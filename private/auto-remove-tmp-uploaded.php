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
 * Xóa tự động tệp tin upload lên dở sau 1 ngày
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

// Mở rộng bộ nhớ cấp phép
if ($sys_info['ini_set_support']) {
    $memoryLimitMB = (int) ini_get('memory_limit');
    if ($memoryLimitMB < 512) {
        ini_set('memory_limit', '512M');
    }
}

$offset_time = NV_CURRENTTIME - (1 * 86400);
$log_file = NV_CONSOLE_DIR . '/logs/auto-remove-tmp-uploaded/' . date('Y-m-d') . '.txt';

$sql = "SELECT * FROM " . NV_PREFIXLANG . "_" . $module_data . "_nodes WHERE
node_type=0 AND is_tmp<" . $offset_time . " AND is_tmp>0 ORDER BY is_tmp ASC";
$result = $db->query($sql);

$num = 0;
while ($row = $result->fetch()) {
    $num++;
    $line = "Delete tmp node #" . $row['id'] . ": ";
    echo $line;
    file_put_contents($log_file, $line, FILE_APPEND);

    $delete = Nodes::remove($row['id'], 1);
    $line = $delete ? "Success\n" : "Error\n";
    echo $line;
    file_put_contents($log_file, $line, FILE_APPEND);
}
$result->closeCursor();

if (empty($num)) {
    echo "No file\n";
}

$console_endtime = microtime(true);
$execution_time = getConsoleExecuteTime($console_starttime, $console_endtime);

echo ('Thời gian thực thi: ' . $execution_time . PHP_EOL);
echo ('Tiến trình kết thúc!' . PHP_EOL);
