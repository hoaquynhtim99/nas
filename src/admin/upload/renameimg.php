<?php

/**
 * NukeViet Content Management System
 * @version 5.x
 * @author VINADES.,JSC <contact@vinades.vn>
 * @copyright (C) 2009-2025 VINADES.,JSC. All rights reserved
 * @license GNU/GPL version 2 or any later version
 * @see https://github.com/nukeviet The NukeViet CMS GitHub project
 */

if (!defined('NV_IS_FILE_ADMIN')) {
    exit('Stop!!!');
}

if ($nv_Request->get_title('checkss', 'post', '') !== NV_CHECK_SESSION) {
    nv_jsonOutput([
        'status' => 'error',
        'mess' => 'Error session!!!'
    ]);
}

$path = nv_check_path_upload($nv_Request->get_string('path', 'post'));
$check_allow_upload_dir = nv_check_allow_upload_dir($path);

if (!isset($check_allow_upload_dir['rename_file'])) {
    nv_jsonOutput([
        'status' => 'error',
        'mess' => $nv_Lang->getModule('notlevel')
    ]);
}

$file = htmlspecialchars(trim($nv_Request->get_string('file', 'post')), ENT_QUOTES);
$file = basename($file);

if (empty($file) or !nv_is_file(NV_BASE_SITEURL . $path . '/' . $file, $path)) {
    nv_jsonOutput([
        'status' => 'error',
        'mess' => $nv_Lang->getModule('errorNotSelectFile')
    ]);
}

$newname = htmlspecialchars(trim($nv_Request->get_string('newname', 'post')), ENT_QUOTES);
$newname = nv_string_to_filename(basename($newname));

if (empty($newname)) {
    nv_jsonOutput([
        'status' => 'error',
        'input' => 'newname',
        'mess' => $nv_Lang->getModule('rename_noname')
    ]);
}

$newalt = $nv_Request->get_title('newalt', 'post', $newname, 1);
if (empty($newalt)) {
    nv_jsonOutput([
        'status' => 'error',
        'input' => 'newalt',
        'mess' => $nv_Lang->getModule('upload_alt_note')
    ]);
}

$ext = nv_getextension($file);
$newname = $newname . '.' . $ext;
if ($file != $newname) {
    $newname2 = $newname;

    $i = 1;
    while (file_exists(NV_ROOTDIR . '/' . $path . '/' . $newname2)) {
        $newname2 = preg_replace('/(.*)(\.[a-zA-Z0-9]+)$/', '\1_' . $i . '\2', $newname);
        ++$i;
    }

    $newname = $newname2;
    if (!@rename(NV_ROOTDIR . '/' . $path . '/' . $file, NV_ROOTDIR . '/' . $path . '/' . $newname)) {
        nv_jsonOutput([
            'status' => 'error',
            'mess' => $nv_Lang->getModule('errorNotRenameFile')
        ]);
    }

    if (preg_match('/^' . nv_preg_quote(NV_UPLOADS_DIR) . '\/(([a-z0-9\-\_\/]+\/)*([a-z0-9\-\_\.]+)(\.(gif|jpg|jpeg|png|bmp|webp)))$/i', $path . '/' . $file, $m)) {
        @nv_deletefile(NV_ROOTDIR . '/' . NV_FILES_DIR . '/' . $m[1]);
        @nv_deletefile(NV_ROOTDIR . '/' . NV_MOBILE_FILES_DIR . '/' . $m[1]);
    }
    if (isset($array_dirname[$path])) {
        $info = nv_getFileInfo($path, $newname);

        $sth = $db->prepare('UPDATE ' . NV_UPLOAD_GLOBALTABLE . "_file SET name = '" . $info['name'] . "', src = '" . $info['src'] . "', title = '" . $newname . "', alt = :newalt WHERE did = " . $array_dirname[$path] . " AND title = '" . $file . "'");
        $sth->bindParam(':newalt', $newalt, PDO::PARAM_STR);
        $sth->execute();
    }
    nv_insert_logs(NV_LANG_DATA, $module_name, $nv_Lang->getModule('rename'), $path . '/' . $file . ' -> ' . $path . '/' . $newname, $admin_info['userid']);
} else {
    $sth = $db->prepare('UPDATE ' . NV_UPLOAD_GLOBALTABLE . '_file SET alt = :newalt WHERE did = ' . $array_dirname[$path] . " AND title = '" . $file . "'");
    $sth->bindParam(':newalt', $newalt, PDO::PARAM_STR);
    $sth->execute();

    nv_insert_logs(NV_LANG_DATA, $module_name, $nv_Lang->getModule('rename'), $path . '/' . $file . ' -> ' . $path . '/' . $newname, $admin_info['userid']);
}
nv_dirListRefreshSize();
nv_jsonOutput([
    'status' => 'success',
    'name' => $newname
]);
