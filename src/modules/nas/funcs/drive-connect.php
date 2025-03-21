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

use Google\Client;
use Google\Service\Drive;
use NukeViet\Module\nas\Shared\GoogleDrives;

$page_title = $nv_Lang->getModule('drconnect');
$key_words = $description = 'no';
$nv_BotManager->setPrivate();
$page_url = NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=' . $op;
if (!defined('NV_IS_USER')) {
    $url = NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=users&amp;' . NV_OP_VARIABLE . '=login&amp;nv_redirect=' . nv_redirect_encrypt(nv_url_rewrite($page_url, true));
    nv_redirect_location($url);
}

// Lấy AuthUrl để thiết lập kết nối
if ($nv_Request->isset_request('setuptoken', 'post')) {
    if ($nv_Request->get_title('checkss', 'post', '') != NV_CHECK_SESSION) {
        nv_jsonOutput([
            'success' => 0,
            'text' => 'Wrong session!!!'
        ]);
    }

    $id = $nv_Request->get_absint('setuptoken', 'post', 0);

    $sql = "SELECT * FROM " . NV_PREFIXLANG . "_" . $module_data . "_api_credentials WHERE id=" . $id . " AND userid=" . $user_info['userid'];
    $row = $db->query($sql)->fetch();
    if (empty($row)) {
        nv_jsonOutput([
            'success' => 0,
            'text' => 'Not exists!!!'
        ]);
    }

    try {
        $client = new Client();
        $client->setScopes(Drive::DRIVE);
        $client->setClientId($row['client_id']);
        $client->setClientSecret($row['client_secret']);
        $client->setRedirectUri('http://localhost');

        // 2 cái này bắt buộc để có refresh_token
        $client->setAccessType('offline');
        $client->setPrompt('select_account consent');

        $authUrl = $client->createAuthUrl();
    } catch (Throwable $e) {
        trigger_error(print_r($e, true));
        nv_jsonOutput([
            'success' => 0,
            'text' => $e->getMessage()
        ]);
    }

    nv_jsonOutput([
        'success' => 1,
        'authUrl' => $authUrl,
        'id' => $row['id'],
        'title' => $nv_Lang->getModule('drconnect_tip1') . ': ' . $row['title']
    ]);
}

// Lưu token
if ($nv_Request->isset_request('savetoken', 'post')) {
    $respon = [
        'status' => 'error',
        'mess' => '',
    ];
    if ($nv_Request->get_title('checkss', 'post', '') != NV_CHECK_SESSION) {
        $respon['mess'] = 'Wrong session!!!';
        nv_jsonOutput($respon);
    }

    $id = $nv_Request->get_absint('savetoken', 'post', 0);

    $sql = "SELECT * FROM " . NV_PREFIXLANG . "_" . $module_data . "_api_credentials WHERE id=" . $id . " AND userid=" . $user_info['userid'];
    $row = $db->query($sql)->fetch();
    if (empty($row)) {
        $respon['mess'] = 'Not exists!!!';
        nv_jsonOutput($respon);
    }

    $verification_code = $nv_Request->get_string('verification_code', 'post', '');
    if (empty($verification_code)) {
        $respon['input'] = 'verification_code';
        $respon['mess'] = $nv_Lang->getGlobal('required_invalid');
        nv_jsonOutput($respon);
    }

    try {
        $client = new Client();
        $client->setScopes(Drive::DRIVE);
        $client->setClientId($row['client_id']);
        $client->setClientSecret($row['client_secret']);
        $client->setRedirectUri('http://localhost');

        // 2 cái này bắt buộc để có refresh_token
        $client->setAccessType('offline');
        $client->setPrompt('select_account consent');

        $accessToken = $client->fetchAccessTokenWithAuthCode($verification_code);
        if (!empty($accessToken['error'])) {
            $respon['mess'] = $accessToken['error'];
            nv_jsonOutput($respon);
        }

        // Thiếu refresh_token
        if (empty($accessToken['refresh_token'])) {
            $respon['mess'] = $nv_Lang->getModule('drconnect_e_refresh_token');
            nv_jsonOutput($respon);
        }

        $client->setAccessToken($accessToken);

        $sql = "UPDATE " . NV_PREFIXLANG . "_" . $module_data . "_api_credentials SET
            token=" . $db->quote(json_encode($client->getAccessToken(), JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT)) . ",
            is_setup=1, is_error=0
        WHERE id=" . $id;
        $db->query($sql);
    } catch (Throwable $e) {
        trigger_error(print_r($e, true));
        $respon['mess'] = $e->getMessage();
        nv_jsonOutput($respon);
    }

    $respon['status'] = 'success';
    $respon['refresh'] = true;
    $respon['mess'] = $nv_Lang->getModule('drconnect_test_success');
    nv_jsonOutput($respon);
}

