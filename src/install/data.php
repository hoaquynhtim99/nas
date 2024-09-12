<?php

/**
 * NukeViet Content Management System
 * @version 4.x
 * @author VINADES.,JSC <contact@vinades.vn>
 * @copyright (C) 2009-2023 VINADES.,JSC. All rights reserved
 * @license GNU/GPL version 2 or any later version
 * @see https://github.com/nukeviet The NukeViet CMS GitHub project
 */

if (!defined('NV_MAINFILE')) {
    exit('Stop!!!');
}

$sql_create_table[] = 'INSERT INTO ' . NV_AUTHORS_GLOBALTABLE . "_module (mid, module, lang_key, weight, act_1, act_2, act_3, checksum, icon) VALUES
(1, 'siteinfo', 'mod_siteinfo', 1, 1, 1, 1, '', 'fa-solid fa-server'),
(2, 'authors', 'mod_authors', 2, 1, 1, 1, '', 'fa-solid fa-user-gear'),
(3, 'settings', 'mod_settings', 3, 1, 1, 0, '', 'fa-solid fa-gears'),
(4, 'database', 'mod_database', 4, 1, 0, 0, '', 'fa-solid fa-database'),
(5, 'webtools', 'mod_webtools', 5, 1, 1, 0, '', 'fa-solid fa-toolbox'),
(6, 'seotools', 'mod_seotools', 6, 1, 1, 0, '', 'fa-brands fa-searchengin'),
(7, 'language', 'mod_language', 7, 1, 1, 0, '', 'fa-solid fa-language'),
(8, 'modules', 'mod_modules', 8, 1, 1, 0, '', 'fa-solid fa-cubes'),
(9, 'themes', 'mod_themes', 9, 1, 1, 0, '', 'fa-solid fa-palette'),
(10, 'extensions', 'mod_extensions', 10, 1, 0, 0, '', 'fa-solid fa-cubes-stacked'),
(11, 'upload', 'mod_upload', 11, 1, 1, 1, '', 'fa-solid fa-folder-plus'),
(12, 'emailtemplates', 'mod_emailtemplates', 12, 1, 1, 0, '', 'fa-solid fa-at')";

$sql_create_table[] = 'INSERT INTO ' . $db_config['prefix'] . "_upload_dir (did, dirname, time, thumb_type, thumb_width, thumb_height, thumb_quality) VALUES ('-1', '', 0, 3, 100, 150, 90)";
$sql_create_table[] = 'UPDATE ' . $db_config['prefix'] . "_upload_dir SET did = '0' WHERE did = '-1'";

