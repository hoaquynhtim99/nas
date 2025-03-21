<?php

/**
 * NukeViet Content Management System
 * @version 4.x
 * @author VINADES.,JSC <contact@vinades.vn>
 * @copyright (C) 2009-2023 VINADES.,JSC. All rights reserved
 * @license GNU/GPL version 2 or any later version
 * @see https://github.com/nukeviet The NukeViet CMS GitHub project
 */

namespace NukeViet\Module\nas\Shared;

use Google\Client;
use Google\Service\Drive;

if (!defined('NV_MAINFILE')) {
    exit('Stop!!!');
}

/**
 * @author Phan Tan Dung
 */
class GoogleDrives
{
    /**
     * Lấy Google\Client và tự làm mới token nếu hết hạn
     *
     * @param array $row
     * @return string|\Google\Client
     */
    public static function getClient(array $row)
    {
        global $module_data, $db;

        try {
            $client = new Client();
            $client->setScopes(Drive::DRIVE);
            $client->setClientId($row['client_id']);
            $client->setClientSecret($row['client_secret']);
            $client->setRedirectUri('http://localhost');

            // 2 cái này bắt buộc để có refresh_token
            $client->setAccessType('offline');
            $client->setPrompt('select_account consent');

            $client->setAccessToken(empty($row['token']) ? [] : json_decode($row['token'], true));

            if ($client->isAccessTokenExpired()) {
                $client->fetchAccessTokenWithRefreshToken($client->getRefreshToken());

                // Cập nhật lại token
                $sql = "UPDATE " . NV_PREFIXLANG . "_" . $module_data . "_api_credentials SET
                    token=" . $db->quote(json_encode($client->getAccessToken(), JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT)) . ",
                    is_setup=1, is_error=0
                WHERE id=" . $row['id'];
                $db->query($sql);
            }
        } catch (\Throwable $e) {
            trigger_error(print_r($e, true));

            // Đánh dấu lỗi làm mới token
            $sql = "UPDATE " . NV_PREFIXLANG . "_" . $module_data . "_api_credentials SET is_error=1 WHERE id=" . $row['id'];
            $db->query($sql);

            return $e->getMessage();
        }

        return $client;
    }
}
