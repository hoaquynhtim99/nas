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

// Thay đổi hoạt động
if ($nv_Request->get_title('changestatus', 'post', '') === NV_CHECK_SESSION) {
    if (!defined('NV_IS_AJAX')) {
        exit('Wrong URL!!!');
    }

    $userid = $nv_Request->get_int('userid', 'post', 0);

    // Kiểm tra tồn tại
    $sql = "SELECT * FROM " . NV_PREFIXLANG . "_" . $module_data . "_users WHERE userid=" . $userid;
    $array = $db->query($sql)->fetch();
    if (empty($array)) {
        nv_jsonOutput([
            'success' => 0,
            'text' => 'User not exists!!!',
        ]);
    }

    $status = empty($array['status']) ? 1 : 0;

    $sql = "UPDATE " . NV_PREFIXLANG . "_" . $module_data . "_users SET status=" . $status . " WHERE userid=" . $userid;
    $db->query($sql);

    nv_insert_logs(NV_LANG_DATA, $module_name, 'STATUS_USER', $userid . ': ' . $status, $admin_info['admin_id']);
    $nv_Cache->delMod($module_name);

    nv_jsonOutput([
        'success' => 1,
        'text' => '',
    ]);
}

// Xóa bỏ 1 hoặc nhiều
if ($nv_Request->get_title('delete', 'post', '') === NV_CHECK_SESSION) {
    if (!defined('NV_IS_AJAX')) {
        exit('Wrong URL!!!');
    }

    $id = $nv_Request->get_int('id', 'post', 0);
    $listid = $nv_Request->get_title('listid', 'post', '');
    $listid = $listid . ',' . $id;
    $listid = array_filter(array_unique(array_map('intval', explode(',', $listid))));

    foreach ($listid as $id) {
        // Kiểm tra tồn tại
        $sql = "SELECT * FROM " . NV_PREFIXLANG . "_" . $module_data . "_users WHERE userid=" . $id;
        $array = $db->query($sql)->fetch();
        if (!empty($array)) {
            nv_insert_logs(NV_LANG_DATA, $module_name, 'DEL_USER', $id, $admin_info['admin_id']);

            // Xóa
            $sql = "DELETE FROM " . NV_PREFIXLANG . "_" . $module_data . "_users WHERE userid=" . $id;
            $db->query($sql);
        }
    }

    $nv_Cache->delMod($module_name);
    nv_jsonOutput([
        'success' => 1,
        'text' => '',
    ]);
}

// Xử lý khi lưu (thêm/sửa)
if ($nv_Request->isset_request('saveform', 'post')) {
    $respon = [
        'status' => 'error',
        'mess' => '',
    ];
    if ($nv_Request->get_title('saveform', 'post', '') !== NV_CHECK_SESSION) {
        $respon['mess'] = 'Session error!';
        nv_jsonOutput($respon);
    }

    $array = [];
    $array['userid'] = $nv_Request->get_absint('userid', 'post', 0);
    $array['username'] = $nv_Request->get_title('username', 'post', '');
    $array['quota_limit'] = $nv_Request->get_title('quota_limit', 'post', '');

    if (!empty($array['userid'])) {
        // Kiểm tra tồn tại khi sửa
        $sql = "SELECT * FROM " . NV_PREFIXLANG . "_" . $module_data . "_users WHERE userid=" . $array['userid'];
        $row = $db->query($sql)->fetch();
        if (empty($row)) {
            $respon['mess'] = 'Error user not exists!';
            nv_jsonOutput($respon);
        }
    } else {
        if (empty($array['username'])) {
            $respon['input'] = 'username';
            $respon['mess'] = $nv_Lang->getModule('user_pick_error');
            nv_jsonOutput($respon);
        }

        // Kiểm tra tồn tại
        $sql = "SELECT * FROM " . NV_USERS_GLOBALTABLE . " WHERE md5username=" . $db->quote(nv_md5safe($array['username']));
        $row = $db->query($sql)->fetch();
        if (empty($row)) {
            $respon['input'] = 'username';
            $respon['mess'] = $nv_Lang->getModule('user_pick_exists');
            nv_jsonOutput($respon);
        }

        // Kiểm tra đã là người dùng được chỉ định
        $sql = "SELECT * FROM " . NV_PREFIXLANG . "_" . $module_data . "_users WHERE userid=" . $row['userid'];
        $user = $db->query($sql)->fetch();
        if (!empty($user)) {
            $respon['input'] = 'username';
            $respon['mess'] = $nv_Lang->getModule('user_pick_exists1');
            nv_jsonOutput($respon);
        }
    }

    if (!empty($array['quota_limit'])) {
        if (!preg_match('/^([0-9\.]+)[\s]*(m|g|t)(b)*$/i', $array['quota_limit'], $m)) {
            $respon['input'] = 'quota_limit';
            $respon['mess'] = $nv_Lang->getModule('quota_limit_error');
            nv_jsonOutput($respon);
        }
        $sizes = [
            'm' => 1048576,
            'g' => 1073741824,
            't' => 1099511627776
        ];
        $array['quota_limit'] = $m[1] * $sizes[strtolower($m[2])];
    } else {
        $array['quota_limit'] = 0;
    }

    if ($array['userid']) {
        nv_insert_logs(NV_LANG_DATA, $module_name, 'ADD_USER', $array['userid'] . ': ' . nv_convertfromBytes($array['quota_limit']), $admin_info['userid']);

        $sql = "UPDATE " . NV_PREFIXLANG . "_" . $module_data . "_users SET
            edit_time=" . NV_CURRENTTIME . ",
            quota_limit=" . $array['quota_limit'] . "
        WHERE userid=" . $array['userid'];
    } else {
        nv_insert_logs(NV_LANG_DATA, $module_name, 'UPDATE_USER', $row['username'] . ': ' . nv_convertfromBytes($array['quota_limit']), $admin_info['userid']);

        $sql = "INSERT INTO " . NV_PREFIXLANG . "_" . $module_data . "_users (
            userid, add_time, quota_limit, status
        ) VALUES (
            " . $row['userid'] . ", " . NV_CURRENTTIME . ", " . $array['quota_limit'] . ", 1
        )";
    }
    $db->query($sql);

    $respon['status'] = 'success';
    $respon['mess'] = $nv_Lang->getGlobal('save_success');
    $respon['refresh'] = 1;
    nv_jsonOutput($respon);
}

