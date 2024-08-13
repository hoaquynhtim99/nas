<?php

/**
 * NukeViet Content Management System
 * @version 4.x
 * @author VINADES.,JSC <contact@vinades.vn>
 * @copyright (C) 2009-2023 VINADES.,JSC. All rights reserved
 * @license GNU/GPL version 2 or any later version
 * @see https://github.com/nukeviet The NukeViet CMS GitHub project
 */

if (!defined('NV_MAINFILE')) {
    exit('Stop!!!');
}

// FIXME xóa plugin sau khi dev xong giao diện admin_future
nv_add_hook($module_name, 'get_module_admin_theme', $priority, function ($vars) {
    $module_theme = $vars[0];
    $module_name = $vars[1];
    $module_info = $vars[2];
    $op = $vars[3];

    $new_theme = 'admin_future';

    if ($module_name == 'authors' and in_array($op, ['2step', 'main', 'del', 'edit', 'add', 'module', 'config'])) {
        return $new_theme;
    }
    if (($module_info['module_file'] ?? '') == 'news' and in_array($op, ['main'])) {
        return $new_theme;
    }
    if ($module_name == 'siteinfo') {
        return $new_theme;
    }
    if ($module_name == 'siteinfo' and $op == 'notification' and ($_GET['ajax'] ?? 0) == 1 and ($_GET['template'] ?? '') == $new_theme) {
        return $new_theme;
    }
    if ($module_name == 'modules' and in_array($op, ['edit'])) {
        return $new_theme;
    }
    if ($module_name == 'language' and in_array($op, ['region'])) {
        return $new_theme;
    }

    return 'admin_default';
});
