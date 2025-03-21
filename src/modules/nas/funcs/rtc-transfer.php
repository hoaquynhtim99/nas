<?php

/**
 * NukeViet Content Management System
 * @version 4.x
 * @author VINADES.,JSC <contact@vinades.vn>
 * @copyright (C) 2009-2021 VINADES.,JSC. All rights reserved
 * @license GNU/GPL version 2 or any later version
 * @see https://github.com/nukeviet The NukeViet CMS GitHub project
 */

if (!defined('NV_IS_MOD_NAS')) {
    exit('Stop!!!');
}

$page_title = $nv_Lang->getModule('app_rtct');
$key_words = $description = 'no';
$nv_BotManager->setPrivate();
$page_url = NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=' . $op;

$room = $array_op[1] ?? '';
if (!empty($room) and !preg_match('/^[0-9a-z]{4}$/', $room)) {
    $room = '';
}

if (!empty($room)) {
    $page_url .= '/' . $room;
}

$canonicalUrl = getCanonicalUrl($page_url);

$config = $module_config[$module_name];
$config['ice_servers'] = empty($config['ice_servers']) ? [] : json_decode($config['ice_servers'], true);
if (!is_array($config['ice_servers'])) {
    $config['ice_servers'] = [];
}

$tpl = new \NukeViet\Template\NVSmarty();
$tpl->assign('LANG', $nv_Lang);
$tpl->assign('MODULE_NAME', $module_name);
$tpl->assign('OP', $op);
$tpl->assign('GCONFIG', $global_config);
$tpl->assign('ARRAY_APPS', $array_apps);
$tpl->assign('ROOM', $room);
$tpl->assign('USER', $user_info ?? []);
$tpl->assign('CONFIG', $config);

// Xử lý STUN/TURN server
if (!empty($room)) {
    $iceServers = [];
    if (!empty($config['turn_enabled']) and (!empty($config['turn_public']) or defined('NV_IS_USER'))) {
        // Coturn
        if ($config['turn_type'] == 1 and !empty($config['coturn_server'])) {
            if ($config['coturn_auth'] == 1 and !empty($config['coturn_secret'])) {
                // Short-Term Credentials
                $user = (time() + $config['coturn_live']) . ':' . nv_genpass(6);
                $iceServers[] = [
                    'urls' => [
                        ('stun:' . $config['coturn_server']),
                        ('turn:' . $config['coturn_server'])
                    ],
                    'username' => $user,
                    'credential' => base64_encode(hash_hmac('sha1', $user, $config['coturn_secret'], true))
                ];
            }
            if ($config['coturn_auth'] == 0 and !empty($config['coturn_user']) and !empty($config['coturn_pass'])) {
                // Long-Term credentials
                $iceServers[] = [
                    'urls' => [
                        ('stun:' . $config['coturn_server']),
                        ('turn:' . $config['coturn_server'])
                    ],
                    'username' => $config['coturn_user'],
                    'credential' => $config['coturn_pass']
                ];
            }
        }
        // ICE server
        if ($config['turn_type'] == 0 and !empty($config['ice_servers'])) {
            foreach ($config['ice_servers'] as $value) {
                if (!empty($value['username']) and !empty($value['credential'])) {
                    $iceServers[] = $value;
                } else {
                    $iceServers[] = [
                        'urls' => $value['urls']
                    ];
                }
            }
        }
    }
    $iceServers = empty($iceServers) ? '' : str_replace('"', '&quot;', json_encode($iceServers));
    $tpl->assign('ICESERVERS', $iceServers);
}

$tpl->setTemplateDir(get_module_tpl_dir('rtc-transfer.tpl'));
$contents = $tpl->fetch('rtc-transfer.tpl');

include NV_ROOTDIR . '/includes/header.php';
echo nv_site_theme(nv_nas_theme($contents));
include NV_ROOTDIR . '/includes/footer.php';
