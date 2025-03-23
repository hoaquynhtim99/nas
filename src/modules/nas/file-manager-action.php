<?php

/**
 * NukeViet Content Management System
 * @version 4.x
 * @author VINADES.,JSC <contact@vinades.vn>
 * @copyright (C) 2009-2021 VINADES.,JSC. All rights reserved
 * @license GNU/GPL version 2 or any later version
 * @see https://github.com/nukeviet The NukeViet CMS GitHub project
 */

if (!defined('NV_IS_MOD_NAS')) {
    exit('Stop!!!');
}

use NukeViet\Module\nas\Shared\Nodes;
use NukeViet\Module\nas\Shared\Mimes;
use NukeViet\Module\nas\Shared\GoogleDrives;
use Google\Service\Drive;

// Thêm thư mục mới
if ($nv_Request->isset_request('add_folder', 'post')) {
    $respon = [
        'status' => 'error',
        'mess' => '',
    ];
    if ($nv_Request->get_title('checkss', 'post', '') != NV_CHECK_SESSION) {
        $respon['mess'] = 'Wrong session!!!';
        nv_jsonOutput($respon);
    }

    // Tạo các thư mục cần thiết
    [$error, $root_dir] = initUserDir();
    if (!empty($error)) {
        $respon['mess'] = $error;
        nv_jsonOutput($respon);
    }
    $root_dir = NAS_DIR . '/' . $root_dir;

    // Thư mục cha
    $folder_id = $nv_Request->get_absint('folder_id', 'post', 0);
    if ($folder_id and !isset($array_folders[$folder_id])) {
        $respon['mess'] = $nv_Lang->getModule('createdir_err_parent');
        nv_jsonOutput($respon);
    }

    $title = nv_substr($nv_Request->get_title('title', 'post', ''), 0, 100);
    if (empty($title)) {
        $respon['input'] = 'title';
        $respon['mess'] = $nv_Lang->getGlobal('required_invalid');
        nv_jsonOutput($respon);
    }

    // Kiểm tra tên hợp lệ
    $alias = strtolower(change_alias($title));
    if (empty($alias)) {
        $respon['input'] = 'title';
        $respon['mess'] = $nv_Lang->getModule('createdir_error_namerule');
        nv_jsonOutput($respon);
    }

    // Tạo ra liên kết tĩnh không trùng trong CSDL lẫn trên thư mục
    if ($folder_id) {
        $root_dir .= '/' . $array_folders[$folder_id]['path'];
    }
    $alias = getUniqueName($alias, '', $root_dir);
    if ($folder_id) {
        $path = $array_folders[$folder_id]['path'] . '/' . $alias;
    } else {
        $path = $alias;
    }

    // Kiểm tra tên trùng
    if (checkTitleExists($title, $folder_id)) {
        $respon['input'] = 'title';
        $respon['mess'] = $nv_Lang->getModule('createdir_err_exists');
        nv_jsonOutput($respon);
    }

    // Chỗ này sắp tùy chỉnh, hiện tại đang sắp theo tên thư mục
    //$sql = "SELECT MAX(weight) weight FROM " . NV_PREFIXLANG . "_" . $module_data . "_nodes WHERE
    //parentid=" . $folder_id . " AND userid=" . $user_info['userid'] . " AND node_type=1";
    //$weight = intval($db->query($sql)->fetchColumn()) + 1;
    $weight = 0;

    $db->beginTransaction();
    try {
        $sql = "INSERT INTO " . NV_PREFIXLANG . "_" . $module_data . "_nodes (
            parentid, userid, node_type, add_time, edit_time, title, alias, path, weight
        ) VALUES (
            " . $folder_id . ", " . $user_info['userid'] . ", 1, " . NV_CURRENTTIME . ", " . NV_CURRENTTIME . ",
            " . $db->quote($title) . ", " . $db->quote($alias) . ", " . $db->quote($path) . ", " . $weight . "
        )";
        $db->query($sql);
        $folder_id_new = $db->lastInsertId();
        if (empty($folder_id_new)) {
            throw new Exception('Error save to DB!');
        }

        $sql = "INSERT INTO " . NV_PREFIXLANG . "_" . $module_data . "_nodes_refs (node_id) VALUES (" . $folder_id_new . ")";
        $db->query($sql);

        mkdir($root_dir . '/' . $alias, 0755);

        $db->commit();
    } catch (Throwable $e) {
        if (is_dir($root_dir . '/' . $alias)) {
            rmdir($root_dir . '/' . $alias);
        }
        $db->rollBack();
        trigger_error(print_r($e, true));
    }

    Nodes::syncFoldersOrder();

    $respon['status'] = 'success';
    $respon['mess'] = $nv_Lang->getGlobal('save_success');
    $respon['redirect'] = nv_url_rewrite(NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=' . $op . '&folder_id=' . $folder_id_new, true);
    nv_jsonOutput($respon);
}

