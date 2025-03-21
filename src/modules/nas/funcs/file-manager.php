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

use NukeViet\Module\nas\Download;
use NukeViet\Module\nas\Shared\Drives;
use NukeViet\Module\nas\Shared\FileOrders;
use NukeViet\Module\nas\Shared\FileTypes;
use NukeViet\Module\nas\Shared\Nodes;

$page_title = $nv_Lang->getModule('app_fmanager');
$key_words = $module_info['keywords'];
$description = $module_info['description'];
$nv_BotManager->setPrivate();

$page_url = NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=' . $op;

// Tải tập tin của mình hoặc tệp tin được public trên zone
if (isset($array_op[2]) and $array_op[1] == 'd' and preg_match('/^[0-9]+$/', $array_op[2])) {
    $id = intval($array_op[2]);

    $where = [];
    $where[] = 'id=' . $id;
    $where[] = 'trash=0';
    $where[] = 'is_tmp=0';
    $where[] = 'trash_parent=0';
    $where[] = 'node_type=0';

    $where_or = [];
    // Tải tệp của mình hoặc chia sẻ với mình
    if (defined('NV_IS_USER')) {
        $where_or[] = "(userid=" . $user_info['userid'] . " OR FIND_IN_SET(" . $user_info['userid'] . ", shared_users))";
    }
    // Tải tệp được public lên zone
    $where_or[] = "(zoned_time=-1 OR zoned_time>" . NV_CURRENTTIME . ")";
    $where[] = '(' . implode(' OR ', $where_or) . ')';

    $sql = "SELECT * FROM " . NV_PREFIXLANG . "_" . $module_data . "_nodes WHERE " . implode(' AND ', $where);
    $node = $db->query($sql)->fetch();
    if (empty($node)) {
        nv_error404();
    }

    // Tìm dir nếu như nó không phải là file của mình
    if (!defined('NV_IS_USER') or $node['userid'] != $user_info['userid']) {
        $sql = "SELECT username FROM " . NV_USERS_GLOBALTABLE . " WHERE userid=" . $node['userid'];
        $username = $db->query($sql)->fetchColumn() ?: '';
        if (empty($username) or !preg_match('/^[a-zA-Z0-9]+$/i', $username)) {
            nv_error404();
        }
        $node_rootdir = strtolower($username);
    } else {
        $node_rootdir = $nas_user['user_dir'];
    }

    $path = NAS_DIR . '/' . $node_rootdir . '/' . $node['path'];
    if (!file_exists($path)) {
        nv_error404();
    }
    $file_name = change_alias($node['title']) . '.' . $node['node_ext'];

    $download = new Download($path, $file_name);
    $download->download_file();
    exit();
}

if (!defined('NV_IS_USER')) {
    $url = NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=users&amp;' . NV_OP_VARIABLE . '=login&amp;nv_redirect=' . nv_redirect_encrypt(nv_url_rewrite($page_url, true));
    nv_redirect_location($url);
}

// Lấy hết cây thư mục của tôi;
$sql = "SELECT * FROM " . NV_PREFIXLANG . "_" . $module_data . "_nodes WHERE userid=" . $user_info['userid'] . "
AND node_type=1 AND trash=0 AND trash_parent=0 ORDER BY sort ASC";
$result = $db->query($sql);

$array_folders = [];
$array_folders_hide = [];
while ($row = $result->fetch()) {
    $row['node_size_show'] = nv_convertfromBytes($row['node_size']);

    $row['parentids'] = empty($row['parentids']) ? [] : explode(',', $row['parentids']);
    $row['subcatid'] = empty($row['subcatid']) ? [] : explode(',', $row['subcatid']);
    $row['subcatids'] = empty($row['subcatids']) ? [] : explode(',', $row['subcatids']);
    $row['properties'] = empty($row['properties']) ? [] : json_decode($row['properties'], true);
    if (!is_array($row['properties'])) {
        $row['properties'] = [];
    }
    if (!empty($row['properties']['hide_media'])) {
        $array_folders_hide[] = $row['id'];
    }

    $array_folders[$row['id']] = $row;
}
$result->closeCursor();

// Gọi file xử lý các tác vụ cho nó gọn. Để cả vào đây hơi dài
require NV_ROOTDIR . '/modules/' . $module_file . '/file-manager-action.php';

$base_url = NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=' . $op;
$per_page = 50;

$request = [];
$request['folder_id'] = $nv_Request->get_absint('folder_id', 'get', 0);
$request['drive'] = $nv_Request->get_title('drive', 'get', '');
$request['type'] = $nv_Request->get_title('type', 'get', FileTypes::TYPE_ALL);
$request['sort'] = $nv_Request->get_title('sort', 'get', $config_user['view_sort']);
$request['q'] = nv_substr($nv_Request->get_title('q', 'get', ''), 0, 100);

