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

if (!defined('NV_MAINFILE')) {
    exit('Stop!!!');
}

/**
 * @author Phan Tan Dung
 */
class Notices
{
    /**
     * Lưu thông báo trễ cách mỗi 1 ngày
     *
     * @param int $userid
     * @param string $notice_key
     * @param string $subject
     * @param string $message
     * @param string $channel
     */
    public static function save(int $userid, string $notice_key, string $subject, string $message, string $channel = 'email')
    {
        global $module_data, $db;

        $offset_time = NV_CURRENTTIME - 86400;
        try {
            $sql = "SELECT * FROM " . NV_PREFIXLANG . "_" . $module_data . "_users_notices WHERE
            userid=" . $userid . " AND channel=" . $db->quote($channel) . " AND notice_key=" . $db->quote($notice_key) . "
            AND notice_time>" . $offset_time . " LIMIT 1";
            $row = $db->query($sql)->fetch();
            if (!empty($row)) {
                return true;
            }

            $sql = "INSERT INTO " . NV_PREFIXLANG . "_" . $module_data . "_users_notices (
                userid, channel, notice_key, notice_time, subject, message
            ) VALUES (
                " . $userid . ", " . $db->quote($channel) . ", " . $db->quote($notice_key) . ",
                " . NV_CURRENTTIME . ", " . $db->quote($subject) . ", " . $db->quote($message) . "
            )";
            $db->query($sql);
        } catch (\Throwable $e) {
            trigger_error(print_r($e, true));
        }
    }
}
