<?php

/**
 * NukeViet Content Management System
 * @version 5.x
 * @author VINADES.,JSC <contact@vinades.vn>
 * @copyright (C) 2009-2025 VINADES.,JSC. All rights reserved
 * @license GNU/GPL version 2 or any later version
 * @see https://github.com/nukeviet The NukeViet CMS GitHub project
 */

if (!defined('NV_IS_FILE_ADMIN')) {
    exit('Stop!!!');
}

$page_title = $nv_Lang->getModule('topics');

$error = '';
$savecat = 0;

$array = [];
$array['topicid'] = 0;
$array['title'] = '';
$array['alias'] = '';
$array['image'] = '';
$array['description'] = '';
$array['keywords'] = '';

$savecat = $nv_Request->get_int('savecat', 'post', 0);
if (!empty($savecat)) {
    $array['topicid'] = $nv_Request->get_int('topicid', 'post', 0);
    $array['title'] = $nv_Request->get_title('title', 'post', '', 1);
    $array['keywords'] = $nv_Request->get_title('keywords', 'post', '', 1);
    $array['alias'] = $nv_Request->get_title('alias', 'post', '');
    $array['description'] = $nv_Request->get_string('description', 'post', '');

    $array['description'] = nv_nl2br(nv_substr(nv_htmlspecialchars(strip_tags($array['description'])), 0, 250), '<br />');

    // Xu ly anh minh hoa
    $array['image'] = $nv_Request->get_title('homeimg', 'post', '');
    if (!nv_is_url($array['image']) and nv_is_file($array['image'], NV_UPLOADS_DIR . '/' . $module_upload . '/topics')) {
        $lu = strlen(NV_BASE_SITEURL . NV_UPLOADS_DIR . '/' . $module_upload . '/topics/');
        $array['image'] = substr($array['image'], $lu);
    } else {
        $array['image'] = '';
    }

    $array['alias'] = ($array['alias'] == '') ? get_mod_alias($array['title'], 'topics', $array['topicid']) : get_mod_alias($array['alias'], 'topics', $array['topicid']);

    // Kiểm tra trùng
    $sql = 'SELECT COUNT(*) FROM ' . NV_PREFIXLANG . '_' . $module_data . '_topics WHERE (title=:title OR alias=:alias)' . ($array['topicid'] ? ' AND topicid!=' . $array['topicid'] : '');
    $sth = $db->prepare($sql);
    $sth->bindParam(':title', $array['title'], PDO::PARAM_STR);
    $sth->bindParam(':alias', $array['alias'], PDO::PARAM_STR);
    $sth->execute();
    $is_exists = $sth->fetchColumn();

    if (empty($array['title'])) {
        $error = $nv_Lang->getModule('topics_error_title');
    } elseif ($is_exists) {
        $error = $nv_Lang->getModule('errorexists');
    } elseif ($array['topicid'] == 0) {
        $weight = $db->query('SELECT max(weight) FROM ' . NV_PREFIXLANG . '_' . $module_data . '_topics')->fetchColumn();
        $weight = (int) $weight + 1;

        $_sql = 'INSERT INTO ' . NV_PREFIXLANG . '_' . $module_data . '_topics (title, alias, description, image, weight, keywords, add_time, edit_time) VALUES ( :title, :alias, :description, :image, :weight, :keywords, ' . NV_CURRENTTIME . ', ' . NV_CURRENTTIME . ')';
        $data_insert = [];
        $data_insert['title'] = $array['title'];
        $data_insert['alias'] = $array['alias'];
        $data_insert['description'] = $array['description'];
        $data_insert['image'] = $array['image'];
        $data_insert['weight'] = $weight;
        $data_insert['keywords'] = $array['keywords'];

        if ($db->insert_id($_sql, 'topicid', $data_insert)) {
            nv_insert_logs(NV_LANG_DATA, $module_name, 'log_add_topic', ' ', $admin_info['userid']);
            nv_redirect_location(NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=' . $op);
        } else {
            $error = $nv_Lang->getModule('errorsave');
        }
    } else {
        $stmt = $db->prepare('UPDATE ' . NV_PREFIXLANG . '_' . $module_data . '_topics SET title= :title, alias = :alias, description= :description, image = :image, keywords= :keywords, edit_time=' . NV_CURRENTTIME . ' WHERE topicid =' . $array['topicid']);
        $stmt->bindParam(':title', $array['title'], PDO::PARAM_STR);
        $stmt->bindParam(':alias', $array['alias'], PDO::PARAM_STR);
        $stmt->bindParam(':description', $array['description'], PDO::PARAM_STR);
        $stmt->bindParam(':image', $array['image'], PDO::PARAM_STR);
        $stmt->bindParam(':keywords', $array['keywords'], PDO::PARAM_STR);

        if ($stmt->execute()) {
            nv_insert_logs(NV_LANG_DATA, $module_name, 'log_edit_topic', 'topicid ' . $array['topicid'], $admin_info['userid']);
            nv_redirect_location(NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=' . $op);
        } else {
            $error = $nv_Lang->getModule('errorsave');
        }
    }
}

$array['topicid'] = $nv_Request->get_int('topicid', 'get', 0);
if ($array['topicid'] > 0) {
    [$array['topicid'], $array['title'], $array['alias'], $array['image'], $array['description'], $array['keywords']] = $db->query('SELECT topicid, title, alias, image, description, keywords FROM ' . NV_PREFIXLANG . '_' . $module_data . '_topics where topicid=' . $array['topicid'])->fetch(3);
    $nv_Lang->setModule('add_topic', $nv_Lang->getModule('edit_topic'));
}

if (is_file(NV_ROOTDIR . '/' . NV_UPLOADS_DIR . '/' . $module_upload . '/topics/' . $array['image'])) {
    $array['image'] = NV_BASE_SITEURL . NV_UPLOADS_DIR . '/' . $module_upload . '/topics/' . $array['image'];
}

$page = $nv_Request->get_page('page', 'get', 1);

$xtpl = new XTemplate('topics.tpl', NV_ROOTDIR . '/themes/' . $global_config['module_theme'] . '/modules/' . $module_file);
$xtpl->assign('LANG', \NukeViet\Core\Language::$lang_module);
$xtpl->assign('GLANG', \NukeViet\Core\Language::$lang_global);
$xtpl->assign('NV_BASE_ADMINURL', NV_BASE_ADMINURL);
$xtpl->assign('NV_NAME_VARIABLE', NV_NAME_VARIABLE);
$xtpl->assign('MODULE_NAME', $module_name);
$xtpl->assign('OP', $op);
$xtpl->assign('UPLOADS_DIR', NV_UPLOADS_DIR . '/' . $module_upload . '/topics');
$xtpl->assign('DATA', $array);
$xtpl->assign('TOPIC_LIST', nv_show_topics_list($page));

if (!empty($error)) {
    $xtpl->assign('ERROR', $error);
    $xtpl->parse('main.error');
}

if (empty($array['alias'])) {
    $xtpl->parse('main.getalias');
}

$xtpl->parse('main');
$contents = $xtpl->text('main');

include NV_ROOTDIR . '/includes/header.php';
echo nv_admin_theme($contents);
include NV_ROOTDIR . '/includes/footer.php';