// Upload tập tin từ internet
if ($nv_Request->isset_request('upload_remote', 'post')) {
    $respon = [
        'status' => 'error',
        'mess' => '',
    ];
    if ($nv_Request->get_title('checkss', 'post', '') != NV_CHECK_SESSION) {
        $respon['mess'] = 'Wrong session!!!';
        nv_jsonOutput($respon);
    }

    // Tạo các thư mục cần thiết
    [$error, $user_dir] = initUserDir();
    if (!empty($error)) {
        $respon['mess'] = $error;
        nv_jsonOutput($respon);
    }
    $root_dir = NAS_DIR . '/' . $user_dir;
    $path_save = '';

    // Kiểm tra quota trước khi upload
    if ($nas_user['quota_percent'] >= 100) {
        $respon['mess'] = $nv_Lang->getModule('upload_error_quota');
        nv_jsonOutput($respon);
    }

    // Thư mục cha
    $folder_id = $nv_Request->get_absint('folder_id', 'post', 0);
    if ($folder_id and !isset($array_folders[$folder_id])) {
        $respon['mess'] = $nv_Lang->getModule('createdir_err_parent');
        nv_jsonOutput($respon);
    }
    if ($folder_id) {
        $root_dir .= '/' . $array_folders[$folder_id]['path'];
        $path_save = $array_folders[$folder_id]['path'];
    }

    $url = $nv_Request->get_string('url', 'post', '', true, false);
    if (empty($url)) {
        $respon['input'] = 'url';
        $respon['mess'] = $nv_Lang->getGlobal('required_invalid');
        nv_jsonOutput($respon);
    }
    $title = nv_substr($nv_Request->get_title('title', 'post', ''), 0, 200);
    if (!empty($title) and checkTitleExists($title, $folder_id)) {
        // Nếu nhập tên, kiểm tra luôn tên phải không được trùng còn khi xác định tự động thì trùng cũng được
        $respon['input'] = 'title';
        $respon['mess'] = $nv_Lang->getModule('createdir_err_exists');
        nv_jsonOutput($respon);
    }

    // Xây dựng trình upload
    $sys_max_size = $sys_max_size_local = min($global_config['nv_max_size'], nv_converttoBytes(ini_get('upload_max_filesize')), nv_converttoBytes(ini_get('post_max_size')));
    if ($global_config['nv_overflow_size'] > $sys_max_size and $global_config['upload_chunk_size'] > 0) {
        $sys_max_size_local = $global_config['nv_overflow_size'];
    }
    $upload = new NukeViet\Files\Upload(['any'], $global_config['forbid_extensions'], $global_config['forbid_mimes'], [$sys_max_size, $sys_max_size_local], NV_MAX_WIDTH, NV_MAX_HEIGHT);
    $upload->setLanguage(\NukeViet\Core\Language::$lang_global);

    // Upload lên
    $upload_info = $upload->save_urlfile($url, $root_dir, false, $global_config['nv_auto_resize']);
    if (!empty($upload_info['error'])) {
        $respon['mess'] = $upload_info['error'];
        nv_jsonOutput($respon);
    }

    // Kiểm tra dung lượng sau upload
    if ($upload_info['size'] > $sys_max_size) {
        if (file_exists($upload_info['name'])) {
            unlink($upload_info['name']);
        }
        $respon['mess'] = $nv_Lang->getGlobal('error_upload_max_user_size', nv_convertfromBytes($sys_max_size));;
        nv_jsonOutput($respon);
    }
    // Kiểm tra quota sau khi upload
    if ($nas_user['quota_limit'] > 0 and (($nas_user['quota_current'] + $upload_info['size']) > $nas_user['quota_limit'])) {
        if (file_exists($upload_info['name'])) {
            unlink($upload_info['name']);
        }
        $respon['mess'] = $nv_Lang->getModule('upload_error_quota');
        nv_jsonOutput($respon);
    }

    $save_info = [];
    $save_info['thumb'] = 0;
    if (empty($title)) {
        $title = preg_replace('/\.([a-zA-Z0-9\-\_]+)$/i', '', $upload_info['basename']);
    }
    $save_info['alias'] = $upload_info['basename'];
    $save_info['path'] = (!empty($path_save) ? ($path_save . '/') : '') . $upload_info['basename'];
    $save_info['image_width'] = 0;
    $save_info['image_height'] = 0;
    if (!empty($upload_info['img_info'])) {
        $save_info['image_width'] = $upload_info['img_info'][0] ?? 0;
        $save_info['image_height'] = $upload_info['img_info'][1] ?? 0;
    }

    // Tạo ảnh thumb nếu như là ảnh
    if (!empty($upload_info['is_img']) and empty($upload_info['is_svg'])) {
        $save_info['thumb'] = makeThumb($upload_info['name']);
    }

    // Lưu vào CSDL
    $db->beginTransaction();
    try {
        $sql = "INSERT INTO " . NV_PREFIXLANG . "_" . $module_data . "_nodes (
            parentid, userid, node_type, add_time, edit_time, title, alias, path, weight,
            node_size, node_mime, node_ext, image_width, image_height, thumb
        ) VALUES (
            " . $folder_id . ", " . $user_info['userid'] . ", 0, " . NV_CURRENTTIME . ", " . NV_CURRENTTIME . ",
            " . $db->quote($title) . ", " . $db->quote($save_info['alias']) . ", " . $db->quote($save_info['path']) . ", 0,
            " . $upload_info['size'] . ", " . $db->quote($upload_info['mime']) . ", " . $db->quote(nv_strtolower($upload_info['ext'])) . ",
            " . $save_info['image_width'] . ", " . $save_info['image_height'] . ", " . $save_info['thumb'] . "
        )";
        $db->query($sql);
        $folder_id_new = $db->lastInsertId();
        if (empty($folder_id_new)) {
            throw new Exception('Error save to DB!');
        }

        $sql = "INSERT INTO " . NV_PREFIXLANG . "_" . $module_data . "_nodes_refs (node_id) VALUES (" . $folder_id_new . ")";
        $db->query($sql);

        // Cập nhật quota của user
        $sql = "UPDATE " . NV_PREFIXLANG . "_" . $module_data . "_users SET quota_current=quota_current+" . $upload_info['size'] . " WHERE userid=" . $user_info['userid'];
        $db->query($sql);

        // Cập nhật dung lượng của các thư mục nó và cha của nó
        if (!empty($folder_id)) {
            $folder_ids = getParentDirs($folder_id, $array_folders);
            $sql = "UPDATE " . NV_PREFIXLANG . "_" . $module_data . "_nodes SET
                node_size=node_size+" . $upload_info['size'] . "
            WHERE id IN(" . implode(',', $folder_ids) . ")";
            $db->query($sql);
        }

        $db->commit();
    } catch (Throwable $e) {
        if (file_exists($upload_info['name'])) {
            unlink($upload_info['name']);
        }
        $db->rollBack();
        trigger_error(print_r($e, true));

        $respon['mess'] = $e->getMessage();
        nv_jsonOutput($respon);
    }

    $redirect = NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=' . $op;
    if (!empty($folder_id)) {
        $redirect .= '&folder_id=' . $folder_id;
    }
    $redirect .= '&sort=add_desc';

    $respon['status'] = 'success';
    $respon['mess'] = $nv_Lang->getGlobal('save_success');
    $respon['redirect'] = nv_url_rewrite($redirect, true);
    nv_jsonOutput($respon);
}

