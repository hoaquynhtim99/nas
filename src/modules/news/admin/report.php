<?php

/**
 * NukeViet Content Management System
 * @version 4.x
 * @author VINADES.,JSC <contact@vinades.vn>
 * @copyright (C) 2009-2023 VINADES.,JSC. All rights reserved
 * @license GNU/GPL version 2 or any later version
 * @see https://github.com/nukeviet The NukeViet CMS GitHub project
 */

if (!defined('NV_IS_FILE_ADMIN')) {
    exit('Stop!!!');
}

use NukeViet\Module\news\Shared\Emails;

$action = $nv_Request->get_title('action', 'post', '');

// Xóa báo cáo lỗi
if (($action == 'del_action' or $action == 'del_mail_action') and $nv_Request->isset_request('rid', 'post')) {
    $rid = $nv_Request->get_int('rid', 'post', 0);
    if (empty($rid)) {
        nv_htmlOutput('Error!!!');
    }

    $report_rows = $db->query('SELECT id, post_email FROM ' . NV_PREFIXLANG . '_' . $module_data . '_report WHERE id = ' . $rid)->fetch();
    if (empty($report_rows)) {
        nv_htmlOutput('Error!!!');
    }

    $db->query('DELETE FROM ' . NV_PREFIXLANG . '_' . $module_data . '_report WHERE id=' . $rid);
    nv_delete_notification(NV_LANG_DATA, $module_name, 'report', $rid);
    if ($action == 'del_mail_action' and !empty($report_rows['post_email'])) {
        $maillang = NV_LANG_INTERFACE;
        if (NV_LANG_DATA != NV_LANG_INTERFACE) {
            $maillang = NV_LANG_DATA;
        }

        $send_data = [[
            'to' => $report_rows['post_email']
        ]];
        nv_sendmail_template_async([$module_file, Emails::REPORT_THANKS], $send_data, $maillang);
    }
    nv_htmlOutput('OK');
}

// Xóa hàng loạt báo cáo lỗi
if ($action == 'multidel' and $nv_Request->isset_request('list', 'post')) {
    $list = $nv_Request->get_typed_array('list', 'post', 'int', []);
    if (!empty($list)) {
        foreach ($list as $rid) {
            nv_delete_notification(NV_LANG_DATA, $module_name, 'report', $rid);
        }
        $list = implode(',', $list);
        $db->query('DELETE FROM ' . NV_PREFIXLANG . '_' . $module_data . '_report WHERE id IN (' . $list . ')');
    }
    nv_htmlOutput('OK');
}

$page_title = $nv_Lang->getModule('report');

$base_url = NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=' . $op;
$page = $nv_Request->get_page('page', 'get', 1);
$per_page = 30;
$db->sqlreset()
    ->select('COUNT(*)')
    ->from(NV_PREFIXLANG . '_' . $module_data . '_report AS r')
    ->join('INNER JOIN ' . NV_PREFIXLANG . '_' . $module_data . '_rows n ON r.newsid=n.id');
$num_items = $db->query($db->sql())->fetchColumn();
if (empty($num_items)) {
    $contents = '<p class="text-center">' . $nv_Lang->getModule('report_empty') . '</p>';
} else {
    $db->select('r.*, n.title')
        ->order('r.post_time DESC')
        ->limit($per_page)
        ->offset(($page - 1) * $per_page);
    $generate_page = nv_generate_page($base_url, $num_items, $per_page, $page);

    $xtpl = new XTemplate('report.tpl', NV_ROOTDIR . '/themes/' . $global_config['module_theme'] . '/modules/' . $module_file);
    $xtpl->assign('GLANG', \NukeViet\Core\Language::$lang_global);
    $xtpl->assign('LANG', \NukeViet\Core\Language::$lang_module);
    $xtpl->assign('ACTION_URL', NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=' . $op);

    $result = $db->query($db->sql());
    while ($row = $result->fetch()) {
        $row['url'] = NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=content&amp;id=' . $row['newsid'] . '&amp;rid=' . $row['id'];
        $row['orig_content_short'] = text_split($row['orig_content'], 50);
        $row['orig_content_short'] = $row['orig_content_short'][0] . (!empty($row['orig_content_short'][1]) ? '...' : '');
        $row['post_time_format'] = date('d/m/Y H:i', $row['post_time']);
        $xtpl->assign('REPORT', $row);
        $xtpl->parse('main.loop');
    }

    $xtpl->parse('main');
    $contents = $xtpl->text('main');
}

include NV_ROOTDIR . '/includes/header.php';
echo nv_admin_theme($contents);
include NV_ROOTDIR . '/includes/footer.php';
