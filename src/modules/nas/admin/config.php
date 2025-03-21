<?php

/**
 * NukeViet Content Management System
 * @version 4.x
 * @author VINADES.,JSC <contact@vinades.vn>
 * @copyright (C) 2009-2021 VINADES.,JSC. All rights reserved
 * @license GNU/GPL version 2 or any later version
 * @see https://github.com/nukeviet The NukeViet CMS GitHub project
 */

if (!defined('NV_IS_FILE_ADMIN')) {
    exit('Stop!!!');
}

$page_title = $nv_Lang->getModule('config');

// Tính dung lượng hệ thống tự động
if ($nv_Request->get_title('getquota', 'post', '') === NV_CHECK_SESSION) {
    if (!defined('NV_IS_AJAX')) {
        exit('Wrong URL!!!');
    }

    if (!function_exists('disk_free_space')) {
        nv_jsonOutput([
            'success' => 0,
            'text' => $nv_Lang->getModule('system_quota_no'),
        ]);
    }
    $space = disk_free_space(NAS_DIR);
    if ($space === false) {
        nv_jsonOutput([
            'success' => 0,
            'text' => $nv_Lang->getModule('system_quota_no'),
        ]);
    }

    if ($space >= 1099511627776) {
        $space = round($space / 1099511627776, 2) . ' TB';
    } elseif ($space >= 1073741824) {
        $space = round($space / 1073741824, 2) . ' GB';
    } elseif ($space > 0) {
        $space = round($space / 1048576, 2) . ' MB';
    } else {
        $space = '';
    }
    nv_jsonOutput([
        'success' => 1,
        'text' => $space,
    ]);
}