// Upload file local
if ($nv_Request->isset_request('upload_file', 'post')) {
    // Trong này phải dùng http_response_code để khiển plupload dừng khi lỗi để nó không tiếp tục upload các chunk
    if ($nv_Request->get_title('checkss', 'post', '') != NV_CHECK_SESSION) {
        http_response_code(400);
        nv_jsonOutput([
            'success' => 0,
            'text' => 'Wrong session!!!'
        ]);
    }

    // Nocache
    header('Expires: Mon, 26 Jul 1997 05:00:00 GMT');
    header('Last-Modified: ' . gmdate('D, d M Y H:i:s') . ' GMT');
    header('Cache-Control: no-store, no-cache, must-revalidate');
    header('Cache-Control: post-check=0, pre-check=0', false);
    header('Pragma: no-cache');

    $request = [];
    $request['folder_id'] = $nv_Request->get_absint('folder_id', 'post', 0);
    $request['name'] = preg_replace('/\.([a-z0-9\_]+)$/i', '', $nv_Request->get_title('name', 'post', ''));
    $request['basename'] = nv_string_to_filename($nv_Request->get_title('name', 'post', ''));
    $request['ext'] = nv_getextension($request['basename']);
    $request['alias'] = preg_replace('/\.([a-z0-9\_]+)$/i', '', $request['basename']);
    $request['chunk'] = $nv_Request->get_absint('chunk', 'post', 0);
    $request['chunks'] = $nv_Request->get_absint('chunks', 'post', 0);
    $request['upload_size'] = $nv_Request->get_absint('upload_size', 'post', 0);
    $request['upload_time'] = $nv_Request->get_absint('upload_time', 'post', 0);

    $sys_max_size = $sys_max_size_local = min($global_config['nv_max_size'], nv_converttoBytes(ini_get('upload_max_filesize')), nv_converttoBytes(ini_get('post_max_size')));
    if ($global_config['nv_overflow_size'] > $sys_max_size and $global_config['upload_chunk_size'] > 0) {
        $sys_max_size_local = $global_config['nv_overflow_size'];
    }

    /**
     * Các thao tác kiểm tra cơ bản dựa trên PHPUpload
     */

    // Cơ bản của biến fileupload
    if (!isset($_FILES, $_FILES['fileupload'], $_FILES['fileupload']['tmp_name']) or !is_uploaded_file($_FILES['fileupload']['tmp_name']) or !file_exists($_FILES['fileupload']['tmp_name'])) {
        http_response_code(400);
        nv_jsonOutput([
            'success' => 0,
            'text' => $nv_Lang->getModule('upload_error_nofile')
        ]);
    }
    // Xác định kích thước
    if (empty($_FILES['fileupload']['size']) or empty($request['upload_size'])) {
        unlink($_FILES['fileupload']['tmp_name']);
        http_response_code(400);
        nv_jsonOutput([
            'success' => 0,
            'text' => $nv_Lang->getModule('upload_error_size')
        ]);
    }
    // Kích thước giới hạn
    if ($_FILES['fileupload']['size'] > $sys_max_size_local or $request['upload_size'] > $sys_max_size_local) {
        unlink($_FILES['fileupload']['tmp_name']);
        http_response_code(406);
        nv_jsonOutput([
            'success' => 0,
            'text' => $nv_Lang->getModule('upload_error_oversize1')
        ]);
    }
    // Lỗi từ PHP
    if (!isset($_FILES['fileupload']['error']) or $_FILES['fileupload']['error'] != UPLOAD_ERR_OK) {
        switch ($_FILES['fileupload']['error']) {
            case UPLOAD_ERR_INI_SIZE:
                $er = $nv_Lang->getGlobal('error_upload_ini_size');
                break;
            case UPLOAD_ERR_FORM_SIZE:
                $er = $nv_Lang->getGlobal('error_upload_form_size');
                break;
            case UPLOAD_ERR_PARTIAL:
                $er = $nv_Lang->getGlobal('error_upload_partial');
                break;
            case UPLOAD_ERR_NO_FILE:
                $er = $nv_Lang->getGlobal('error_upload_no_file');

                break;
            case UPLOAD_ERR_NO_TMP_DIR:
                $er = $nv_Lang->getGlobal('error_upload_no_tmp_dir');
                break;
            case UPLOAD_ERR_CANT_WRITE:
                $er = $nv_Lang->getGlobal('error_upload_cant_write');
                break;
            case UPLOAD_ERR_EXTENSION:
                $er = $nv_Lang->getGlobal('error_upload_extension');
                break;
            default:
                $er = $nv_Lang->getGlobal('error_upload_unknown');
        }

        unlink($_FILES['fileupload']['tmp_name']);
        http_response_code(406);
        nv_jsonOutput([
            'success' => 0,
            'text' => $er
        ]);
    }

    // Kiểm tra thư mục cha
    if ($request['folder_id'] and !isset($array_folders[$request['folder_id']])) {
        unlink($_FILES['fileupload']['tmp_name']);
        http_response_code(406);
        nv_jsonOutput([
            'success' => 0,
            'text' => $nv_Lang->getModule('createdir_err_parent')
        ]);
    }
    // Kiểm tra dữ liệu chunks
    if ($request['chunks'] > 0 and $request['chunk'] > $request['chunks'] - 1) {
        unlink($_FILES['fileupload']['tmp_name']);
        http_response_code(400);
        nv_jsonOutput([
            'success' => 0,
            'text' => 'Chunk data wrong!!!'
        ]);
    }
    // Kiểm tra chunk so với cấu hình cho phép chunk
    if ($global_config['upload_chunk_size'] > 0 and $request['chunks'] < 1) {
        unlink($_FILES['fileupload']['tmp_name']);
        http_response_code(400);
        nv_jsonOutput([
            'success' => 0,
            'text' => 'Missing chunks!!!'
        ]);
    }
    // Kiểm tra tên tệp tin gửi lên
    if (empty($request['name']) or empty($request['basename']) or empty($request['alias'])) {
        unlink($_FILES['fileupload']['tmp_name']);
        http_response_code(400);
        nv_jsonOutput([
            'success' => 0,
            'text' => $nv_Lang->getModule('upload_error_name')
        ]);
    }
    // Kiểm tra phần mở rộng của tên tệp tin gửi lên
    if (empty($request['ext'])) {
        unlink($_FILES['fileupload']['tmp_name']);
        http_response_code(400);
        nv_jsonOutput([
            'success' => 0,
            'text' => $nv_Lang->getGlobal('error_upload_mime_not_recognize')
        ]);
    }
    // Kiểm tra quota trước khi upload
    if ($nas_user['quota_percent'] >= 100) {
        unlink($_FILES['fileupload']['tmp_name']);
        http_response_code(405);
        nv_jsonOutput([
            'success' => 0,
            'text' => $nv_Lang->getModule('upload_error_quota')
        ]);
    }
    // Kiểm tra quota sau khi cộng file này vào
    if ($nas_user['quota_limit'] > 0 and (($nas_user['quota_current'] + $_FILES['fileupload']['size']) > $nas_user['quota_limit'] or ($nas_user['quota_current'] + $request['upload_size']) > $nas_user['quota_limit'])) {
        unlink($_FILES['fileupload']['tmp_name']);
        http_response_code(406);
        nv_jsonOutput([
            'success' => 0,
            'text' => $nv_Lang->getModule('upload_error_quota')
        ]);
    }
    // Thiếu time hoặc time quá 1 ngày
    if (empty($request['upload_time']) or (NV_CURRENTTIME - $request['upload_time']) > 86400) {
        unlink($_FILES['fileupload']['tmp_name']);
        http_response_code(403);
        nv_jsonOutput([
            'success' => 0,
            'text' => 'Missing time or timeout!!!'
        ]);
    }

    // Tạo các thư mục cần thiết
    [$error, $user_dir] = initUserDir();
    if (!empty($error)) {
        unlink($_FILES['fileupload']['tmp_name']);
        http_response_code(500);
        nv_jsonOutput([
            'success' => 0,
            'text' => $error
        ]);
    }
    $root_dir = NAS_DIR . '/' . $user_dir;
    $path_save = '';

    if ($request['folder_id']) {
        $root_dir .= '/' . $array_folders[$request['folder_id']]['path'];
        $path_save = $array_folders[$request['folder_id']]['path'];
    }

    // md5 tên tập tin, dung lượng tập tin, thời gian upload, thư mục, session => UNIQUE để check
    $uniqid = md5($request['name'] . $request['upload_size'] . $request['upload_time'] . $request['folder_id'] . NV_CHECK_SESSION);

    $sql = "SELECT * FROM " . NV_PREFIXLANG . "_" . $module_data . "_nodes WHERE userid=" . $user_info['userid'] . "
    AND node_type=0 AND is_tmp=" . $request['upload_time'] . " AND uniqid=" . $db->quote($uniqid);
    $current_upload = $db->query($sql)->fetch();
    if (!empty($current_upload)) {
        $request['alias'] = $current_upload['alias'];
        $request['relative_path'] = $current_upload['path'];
        $request['full_path'] = NAS_DIR . '/' . $user_dir . '/' . $current_upload['path'];
        $node_id = $current_upload['id'];
    } else {
        // Xác định tên file tải lên
        $request['alias'] = getUniqueName($request['alias'], $request['ext'], $root_dir);
        $request['relative_path'] = $request['alias'];
        if (!empty($path_save)) {
            $request['relative_path'] = $path_save . '/' . $request['relative_path'];
        }
        $request['full_path'] = $root_dir . '/' . $request['alias'];

        // Lưu ngay vào CSDL dưới dạng file tạm và tải lên sau
        $db->beginTransaction();
        try {
            $sql = "INSERT INTO " . NV_PREFIXLANG . "_" . $module_data . "_nodes (
                parentid, userid, node_type, add_time, edit_time, title, alias, path, node_size, node_ext, is_tmp, uniqid
            ) VALUES (
                " . $request['folder_id'] . ", " . $user_info['userid'] . ", 0, " . NV_CURRENTTIME . ", " . NV_CURRENTTIME . ",
                " . $db->quote($request['name']) . ", " . $db->quote($request['alias']) . ", " . $db->quote($request['relative_path']) . ",
                " . $request['upload_size'] . ", " . $db->quote($request['ext']) . ", " . $request['upload_time'] . ",
                " . $db->quote($uniqid) . "
            )";
            $db->query($sql);
            $node_id = $db->lastInsertId();
            if (empty($node_id)) {
                throw new Exception('Save file error!!!');
            }

            $sql = "INSERT INTO " . NV_PREFIXLANG . "_" . $module_data . "_nodes_refs (node_id) VALUES (" . $node_id . ")";
            $db->query($sql);

            if (file_exists($request['full_path'])) {
                throw new Exception('Error file exists before upload!!!');
            }
            if (!touch($request['full_path'])) {
                throw new Exception('Error touch file to upload!!!');
            }

            $db->commit();
        } catch (Throwable $e) {
            $db->rollBack();
            trigger_error(print_r($e, true));
            unlink($_FILES['fileupload']['tmp_name']);
            http_response_code(500);
            nv_jsonOutput([
                'success' => 0,
                'text' => htmlspecialchars($e->getMessage())
            ]);
        }
    }

    $finish_upload = 0;

    if ($global_config['upload_chunk_size'] > 0 and $request['chunks'] > 1) {
        // Upload từng phần
        if ($request['chunk'] == 0) {
            unlink($request['full_path']);
        }

        $fpOut = fopen($request['full_path'], $request['chunk'] == 0 ? 'wb' : 'ab');
        if (!$fpOut) {
            unlink($_FILES['fileupload']['tmp_name']);
            http_response_code(500);
            nv_jsonOutput([
                'success' => 0,
                'text' => $nv_Lang->getGlobal('error_upload_no_tmp_dir')
            ]);
        }
        $fpIn = fopen($_FILES['fileupload']['tmp_name'], 'rb');
        if (!$fpIn) {
            fclose($fpOut);
            unlink($_FILES['fileupload']['tmp_name']);
            http_response_code(500);
            nv_jsonOutput([
                'success' => 0,
                'text' => $nv_Lang->getModule('upload_error_readtmp')
            ]);
        }
        while ($buff = fread($fpIn, 4096)) {
            fwrite($fpOut, $buff);
        }
        fclose($fpIn);
        fclose($fpOut);

        if ($request['chunk'] >= $request['chunks'] - 1) {
            $finish_upload = 1;

            $request['mime'] = Mimes::get($request['full_path']);
            if (empty($request['mime'])) {
                unlink($_FILES['fileupload']['tmp_name']);
                unlink($request['full_path']);
                http_response_code(403);
                nv_jsonOutput([
                    'success' => 0,
                    'text' => $nv_Lang->getGlobal('error_upload_mime_not_recognize')
                ]);
            }
        }
    } else {
        $finish_upload = 1;

        // Upload 1 lần (nếu không chunk hoặc file tải lên kích thước bé hơn chunk)
        $request['mime'] = Mimes::get($_FILES['fileupload']['tmp_name']);
        if (empty($request['mime'])) {
            unlink($_FILES['fileupload']['tmp_name']);
            http_response_code(403);
            nv_jsonOutput([
                'success' => 0,
                'text' => $nv_Lang->getGlobal('error_upload_mime_not_recognize')
            ]);
        }

        // Chép
        if (!@copy($_FILES['fileupload']['tmp_name'], $request['full_path'])) {
            @move_uploaded_file($_FILES['fileupload']['tmp_name'], $request['full_path']);
        }

        if (!file_exists($request['full_path']) or !filesize($request['full_path'])) {
            file_exists($_FILES['fileupload']['tmp_name']) && unlink($_FILES['fileupload']['tmp_name']);
            http_response_code(500);
            nv_jsonOutput([
                'success' => 0,
                'text' => $nv_Lang->getGlobal('error_upload_cant_write')
            ]);
        }
    }

    if ($finish_upload) {
        // Sau khi upload thành công kiểm tra một số việc như tạo ảnh thumb, check phải là ảnh không, kích thước ảnh như thế nào

        // Đối chiếu dung lượng post và thực tế trong ổ đĩa
        if ($request['upload_size'] != filesize($request['full_path'])) {
            file_exists($_FILES['fileupload']['tmp_name']) && unlink($_FILES['fileupload']['tmp_name']);
            unlink($request['full_path']);
            http_response_code(403);
            nv_jsonOutput([
                'success' => 0,
                'text' => $nv_Lang->getModule('upload_error_size1')
            ]);
        }

        $request['thumb'] = 0;
        $request['image_width'] = 0;
        $request['image_height'] = 0;

        if (preg_match('#image\/[x\-]*([a-z]+)#', $request['mime'])) {
            $img_info = @getimagesize($request['full_path']);
            if (isset($img_info[1]) and is_numeric($img_info[0]) and is_numeric($img_info[1])) {
                $request['image_width'] = intval($img_info[0]);
                $request['image_height'] = intval($img_info[1]);
                $request['thumb'] = makeThumb($request['full_path']);
            }
        }

        // Cuối cùng cập nhật lại tệp đã lưu tạm và các thông số khác
        // Lưu vào CSDL
        $db->beginTransaction();
        try {
            $sql = "UPDATE " . NV_PREFIXLANG . "_" . $module_data . "_nodes SET
                node_mime=" . $db->quote($request['mime']) . ",
                image_width=" . $request['image_width'] . ",
                image_height=" . $request['image_height'] . ",
                thumb=" . $request['thumb'] . ",
                is_tmp=0, uniqid=''
            WHERE id=" . $node_id;
            $db->query($sql);

            // Cập nhật quota của user
            $sql = "UPDATE " . NV_PREFIXLANG . "_" . $module_data . "_users SET quota_current=quota_current+" . $request['upload_size'] . " WHERE userid=" . $user_info['userid'];
            $db->query($sql);

            // Cập nhật dung lượng của các thư mục nó và cha của nó
            if (!empty($request['folder_id'])) {
                $folder_ids = getParentDirs($request['folder_id'], $array_folders);
                $sql = "UPDATE " . NV_PREFIXLANG . "_" . $module_data . "_nodes SET
                    node_size=node_size+" . $request['upload_size'] . "
                WHERE id IN(" . implode(',', $folder_ids) . ")";
                $db->query($sql);
            }

            $db->commit();
        } catch (Throwable $e) {
            $db->rollBack();
            trigger_error(print_r($e, true));
            file_exists($_FILES['fileupload']['tmp_name']) && unlink($_FILES['fileupload']['tmp_name']);
            unlink($request['full_path']);
            http_response_code(500);
            nv_jsonOutput([
                'success' => 0,
                'text' => htmlspecialchars($e->getMessage())
            ]);
        }

        $link = NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=' . $op;
        if (!empty($request['folder_id'])) {
            $link .= '&folder_id=' . $request['folder_id'];
        }
        $link .= '&sort=add_desc&highlight=' . $node_id;
        $link = nv_url_rewrite($link, true);
    } else {
        $link = '';
    }

    file_exists($_FILES['fileupload']['tmp_name']) && unlink($_FILES['fileupload']['tmp_name']);
    nv_jsonOutput([
        'success' => 1,
        'link' => $link,
        'text' => ''
    ]);
}

