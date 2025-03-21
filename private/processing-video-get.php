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
 * Lấy tệp tin video cần xử lý lưu vào logs/processing-video/queue.txt
 * exit 0 là không có video
 *      1 là lỗi
 *      2 là thành công
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

$log_file = NV_CONSOLE_DIR . '/logs/processing-video/' . date('Y-m-d') . '.txt';

$sql = "SELECT * FROM " . NV_PREFIXLANG . "_" . $module_data . "_nodes WHERE
    trash=0 AND trash_parent=0 AND is_tmp=0 AND node_type=0
    AND node_ext IN('mp4', 'avi', 'mkv', 'mov', 'wmv', 'flv', 'webm', 'm4v', 'mpg', 'mpeg', '3gp')
    AND process_time=0
ORDER BY add_time ASC LIMIT 1";
$node = $db->query($sql)->fetch();
if (empty($node)) {
    echo "There are no videos in the queue\n";
    exit(0);
}

// Lấy thành viên này
$sql = "SELECT * FROM " . NV_USERS_GLOBALTABLE . " WHERE userid=" . $node['userid'];
$user = $db->query($sql)->fetch();
if (empty($user)) {
    echo "User not found\n";

    $sql = "UPDATE " . NV_PREFIXLANG . "_" . $module_data . "_nodes SET process_time=-" . NV_CURRENTTIME . " WHERE id=" . $node['id'];
    $db->query($sql);

    exit(1);
}
$user['user_dir'] = strtolower($user['username']);
if (!preg_match('/^[a-zA-Z0-9]+$/i', $user['user_dir'])) {
    echo "Username wrong\n";

    $sql = "UPDATE " . NV_PREFIXLANG . "_" . $module_data . "_nodes SET process_time=-" . NV_CURRENTTIME . " WHERE id=" . $node['id'];
    $db->query($sql);

    exit(1);
}

$full_path = NAS_DIR . '/' . $user['user_dir'] . '/' . $node['path'];
$image_path = NV_ROOTDIR . '/' . NV_ASSETS_DIR . '/nas-cover/' . date('Y-m', $node['add_time']) . '/' . uniqid(strtolower(change_alias(nv_substr($node['title'], 0, 50))) . '_', true) . '.jpg';

if (!file_exists($full_path)) {
    echo "File not found\n";

    $sql = "UPDATE " . NV_PREFIXLANG . "_" . $module_data . "_nodes SET process_time=-" . NV_CURRENTTIME . " WHERE id=" . $node['id'];
    $db->query($sql);

    exit(1);
}

$queue_path = NV_CONSOLE_DIR . '/logs/processing-video/path.txt';
$queue_cover = NV_CONSOLE_DIR . '/logs/processing-video/cover.txt';
$queue_id = NV_CONSOLE_DIR . '/logs/processing-video/id.txt';

file_put_contents($queue_path, $full_path, LOCK_EX);
file_put_contents($queue_cover, $image_path, LOCK_EX);
file_put_contents($queue_id, $node['id'], LOCK_EX);

echo "Pending video #" . $node['id'] . ": " . $node['title'] . "\n";
exit(2);
