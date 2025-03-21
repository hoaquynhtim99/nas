<?php

/**
 * NukeViet Content Management System
 * @version 4.x
 * @author VINADES.,JSC <contact@vinades.vn>
 * @copyright (C) 2009-2021 VINADES.,JSC. All rights reserved
 * @license GNU/GPL version 2 or any later version
 * @see https://github.com/nukeviet The NukeViet CMS GitHub project
 */

if (!defined('NV_ADMIN') or !defined('NV_MAINFILE')) {
    exit('Stop!!!');
}

$module_version = [
    'name' => 'BlaNAS',
    'modfuncs' => 'file-zone,rtc-transfer,drive-connect,file-manager,main',
    'submenu' => 'file-zone,rtc-transfer,drive-connect,file-manager',
    'is_sysmod' => 0,
    'virtual' => 1,
    'version' => '4.6.00',
    'date' => 'Saturday, August 31, 2024 10:46:20 AM GMT+07:00',
    'author' => 'PHAN TAN DUNG <writeblabla@gmail.com>',
    'note' => 'Phần mềm quản lý chia sẻ ổ cứng trên không gian mạng',
    'uploads_dir' => [
        $module_upload
    ]
];