// Xóa App
if ($nv_Request->isset_request('delete', 'post')) {
    if ($nv_Request->get_title('checkss', 'post', '') != NV_CHECK_SESSION) {
        nv_jsonOutput([
            'success' => 0,
            'text' => 'Wrong session!!!'
        ]);
    }

    $id = $nv_Request->get_absint('delete', 'post', 0);

    $sql = "SELECT * FROM " . NV_PREFIXLANG . "_" . $module_data . "_api_credentials WHERE id=" . $id . " AND userid=" . $user_info['userid'];
    $row = $db->query($sql)->fetch();
    if (empty($row)) {
        nv_jsonOutput([
            'success' => 0,
            'text' => 'Not exists!!!'
        ]);
    }

    $sql = "DELETE FROM " . NV_PREFIXLANG . "_" . $module_data . "_api_credentials WHERE id=" . $id;
    $db->query($sql);

    nv_jsonOutput([
        'success' => 1,
        'text' => 'Success!!!'
    ]);
}

// Kiểm tra kết nối
if ($nv_Request->isset_request('testconnect', 'post')) {
    if ($nv_Request->get_title('checkss', 'post', '') != NV_CHECK_SESSION) {
        nv_jsonOutput([
            'success' => 0,
            'text' => 'Wrong session!!!'
        ]);
    }

    $id = $nv_Request->get_absint('testconnect', 'post', 0);

    $sql = "SELECT * FROM " . NV_PREFIXLANG . "_" . $module_data . "_api_credentials WHERE id=" . $id . " AND userid=" . $user_info['userid'];
    $row = $db->query($sql)->fetch();
    if (empty($row)) {
        nv_jsonOutput([
            'success' => 0,
            'text' => 'Not exists!!!'
        ]);
    }

    $client = GoogleDrives::getClient($row);
    if (is_string($client)) {
        nv_jsonOutput([
            'success' => 0,
            'text' => $client
        ]);
    }

    try {
        $service = new Drive($client);
        $q = [];
        $q[] = "mimeType='application/vnd.google-apps.folder'";
        $q[] = "trashed=false";
        $q[] = "'root' in parents";

        $optParams = [
            'pageSize' => 1, // Max có thể là 1000
            'fields' => 'files(id,name,createdTime)',
            'orderBy' => 'name asc',
            'q' => implode(' and ', $q)
        ];
        $results = $service->files->listFiles($optParams);
        $files = $results->getFiles();
    } catch (Throwable $e) {
        trigger_error(print_r($e, true));

        $json = json_decode(trim($e->getMessage()), true);

        // Lỗi liên quan token
        if (
            preg_match('/Token[\s]*has[\s]*been[\s]*expired[\s]*or[\s]*revoked/i', $e->getMessage()) or
            (is_array($json) and (
            (!empty($json['error']) and $json['error'] == 'invalid_grant')
        ))) {
            $sql = "UPDATE " . NV_PREFIXLANG . "_" . $module_data . "_api_credentials SET is_error=1 WHERE id=" . $id;
            $db->query($sql);
        }

        nv_jsonOutput([
            'success' => 0,
            'text' => $e->getMessage()
        ]);
    }

    nv_jsonOutput([
        'success' => 1,
        'text' => $nv_Lang->getModule('drconnect_test_success')
    ]);
}

