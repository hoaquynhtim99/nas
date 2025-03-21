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
 * Đồng bộ thư mục đã được cài đặt lên Google Drive
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
 * Đồng bộ thư mục cha rồi đến con
 * Cuối cùng đến tệp tin
 */
$log_file = NV_CONSOLE_DIR . '/logs/sync-google-drive/' . date('Y-m-d') . '.txt';

// Mỗi lần xử lý 10 thư mục
$sql = "UPDATE " . NV_PREFIXLANG . "_" . $module_data . "_nodes SET
    sync_lastime=" . NV_CURRENTTIME . "
WHERE sync_appid>0 AND sync_iserror=0
ORDER BY sync_lastime ASC LIMIT 10";
$db->query($sql);

$sql = "SELECT * FROM " . NV_PREFIXLANG . "_" . $module_data . "_nodes WHERE sync_appid>0 AND sync_iserror=0 AND sync_lastime=" . NV_CURRENTTIME;
$result = $db->query($sql);

$num = 0;
while ($folder = $result->fetch()) {
    unset($client, $service);
    echo "Check sync folder " . $folder['title'] . ":\n";

    // Lấy thành viên này
    $sql = "SELECT * FROM " . NV_USERS_GLOBALTABLE . " WHERE userid=" . $folder['userid'];
    $user = $db->query($sql)->fetch();
    if (empty($user)) {
        echo "User not found\n";
        continue;
    }
    $user['user_dir'] = strtolower($user['username']);
    if (!preg_match('/^[a-zA-Z0-9]+$/i', $user['user_dir'])) {
        echo "Username wrong to sync\n";
        continue;
    }

    // Lấy APP
    $sql = "SELECT * FROM " . NV_PREFIXLANG . "_" . $module_data . "_api_credentials WHERE id=" . $folder['sync_appid'];
    $app = $db->query($sql)->fetch();
    if (empty($app)) {
        echo "No APP found\n";
        Notices::save($folder['userid'], 'SYNC_GDRIVE', $nv_Lang->getModule('syncgdrive_cerror_appfound1'), $nv_Lang->getModule('syncgdrive_cerror_appfound2', $folder['title']));
        continue;
    }
    // Chưa kết nối APP xong thì bỏ qua
    if (empty($app['is_setup'])) {
        echo "APP not setup\n";
        continue;
    }
    // APP lỗi thì bỏ qua và báo lỗi
    if (!empty($app['is_error'])) {
        echo "APP is error\n";
        Notices::save($folder['userid'], 'SYNC_GDRIVE', $nv_Lang->getModule('syncgdrive_cerror_apperror1'), $nv_Lang->getModule('syncgdrive_cerror_apperror2', $folder['title'], $app['title']));
        continue;
    }
    // Tạo client của APP để kiểm tra
    $client = GoogleDrives::getClient($app);
    if (is_string($client)) {
        echo "APP Error: " . $client . "\n";
        Notices::save($folder['userid'], 'SYNC_GDRIVE', $nv_Lang->getModule('syncgdrive_cerror_apperror3'), $nv_Lang->getModule('syncgdrive_cerror_apperror4', $row['title'], $app['title'], $client));
        continue;
    }
    $service = new Drive($client);

    // Đồng bộ 10 tệp tin/thư mục mới lên
    $sql = "SELECT * FROM " . NV_PREFIXLANG . "_" . $module_data . "_nodes WHERE
    trash=0 AND trash_parent=0 AND is_tmp=0 AND sync_folderid='' AND sync_iserror=0
    AND (parentid=" . $folder['id'];
    if (!empty($folder['subcatids'])) {
        $sql .= " OR parentid IN(" . $folder['subcatids'] . ")";
    }
    $sql .= ") ORDER BY node_type DESC, lev ASC, add_time ASC LIMIT 10";
    $result2 = $db->query($sql);
    while ($row = $result2->fetch()) {
        $num++;
        $line = "Sync " . ($row['node_type'] == Nodes::TYPE_FILE ? 'file' : 'folder') . " #[" . $row['id'] . "] " . $row['title'] . ": ";
        echo $line;
        file_put_contents($log_file, $line, FILE_APPEND);

        try {
            // Lấy thư mục cha của nó nếu có
            $row_parent = [];
            if (!empty($row['parentid'])) {
                if ($row['parentid'] == $folder['id']) {
                    // Cha của nó chính là đối tượng bật đồng bộ
                    $row_parent = $folder;
                } else {
                    // Các thư mục con bên trong
                    $sql = "SELECT * FROM " . NV_PREFIXLANG . "_" . $module_data . "_nodes WHERE id=" . $row['parentid'];
                    $row_parent = $db->query($sql)->fetch();
                    if (empty($row_parent)) {
                        Notices::save($folder['userid'], 'SYNC_GDRIVE', $nv_Lang->getModule('syncgdrive_cerror_parent1'), $nv_Lang->getModule('syncgdrive_cerror_parent2', $row['title'], $row['parentid']));
                        throw new Exception("Parent not found");
                    }
                }
                if (!empty($row_parent['sync_iserror'])) {
                    // Cha không đồng bộ được thì con cũng không
                    Notices::save($folder['userid'], 'SYNC_GDRIVE', $nv_Lang->getModule('syncgdrive_cerror_parent3'), $nv_Lang->getModule('syncgdrive_cerror_parent4', $row['title'], $row_parent['title']));
                    throw new Exception("Parent sync error");
                }
            }

            // Cha của nó chưa được đồng bộ lên để lấy ID thư mục trên Google Drive
            if (empty($row_parent['sync_folderid'])) {
                Notices::save($folder['userid'], 'SYNC_GDRIVE', $nv_Lang->getModule('syncgdrive_cerror_parent5'), $nv_Lang->getModule('syncgdrive_cerror_parent6', $row['title'], $row_parent['title']));
                throw new Exception("Parent sync success but no folderID");
            }

            if ($row['node_type'] == Nodes::TYPE_FOLDER) {
                // Tạo thư mục
                $fileMetadata = new DriveFile([
                    'name' => nv_unhtmlspecialchars($row['title']),
                    'mimeType' => 'application/vnd.google-apps.folder'
                ]);
                $fileMetadata->setParents([$row_parent['sync_folderid']]);
                $create = $service->files->create($fileMetadata, [
                    'fields' => 'id, name'
                ]);
                $gdrive_id = $create->getId();
            } else {
                // Upload tệp tin
                $file_path = NAS_DIR . '/' . $user['user_dir'] . '/' . $row['path'];
                if (!is_file($file_path)) {
                    Notices::save($folder['userid'], 'SYNC_GDRIVE', $nv_Lang->getModule('syncgdrive_cerror_fileexists1'), $nv_Lang->getModule('syncgdrive_cerror_fileexists2', $row['title']));
                    throw new Exception("File not found on disk");
                }

                echo "Start upload file";
                $fileMetadata = new DriveFile([
                    'name' => nv_unhtmlspecialchars($row['title']) . '.' . $row['node_ext'],
                ]);
                $fileMetadata->setParents([$row_parent['sync_folderid']]);

                if (filesize($file_path) > 5242880) {
                    // File > 5mb upload từng phần
                    echo " chunks mode:\n";

                    $client->setDefer(true);
                    $create = $service->files->create($fileMetadata);

                    $media = new MediaFileUpload($client, $create, $row['node_mime'], null, true, 5242880);
                    $media->setFileSize(filesize($file_path));

                    $status_upload = false;
                    $handle = fopen($file_path, 'rb');

                    $stt = 0;
                    while (!$status_upload and !feof($handle)) {
                        $chunk = read_chunk($handle, 5242880);
                        $status_upload = $media->nextChunk($chunk);
                        echo "Upload part #" . (++$stt) . "\n";
                    }

                    $result_upload = false;
                    if ($status_upload != false) {
                        $result_upload = $status_upload;
                    }
                    fclose($handle);

                    if (!$result_upload) {
                        Notices::save($folder['userid'], 'SYNC_GDRIVE', $nv_Lang->getModule('syncgdrive_cerror_upload1'), $nv_Lang->getModule('syncgdrive_cerror_upload2', $row['title']));
                        throw new Exception("Upload chunks error");
                    }
                    $gdrive_id = $result_upload->getId();
                } else {
                    // File <= 5mb upload 1 lần trực tiếp
                    echo '...';
                    $client->setDefer(false);
                    $create = $service->files->create($fileMetadata, [
                        'fields' => 'id, name',
                        'data' => file_get_contents($file_path),
                        'uploadType' => 'multipart'
                    ]);
                    $gdrive_id = $create->getId();
                }
            }

            // Ghi lại thông tin đã đồng bộ lên CSDL
            $sql = "UPDATE " . NV_PREFIXLANG . "_" . $module_data . "_nodes SET
                sync_folderid=" . $db->quote($gdrive_id) . ",
                sync_lastime=" . NV_CURRENTTIME . "
            WHERE id=" . $row['id'];
            $db->query($sql);

            $line = "success\n";
            echo $line;
            file_put_contents($log_file, $line, FILE_APPEND);
        } catch (Throwable $e) {
            trigger_error(print_r($e, true));

            $line = $e->getMessage() . "\n";
            echo $line;
            file_put_contents($log_file, $line, FILE_APPEND);

            // Đánh dấu lỗi đồng bộ của note
            $sql = "UPDATE " . NV_PREFIXLANG . "_" . $module_data . "_nodes SET sync_lastime=" . NV_CURRENTTIME . ", sync_iserror=" . NV_CURRENTTIME . " WHERE id=" . $row['id'];
            $db->query($sql);

            $sql = "UPDATE " . NV_PREFIXLANG . "_" . $module_data . "_nodes_refs SET sync_messerror=" . $db->quote($e->getMessage()) . " WHERE node_id=" . $row['id'];
            $db->query($sql);
        }
    }
    $result2->closeCursor();

    // Đổi tên 10 tệp tin/thư mục
    $sql = "SELECT * FROM " . NV_PREFIXLANG . "_" . $module_data . "_nodes WHERE
    trash=0 AND trash_parent=0 AND is_tmp=0 AND sync_folderid!='' AND sync_iserror=0 AND sync_lastime>0
    AND rename_time>sync_lastime
    AND (parentid=" . $folder['id'];
    if (!empty($folder['subcatids'])) {
        $sql .= " OR parentid IN(" . $folder['subcatids'] . ")";
    }
    $sql .= ") ORDER BY node_type DESC, lev ASC, rename_time ASC LIMIT 10";
    $result2 = $db->query($sql);
    while ($row = $result2->fetch()) {
        $num++;
        $line = "Change name " . ($row['node_type'] == Nodes::TYPE_FILE ? 'file' : 'folder') . " to #[" . $row['id'] . "] " . $row['title'] . ": ";
        echo $line;
        file_put_contents($log_file, $line, FILE_APPEND);

        try {
            // Đổi tên
            $fileMetadata = new DriveFile([
                'name' => nv_unhtmlspecialchars($row['title']),
            ]);
            $updatedFile = $service->files->update($row['sync_folderid'], $fileMetadata, [
                'fields' => 'id, name'
            ]);

            // Ghi lại thông tin đã đồng bộ lên CSDL
            $sql = "UPDATE " . NV_PREFIXLANG . "_" . $module_data . "_nodes SET
                sync_lastime=" . NV_CURRENTTIME . "
            WHERE id=" . $row['id'];
            $db->query($sql);

            $line = "success\n";
            echo $line;
            file_put_contents($log_file, $line, FILE_APPEND);
        } catch (Throwable $e) {
            trigger_error(print_r($e, true));

            $line = $e->getMessage() . "\n";
            echo $line;
            file_put_contents($log_file, $line, FILE_APPEND);

            // Đánh dấu lỗi đồng bộ của note
            $sql = "UPDATE " . NV_PREFIXLANG . "_" . $module_data . "_nodes SET sync_lastime=" . NV_CURRENTTIME . ", sync_iserror=" . NV_CURRENTTIME . " WHERE id=" . $row['id'];
            $db->query($sql);

            $sql = "UPDATE " . NV_PREFIXLANG . "_" . $module_data . "_nodes_refs SET sync_messerror=" . $db->quote($e->getMessage()) . " WHERE node_id=" . $row['id'];
            $db->query($sql);
        }
    }
    $result2->closeCursor();
}
$result->closeCursor();

if (empty($num)) {
    echo "Nothing for sync\n";
} else {
    file_put_contents($log_file, "--------------------\n\n", FILE_APPEND);
}

$console_endtime = microtime(true);
$execution_time = getConsoleExecuteTime($console_starttime, $console_endtime);

echo ('Thời gian thực thi: ' . $execution_time . PHP_EOL);
echo ('Tiến trình kết thúc!' . PHP_EOL);

/**
 * @param mixed $handle
 * @param integer $chunkSize
 * @return string
 */
function read_chunk($handle, $chunkSize)
{
    $byteCount = 0;
    $giantChunk = '';
    while (!feof($handle)) {
        $chunk = fread($handle, 8192);
        $byteCount += strlen($chunk);
        $giantChunk .= $chunk;
        if ($byteCount >= $chunkSize) {
            return $giantChunk;
        }
    }
    return $giantChunk;
}
