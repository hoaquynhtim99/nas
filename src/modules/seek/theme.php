<?php

/**
 * NukeViet Content Management System
 * @version 5.x
 * @author VINADES.,JSC <contact@vinades.vn>
 * @copyright (C) 2009-2025 VINADES.,JSC. All rights reserved
 * @license GNU/GPL version 2 or any later version
 * @see https://github.com/nukeviet The NukeViet CMS GitHub project
 */

if (!defined('NV_IS_MOD_SEARCH')) {
    exit('Stop!!!');
}

/**
 * search_main_theme()
 *
 * @param bool  $is_search
 * @param array $search
 * @param array $array_modul
 * @return string
 */
function search_main_theme($is_search, $search, $array_modul)
{
    global $module_info, $global_config, $nv_Lang, $module_name;

    $xtpl = new XTemplate('form.tpl', get_module_tpl_dir('form.tpl'));
    $xtpl->assign('LANG', \NukeViet\Core\Language::$lang_module);
    $xtpl->assign('NV_MIN_SEARCH_LENGTH', NV_MIN_SEARCH_LENGTH);
    $xtpl->assign('NV_MAX_SEARCH_LENGTH', NV_MAX_SEARCH_LENGTH);
    $xtpl->assign('PAGE', $search['page']);
    $xtpl->assign('NV_LANG_VARIABLE', NV_LANG_VARIABLE);
    $xtpl->assign('NV_LANG_DATA', NV_LANG_DATA);
    $xtpl->assign('NV_NAME_VARIABLE', NV_NAME_VARIABLE);
    $xtpl->assign('MODULE_NAME', $module_name);
    $xtpl->assign('INVALID_KEY_MESS', $nv_Lang->getModule('searchQueryError', NV_MIN_SEARCH_LENGTH));

    $search['action'] = NV_BASE_SITEURL . 'index.php';
    $search['full_action'] = NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name;
    $search['andChecked'] = $search['logic'] == 1 ? ' checked="checked"' : '';
    $search['orChecked'] = $search['logic'] == 1 ? '' : ' checked="checked"';

    $xtpl->assign('DATA', $search);

    if (!empty($array_modul)) {
        foreach ($array_modul as $m_name => $m_info) {
            $m_info['value'] = $m_name;
            $m_info['selected'] = ($m_name == $search['mod']) ? ' selected="selected"' : '';
            $m_info['adv_search'] = $m_info['adv_search'] ? 'true' : 'false';
            $m_info['url'] = NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $m_name . '&' . NV_OP_VARIABLE . '=search';

            $xtpl->assign('MOD', $m_info);
            $xtpl->parse('main.select_option');
        }
    }

    if (isset($global_config['searchEngineUniqueID']) and !empty($global_config['searchEngineUniqueID'])) {
        $xtpl->assign('SEARCH_ENGINE_UNIQUE_ID', $global_config['searchEngineUniqueID']);
        $xtpl->parse('main.search_engine_unique_ID');
    }

    if ($is_search) {
        if ($search['is_error']) {
            $xtpl->assign('SEARCH_RESULT', '<span class="red">' . $search['errorInfo'] . '</span>');
            $xtpl->parse('main.is_invalid');
        } else {
            $xtpl->assign('SEARCH_RESULT', $search['content']);
            $xtpl->parse('main.is_valid');
        }
    }

    $xtpl->parse('main');

    return $xtpl->text('main');
}

/**
 * urlencode_rfc_3986()
 *
 * @param string $string
 * @return string
 */
function urlencode_rfc_3986($string)
{
    $entities = ['%21', '%2A', '%27', '%28', '%29', '%3B', '%3A', '%40', '%26', '%3D', '%2B', '%24', '%2C', '%2F', '%3F', '%25', '%23', '%5B', '%5D'];
    $replacements = ['!', '*', "'", '(', ')', ';', ':', '@', '&', '=', '+', '$', ',', '/', '?', '%', '#', '[', ']'];

    return str_replace($entities, $replacements, urlencode($string));
}

/**
 * search_result_theme()
 *
 * @param array  $result_array
 * @param string $mod
 * @param string $mod_custom_title
 * @param array  $search
 * @param bool   $is_generate_page
 * @param int    $limit
 * @param int    $num_items
 * @return string
 */
function search_result_theme($result_array, $mod, $mod_custom_title, $search, $is_generate_page, $limit, $num_items)
{
    global $module_info, $db, $module_name;
    $xtpl = new XTemplate('result.tpl', get_module_tpl_dir('result.tpl'));
    $xtpl->assign('LANG', \NukeViet\Core\Language::$lang_module);
    $xtpl->assign('SEARCH_RESULT_NUM', $num_items);
    $xtpl->assign('MODULE_CUSTOM_TITLE', $mod_custom_title);
    $xtpl->assign('HIDDEN_KEY', $search['key']);

    foreach ($result_array as $result) {
        $xtpl->assign('RESULT', $result);
        $xtpl->parse('main.result');
    }

    $base_url = NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&q=' . urlencode_rfc_3986($search['key']);
    if ($mod != 'all') {
        $base_url .= '&m=' . $mod;
    }
    if (empty($search['logic'])) {
        $base_url .= '&l=' . $search['logic'];
    }

    if ($is_generate_page) {
        $generate_page = nv_generate_page($base_url, $num_items, $limit, $search['page']);
        if (!empty($generate_page)) {
            $xtpl->assign('GENERATE_PAGE', $generate_page);
            $xtpl->parse('main.generate_page');
        }
    } else {
        if ($num_items > $limit) {
            $xtpl->assign('MORE', $base_url);
            $xtpl->parse('main.more');
        }
    }

    $xtpl->parse('main');

    return $xtpl->text('main');
}
