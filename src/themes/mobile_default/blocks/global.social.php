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

if (!nv_function_exists('nv_menu_theme_social')) {
    /**
     * nv_menu_theme_social_config()
     *
     * @param string $module
     * @param array  $data_block
     * @return string
     */
    function nv_menu_theme_social_config($module, $data_block)
    {
        global $nv_Lang;

        $html = '<div class="row mb-3">';
        $html .= '	<label class="col-sm-3 col-form-label text-sm-end text-truncate fw-medium">' . $nv_Lang->getModule('facebook') . ':</label>';
        $html .= '	<div class="col-sm-9"><input type="text" name="config_facebook" class="form-control" value="' . $data_block['facebook'] . '"/></div>';
        $html .= '</div>';
        $html .= '<div class="row mb-3">';
        $html .= '	<label class="col-sm-3 col-form-label text-sm-end text-truncate fw-medium">' . $nv_Lang->getModule('youtube') . ':</label>';
        $html .= '	<div class="col-sm-9"><input type="text" name="config_youtube" class="form-control" value="' . $data_block['youtube'] . '"/></div>';
        $html .= '</div>';
        $html .= '<div class="row mb-3">';
        $html .= '	<label class="col-sm-3 col-form-label text-sm-end text-truncate fw-medium">' . $nv_Lang->getModule('twitter') . ':</label>';
        $html .= '	<div class="col-sm-9"><input type="text" name="config_twitter" class="form-control" value="' . $data_block['twitter'] . '"/></div>';
        $html .= '</div>';

        return $html;
    }

    /**
     * nv_menu_theme_social_submit()
     *
     * @param string $module
     * @return array
     */
    function nv_menu_theme_social_submit($module)
    {
        global $nv_Request;
        $return = [];
        $return['error'] = [];
        $return['config']['facebook'] = $nv_Request->get_title('config_facebook', 'post');
        $return['config']['youtube'] = $nv_Request->get_title('config_youtube', 'post');
        $return['config']['twitter'] = $nv_Request->get_title('config_twitter', 'post');

        return $return;
    }

    /**
     * nv_menu_theme_social()
     *
     * @param array $block_config
     * @return string
     */
    function nv_menu_theme_social($block_config)
    {
        global $global_config, $site_mods;

        $block_theme = get_tpl_dir([$global_config['module_theme'], $global_config['site_theme']], 'default', '/blocks/global.social.tpl');
        $xtpl = new XTemplate('global.social.tpl', NV_ROOTDIR . '/themes/' . $block_theme . '/blocks');
        $xtpl->assign('LANG', \NukeViet\Core\Language::$lang_global);
        $xtpl->assign('BLOCK_THEME', $block_theme);
        $xtpl->assign('DATA', $block_config);
        if (!empty($block_config['facebook'])) {
            $xtpl->parse('main.facebook');
        }
        if (!empty($block_config['youtube'])) {
            $xtpl->parse('main.youtube');
        }
        if (!empty($block_config['twitter'])) {
            $xtpl->parse('main.twitter');
        }
        if (isset($site_mods['feeds'])) {
            $xtpl->assign('FEEDS_HREF', NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=feeds');
            $xtpl->parse('main.feeds');
        }
        $xtpl->parse('main');

        return $xtpl->text('main');
    }
}

if (defined('NV_SYSTEM')) {
    $content = nv_menu_theme_social($block_config);
}
