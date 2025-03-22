<?php

/**
 * NukeViet Content Management System
 * @version 4.x
 * @author VINADES.,JSC <contact@vinades.vn>
 * @copyright (C) 2009-2023 VINADES.,JSC. All rights reserved
 * @license GNU/GPL version 2 or any later version
 * @see https://github.com/nukeviet The NukeViet CMS GitHub project
 */

if (!defined('NV_IS_CONSOLE')) {
    die('Stop!!!');
}

$_SERVER['HTTP_HOST'] = 'blanas.local';
$_SERVER['HTTPS'] = 'on';

$_SERVER['SERVER_NAME'] = 'localhost';
$_SERVER['SERVER_PROTOCOL'] = 'http';
$_SERVER['REQUEST_URI'] = '';
$_SERVER['SERVER_PORT'] = '80';
$_SERVER['PHP_SELF'] = '';
$_SERVER['HTTP_CLIENT_IP'] = '127.0.0.1';
$_SERVER['REMOTE_ADDR'] = '127.0.0.1';
$_SERVER['SERVER_SOFTWARE'] = 'Litespeed';
$_SERVER['HTTP_USER_AGENT'] = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/97.0.4692.99 Safari/537.36';

// Dùng để tùy chỉnh giờ
//$_SERVER['REQUEST_TIME'] = 1589907600;

$_GET['language'] = 'vi';

define('NV_IS_LOCAL_CONSOLE', true);

/**
 * @param double $start
 * @param double $end
 * @return string
 */
function getConsoleExecuteTime($start, $end)
{
    $times = ($end - $start) * 1000;
    if ($times < 1000) {
        return (intval($times) . 'ms');
    }
    $times = intval($times / 1000);
    return nv_convertfromSec($times);
}