// Đổi tên tệp tin/thư mục
if ($nv_Request->isset_request('rename_node', 'post')) {
    $respon = [
        'status' => 'error',
        'mess' => '',
    ];
    if ($nv_Request->get_title('checkss', 'post', '') != NV_CHECK_SESSION) {
        $respon['mess'] = 'Wrong session!!!';
        nv_jsonOutput($respon);
    }

    $id = $nv_Request->get_absint('id', 'post', 0);

    // Lấy và kiểm tra node
    $sql = "SELECT * FROM " . NV_PREFIXLANG . "_" . $module_data . "_nodes WHERE
    userid=" . $user_info['userid'] . " AND id=" . $id . " AND trash=0 AND trash_parent=0 AND is_tmp=0";
    $node = $db->query($sql)->fetch();
    if (empty($node)) {
        $respon['mess'] = 'File/folder not exists!!!';
        nv_jsonOutput($respon);
    }

    $new_name = nv_substr($nv_Request->get_title('new_name', 'post', ''), 0, 100);
    if (empty($new_name)) {
        $respon['input'] = 'new_name';
        $respon['mess'] = $nv_Lang->getModule('rename_error_empty');
        nv_jsonOutput($respon);
    }
    if ($new_name == $node['title']) {
        $respon['input'] = 'new_name';
        $respon['mess'] = $nv_Lang->getModule('rename_error_same');
        nv_jsonOutput($respon);
    }

    // Kiểm tra tên hợp lệ
    $alias = strtolower(change_alias($new_name));
    if (empty($alias)) {
        $respon['input'] = 'new_name';
        $respon['mess'] = $nv_Lang->getModule('createdir_error_namerule');
        nv_jsonOutput($respon);
    }
    // Kiểm tra tên trùng
    if (checkTitleExists($new_name, $node['parentid'])) {
        $respon['input'] = 'new_name';
        $respon['mess'] = $nv_Lang->getModule('createdir_err_exists');
        nv_jsonOutput($respon);
    }

    $root_dir = NAS_DIR . '/' . $nas_user['user_dir'];
    $root_assetsdir = NV_ROOTDIR . '/' . NV_FILES_DIR . '/nas-data/' . $nas_user['user_dir'];
    if (!empty($node['parentid'])) {
        $root_dir .= '/' . $array_folders[$node['parentid']]['path'];
        $root_assetsdir .= '/' . $array_folders[$node['parentid']]['path'];
    }

    // Tạo ra liên kết tĩnh không trùng trong CSDL lẫn trên thư mục
    $alias = getUniqueName($alias, $node['node_ext'], $root_dir);

    $fullpath_old = NAS_DIR . '/' . $nas_user['user_dir'] . '/' . $node['path'];
    $fullpath_new = $root_dir . '/' . $alias;

    $fullpath_assets_old = NV_ROOTDIR . '/' . NV_FILES_DIR . '/nas-data/' . $nas_user['user_dir'] . '/' . $node['path'];
    $fullpath_assets_new = $root_assetsdir . '/' . $alias;

    if (file_exists($fullpath_old)) {
        if (!rename($fullpath_old, $fullpath_new)) {
            $respon['mess'] = $nv_Lang->getModule('rename_error_changedir');
            nv_jsonOutput($respon);
        }
    }
    if (file_exists($fullpath_assets_old)) {
        rename($fullpath_assets_old, $fullpath_assets_new);
    }

    $db->beginTransaction();
    try {
        $path_new = substr($fullpath_new, strlen(NAS_DIR . '/' . $nas_user['user_dir'] . '/'));

        // Đổi path chính nó
        $sql = "UPDATE " . NV_PREFIXLANG . "_" . $module_data . "_nodes SET
            rename_time=" . NV_CURRENTTIME . ",
            title=" . $db->quote($new_name) . ",
            alias=" . $db->quote($alias) . ",
            path=" . $db->quote($path_new) . "
        WHERE id=" . $node['id'];
        $db->query($sql);

        // Đổi thư mục/tệp tin trong nó. Xảy ra nếu là thư mục
        if ($node['node_type'] == Nodes::TYPE_FOLDER) {
            $where = [];
            $where[] = "parentid=" . $node['id'];
            if (!empty($node['subcatids'])) {
                $where[] = "parentid IN(" . $node['subcatids'] . ")";
            }

            $pat = $db->quote('^' . preg_replace('/(\.|\*|\+|\?|\[|\]|\^|\$|\\\)/', '\\\\\\1', $node['path'] . '/'));
            $sql = "UPDATE " . NV_PREFIXLANG . "_" . $module_data . "_nodes SET
                path=REGEXP_REPLACE(path, " . $pat . ", " . $db->quote($path_new . '/') . ")
            WHERE " . implode(' OR ', $where);
            $db->query($sql);
        }

        $db->commit();
    } catch (Throwable $e) {
        $db->rollBack();
        trigger_error(print_r($e, true));

        // Rename ngược lại
        if (file_exists($fullpath_assets_new)) {
            rename($fullpath_assets_new, $fullpath_assets_old);
        }
        if (file_exists($fullpath_new)) {
            rename($fullpath_new, $fullpath_old);
        }

        $respon['mess'] = $e->getMessage();
        nv_jsonOutput($respon);
    }

    $respon['status'] = 'success';
    $respon['mess'] = $nv_Lang->getGlobal('save_success');
    $respon['refresh'] = 1;
    nv_jsonOutput($respon);
}