// Xử lý khi lưu
if ($nv_Request->isset_request('checkss', 'post')) {
    $respon = [
        'status' => 'error',
        'mess' => '',
    ];
    if ($nv_Request->get_title('checkss', 'post', '') !== NV_CHECK_SESSION) {
        $respon['mess'] = 'Session error!';
        nv_jsonOutput($respon);
    }

    $array = [];
    $array['system_quota'] = $nv_Request->get_title('system_quota', 'post', '');
    if (!empty($array['system_quota'])) {
        if (!preg_match('/^([0-9\.]+)[\s]*(m|g|t)(b)*$/i', $array['system_quota'], $m)) {
            $respon['input'] = 'system_quota';
            $respon['mess'] = $nv_Lang->getModule('quota_limit_error');
            nv_jsonOutput($respon);
        }
        $sizes = [
            'm' => 1048576,
            'g' => 1073741824,
            't' => 1099511627776
        ];
        $array['system_quota'] = $m[1] * $sizes[strtolower($m[2])];
    } else {
        $array['system_quota'] = '';
    }

    $array['websocket_url'] = $nv_Request->get_title('websocket_url', 'post', '');

    $array['turn_enabled'] = (int) $nv_Request->get_bool('turn_enabled', 'post', false);
    $array['turn_type'] = $nv_Request->get_int('turn_type', 'post', 0);
    if (!in_array($array['turn_type'], [0, 1])) {
        $respon['mess'] = 'turn_type error!';
        $respon['input'] = 'turn_type';
        nv_jsonOutput($respon);
    }

    $array['coturn_auth'] = $nv_Request->get_int('coturn_auth', 'post', 0);
    if (!in_array($array['coturn_auth'], [0, 1])) {
        $respon['mess'] = 'coturn_auth error!';
        $respon['input'] = 'coturn_auth';
        nv_jsonOutput($respon);
    }

    $array['coturn_server'] = nv_substr($nv_Request->get_title('coturn_server', 'post', ''), 0, 200);
    $array['coturn_user'] = nv_substr($nv_Request->get_title('coturn_user', 'post', ''), 0, 200);
    $array['coturn_pass'] = nv_substr($nv_Request->get_title('coturn_pass', 'post', ''), 0, 200);
    $array['coturn_secret'] = nv_substr($nv_Request->get_title('coturn_secret', 'post', ''), 0, 200);

    $array['coturn_live'] = $nv_Request->get_int('coturn_live', 'post', 0);
    if ($array['coturn_live'] < 1 or $array['coturn_live'] > 999999) {
        $respon['mess'] = 'coturn_live error!';
        $respon['input'] = 'coturn_live';
        nv_jsonOutput($respon);
    }

    // Xử lý cấu hình ICE Servers
    $ice_username = $nv_Request->get_typed_array('ice_username', 'post', 'title', []);
    $ice_credential = $nv_Request->get_typed_array('ice_credential', 'post', 'title', []);
    $ice_urls = $nv_Request->get_typed_array('ice_urls', 'post', 'title', []);
    $array['ice_servers'] = [];

    foreach ($ice_urls as $key => $urls) {
        $urls = nv_nl2br($urls, '<<>>');
        $urls = array_filter(array_unique(array_map('trim', explode('<<>>', $urls))));
        if (!empty($urls)) {
            $array['ice_servers'][] = [
                'username' => $ice_username[$key] ?? '',
                'credential' => $ice_credential[$key] ?? '',
                'urls' => $urls
            ];
        }
    }
    $array['ice_servers'] = empty($array['ice_servers']) ? '' : json_encode($array['ice_servers'], JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);

    $array['turn_public'] = (int) $nv_Request->get_bool('turn_public', 'post', false);

    $sth = $db->prepare("UPDATE " . NV_CONFIG_GLOBALTABLE . " SET config_value = :config_value WHERE lang = '" . NV_LANG_DATA . "' AND module = :module_name AND config_name = :config_name");
    $sth->bindParam(':module_name', $module_name, PDO::PARAM_STR);

    foreach ($array as $config_name => $config_value) {
        $sth->bindParam(':config_name', $config_name, PDO::PARAM_STR);
        $sth->bindParam(':config_value', $config_value, PDO::PARAM_STR);
        $sth->execute();
    }

    nv_insert_logs(NV_LANG_DATA, $module_name, 'CONFIG', json_encode($array, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE), $admin_info['admin_id']);
    $nv_Cache->delMod('settings');
    $nv_Cache->delMod($module_name);

    $respon['status'] = 'success';
    $respon['mess'] = $nv_Lang->getGlobal('save_success');
    $respon['redirect'] = NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=' . $op . '&rand=' . nv_genpass();
    nv_jsonOutput($respon);
}

$array = $module_config[$module_name];

$template = get_tpl_dir([$global_config['module_theme'], $global_config['admin_theme']], 'admin_default', '/modules/' . $module_file . '/config.tpl');
$tpl = new \NukeViet\Template\NVSmarty();
$tpl->setTemplateDir(NV_ROOTDIR . '/themes/' . $template . '/modules/' . $module_file);
$tpl->assign('LANG', $nv_Lang);
$tpl->assign('MODULE_NAME', $module_name);
$tpl->assign('OP', $op);

// Đổi dung lượng hiển thị
$array['system_quota'] = intval($array['system_quota']);
if ($array['system_quota'] >= 1099511627776) {
    $array['system_quota'] = round(($array['system_quota'] / 1099511627776), 2) . ' TB';
} elseif ($array['system_quota'] >= 1073741824) {
    $array['system_quota'] = round(($array['system_quota'] / 1073741824), 2) . ' GB';
} elseif ($array['system_quota'] > 0) {
    $array['system_quota'] = round(($array['system_quota'] / 1048576), 2) . ' MB';
} else {
    $array['system_quota'] = '';
}

$array['ice_servers'] = empty($array['ice_servers']) ? [] : json_decode($array['ice_servers'], true);
if (empty($array['ice_servers'])) {
    $array['ice_servers'][] = [
        'username' => '',
        'credential' => '',
        'urls' => []
    ];
}

$tpl->assign('DATA', $array);

$contents = $tpl->fetch('config.tpl');

include NV_ROOTDIR . '/includes/header.php';
echo nv_admin_theme($contents);
include NV_ROOTDIR . '/includes/footer.php';
