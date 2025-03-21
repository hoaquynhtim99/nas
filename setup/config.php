<?php

/**
 * NukeViet Content Management System
 * @version 4.x
 * @author VINADES.,JSC <contact@vinades.vn>
 * @copyright (C) 2009-2024 VINADES.,JSC. All rights reserved
 * @license GNU/GPL version 2 or any later version
 * @see https://github.com/nukeviet The NukeViet CMS GitHub project
 */

if (!defined('NV_MAINFILE')) {
    exit('Stop!!!');
}

if (NV_ROOTDIR == '/var/www/html') {
    // Docker
    $db_config['dbhost'] = 'db';
} else {
    // Xampp windows
    $db_config['dbhost'] = '127.0.0.1';
}
$db_config['dbport'] = '';
$db_config['dbname'] = 'nv50_nas';
$db_config['dbsystem'] = 'nv50_nas';
$db_config['dbuname'] = 'root';
$db_config['dbpass'] = '';
$db_config['dbtype'] = 'mysql';
$db_config['collation'] = 'utf8mb4_unicode_ci';
$db_config['charset'] = 'utf8mb4';
$db_config['persistent'] = false;
$db_config['prefix'] = 'nv5';

$global_config['site_domain'] = '';
$global_config['name_show'] = 0;
$global_config['idsite'] = 0;
$global_config['sitekey'] = 'aaskifrelyvsweht67tgc2cigs3p2lqs';// Do not change sitekey!
$global_config['hashprefix'] = '{SSHA512}';
$global_config['cached'] = 'files';
$global_config['session_handler'] = 'files';
$global_config['extension_setup'] = 3; // 0: No, 1: Upload, 2: NukeViet Store, 3: Upload + NukeViet Store
$global_config['core_cdn_url'] = 'https://cdn.jsdelivr.net/gh/nukeviet/nukeviet@nukeviet5.0/src/';
$global_config['nat_ports'] = [];
// Readmore: https://wiki.nukeviet.vn/nukeviet4:advanced_setting:file_config

define('SKIP_MY_CAPTCHA', true);

// Thư mục data (đường dẫn tuyệt đối)
define('NAS_DIR', 'E:/nas');
