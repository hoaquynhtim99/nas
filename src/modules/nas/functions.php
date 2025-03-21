<?php

/**
 * NukeViet Content Management System
 * @version 4.x
 * @author VINADES.,JSC <contact@vinades.vn>
 * @copyright (C) 2009-2021 VINADES.,JSC. All rights reserved
 * @license GNU/GPL version 2 or any later version
 * @see https://github.com/nukeviet The NukeViet CMS GitHub project
 */

if (!defined('NV_SYSTEM')) {
    exit('Stop!!!');
}

define('NV_IS_MOD_NAS', true);

require NV_ROOTDIR . '/modules/' . $module_file . '/global.functions.php';
$nas_user = $config_user = $api_google_drive = [];

if (defined('NV_IS_USER')) {
    $sql = "SELECT * FROM " . NV_PREFIXLANG . "_" . $module_data . "_users WHERE userid=" . $user_info['userid'] . " AND status=1";
    $nas_user = $db->query($sql)->fetch();

    if (!empty($nas_user)) {
        define('NAS_USER', true);

        $nas_user['quota_current_show'] = nv_convertfromBytes($nas_user['quota_current']);
        $nas_user['quota_limit_show'] = $nas_user['quota_limit'] > 0 ? nv_convertfromBytes($nas_user['quota_limit']) : '∞';
        if ($nas_user['quota_limit'] <= 0) {
            $nas_user['quota_percent'] = 0;
        } else {
            $nas_user['quota_percent'] = round($nas_user['quota_current'] / $nas_user['quota_limit'] * 100, 2);
        }

        $nas_user['user_dir'] = strtolower($user_info['username']);

        $sql = "SELECT * FROM " . NV_AUTHORS_GLOBALTABLE . " WHERE admin_id=" . $user_info['userid'] . " AND is_suspend=0";
        $nas_user['admin_info'] = $db->query($sql)->fetch() ?: [];
    }

    // Thiết lập của user
    $sql = "SELECT * FROM " . NV_PREFIXLANG . "_" . $module_data . "_users_config WHERE userid=" . $user_info['userid'];
    $result = $db->query($sql);
    while ($row = $result->fetch()) {
        $config_user[$row['config_name']] = $row['config_value'];
    }
    $result->closeCursor();

    // API Google của user
    $sql = "SELECT * FROM " . NV_PREFIXLANG . "_" . $module_data . "_api_credentials WHERE userid=" . $user_info['userid'] . " AND is_setup=1 ORDER BY title ASC";
    $result = $db->query($sql);
    while ($row = $result->fetch()) {
        $api_google_drive[$row['id']] = $row;
    }
    $result->closeCursor();
}

// Danh sách các ứng dụng
$array_apps = [];
$array_apps['file-zone'] = $nv_Lang->getModule('app_fzone');

if (!empty($module_config[$module_name]['websocket_url'])) {
    $array_apps['rtc-transfer'] = $nv_Lang->getModule('app_rtct');
}

if (defined('NAS_USER')) {
    $array_apps['file-manager'] = $nv_Lang->getModule('app_fmanager');
    //$array_apps['music-player'] = $nv_Lang->getModule('app_muplayer');
    //$array_apps['video-player'] = $nv_Lang->getModule('app_vdplayer');
    $array_apps['drive-connect'] = $nv_Lang->getModule('app_drivecnt');
} elseif ($op != 'main' and defined('NV_IS_USER')) {
    $op_file = 'main';
    $contents = nv_theme_alert($nv_Lang->getModule('ui_not_nasuser'), $nv_Lang->getModule('ui_not_nasuser_content'));
    include NV_ROOTDIR . '/includes/header.php';
    echo nv_site_theme($contents);
    include NV_ROOTDIR . '/includes/footer.php';
}

/**
 * @param string $contents
 * @return string
 */
function nv_nas_theme(?string $contents)
{
    global $nv_Lang, $global_config, $page_url, $module_name, $user_info, $array_apps, $home, $nas_user, $op;

    $tpl = new \NukeViet\Template\NVSmarty();
    $tpl->setTemplateDir(get_module_tpl_dir('theme.tpl'));
    $tpl->assign('LANG', $nv_Lang);
    $tpl->assign('MODULE_CONTENTS', $contents);
    $tpl->assign('GCONFIG', $global_config);
    $tpl->assign('MODULE_NAME', $module_name);
    $tpl->assign('HOME', $home);
    $tpl->assign('OP', $op);

    // Thanh topbar
    if (!defined('NV_IS_USER')) {
        if (empty($page_url)) {
            $nv_redirect = NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name;
        } else {
            $nv_redirect = $page_url;
        }
        $tpl->assign('LOGIN_LINK', NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=users&amp;' . NV_OP_VARIABLE . '=login&amp;nv_redirect=' . nv_redirect_encrypt(nv_url_rewrite($nv_redirect)));
    } else {
        $tpl->assign('USER', $user_info);
        $tpl->assign('NUSER', $nas_user);
    }

    $tpl->assign('ARRAY_APPS', $array_apps);

    return $tpl->fetch('theme.tpl');
}
