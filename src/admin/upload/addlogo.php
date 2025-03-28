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

$path = nv_check_path_upload($nv_Request->get_string('path', 'post,get'));
$check_allow_upload_dir = nv_check_allow_upload_dir($path);

if (!isset($check_allow_upload_dir['delete_file'])) {
    nv_jsonOutput([
        'status' => 'error',
        'mess' => $nv_Lang->getModule('notlevel')
    ]);
}

$file = htmlspecialchars(trim($nv_Request->get_string('file', 'post,get')), ENT_QUOTES);
$file = basename($file);

if (empty($file)) {
    nv_jsonOutput([
        'status' => 'error',
        'mess' => $nv_Lang->getModule('errorNotSelectFile')
    ]);
}
if (!nv_is_file(NV_BASE_SITEURL . $path . '/' . $file, $path)) {
    nv_jsonOutput([
        'status' => 'error',
        'mess' => $nv_Lang->getModule('file_no_exists')
    ]);
}

if ($nv_Request->isset_request('path', 'post') and $nv_Request->isset_request('x', 'post') and $nv_Request->isset_request('y', 'post')) {
    if (file_exists(NV_ROOTDIR . '/' . $global_config['upload_logo'])) {
        $upload_logo = NV_ROOTDIR . '/' . $global_config['upload_logo'];
    } else {
        nv_jsonOutput([
            'status' => 'error',
            'mess' => $nv_Lang->getModule('notlogo')
        ]);
    }

    $config_logo = [];
    $config_logo['x'] = $nv_Request->get_int('x', 'post', 0);
    $config_logo['y'] = $nv_Request->get_int('y', 'post', 0);
    $config_logo['w'] = $nv_Request->get_int('w', 'post', 0);
    $config_logo['h'] = $nv_Request->get_int('h', 'post', 0);

    if ($config_logo['w'] > 0 and $config_logo['h'] > 0) {
        if (isset($array_thumb_config[$path])) {
            $thumb_config = $array_thumb_config[$path];
        } else {
            $thumb_config = $array_thumb_config[''];
            $_arr_path = explode('/', $path);
            while (count($_arr_path) > 1) {
                array_pop($_arr_path);
                $_path = implode('/', $_arr_path);
                if (isset($array_thumb_config[$_path])) {
                    $thumb_config = $array_thumb_config[$_path];
                    break;
                }
            }
        }

        $createImage = new NukeViet\Files\Image(NV_ROOTDIR . '/' . $path . '/' . $file, NV_MAX_WIDTH, NV_MAX_HEIGHT);
        $createImage->addlogo($upload_logo, '', '', $config_logo);
        $createImage->save(NV_ROOTDIR . '/' . $path, $file, $thumb_config['thumb_quality']);
        $createImage->close();

        if (isset($array_dirname[$path])) {
            if (preg_match('/^' . nv_preg_quote(NV_UPLOADS_DIR) . '\/(([a-z0-9\-\_\/]+\/)*([a-z0-9\-\_\.]+)(\.(gif|jpg|jpeg|png|bmp|webp)))$/i', $path . '/' . $file, $m)) {
                @nv_deletefile(NV_ROOTDIR . '/' . NV_FILES_DIR . '/' . $m[1]);
                @nv_deletefile(NV_ROOTDIR . '/' . NV_MOBILE_FILES_DIR . '/' . $m[1]);
            }

            $info = nv_getFileInfo($path, $file);

            $did = $array_dirname[$path];
            $db->query('UPDATE ' . NV_UPLOAD_GLOBALTABLE . '_file SET filesize=' . $info['filesize'] . ", src='" . $info['src'] . "', srcwidth=" . $info['srcwidth'] . ', srcheight=' . $info['srcheight'] . ", sizes='" . $info['size'] . "', userid=" . $admin_info['userid'] . ', mtime=' . $info['mtime'] . ' WHERE did = ' . $did . " AND title = '" . $file . "'");
            nv_dirListRefreshSize();
        }

        nv_jsonOutput([
            'status' => 'success',
            'name' => basename($file)
        ]);
    }
}

nv_jsonOutput([
    'status' => 'error',
    'mess' => 'Error Access!!'
]);
