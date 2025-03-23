<?php

/**
 * NukeViet Content Management System
 * @version 5.x
 * @author VINADES.,JSC <contact@vinades.vn>
 * @copyright (C) 2009-2025 VINADES.,JSC. All rights reserved
 * @license GNU/GPL version 2 or any later version
 * @see https://github.com/nukeviet The NukeViet CMS GitHub project
 */

if (!defined('NV_MAINFILE')) {
    exit('Stop!!!');
}

// Thư mục data (đường dẫn tuyệt đối)
define('NAS_DIR', '/var/www/private/nas');

$db_config['dbhost'] = 'db';
$db_config['dbport'] = '';
$db_config['dbname'] = 'nas';
$db_config['dbsystem'] = 'nas';
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
$global_config['sitekey'] = '6df3218bb3329eac2d962e2212936ed3';// Do not change sitekey!
$global_config['hashprefix'] = '{SSHA512}';
$global_config['cached'] = 'files';
$global_config['session_handler'] = 'files';
$global_config['extension_setup'] = 3; // 0: No, 1: Upload, 2: NukeViet Store, 3: Upload + NukeViet Store
$global_config['core_cdn_url'] = 'https://cdn.jsdelivr.net/gh/nukeviet/nukeviet@nukeviet5.0/src/';
$global_config['nat_ports'] = [];
// Readmore: https://wiki.nukeviet.vn/nukeviet4:advanced_setting:file_config
