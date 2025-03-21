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

$page_title = $module_info['site_title'];
$key_words = $module_info['keywords'];
$description = $module_info['description'];

$page_url = NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name;
$canonicalUrl = getCanonicalUrl($page_url);

$tpl = new \NukeViet\Template\NVSmarty();
$tpl->assign('LANG', $nv_Lang);
$tpl->assign('MODULE_NAME', $module_name);
$tpl->assign('GCONFIG', $global_config);

$tpl->assign('ARRAY_APPS', $array_apps);

$tpl->setTemplateDir(get_module_tpl_dir('main.tpl'));
$contents = $tpl->fetch('main.tpl');

include NV_ROOTDIR . '/includes/header.php';
echo nv_site_theme(nv_nas_theme($contents));
include NV_ROOTDIR . '/includes/footer.php';