$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'admin_theme', 'admin_default')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'online_upd', '1')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'statistic', '1')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'site_phone', '')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'googleAnalyticsID', '')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'googleAnalyticsSetDomainName', '0')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'googleAnalyticsMethod', 'classic')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'googleAnalytics4ID', '')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'searchEngineUniqueID', '')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'zaloOfficialAccountID', '')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'zaloAppID', '')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'zaloAppSecretKey', '')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'zaloOAAccessToken', '')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'zaloOARefreshToken', '')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'zaloOAAccessTokenTime', '0')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'zaloOASecretKey', '')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'metaTagsOgp', '1')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'pageTitleMode', 'pagetitle')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'description_length', '170')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'nv_unickmin', '" . $global_config['nv_unickmin'] . "')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'nv_unickmax', '" . $global_config['nv_unickmax'] . "')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'nv_upassmin', '" . $global_config['nv_upassmin'] . "')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'nv_upassmax', '" . $global_config['nv_upassmax'] . "')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'dir_forum', '')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'nv_unick_type', '" . $global_config['nv_unick_type'] . "')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'nv_upass_type', '" . $global_config['nv_upass_type'] . "')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'allowmailchange', '1')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'allowuserpublic', '1')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'allowquestion', '0')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'allowloginchange', '0')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'allowuserlogin', '1')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'allowuserloginmulti', '0')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'allowuserreg', '2')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'is_user_forum', '0')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'openid_servers', '')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'openid_processing', 'connect,create,auto')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'user_check_pass_time', '1800')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'auto_login_after_reg', '1')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'email_dot_equivalent', '1')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'email_plus_equivalent', '1')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'whoviewuser', '2')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'ssl_https', '0')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'facebook_client_id', '')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'facebook_client_secret', '')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'google_client_id', '')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'google_client_secret', '')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'referer_blocker', '1')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'private_site', '0')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'max_user_admin', 0)";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'max_user_number', 0)";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'captcha_area', 'r,m,p')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'captcha_type', 'captcha')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . ' (lang, module, config_name, config_value) VALUES (\'sys\', \'site\', \'nv_csp\', \'{"default-src":{"self":1},"script-src":{"self":1,"unsafe-inline":1,"unsafe-eval":1,"hosts":["*.google.com","*.google-analytics.com","*.googletagmanager.com","*.gstatic.com","*.facebook.com","*.facebook.net","*.twitter.com","*.zalo.me","*.zaloapp.com","*.tawk.to","*.cloudflareinsights.com"]},"style-src":{"self":1,"data":1,"unsafe-inline":1,"hosts":["*.google.com","*.googleapis.com","*.tawk.to"]},"img-src":{"self":1,"data":1,"hosts":["*.twitter.com","*.google.com","*.googleapis.com","*.google-analytics.com","*.gstatic.com","*.facebook.com","tawk.link","*.tawk.to","static.nukeviet.vn"]},"font-src":{"self":1,"data":1,"hosts":["*.googleapis.com","*.gstatic.com","*.tawk.to"]},"connect-src":{"self":1,"hosts":["*.google-analytics.com","*.zalo.me","*.tawk.to","wss:\/\/*.tawk.to"]},"media-src":{"self":1,"hosts":["*.tawk.to"]},"frame-src":{"self":1,"hosts":["*.google.com","*.youtube.com","*.facebook.com","*.facebook.net","*.twitter.com","*.zalo.me","*.live.com"]},"form-action":{"self":1,"hosts":["*.google.com"]}}\')';
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'nv_csp_act', '0')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'nv_csp_script_nonce', '0')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'nv_rp', 'no-referrer-when-downgrade, strict-origin-when-cross-origin')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'nv_rp_act', '1')";
$sql_create_table[] = "INSERT INTO " . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'nv_pp', 'accelerometer=(self), autoplay=(self \"https://youtube.com\" \"https://www.youtube.com\" \"https://*.youtube.com\"), camera=(self), display-capture=(self), encrypted-media=(self), fullscreen=(self \"https://youtube.com\" \"https://www.youtube.com\" \"https://*.youtube.com\"), gamepad=(self), geolocation=(self), gyroscope=(self), hid=(self), identity-credentials-get=(self), idle-detection=(self), local-fonts=(self), magnetometer=(self), microphone=(self), midi=(self), otp-credentials=(self), payment=(self), picture-in-picture=(self \"https://youtube.com\" \"https://www.youtube.com\" \"https://*.youtube.com\"), publickey-credentials-get=(self), screen-wake-lock=(self), serial=(self), storage-access=(self), usb=(self), web-share=(self), window-management=(self), xr-spatial-tracking=(self)')";
$sql_create_table[] = "INSERT INTO " . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'nv_pp_act', '1')";
$sql_create_table[] = "INSERT INTO " . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'nv_fp', 'accelerometer \'self\'; autoplay \'self\' https://youtube.com https://www.youtube.com; camera \'self\'; display-capture \'self\'; encrypted-media \'self\'; fullscreen \'self\' https://youtube.com https://www.youtube.com; gamepad \'self\'; geolocation \'self\'; gyroscope \'self\'; hid \'self\'; identity-credentials-get \'self\'; idle-detection \'self\'; local-fonts \'self\'; magnetometer \'self\'; microphone \'self\'; midi \'self\'; otp-credentials \'self\'; payment \'self\'; picture-in-picture \'self\' https://youtube.com https://www.youtube.com; publickey-credentials-get \'self\'; screen-wake-lock \'self\'; serial \'self\'; storage-access \'self\'; usb \'self\'; web-share \'self\'; window-management \'self\'; xr-spatial-tracking \'self\'')";
$sql_create_table[] = "INSERT INTO " . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'nv_fp_act', '1')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'pass_timeout', '0')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'oldpass_num', '5')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'send_pass', '0')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'login_name_type', 'username')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'remove_2step_method', '0')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'remove_2step_allow', '0')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'ogp_image', '')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'cronjobs_last_time', '0')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'cronjobs_interval', '5')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'cronjobs_launcher', 'system')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'inform_active', '1')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'inform_default_exp', '604800')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'inform_exp_del', '604800')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'inform_refresh_time', '30')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'inform_max_characters', '200')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'inform_numrows', '10')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'over_capacity', '0')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'show_folder_size', '0')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'sitelinks_search_box_schema', '1')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'organization_logo', '')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'breadcrumblist', '0')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'localbusiness', '0')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'google_tag_manager', '')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'thumb_max_width', '350')";
$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES ('sys', 'site', 'thumb_max_height', '350')";

