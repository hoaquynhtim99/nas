<?php

/**
 * NukeViet Content Management System
 * @version 4.x
 * @author VINADES.,JSC <contact@vinades.vn>
 * @copyright (C) 2009-2021 VINADES.,JSC. All rights reserved
 * @license GNU/GPL version 2 or any later version
 * @see https://github.com/nukeviet The NukeViet CMS GitHub project
 */

if (!defined('NV_MAINFILE')) {
    die('Stop!!!');
}

/**
 * Hàm tạo các thư mục cần thiết cho user
 *
 * @return string[]|mixed[]|string[]
 */
function initUserDir()
{
    global $user_info, $nv_Lang;

    // Rule của username
    if (!preg_match('/^[a-zA-Z0-9]+$/i', $user_info['username'])) {
        return [$nv_Lang->getModule('upload_error_username'), ''];
    }

    // Tạo thư mục trong NAS
    $user_dir = strtolower($user_info['username']);
    if (!is_dir(NAS_DIR . '/' . $user_dir)) {
        $mkdir = mkdir(NAS_DIR . '/' . $user_dir, 0755);
        if ($mkdir !== true) {
            return [$nv_Lang->getModule('upload_error_dirroot'), ''];
        }
    }

    // Tạo thư mục assets
    $asset_dirs = [];
    $asset_dirs[] = NV_ASSETS_DIR . '/nas-data';
    $asset_dirs[] = NV_ASSETS_DIR . '/nas-data/' . $user_dir;

    foreach ($asset_dirs as $dir) {
        if (!is_dir($dir)) {
            $mkdir = mkdir($dir, 0755);
            if ($mkdir !== true) {
                return [$nv_Lang->getModule('createdir_err_assets'), ''];
            }
            file_put_contents($dir . '/index.html', '', LOCK_EX);
        }
    }

    return ['', $user_dir];
}

/**
 * Hàm tạo ảnh thumb cho ảnh đã upload lên
 *
 * @param string $image_path
 * @return number
 */
function makeThumb(string $image_path)
{
    global $db;

    $relative_path = substr($image_path, strlen(NAS_DIR . '/'));
    if (file_exists(NV_ROOTDIR . '/' . NV_ASSETS_DIR . '/nas-data/' . $relative_path)) {
        return 1;
    }

    // Tạo thư mục trong assets để đủ
    $dirs = explode('/', $relative_path);
    unset($dirs[sizeof($dirs) - 1]);
    $create_dir = NV_ROOTDIR . '/' . NV_ASSETS_DIR . '/nas-data';
    foreach ($dirs as $dir) {
        $create_dir .= '/' . $dir;
        if (!is_dir($create_dir)) {
            $mkdir = mkdir($create_dir, 0755);
            if ($mkdir !== true) {
                return 0;
            }
            file_put_contents($create_dir . '/index.html', '', LOCK_EX);
        }
    }

    $sql = "SELECT * FROM " . NV_UPLOAD_GLOBALTABLE . "_dir WHERE did=0";
    $config_dir = $db->query($sql)->fetch() ?: [];
    $thumb_width = empty($config_dir['thumb_width']) ? 480 : $config_dir['thumb_width'];
    $thumb_height = empty($config_dir['thumb_height']) ? 600 : $config_dir['thumb_height'];
    $thumb_quality = empty($config_dir['thumb_quality']) ? 80 : $config_dir['thumb_quality'];

    $image = new NukeViet\Files\Image($image_path, NV_MAX_WIDTH, NV_MAX_HEIGHT);
    if ($image->fileinfo['width'] > $thumb_width or $image->fileinfo['height'] > $thumb_height) {
        // Tạo ảnh thumb
        $image->resizeXY($thumb_width, $thumb_height);
        $image->save(dirname(NV_ROOTDIR . '/' . NV_ASSETS_DIR . '/nas-data/' . $relative_path), basename($relative_path), $thumb_quality);
    } else {
        // Chép trực tiếp ảnh nếu bé hơn thumb
        copy($image_path, NV_ROOTDIR . '/' . NV_ASSETS_DIR . '/nas-data/' . $relative_path);
    }

    if (file_exists(NV_ROOTDIR . '/' . NV_ASSETS_DIR . '/nas-data/' . $relative_path)) {
        return 1;
    }
    return 0;
}

/**
 * Xác định tên thư mục/tập tin không trùng thuộc 1 thư mục cha gồm cả phần mở rộng nếu có
 *
 * @param string $alias
 * @param string $ext
 * @param string $root_path
 * @return string
 */
function getUniqueName(string $alias, string $ext, string $root_path)
{
    if (!empty($ext)) {
        $ext = '.' . $ext;
    }

    // Tìm tên không trùng trong thư mục
    $alias_prefix = $alias;
    $prefix = 0;
    while (1) {
        if (file_exists($root_path . '/' . $alias . $ext)) {
            $prefix++;
            $alias = $alias_prefix . '-' . $prefix;
        } else {
            break;
        }
    }

    return $alias . $ext;
}

/**
 * Lấy hết các thư mục cha của nó tính cả nó
 *
 * @param int $folder_id
 * @param array $array_folders
 * @return array
 */
function getParentDirs(int $folder_id, array $array_folders)
{
    $ids = [];
    $parentid = $folder_id;
    while ($parentid > 0) {
        $ids[] = $parentid;
        $parentid = $array_folders[$parentid]['parentid'];
    }

    return $ids;
}

/**
 * Hàm kiểm tra xem tên Node có bị trùng không
 *
 * @param string $title
 * @param int $folder_id
 * @param int $id
 * @return bool|int
 */
function checkTitleExists(string $title, int $folder_id, int $id = 0)
{
    global $module_data, $user_info, $db;

    $sql = "SELECT id FROM " . NV_PREFIXLANG . "_" . $module_data . "_nodes WHERE
    userid=" . $user_info['userid'] . " AND title=" . $db->quote($title) . " AND parentid=" . $folder_id;
    if ($id > 0) {
        $sql .= " AND id!=" . $id;
    }
    return $db->query($sql)->fetchColumn();
}
