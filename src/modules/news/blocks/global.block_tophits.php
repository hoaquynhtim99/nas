<?php

/**
 * NukeViet Content Management System
 * @version 5.x
 * @author VINADES.,JSC <contact@vinades.vn>
 * @copyright (C) 2009-2025 VINADES.,JSC. All rights reserved
 * @license GNU/GPL version 2 or any later version
 * @see https://github.com/nukeviet The NukeViet CMS GitHub project
 */

if (!defined('NV_MAINFILE')) {
    exit('Stop!!!');
}

if (!nv_function_exists('nv_news_block_tophits')) {
    /**
     * nv_block_config_tophits_blocks()
     *
     * @param string $module
     * @param array  $data_block
     * @return string
     */
    function nv_block_config_tophits_blocks($module, $data_block)
    {
        global $nv_Cache, $site_mods, $nv_Lang;

        $tooltip_position = [
            'top' => $nv_Lang->getModule('tooltip_position_top'),
            'bottom' => $nv_Lang->getModule('tooltip_position_bottom'),
            'left' => $nv_Lang->getModule('tooltip_position_left'),
            'right' => $nv_Lang->getModule('tooltip_position_right')
        ];
        $html = '';
        $html .= '<div class="row mb-3">';
        $html .= '	<label class="col-sm-3 col-form-label text-sm-end text-truncate fw-medium">' . $nv_Lang->getModule('number_day') . ':</label>';
        $html .= '	<div class="col-sm-9"><input type="text" name="config_number_day" class="form-control w100" size="5" value="' . $data_block['number_day'] . '"/></div>';
        $html .= '</div>';
        $html .= '<div class="row mb-3">';
        $html .= '	<label class="col-sm-3 col-form-label text-sm-end text-truncate fw-medium">' . $nv_Lang->getModule('numrow') . ':</label>';
        $html .= '	<div class="col-sm-9"><input type="text" name="config_numrow" class="form-control w100" size="5" value="' . $data_block['numrow'] . '"/></div>';
        $html .= '</div>';
        $html .= '<div class="row mb-3">';
        $html .= '<label class="col-sm-3 col-form-label text-sm-end text-truncate fw-medium">' . $nv_Lang->getModule('showtooltip') . ':</label>';
        $html .= '<div class="col-sm-9">';
        $html .= '<div class="row g-2 align-items-center">';
        $html .= '<div class="col-sm-2">';
        $html .= '<input class="form-check-input" type="checkbox" value="1" name="config_showtooltip" ' . ($data_block['showtooltip'] == 1 ? 'checked="checked"' : '') . ' /></div>';
        $html .= '<div class="col-sm-5">';
        $html .= '<div class="input-group">';
        $html .= '<div class="input-group-text">' . $nv_Lang->getModule('tooltip_position') . '</div>';
        $html .= '<select name="config_tooltip_position" class="form-select">';

        foreach ($tooltip_position as $key => $value) {
            $html .= '<option value="' . $key . '" ' . ($data_block['tooltip_position'] == $key ? 'selected="selected"' : '') . '>' . $value . '</option>';
        }

        $html .= '</select>';
        $html .= '</div>';
        $html .= '</div>';
        $html .= '<div class="col-sm-5">';
        $html .= '<div class="input-group">';
        $html .= '<div class="input-group-text">' . $nv_Lang->getModule('tooltip_length') . '</div>';
        $html .= '<input type="text" class="form-control" name="config_tooltip_length" value="' . $data_block['tooltip_length'] . '"/>';
        $html .= '</div>';
        $html .= '</div>';
        $html .= '</div>';
        $html .= '</div>';
        $html .= '</div>';
        $html .= '</div>';
        $html .= '<div class="row mb-3">';
        $html .= '<label class="col-sm-3 col-form-label text-sm-end text-truncate fw-medium">' . $nv_Lang->getModule('nocatid') . ':</label>';
        $sql = 'SELECT * FROM ' . NV_PREFIXLANG . '_' . $site_mods[$module]['module_data'] . '_cat ORDER BY sort ASC';
        $list = $nv_Cache->db($sql, '', $module);
        $html .= '<div class="col-sm-9">';
        $html .= '<div style="max-height: 200px; overflow: auto">';
        if (!is_array($data_block['nocatid'])) {
            $data_block['nocatid'] = explode(',', $data_block['nocatid']);
        }
        foreach ($list as $l) {
            if ($l['status'] == 1 or $l['status'] == 2) {
                $xtitle_i = '';

                if ($l['lev'] > 0) {
                    for ($i = 1; $i <= $l['lev']; ++$i) {
                        $xtitle_i .= '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';
                    }
                }
                $html .= '<div class="form-check"><input class="form-check-input" type="checkbox" name="config_nocatid[]" value="' . $l['catid'] . '" ' . ((in_array((int) $l['catid'], array_map('intval', $data_block['nocatid']), true)) ? ' checked="checked"' : '') . ' id="config_nocatid_' . $l['catid'] . '"><label class="form-check-label" for="config_nocatid_' . $l['catid'] . '">' . $xtitle_i . $l['title'] . '</label></div>';
            }
        }
        $html .= '</div>';
        $html .= '</div>';
        $html .= '</div>';

        return $html;
    }

    /**
     * nv_block_config_tophits_blocks_submit()
     *
     * @param string $module
     * @return array
     */
    function nv_block_config_tophits_blocks_submit($module)
    {
        global $nv_Request;
        $return = [];
        $return['error'] = [];
        $return['config'] = [];
        $return['config']['number_day'] = $nv_Request->get_int('config_number_day', 'post', 0);
        $return['config']['numrow'] = $nv_Request->get_int('config_numrow', 'post', 0);
        $return['config']['showtooltip'] = $nv_Request->get_int('config_showtooltip', 'post', 0);
        $return['config']['tooltip_position'] = $nv_Request->get_string('config_tooltip_position', 'post', 0);
        $return['config']['tooltip_length'] = $nv_Request->get_string('config_tooltip_length', 'post', 0);
        $return['config']['nocatid'] = $nv_Request->get_typed_array('config_nocatid', 'post', 'int', []);

        return $return;
    }

    /**
     * nv_news_block_tophits()
     *
     * @param array  $block_config
     * @param string $mod_data
     * @return string
     */
    function nv_news_block_tophits($block_config, $mod_data)
    {
        global $module_array_cat, $site_mods, $db_slave, $module_config, $global_config;

        $module = $block_config['module'];
        $mod_file = $site_mods[$module]['module_file'];

        $blockwidth = $module_config[$module]['blockwidth'];
        $show_no_image = $module_config[$module]['show_no_image'];
        $publtime = NV_CURRENTTIME - $block_config['number_day'] * 86400;

        $array_block_news = [];
        $db_slave->sqlreset()
            ->select('id, catid, publtime, title, alias, homeimgthumb, homeimgfile, hometext, external_link')
            ->from(NV_PREFIXLANG . '_' . $mod_data . '_rows')
            ->order('hitstotal DESC')
            ->limit($block_config['numrow']);
        if (empty($block_config['nocatid'])) {
            $db_slave->where('status= 1 AND publtime > ' . $publtime);
        } else {
            $db_slave->where('status= 1 AND publtime > ' . $publtime . ' AND catid NOT IN (' . implode(',', $block_config['nocatid']) . ')');
        }

        $result = $db_slave->query($db_slave->sql());
        while ([$id, $catid, $publtime, $title, $alias, $homeimgthumb, $homeimgfile, $hometext, $external_link] = $result->fetch(3)) {
            if ($homeimgthumb == 1) {
                // image thumb
                $imgurl = NV_BASE_SITEURL . NV_FILES_DIR . '/' . $site_mods[$module]['module_upload'] . '/' . $homeimgfile;
            } elseif ($homeimgthumb == 2) {
                // image file
                $imgurl = NV_BASE_SITEURL . NV_UPLOADS_DIR . '/' . $site_mods[$module]['module_upload'] . '/' . $homeimgfile;
            } elseif ($homeimgthumb == 3) {
                // image url
                $imgurl = $homeimgfile;
            } elseif (!empty($show_no_image)) {
                // no image
                $imgurl = NV_BASE_SITEURL . $show_no_image;
            } else {
                $imgurl = '';
            }
            $link = NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module . '&amp;' . NV_OP_VARIABLE . '=' . $module_array_cat[$catid]['alias'] . '/' . $alias . '-' . $id . $global_config['rewrite_exturl'];

            $array_block_news[] = [
                'id' => $id,
                'title' => $title,
                'link' => $link,
                'imgurl' => $imgurl,
                'width' => $blockwidth,
                'hometext' => $hometext,
                'hometext_clean' => nv_clean60(strip_tags($hometext), $block_config['tooltip_length'], true),
                'external_link' => $external_link,
                'target_blank' => $external_link ? ' target="_blank"' : ''
            ];
        }

        $block_theme = get_tpl_dir($global_config['module_theme'], 'default', '/modules/' . $mod_file . '/block_tophits.tpl');
        $xtpl = new XTemplate('block_tophits.tpl', NV_ROOTDIR . '/themes/' . $block_theme . '/modules/' . $mod_file);
        $xtpl->assign('TEMPLATE', $block_theme);

        foreach ($array_block_news as $array_news) {
            $xtpl->assign('blocknews', $array_news);

            if (!empty($array_news['imgurl'])) {
                $xtpl->parse('main.newloop.imgblock');
            }

            if (!$block_config['showtooltip']) {
                $xtpl->assign('TITLE', 'title="' . $array_news['title'] . '"');
            }

            // Bootstrap 4/5
            if ($block_config['showtooltip']) {
                $xtpl->assign('TOOLTIP_POSITION', $block_config['tooltip_position']);
                $xtpl->parse('main.newloop.tooltip');
            }

            $xtpl->parse('main.newloop');
        }

        if ($block_config['showtooltip']) {
            $xtpl->assign('TOOLTIP_POSITION', $block_config['tooltip_position']);
            $xtpl->parse('main.tooltip');
        }

        $xtpl->parse('main');

        return $xtpl->text('main');
    }
}

if (defined('NV_SYSTEM')) {
    global $nv_Cache, $site_mods, $module_name, $global_array_cat, $module_array_cat;
    $module = $block_config['module'];
    if (isset($site_mods[$module])) {
        $mod_data = $site_mods[$module]['module_data'];
        if ($module == $module_name) {
            $module_array_cat = $global_array_cat;
            unset($module_array_cat[0]);
        } else {
            $module_array_cat = [];
            $sql = 'SELECT catid, parentid, title, alias, viewcat, subcatid, numlinks, description, keywords, groups_view, status FROM ' . NV_PREFIXLANG . '_' . $mod_data . '_cat ORDER BY sort ASC';
            $list = $nv_Cache->db($sql, 'catid', $module);
            if (!empty($list)) {
                foreach ($list as $l) {
                    $module_array_cat[$l['catid']] = $l;
                    $module_array_cat[$l['catid']]['link'] = NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module . '&amp;' . NV_OP_VARIABLE . '=' . $l['alias'];
                }
            }
        }
        $content = nv_news_block_tophits($block_config, $mod_data);
    }
}