// Thay đổi kiểu hiển thị dạng list/dạng lưới
if ($nv_Request->isset_request('change_view_type', 'post')) {
    if ($nv_Request->get_title('checkss', 'post', '') != NV_CHECK_SESSION) {
        nv_jsonOutput([
            'success' => 0,
            'text' => 'Wrong session!!!'
        ]);
    }

    $view_type = $nv_Request->get_title('change_view_type', 'post', '');
    if (!in_array($view_type, ['list', 'grid'])) {
        nv_jsonOutput([
            'success' => 0,
            'text' => 'Wrong type!!!'
        ]);
    }

    $sql = "INSERT INTO " . NV_PREFIXLANG . "_" . $module_data . "_users_config (
        userid, config_name, config_value
    ) VALUES (
        " . $user_info['userid'] . ", 'view_type', " . $db->quote($view_type) . "
    ) ON DUPLICATE KEY UPDATE config_value=" . $db->quote($view_type);
    $db->query($sql);

    nv_jsonOutput([
        'success' => 1,
        'text' => ''
    ]);
}

// Đánh dấu, bỏ đánh dấu
if ($nv_Request->isset_request('bookmark_file', 'post')) {
    if ($nv_Request->get_title('checkss', 'post', '') != NV_CHECK_SESSION) {
        nv_jsonOutput([
            'success' => 0,
            'text' => 'Wrong session!!!'
        ]);
    }

    $id = $nv_Request->get_absint('bookmark_file', 'post', 0);

    // Lấy và kiểm tra file
    $sql = "SELECT * FROM " . NV_PREFIXLANG . "_" . $module_data . "_nodes WHERE
    userid=" . $user_info['userid'] . " AND id=" . $id . " AND node_type=0 AND trash=0 AND trash_parent=0 AND is_tmp=0";
    $node = $db->query($sql)->fetch();
    if (empty($node)) {
        nv_jsonOutput([
            'success' => 0,
            'text' => 'File not exists!!!'
        ]);
    }

    $bookmarked = $node['bookmarked'] > 0 ? 0 : NV_CURRENTTIME;
    $sql = "UPDATE " . NV_PREFIXLANG . "_" . $module_data . "_nodes SET bookmarked=" . $bookmarked . " WHERE id=" . $id;
    $db->query($sql);

    nv_jsonOutput([
        'success' => 1,
        'text' => '',
        'bookmarked' => $bookmarked
    ]);
}