// Thêm/sửa API APP
if ($nv_Request->isset_request('checkss', 'post')) {
    $respon = [
        'status' => 'error',
        'mess' => '',
    ];
    if ($nv_Request->get_title('checkss', 'post', '') != NV_CHECK_SESSION) {
        $respon['mess'] = 'Wrong session!!!';
        nv_jsonOutput($respon);
    }

    $array = [];
    $array['id'] = $nv_Request->get_absint('id', 'post', 0);
    $array['title'] = nv_substr($nv_Request->get_title('title', 'post', ''), 0, 100);
    $array['client_id'] = nv_substr($nv_Request->get_title('client_id', 'post', ''), 0, 200);
    $array['client_secret'] = nv_substr($nv_Request->get_title('client_secret', 'post', ''), 0, 200);

    if ($array['id']) {
        $sql = "SELECT * FROM " . NV_PREFIXLANG . "_" . $module_data . "_api_credentials WHERE id=" . $array['id'] . " AND userid=" . $user_info['userid'];
        $row_old = $db->query($sql)->fetch();
        if (empty($row_old)) {
            $respon['mess'] = 'Not exists!!!';
            nv_jsonOutput($respon);
        }
    }

    $keys = ['title', 'client_id', 'client_secret'];
    foreach ($keys as $key) {
        if (empty($array[$key])) {
            $respon['input'] = $key;
            $respon['mess'] = $nv_Lang->getGlobal('required_invalid');
            nv_jsonOutput($respon);
        }
    }

    // Kiểm tra trùng tiêu đề
    $sql = "SELECT * FROM " . NV_PREFIXLANG . "_" . $module_data . "_api_credentials
    WHERE userid=" . $user_info['userid'] . " AND title=" . $db->quote($array['title']);
    if ($array['id']) {
        $sql .= " AND id!=" . $array['id'];
    }
    $row = $db->query($sql)->fetch();
    if (!empty($row)) {
        $respon['input'] = 'title';
        $respon['mess'] = $nv_Lang->getModule('drconnect_e_title');
        nv_jsonOutput($respon);
    }

    if ($array['id']) {
        $reset = ($row_old['client_id'] != $array['client_id'] or $row_old['client_secret'] != $array['client_secret']);
        $sql = "UPDATE " . NV_PREFIXLANG . "_" . $module_data . "_api_credentials SET
            title=" . $db->quote($array['title']) . ",
            client_id=" . $db->quote($array['client_id']) . ",
            client_secret=" . $db->quote($array['client_secret']) . ",
            edit_time=" . NV_CURRENTTIME;
        if ($reset) {
            $sql .= ", token=null, is_setup=0, is_error=0";
        }
        $sql .= " WHERE id=" . $array['id'];
    } else {
        $sql = "INSERT INTO " . NV_PREFIXLANG . "_" . $module_data . "_api_credentials (
            userid, add_time, edit_time, title, client_id, client_secret
        ) VALUES (
            " . $user_info['userid'] . ", " . NV_CURRENTTIME . ", " . NV_CURRENTTIME . ",
            " . $db->quote($array['title']) . ", " . $db->quote($array['client_id']) . ",
            " . $db->quote($array['client_secret']) . "
        )";
    }
    try {
        $db->query($sql);
    } catch (Throwable $e) {
        trigger_error(print_r($e, true));
        $respon['mess'] = $e->getMessage();
        nv_jsonOutput($respon);
    }

    $respon['status'] = 'success';
    $respon['refresh'] = true;
    $respon['mess'] = $nv_Lang->getGlobal('save_success');
    nv_jsonOutput($respon);
}

$tpl = new \NukeViet\Template\NVSmarty();
$tpl->assign('LANG', $nv_Lang);
$tpl->assign('MODULE_NAME', $module_name);
$tpl->assign('OP', $op);
$tpl->assign('GCONFIG', $global_config);
$tpl->assign('ARRAY_APPS', $array_apps);

$sql = "SELECT * FROM " . NV_PREFIXLANG . "_" . $module_data . "_api_credentials WHERE userid=" . $user_info['userid'] . " ORDER BY id DESC";
$result = $db->query($sql);

$array = [];
while ($row = $result->fetch()) {
    $array[] = $row;
}
$result->closeCursor();
$tpl->assign('ARRAY', $array);

$canonicalUrl = getCanonicalUrl($page_url);

$tpl->setTemplateDir(get_module_tpl_dir('drive-connect.tpl'));
$contents = $tpl->fetch('drive-connect.tpl');

include NV_ROOTDIR . '/includes/header.php';
echo nv_site_theme(nv_nas_theme($contents));
include NV_ROOTDIR . '/includes/footer.php';