$page_title = $nv_Lang->getModule('ulists');

$per_page = 12;
$page = $nv_Request->get_absint('page', 'get', 1);
$base_url = NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name;

// Phần tìm kiếm
$array_search = [];
$array_search['q'] = $nv_Request->get_title('q', 'get', '');

$db->sqlreset()->select('COUNT(tb1.userid)')->from(NV_PREFIXLANG . '_' . $module_data . '_users tb1')
->join('INNER JOIN ' . NV_USERS_GLOBALTABLE . ' tb2 ON tb1.userid=tb2.userid');

$where = [];
if (!empty($array_search['q'])) {
    $base_url .= '&amp;q=' . urlencode($array_search['q']);
    $dblikekey = $db->dblikeescape($array_search['q']);
    $like_name = $global_config['name_show'] == 0 ? "CONCAT(tb2.last_name, ' ', tb2.first_name)" : "CONCAT(tb2.first_name, ' ', tb2.last_name)";
    $where[] = "(
        tb2.username LIKE '%" . $dblikekey . "%' OR
        " . $like_name . " LIKE '%" . $dblikekey . "%' OR
        tb2.email LIKE '%" . $dblikekey . "%'
    )";
}

// Phần sắp xếp
$array_order = [];
$array_order['field'] = $nv_Request->get_title('of', 'get', '');
$array_order['value'] = $nv_Request->get_title('ov', 'get', '');
$base_url_order = $base_url;
if ($page > 1) {
    $base_url_order .= '&amp;page=' . $page;
}

// Định nghĩa các field và các value được phép sắp xếp
$order_fields = ['first_name', 'add_time'];
$order_values = ['asc', 'desc'];
$order_fields_sql = [
    'first_name' => 'tb2.first_name',
    'add_time' => 'tb1.add_time'
];

if (!in_array($array_order['field'], $order_fields)) {
    $array_order['field'] = '';
}
if (!in_array($array_order['value'], $order_values)) {
    $array_order['value'] = '';
}

if (!empty($where)) {
    $db->where(implode(' AND ', $where));
}

$num_items = $db->query($db->sql())->fetchColumn();

if (!empty($array_order['field']) and !empty($array_order['value'])) {
    $order = $order_fields_sql[$array_order['field']] . ' ' . $array_order['value'];
} else {
    $order = 'tb1.userid DESC';
}
$db->select('tb1.*, tb2.username, tb2.first_name, tb2.last_name, tb2.email, tb2.photo')->order($order)->limit($per_page)->offset(($page - 1) * $per_page);
$result = $db->query($db->sql());

$array = [];

while ($row = $result->fetch()) {
    if ($row['quota_limit'] >= 1099511627776) {
        $row['quota_limit_text'] = ($row['quota_limit'] / 1099511627776) . ' TB';
    } elseif ($row['quota_limit'] >= 1073741824) {
        $row['quota_limit_text'] = ($row['quota_limit'] / 1073741824) . ' GB';
    } elseif ($row['quota_limit'] > 0) {
        $row['quota_limit_text'] = ($row['quota_limit'] / 1048576) . ' MB';
    } else {
        $row['quota_limit_text'] = '';
    }
    $row['full_name'] = nv_show_name_user($row['first_name'], $row['last_name']);
    if (!empty($row['photo'])) {
        $row['photo'] = NV_BASE_SITEURL . $row['photo'];
    }
    $row['add_time'] = nv_datetime_format($row['add_time'], 1);
    $row['quota_limit_show'] = $row['quota_limit'] ? nv_convertfromBytes($row['quota_limit']) : '∞';
    $row['quota_current_show'] = nv_convertfromBytes($row['quota_current']);

    $array[$row['userid']] = $row;
}
$result->closeCursor();

$template = get_tpl_dir([$global_config['module_theme'], $global_config['admin_theme']], 'admin_default', '/modules/' . $module_file . '/main.tpl');
$tpl = new \NukeViet\Template\NVSmarty();
$tpl->setTemplateDir(NV_ROOTDIR . '/themes/' . $template . '/modules/' . $module_file);
$tpl->assign('LANG', $nv_Lang);
$tpl->assign('MODULE_NAME', $module_name);
$tpl->assign('OP', $op);

$tpl->assign('DATA', $array);
$tpl->assign('SEARCH', $array_search);
$tpl->assign('PAGINATION', nv_generate_page($base_url, $num_items, $per_page, $page));
$tpl->assign('ARRAY_ORDER', $array_order);
$tpl->assign('BASE_URL_ORDER', $base_url_order);

$contents = $tpl->fetch('main.tpl');

include NV_ROOTDIR . '/includes/header.php';
echo nv_admin_theme($contents);
include NV_ROOTDIR . '/includes/footer.php';