// Cho vào thùng rác tệp tin/thư mục
if ($nv_Request->isset_request('trash_node', 'post')) {
    if ($nv_Request->get_title('checkss', 'post', '') != NV_CHECK_SESSION) {
        nv_jsonOutput([
            'success' => 0,
            'text' => 'Wrong session!!!'
        ]);
    }

    $ids = $nv_Request->get_title('trash_node', 'post', '');
    $ids = array_filter(array_unique(array_map('intval', explode(',', $ids))));

    $has_folder = [];
    $number = 0;
    foreach ($ids as $id) {
        // Lấy và kiểm tra file/folder
        $sql = "SELECT * FROM " . NV_PREFIXLANG . "_" . $module_data . "_nodes WHERE
        userid=" . $user_info['userid'] . " AND id=" . $id . " AND trash=0 AND trash_parent=0 AND is_tmp=0";
        $node = $db->query($sql)->fetch();
        if (empty($node)) {
            continue;
        }
        $number++;

        $db->beginTransaction();
        try {
            if ($node['node_type'] == Nodes::TYPE_FOLDER) {
                $has_folder = $node;
                /*
                 * Đối với thư mục cập nhật hết node bên trong nó lên trash_parent +1
                 * Nguyên tắc: Khi xóa thư mục thì file và thư mục con trong nó trash_parent=1
                 * Tiếp tục nếu có thư mục cha của nó được xóa thì nó sẽ là trash_parent=1 còn bên trong con của nó trash_parent=2
                 * Khi thư mục cha được hoàn tác xóa thì trừ bớt trash_parent và trash_parent nó lại trả về =0 và trash_parent con của nó =1
                 */
                $sql = "UPDATE " . NV_PREFIXLANG . "_" . $module_data . "_nodes SET trash_parent=trash_parent+1 WHERE parentid=" . $node['id'];
                if (!empty($node['subcatids'])) {
                    $sql .= " OR parentid IN(" . $node['subcatids'] . ")";
                }
                $db->query($sql);
            }

            $sql = "UPDATE " . NV_PREFIXLANG . "_" . $module_data . "_nodes SET trash=" . NV_CURRENTTIME . " WHERE id=" . $id;
            $db->query($sql);

            $db->commit();
        } catch (Throwable $e) {
            $db->rollBack();
            trigger_error(print_r($e, true));
        }
    }
    if (empty($number)) {
        nv_jsonOutput([
            'success' => 0,
            'text' => 'No file/folder!!!'
        ]);
    }

    // Sau khi xóa nếu toàn là tập tin thì tải lại danh sách. Nếu có thư mục phải chuyển hướng đến thư mục cha của nó
    $redirect = '';
    if (!empty($has_folder)) {
        $redirect = NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=' . $op;
        if ($has_folder['parentid'] > 0) {
            $redirect .= '&folder_id=' . $has_folder['parentid'];
        }
        $redirect = nv_url_rewrite($redirect, true);
    }

    nv_jsonOutput([
        'success' => 1,
        'text' => '',
        'reload' => !empty($has_folder) ? 0 : 1,
        'redirect' => $redirect
    ]);
}

// Lấy ra khỏi thùng rác tệp tin/thư mục
if ($nv_Request->isset_request('untrash_node', 'post')) {
    if ($nv_Request->get_title('checkss', 'post', '') != NV_CHECK_SESSION) {
        nv_jsonOutput([
            'success' => 0,
            'text' => 'Wrong session!!!'
        ]);
    }

    $ids = $nv_Request->get_title('untrash_node', 'post', '');
    $ids = array_filter(array_unique(array_map('intval', explode(',', $ids))));

    $has_folder = [];
    $number = 0;
    foreach ($ids as $id) {
        // Lấy và kiểm tra file/folder
        $sql = "SELECT * FROM " . NV_PREFIXLANG . "_" . $module_data . "_nodes WHERE
        userid=" . $user_info['userid'] . " AND id=" . $id . " AND trash>0 AND trash_parent=0 AND is_tmp=0";
        $node = $db->query($sql)->fetch();
        if (empty($node)) {
            continue;
        }
        $number++;

        $db->beginTransaction();
        try {
            if ($node['node_type'] == Nodes::TYPE_FOLDER) {
                $has_folder = $node;

                // Làm ngược lại lúc đưa vào thùng rác
                $sql = "UPDATE " . NV_PREFIXLANG . "_" . $module_data . "_nodes SET trash_parent=trash_parent-1 WHERE parentid=" . $node['id'];
                if (!empty($node['subcatids'])) {
                    $sql .= " OR parentid IN(" . $node['subcatids'] . ")";
                }
                $db->query($sql);
            }

            $sql = "UPDATE " . NV_PREFIXLANG . "_" . $module_data . "_nodes SET trash=0 WHERE id=" . $id;
            $db->query($sql);

            $db->commit();
        } catch (Throwable $e) {
            $db->rollBack();
            trigger_error(print_r($e, true));
        }
    }
    if (empty($number)) {
        nv_jsonOutput([
            'success' => 0,
            'text' => 'No file/folder!!!'
        ]);
    }

    nv_jsonOutput([
        'success' => 1,
        'text' => '',
        'reload' => !empty($has_folder) ? 1 : 0
    ]);
}

// Xóa vĩnh viễn tệp tin/thư mục
if ($nv_Request->isset_request('delete_permanently_node', 'post')) {
    if ($nv_Request->get_title('checkss', 'post', '') != NV_CHECK_SESSION) {
        nv_jsonOutput([
            'success' => 0,
            'text' => 'Wrong session!!!'
        ]);
    }

    $ids = $nv_Request->get_title('delete_permanently_node', 'post', '');
    $ids = array_filter(array_unique(array_map('intval', explode(',', $ids))));

    $number = 0;
    foreach ($ids as $id) {
        // Lấy và kiểm tra file/folder
        $sql = "SELECT * FROM " . NV_PREFIXLANG . "_" . $module_data . "_nodes WHERE
        userid=" . $user_info['userid'] . " AND id=" . $id . " AND trash>0 AND trash_parent=0 AND is_tmp=0";
        $node = $db->query($sql)->fetch();
        if (empty($node)) {
            continue;
        }
        $number++;
        Nodes::remove($id);
    }
    if (empty($number)) {
        nv_jsonOutput([
            'success' => 0,
            'text' => 'No file/folder!!!'
        ]);
    }

    nv_jsonOutput([
        'success' => 1,
        'text' => '',
    ]);
}

// Dọn sạch thùng rác
if ($nv_Request->isset_request('empty_trash', 'post')) {
    if ($nv_Request->get_title('checkss', 'post', '') != NV_CHECK_SESSION) {
        nv_jsonOutput([
            'success' => 0,
            'text' => 'Wrong session!!!'
        ]);
    }

    $sql = "SELECT * FROM " . NV_PREFIXLANG . "_" . $module_data . "_nodes WHERE trash>0 AND trash_parent=0
    AND userid=" . $user_info['userid'] . " AND is_tmp=0 ORDER BY trash ASC";
    $result = $db->query($sql);
    while ($row = $result->fetch()) {
        Nodes::remove($row['id']);
    }
    $result->closeCursor();

    nv_jsonOutput([
        'success' => 1,
        'text' => '',
    ]);
}