$sql_create_table[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES
('sys', 'define', 'nv_gfx_num', '6'),
('sys', 'global', 'closed_site', '0'),
('sys', 'global', 'site_reopening_time', '0'),
('sys', 'global', 'notification_active', '1'),
('sys', 'global', 'notification_autodel', '15'),
('sys', 'global', 'site_keywords', 'NukeViet, portal, mysql, php'),
('sys', 'global', 'block_admin_ip', '0'),
('sys', 'global', 'admfirewall', '0'),
('sys', 'global', 'dump_autobackup', '1'),
('sys', 'global', 'dump_backup_ext', 'gz'),
('sys', 'global', 'dump_backup_day', '30'),
('sys', 'global', 'file_allowed_ext', 'adobe,archives,audio,documents,images,real,video'),
('sys', 'global', 'forbid_extensions', 'htm,html,htmls,js,php,php3,php4,php5,phtml,inc'),
('sys', 'global', 'forbid_mimes', 'application/ecmascript,application/javascript,application/x-javascript,text/ecmascript,text/html,text/javascript,application/x-httpd-php,application/x-httpd-php-source,application/php,application/x-php,text/php,text/x-php'),
('sys', 'global', 'nv_max_size', '" . min(nv_converttoBytes(ini_get('upload_max_filesize')), nv_converttoBytes(ini_get('post_max_size'))) . "'),
('sys', 'global', 'nv_overflow_size', '0'),
('sys', 'global', 'upload_checking_mode', 'strong'),
('sys', 'global', 'upload_alt_require', '1'),
('sys', 'global', 'upload_auto_alt', '1'),
('sys', 'global', 'upload_chunk_size', '0'),
('sys', 'global', 'useactivate', '2'),
('sys', 'global', 'allow_sitelangs', '" . NV_LANG_DATA . "'),
('sys', 'global', 'read_type', '0'),
('sys', 'global', 'rewrite_enable', '" . $global_config['rewrite_enable'] . "'),
('sys', 'global', 'rewrite_optional', '" . $global_config['rewrite_optional'] . "'),
('sys', 'global', 'rewrite_endurl', '" . $global_config['rewrite_endurl'] . "'),
('sys', 'global', 'rewrite_exturl', '" . $global_config['rewrite_exturl'] . "'),
('sys', 'global', 'rewrite_op_mod', ''),
('sys', 'global', 'autocheckupdate', '1'),
('sys', 'global', 'autoupdatetime', '24'),
('sys', 'global', 'gzip_method', '" . $global_config['gzip_method'] . "'),
('sys', 'global', 'blank_operation', '" . $global_config['blank_operation'] . "'),
('sys', 'global', 'resource_preload', '2'),
('sys', 'global', 'authors_detail_main', '0'),
('sys', 'global', 'spadmin_add_admin', '1'),
('sys', 'global', 'timestamp', '" . NV_CURRENTTIME . "'),
('sys', 'global', 'static_noquerystring', '0'),
('sys', 'global', 'version', '" . $global_config['version'] . "'),
('sys', 'global', 'cookie_httponly', '" . $global_config['cookie_httponly'] . "'),
('sys', 'global', 'admin_check_pass_time', '1800'),
('sys', 'global', 'admin_login_duration', '10800'),
('sys', 'global', 'admin_user_logout', '0'),
('sys', 'global', 'cookie_secure', '" . $global_config['cookie_secure'] . "'),
('sys', 'global', 'cookie_SameSite', '" . $global_config['cookie_SameSite'] . "'),
('sys', 'global', 'cookie_share', '0'),
('sys', 'global', 'is_flood_blocker', '1'),
('sys', 'global', 'max_requests_60', '40'),
('sys', 'global', 'max_requests_300', '150'),
('sys', 'global', 'is_login_blocker', '1'),
('sys', 'global', 'login_number_tracking', '5'),
('sys', 'global', 'login_time_tracking', '5'),
('sys', 'global', 'login_time_ban', '30'),
('sys', 'global', 'nv_display_errors_list', '1'),
('sys', 'global', 'display_errors_list', '1'),
('sys', 'global', 'nv_auto_resize', '1'),
('sys', 'global', 'dump_interval', '1'),
('sys', 'global', 'nv_static_url', ''),
('sys', 'global', 'cdn_url', ''),
('sys', 'global', 'assets_cdn', '0'),
('sys', 'global', 'two_step_verification', '0'),
('sys', 'global', 'admin_2step_opt', 'code'),
('sys', 'global', 'admin_2step_default', 'code'),
('sys', 'global', 'recaptcha_sitekey', ''),
('sys', 'global', 'recaptcha_secretkey', ''),
('sys', 'global', 'recaptcha_type', 'image'),
('sys', 'global', 'recaptcha_ver', '2'),
('sys', 'global', 'users_special', '0'),
('sys', 'global', 'crosssite_restrict', '1'),
('sys', 'global', 'crosssite_valid_domains', ''),
('sys', 'global', 'crosssite_valid_ips', ''),
('sys', 'global', 'crosssite_allowed_variables', ''),
('sys', 'global', 'crossadmin_restrict', '1'),
('sys', 'global', 'crossadmin_valid_domains', ''),
('sys', 'global', 'crossadmin_valid_ips', ''),
('sys', 'global', 'domains_whitelist', '[\"youtube.com\",\"www.youtube.com\",\"google.com\",\"www.google.com\",\"drive.google.com\",\"docs.google.com\",\"view.officeapps.live.com\"]'),
('sys', 'global', 'domains_restrict', '1'),
('sys', 'global', 'remote_api_access', '0'),
('sys', 'global', 'api_check_time', '5'),
('sys', 'global', 'allow_null_origin', '0'),
('sys', 'global', 'ip_allow_null_origin', ''),
('sys', 'global', 'cookie_notice_popup', '0'),
('sys', 'global', 'check_zaloip_expired', '0'),
('sys', 'global', 'zaloWebhookIPs', ''),
('sys', 'global', 'end_url_variables', ''),
('sys', 'global', 'request_uri_check', 'page'),
('sys', 'global', 'XSSsanitize', '1'),
('sys', 'global', 'admin_XSSsanitize', '1'),
('sys', 'global', 'unsign_vietwords', '1'),
('sys', 'global', 'passshow_button', '0'),
('sys', 'global', 'auto_acao', '1'),
('sys', 'global', 'load_files_seccode', ''),
('sys', 'global', 'error_separate_file', '0'),
('sys', 'global', 'region', ''),

('sys', 'define', 'nv_gfx_width', '150'),
('sys', 'define', 'nv_gfx_height', '40'),
('sys', 'define', 'nv_max_width', '1500'),
('sys', 'define', 'nv_max_height', '1500'),
('sys', 'define', 'nv_mobile_mode_img', '480'),
('sys', 'define', 'nv_live_cookie_time', '" . NV_LIVE_COOKIE_TIME . "'),
('sys', 'define', 'nv_live_session_time', '0'),
('sys', 'define', 'nv_anti_iframe', '" . NV_ANTI_IFRAME . "'),
('sys', 'define', 'nv_anti_agent', '" . NV_ANTI_AGENT . "'),
('sys', 'define', 'nv_allowed_html_tags', '" . NV_ALLOWED_HTML_TAGS . "'),
('sys', 'define', 'nv_debug', '" . NV_DEBUG . "')";

$sql_create_table[] = 'INSERT INTO ' . NV_CRONJOBS_GLOBALTABLE . ' (start_time, inter_val, run_file, run_func, params, del, is_sys, act, last_time, last_result) VALUES (' . NV_CURRENTTIME . ", 5, 'online_expired_del.php', 'cron_online_expired_del', '', 0, 1, 1, 0, 0)";
$sql_create_table[] = 'INSERT INTO ' . NV_CRONJOBS_GLOBALTABLE . ' (start_time, inter_val, run_file, run_func, params, del, is_sys, act, last_time, last_result) VALUES (' . NV_CURRENTTIME . ", 1440, 'dump_autobackup.php', 'cron_dump_autobackup', '', 0, 1, 1, 0, 0)";
$sql_create_table[] = 'INSERT INTO ' . NV_CRONJOBS_GLOBALTABLE . ' (start_time, inter_val, run_file, run_func, params, del, is_sys, act, last_time, last_result) VALUES (' . NV_CURRENTTIME . ", 60, 'temp_download_destroy.php', 'cron_auto_del_temp_download', '', 0, 1, 1, 0, 0)";
$sql_create_table[] = 'INSERT INTO ' . NV_CRONJOBS_GLOBALTABLE . ' (start_time, inter_val, run_file, run_func, params, del, is_sys, act, last_time, last_result) VALUES (' . NV_CURRENTTIME . ", 30, 'ip_logs_destroy.php', 'cron_del_ip_logs', '', 0, 1, 1, 0, 0)";
$sql_create_table[] = 'INSERT INTO ' . NV_CRONJOBS_GLOBALTABLE . ' (start_time, inter_val, run_file, run_func, params, del, is_sys, act, last_time, last_result) VALUES (' . NV_CURRENTTIME . ", 1440, 'error_log_destroy.php', 'cron_auto_del_error_log', '', 0, 1, 1, 0, 0)";
$sql_create_table[] = 'INSERT INTO ' . NV_CRONJOBS_GLOBALTABLE . ' (start_time, inter_val, run_file, run_func, params, del, is_sys, act, last_time, last_result) VALUES (' . NV_CURRENTTIME . ", 360, 'error_log_sendmail.php', 'cron_auto_sendmail_error_log', '', 0, 1, 0, 0, 0)";
$sql_create_table[] = 'INSERT INTO ' . NV_CRONJOBS_GLOBALTABLE . ' (start_time, inter_val, run_file, run_func, params, del, is_sys, act, last_time, last_result) VALUES (' . NV_CURRENTTIME . ", 60, 'ref_expired_del.php', 'cron_ref_expired_del', '', 0, 1, 1, 0, 0)";
$sql_create_table[] = 'INSERT INTO ' . NV_CRONJOBS_GLOBALTABLE . ' (start_time, inter_val, run_file, run_func, params, del, is_sys, act, last_time, last_result) VALUES (' . NV_CURRENTTIME . ", 60, 'check_version.php', 'cron_auto_check_version', '', 0, 1, 1, 0, 0)";
$sql_create_table[] = 'INSERT INTO ' . NV_CRONJOBS_GLOBALTABLE . ' (start_time, inter_val, run_file, run_func, params, del, is_sys, act, last_time, last_result) VALUES (' . NV_CURRENTTIME . ", 1440, 'notification_autodel.php', 'cron_notification_autodel', '', 0, 1, 1, 0, 0)";
$sql_create_table[] = 'INSERT INTO ' . NV_CRONJOBS_GLOBALTABLE . ' (start_time, inter_val, run_file, run_func, params, del, is_sys, act, last_time, last_result) VALUES (' . NV_CURRENTTIME . ", 1440, 'remove_expired_inform.php', 'cron_remove_expired_inform', '', 0, 1, 1, 0, 0)";
$sql_create_table[] = 'INSERT INTO ' . NV_CRONJOBS_GLOBALTABLE . ' (start_time, inter_val, run_file, run_func, params, del, is_sys, act, last_time, last_result) VALUES (' . NV_CURRENTTIME . ", 60, 'apilogs_autodel.php', 'cron_apilogs_autodel', '', 0, 1, 1, 0, 0)";
$sql_create_table[] = 'INSERT INTO ' . NV_CRONJOBS_GLOBALTABLE . ' (start_time, inter_val, run_file, run_func, params, del, is_sys, act, last_time, last_result) VALUES (' . NV_CURRENTTIME . ", 60, 'expadmin_handling.php', 'cron_expadmin_handling', '', 0, 1, 1, 0, 0)";

$sql_create_table[] = 'INSERT INTO ' . $db_config['prefix'] . "_setup_extensions (id, type, title, is_sys, is_virtual, basename, table_prefix, version, addtime, author, note) VALUES (0, 'module', 'about', 0, 0, 'page', 'about', '4.5.00 1626512400', " . NV_CURRENTTIME . ", 'VINADES <contact@vinades.vn>', '')";
$sql_create_table[] = 'INSERT INTO ' . $db_config['prefix'] . "_setup_extensions (id, type, title, is_sys, is_virtual, basename, table_prefix, version, addtime, author, note) VALUES (0, 'module', 'siteterms', 0, 0, 'page', 'siteterms', '4.5.00 1626512400', " . NV_CURRENTTIME . ", 'VINADES <contact@vinades.vn>', '')";
$sql_create_table[] = 'INSERT INTO ' . $db_config['prefix'] . "_setup_extensions (id, type, title, is_sys, is_virtual, basename, table_prefix, version, addtime, author, note) VALUES (19, 'module', 'banners', 1, 0, 'banners', 'banners', '4.5.00 1626512400', " . NV_CURRENTTIME . ", 'VINADES <contact@vinades.vn>', '')";
$sql_create_table[] = 'INSERT INTO ' . $db_config['prefix'] . "_setup_extensions (id, type, title, is_sys, is_virtual, basename, table_prefix, version, addtime, author, note) VALUES (0, 'module', 'zalo', 1, 0, 'zalo', 'zalo', '4.6.00 1637048941', " . NV_CURRENTTIME . ", 'VINADES <contact@vinades.vn>', '')";
$sql_create_table[] = 'INSERT INTO ' . $db_config['prefix'] . "_setup_extensions (id, type, title, is_sys, is_virtual, basename, table_prefix, version, addtime, author, note) VALUES (20, 'module', 'contact', 0, 1, 'contact', 'contact', '4.5.00 1626512400', " . NV_CURRENTTIME . ", 'VINADES <contact@vinades.vn>', '')";
$sql_create_table[] = 'INSERT INTO ' . $db_config['prefix'] . "_setup_extensions (id, type, title, is_sys, is_virtual, basename, table_prefix, version, addtime, author, note) VALUES (1, 'module', 'news', 0, 1, 'news', 'news', '4.5.00 1626512400', " . NV_CURRENTTIME . ", 'VINADES <contact@vinades.vn>', '')";
$sql_create_table[] = 'INSERT INTO ' . $db_config['prefix'] . "_setup_extensions (id, type, title, is_sys, is_virtual, basename, table_prefix, version, addtime, author, note) VALUES (21, 'module', 'voting', 0, 0, 'voting', 'voting', '4.5.00 1626512400', " . NV_CURRENTTIME . ", 'VINADES <contact@vinades.vn>', '')";
$sql_create_table[] = 'INSERT INTO ' . $db_config['prefix'] . "_setup_extensions (id, type, title, is_sys, is_virtual, basename, table_prefix, version, addtime, author, note) VALUES (22, 'module', 'forum', 0, 0, 'forum', 'forum', '4.5.00 1626512400', " . NV_CURRENTTIME . ", 'VINADES <contact@vinades.vn>', '')";
$sql_create_table[] = 'INSERT INTO ' . $db_config['prefix'] . "_setup_extensions (id, type, title, is_sys, is_virtual, basename, table_prefix, version, addtime, author, note) VALUES (284, 'module', 'seek', 1, 0, 'seek', 'seek', '4.5.00 1626512400', " . NV_CURRENTTIME . ", 'VINADES <contact@vinades.vn>', '')";
$sql_create_table[] = 'INSERT INTO ' . $db_config['prefix'] . "_setup_extensions (id, type, title, is_sys, is_virtual, basename, table_prefix, version, addtime, author, note) VALUES (24, 'module', 'users', 1, 1, 'users', 'users', '4.5.00 1626512400', " . NV_CURRENTTIME . ", 'VINADES <contact@vinades.vn>', '')";
$sql_create_table[] = 'INSERT INTO ' . $db_config['prefix'] . "_setup_extensions (id, type, title, is_sys, is_virtual, basename, table_prefix, version, addtime, author, note) VALUES (27, 'module', 'statistics', 0, 0, 'statistics', 'statistics', '4.5.00 1626512400', " . NV_CURRENTTIME . ", 'VINADES <contact@vinades.vn>', '')";
$sql_create_table[] = 'INSERT INTO ' . $db_config['prefix'] . "_setup_extensions (id, type, title, is_sys, is_virtual, basename, table_prefix, version, addtime, author, note) VALUES (29, 'module', 'menu', 0, 0, 'menu', 'menu', '4.5.00 1626512400', " . NV_CURRENTTIME . ", 'VINADES <contact@vinades.vn>', '')";
$sql_create_table[] = 'INSERT INTO ' . $db_config['prefix'] . "_setup_extensions (id, type, title, is_sys, is_virtual, basename, table_prefix, version, addtime, author, note) VALUES (283, 'module', 'feeds', 1, 0, 'feeds', 'feeds', '4.5.00 1626512400', " . NV_CURRENTTIME . ", 'VINADES <contact@vinades.vn>', '')";
$sql_create_table[] = 'INSERT INTO ' . $db_config['prefix'] . "_setup_extensions (id, type, title, is_sys, is_virtual, basename, table_prefix, version, addtime, author, note) VALUES (282, 'module', 'page', 1, 1, 'page', 'page', '4.5.00 1626512400', " . NV_CURRENTTIME . ", 'VINADES <contact@vinades.vn>', '')";
$sql_create_table[] = 'INSERT INTO ' . $db_config['prefix'] . "_setup_extensions (id, type, title, is_sys, is_virtual, basename, table_prefix, version, addtime, author, note) VALUES (281, 'module', 'comment', 1, 0, 'comment', 'comment', '4.5.00 1626512400', " . NV_CURRENTTIME . ", 'VINADES <contact@vinades.vn>', '')";
$sql_create_table[] = 'INSERT INTO ' . $db_config['prefix'] . "_setup_extensions (id, type, title, is_sys, is_virtual, basename, table_prefix, version, addtime, author, note) VALUES (312, 'module', 'freecontent', 0, 1, 'freecontent', 'freecontent', '4.5.00 1626512400', " . NV_CURRENTTIME . ", 'VINADES <contact@vinades.vn>', '')";
$sql_create_table[] = 'INSERT INTO ' . $db_config['prefix'] . "_setup_extensions (id, type, title, is_sys, is_virtual, basename, table_prefix, version, addtime, author, note) VALUES (327, 'module', 'two-step-verification', 1, 0, 'two-step-verification', 'two_step_verification', '4.5.00 1626512400', " . NV_CURRENTTIME . ", 'VINADES <contact@vinades.vn>', '')";
$sql_create_table[] = 'INSERT INTO ' . $db_config['prefix'] . "_setup_extensions (id, type, title, is_sys, is_virtual, basename, table_prefix, version, addtime, author, note) VALUES (307, 'theme', 'default', 0, 0, 'default', 'default', '4.5.00 1626512400', " . NV_CURRENTTIME . ", 'VINADES <contact@vinades.vn>', '')";
$sql_create_table[] = 'INSERT INTO ' . $db_config['prefix'] . "_setup_extensions (id, type, title, is_sys, is_virtual, basename, table_prefix, version, addtime, author, note) VALUES (311, 'theme', 'mobile_default', 0, 0, 'mobile_default', 'mobile_default', '4.5.00 1626512400', " . NV_CURRENTTIME . ", 'VINADES <contact@vinades.vn>', '')";
$sql_create_table[] = 'INSERT INTO ' . $db_config['prefix'] . "_setup_extensions (id, type, title, is_sys, is_virtual, basename, table_prefix, version, addtime, author, note) VALUES (22, 'module', 'inform', 1, 0, 'inform', 'inform', '4.6.00 1666092814', " . NV_CURRENTTIME . ", 'VINADES <contact@vinades.vn>', '')";
$sql_create_table[] = 'INSERT INTO ' . $db_config['prefix'] . "_setup_extensions (id, type, title, is_sys, is_virtual, basename, table_prefix, version, addtime, author, note) VALUES (22, 'module', 'myapi', 1, 0, 'myapi', 'myapi', '4.6.00 1666092814', " . NV_CURRENTTIME . ", 'VINADES <contact@vinades.vn>', '')";

// FIXME số 999 dùng để develop, sau sẽ xóa
$sql_create_table[] = 'INSERT INTO ' . $db_config['prefix'] . "_plugins (pid, plugin_file, plugin_area, plugin_module_name, plugin_module_file, weight) VALUES
(1, 'qrcode.php', 'get_qr_code', '', '', 1),
(2, 'cdn_js_css_image.php', 'change_site_buffer', '', '', 1),
(3, 'emf_code_user.php', 'get_email_merge_fields', 'users', 'users', 1),
(4, 'emf_core_author.php', 'get_email_merge_fields', '', '', 2),
(5, 'emf_all.php', 'get_email_merge_fields', '', '', 3),
(998, 'get_module_admin_theme.php', 'get_module_admin_theme', '', '', 1),
(999, 'get_global_admin_theme.php', 'get_global_admin_theme', '', '', 1)
";
