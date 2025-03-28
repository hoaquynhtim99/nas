<?php

/**
 * NukeViet Content Management System
 * @version 5.x
 * @author VINADES.,JSC <contact@vinades.vn>
 * @copyright (C) 2009-2025 VINADES.,JSC. All rights reserved
 * @license GNU/GPL version 2 or any later version
 * @see https://github.com/nukeviet The NukeViet CMS GitHub project
 */

if (!defined('NV_IS_MOD_NEWS')) {
    exit('Stop!!!');
}

if (empty($array_op)) {
    nv_redirect_location(NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name);
}
$author_info = [];
$author_info['alias'] = $array_op[1];
$author_info['is_guest'] = ($author_info['alias'] == 'guests') ? true : false;
$page = (isset($array_op[2]) and preg_match('/^page\-([0-9]+)$/', $array_op[2], $m)) ? (int) ($m[1]) : 1;

if (!$author_info['is_guest']) {
    $stmt = $db_slave->prepare('SELECT id, uid, pseudonym, image, description, add_time, numnews FROM ' . NV_PREFIXLANG . '_' . $module_data . '_author WHERE alias= :alias AND active=1');
    $stmt->bindParam(':alias', $author_info['alias'], PDO::PARAM_STR);
    $stmt->execute();
    [$author_info['id'], $author_info['uid'], $author_info['pseudonym'], $author_info['image'], $author_info['description'], $author_info['add_time'], $author_info['numnews']] = $stmt->fetch(3);
    if (!$author_info['id']) {
        nv_redirect_location(NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name);
    }

    if (!empty($author_info['image'])) {
        $author_info['image'] = NV_BASE_SITEURL . NV_UPLOADS_DIR . '/' . $module_upload . '/authors/' . $author_info['image'];
    }
    $author_info['add_time_format'] = nv_date_format(1, $author_info['add_time']);

    $page_title = $author_info['pseudonym'];
    $where = 'status=1 AND id IN (SELECT id FROM ' . NV_PREFIXLANG . '_' . $module_data . '_authorlist WHERE aid=' . $author_info['id'] . ')';
} else {
    $page_title = $nv_Lang->getModule('articles_by_other_authors');
    $where = "status=1 AND author!=''";
}

$page_url = $base_url = NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=author/' . $author_info['alias'];
if ($page > 1) {
    $page_url .= '/page-' . $page;
    $page_title .= NV_TITLEBAR_DEFIS . $nv_Lang->getGlobal('page') . ' ' . $page;
}

$canonicalUrl = getCanonicalUrl($page_url, true);

$array_mod_title[] = [
    'catid' => 0,
    'title' => $page_title,
    'link' => $base_url
];

$item_array = [];
$end_publtime = 0;
$show_no_image = $module_config[$module_name]['show_no_image'];

$db_slave->sqlreset()
    ->select('COUNT(*)')
    ->from(NV_PREFIXLANG . '_' . $module_data . '_rows')
    ->where($where);
$num_items = $db_slave->query($db_slave->sql())
    ->fetchColumn();

// Không cho tùy ý đánh số page + xác định trang trước, trang sau
betweenURLs($page, ceil($num_items / $per_page), $base_url, '/page-', $prevPage, $nextPage);

$db_slave->select('id, catid, listcatid, topicid, admin_id, author, sourceid, addtime, edittime, publtime, title, alias, hometext, homeimgfile, homeimgalt, homeimgthumb, allowed_rating, external_link, hitstotal, hitscm, total_rating, click_rating')
    ->order($order_articles_by . ' DESC')
    ->limit($per_page)
    ->offset(($page - 1) * $per_page);
$result = $db_slave->query($db_slave->sql());
while ($item = $result->fetch()) {
    $item['imghome'] = $item['imgmobile'] = '';
    get_homeimgfile($item, 'src');

    $item['alt'] = !empty($item['homeimgalt']) ? $item['homeimgalt'] : $item['title'];
    $item['width'] = $module_config[$module_name]['homewidth'];

    $end_publtime = $item['publtime'];

    $item['link'] = $global_array_cat[$item['catid']]['link'] . '/' . $item['alias'] . '-' . $item['id'] . $global_config['rewrite_exturl'];
    $item_array[] = $item;
}
$result->closeCursor();
unset($query, $row);

$item_array_other = [];
if ($st_links > 0) {
    $db_slave->sqlreset()
        ->select('id, catid, listcatid, addtime, edittime, publtime, title, alias, hitstotal, external_link')
        ->from(NV_PREFIXLANG . '_' . $module_data . '_rows')
        ->where($where . ' AND publtime < ' . $end_publtime)
        ->order($order_articles_by . ' DESC')
        ->limit($st_links);
    $result = $db_slave->query($db_slave->sql());
    while ($item = $result->fetch()) {
        $item['link'] = $global_array_cat[$item['catid']]['link'] . '/' . $item['alias'] . '-' . $item['id'] . $global_config['rewrite_exturl'];
        $item_array_other[] = $item;
    }
    unset($query, $row);
}

$generate_page = nv_alias_page($page_title, $base_url, $num_items, $per_page, $page);

$contents = author_theme($author_info, $item_array, $item_array_other, $generate_page);

include NV_ROOTDIR . '/includes/header.php';
echo nv_site_theme($contents);
include NV_ROOTDIR . '/includes/footer.php';
