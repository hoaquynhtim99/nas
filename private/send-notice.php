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
 * Gửi email thông báo cho người dùng các lỗi
 */

use NukeViet\Module\nas\Shared\Nodes;

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

// Mở rộng bộ nhớ cấp phép
if ($sys_info['ini_set_support']) {
    $memoryLimitMB = (int) ini_get('memory_limit');
    if ($memoryLimitMB < 512) {
        ini_set('memory_limit', '512M');
    }
}

// Mỗi lần chỉ gửi một thông báo qua email tránh bị nhiều quá
// Nếu có nhà cung cấp gửi email thì tăng limit lên
$limit = 1;

$sql = "SELECT tb1.*, tb2.email FROM " . NV_PREFIXLANG . "_" . $module_data . "_users_notices tb1
INNER JOIN " . NV_USERS_GLOBALTABLE . " tb2 ON tb1.userid=tb2.userid
WHERE tb1.send_time=0 ORDER BY tb1.notice_time ASC LIMIT " . $limit;
$result = $db->query($sql);

$num = 0;
while ($row = $result->fetch()) {
    $num++;
    echo "Send to " . $row['email'] . ": " . nv_substr($row['subject'], 0, 20) . " -------> ";

    $global_config['custom_configs']['custom_mail_references'] = $module_data . '-notice-error-u' . $row['userid'] . '@' . NV_SERVER_NAME;
    $check = nv_sendmail([$global_config['site_name'], $global_config['site_email']], $row['email'], $nv_Lang->getModule('cron_error_sendsubject'), ('<strong>' . $row['subject'] . '</strong><br />' . $row['message']), '', false, true);
    $send_message = '';
    if ($check !== '') {
        echo "Error: " . $check . "\n";
        $send_message = $check;
    } else {
        echo "Success\n";
    }

    $sql = "UPDATE " . NV_PREFIXLANG . "_" . $module_data . "_users_notices SET
        send_time=" . NV_CURRENTTIME . ",
        send_message=" . $db->quote($send_message) . "
    WHERE id=" . $row['id'];
    $db->query($sql);
}
$result->closeCursor();

if (empty($num)) {
    echo "No notice\n";
}

// Xóa các thông báo sau 30 ngày
$offset_time = NV_CURRENTTIME - (30 * 86400);
$sql = "DELETE FROM " . NV_PREFIXLANG . "_" . $module_data . "_users_notices WHERE notice_time<" . $offset_time;
$num = $db->exec($sql);

echo "Delete OLD: " . $num . "\n";

$console_endtime = microtime(true);
$execution_time = getConsoleExecuteTime($console_starttime, $console_endtime);

echo ('Thời gian thực thi: ' . $execution_time . PHP_EOL);
echo ('Tiến trình kết thúc!' . PHP_EOL);
