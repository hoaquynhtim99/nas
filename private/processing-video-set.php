<?php

/**
 * NukeViet Content Management System
 * @version 4.x
 * @author VINADES.,JSC <contact@vinades.vn>
 * @copyright (C) 2009-2023 VINADES.,JSC. All rights reserved
 * @license GNU/GPL version 2 or any later version
 * @see https://github.com/nukeviet The NukeViet CMS GitHub project
 */

define('NV_SYSTEM', true);
define('NV_IS_CONSOLE', true);

/**
 * Đọc kết quả xử lý video lưu vào CSDL
 */

if (preg_match('/^([A-Z]{1})\:/', __DIR__)) {
    define('NV_ROOTDIR', str_replace(DIRECTORY_SEPARATOR, '/', realpath(pathinfo(str_replace(DIRECTORY_SEPARATOR, '/', __FILE__), PATHINFO_DIRNAME) . '/../src')));
    define('NV_IN_LOCAL_CONSOLE', true);
} else {
    define('NV_ROOTDIR', str_replace(DIRECTORY_SEPARATOR, '/', realpath(pathinfo(str_replace(DIRECTORY_SEPARATOR, '/', __FILE__), PATHINFO_DIRNAME) . '/../public_html')));
}

define('NV_CONSOLE_DIR', str_replace(DIRECTORY_SEPARATOR, '/', realpath(pathinfo(str_replace(DIRECTORY_SEPARATOR, '/', __FILE__), PATHINFO_DIRNAME))));

require NV_CONSOLE_DIR . '/server.php';
require NV_ROOTDIR . '/includes/mainfile.php';
$console_starttime = microtime(true);

$module_data = 'nas';
$module_file = 'nas';
$nv_Lang->loadModule($module_file);

$queue_path = NV_CONSOLE_DIR . '/logs/processing-video/path.txt';
$queue_cover = NV_CONSOLE_DIR . '/logs/processing-video/cover.txt';
$queue_id = NV_CONSOLE_DIR . '/logs/processing-video/id.txt';
$queue_error = NV_CONSOLE_DIR . '/logs/processing-video/error.txt';
$queue_resolution = NV_CONSOLE_DIR . '/logs/processing-video/resolution.txt';
$queue_duration = NV_CONSOLE_DIR . '/logs/processing-video/duration.txt';

// Lấy video
$node_id = (int) file_get_contents($queue_id);
$sql = "SELECT * FROM " . NV_PREFIXLANG . "_" . $module_data . "_nodes WHERE id=" . $node_id;
$node = $db->query($sql)->fetch();
if (empty($node)) {
    exit("Node not exists\n");
}

// Xác định lỗi hay không
$process_time = NV_CURRENTTIME;
if (file_exists($queue_error)) {
    $process_time = -1 * NV_CURRENTTIME;
}

// Lấy cover cũ và mới
$sql = "SELECT image_cover FROM " . NV_PREFIXLANG . "_" . $module_data . "_nodes_refs WHERE node_id=" . $node_id;
$old_cover = $db->query($sql)->fetchColumn() ?: '';
$new_cover = trim(file_get_contents($queue_cover));
if (!file_exists($new_cover)) {
    $process_time = -1 * NV_CURRENTTIME;
}

// Lấy độ phân giải
if (file_exists($queue_resolution)) {
    $resolution = trim(file_get_contents($queue_resolution));
    $resolution = explode('x', $resolution);
    if (isset($resolution[1])) {
        $node['image_width'] = intval($resolution[0]);
        $node['image_height'] = intval($resolution[1]);
    }
}

// Lấy thời lượng
if (file_exists($queue_duration)) {
    $node['duration'] = intval(trim(file_get_contents($queue_duration)));
}

// Nếu lỗi giữ nguyên ảnh mới
$image_cover = substr($new_cover, strlen(NV_ROOTDIR . '/' . NV_ASSETS_DIR . '/nas-cover/'));
if ($process_time < 0) {
    $image_cover = $old_cover;
} elseif (!empty($old_cover)) {
    // Nếu thành công xóa cover cũ nếu có
    $path_old_cover = NV_ROOTDIR . '/' . NV_ASSETS_DIR . '/nas-cover/' . $old_cover;
    if (file_exists($path_old_cover)) {
        unlink($path_old_cover);
    }
}

// Cập nhật kích thước video và trạng thái xử lý
$sql = "UPDATE " . NV_PREFIXLANG . "_" . $module_data . "_nodes SET
    duration=" . $node['duration'] . ",
    image_width=" . $node['image_width'] . ",
    image_height=" . $node['image_height'] . ",
    process_time=" . $process_time . "
WHERE id=" . $node['id'];
$db->query($sql);

// Cập nhật ảnh của video
$sql = "UPDATE " . NV_PREFIXLANG . "_" . $module_data . "_nodes_refs SET
    image_cover=" . $db->quote($image_cover) . "
WHERE node_id=" . $node['id'];
$db->query($sql);

echo "Save success\n";