// Fetch danh sách thư mục trên Google Drive qua API
if ($nv_Request->isset_request('fetch_gdrive_folder', 'post')) {
    if ($nv_Request->get_title('checkss', 'post', '') != NV_CHECK_SESSION) {
        nv_jsonOutput([
            'success' => 0,
            'text' => 'Wrong session!!!'
        ]);
    }

    $app_id = $nv_Request->get_absint('app_id', 'post', 0);
    $folder_id = $nv_Request->get_title('folder_id', 'post', '');
    $folder_name = $nv_Request->get_title('folder_name', 'post', '');
    if (!isset($api_google_drive[$app_id])) {
        nv_jsonOutput([
            'success' => 0,
            'text' => 'App not exists!!!'
        ]);
    }
    if (!empty($api_google_drive[$app_id]['is_error'])) {
        nv_jsonOutput([
            'success' => 0,
            'text' => $nv_Lang->getModule('syncgdrive_error_apperror')
        ]);
    }

    $client = GoogleDrives::getClient($api_google_drive[$app_id]);
    if (is_string($client)) {
        nv_jsonOutput([
            'success' => 0,
            'text' => $client
        ]);
    }

    try {
        $service = new Drive($client);
        $q = [];
        $q[] = "mimeType='application/vnd.google-apps.folder'";
        $q[] = "trashed=false";
        if (empty($folder_id)) {
            $q[] = "'root' in parents";
        } else {
            $q[] = "'" . $folder_id . "' in parents";
        }

        $optParams = [
            'pageSize' => 1000, // Max có thể là 1000
            'fields' => 'files(id,name,createdTime)',
            'orderBy' => 'name asc',
            'q' => implode(' and ', $q)
        ];
        $results = $service->files->listFiles($optParams);
        $files = $results->getFiles();
    } catch (Throwable $e) {
        trigger_error(print_r($e, true));

        // Lỗi liên quan token
        if (preg_match('/Token[\s]*has[\s]*been[\s]*expired[\s]*or[\s]*revoked/i', $e->getMessage())) {
            $sql = "UPDATE " . NV_PREFIXLANG . "_" . $module_data . "_api_credentials SET is_error=1 WHERE id=" . $app_id;
            $db->query($sql);
        }

        nv_jsonOutput([
            'success' => 0,
            'text' => $e->getMessage()
        ]);
    }

    if (empty($files)) {
        nv_jsonOutput([
            'success' => 0,
            'text' => $nv_Lang->getModule('syncgdrive_nosub_folder'),
        ]);
    }

    $tpl = new \NukeViet\Template\NVSmarty();
    $tpl->assign('LANG', $nv_Lang);
    $tpl->assign('MODULE_NAME', $module_name);
    $tpl->assign('OP', $op);
    $tpl->assign('FILES', $files);
    $tpl->assign('FOLDER_ID', $folder_id);
    $tpl->assign('FOLDER_NAME', $folder_name);

    $tpl->setTemplateDir(get_module_tpl_dir('file-manager-google-drive-menu-folder.tpl'));
    nv_jsonOutput([
        'success' => 1,
        'text' => '',
        'html' => $tpl->fetch('file-manager-google-drive-menu-folder.tpl'),
        'objects' => $files
    ]);
}

// Lưu đồng bộ thư mục
if ($nv_Request->isset_request('setupsyncgoogledrive', 'post')) {
    if ($nv_Request->get_title('checkss', 'post', '') != NV_CHECK_SESSION) {
        nv_jsonOutput([
            'status' => 'error',
            'mess' => 'Wrong session!!!'
        ]);
    }

    $app_id = $nv_Request->get_absint('id', 'post', 0);
    $folder_id = $nv_Request->get_absint('folder_id', 'post', 0);
    $drive_id = $nv_Request->get_title('drive_id', 'post', '');

    // Kiểm tra chưa chọn APP
    if (empty($app_id)) {
        nv_jsonOutput([
            'status' => 'error',
            'input' => 'id',
            'mess' => $nv_Lang->getModule('syncgdrive_error_chooseapp')
        ]);
    }
    // Kiểm tra APP tồn tại
    if (!isset($api_google_drive[$app_id])) {
        nv_jsonOutput([
            'status' => 'error',
            'input' => 'id',
            'mess' => 'APP not exists!!!'
        ]);
    }
    // Kiểm tra tồn tại thư mục
    if (!isset($array_folders[$folder_id])) {
        nv_jsonOutput([
            'status' => 'error',
            'mess' => 'Folder not exists!!!'
        ]);
    }
    // Kiểm tra chưa chọn thư mục Google Drive đồng bộ
    if (empty($drive_id)) {
        nv_jsonOutput([
            'status' => 'error',
            'mess' => $nv_Lang->getModule('syncgdrive_error_choose')
        ]);
    }
    // Kiểm tra không được đồng bộ vì thư mục cha đã đồng bộ
    if ($array_folders[$folder_id]['sync_disabled']) {
        nv_jsonOutput([
            'status' => 'error',
            'mess' => 'Not allowed!!!'
        ]);
    }
    // Kiểm tra xem thư mục này đã được đồng bộ cho cái khác chưa
    $sql = "SELECT * FROM " . NV_PREFIXLANG . "_" . $module_data . "_nodes WHERE userid=" . $user_info['userid'] . "
    AND sync_appid=" . $app_id . " AND sync_folderid=" . $db->quote($drive_id);
    $row = $db->query($sql)->fetch();
    if (!empty($row)) {
        nv_jsonOutput([
            'status' => 'error',
            'mess' => $nv_Lang->getModule('syncgdrive_error_exists')
        ]);
    }

    $db->beginTransaction();
    try {
        $sql = "UPDATE " . NV_PREFIXLANG . "_" . $module_data . "_nodes SET
            sync_appid=" . $app_id . ",
            sync_folderid=" . $db->quote($drive_id) . "
        WHERE id=" . $folder_id;
        $db->query($sql);

        if (!empty($array_folders[$folder_id]['subcatids'])) {
            $sql = "UPDATE " . NV_PREFIXLANG . "_" . $module_data . "_nodes SET sync_disabled=1 WHERE id IN(" . implode(',', $array_folders[$folder_id]['subcatids']) . ")";
            $db->query($sql);
        }

        $db->commit();
    } catch (Throwable $e) {
        $db->rollBack();
        trigger_error(print_r($e, true));
        nv_jsonOutput([
            'status' => 'error',
            'mess' => $e->getMessage()
        ]);
    }

    nv_jsonOutput([
        'status' => 'success',
        'mess' => $nv_Lang->getGlobal('save_success'),
        'refresh' => 1
    ]);
}

