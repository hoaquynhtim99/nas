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
 * Hàng ngày gọi lên Google Drive kiểm tra các app để chắc chắn nó vẫn còn hoạt động
 * Nếu không hoạt động gửi email cảnh báo
 */

use NukeViet\Module\nas\Shared\GoogleDrives;
use Google\Service\Drive;
use NukeViet\Module\nas\Shared\Nodes;
use Google\Service\Drive\DriveFile;
use Google\Http\MediaFileUpload;
use NukeViet\Module\nas\Shared\Notices;

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

/**
 * Kiểm tra các app
 */
$log_file = NV_CONSOLE_DIR . '/logs/auto-check-app/' . date('Y-m-d') . '.txt';

$sql = "SELECT * FROM " . NV_PREFIXLANG . "_" . $module_data . "_api_credentials WHERE is_setup=1 AND is_error=0";
$result = $db->query($sql);

$num = 0;
while ($row = $result->fetch()) {
    $num++;
    echo "Check app [#" . $row['id'] . "] " . $row['title'] . ": ";

    try {
        // Tạo client của APP để kiểm tra
        $client = GoogleDrives::getClient($row);
        if (is_string($client)) {
            throw new Exception($client);
        }

        // Kết nối thử
        $service = new Drive($client);
        $q = [];
        $q[] = "mimeType='application/vnd.google-apps.folder'";
        $q[] = "trashed=false";
        $q[] = "'root' in parents";

        $optParams = [
            'pageSize' => 1, // Max có thể là 1000
            'fields' => 'files(id,name,createdTime)',
            'orderBy' => 'name asc',
            'q' => implode(' and ', $q)
        ];
        $results = $service->files->listFiles($optParams);
        $files = $results->getFiles();

        echo "Success!\n";
    } catch (Throwable $e) {
        trigger_error(print_r($e, true));

        $sql = "UPDATE " . NV_PREFIXLANG . "_" . $module_data . "_api_credentials SET is_error=1 WHERE id=" . $row['id'];
        $db->query($sql);

        echo "Error: " . $e->getMessage() . "\n";
        Notices::save($row['userid'], 'CHECK_APP', $nv_Lang->getModule('syncgdrive_aerror_check1'), $nv_Lang->getModule('syncgdrive_aerror_check2', $row['title'], $e->getMessage()));
    }

    echo "\n";
}
$result->closeCursor();

if (empty($num)) {
    echo "No app for check\n";
} else {
    file_put_contents($log_file, "--------------------\n\n", FILE_APPEND);
}

$console_endtime = microtime(true);
$execution_time = getConsoleExecuteTime($console_starttime, $console_endtime);

echo ('Thời gian thực thi: ' . $execution_time . PHP_EOL);
echo ('Tiến trình kết thúc!' . PHP_EOL);
