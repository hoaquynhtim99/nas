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

use NukeViet\Module\nas\Shared\FileTypes;

$page_title = $nv_Lang->getModule('app_fzone');
$key_words = $module_info['keywords'];
$description = $module_info['description'];

$base_url = NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=' . $op;

$tpl = new \NukeViet\Template\NVSmarty();
$tpl->assign('LANG', $nv_Lang);
$tpl->assign('MODULE_NAME', $module_name);
$tpl->assign('OP', $op);
$tpl->assign('GCONFIG', $global_config);
$tpl->assign('ARRAY_APPS', $array_apps);
$tpl->assign('USER', $nas_user);

$request = [];
$request['q'] = nv_substr($nv_Request->get_title('q', 'get', ''), 0, 100);

$page = $nv_Request->get_absint('page', 'get', 1);
$per_page = 50;

$db->sqlreset()->from(NV_PREFIXLANG . '_' . $module_data . '_nodes');

$where = [];
$where[] = 'is_tmp=0'; // Không hiển thị node chưa tải lên xong
$where[] = 'trash_parent=0'; // Không hiển thị node mà thư mục cha bị xóa
$where[] = 'trash=0'; // Không hiển thị node bị xóa
$where[] = 'node_type=0'; // Chỉ show tệp tin
$where[] = "(zoned_time=-1 OR zoned_time>" . NV_CURRENTTIME . ")";

// Tìm theo từ khóa
if (!empty($request['q'])) {
    $base_url .= '&amp;q=' . urlencode($request['q']);
    $where[] = "title LIKE '%" . $db->dblikeescape($request['q']) . "%'";
}

$db->select('COUNT(id)')->where(implode(' AND ', $where));
$num_items = $db->query($db->sql())->fetchColumn();

$urlappend = '&amp;page=';
betweenURLs($page, ceil($num_items / $per_page), $base_url, $urlappend, $prevPage, $nextPage);

$db->select('*');

$db->order('title ASC')->limit($per_page)->offset(($page - 1) * $per_page);

$result = $db->query($db->sql());

$array_nodes = $array_nodes_refs = $array_node_ids = [];
while ($row = $result->fetch()) {
    $row['node_size_show'] = nv_convertfromBytes($row['node_size']);
    $row['add_time_show'] = nv_datetime_format($row['add_time']);
    $row['edit_time_show'] = nv_datetime_format($row['edit_time']);
    $row['icon'] = $row['node_type'] == 1 ? 'folder' : FileTypes::typeFromExt($row['node_ext']);
    $row['link_download'] = urlRewriteWithDomain(NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=file-manager/d/' . $row['id'], NV_MY_DOMAIN);
    $row['duration_show'] = $row['duration'] >= 3600 ? gmdate('G:i:s', $row['duration']) : ($row['duration'] > 0 ? gmdate('i:s', $row['duration']) : '');

    $array_node_ids[$row['id']] = $row['id'];
    $array_nodes[] = $row;
}
$result->closeCursor();
$tpl->assign('FILES', $array_nodes);
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
$tpl->assign('SEARCH', $request);
$tpl->assign('GCONFIG', $global_config);

$page_url = $base_url;
if ($page > 1) {
    $page_url .= '&amp;page=' . $page;
}
$canonicalUrl = getCanonicalUrl($page_url);

$tpl->setTemplateDir(get_module_tpl_dir('file-zone.tpl'));
$contents = $tpl->fetch('file-zone.tpl');

include NV_ROOTDIR . '/includes/header.php';
echo nv_site_theme(nv_nas_theme($contents));
include NV_ROOTDIR . '/includes/footer.php';