// Tắt đồng bộ thư mục
if ($nv_Request->isset_request('offsyncgoogledrive', 'post')) {
    if ($nv_Request->get_title('checkss', 'post', '') != NV_CHECK_SESSION) {
        nv_jsonOutput([
            'success' => 0,
            'text' => 'Wrong session!!!'
        ]);
    }

    $folder_id = $nv_Request->get_absint('offsyncgoogledrive', 'post', 0);

    // Kiểm tra tồn tại thư mục
    if (!isset($array_folders[$folder_id])) {
        nv_jsonOutput([
            'success' => 0,
            'text' => 'Folder not exists!!!'
        ]);
    }
    // Kiểm tra chưa đồng bộ trước đó
    if (!$array_folders[$folder_id]['sync_appid']) {
        nv_jsonOutput([
            'success' => 0,
            'text' => 'Not synced before!!!'
        ]);
    }

    $db->beginTransaction();
    try {
        // Tắt thư mục
        $sql = "UPDATE " . NV_PREFIXLANG . "_" . $module_data . "_nodes SET
            sync_appid=0, sync_folderid='', sync_lastime=0, sync_iserror=0
        WHERE id=" . $folder_id;
        $db->query($sql);

        // Tắt refs thư mục
        $sql = "UPDATE " . NV_PREFIXLANG . "_" . $module_data . "_nodes_refs SET sync_messerror=null WHERE node_id=" . $folder_id;
        $db->query($sql);

        // Cho phép thư mục con đồng bộ lại
        if (!empty($array_folders[$folder_id]['subcatids'])) {
            $sql = "UPDATE " . NV_PREFIXLANG . "_" . $module_data . "_nodes SET sync_disabled=0 WHERE id IN(" . implode(',', $array_folders[$folder_id]['subcatids']) . ")";
            $db->query($sql);
        }

        // Tắt tệp tin + thư mục con
        $where = [];
        $where[] = "parentid=" . $folder_id;
        if (!empty($array_folders[$folder_id]['subcatids'])) {
            $where[] = "parentid IN(" . implode(',', $array_folders[$folder_id]['subcatids']) . ")";
        }
        $where = "(" . implode(' OR ', $where) . ")";

        $sql = "UPDATE " . NV_PREFIXLANG . "_" . $module_data . "_nodes_refs SET sync_messerror=null WHERE node_id IN(
            SELECT id FROM " . NV_PREFIXLANG . "_" . $module_data . "_nodes WHERE " . $where . "
        )";
        $db->query($sql);

        $sql = "UPDATE " . NV_PREFIXLANG . "_" . $module_data . "_nodes SET
            sync_appid=0, sync_folderid='', sync_lastime=0, sync_iserror=0
        WHERE " . $where;
        $db->query($sql);

        $db->commit();
    } catch (Throwable $e) {
        $db->rollBack();
        trigger_error(print_r($e, true));
        nv_jsonOutput([
            'success' => 0,
            'text' => $e->getMessage()
        ]);
    }

    nv_jsonOutput([
        'success' => 1,
        'text' => ''
    ]);
}

// Lấy thông tin thư mục để điền vào modal tùy chỉnh thư mục
if ($nv_Request->isset_request('get_info_folder', 'post')) {
    if ($nv_Request->get_title('checkss', 'post', '') != NV_CHECK_SESSION) {
        nv_jsonOutput([
            'success' => 0,
            'text' => 'Wrong session!!!'
        ]);
    }

    $folder_id = $nv_Request->get_absint('get_info_folder', 'post', 0);

    // Kiểm tra tồn tại thư mục
    if (!isset($array_folders[$folder_id])) {
        nv_jsonOutput([
            'success' => 0,
            'text' => 'Folder not exists!!!'
        ]);
    }

    nv_jsonOutput([
        'success' => 1,
        'text' => 'Success!',
        'folder' => $array_folders[$folder_id]
    ]);
}

// Lưu tùy chỉnh thư mục
if ($nv_Request->isset_request('save_setting_folder', 'post')) {
    if ($nv_Request->get_title('checkss', 'post', '') != NV_CHECK_SESSION) {
        nv_jsonOutput([
            'status' => 'error',
            'mess' => 'Wrong session!!!'
        ]);
    }

    $folder_id = $nv_Request->get_absint('folder_id', 'post', 0);

    // Kiểm tra tồn tại thư mục
    if (!isset($array_folders[$folder_id])) {
        nv_jsonOutput([
            'status' => 'error',
            'text' => 'Folder not exists!!!'
        ]);
    }

    $array = [];
    $array['show_type'] = $nv_Request->get_title('show_type', 'post', '');
    $array['hide_media'] = (int) $nv_Request->get_bool('hide_media', 'post', false);
    if (!empty($array['show_type']) and $array['show_type'] != 'grid') {
        $array['show_type'] = '';
    }

    $properties = array_merge($array_folders[$folder_id]['properties'], $array);
    $properties = json_encode($properties, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);

    $sql = "UPDATE " . NV_PREFIXLANG . "_" . $module_data . "_nodes SET properties=" . $db->quote($properties) . " WHERE id=" . $folder_id;
    $db->query($sql);

    nv_jsonOutput([
        'status' => 'success',
        'mess' => $nv_Lang->getGlobal('save_success'),
        'refresh' => 1
    ]);
}

// Xử lý lại video
if ($nv_Request->isset_request('reprocess_video', 'post')) {
    if ($nv_Request->get_title('checkss', 'post', '') != NV_CHECK_SESSION) {
        nv_jsonOutput([
            'success' => 0,
            'text' => 'Wrong session!!!'
        ]);
    }

    $id = $nv_Request->get_absint('reprocess_video', 'post', 0);

    // Lấy và kiểm tra node
    $sql = "SELECT * FROM " . NV_PREFIXLANG . "_" . $module_data . "_nodes WHERE
    userid=" . $user_info['userid'] . " AND id=" . $id . " AND trash=0 AND trash_parent=0 AND is_tmp=0";
    $node = $db->query($sql)->fetch();
    if (empty($node)) {
        $respon['mess'] = 'Video not exists!!!';
        nv_jsonOutput($respon);
    }

    $sql = "UPDATE " . NV_PREFIXLANG . "_" . $module_data . "_nodes SET process_time=0 WHERE id=" . $id;
    $db->query($sql);

    nv_jsonOutput([
        'success' => 1,
        'text' => $nv_Lang->getModule('ui_recreate_cover_success')
    ]);
}

// Zone và hủy Zone
if ($nv_Request->isset_request('zone_unzone', 'post')) {
    if ($nv_Request->get_title('checkss', 'post', '') != NV_CHECK_SESSION) {
        nv_jsonOutput([
            'success' => 0,
            'text' => 'Wrong session!!!'
        ]);
    }

    $id = $nv_Request->get_absint('zone_unzone', 'post', 0);
    $mode = $nv_Request->get_title('mode', 'post', '');

    // Lấy và kiểm tra node
    $sql = "SELECT * FROM " . NV_PREFIXLANG . "_" . $module_data . "_nodes WHERE
    userid=" . $user_info['userid'] . " AND id=" . $id . " AND trash=0 AND trash_parent=0 AND is_tmp=0 AND node_type=" . Nodes::TYPE_FILE;
    $node = $db->query($sql)->fetch();
    if (empty($node)) {
        nv_jsonOutput([
            'success' => 0,
            'text' => 'File not exists!!!'
        ]);
    }
    $not_zoned = ($node['zoned_time'] == 0 or ($node['zoned_time'] > 0 and $node['zoned_time'] < NV_CURRENTTIME));
    if ($not_zoned and !in_array($mode, ['temporary', 'permanently'])) {
        nv_jsonOutput([
            'success' => 0,
            'text' => 'Wrong data request!!!'
        ]);
    }

    if ($not_zoned) {
        // Zone
        $zoned_time = $mode == 'permanently' ? -1 : (NV_CURRENTTIME + 300);
    } else {
        // Hủy Zone
        $zoned_time = 0;
    }
    $sql = "UPDATE " . NV_PREFIXLANG . "_" . $module_data . "_nodes SET zoned_time=" . $zoned_time . " WHERE id=" . $id;
    $db->query($sql);

    nv_jsonOutput([
        'success' => 1,
        'text' => $not_zoned ? $nv_Lang->getModule($mode == 'temporary' ? 'fzone_zone_success0' : 'fzone_zone_success1') : $nv_Lang->getModule('fzone_unzone_success'),
        'zone' => empty($zoned_time) ? 0 : 1
    ]);
}