$page = $nv_Request->get_absint('page', 'get', 1);

if (!empty($request['drive']) and !in_array($request['drive'], Drives::LIST_DRIVE, true)) {
    $request['drive'] = '';
}
if (!in_array($request['type'], FileTypes::LISTS, true)) {
    $request['type'] = FileTypes::TYPE_ALL;
}
if (!in_array($request['sort'], FileOrders::LISTS, true)) {
    $request['sort'] = $config_user['view_sort'];
}

// URL phân trang tuân theo sort và type
if ($request['type'] != FileTypes::TYPE_ALL) {
    $base_url .= '&amp;type=' . $request['type'];
}
if ($request['sort'] != $config_user['view_sort']) {
    $base_url .= '&amp;sort=' . $request['sort'];
}

// Kiểm tra thư mục đang xem có quyền không
if ($request['folder_id'] > 0 and !isset($array_folders[$request['folder_id']])) {
    nv_redirect_location(NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=' . $op);
}

$tpl = new \NukeViet\Template\NVSmarty();
$tpl->assign('LANG', $nv_Lang);
$tpl->assign('MODULE_NAME', $module_name);
$tpl->assign('OP', $op);
$tpl->assign('NUSER', $nas_user);
$tpl->assign('NUSER_CONFIG', $config_user);
$tpl->assign('REQUEST', $request);
$tpl->assign('USER_DIR', strtolower($user_info['username']));
$tpl->assign('GCONFIG', $global_config);

$tpl->assign('FILEORDERS', FileOrders::LISTS);
$tpl->assign('FILETYPES', FileTypes::LISTS);

$sys_max_size = $sys_max_size_local = min($global_config['nv_max_size'], nv_converttoBytes(ini_get('upload_max_filesize')), nv_converttoBytes(ini_get('post_max_size')));
if ($global_config['nv_overflow_size'] > $sys_max_size and $global_config['upload_chunk_size'] > 0) {
    $sys_max_size_local = $global_config['nv_overflow_size'];
}
$tpl->assign('UPLOAD_MAXSIZE', $sys_max_size_local);
$tpl->assign('UPLOAD_MAXSIZE_VIEW', nv_convertfromBytes($sys_max_size_local));

$db->sqlreset()->from(NV_PREFIXLANG . '_' . $module_data . '_nodes');

$where = [];
$where['userid'] = 'userid=' . $user_info['userid'];
$where[] = 'is_tmp=0'; // Không hiển thị node chưa tải lên xong
$where['trash_parent'] = 'trash_parent=0'; // Không hiển thị node mà thư mục cha bị xóa

// Tìm theo từ khóa
if (!empty($request['q'])) {
    $base_url .= '&amp;q=' . urlencode($request['q']);
    $where[] = "title LIKE '%" . $db->dblikeescape($request['q']) . "%'";
}

if (empty($request['drive']) or $request['drive'] == Drives::DRIVE_FILE) {
    // Tập tin, thư mục
    $where[] = 'trash=0';

    if (!empty($request['folder_id'])) {
        $base_url .= '&amp;folder_id=' . $request['folder_id'];
    }

    $where_or = [];
    if (empty($request['q']) or !empty($request['folder_id'])) {
        // Không có tìm kiếm hoặc tìm kiếm ở 1 thư mục nào đó thì thêm điều kiện file của thư mục đó
        $where_or[] = 'parentid=' . $request['folder_id'];
    }
    if (!empty($request['q']) and !empty($request['folder_id']) and !empty($array_folders[$request['folder_id']]['subcatids'])) {
        $where_or[] = 'parentid IN(' . $array_folders[$request['folder_id']]['subcatids'] . ')';
    }
    if (!empty($where_or)) {
        $where[] = '(' . implode(' OR ', $where_or) . ')';
    }
} else {
    // Lọc theo từng drive cụ thể
    $base_url .= '&amp;drive=' . $request['drive'];
    $where['trash'] = 'trash=0';

    if ($request['drive'] == Drives::DRIVE_BOOKMARK) {
        // Đã lưu
        $where['is_file'] = 'node_type=0';
        $where[] = 'bookmarked>0';
    } elseif ($request['drive'] == Drives::DRIVE_DOCUMENT) {
        // Tài liệu
        $where['is_file'] = 'node_type=0';
        $exts = FileTypes::extsFromType(FileTypes::TYPE_DOCUMENT);
        if (!empty($exts)) {
            $where[] = "node_ext IN('" . implode("', '", $exts) . "')";
        }
    } elseif ($request['drive'] == Drives::DRIVE_HISTORY) {
        // Gần đây: Order tự nhận do js control
        $where['is_file'] = 'node_type=0';
        if (!empty($array_folders_hide)) {
            $where[] = "parentid NOT IN('" . implode("', '", $array_folders_hide) . "')";
        }
    } elseif ($request['drive'] == Drives::DRIVE_MEDIA) {
        // Đa phương tiện: Ảnh, phim, nhạc
        $where['is_file'] = 'node_type=0';
        $exts = array_merge(FileTypes::extsFromType(FileTypes::TYPE_IMAGE), FileTypes::extsFromType(FileTypes::TYPE_MOVIE), FileTypes::extsFromType(FileTypes::TYPE_MUSIC));
        if (!empty($exts)) {
            $where[] = "node_ext IN('" . implode("', '", $exts) . "')";
        }
        if (!empty($array_folders_hide)) {
            $where[] = "parentid NOT IN('" . implode("', '", $array_folders_hide) . "')";
        }
    } elseif ($request['drive'] == Drives::DRIVE_SHARED) {
        // Được chia sẻ
        $where['is_file'] = 'node_type=0';
        $where[] = 'FIND_IN_SET(' . $user_info['userid'] . ', shared_users)';
        unset($where['userid']);
    } elseif ($request['drive'] == Drives::DRIVE_TRASH) {
        $where[] = 'trash>0';
        unset($where['trash']);
    }
}

// Lọc theo loại tập tin
if ($request['type'] != FileTypes::TYPE_ALL) {
    if (!isset($where['is_file'])) {
        $where['is_file'] = 'node_type=0';
    }
    $exts = FileTypes::extsFromType($request['type']);
    if (!empty($exts)) {
        $where[] = "node_ext IN('" . implode("', '", $exts) . "')";
    }
}

$db->select('COUNT(id)')->where(implode(' AND ', $where));
$num_items = $db->query($db->sql())->fetchColumn();

$urlappend = '&amp;page=';
betweenURLs($page, ceil($num_items / $per_page), $base_url, $urlappend, $prevPage, $nextPage);

$db->select('*');

// Xác định sắp xếp
$order = [];
if ($request['sort'] != FileOrders::ORDER_EXT_ASC and $request['sort'] != FileOrders::ORDER_EXT_DESC) {
    // Các kiểu sắp xếp khác ngoại trừ theo định dạng thì cho thư mục lên đầu, tập tin xuống sau
    $order[] = 'node_type DESC';
}
[$order_field, $order_value] = FileOrders::getOrder($request['sort']);
$order[] = $order_field . ' ' . $order_value;

$db->order(implode(', ', $order))->limit($per_page)->offset(($page - 1) * $per_page);

$result = $db->query($db->sql());

$array_nodes = $array_nodes_refs = $array_node_ids = [];
while ($row = $result->fetch()) {
    $row['node_size_show'] = nv_convertfromBytes($row['node_size']);
    $row['add_time_show'] = nv_datetime_format($row['add_time']);
    $row['edit_time_show'] = nv_datetime_format($row['edit_time']);
    $row['icon'] = $row['node_type'] == 1 ? 'folder' : FileTypes::typeFromExt($row['node_ext']);
    $row['ownership'] = $row['userid'] == $user_info['userid'] ? 1 : 0;
    $row['link_download'] = urlRewriteWithDomain(NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=' . $op . '/d/' . $row['id'], NV_MY_DOMAIN);
    $row['duration_show'] = $row['duration'] >= 3600 ? gmdate('G:i:s', $row['duration']) : ($row['duration'] > 0 ? gmdate('i:s', $row['duration']) : '');

    if ($row['node_type'] == Nodes::TYPE_FOLDER) {
        $row['link_folder'] = NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=' . $op . '&amp;folder_id=' . $row['id'];
    } else {
        $row['link_folder'] = '';
        $array_node_ids[$row['id']] = $row['id'];
    }

    $array_nodes[] = $row;
}
$result->closeCursor();
$tpl->assign('ARRAY_NODES', $array_nodes);
$tpl->assign('PAGINATION', nv_generate_page($base_url, $num_items, $per_page, $page));

if (!empty($array_node_ids)) {
    $sql = "SELECT * FROM " . NV_PREFIXLANG . "_" . $module_data . "_nodes_refs WHERE node_id IN(" . implode(',', $array_node_ids) . ")";
    $result = $db->query($sql);

    while ($row = $result->fetch()) {
        $array_nodes_refs[$row['node_id']] = $row;
    }
    $result->closeCursor();
}
$tpl->assign('ARRAY_NODES_REFS', $array_nodes_refs);

// Cây thư mục cố định của mọi thành viên
$array_categories = [];
$array_categories['drive'] = [
    'title' => $nv_Lang->getModule('ui_my_drive'),
    'open' => ($request['drive'] == '' or $request['drive'] == Drives::DRIVE_FILE) ? 1 : 0,
    'active' => (($request['drive'] == '' or $request['drive'] == Drives::DRIVE_FILE) and empty($request['folder_id'])) ? 1 : 0
];
$array_categories['shared'] = [
    'title' => $nv_Lang->getModule('drive_shared'),
    'open' => $request['drive'] == Drives::DRIVE_SHARED ? 1 : 0,
    'active' => $request['drive'] == Drives::DRIVE_SHARED ? 1 : 0
];
$array_categories['document'] = [
    'title' => $nv_Lang->getModule('drive_doc'),
    'open' => $request['drive'] == Drives::DRIVE_DOCUMENT ? 1 : 0,
    'active' => $request['drive'] == Drives::DRIVE_DOCUMENT ? 1 : 0
];
$array_categories['media'] = [
    'title' => $nv_Lang->getModule('drive_media'),
    'open' => $request['drive'] == Drives::DRIVE_MEDIA ? 1 : 0,
    'active' => $request['drive'] == Drives::DRIVE_MEDIA ? 1 : 0
];
$array_categories['history'] = [
    'title' => $nv_Lang->getModule('drive_history'),
    'open' => $request['drive'] == Drives::DRIVE_HISTORY ? 1 : 0,
    'active' => $request['drive'] == Drives::DRIVE_HISTORY ? 1 : 0
];
$array_categories['bookmark'] = [
    'title' => $nv_Lang->getModule('drive_bookmark'),
    'open' => $request['drive'] == Drives::DRIVE_BOOKMARK ? 1 : 0,
    'active' => $request['drive'] == Drives::DRIVE_BOOKMARK ? 1 : 0
];
$array_categories['trash'] = [
    'title' => $nv_Lang->getModule('drive_trash'),
    'open' => $request['drive'] == Drives::DRIVE_TRASH ? 1 : 0,
    'active' => $request['drive'] == Drives::DRIVE_TRASH ? 1 : 0
];

if ($request['folder_id'] > 0) {
    $drive_name = $array_folders[$request['folder_id']]['title'];
} elseif (empty($request['drive']) or $request['drive'] == Drives::DRIVE_FILE) {
    $drive_name = $array_categories['drive']['title'];
} else {
    $drive_name = $array_categories[$request['drive']]['title'];
}

$tpl->assign('RQ', $request);
$tpl->assign('DRIVE_NAME', $drive_name);

// Trả danh sách file qua ajax
if (defined('NV_IS_AJAX')) {
    if ($nv_Request->get_title('checkss', 'get', '') != NV_CHECK_SESSION) {
        nv_jsonOutput([
            'success' => 0,
            'text' => 'Wrong session!!!'
        ]);
    }

    // Thay đổi kiểu sắp xếp
    if ($nv_Request->isset_request('change_sort', 'get') and $request['sort'] != $config_user['view_sort']) {
        $sql = "UPDATE " . NV_PREFIXLANG . "_" . $module_data . "_users_config SET config_value=" . $db->quote($request['sort']) . "
        WHERE config_name='view_sort' AND userid=" . $user_info['userid'];
        $db->query($sql);
    }

    $tpl->setTemplateDir(get_module_tpl_dir('file-manager-files.tpl'));
    $contents = $tpl->fetch('file-manager-files.tpl');

    nv_jsonOutput([
        'success' => 1,
        'text' => '',
        'html' => nv_url_rewrite($contents),
        'drive_name' => $drive_name
    ]);
}

$page_url = $base_url;
if ($page > 1) {
    $page_url .= '&amp;page=' . $page;
}
$canonicalUrl = getCanonicalUrl($page_url);

$tpl->assign('CATEGORIES', $array_categories);
$tpl->assign('ARRAY_FOLDERS', $array_folders);
$tpl->assign('API_GOOGLE_DRIVE', $api_google_drive);

$tpl->setTemplateDir(get_module_tpl_dir('file-manager.tpl'));
$contents = $tpl->fetch('file-manager.tpl');

include NV_ROOTDIR . '/includes/header.php';
echo nv_site_theme(nv_nas_theme($contents));
include NV_ROOTDIR . '/includes/footer.php';
