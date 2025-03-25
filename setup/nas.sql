-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: db
-- Generation Time: Mar 25, 2025 at 04:05 PM
-- Server version: 11.4.5-MariaDB-ubu2404
-- PHP Version: 8.2.27

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `nas`
--
CREATE DATABASE IF NOT EXISTS `nas` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `nas`;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_api_role`
--

DROP TABLE IF EXISTS `nv5_api_role`;
CREATE TABLE `nv5_api_role` (
  `role_id` smallint(4) NOT NULL,
  `role_md5title` char(32) NOT NULL,
  `role_type` enum('private','public') NOT NULL DEFAULT 'private',
  `role_object` enum('admin','user') NOT NULL DEFAULT 'admin',
  `role_title` varchar(250) NOT NULL DEFAULT '',
  `role_description` varchar(250) NOT NULL DEFAULT '',
  `role_data` text NOT NULL,
  `log_period` int(11) NOT NULL DEFAULT 0,
  `flood_rules` text NOT NULL,
  `addtime` int(11) NOT NULL DEFAULT 0,
  `edittime` int(11) NOT NULL DEFAULT 0,
  `status` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Role api';

-- --------------------------------------------------------

--
-- Table structure for table `nv5_api_role_credential`
--

DROP TABLE IF EXISTS `nv5_api_role_credential`;
CREATE TABLE `nv5_api_role_credential` (
  `id` int(11) NOT NULL,
  `userid` int(11) UNSIGNED NOT NULL,
  `role_id` smallint(4) UNSIGNED NOT NULL DEFAULT 0,
  `access_count` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `last_access` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `addtime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `endtime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `quota` int(20) UNSIGNED NOT NULL DEFAULT 0,
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Quyền truy cập API Role';

-- --------------------------------------------------------

--
-- Table structure for table `nv5_api_role_logs`
--

DROP TABLE IF EXISTS `nv5_api_role_logs`;
CREATE TABLE `nv5_api_role_logs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `role_id` smallint(4) NOT NULL DEFAULT 0,
  `userid` int(11) NOT NULL DEFAULT 0,
  `command` char(100) NOT NULL DEFAULT '',
  `log_time` int(11) NOT NULL DEFAULT 0,
  `log_ip` char(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Lịch sử gọi API';

-- --------------------------------------------------------

--
-- Table structure for table `nv5_api_user`
--

DROP TABLE IF EXISTS `nv5_api_user`;
CREATE TABLE `nv5_api_user` (
  `id` int(11) NOT NULL,
  `userid` int(11) UNSIGNED NOT NULL,
  `ident` varchar(50) NOT NULL DEFAULT '',
  `secret` varchar(250) NOT NULL DEFAULT '',
  `ips` text NOT NULL,
  `method` enum('none','password_verify','md5_verify') NOT NULL DEFAULT 'password_verify',
  `addtime` int(11) NOT NULL DEFAULT 0,
  `edittime` int(11) NOT NULL DEFAULT 0,
  `last_access` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='User API theo từng phương thức xác thực';

-- --------------------------------------------------------

--
-- Table structure for table `nv5_authors`
--

DROP TABLE IF EXISTS `nv5_authors`;
CREATE TABLE `nv5_authors` (
  `admin_id` int(11) UNSIGNED NOT NULL,
  `editor` varchar(100) DEFAULT '',
  `lev` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `lev_expired` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `after_exp_action` mediumtext DEFAULT NULL,
  `files_level` varchar(255) DEFAULT '',
  `position` varchar(255) NOT NULL,
  `main_module` varchar(50) NOT NULL DEFAULT 'siteinfo',
  `admin_theme` varchar(100) NOT NULL DEFAULT '',
  `addtime` int(11) NOT NULL DEFAULT 0,
  `edittime` int(11) NOT NULL DEFAULT 0,
  `is_suspend` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `susp_reason` text DEFAULT NULL,
  `pre_check_num` varchar(40) NOT NULL DEFAULT '',
  `pre_last_login` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `pre_last_ip` varchar(45) DEFAULT '',
  `pre_last_agent` varchar(255) DEFAULT '',
  `check_num` varchar(40) NOT NULL DEFAULT '',
  `last_login` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `last_ip` varchar(45) DEFAULT '',
  `last_agent` varchar(255) DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Quản trị site';

--
-- Dumping data for table `nv5_authors`
--

INSERT INTO `nv5_authors` (`admin_id`, `editor`, `lev`, `lev_expired`, `after_exp_action`, `files_level`, `position`, `main_module`, `admin_theme`, `addtime`, `edittime`, `is_suspend`, `susp_reason`, `pre_check_num`, `pre_last_login`, `pre_last_ip`, `pre_last_agent`, `check_num`, `last_login`, `last_ip`, `last_agent`) VALUES
(1, 'ckeditor5-classic', 1, 0, NULL, 'adobe,archives,audio,documents,images,real,video|1|1|1', 'Administrator', 'siteinfo', '', 0, 0, 0, '', '', 0, '', '', '3fc77ec7b4b39cac25350d11b4646c44', 1742893249, '172.19.1.0', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36');

-- --------------------------------------------------------

--
-- Table structure for table `nv5_authors_config`
--

DROP TABLE IF EXISTS `nv5_authors_config`;
CREATE TABLE `nv5_authors_config` (
  `id` mediumint(8) UNSIGNED NOT NULL,
  `keyname` varchar(39) NOT NULL DEFAULT '',
  `mask` tinyint(4) NOT NULL DEFAULT 0,
  `begintime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `endtime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `notice` varchar(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Cấu hình tường lửa từng tài khoản quản trị';

-- --------------------------------------------------------

--
-- Table structure for table `nv5_authors_module`
--

DROP TABLE IF EXISTS `nv5_authors_module`;
CREATE TABLE `nv5_authors_module` (
  `mid` mediumint(8) NOT NULL,
  `module` varchar(50) NOT NULL,
  `lang_key` varchar(50) NOT NULL DEFAULT '',
  `weight` mediumint(8) NOT NULL DEFAULT 0,
  `act_1` tinyint(4) NOT NULL DEFAULT 0,
  `act_2` tinyint(4) NOT NULL DEFAULT 1,
  `act_3` tinyint(4) NOT NULL DEFAULT 1,
  `checksum` varchar(32) DEFAULT '',
  `icon` varchar(100) NOT NULL DEFAULT '' COMMENT 'Icon'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bật tắt module trong quản trị theo cấp quản trị';

--
-- Dumping data for table `nv5_authors_module`
--

INSERT INTO `nv5_authors_module` (`mid`, `module`, `lang_key`, `weight`, `act_1`, `act_2`, `act_3`, `checksum`, `icon`) VALUES
(1, 'siteinfo', 'mod_siteinfo', 1, 1, 1, 1, 'b328de65d559374f88c2c982a5c1fb87', 'fa-solid fa-server'),
(2, 'authors', 'mod_authors', 2, 1, 1, 1, '709e68103e8a62d575aa4a617a49907e', 'fa-solid fa-user-gear'),
(3, 'settings', 'mod_settings', 3, 1, 1, 0, '177190d1abcbde923eafe09a3f6ed221', 'fa-solid fa-gears'),
(4, 'database', 'mod_database', 4, 1, 0, 0, '616c6d53357554782e6c5826e5ba6ef4', 'fa-solid fa-database'),
(5, 'webtools', 'mod_webtools', 5, 1, 1, 0, '4bd1054dbc31567e6fe96f4b64bb0560', 'fa-solid fa-toolbox'),
(6, 'seotools', 'mod_seotools', 6, 1, 1, 0, 'd29cbef06e62477f9e48e75897d67bdd', 'fa-brands fa-searchengin'),
(7, 'language', 'mod_language', 7, 1, 1, 0, '67bf8fe5c2120ca01163f7fe858c15da', 'fa-solid fa-language'),
(8, 'modules', 'mod_modules', 8, 1, 1, 0, 'b50e7f92cbc7e898ae18c9fdaca68a96', 'fa-solid fa-cubes'),
(9, 'themes', 'mod_themes', 9, 1, 1, 0, '6879ff23131c74f31fb9dc31f424e1a0', 'fa-solid fa-palette'),
(10, 'extensions', 'mod_extensions', 10, 1, 0, 0, 'f5e8a12cd81b0937ed955ec82cb8b89c', 'fa-solid fa-cubes-stacked'),
(11, 'upload', 'mod_upload', 11, 1, 1, 1, '5c66bec786efc7f1092960a2d0e2d9db', 'fa-solid fa-folder-plus'),
(12, 'emailtemplates', 'mod_emailtemplates', 12, 1, 1, 0, '642a8ff65254230ca87b8fb8a104b28b', 'fa-solid fa-at');

-- --------------------------------------------------------

--
-- Table structure for table `nv5_authors_oauth`
--

DROP TABLE IF EXISTS `nv5_authors_oauth`;
CREATE TABLE `nv5_authors_oauth` (
  `id` mediumint(8) UNSIGNED NOT NULL,
  `admin_id` int(11) UNSIGNED NOT NULL COMMENT 'ID của quản trị',
  `oauth_server` varchar(50) NOT NULL COMMENT 'Eg: facebook, google...',
  `oauth_uid` varchar(50) NOT NULL COMMENT 'ID duy nhất ứng với server',
  `oauth_email` varchar(50) NOT NULL COMMENT 'Email',
  `oauth_id` varchar(50) NOT NULL DEFAULT '',
  `addtime` int(11) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng lưu xác thực 2 bước từ oauth của admin';

-- --------------------------------------------------------

--
-- Table structure for table `nv5_authors_vars`
--

DROP TABLE IF EXISTS `nv5_authors_vars`;
CREATE TABLE `nv5_authors_vars` (
  `id` mediumint(8) UNSIGNED NOT NULL,
  `admin_id` int(11) UNSIGNED NOT NULL COMMENT 'ID của quản trị',
  `lang` varchar(3) NOT NULL DEFAULT 'all' COMMENT 'Ngôn ngữ hoặc tất cả',
  `theme` varchar(100) NOT NULL DEFAULT '' COMMENT 'Giao diện',
  `config_name` varchar(60) NOT NULL DEFAULT '' COMMENT 'Khóa cấu hình',
  `config_value` text DEFAULT NULL COMMENT 'Nội dung cấu hình',
  `weight` smallint(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Sắp xếp'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Các config khác của quản trị';

-- --------------------------------------------------------

--
-- Table structure for table `nv5_banners_click`
--

DROP TABLE IF EXISTS `nv5_banners_click`;
CREATE TABLE `nv5_banners_click` (
  `id` int(11) UNSIGNED NOT NULL,
  `bid` mediumint(8) NOT NULL DEFAULT 0,
  `click_time` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `click_day` int(2) NOT NULL,
  `click_ip` varchar(46) NOT NULL,
  `click_country` varchar(10) NOT NULL,
  `click_browse_key` varchar(100) NOT NULL,
  `click_browse_name` varchar(100) NOT NULL,
  `click_os_key` varchar(100) NOT NULL,
  `click_os_name` varchar(100) NOT NULL,
  `click_ref` varchar(255) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_banners_plans`
--

DROP TABLE IF EXISTS `nv5_banners_plans`;
CREATE TABLE `nv5_banners_plans` (
  `id` smallint(5) UNSIGNED NOT NULL,
  `blang` char(2) DEFAULT '',
  `title` varchar(250) NOT NULL,
  `description` text DEFAULT NULL,
  `form` varchar(100) NOT NULL,
  `width` smallint(4) UNSIGNED NOT NULL DEFAULT 0,
  `height` smallint(4) UNSIGNED NOT NULL DEFAULT 0,
  `act` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `require_image` tinyint(1) UNSIGNED NOT NULL DEFAULT 1,
  `uploadtype` varchar(255) NOT NULL DEFAULT '',
  `uploadgroup` varchar(255) NOT NULL DEFAULT '',
  `exp_time` int(11) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_banners_plans`
--

INSERT INTO `nv5_banners_plans` (`id`, `blang`, `title`, `description`, `form`, `width`, `height`, `act`, `require_image`, `uploadtype`, `uploadgroup`, `exp_time`) VALUES
(1, '', 'Mid-page ad block', '', 'sequential', 575, 72, 1, 1, 'images', '', 0),
(2, '', 'Left-column ad block', '', 'sequential', 212, 800, 1, 1, 'images', '', 0),
(3, '', 'Right-column ad block', '', 'random', 250, 500, 1, 1, 'images', '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_banners_rows`
--

DROP TABLE IF EXISTS `nv5_banners_rows`;
CREATE TABLE `nv5_banners_rows` (
  `id` mediumint(8) UNSIGNED NOT NULL,
  `title` varchar(255) NOT NULL,
  `pid` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `clid` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `file_name` varchar(255) NOT NULL,
  `file_ext` varchar(100) NOT NULL,
  `file_mime` varchar(100) NOT NULL,
  `width` int(4) UNSIGNED NOT NULL DEFAULT 0,
  `height` int(4) UNSIGNED NOT NULL DEFAULT 0,
  `file_alt` varchar(255) DEFAULT '',
  `imageforswf` varchar(255) DEFAULT '',
  `click_url` varchar(255) DEFAULT '',
  `target` varchar(10) NOT NULL DEFAULT '_blank',
  `bannerhtml` mediumtext NOT NULL,
  `add_time` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `publ_time` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `exp_time` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `hits_total` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `act` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `weight` int(11) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_banners_rows`
--

INSERT INTO `nv5_banners_rows` (`id`, `title`, `pid`, `clid`, `file_name`, `file_ext`, `file_mime`, `width`, `height`, `file_alt`, `imageforswf`, `click_url`, `target`, `bannerhtml`, `add_time`, `publ_time`, `exp_time`, `hits_total`, `act`, `weight`) VALUES
(1, 'Mid-page advertisement', 1, 1, 'webnhanh.jpg', 'png', 'image/jpeg', 575, 72, '', '', 'http://webnhanh.vn', '_blank', '', 1742685231, 1742685231, 0, 0, 1, 1),
(2, 'Left-column advertisement', 2, 1, 'vinades.jpg', 'jpg', 'image/jpeg', 212, 400, '', '', 'https://vinades.vn', '_blank', '', 1742685231, 1742685231, 0, 0, 1, 2);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_config`
--

DROP TABLE IF EXISTS `nv5_config`;
CREATE TABLE `nv5_config` (
  `lang` varchar(3) NOT NULL DEFAULT 'sys',
  `module` varchar(50) NOT NULL DEFAULT 'global',
  `config_name` varchar(30) NOT NULL DEFAULT '',
  `config_value` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Cấu hình hệ thống';

--
-- Dumping data for table `nv5_config`
--

INSERT INTO `nv5_config` (`lang`, `module`, `config_name`, `config_value`) VALUES
('sys', 'banners', 'captcha_type', 'captcha'),
('sys', 'define', 'nv_allowed_html_tags', 'embed, object, param, a, b, blockquote, br, caption, col, colgroup, div, em, h1, h2, h3, h4, h5, h6, hr, i, img, li, p, span, strong, s, sub, sup, table, tbody, td, th, tr, u, ul, ol, iframe, figure, figcaption, video, audio, source, track, code, pre, mark'),
('sys', 'define', 'nv_anti_agent', '0'),
('sys', 'define', 'nv_anti_iframe', '1'),
('sys', 'define', 'nv_debug', '1'),
('sys', 'define', 'nv_gfx_height', '40'),
('sys', 'define', 'nv_gfx_num', '6'),
('sys', 'define', 'nv_gfx_width', '150'),
('sys', 'define', 'nv_live_cookie_time', '31104000'),
('sys', 'define', 'nv_live_session_time', '0'),
('sys', 'define', 'nv_max_height', '1500'),
('sys', 'define', 'nv_max_width', '1500'),
('sys', 'define', 'nv_mobile_mode_img', '480'),
('sys', 'global', 'admfirewall', '0'),
('sys', 'global', 'admin_2step_default', 'code'),
('sys', 'global', 'admin_2step_opt', 'code'),
('sys', 'global', 'admin_check_pass_time', '1800'),
('sys', 'global', 'admin_login_duration', '10800'),
('sys', 'global', 'admin_rewrite', '1'),
('sys', 'global', 'admin_user_logout', '0'),
('sys', 'global', 'admin_XSSsanitize', '1'),
('sys', 'global', 'allow_null_origin', '0'),
('sys', 'global', 'allow_sitelangs', 'vi'),
('sys', 'global', 'api_check_time', '5'),
('sys', 'global', 'assets_cdn', '0'),
('sys', 'global', 'authors_detail_main', '0'),
('sys', 'global', 'auto_acao', '1'),
('sys', 'global', 'autocheckupdate', '1'),
('sys', 'global', 'autoupdatetime', '24'),
('sys', 'global', 'blank_operation', '1'),
('sys', 'global', 'block_admin_ip', '0'),
('sys', 'global', 'cdn_url', ''),
('sys', 'global', 'check_zaloip_expired', '0'),
('sys', 'global', 'closed_site', '0'),
('sys', 'global', 'cookie_httponly', '1'),
('sys', 'global', 'cookie_notice_popup', '0'),
('sys', 'global', 'cookie_prefix', 'nv4'),
('sys', 'global', 'cookie_SameSite', 'Lax'),
('sys', 'global', 'cookie_secure', '0'),
('sys', 'global', 'cookie_share', '0'),
('sys', 'global', 'crossadmin_restrict', '1'),
('sys', 'global', 'crossadmin_valid_domains', ''),
('sys', 'global', 'crossadmin_valid_ips', ''),
('sys', 'global', 'crosssite_allowed_variables', ''),
('sys', 'global', 'crosssite_restrict', '1'),
('sys', 'global', 'crosssite_valid_domains', ''),
('sys', 'global', 'crosssite_valid_ips', ''),
('sys', 'global', 'display_errors_list', '1'),
('sys', 'global', 'domains_restrict', '1'),
('sys', 'global', 'domains_whitelist', '[\"youtube.com\",\"www.youtube.com\",\"google.com\",\"www.google.com\",\"drive.google.com\",\"docs.google.com\",\"view.officeapps.live.com\"]'),
('sys', 'global', 'dump_autobackup', '0'),
('sys', 'global', 'dump_backup_day', '30'),
('sys', 'global', 'dump_backup_ext', 'gz'),
('sys', 'global', 'dump_interval', '1'),
('sys', 'global', 'end_url_variables', ''),
('sys', 'global', 'error_send_email', 'webmaster@blanas.local'),
('sys', 'global', 'error_separate_file', '0'),
('sys', 'global', 'error_set_logs', '1'),
('sys', 'global', 'file_allowed_ext', 'adobe,archives,audio,documents,images,real,video'),
('sys', 'global', 'forbid_extensions', 'htm,html,htmls,js,php,php3,php4,php5,phtml,inc'),
('sys', 'global', 'forbid_mimes', 'application/ecmascript,application/javascript,application/x-javascript,text/ecmascript,text/html,text/javascript,application/x-httpd-php,application/x-httpd-php-source,application/php,application/x-php,text/php,text/x-php'),
('sys', 'global', 'ftp_check_login', '0'),
('sys', 'global', 'ftp_path', '/'),
('sys', 'global', 'ftp_port', '21'),
('sys', 'global', 'ftp_server', 'localhost'),
('sys', 'global', 'ftp_user_name', ''),
('sys', 'global', 'ftp_user_pass', 'w9B7b5-rKtAUR7TuEHNUXg,,'),
('sys', 'global', 'gzip_method', '1'),
('sys', 'global', 'ip_allow_null_origin', ''),
('sys', 'global', 'is_flood_blocker', '1'),
('sys', 'global', 'is_login_blocker', '1'),
('sys', 'global', 'lang_geo', '0'),
('sys', 'global', 'lang_multi', '0'),
('sys', 'global', 'load_files_seccode', ''),
('sys', 'global', 'login_number_tracking', '5'),
('sys', 'global', 'login_time_ban', '30'),
('sys', 'global', 'login_time_tracking', '5'),
('sys', 'global', 'max_requests_300', '150'),
('sys', 'global', 'max_requests_60', '40'),
('sys', 'global', 'my_domains', 'blanas.local'),
('sys', 'global', 'notification_active', '1'),
('sys', 'global', 'notification_autodel', '15'),
('sys', 'global', 'nv_auto_resize', '1'),
('sys', 'global', 'nv_display_errors_list', '1'),
('sys', 'global', 'nv_max_size', '262144000'),
('sys', 'global', 'nv_overflow_size', '0'),
('sys', 'global', 'nv_static_url', ''),
('sys', 'global', 'passshow_button', '0'),
('sys', 'global', 'proxy_blocker', '0'),
('sys', 'global', 'read_type', '0'),
('sys', 'global', 'recaptcha_secretkey', ''),
('sys', 'global', 'recaptcha_sitekey', ''),
('sys', 'global', 'recaptcha_type', 'image'),
('sys', 'global', 'recaptcha_ver', '2'),
('sys', 'global', 'region', ''),
('sys', 'global', 'remote_api_access', '0'),
('sys', 'global', 'request_uri_check', 'page'),
('sys', 'global', 'resource_preload', '2'),
('sys', 'global', 'rewrite_enable', '1'),
('sys', 'global', 'rewrite_endurl', '/'),
('sys', 'global', 'rewrite_exturl', '.html'),
('sys', 'global', 'rewrite_op_mod', 'nas'),
('sys', 'global', 'rewrite_optional', '1'),
('sys', 'global', 'session_prefix', 'nv4s_j0WfIb'),
('sys', 'global', 'site_keywords', 'NukeViet, portal, mysql, php'),
('sys', 'global', 'site_lang', 'vi'),
('sys', 'global', 'site_reopening_time', '0'),
('sys', 'global', 'site_timezone', 'byCountry'),
('sys', 'global', 'spadmin_add_admin', '1'),
('sys', 'global', 'static_noquerystring', '0'),
('sys', 'global', 'str_referer_blocker', '0'),
('sys', 'global', 'timestamp', '1742685231'),
('sys', 'global', 'turnstile_secretkey', ''),
('sys', 'global', 'turnstile_sitekey', ''),
('sys', 'global', 'two_step_verification', '0'),
('sys', 'global', 'unsign_vietwords', '1'),
('sys', 'global', 'upload_alt_require', '1'),
('sys', 'global', 'upload_auto_alt', '1'),
('sys', 'global', 'upload_checking_mode', 'strong'),
('sys', 'global', 'upload_chunk_size', '0'),
('sys', 'global', 'useactivate', '2'),
('sys', 'global', 'users_special', '0'),
('sys', 'global', 'version', '5.0.00'),
('sys', 'global', 'XSSsanitize', '1'),
('sys', 'global', 'zaloWebhookIPs', ''),
('sys', 'site', 'admin_theme', 'admin_default'),
('sys', 'site', 'allowloginchange', '0'),
('sys', 'site', 'allowmailchange', '1'),
('sys', 'site', 'allowquestion', '0'),
('sys', 'site', 'allowuserlogin', '1'),
('sys', 'site', 'allowuserloginmulti', '0'),
('sys', 'site', 'allowuserpublic', '1'),
('sys', 'site', 'allowuserreg', '2'),
('sys', 'site', 'auto_login_after_reg', '1'),
('sys', 'site', 'breadcrumblist', '0'),
('sys', 'site', 'captcha_area', 'r,m,p'),
('sys', 'site', 'captcha_type', 'captcha'),
('sys', 'site', 'cronjobs_interval', '5'),
('sys', 'site', 'cronjobs_last_time', '1742893239'),
('sys', 'site', 'cronjobs_launcher', 'system'),
('sys', 'site', 'description_length', '170'),
('sys', 'site', 'dir_forum', ''),
('sys', 'site', 'email_dot_equivalent', '1'),
('sys', 'site', 'email_plus_equivalent', '1'),
('sys', 'site', 'facebook_client_id', ''),
('sys', 'site', 'facebook_client_secret', ''),
('sys', 'site', 'google_client_id', ''),
('sys', 'site', 'google_client_secret', ''),
('sys', 'site', 'google_tag_manager', ''),
('sys', 'site', 'googleAnalytics4ID', ''),
('sys', 'site', 'googleAnalyticsID', ''),
('sys', 'site', 'googleAnalyticsMethod', 'classic'),
('sys', 'site', 'googleAnalyticsSetDomainName', '0'),
('sys', 'site', 'inform_active', '1'),
('sys', 'site', 'inform_default_exp', '604800'),
('sys', 'site', 'inform_exp_del', '604800'),
('sys', 'site', 'inform_max_characters', '200'),
('sys', 'site', 'inform_numrows', '10'),
('sys', 'site', 'inform_refresh_time', '30'),
('sys', 'site', 'is_user_forum', '0'),
('sys', 'site', 'localbusiness', '0'),
('sys', 'site', 'login_name_type', 'username'),
('sys', 'site', 'max_user_admin', '0'),
('sys', 'site', 'max_user_number', '0'),
('sys', 'site', 'metaTagsOgp', '1'),
('sys', 'site', 'nv_csp', '{\"default-src\":{\"self\":1},\"script-src\":{\"self\":1,\"unsafe-inline\":1,\"unsafe-eval\":1,\"hosts\":[\"*.google.com\",\"*.google-analytics.com\",\"*.googletagmanager.com\",\"*.gstatic.com\",\"*.facebook.com\",\"*.facebook.net\",\"*.twitter.com\",\"*.zalo.me\",\"*.zaloapp.com\",\"*.tawk.to\",\"*.cloudflareinsights.com\",\"*.cloudflare.com\"]},\"style-src\":{\"self\":1,\"data\":1,\"unsafe-inline\":1,\"hosts\":[\"*.google.com\",\"*.googleapis.com\",\"*.tawk.to\"]},\"img-src\":{\"self\":1,\"data\":1,\"hosts\":[\"*.twitter.com\",\"*.google.com\",\"*.googleapis.com\",\"*.google-analytics.com\",\"*.gstatic.com\",\"*.facebook.com\",\"tawk.link\",\"*.tawk.to\",\"static.nukeviet.vn\"]},\"font-src\":{\"self\":1,\"data\":1,\"hosts\":[\"*.googleapis.com\",\"*.gstatic.com\",\"*.tawk.to\"]},\"connect-src\":{\"self\":1,\"hosts\":[\"*.google-analytics.com\",\"*.zalo.me\",\"*.tawk.to\",\"wss://*.tawk.to\"]},\"media-src\":{\"self\":1,\"hosts\":[\"*.tawk.to\"]},\"frame-src\":{\"self\":1,\"hosts\":[\"*.google.com\",\"*.youtube.com\",\"*.facebook.com\",\"*.facebook.net\",\"*.twitter.com\",\"*.zalo.me\",\"*.live.com\",\"*.cloudflare.com\"]},\"form-action\":{\"self\":1,\"hosts\":[\"*.google.com\"]}}'),
('sys', 'site', 'nv_csp_act', '0'),
('sys', 'site', 'nv_csp_script_nonce', '0'),
('sys', 'site', 'nv_fp', 'accelerometer \'self\'; autoplay \'self\' https://youtube.com https://www.youtube.com; camera \'self\'; display-capture \'self\'; encrypted-media \'self\'; fullscreen \'self\' https://youtube.com https://www.youtube.com; gamepad \'self\'; geolocation \'self\'; gyroscope \'self\'; hid \'self\'; identity-credentials-get \'self\'; idle-detection \'self\'; local-fonts \'self\'; magnetometer \'self\'; microphone \'self\'; midi \'self\'; otp-credentials \'self\'; payment \'self\'; picture-in-picture \'self\' https://youtube.com https://www.youtube.com; publickey-credentials-get \'self\'; screen-wake-lock \'self\'; serial \'self\'; storage-access \'self\'; usb \'self\'; web-share \'self\'; window-management \'self\'; xr-spatial-tracking \'self\''),
('sys', 'site', 'nv_fp_act', '1'),
('sys', 'site', 'nv_pp', 'accelerometer=(self), autoplay=(self \"https://youtube.com\" \"https://www.youtube.com\" \"https://*.youtube.com\"), camera=(self), display-capture=(self), encrypted-media=(self), fullscreen=(self \"https://youtube.com\" \"https://www.youtube.com\" \"https://*.youtube.com\"), gamepad=(self), geolocation=(self), gyroscope=(self), hid=(self), identity-credentials-get=(self), idle-detection=(self), local-fonts=(self), magnetometer=(self), microphone=(self), midi=(self), otp-credentials=(self), payment=(self), picture-in-picture=(self \"https://youtube.com\" \"https://www.youtube.com\" \"https://*.youtube.com\" \"https://*.cloudflare.com\"), publickey-credentials-get=(self), screen-wake-lock=(self), serial=(self), storage-access=(self), usb=(self), web-share=(self), window-management=(self), xr-spatial-tracking=(self)'),
('sys', 'site', 'nv_pp_act', '1'),
('sys', 'site', 'nv_rp', 'no-referrer-when-downgrade, strict-origin-when-cross-origin'),
('sys', 'site', 'nv_rp_act', '1'),
('sys', 'site', 'nv_unick_type', '4'),
('sys', 'site', 'nv_unickmax', '20'),
('sys', 'site', 'nv_unickmin', '4'),
('sys', 'site', 'nv_upass_type', '3'),
('sys', 'site', 'nv_upassmax', '32'),
('sys', 'site', 'nv_upassmin', '8'),
('sys', 'site', 'ogp_image', ''),
('sys', 'site', 'oldpass_num', '5'),
('sys', 'site', 'online_upd', '1'),
('sys', 'site', 'openid_processing', 'connect,create,auto'),
('sys', 'site', 'openid_servers', ''),
('sys', 'site', 'organization_logo', ''),
('sys', 'site', 'over_capacity', '0'),
('sys', 'site', 'pageTitleMode', 'pagetitle'),
('sys', 'site', 'pass_timeout', '0'),
('sys', 'site', 'private_site', '1'),
('sys', 'site', 'referer_blocker', '1'),
('sys', 'site', 'remove_2step_allow', '0'),
('sys', 'site', 'remove_2step_method', '0'),
('sys', 'site', 'searchEngineUniqueID', ''),
('sys', 'site', 'send_pass', '0'),
('sys', 'site', 'show_folder_size', '0'),
('sys', 'site', 'site_email', 'webmaster@blanas.local'),
('sys', 'site', 'site_phone', ''),
('sys', 'site', 'sitelinks_search_box_schema', '1'),
('sys', 'site', 'ssl_https', '0'),
('sys', 'site', 'stat_excl_bot', '0'),
('sys', 'site', 'statistic', '1'),
('sys', 'site', 'statistics_timezone', 'Asia/Bangkok'),
('sys', 'site', 'thumb_max_height', '350'),
('sys', 'site', 'thumb_max_width', '350'),
('sys', 'site', 'user_check_pass_time', '1800'),
('sys', 'site', 'whoviewuser', '2'),
('sys', 'site', 'zaloAppID', ''),
('sys', 'site', 'zaloAppSecretKey', ''),
('sys', 'site', 'zaloOAAccessToken', ''),
('sys', 'site', 'zaloOAAccessTokenTime', '0'),
('sys', 'site', 'zaloOARefreshToken', ''),
('sys', 'site', 'zaloOASecretKey', ''),
('sys', 'site', 'zaloOfficialAccountID', ''),
('vi', 'about', 'activecomm', '0'),
('vi', 'about', 'adminscomm', ''),
('vi', 'about', 'allowattachcomm', '0'),
('vi', 'about', 'allowed_comm', '-1'),
('vi', 'about', 'alloweditorcomm', '0'),
('vi', 'about', 'auto_postcomm', '1'),
('vi', 'about', 'captcha_area_comm', '1'),
('vi', 'about', 'emailcomm', '0'),
('vi', 'about', 'perpagecomm', '5'),
('vi', 'about', 'setcomm', '4'),
('vi', 'about', 'sortcomm', '0'),
('vi', 'about', 'timeoutcomm', '360'),
('vi', 'about', 'view_comm', '6'),
('vi', 'comment', 'captcha_type', 'captcha'),
('vi', 'contact', 'bodytext', 'Để không ngừng nâng cao chất lượng dịch vụ và đáp ứng tốt hơn nữa các yêu cầu của Quý khách, chúng tôi mong muốn nhận được các thông tin phản hồi. Nếu Quý khách có bất kỳ thắc mắc hoặc đóng góp nào, xin vui lòng liên hệ với chúng tôi theo thông tin dưới đây. Chúng tôi sẽ phản hồi lại Quý khách trong thời gian sớm nhất.'),
('vi', 'contact', 'captcha_type', 'captcha'),
('vi', 'contact', 'feedback_address', '0'),
('vi', 'contact', 'feedback_phone', '0'),
('vi', 'contact', 'sendcopymode', '0'),
('vi', 'contact', 'silent_mode', '1'),
('vi', 'freecontent', 'next_execute', '0'),
('vi', 'global', 'antispam_warning', '0'),
('vi', 'global', 'antispam_warning_content', ''),
('vi', 'global', 'autologomod', ''),
('vi', 'global', 'autologosize1', '50'),
('vi', 'global', 'autologosize2', '40'),
('vi', 'global', 'autologosize3', '30'),
('vi', 'global', 'data_warning', '0'),
('vi', 'global', 'data_warning_content', ''),
('vi', 'global', 'disable_site_content', 'Vì lý do kỹ thuật website tạm ngưng hoạt động. Thành thật xin lỗi các bạn vì sự bất tiện này!'),
('vi', 'global', 'dkim_included', 'sendmail,mail'),
('vi', 'global', 'force_reply', '0'),
('vi', 'global', 'force_sender', '0'),
('vi', 'global', 'mail_tpl', ''),
('vi', 'global', 'mailer_mode', 'mail'),
('vi', 'global', 'mobile_theme', ''),
('vi', 'global', 'name_show', '0'),
('vi', 'global', 'notify_email_error', '0'),
('vi', 'global', 'opensearch_link', ''),
('vi', 'global', 'preview_theme', ''),
('vi', 'global', 'reply_email', ''),
('vi', 'global', 'reply_name', ''),
('vi', 'global', 'sender_email', ''),
('vi', 'global', 'sender_name', ''),
('vi', 'global', 'site_banner', 'uploads/bg-2.jpg'),
('vi', 'global', 'site_description', 'Empowering Your Digital Storage'),
('vi', 'global', 'site_domain', ''),
('vi', 'global', 'site_favicon', 'uploads/icons/nas-fav.png'),
('vi', 'global', 'site_home_module', 'nas'),
('vi', 'global', 'site_keywords', ''),
('vi', 'global', 'site_logo', 'uploads/icons/nas-fav.png'),
('vi', 'global', 'site_name', 'BlaNAS'),
('vi', 'global', 'site_theme', 'default'),
('vi', 'global', 'smime_included', 'sendmail,mail'),
('vi', 'global', 'smtp_host', 'smtp.gmail.com'),
('vi', 'global', 'smtp_password', 'QY4NXrc18UtceZ8HB5fiMA,,'),
('vi', 'global', 'smtp_port', '465'),
('vi', 'global', 'smtp_ssl', '1'),
('vi', 'global', 'smtp_username', 'user@gmail.com'),
('vi', 'global', 'switch_mobi_des', '0'),
('vi', 'global', 'theme_type', 'r'),
('vi', 'global', 'tinify_active', '0'),
('vi', 'global', 'tinify_api', ''),
('vi', 'global', 'upload_logo', ''),
('vi', 'global', 'upload_logo_pos', 'bottomRight'),
('vi', 'global', 'user_allowed_theme', ''),
('vi', 'global', 'verify_peer_name_ssl', '1'),
('vi', 'global', 'verify_peer_ssl', '1'),
('vi', 'nas', 'coturn_auth', '1'),
('vi', 'nas', 'coturn_live', '600'),
('vi', 'nas', 'coturn_pass', 'HTsHMaAuLqq1NppA'),
('vi', 'nas', 'coturn_secret', 'S92ADLUSGNBFFatrhRq8WnAF9EXJ5hxs'),
('vi', 'nas', 'coturn_server', '127.0.0.1:3478'),
('vi', 'nas', 'coturn_user', 'webmaster'),
('vi', 'nas', 'ice_servers', ''),
('vi', 'nas', 'system_quota', '1099511627776'),
('vi', 'nas', 'turn_enabled', '1'),
('vi', 'nas', 'turn_public', '1'),
('vi', 'nas', 'turn_type', '0'),
('vi', 'nas', 'websocket_url', 'ws://127.0.0.1:3001'),
('vi', 'news', 'active_history', '0'),
('vi', 'news', 'activecomm', '1'),
('vi', 'news', 'adminscomm', ''),
('vi', 'news', 'alias_lower', '1'),
('vi', 'news', 'allowattachcomm', '0'),
('vi', 'news', 'allowed_comm', '-1'),
('vi', 'news', 'allowed_rating', '1'),
('vi', 'news', 'allowed_rating_point', '1'),
('vi', 'news', 'alloweditorcomm', '0'),
('vi', 'news', 'auto_postcomm', '1'),
('vi', 'news', 'auto_save', '0'),
('vi', 'news', 'auto_tags', '0'),
('vi', 'news', 'blockheight', '75'),
('vi', 'news', 'blockwidth', '70'),
('vi', 'news', 'captcha_area_comm', '1'),
('vi', 'news', 'captcha_type', 'captcha'),
('vi', 'news', 'config_source', '0'),
('vi', 'news', 'copy_news', '1'),
('vi', 'news', 'copyright', 'Chú ý: Việc đăng lại bài viết trên ở website hoặc các phương tiện truyền thông khác mà không ghi rõ nguồn https://nukeviet.vn là vi phạm bản quyền'),
('vi', 'news', 'elas_host', ''),
('vi', 'news', 'elas_index', ''),
('vi', 'news', 'elas_port', '9200'),
('vi', 'news', 'elas_use', '0'),
('vi', 'news', 'emailcomm', '0'),
('vi', 'news', 'facebookappid', ''),
('vi', 'news', 'frontend_edit_alias', '0'),
('vi', 'news', 'frontend_edit_layout', '1'),
('vi', 'news', 'hide_author', '0'),
('vi', 'news', 'hide_inauthor', '0'),
('vi', 'news', 'homeheight', '150'),
('vi', 'news', 'homewidth', '100'),
('vi', 'news', 'htmlhometext', '0'),
('vi', 'news', 'identify_cat_change', '0'),
('vi', 'news', 'imagefull', '460'),
('vi', 'news', 'imgposition', '2'),
('vi', 'news', 'indexfile', 'viewcat_main_right'),
('vi', 'news', 'instant_articles_active', '0'),
('vi', 'news', 'instant_articles_auto', '1'),
('vi', 'news', 'instant_articles_gettime', '120'),
('vi', 'news', 'instant_articles_httpauth', '0'),
('vi', 'news', 'instant_articles_livetime', '60'),
('vi', 'news', 'instant_articles_password', ''),
('vi', 'news', 'instant_articles_template', 'default'),
('vi', 'news', 'instant_articles_username', ''),
('vi', 'news', 'keywords_tag', '1'),
('vi', 'news', 'mobile_indexfile', 'viewcat_page_new'),
('vi', 'news', 'order_articles', '0'),
('vi', 'news', 'per_page', '20'),
('vi', 'news', 'perpagecomm', '5'),
('vi', 'news', 'report_active', '1'),
('vi', 'news', 'report_group', '4'),
('vi', 'news', 'report_limit', '2'),
('vi', 'news', 'setcomm', '4'),
('vi', 'news', 'show_no_image', ''),
('vi', 'news', 'showhometext', '1'),
('vi', 'news', 'showtooltip', '1'),
('vi', 'news', 'socialbutton', 'facebook,twitter'),
('vi', 'news', 'sortcomm', '0'),
('vi', 'news', 'st_links', '10'),
('vi', 'news', 'structure_upload', 'Ym'),
('vi', 'news', 'tags_alias', '0'),
('vi', 'news', 'tags_remind', '1'),
('vi', 'news', 'timecheckstatus', '0'),
('vi', 'news', 'timeoutcomm', '360'),
('vi', 'news', 'tooltip_length', '150'),
('vi', 'news', 'tooltip_position', 'bottom'),
('vi', 'news', 'view_comm', '6'),
('vi', 'page', 'activecomm', '0'),
('vi', 'page', 'adminscomm', ''),
('vi', 'page', 'allowattachcomm', '0'),
('vi', 'page', 'allowed_comm', '-1'),
('vi', 'page', 'alloweditorcomm', '0'),
('vi', 'page', 'auto_postcomm', '1'),
('vi', 'page', 'captcha_area_comm', '1'),
('vi', 'page', 'emailcomm', '0'),
('vi', 'page', 'perpagecomm', '5'),
('vi', 'page', 'setcomm', '4'),
('vi', 'page', 'sortcomm', '0'),
('vi', 'page', 'timeoutcomm', '360'),
('vi', 'page', 'view_comm', '6'),
('vi', 'seotools', 'prcservice', ''),
('vi', 'siteterms', 'activecomm', '0'),
('vi', 'siteterms', 'adminscomm', ''),
('vi', 'siteterms', 'allowattachcomm', '0'),
('vi', 'siteterms', 'allowed_comm', '-1'),
('vi', 'siteterms', 'alloweditorcomm', '0'),
('vi', 'siteterms', 'auto_postcomm', '1'),
('vi', 'siteterms', 'captcha_area_comm', '1'),
('vi', 'siteterms', 'emailcomm', '0'),
('vi', 'siteterms', 'perpagecomm', '5'),
('vi', 'siteterms', 'setcomm', '4'),
('vi', 'siteterms', 'sortcomm', '0'),
('vi', 'siteterms', 'timeoutcomm', '360'),
('vi', 'siteterms', 'view_comm', '6'),
('vi', 'voting', 'captcha_type', 'captcha'),
('vi', 'voting', 'difftimeout', '3600');

-- --------------------------------------------------------

--
-- Table structure for table `nv5_cookies`
--

DROP TABLE IF EXISTS `nv5_cookies`;
CREATE TABLE `nv5_cookies` (
  `name` varchar(50) NOT NULL DEFAULT '',
  `value` mediumtext NOT NULL,
  `domain` varchar(100) NOT NULL DEFAULT '',
  `path` varchar(100) NOT NULL DEFAULT '',
  `expires` int(11) NOT NULL DEFAULT 0,
  `secure` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Cookie truy cập kho store';

-- --------------------------------------------------------

--
-- Table structure for table `nv5_counter`
--

DROP TABLE IF EXISTS `nv5_counter`;
CREATE TABLE `nv5_counter` (
  `c_type` varchar(100) NOT NULL,
  `c_val` varchar(100) NOT NULL,
  `last_update` int(11) NOT NULL DEFAULT 0,
  `c_count` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `vi_count` int(11) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Thống kê truy cập';

--
-- Dumping data for table `nv5_counter`
--

INSERT INTO `nv5_counter` (`c_type`, `c_val`, `last_update`, `c_count`, `vi_count`) VALUES
('bot', 'bingbot', 0, 0, 0),
('bot', 'coccocbot', 0, 0, 0),
('bot', 'googlebot', 0, 0, 0),
('bot', 'msnbot', 0, 0, 0),
('bot', 'w3cvalidator', 0, 0, 0),
('bot', 'yahooslurp', 0, 0, 0),
('browser', 'amaya', 0, 0, 0),
('browser', 'android', 0, 0, 0),
('browser', 'bingbot', 0, 0, 0),
('browser', 'blackberry', 0, 0, 0),
('browser', 'bots', 0, 0, 0),
('browser', 'chrome', 1742893239, 6, 6),
('browser', 'coccoc', 0, 0, 0),
('browser', 'coccocbot', 0, 0, 0),
('browser', 'edge', 0, 0, 0),
('browser', 'explorer', 0, 0, 0),
('browser', 'firebird', 0, 0, 0),
('browser', 'firefox', 1742893379, 1, 1),
('browser', 'galeon', 0, 0, 0),
('browser', 'googlebot', 0, 0, 0),
('browser', 'icab', 0, 0, 0),
('browser', 'icecat', 0, 0, 0),
('browser', 'iceweasel', 0, 0, 0),
('browser', 'ipad', 0, 0, 0),
('browser', 'iphone', 0, 0, 0),
('browser', 'ipod', 0, 0, 0),
('browser', 'konqueror', 0, 0, 0),
('browser', 'lynx', 0, 0, 0),
('browser', 'Mobile', 0, 0, 0),
('browser', 'mozilla', 0, 0, 0),
('browser', 'msn', 0, 0, 0),
('browser', 'msnbot', 0, 0, 0),
('browser', 'netpositive', 0, 0, 0),
('browser', 'netscape', 0, 0, 0),
('browser', 'nokia', 0, 0, 0),
('browser', 'nokias60', 0, 0, 0),
('browser', 'omniweb', 0, 0, 0),
('browser', 'opera', 0, 0, 0),
('browser', 'operamini', 0, 0, 0),
('browser', 'phoenix', 0, 0, 0),
('browser', 'pocket', 0, 0, 0),
('browser', 'safari', 0, 0, 0),
('browser', 'shiretoko', 0, 0, 0),
('browser', 'Unknown', 0, 0, 0),
('browser', 'w3cvalidator', 0, 0, 0),
('browser', 'webtv', 0, 0, 0),
('browser', 'yahooslurp', 0, 0, 0),
('c_time', 'last', 0, 1742893379, 0),
('c_time', 'start', 0, 0, 0),
('country', 'AD', 0, 0, 0),
('country', 'AE', 0, 0, 0),
('country', 'AF', 0, 0, 0),
('country', 'AG', 0, 0, 0),
('country', 'AI', 0, 0, 0),
('country', 'AL', 0, 0, 0),
('country', 'AM', 0, 0, 0),
('country', 'AN', 0, 0, 0),
('country', 'AO', 0, 0, 0),
('country', 'AQ', 0, 0, 0),
('country', 'AR', 0, 0, 0),
('country', 'AS', 0, 0, 0),
('country', 'AT', 0, 0, 0),
('country', 'AU', 0, 0, 0),
('country', 'AW', 0, 0, 0),
('country', 'AZ', 0, 0, 0),
('country', 'BA', 0, 0, 0),
('country', 'BB', 0, 0, 0),
('country', 'BD', 0, 0, 0),
('country', 'BE', 0, 0, 0),
('country', 'BF', 0, 0, 0),
('country', 'BG', 0, 0, 0),
('country', 'BH', 0, 0, 0),
('country', 'BI', 0, 0, 0),
('country', 'BJ', 0, 0, 0),
('country', 'BM', 0, 0, 0),
('country', 'BN', 0, 0, 0),
('country', 'BO', 0, 0, 0),
('country', 'BR', 0, 0, 0),
('country', 'BS', 0, 0, 0),
('country', 'BT', 0, 0, 0),
('country', 'BW', 0, 0, 0),
('country', 'BY', 0, 0, 0),
('country', 'BZ', 0, 0, 0),
('country', 'CA', 0, 0, 0),
('country', 'CD', 0, 0, 0),
('country', 'CF', 0, 0, 0),
('country', 'CG', 0, 0, 0),
('country', 'CH', 0, 0, 0),
('country', 'CI', 0, 0, 0),
('country', 'CK', 0, 0, 0),
('country', 'CL', 0, 0, 0),
('country', 'CM', 0, 0, 0),
('country', 'CN', 0, 0, 0),
('country', 'CO', 0, 0, 0),
('country', 'CR', 0, 0, 0),
('country', 'CS', 0, 0, 0),
('country', 'CU', 0, 0, 0),
('country', 'CV', 0, 0, 0),
('country', 'CY', 0, 0, 0),
('country', 'CZ', 0, 0, 0),
('country', 'DE', 0, 0, 0),
('country', 'DJ', 0, 0, 0),
('country', 'DK', 0, 0, 0),
('country', 'DM', 0, 0, 0),
('country', 'DO', 0, 0, 0),
('country', 'DZ', 0, 0, 0),
('country', 'EC', 0, 0, 0),
('country', 'EE', 0, 0, 0),
('country', 'EG', 0, 0, 0),
('country', 'ER', 0, 0, 0),
('country', 'ES', 0, 0, 0),
('country', 'ET', 0, 0, 0),
('country', 'EU', 0, 0, 0),
('country', 'FI', 0, 0, 0),
('country', 'FJ', 0, 0, 0),
('country', 'FK', 0, 0, 0),
('country', 'FM', 0, 0, 0),
('country', 'FO', 0, 0, 0),
('country', 'FR', 0, 0, 0),
('country', 'GA', 0, 0, 0),
('country', 'GB', 0, 0, 0),
('country', 'GD', 0, 0, 0),
('country', 'GE', 0, 0, 0),
('country', 'GF', 0, 0, 0),
('country', 'GH', 0, 0, 0),
('country', 'GI', 0, 0, 0),
('country', 'GL', 0, 0, 0),
('country', 'GM', 0, 0, 0),
('country', 'GN', 0, 0, 0),
('country', 'GP', 0, 0, 0),
('country', 'GQ', 0, 0, 0),
('country', 'GR', 0, 0, 0),
('country', 'GS', 0, 0, 0),
('country', 'GT', 0, 0, 0),
('country', 'GU', 0, 0, 0),
('country', 'GW', 0, 0, 0),
('country', 'GY', 0, 0, 0),
('country', 'HK', 0, 0, 0),
('country', 'HN', 0, 0, 0),
('country', 'HR', 0, 0, 0),
('country', 'HT', 0, 0, 0),
('country', 'HU', 0, 0, 0),
('country', 'ID', 0, 0, 0),
('country', 'IE', 0, 0, 0),
('country', 'IL', 0, 0, 0),
('country', 'IN', 0, 0, 0),
('country', 'IO', 0, 0, 0),
('country', 'IQ', 0, 0, 0),
('country', 'IR', 0, 0, 0),
('country', 'IS', 0, 0, 0),
('country', 'IT', 0, 0, 0),
('country', 'JM', 0, 0, 0),
('country', 'JO', 0, 0, 0),
('country', 'JP', 0, 0, 0),
('country', 'KE', 0, 0, 0),
('country', 'KG', 0, 0, 0),
('country', 'KH', 0, 0, 0),
('country', 'KI', 0, 0, 0),
('country', 'KM', 0, 0, 0),
('country', 'KN', 0, 0, 0),
('country', 'KR', 0, 0, 0),
('country', 'KW', 0, 0, 0),
('country', 'KY', 0, 0, 0),
('country', 'KZ', 0, 0, 0),
('country', 'LA', 0, 0, 0),
('country', 'LB', 0, 0, 0),
('country', 'LC', 0, 0, 0),
('country', 'LI', 0, 0, 0),
('country', 'LK', 0, 0, 0),
('country', 'LR', 0, 0, 0),
('country', 'LS', 0, 0, 0),
('country', 'LT', 0, 0, 0),
('country', 'LU', 0, 0, 0),
('country', 'LV', 0, 0, 0),
('country', 'LY', 0, 0, 0),
('country', 'MA', 0, 0, 0),
('country', 'MC', 0, 0, 0),
('country', 'MD', 0, 0, 0),
('country', 'MG', 0, 0, 0),
('country', 'MH', 0, 0, 0),
('country', 'MK', 0, 0, 0),
('country', 'ML', 0, 0, 0),
('country', 'MM', 0, 0, 0),
('country', 'MN', 0, 0, 0),
('country', 'MO', 0, 0, 0),
('country', 'MP', 0, 0, 0),
('country', 'MQ', 0, 0, 0),
('country', 'MR', 0, 0, 0),
('country', 'MT', 0, 0, 0),
('country', 'MU', 0, 0, 0),
('country', 'MV', 0, 0, 0),
('country', 'MW', 0, 0, 0),
('country', 'MX', 0, 0, 0),
('country', 'MY', 0, 0, 0),
('country', 'MZ', 0, 0, 0),
('country', 'NA', 0, 0, 0),
('country', 'NC', 0, 0, 0),
('country', 'NE', 0, 0, 0),
('country', 'NF', 0, 0, 0),
('country', 'NG', 0, 0, 0),
('country', 'NI', 0, 0, 0),
('country', 'NL', 0, 0, 0),
('country', 'NO', 0, 0, 0),
('country', 'NP', 0, 0, 0),
('country', 'NR', 0, 0, 0),
('country', 'NU', 0, 0, 0),
('country', 'NZ', 0, 0, 0),
('country', 'OM', 0, 0, 0),
('country', 'PA', 0, 0, 0),
('country', 'PE', 0, 0, 0),
('country', 'PF', 0, 0, 0),
('country', 'PG', 0, 0, 0),
('country', 'PH', 0, 0, 0),
('country', 'PK', 0, 0, 0),
('country', 'PL', 0, 0, 0),
('country', 'PR', 0, 0, 0),
('country', 'PS', 0, 0, 0),
('country', 'PT', 0, 0, 0),
('country', 'PW', 0, 0, 0),
('country', 'PY', 0, 0, 0),
('country', 'QA', 0, 0, 0),
('country', 'RE', 0, 0, 0),
('country', 'RO', 0, 0, 0),
('country', 'RU', 0, 0, 0),
('country', 'RW', 0, 0, 0),
('country', 'SA', 0, 0, 0),
('country', 'SB', 0, 0, 0),
('country', 'SC', 0, 0, 0),
('country', 'SD', 0, 0, 0),
('country', 'SE', 0, 0, 0),
('country', 'SG', 0, 0, 0),
('country', 'SI', 0, 0, 0),
('country', 'SK', 0, 0, 0),
('country', 'SL', 0, 0, 0),
('country', 'SM', 0, 0, 0),
('country', 'SN', 0, 0, 0),
('country', 'SO', 0, 0, 0),
('country', 'SR', 0, 0, 0),
('country', 'ST', 0, 0, 0),
('country', 'SV', 0, 0, 0),
('country', 'SY', 0, 0, 0),
('country', 'SZ', 0, 0, 0),
('country', 'TD', 0, 0, 0),
('country', 'TF', 0, 0, 0),
('country', 'TG', 0, 0, 0),
('country', 'TH', 0, 0, 0),
('country', 'TJ', 0, 0, 0),
('country', 'TK', 0, 0, 0),
('country', 'TL', 0, 0, 0),
('country', 'TM', 0, 0, 0),
('country', 'TN', 0, 0, 0),
('country', 'TO', 0, 0, 0),
('country', 'TR', 0, 0, 0),
('country', 'TT', 0, 0, 0),
('country', 'TV', 0, 0, 0),
('country', 'TW', 0, 0, 0),
('country', 'TZ', 0, 0, 0),
('country', 'UA', 0, 0, 0),
('country', 'UG', 0, 0, 0),
('country', 'unkown', 0, 0, 0),
('country', 'US', 0, 0, 0),
('country', 'UY', 0, 0, 0),
('country', 'UZ', 0, 0, 0),
('country', 'VA', 0, 0, 0),
('country', 'VC', 0, 0, 0),
('country', 'VE', 0, 0, 0),
('country', 'VG', 0, 0, 0),
('country', 'VI', 0, 0, 0),
('country', 'VN', 0, 0, 0),
('country', 'VU', 0, 0, 0),
('country', 'WS', 0, 0, 0),
('country', 'YE', 0, 0, 0),
('country', 'YT', 0, 0, 0),
('country', 'YU', 0, 0, 0),
('country', 'ZA', 0, 0, 0),
('country', 'ZM', 0, 0, 0),
('country', 'ZW', 0, 0, 0),
('country', 'ZZ', 1742893379, 7, 7),
('day', '01', 0, 0, 0),
('day', '02', 0, 0, 0),
('day', '03', 0, 0, 0),
('day', '04', 0, 0, 0),
('day', '05', 0, 0, 0),
('day', '06', 0, 0, 0),
('day', '07', 0, 0, 0),
('day', '08', 0, 0, 0),
('day', '09', 0, 0, 0),
('day', '10', 0, 0, 0),
('day', '11', 0, 0, 0),
('day', '12', 0, 0, 0),
('day', '13', 0, 0, 0),
('day', '14', 0, 0, 0),
('day', '15', 0, 0, 0),
('day', '16', 0, 0, 0),
('day', '17', 0, 0, 0),
('day', '18', 0, 0, 0),
('day', '19', 0, 0, 0),
('day', '20', 0, 0, 0),
('day', '21', 0, 0, 0),
('day', '22', 0, 0, 0),
('day', '23', 1742741686, 4, 4),
('day', '24', 1742822689, 1, 1),
('day', '25', 1742893379, 2, 2),
('day', '26', 0, 0, 0),
('day', '27', 0, 0, 0),
('day', '28', 0, 0, 0),
('day', '29', 0, 0, 0),
('day', '30', 0, 0, 0),
('day', '31', 0, 0, 0),
('dayofweek', 'Friday', 0, 0, 0),
('dayofweek', 'Monday', 1742822689, 1, 1),
('dayofweek', 'Saturday', 0, 0, 0),
('dayofweek', 'Sunday', 1742741686, 4, 4),
('dayofweek', 'Thursday', 0, 0, 0),
('dayofweek', 'Tuesday', 1742893379, 2, 2),
('dayofweek', 'Wednesday', 0, 0, 0),
('hour', '00', 0, 0, 0),
('hour', '01', 0, 0, 0),
('hour', '02', 0, 0, 0),
('hour', '03', 0, 0, 0),
('hour', '04', 0, 0, 0),
('hour', '05', 0, 0, 0),
('hour', '06', 1742687591, 0, 0),
('hour', '07', 1742689567, 0, 0),
('hour', '08', 0, 0, 0),
('hour', '09', 0, 0, 0),
('hour', '10', 0, 0, 0),
('hour', '11', 0, 0, 0),
('hour', '12', 0, 0, 0),
('hour', '13', 0, 0, 0),
('hour', '14', 0, 0, 0),
('hour', '15', 0, 0, 0),
('hour', '16', 1742893379, 2, 2),
('hour', '17', 0, 0, 0),
('hour', '18', 0, 0, 0),
('hour', '19', 0, 0, 0),
('hour', '20', 1742822689, 0, 0),
('hour', '21', 1742741686, 0, 0),
('hour', '22', 0, 0, 0),
('hour', '23', 0, 0, 0),
('month', 'Apr', 0, 0, 0),
('month', 'Aug', 0, 0, 0),
('month', 'Dec', 0, 0, 0),
('month', 'Feb', 0, 0, 0),
('month', 'Jan', 0, 0, 0),
('month', 'Jul', 0, 0, 0),
('month', 'Jun', 0, 0, 0),
('month', 'Mar', 1742893379, 7, 7),
('month', 'May', 0, 0, 0),
('month', 'Nov', 0, 0, 0),
('month', 'Oct', 0, 0, 0),
('month', 'Sep', 0, 0, 0),
('os', 'android', 0, 0, 0),
('os', 'apple', 0, 0, 0),
('os', 'beos', 0, 0, 0),
('os', 'blackberry', 0, 0, 0),
('os', 'freebsd', 0, 0, 0),
('os', 'ipad', 0, 0, 0),
('os', 'iphone', 0, 0, 0),
('os', 'ipod', 0, 0, 0),
('os', 'irix', 0, 0, 0),
('os', 'linux', 0, 0, 0),
('os', 'netbsd', 0, 0, 0),
('os', 'nokia', 0, 0, 0),
('os', 'openbsd', 0, 0, 0),
('os', 'opensolaris', 0, 0, 0),
('os', 'os2', 0, 0, 0),
('os', 'palm', 0, 0, 0),
('os', 'sunos', 0, 0, 0),
('os', 'unknown', 0, 0, 0),
('os', 'win', 0, 0, 0),
('os', 'win10', 1742893379, 7, 7),
('os', 'win2000', 0, 0, 0),
('os', 'win2003', 0, 0, 0),
('os', 'win7', 0, 0, 0),
('os', 'win8', 0, 0, 0),
('os', 'wince', 0, 0, 0),
('os', 'winvista', 0, 0, 0),
('os', 'winxp', 0, 0, 0),
('total', 'hits', 1742893379, 7, 7),
('year', '2025', 1742893379, 7, 7),
('year', '2026', 0, 0, 0),
('year', '2027', 0, 0, 0),
('year', '2028', 0, 0, 0),
('year', '2029', 0, 0, 0),
('year', '2030', 0, 0, 0),
('year', '2031', 0, 0, 0),
('year', '2032', 0, 0, 0),
('year', '2033', 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_cronjobs`
--

DROP TABLE IF EXISTS `nv5_cronjobs`;
CREATE TABLE `nv5_cronjobs` (
  `id` mediumint(8) UNSIGNED NOT NULL,
  `start_time` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `inter_val` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `inter_val_type` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0: Lặp lại sau thời điểm bắt đầu thực tế, 1:lặp lại sau thời điểm bắt đầu trong CSDL',
  `run_file` varchar(255) NOT NULL,
  `run_func` varchar(255) NOT NULL,
  `params` varchar(255) DEFAULT NULL,
  `del` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `is_sys` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `act` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `last_time` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `last_result` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `vi_cron_name` varchar(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Tiến trình tự động';

--
-- Dumping data for table `nv5_cronjobs`
--

INSERT INTO `nv5_cronjobs` (`id`, `start_time`, `inter_val`, `inter_val_type`, `run_file`, `run_func`, `params`, `del`, `is_sys`, `act`, `last_time`, `last_result`, `vi_cron_name`) VALUES
(1, 1742685231, 5, 0, 'online_expired_del.php', 'cron_online_expired_del', '', 0, 1, 1, 1742893239, 1, 'Xóa các dòng ghi trạng thái online đã cũ trong CSDL'),
(2, 1742685231, 1440, 0, 'dump_autobackup.php', 'cron_dump_autobackup', '', 0, 1, 1, 1742822694, 1, 'Tự động lưu CSDL'),
(3, 1742685231, 60, 0, 'temp_download_destroy.php', 'cron_auto_del_temp_download', '', 0, 1, 1, 1742893239, 1, 'Xóa các file tạm trong thư mục tmp'),
(4, 1742685231, 30, 0, 'ip_logs_destroy.php', 'cron_del_ip_logs', '', 0, 1, 1, 1742893239, 1, 'Xóa IP log files, Xóa các file nhật ký truy cập'),
(5, 1742685231, 1440, 0, 'error_log_destroy.php', 'cron_auto_del_error_log', '', 0, 1, 1, 1742822694, 1, 'Xóa các file error_log quá hạn'),
(6, 1742685231, 360, 0, 'error_log_sendmail.php', 'cron_auto_sendmail_error_log', '', 0, 1, 0, 0, 0, 'Gửi email các thông báo lỗi cho admin'),
(7, 1742685231, 60, 0, 'ref_expired_del.php', 'cron_ref_expired_del', '', 0, 1, 1, 1742893239, 1, 'Xóa các referer quá hạn'),
(8, 1742685231, 60, 0, 'check_version.php', 'cron_auto_check_version', '', 0, 1, 1, 1742893239, 1, 'Kiểm tra phiên bản NukeViet'),
(9, 1742685231, 1440, 0, 'notification_autodel.php', 'cron_notification_autodel', '', 0, 1, 1, 1742822694, 1, 'Xóa thông báo cũ'),
(10, 1742685231, 1440, 0, 'remove_expired_inform.php', 'cron_remove_expired_inform', '', 0, 1, 1, 1742822694, 1, 'Xóa thông báo quá hạn'),
(11, 1742685231, 60, 0, 'apilogs_autodel.php', 'cron_apilogs_autodel', '', 0, 1, 1, 1742893239, 1, 'Xóa các API-log hết hạn'),
(12, 1742685231, 60, 0, 'expadmin_handling.php', 'cron_expadmin_handling', '', 0, 1, 1, 1742893239, 1, 'Xử lý admin quá hạn');

-- --------------------------------------------------------

--
-- Table structure for table `nv5_emailtemplates`
--

DROP TABLE IF EXISTS `nv5_emailtemplates`;
CREATE TABLE `nv5_emailtemplates` (
  `emailid` mediumint(8) UNSIGNED NOT NULL,
  `lang` varchar(2) NOT NULL DEFAULT '' COMMENT 'Ngôn ngữ',
  `module_file` varchar(50) NOT NULL DEFAULT '' COMMENT 'Module file của email',
  `module_name` varchar(50) NOT NULL DEFAULT '' COMMENT 'Module name của email',
  `id` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'ID mẫu theo module',
  `sys_pids` varchar(255) NOT NULL DEFAULT '' COMMENT 'Các plugin xử lý dữ liệu của hệ thống',
  `pids` varchar(255) NOT NULL DEFAULT '' COMMENT 'Các plugin xử lý dữ liệu',
  `catid` smallint(4) UNSIGNED NOT NULL DEFAULT 0,
  `time_add` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Tạo lúc',
  `time_update` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Cập nhật lúc',
  `send_name` varchar(255) NOT NULL DEFAULT '' COMMENT 'Tên người gửi',
  `send_email` varchar(255) NOT NULL DEFAULT '' COMMENT 'Email người gửi',
  `send_cc` text NOT NULL COMMENT 'CC Emails',
  `send_bcc` text NOT NULL COMMENT 'BCC Emails',
  `attachments` text NOT NULL COMMENT 'Đính kèm',
  `is_system` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Của hệ thống hay không',
  `is_plaintext` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Gửi dạng text thuần hay có định dạng',
  `is_disabled` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Đình chỉ gửi mail hay không',
  `is_selftemplate` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '1 thì không dùng template của giao diện, 0 thì dùng',
  `mailtpl` varchar(255) NOT NULL DEFAULT '' COMMENT 'Tên mẫu cứng trong file nếu chọn',
  `default_subject` varchar(250) NOT NULL DEFAULT '' COMMENT 'Tiêu đề email tất cả các ngôn ngữ',
  `default_content` mediumtext NOT NULL COMMENT 'Nội dung email tất cả các ngôn ngữ',
  `vi_title` varchar(250) NOT NULL DEFAULT '',
  `vi_subject` varchar(250) NOT NULL DEFAULT '',
  `vi_content` mediumtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng mẫu email';

--
-- Dumping data for table `nv5_emailtemplates`
--

INSERT INTO `nv5_emailtemplates` (`emailid`, `lang`, `module_file`, `module_name`, `id`, `sys_pids`, `pids`, `catid`, `time_add`, `time_update`, `send_name`, `send_email`, `send_cc`, `send_bcc`, `attachments`, `is_system`, `is_plaintext`, `is_disabled`, `is_selftemplate`, `mailtpl`, `default_subject`, `default_content`, `vi_title`, `vi_subject`, `vi_content`) VALUES
(1, '', '', '', 1, '4', '', 2, 1742685231, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Thông báo từ website {$site_name}', 'Ban quản trị website {$site_name} xin thông báo:<br />Tài khoản quản trị của bạn tại website {$site_name} đã bị xóa vào {$time}{if not empty($note)} vì lý do: {$note}{/if}.<br />Mọi đề nghị, thắc mắc... xin gửi email đến địa chỉ <a href=\"mailto:{$email}\">{$email}</a>{if not empty($username)}<br/><br/>{$sig}<br/><br/>{$username}<br/>{$position}<br/>{$email}{/if}', 'Thông báo tài khoản quản trị đã bị xóa', '', ''),
(2, '', '', '', 2, '4', '', 2, 1742685231, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Thông báo từ website {$site_name}', 'Ban quản trị website {$site_name} xin thông báo:<br />Tài khoản quản trị của bạn tại website {$site_name} đã bị đình chỉ hoạt động vào {$time} vì lý do: {$note}.<br />Mọi đề nghị, thắc mắc... xin gửi email đến địa chỉ <a href=\"mailto:{$email}\">{$email}</a>{if not empty($username)}<br/><br/>{$sig}<br/><br/>{$username}<br/>{$position}<br/>{$email}{/if}', 'Thông báo đình chỉ quản trị site', '', ''),
(3, '', '', '', 3, '4', '', 2, 1742685231, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Thông báo từ website {$site_name}', 'Ban quản trị website {$site_name} xin thông báo:<br />Tài khoản quản trị của bạn tại website {$site_name} đã hoạt động trở lại vào {$time}.<br />Trước đó tài khoản này đã bị đình chỉ hoạt động vì lý do: {$note}{if not empty($username)}<br/><br/>{$sig}<br/><br/>{$username}<br/>{$position}<br/>{$email}{/if}', 'Thông báo kích hoạt lại quản trị site', '', ''),
(4, '', '', '', 4, '4', '', 2, 1742685231, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Định cấu hình Xác thực hai bước bằng Oauth đã hoàn tất', '{$greeting_user}<br /><br />Ban quản trị website {$site_name} xin thông báo:<br />Việc xác thực đăng nhập quản trị của bạn bằng Oauth đã được thiết lập thành công. Bạn có thể sử dụng tài khoản <strong>{$oauth_id}</strong> của nhà cung cấp <strong>{$oauth_name}</strong> để xác thực mỗi khi đăng nhập vào quản trị hệ thống.', 'Thông báo phương thức xác thực hai bước mới được thêm vào tài khoản quản trị', '', ''),
(5, '', '', '', 5, '4', '', 2, 1742685231, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Định cấu hình Xác thực hai bước bằng Oauth đã bị hủy', '{$greeting_user}<br /><br />Ban quản trị website {$site_name} xin thông báo:<br />Theo yêu cầu của bạn, việc xác thực hai bước bằng Oauth đã hủy thành công. Bạn đã không thể sử dụng các tài khoản <strong>{$oauth_id}</strong> để xác thực đăng nhập vào quản trị hệ thống.', 'Thông báo tất cả phương thức xác thực hai bước đã bị xóa khỏi tài khoản quản trị', '', ''),
(6, '', '', '', 6, '4', '', 2, 1742685231, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Định cấu hình Xác thực hai bước bằng Oauth đã bị hủy', '{$greeting_user}<br /><br />Ban quản trị website {$site_name} xin thông báo:<br />Theo yêu cầu của bạn, việc xác thực hai bước bằng Oauth đã hủy thành công. Bạn đã không thể sử dụng tài khoản <strong>{$oauth_id}</strong> của nhà cung cấp <strong>{$oauth_name}</strong> để xác thực đăng nhập vào quản trị hệ thống.', 'Thông báo phương thức xác thực hai bước đã bị xóa khỏi tài khoản quản trị', '', ''),
(7, '', '', '', 7, '5', '', 1, 1742685231, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Cảnh báo từ website {$site_name}', 'Hệ thống đã nhận được một số thông báo. Bạn hãy mở file đính kèm để xem chi tiết', 'Email tự động thông báo lỗi', '', ''),
(8, '', '', '', 8, '5', '', 1, 1742685231, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Email thử nghiệm', 'Đây là email thử nghiệm để kiểm tra cấu hình gửi mail. Đơn giản bạn hãy xóa nó đi!', 'Email gửi thử nghiệm để kiểm tra cấu hình gửi mail', '', ''),
(1001, 'vi', 'news', 'news', 1, '5', '', 4, 1742685231, 0, '', '', '', '', '', 0, 0, 0, 0, '', 'Tin nhắn từ {$from_name}', 'Xin chào!<br />Bạn của bạn là {$from_name} mong muốn giới thiệu với bạn bài viết “{$post_name}” trên website {$site_name}{if not empty($message)} với lời nhắn:<br />{$message}{/if}.<br/>----------<br/><strong>{$post_name}</strong><br/>{$hometext}<br/><br/>Bạn có thể xem đầy đủ bài viết bằng cách click vào link bên dưới:<br /><a href=\"{$link}\" title=\"{$post_name}\">{$link}</a>', 'Gửi email giới thiệu bài viết cho bạn bè tại module news', '', ''),
(1002, 'vi', 'news', 'news', 2, '5', '', 4, 1742685231, 0, '', '', '', '', '', 0, 0, 0, 0, '', 'Cảm ơn bạn đã báo lỗi', 'Xin chào!<br />Ban quản trị website {$site_name} cảm ơn bạn đã gửi đến chúng tôi báo cáo lỗi trong nội dung bài viết. Lỗi mà bạn thông báo đã được chúng tôi sửa lại.<br />Hy vọng sẽ nhận được sự giúp đỡ tiếp theo của bạn trong tương lai.<br />Chúc bạn luôn mạnh khỏe, hạnh phúc và thành công!', 'Email cảm ơn người báo lỗi tại module news', '', ''),
(1003, 'vi', 'users', 'users', 1, '3', '', 3, 1742685231, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Thông tin kích hoạt tài khoản', '{$greeting_user}<br /><br />Tài khoản của bạn tại website {$site_name} đang chờ kích hoạt. Để kích hoạt, bạn hãy click vào link dưới đây:<br /><br />URL: <a href=\"{$link}\">{$link}</a><br /><br />Các thông tin cần thiết:<br /><br />Tài khoản: {$username}<br />Email: {$email}<br /><br />Việc kích hoạt tài khoản chỉ có hiệu lực đến {$active_deadline}<br /><br />Đây là thư tự động được gửi đến hòm thư điện tử của bạn từ website {$site_name}. Nếu bạn không hiểu gì về nội dung bức thư này, đơn giản hãy xóa nó đi.', 'Kích hoạt tài khoản qua email', '', ''),
(1004, 'vi', 'users', 'users', 2, '3', '', 3, 1742685231, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Thư thông báo xóa tài khoản', '{$greeting_user}<br /><br />Chúng tôi rất lấy làm tiếc thông báo về việc tài khoản của bạn đã bị xóa khỏi website {$site_name}.', 'Thư thông báo xóa tài khoản', '', ''),
(1005, 'vi', 'users', 'users', 3, '3', '', 3, 1742685231, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Mã dự phòng mới', '{$greeting_user}<br /><br />Mã dự phòng cho tài khoản của bạn tại website {$site_name} đã được thay đổi. Dưới đây là mã dự phòng mới:<br /><br />{foreach from=$new_code item=code}{$code}<br />{/foreach}<br />Bạn chú ý giữ mã dự phòng an toàn. Nếu mất điện thoại và mất cả mã dự phòng bạn sẽ không thể truy cập vào tài khoản của mình được nữa.<br /><br />Đây là thư tự động được gửi đến hòm thư điện tử của bạn từ website {$site_name}. Nếu bạn không hiểu gì về nội dung bức thư này, đơn giản hãy xóa nó đi.', 'Gửi mã dự phòng mới', '', ''),
(1006, 'vi', 'users', 'users', 4, '3', '', 3, 1742685231, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Tài khoản của bạn đã được tạo', '{$greeting_user}<br /><br />Tài khoản của bạn tại website {$site_name} đã được kích hoạt. Dưới đây là thông tin tài khoản:<br /><br />Bí danh: {$username}<br />Email: {$email}<br /><br />Vui lòng bấm vào đường dẫn dưới đây để đăng nhập:<br />URL: <a href=\"{$link}\">{$link}</a><br /><br />Đây là thư tự động được gửi đến email của bạn từ website {$site_name}. Nếu bạn không hiểu gì về nội dung bức thư này, đơn giản hãy xóa nó đi.', 'Thông báo tài khoản đã được tạo khi thành viên đăng kí thành công tại form', '', ''),
(1007, 'vi', 'users', 'users', 5, '3', '', 3, 1742685231, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Tài khoản của bạn đã được tạo', '{$greeting_user}<br /><br />Tài khoản của bạn tại website {$site_name} đã được kích hoạt. Để đăng nhập vui lòng truy cập vào trang: <a href=\"{$link}\">{$link}</a> và click vào nút: Đăng nhập bằng {$oauth_name}.<br /><br />Đây là thư tự động được gửi đến email của bạn từ website {$site_name}. Nếu bạn không hiểu gì về nội dung bức thư này, đơn giản hãy xóa nó đi.', 'Thông báo tài khoản đã được tạo khi thành viên đăng kí thành công qua Oauth', '', ''),
(1008, 'vi', 'users', 'users', 6, '3', '', 3, 1742685231, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Tài khoản của bạn đã được tạo', '{$greeting_user}<br /><br />Tài khoản của bạn tại website {$site_name} đã được kích hoạt. Dưới đây là thông tin đăng nhập:<br /><br />URL: <a href=\"{$link}\">{$link}</a><br />Bí danh: {$username}<br />Email: {$email}<br /><br />Đây là thư tự động được gửi đến email của bạn từ website {$site_name}. Nếu bạn không hiểu gì về nội dung bức thư này, đơn giản hãy xóa nó đi.', 'Thông báo tài khoản được trưởng nhóm khởi tạo', '', ''),
(1009, 'vi', 'users', 'users', 7, '3', '', 3, 1742685231, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Tài khoản của bạn đã được tạo', '{$greeting_user}<br /><br />Tài khoản của bạn tại website {$site_name} đã được khởi tạo. Dưới đây là thông tin đăng nhập:<br /><br />URL: <a href=\"{$link}\">{$link}</a><br />Bí danh: {$username}<br />Mật khẩu: {$password}<br />{if $pass_reset gt 0 or $email_reset gt 0}<br />Chú ý:<br />{if $pass_reset eq 2}- Chúng tôi khuyến cáo bạn nên thay đổi mật khẩu trước khi sử dụng tài khoản.<br />{elseif $pass_reset eq 1}- Bạn cần đổi mật khẩu trước khi sử dụng tài khoản.<br />{/if}{if $email_reset eq 2}- Chúng tôi khuyến cáo bạn nên thay đổi email trước khi sử dụng tài khoản.<br />{elseif $email_reset eq 1}- Bạn cần đổi email trước khi sử dụng tài khoản.<br />{/if}{/if}<br />Đây là thư tự động được gửi đến hòm thư điện tử của bạn từ website {$site_name}. Nếu bạn không hiểu gì về nội dung bức thư này, đơn giản hãy xóa nó đi.', 'Thông báo tài khoản được quản trị khởi tạo', '', ''),
(1010, 'vi', 'users', 'users', 8, '3', '', 3, 1742685231, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Mã xác minh chế độ an toàn', '{$greeting_user}<br /><br />Bạn đã gửi yêu cầu sử dụng chế độ an toàn tại website {$site_name}. Dưới đây là mã xác minh dùng cho việc kích hoạt hoặc tắt chế độ an toàn:<br /><br /><strong>{$code}</strong><br /><br />Mã xác minh này chỉ có tác dụng bật-tắt chế độ an toàn một lần duy nhất. Sau khi bạn tắt chế độ an toàn, mã xác minh này sẽ vô giá trị.<br /><br />Đây là thư tự động được gửi đến email của bạn từ website {$site_name}.', 'Gửi mã xác minh khi người dùng bật/ tắt chế độ an toàn', '', ''),
(1011, 'vi', 'users', 'users', 9, '3', '', 3, 1742685231, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Hồ sơ của bạn đã được cập nhật', '{$greeting_user}<br /><br />Tài khoản của bạn tại website {$site_name} đã được cập nhật {if $send_newvalue}với {$label} mới là <strong>{$newvalue}</strong>{else}{$label} mới{/if}.<br /><br />Đây là thư tự động được gửi đến email của bạn từ website {$site_name}.', 'Thông báo các thay đổi về tài khoản vừa được người dùng thực hiện', '', ''),
(1012, 'vi', 'users', 'users', 10, '3', '', 3, 1742685231, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Tài khoản của bạn đã được cập nhật', '{$greeting_user}<br /><br />Tài khoản của bạn tại website {$site_name} đã được cập nhật. Dưới đây là thông tin đăng nhập:<br /><br />URL: <a href=\"{$link}\">{$link}</a><br />Bí danh: {$username}<br />Email: {$email}{if not empty($password)}<br />Mật khẩu: {$password}{/if}<br />{if $pass_reset gt 0 or $email_reset gt 0}<br />Chú ý:<br />{if $pass_reset eq 2}- Chúng tôi khuyến cáo bạn nên thay đổi mật khẩu trước khi sử dụng tài khoản.<br />{elseif $pass_reset eq 1}- Bạn cần đổi mật khẩu trước khi sử dụng tài khoản.<br />{/if}{if $email_reset eq 2}- Chúng tôi khuyến cáo bạn nên thay đổi email trước khi sử dụng tài khoản.<br />{elseif $email_reset eq 1}- Bạn cần đổi email trước khi sử dụng tài khoản.<br />{/if}{/if}<br />Đây là thư tự động được gửi đến hòm thư điện tử của bạn từ website {$site_name}. Nếu bạn không hiểu gì về nội dung bức thư này, đơn giản hãy xóa nó đi.', 'Thông báo các thay đổi về tài khoản vừa được quản trị thực hiện', '', ''),
(1013, 'vi', 'users', 'users', 11, '3', '', 3, 1742685231, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Thông tin kích hoạt thay đổi email', '{$greeting_user}<br /><br />Bạn đã gửi đề nghị thay đổi email của tài khoản người dùng trên website {$site_name}. Để hoàn tất thay đổi này, bạn cần xác nhận email mới bằng cách nhập Mã xác minh dưới đây vào ô tương ứng tại khu vực Sửa thông tin tài khoản:<br /><br />Mã xác minh: <strong>{$code}</strong><br /><br />Mã này hết hạn vào {$deadline}.<br /><br />Đây là thư tự động được gửi đến email của bạn từ website {$site_name}. Nếu bạn không hiểu gì về nội dung bức thư này, đơn giản hãy xóa nó đi.', 'Thư xác nhận thay đổi email tài khoản', '', ''),
(1014, 'vi', 'users', 'users', 12, '3', '', 3, 1742685231, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Yêu cầu tham gia nhóm', 'Xin chào trưởng nhóm <strong>{$group_name}</strong>,<br /><br /><strong>{$full_name}</strong> đã gửi yêu cầu tham gia nhóm <strong>{$group_name}</strong> do bạn đang quản lý. Vui lòng xét duyệt yêu cầu bằng cách nhấn vào <a href=\"{$link}\">liên kết này</a>.', 'Thông báo có yêu cầu tham gia nhóm', '', ''),
(1015, 'vi', 'users', 'users', 13, '3', '', 3, 1742685231, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Thông tin kích hoạt tài khoản', '{$greeting_user}<br /><br />Tài khoản của bạn tại website {$site_name} đang chờ kích hoạt. Để kích hoạt, bạn hãy click vào link dưới đây:<br /><br />URL: <a href=\"{$link}\">{$link}</a><br />Các thông tin cần thiết:<br />Bí danh: {$username}<br />Email: {$email}<br />Mật khẩu: {$password}<br /><br />Việc kích hoạt tài khoản chỉ có hiệu lực đến {$active_deadline}<br /><br />Đây là thư tự động được gửi đến email của bạn từ website {$site_name}. Nếu bạn không hiểu gì về nội dung bức thư này, đơn giản hãy xóa nó đi.', 'Gửi lại thông tin kích hoạt tài khoản', '', ''),
(1016, 'vi', 'users', 'users', 14, '3', '', 3, 1742685231, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Hướng dẫn tạo lại mật khẩu', '{$greeting_user}<br /><br />Bạn vừa gửi đề nghị thay đổi mật khẩu tài khoản người dùng tại website {$site_name}. Để thay đổi mật khẩu, bạn cần nhập mã xác minh dưới đây vào ô tương ứng tại khu vực thay đổi mật khẩu.<br /><br />Mã xác minh: <strong>{$code}</strong><br /><br />Mã này chỉ được sử dụng một lần và trước thời hạn: {$deadline}.<br />Yêu cầu này xuất phát từ:<br />- IP: <strong>{$ip}</strong><br />- Trình duyệt: <strong>{$user_agent}</strong><br />- Thời gian gửi yêu cầu: <strong>{$request_time}</strong><br /><br />Đây là thư tự động được gửi đến email của bạn từ website {$site_name}. Nếu bạn không hiểu gì về nội dung bức thư này, đơn giản hãy xóa nó đi.', 'Hướng dẫn lấy lại mật khẩu thành viên', '', ''),
(1017, 'vi', 'users', 'users', 15, '3', '', 3, 1742685231, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Xác thực 2 bước đã tắt', '{$greeting_user}<br /><br />Theo yêu cầu của bạn, chúng tôi đã tắt tính năng Xác thực 2 bước cho tài khoản của bạn tại website {$site_name}.<br /><br />Đây là thư tự động được gửi đến hòm thư điện tử của bạn từ website {$site_name}. Nếu bạn không hiểu gì về nội dung bức thư này, đơn giản hãy xóa nó đi.', 'Thông báo xác thực hai bước đã gỡ thành công', '', ''),
(1018, 'vi', 'users', 'users', 16, '3', '', 3, 1742685231, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Thông tin tắt xác thực 2 bước', '{$greeting_user}<br /><br />Chúng tôi vừa nhận được yêu cầu tắt xác thực 2 bước cho tài khoản của bạn tại website {$site_name}. Nếu bạn là người gửi yêu cầu này, hãy sử dụng Mã xác minh dưới đây để tiến hành tắt:<br /><br />Mã xác minh: <strong>{$code}</strong><br /><br />Đây là thư tự động được gửi đến hòm thư điện tử của bạn từ website {$site_name}. Nếu bạn không hiểu gì về nội dung bức thư này, đơn giản hãy xóa nó đi.', 'Hướng dẫn tắt xác thực hai bước khi quên mã', '', ''),
(1019, 'vi', 'users', 'users', 17, '3', '', 3, 1742685231, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Thông báo bảo mật', '{$greeting_user}<br /><br />Chúng tôi thông tin đến bạn là tài khoản bên thứ ba <strong>{$oauth_name}</strong> vừa được kết nối với tài khoản <strong>{$username}</strong> của bạn bởi trưởng nhóm.<br /><br /><a href=\"{$link}\" style=\"font-family:Roboto,RobotoDraft,Helvetica,Arial,sans-serif;line-height:16px;color:#ffffff;font-weight:400;text-decoration:none;font-size:14px;display:inline-block;padding:10px 24px;background-color:#4184f3;border-radius:5px;min-width:90px\">Quản lý tài khoản bên thứ ba</a>', 'Thông báo oauth được thêm vào tài khoản bởi trưởng nhóm', '', ''),
(1020, 'vi', 'users', 'users', 18, '3', '', 3, 1742685231, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Thông báo bảo mật', '{$greeting_user}<br /><br />Tài khoản bên thứ ba <strong>{$oauth_name}</strong> vừa được kết nối với tài khoản <strong>{$username}</strong> của bạn. Nếu đây không phải là chủ ý của bạn, vui lòng nhanh chóng xóa nó khỏi tài khoản của mình bằng cách truy cập vào khu vực quản lý tài khoản bên thứ ba.<br /><br /><a href=\"{$link}\" style=\"font-family:Roboto,RobotoDraft,Helvetica,Arial,sans-serif;line-height:16px;color:#ffffff;font-weight:400;text-decoration:none;font-size:14px;display:inline-block;padding:10px 24px;background-color:#4184f3;border-radius:5px;min-width:90px\">Quản lý tài khoản bên thứ ba</a>', 'Thông báo oauth được thêm vào tài khoản bởi chính người dùng', '', ''),
(1021, 'vi', 'users', 'users', 19, '3', '', 3, 1742685231, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Thông báo bảo mật', '{$greeting_user}<br /><br />Chúng tôi thông tin đến bạn là tài khoản bên thứ ba <strong>{$oauth_name}</strong> vừa được ngắt kết nối khỏi tài khoản <strong>{$username}</strong> của bạn bởi trưởng nhóm.<br /><br /><a href=\"{$link}\" style=\"font-family:Roboto,RobotoDraft,Helvetica,Arial,sans-serif;line-height:16px;color:#ffffff;font-weight:400;text-decoration:none;font-size:14px;display:inline-block;padding:10px 24px;background-color:#4184f3;border-radius:5px;min-width:90px\">Quản lý tài khoản bên thứ ba</a>', 'Thông báo oauth được xóa khỏi tài khoản bởi trưởng nhóm', '', ''),
(1022, 'vi', 'users', 'users', 21, '3', '', 3, 1742685231, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Thông báo bảo mật', '{$greeting_user}<br /><br />Tài khoản bên thứ ba <strong>{$oauth_name}</strong> vừa được ngắt kết nối khỏi tài khoản <strong>{$username}</strong> của bạn. Nếu đây không phải là chủ ý của bạn, vui lòng nhanh chóng liên hệ với quản trị site để được giúp đỡ.<br /><br /><a href=\"{$link}\" style=\"font-family:Roboto,RobotoDraft,Helvetica,Arial,sans-serif;line-height:16px;color:#ffffff;font-weight:400;text-decoration:none;font-size:14px;display:inline-block;padding:10px 24px;background-color:#4184f3;border-radius:5px;min-width:90px\">Quản lý tài khoản bên thứ ba</a>', 'Thông báo oauth được xóa khỏi tài khoản bởi chính người dùng', '', ''),
(1023, 'vi', 'users', 'users', 22, '3', '', 3, 1742685231, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Thư xác minh email mới', 'Xin chào!<br /><br />Bạn đã gửi yêu cầu xác minh email: {$email}. Hãy chép mã dưới đây vào ô Mã xác minh trên site.<br /><br />Mã xác minh: <strong>{$code}</strong><br /><br />Đây là thư tự động được gửi đến email của bạn từ website {$site_name}. Nếu bạn không hiểu gì về nội dung bức thư này, đơn giản hãy xóa nó đi.', 'Gửi mã xác minh email khi đăng nhập qua Oauth mà email trùng với tài khoản đã có', '', ''),
(1024, 'vi', 'users', 'users', 24, '3', '', 3, 1742685231, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Tài khoản của bạn đã được tạo', '{$greeting_user}<br /><br />Tài khoản của bạn tại website {$site_name} đã được kích hoạt. {if empty($oauth_name)}Dưới đây là thông tin đăng nhập:<br /><br />URL: <a href=\"{$link}\">{$link}</a><br />Bí danh: {$username}<br />{if not empty($password)}Mật khẩu: {$password}{/if}{else}Để đăng nhập vui lòng truy cập vào trang: <a href=\"{$link}\">{$link}</a> và click vào nút: <strong>Đăng nhập bằng {$oauth_name}</strong>.{if not empty($password)}<br /><br />Bạn cũng có thể đăng nhập theo cách thông thường với thông tin:<br />Bí danh: {$username}<br />Mật khẩu: {$password}{/if}{/if}{if $pass_reset gt 0 or $email_reset gt 0}<br />Chú ý:<br />{if $pass_reset eq 2}- Chúng tôi khuyến cáo bạn nên thay đổi mật khẩu trước khi sử dụng tài khoản.<br />{elseif $pass_reset eq 1}- Bạn cần đổi mật khẩu trước khi sử dụng tài khoản.<br />{/if}{if $email_reset eq 2}- Chúng tôi khuyến cáo bạn nên thay đổi email trước khi sử dụng tài khoản.<br />{elseif $email_reset eq 1}- Bạn cần đổi email trước khi sử dụng tài khoản.<br />{/if}{/if}<br />Đây là thư tự động được gửi đến hòm thư điện tử của bạn từ website {$site_name}. Nếu bạn không hiểu gì về nội dung bức thư này, đơn giản hãy xóa nó đi.', 'Email thông báo cho người dùng khi quản trị kích hoạt tài khoản', '', ''),
(1025, 'vi', 'users', 'users', 25, '3', '', 3, 1742685231, 0, '', '', '', '', '', 1, 0, 0, 0, '', '{if $pass_reset eq 2}Khuyến cáo thay đổi mật khẩu truy cập{else}Cần thay đổi mật khẩu truy cập{/if}', '{$greeting_user}<br /><br />Ban quản trị website {$site_name} xin thông báo: Vì lý do bảo mật chúng tôi {if $pass_reset eq 2}khuyến cáo bạn nên{else}đề nghị bạn nhanh chóng{/if} thay đổi mật khẩu truy cập tài khoản của mình. Để thay đổi mật khẩu, trước hết bạn cần truy cập vào trang <a href=\"{$link}\">Quản lý tài khoản cá nhân</a>, chọn nút Thiết lập tài khoản, sau đó chọn nút Mật khẩu và làm theo hướng dẫn.', 'Email yêu cầu người dùng thay đổi mật khẩu', '', ''),
(1026, 'vi', 'users', 'users', 26, '3', '', 3, 1742685231, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Thông báo bảo mật', '{$greeting_user}<br /><br />Tài khoản của bạn vừa được tắt xác thực hai bước bởi quản trị viên. Chúng tôi gửi cho bạn email này để thông tin đến bạn.<br /><br /><a href=\"{$link}\" style=\"font-family:Roboto,RobotoDraft,Helvetica,Arial,sans-serif;line-height:16px;color:#ffffff;font-weight:400;text-decoration:none;font-size:14px;display:inline-block;padding:10px 24px;background-color:#4184f3;border-radius:5px;min-width:90px\">Quản lý xác thực hai bước</a>', 'Thông báo đến người dùng xác thực hai bước đã được quản trị tắt', '', ''),
(1027, 'vi', 'users', 'users', 20, '3', '', 3, 1742685231, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Thông báo bảo mật', '{$greeting_user}<br /><br />Chúng tôi thông tin đến bạn là tài khoản bên thứ ba <strong>{$oauth_name}</strong> vừa được ngắt kết nối khỏi tài khoản của bạn bởi quản trị viên.<br /><br /><a href=\"{$link}\" style=\"font-family:Roboto,RobotoDraft,Helvetica,Arial,sans-serif;line-height:16px;color:#ffffff;font-weight:400;text-decoration:none;font-size:14px;display:inline-block;padding:10px 24px;background-color:#4184f3;border-radius:5px;min-width:90px\">Quản lý tài khoản bên thứ ba</a>', 'Thông báo oauth được xóa khỏi tài khoản bởi quản trị', '', ''),
(1028, 'vi', 'users', 'users', 23, '3', '', 3, 1742685231, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Thông báo bảo mật', '{$greeting_user}<br /><br />Chúng tôi thông tin đến bạn là tất cả các tài khoản bên thứ ba vừa được ngắt kết nối khỏi tài khoản của bạn bởi quản trị viên.<br /><br /><a href=\"{$link}\" style=\"font-family:Roboto,RobotoDraft,Helvetica,Arial,sans-serif;line-height:16px;color:#ffffff;font-weight:400;text-decoration:none;font-size:14px;display:inline-block;padding:10px 24px;background-color:#4184f3;border-radius:5px;min-width:90px\">Quản lý tài khoản bên thứ ba</a>', 'Thông báo đến người dùng khi quản trị xóa tất cả Oauth của họ', '', ''),
(1029, 'vi', 'users', 'users', 27, '3', '', 3, 1742685231, 0, '', '', '', '', '', 1, 0, 0, 0, '', '{if $email_reset eq 2}Khuyến cáo thay đổi email{else}Cần thay đổi email{/if}', '{$greeting_user}<br /><br />Ban quản trị website {$site_name} xin thông báo: Vì lý do bảo mật chúng tôi {if $email_reset eq 2}khuyến cáo bạn nên{else}đề nghị bạn nhanh chóng{/if} thay đổi email tài khoản của mình. Để thay đổi email, trước hết bạn cần truy cập vào trang <a href=\"{$link}\">Quản lý tài khoản cá nhân</a>, chọn nút Thiết lập tài khoản, sau đó chọn nút Email và làm theo hướng dẫn.', 'Email yêu cầu người dùng thay đổi email', '', ''),
(1030, 'vi', 'users', 'users', 28, '3', '', 3, 1742685231, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Khóa bảo mật đã được thêm vào tài khoản của bạn', '{$greeting_user}<br /><br />Một khóa bảo mật có tên &quot;{$security_key}&quot; vừa được thêm vào tài khoản của bạn tại website {$site_name}. Hành động này xuất phát từ:\n<ul>\n    <li>Trình duyệt: <strong>{$user_agent}</strong></li>\n    <li>IP: <strong>{$ip}</strong></li>\n    <li>Thời gian thao tác: <strong>{$action_time}</strong></li>\n</ul>\n<p>Chúng tôi gửi thông báo bắt buộc này đến email của bạn để đảm bảo chính bạn là người thực hiện. Trong trường hợp không phải là bạn, vui lòng khẩn trương truy cập <a href=\"{$tstep_link}\">trang quản lí xác thực hai bước</a> để xem lại các khóa bảo mật. Đồng thời thực hiện <a href=\"{$pass_link}\">đổi mật khẩu ngay</a> để đảm bảo an toàn.</p>\nNhắc nhở: Bạn đã lưu trữ mã dự phòng của mình chưa? Nếu chưa xin vui lòng dành chút thời gian tải xuống và lưu trữ cẩn thận, vì đây là phương án cuối cùng đảm bảo bạn có thể truy cập vào tài khoản trong trường hợp mất các thiết bị để truy cập các phương án xác thực hai bước. Bạn có thể <a href=\"{$code_link}\">tải chúng xuống tại đây</a>.', 'Email thêm khóa bảo mật', '', ''),
(1031, 'vi', 'users', 'users', 29, '3', '', 3, 1742685231, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Khóa đăng nhập đã được thêm vào tài khoản của bạn', '{$greeting_user}<br /><br />Một khóa đăng nhập có tên &quot;{$passkey}&quot; vừa được thêm vào tài khoản của bạn tại website {$site_name}. Hành động này xuất phát từ:\n<ul>\n    <li>Trình duyệt: <strong>{$user_agent}</strong></li>\n    <li>IP: <strong>{$ip}</strong></li>\n    <li>Thời gian thao tác: <strong>{$action_time}</strong></li>\n</ul>\nChúng tôi gửi thông báo bắt buộc này đến email của bạn để đảm bảo chính bạn là người thực hiện. Trong trường hợp không phải là bạn, vui lòng khẩn trương truy cập <a href=\"{$passkey_link}\">trang quản lí khóa đăng nhập</a> để xem lại các khóa đăng nhập. Đồng thời thực hiện <a href=\"{$pass_link}\">đổi mật khẩu ngay</a> để đảm bảo an toàn.', 'Email thêm khóa đăng nhập', '', ''),
(1032, 'vi', 'users', 'users', 30, '3', '', 3, 1742685231, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Khóa bảo mật đã bị xóa khỏi tài khoản của bạn', '{$greeting_user}<br /><br />Khóa bảo mật &quot;{$security_key}&quot; vừa bị xóa khỏi tài khoản của bạn tại website {$site_name}. Hành động này xuất phát từ:\n<ul>\n    <li>Trình duyệt: <strong>{$user_agent}</strong></li>\n    <li>IP: <strong>{$ip}</strong></li>\n    <li>Thời gian thao tác: <strong>{$action_time}</strong></li>\n</ul>\n<p>Chúng tôi gửi thông báo bắt buộc này đến email của bạn để đảm bảo chính bạn là người thực hiện. Trong trường hợp không phải là bạn, vui lòng khẩn trương truy cập <a href=\"{$tstep_link}\">trang quản lí xác thực hai bước</a> để xem lại các khóa bảo mật. Đồng thời thực hiện <a href=\"{$pass_link}\">đổi mật khẩu ngay</a> để đảm bảo an toàn.</p>\nNhắc nhở: Bạn đã lưu trữ mã dự phòng của mình chưa? Nếu chưa xin vui lòng dành chút thời gian tải xuống và lưu trữ cẩn thận, vì đây là phương án cuối cùng đảm bảo bạn có thể truy cập vào tài khoản trong trường hợp mất các thiết bị để truy cập các phương án xác thực hai bước. Bạn có thể <a href=\"{$code_link}\">tải chúng xuống tại đây</a>.', 'Email xóa khóa bảo mật', '', ''),
(1033, 'vi', 'users', 'users', 31, '3', '', 3, 1742685231, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Khóa đăng nhập đã bị xóa khỏi tài khoản của bạn', '{$greeting_user}<br /><br />Khóa đăng nhập có tên &quot;{$passkey}&quot; vừa bị xóa khỏi tài khoản của bạn tại website {$site_name}. Hành động này xuất phát từ:\n<ul>\n    <li>Trình duyệt: <strong>{$user_agent}</strong></li>\n    <li>IP: <strong>{$ip}</strong></li>\n    <li>Thời gian thao tác: <strong>{$action_time}</strong></li>\n</ul>\nChúng tôi gửi thông báo bắt buộc này đến email của bạn để đảm bảo chính bạn là người thực hiện. Trong trường hợp không phải là bạn, vui lòng khẩn trương truy cập <a href=\"{$passkey_link}\">trang quản lí khóa đăng nhập</a> để xem lại các khóa đăng nhập. Đồng thời thực hiện <a href=\"{$pass_link}\">đổi mật khẩu ngay</a> để đảm bảo an toàn.', 'Email xóa khóa đăng nhập', '', ''),
(1034, 'vi', 'two-step-verification', 'two-step-verification', 1, '5', '', 3, 1742685231, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Thông báo bảo mật', '{$greeting_user}<br /><br />Tài khoản của bạn tại website <a href=\"{$Home}\"><strong>{$site_name}</strong></a> vừa kích hoạt chức năng xác thực hai bước qua ứng dụng. Thông tin:<br /><br />- Thời gian: <strong>{$time}</strong><br />- IP: <strong>{$ip}</strong><br />- Trình duyệt: <strong>{$browser}</strong><br /><br />Nếu đây đúng là bạn, hãy bỏ qua email này. Nếu đây không phải là bạn, rất có thể tài khoản của bạn đã bị đánh cắp. Hãy liên hệ với quản trị site để được hỗ trợ', 'Thông báo bật xác thực hai bước cho tài khoản thành viên', '', ''),
(1035, 'vi', 'two-step-verification', 'two-step-verification', 2, '5', '', 3, 1742685231, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Thông báo bảo mật', '{$greeting_user}<br /><br />Tài khoản của bạn tại website <a href=\"{$Home}\"><strong>{$site_name}</strong></a> vừa tắt chức năng xác thực hai bước qua ứng dụng. Thông tin:<br /><br />- Thời gian: <strong>{$time}</strong><br />- IP: <strong>{$ip}</strong><br />- Trình duyệt: <strong>{$browser}</strong><br /><br />Nếu đây đúng là bạn, hãy bỏ qua email này. Nếu đây không phải là bạn, mời kiểm tra lại thông tin cá nhân tại <a href=\"{$link}\">{$link}</a>', 'Thông báo tắt xác thực hai bước cho tài khoản thành viên', '', ''),
(1036, 'vi', 'two-step-verification', 'two-step-verification', 3, '5', '', 3, 1742685231, 0, '', '', '', '', '', 1, 0, 0, 0, '', 'Thông báo bảo mật', '{$greeting_user}<br /><br />Tài khoản của bạn tại website <a href=\"{$Home}\"><strong>{$site_name}</strong></a> vừa tạo lại mã dự phòng. Thông tin:<br /><br />- Thời gian: <strong>{$time}</strong><br />- IP: <strong>{$ip}</strong><br />- Trình duyệt: <strong>{$browser}</strong><br /><br />Nếu đây đúng là bạn, hãy bỏ qua email này. Nếu đây không phải là bạn, mời kiểm tra lại thông tin cá nhân tại <a href=\"{$link}\">{$link}</a>', 'Thông báo tạo lại mã dự phòng xác thực hai bước cho tài khoản thành viên', '', '');

-- --------------------------------------------------------

--
-- Table structure for table `nv5_emailtemplates_categories`
--

DROP TABLE IF EXISTS `nv5_emailtemplates_categories`;
CREATE TABLE `nv5_emailtemplates_categories` (
  `catid` smallint(4) UNSIGNED NOT NULL,
  `time_add` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Tạo lúc',
  `time_update` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Cập nhật lúc',
  `weight` smallint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Sắp thứ tự',
  `is_system` tinyint(1) UNSIGNED NOT NULL DEFAULT 1,
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '0 ẩn, 1 hiển thị',
  `vi_title` varchar(250) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng danh mục mẫu email';

--
-- Dumping data for table `nv5_emailtemplates_categories`
--

INSERT INTO `nv5_emailtemplates_categories` (`catid`, `time_add`, `time_update`, `weight`, `is_system`, `status`, `vi_title`) VALUES
(1, 1742685231, 0, 1, 1, 1, 'Email của hệ thống'),
(2, 1742685231, 0, 3, 1, 1, 'Email về quản trị'),
(3, 1742685231, 0, 2, 1, 1, 'Email về tài khoản'),
(4, 1742685231, 0, 4, 1, 1, 'Email của các module');

-- --------------------------------------------------------

--
-- Table structure for table `nv5_extension_files`
--

DROP TABLE IF EXISTS `nv5_extension_files`;
CREATE TABLE `nv5_extension_files` (
  `idfile` mediumint(8) UNSIGNED NOT NULL,
  `type` varchar(10) NOT NULL DEFAULT 'other',
  `title` varchar(55) NOT NULL DEFAULT '',
  `path` varchar(255) NOT NULL DEFAULT '',
  `lastmodified` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `duplicate` smallint(4) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='File của các ứng dụng';

-- --------------------------------------------------------

--
-- Table structure for table `nv5_inform`
--

DROP TABLE IF EXISTS `nv5_inform`;
CREATE TABLE `nv5_inform` (
  `id` int(11) UNSIGNED NOT NULL,
  `receiver_grs` varchar(1000) NOT NULL DEFAULT '',
  `receiver_ids` varchar(1000) NOT NULL DEFAULT '',
  `sender_role` enum('system','group','admin') NOT NULL DEFAULT 'system',
  `sender_group` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `sender_admin` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `message` text DEFAULT NULL,
  `link` varchar(500) NOT NULL DEFAULT '',
  `add_time` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `exp_time` int(11) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Thông báo khu vực người dùng';

-- --------------------------------------------------------

--
-- Table structure for table `nv5_inform_status`
--

DROP TABLE IF EXISTS `nv5_inform_status`;
CREATE TABLE `nv5_inform_status` (
  `pid` int(11) UNSIGNED NOT NULL,
  `userid` int(11) UNSIGNED NOT NULL,
  `shown_time` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `viewed_time` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `favorite_time` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `hidden_time` int(11) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Trạng thái đọc thông báo của người dùng';

-- --------------------------------------------------------

--
-- Table structure for table `nv5_ips`
--

DROP TABLE IF EXISTS `nv5_ips`;
CREATE TABLE `nv5_ips` (
  `id` mediumint(8) NOT NULL,
  `type` tinyint(4) UNSIGNED NOT NULL DEFAULT 0,
  `ip` varchar(32) DEFAULT NULL,
  `mask` tinyint(4) UNSIGNED NOT NULL DEFAULT 0,
  `area` tinyint(3) NOT NULL,
  `begintime` int(11) DEFAULT NULL,
  `endtime` int(11) DEFAULT NULL,
  `notice` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Thiết lập tường lửa IP truy cập site';

-- --------------------------------------------------------

--
-- Table structure for table `nv5_language`
--

DROP TABLE IF EXISTS `nv5_language`;
CREATE TABLE `nv5_language` (
  `id` mediumint(8) UNSIGNED NOT NULL,
  `idfile` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `langtype` varchar(50) NOT NULL DEFAULT 'lang_module',
  `lang_key` varchar(50) NOT NULL,
  `weight` smallint(4) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Key lang ngôn ngữ giao diện';

-- --------------------------------------------------------

--
-- Table structure for table `nv5_language_file`
--

DROP TABLE IF EXISTS `nv5_language_file`;
CREATE TABLE `nv5_language_file` (
  `idfile` mediumint(8) UNSIGNED NOT NULL,
  `module` varchar(50) NOT NULL,
  `admin_file` varchar(200) NOT NULL DEFAULT '0',
  `langtype` varchar(50) NOT NULL DEFAULT 'lang_module'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Các file ngôn ngữ giao diện';

-- --------------------------------------------------------

--
-- Table structure for table `nv5_logs`
--

DROP TABLE IF EXISTS `nv5_logs`;
CREATE TABLE `nv5_logs` (
  `id` int(11) NOT NULL,
  `lang` varchar(10) NOT NULL,
  `module_name` varchar(50) NOT NULL,
  `name_key` varchar(255) NOT NULL,
  `note_action` text NOT NULL,
  `link_acess` varchar(255) DEFAULT '',
  `userid` mediumint(8) UNSIGNED NOT NULL,
  `log_time` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Nhật kí hệ thống';

--
-- Dumping data for table `nv5_logs`
--

INSERT INTO `nv5_logs` (`id`, `lang`, `module_name`, `name_key`, `note_action`, `link_acess`, `userid`, `log_time`) VALUES
(1, 'vi', 'login', '[webmaster] Đăng nhập', ' Client IP:172.19.1.0', '', 0, 1742685484),
(2, 'vi', 'modules', 'Thiết lập module mới nas', '', '', 1, 1742685564),
(3, 'vi', 'modules', 'Sửa module &ldquo;nas&rdquo;', '', '', 1, 1742685824),
(4, 'vi', 'modules', 'Thứ tự module: nas', '19 -> 1', '', 1, 1742685833),
(5, 'vi', 'modules', 'Sửa module &ldquo;nas&rdquo;', '', '', 1, 1742685850),
(6, 'vi', 'nas', 'CONFIG', '{\"system_quota\":1099511627776,\"websocket_url\":\"\",\"turn_enabled\":0,\"turn_type\":0,\"coturn_auth\":0,\"coturn_server\":\"\",\"coturn_user\":\"\",\"coturn_pass\":\"\",\"coturn_secret\":\"\",\"coturn_live\":600,\"ice_servers\":\"\",\"turn_public\":0}', '', 1, 1742685996),
(7, 'vi', 'nas', 'UPDATE_USER', 'webmaster: 500 GB', '', 1, 1742686039),
(8, 'vi', 'settings', 'Change System setting', '', '', 1, 1742686185),
(9, 'vi', 'themes', 'Thiết lập giao diện theme: \"blanas\"', '', '', 1, 1742686630),
(10, 'vi', 'modules', 'Sửa module &ldquo;nas&rdquo;', '', '', 1, 1742686708),
(11, 'vi', 'users', '[webmaster] Đăng nhập theo kiểu thông thường', ' Client IP:172.19.1.0', '', 0, 1742689573),
(12, 'vi', 'login', '[webmaster] Đăng nhập', ' Client IP:172.19.1.0', '', 0, 1742690944),
(13, 'vi', 'upload', 'Upload file', 'uploads/g3.jpg', '', 1, 1742690974),
(14, 'vi', 'upload', 'Xóa file', 'uploads/g3.jpg', '', 1, 1742690982),
(15, 'vi', 'upload', 'Upload file', 'uploads/canh-diem-1.jpg', '', 1, 1742690992),
(16, 'vi', 'upload', 'Xóa file', 'uploads/canh-diem-1.jpg', '', 1, 1742690997),
(17, 'vi', 'login', '[webmaster] Đăng nhập', ' Client IP:172.19.1.0', '', 0, 1742822751),
(18, 'vi', 'nas', 'CONFIG', '{\"system_quota\":1099511627776,\"websocket_url\":\"ws://127.0.0.1:3000\",\"turn_enabled\":1,\"turn_type\":0,\"coturn_auth\":1,\"coturn_server\":\"127.0.0.1:3478\",\"coturn_user\":\"webmaster\",\"coturn_pass\":\"HTsHMaAuLqq1NppA\",\"coturn_secret\":\"S92ADLUSGNBFFatrhRq8WnAF9EXJ5hxs\",\"coturn_live\":600,\"ice_servers\":\"\",\"turn_public\":1}', '', 1, 1742823003),
(19, 'vi', 'login', '[webmaster] Đăng nhập', ' Client IP:172.19.1.0', '', 0, 1742893249),
(20, 'vi', 'nas', 'CONFIG', '{\"system_quota\":1099511627776,\"websocket_url\":\"ws://127.0.0.1:3001\",\"turn_enabled\":1,\"turn_type\":0,\"coturn_auth\":1,\"coturn_server\":\"127.0.0.1:3478\",\"coturn_user\":\"webmaster\",\"coturn_pass\":\"HTsHMaAuLqq1NppA\",\"coturn_secret\":\"S92ADLUSGNBFFatrhRq8WnAF9EXJ5hxs\",\"coturn_live\":600,\"ice_servers\":\"\",\"turn_public\":1}', '', 1, 1742893356);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_notification`
--

DROP TABLE IF EXISTS `nv5_notification`;
CREATE TABLE `nv5_notification` (
  `id` int(11) UNSIGNED NOT NULL,
  `admin_view_allowed` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Cấp quản trị được xem: 0,1,2',
  `logic_mode` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0: Cấp trên xem được cấp dưới, 1: chỉ cấp hoặc người được chỉ định',
  `send_to` varchar(250) NOT NULL DEFAULT '' COMMENT 'Danh sách id người nhận, phân cách bởi dấu phảy',
  `send_from` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `area` tinyint(1) UNSIGNED NOT NULL,
  `language` char(3) NOT NULL,
  `module` varchar(50) NOT NULL,
  `obid` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `type` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `add_time` int(11) UNSIGNED NOT NULL,
  `view` tinyint(1) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Thông báo trong quản trị';

-- --------------------------------------------------------

--
-- Table structure for table `nv5_plugins`
--

DROP TABLE IF EXISTS `nv5_plugins`;
CREATE TABLE `nv5_plugins` (
  `pid` mediumint(8) UNSIGNED NOT NULL,
  `plugin_lang` varchar(3) NOT NULL DEFAULT 'all' COMMENT 'Ngôn ngữ sử dụng, all là tất cả ngôn ngữ',
  `plugin_file` varchar(50) NOT NULL COMMENT 'File PHP của plugin',
  `plugin_area` varchar(50) NOT NULL DEFAULT '' COMMENT 'Tên hook, tự đặt, không nên có tên nào trùng nhau',
  `plugin_module_name` varchar(50) NOT NULL DEFAULT '' COMMENT 'Tên module nhận và xử lý data',
  `plugin_module_file` varchar(50) NOT NULL DEFAULT '' COMMENT 'Tên module chứa file plugin, rỗng thì nằm ở includes/plugin',
  `hook_module` varchar(50) NOT NULL DEFAULT '' COMMENT 'Module xảy ra event, rỗng thì là của hệ thống',
  `weight` tinyint(4) NOT NULL COMMENT 'Thứ tự trong cùng một hook, càng to càng ưu tiên'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Các hooks';

--
-- Dumping data for table `nv5_plugins`
--

INSERT INTO `nv5_plugins` (`pid`, `plugin_lang`, `plugin_file`, `plugin_area`, `plugin_module_name`, `plugin_module_file`, `hook_module`, `weight`) VALUES
(1, 'all', 'qrcode.php', 'get_qr_code', '', '', '', 1),
(2, 'all', 'cdn_js_css_image.php', 'change_site_buffer', '', '', '', 1),
(3, 'all', 'emf_code_user.php', 'get_email_merge_fields', 'users', 'users', '', 1),
(4, 'all', 'emf_core_author.php', 'get_email_merge_fields', '', '', '', 2),
(5, 'all', 'emf_all.php', 'get_email_merge_fields', '', '', '', 3),
(998, 'all', 'get_module_admin_theme.php', 'get_module_admin_theme', '', '', '', 1),
(999, 'all', 'get_global_admin_theme.php', 'get_global_admin_theme', '', '', '', 1);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_sessions`
--

DROP TABLE IF EXISTS `nv5_sessions`;
CREATE TABLE `nv5_sessions` (
  `session_id` varchar(50) DEFAULT NULL,
  `userid` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `username` varchar(100) NOT NULL,
  `onl_time` int(11) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=MEMORY DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_sessions`
--

INSERT INTO `nv5_sessions` (`session_id`, `userid`, `username`, `onl_time`) VALUES
('83t9k5hogmc1d9nko5j2rtkrgd', 1, 'webmaster', 1742893239),
('cufibulhbnq90qrmnmej1rt5qe', 1, 'webmaster', 1742893431),
('6s7tbq5fqhp374fgo4d5mk7gs6', 0, 'guest', 1742893379);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_setup_extensions`
--

DROP TABLE IF EXISTS `nv5_setup_extensions`;
CREATE TABLE `nv5_setup_extensions` (
  `id` int(11) NOT NULL DEFAULT 0,
  `type` varchar(10) NOT NULL DEFAULT 'other',
  `title` varchar(55) NOT NULL,
  `is_sys` tinyint(1) NOT NULL DEFAULT 0,
  `is_virtual` tinyint(1) NOT NULL DEFAULT 0,
  `basename` varchar(50) NOT NULL DEFAULT '',
  `table_prefix` varchar(55) NOT NULL DEFAULT '',
  `version` varchar(50) NOT NULL,
  `addtime` int(11) NOT NULL DEFAULT 0,
  `author` text NOT NULL,
  `note` varchar(255) DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Các ứng dụng cài vào';

--
-- Dumping data for table `nv5_setup_extensions`
--

INSERT INTO `nv5_setup_extensions` (`id`, `type`, `title`, `is_sys`, `is_virtual`, `basename`, `table_prefix`, `version`, `addtime`, `author`, `note`) VALUES
(0, 'module', 'about', 0, 0, 'page', 'about', '5.0.00 1736144674', 1742685231, 'VINADES.,JSC <contact@vinades.vn>', ''),
(19, 'module', 'banners', 1, 0, 'banners', 'banners', '5.0.00 1736144674', 1742685231, 'VINADES.,JSC <contact@vinades.vn>', ''),
(281, 'module', 'comment', 1, 0, 'comment', 'comment', '5.0.00 1736144674', 1742685231, 'VINADES.,JSC <contact@vinades.vn>', ''),
(20, 'module', 'contact', 0, 1, 'contact', 'contact', '5.0.00 1736144674', 1742685231, 'VINADES.,JSC <contact@vinades.vn>', ''),
(283, 'module', 'feeds', 1, 0, 'feeds', 'feeds', '5.0.00 1736144674', 1742685231, 'VINADES.,JSC <contact@vinades.vn>', ''),
(312, 'module', 'freecontent', 0, 1, 'freecontent', 'freecontent', '5.0.00 1736144674', 1742685231, 'VINADES.,JSC <contact@vinades.vn>', ''),
(22, 'module', 'inform', 1, 0, 'inform', 'inform', '5.0.00 1736144674', 1742685231, 'VINADES.,JSC <contact@vinades.vn>', ''),
(29, 'module', 'menu', 0, 0, 'menu', 'menu', '5.0.00 1736144674', 1742685231, 'VINADES.,JSC <contact@vinades.vn>', ''),
(22, 'module', 'myapi', 1, 0, 'myapi', 'myapi', '5.0.00 1736144674', 1742685231, 'VINADES.,JSC <contact@vinades.vn>', ''),
(0, 'module', 'nas', 0, 1, 'nas', 'nas', '4.6.00 1725075980', 1742685556, 'PHAN TAN DUNG <writeblabla@gmail.com>', 'Phần mềm quản lý chia sẻ ổ cứng trên không gian mạng'),
(1, 'module', 'news', 0, 1, 'news', 'news', '5.0.00 1736144674', 1742685231, 'VINADES.,JSC <contact@vinades.vn>', ''),
(282, 'module', 'page', 1, 1, 'page', 'page', '5.0.00 1736144674', 1742685231, 'VINADES.,JSC <contact@vinades.vn>', ''),
(284, 'module', 'seek', 1, 0, 'seek', 'seek', '5.0.00 1736144674', 1742685231, 'VINADES.,JSC <contact@vinades.vn>', ''),
(0, 'module', 'siteterms', 0, 0, 'page', 'siteterms', '5.0.00 1736144674', 1742685231, 'VINADES.,JSC <contact@vinades.vn>', ''),
(27, 'module', 'statistics', 0, 0, 'statistics', 'statistics', '5.0.00 1736144674', 1742685231, 'VINADES.,JSC <contact@vinades.vn>', ''),
(327, 'module', 'two-step-verification', 1, 0, 'two-step-verification', 'two_step_verification', '5.0.00 1736144674', 1742685231, 'VINADES.,JSC <contact@vinades.vn>', ''),
(24, 'module', 'users', 1, 1, 'users', 'users', '5.0.00 1736144674', 1742685231, 'VINADES.,JSC <contact@vinades.vn>', ''),
(21, 'module', 'voting', 0, 0, 'voting', 'voting', '5.0.00 1736144674', 1742685231, 'VINADES.,JSC <contact@vinades.vn>', ''),
(517, 'module', 'zalo', 1, 0, 'zalo', 'zalo', '5.0.00 1736144674', 1742685231, 'VINADES.,JSC <contact@vinades.vn>', ''),
(307, 'theme', 'default', 0, 0, 'default', 'default', '5.0.00 1736144674', 1742685231, 'VINADES.,JSC <contact@vinades.vn>', ''),
(311, 'theme', 'mobile_default', 0, 0, 'mobile_default', 'mobile_default', '5.0.00 1736144674', 1742685231, 'VINADES.,JSC <contact@vinades.vn>', '');

-- --------------------------------------------------------

--
-- Table structure for table `nv5_setup_language`
--

DROP TABLE IF EXISTS `nv5_setup_language`;
CREATE TABLE `nv5_setup_language` (
  `lang` char(2) NOT NULL,
  `setup` tinyint(1) NOT NULL DEFAULT 0,
  `weight` smallint(4) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Ngôn ngữ data';

--
-- Dumping data for table `nv5_setup_language`
--

INSERT INTO `nv5_setup_language` (`lang`, `setup`, `weight`) VALUES
('vi', 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_upload_dir`
--

DROP TABLE IF EXISTS `nv5_upload_dir`;
CREATE TABLE `nv5_upload_dir` (
  `did` mediumint(8) NOT NULL,
  `dirname` varchar(250) DEFAULT NULL,
  `time` int(11) NOT NULL DEFAULT 0,
  `total_size` double UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Dung lượng thư mục',
  `thumb_type` tinyint(4) NOT NULL DEFAULT 0,
  `thumb_width` smallint(6) NOT NULL DEFAULT 0,
  `thumb_height` smallint(6) NOT NULL DEFAULT 0,
  `thumb_quality` tinyint(4) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Thư mục upload';

--
-- Dumping data for table `nv5_upload_dir`
--

INSERT INTO `nv5_upload_dir` (`did`, `dirname`, `time`, `total_size`, `thumb_type`, `thumb_width`, `thumb_height`, `thumb_quality`) VALUES
(0, '', 0, 0, 3, 100, 150, 90),
(1, 'uploads/menu', 0, 0, 0, 0, 0, 0),
(2, 'uploads', 1742685427, 1610113, 0, 0, 0, 0),
(3, 'uploads/about', 1742685427, 242102, 0, 0, 0, 0),
(4, 'uploads/banners', 1742685427, 179287, 0, 0, 0, 0),
(5, 'uploads/banners/files', 1742685427, 0, 0, 0, 0, 0),
(6, 'uploads/comment', 1742685427, 0, 0, 0, 0, 0),
(7, 'uploads/contact', 1742685427, 0, 0, 0, 0, 0),
(8, 'uploads/emailtemplates', 1742685427, 0, 0, 0, 0, 0),
(9, 'uploads/feeds', 1742685427, 0, 0, 0, 0, 0),
(10, 'uploads/freecontent', 1742685427, 138096, 0, 0, 0, 0),
(11, 'uploads/icons', 1742685427, 2744, 0, 0, 0, 0),
(12, 'uploads/inform', 1742685427, 0, 0, 0, 0, 0),
(14, 'uploads/news', 1742685427, 853881, 0, 0, 0, 0),
(15, 'uploads/news/authors', 1742685427, 0, 0, 0, 0, 0),
(16, 'uploads/news/source', 1742685427, 0, 0, 0, 0, 0),
(17, 'uploads/news/temp_pic', 1742685427, 0, 0, 0, 0, 0),
(18, 'uploads/news/topics', 1742685427, 0, 0, 0, 0, 0),
(19, 'uploads/page', 1742685427, 0, 0, 0, 0, 0),
(20, 'uploads/siteterms', 1742685427, 0, 0, 0, 0, 0),
(21, 'uploads/users', 1742685427, 0, 0, 0, 0, 0),
(22, 'uploads/users/groups', 1742685427, 0, 0, 0, 0, 0),
(23, 'uploads/users/userfiles', 1742685427, 0, 0, 0, 0, 0),
(24, 'uploads/zalo', 1742685427, 0, 0, 0, 0, 0),
(25, 'uploads/nas', 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_upload_file`
--

DROP TABLE IF EXISTS `nv5_upload_file`;
CREATE TABLE `nv5_upload_file` (
  `name` varchar(245) NOT NULL,
  `ext` varchar(10) NOT NULL DEFAULT '',
  `type` varchar(5) NOT NULL DEFAULT '',
  `filesize` double NOT NULL DEFAULT 0,
  `src` varchar(255) NOT NULL DEFAULT '',
  `srcwidth` int(11) NOT NULL DEFAULT 0,
  `srcheight` int(11) NOT NULL DEFAULT 0,
  `sizes` varchar(50) NOT NULL DEFAULT '',
  `userid` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `mtime` int(11) NOT NULL DEFAULT 0,
  `did` int(11) NOT NULL DEFAULT 0,
  `title` varchar(245) NOT NULL DEFAULT '',
  `alt` varchar(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='File upload';

--
-- Dumping data for table `nv5_upload_file`
--

INSERT INTO `nv5_upload_file` (`name`, `ext`, `type`, `filesize`, `src`, `srcwidth`, `srcheight`, `sizes`, `userid`, `mtime`, `did`, `title`, `alt`) VALUES
('bg-1.jpg', 'jpg', 'image', 136518, 'assets/bg-1.jpg', 80, 57, '1920|1363', 1, 1727736008, 2, 'bg-1.jpg', 'bg 1'),
('bg-2.jpg', 'jpg', 'image', 57485, 'assets/bg-2.jpg', 80, 38, '1920|905', 1, 1727736263, 2, 'bg-2.jpg', 'bg 2'),
('logo-nukev...png', 'png', 'image', 13223, 'assets/about/logo-nukeviet3-flag-180x75.png', 80, 34, '180|75', 1, 1742336394, 3, 'logo-nukeviet3-flag-180x75.png', 'logo nukeviet3 flag 180x75'),
('nukevietcm...png', 'png', 'image', 13125, 'assets/about/nukevietcms_laco_180x57.png', 80, 26, '180|57', 1, 1742336394, 3, 'nukevietcms_laco_180x57.png', 'nukevietcms laco 180x57'),
('nukevietcm...png', 'png', 'image', 13319, 'assets/about/nukevietcms_mu_noel_180x84.png', 80, 38, '180|84', 1, 1742336394, 3, 'nukevietcms_mu_noel_180x84.png', 'nukevietcms mu noel 180x84'),
('nukevietcm...png', 'png', 'image', 11974, 'assets/about/nukevietcms-180x84.png', 80, 38, '180|84', 1, 1742336394, 3, 'nukevietcms-180x84.png', 'nukevietcms 180x84'),
('nukevietcms.png', 'png', 'image', 85684, 'assets/about/nukevietcms.png', 80, 38, '1500|700', 1, 1742336394, 3, 'nukevietcms.png', 'nukevietcms'),
('nukevietvn...png', 'png', 'image', 11586, 'assets/about/nukevietvn_180x84.png', 80, 38, '180|84', 1, 1742336394, 3, 'nukevietvn_180x84.png', 'nukevietvn 180x84'),
('nukevietvn.png', 'png', 'image', 81035, 'assets/about/nukevietvn.png', 80, 38, '1500|700', 1, 1742336394, 3, 'nukevietvn.png', 'nukevietvn'),
('w.png', 'png', 'image', 12156, 'assets/about/w.png', 80, 40, '288|143', 1, 1742336394, 3, 'w.png', 'w'),
('vinades.jpg', 'jpg', 'image', 104940, 'assets/banners/vinades.jpg', 43, 80, '212|400', 1, 1742336394, 4, 'vinades.jpg', 'vinades'),
('webnhanh.jpg', 'jpg', 'image', 74347, 'assets/banners/webnhanh.jpg', 80, 10, '572|72', 1, 1742336394, 4, 'webnhanh.jpg', 'webnhanh'),
('cms.jpg', 'jpg', 'image', 29026, 'assets/freecontent/cms.jpg', 80, 44, '130|71', 1, 1742336394, 10, 'cms.jpg', 'cms'),
('edugate.jpg', 'jpg', 'image', 28008, 'assets/freecontent/edugate.jpg', 80, 44, '130|71', 1, 1742336394, 10, 'edugate.jpg', 'edugate'),
('portal.jpg', 'jpg', 'image', 25973, 'assets/freecontent/portal.jpg', 80, 44, '130|71', 1, 1742336394, 10, 'portal.jpg', 'portal'),
('shop.jpg', 'jpg', 'image', 26352, 'assets/freecontent/shop.jpg', 80, 44, '130|71', 1, 1742336394, 10, 'shop.jpg', 'shop'),
('toa-soan-d...jpg', 'jpg', 'image', 28737, 'assets/freecontent/toa-soan-dien-tu.jpg', 80, 44, '130|71', 1, 1742336394, 10, 'toa-soan-dien-tu.jpg', 'toa soan dien tu'),
('nas-fav.png', 'png', 'image', 2744, 'assets/icons/nas-fav.png', 48, 48, '48|48', 1, 1727426670, 11, 'nas-fav.png', 'nas fav'),
('chuc-mung-...jpg', 'jpg', 'image', 130708, 'assets/news/chuc-mung-nukeviet-thong-tu-20-bo-tttt.jpg', 80, 62, '461|360', 1, 1742336394, 14, 'chuc-mung-nukeviet-thong-tu-20-bo-tttt.jpg', 'chuc mung nukeviet thong tu 20 bo tttt'),
('hoc-viec-t...jpg', 'jpg', 'image', 167193, 'assets/news/hoc-viec-tai-cong-ty-vinades.jpg', 80, 63, '460|360', 1, 1742336394, 14, 'hoc-viec-tai-cong-ty-vinades.jpg', 'hoc viec tai cong ty vinades'),
('hoptac.jpg', 'jpg', 'image', 12871, 'assets/news/hoptac.jpg', 80, 66, '382|314', 1, 1742336394, 14, 'hoptac.jpg', 'hoptac'),
('nangly.jpg', 'jpg', 'image', 34802, 'assets/news/nangly.jpg', 80, 53, '500|332', 1, 1742336394, 14, 'nangly.jpg', 'nangly'),
('nukeviet-cms.jpg', 'jpg', 'image', 83489, 'assets/news/nukeviet-cms.jpg', 80, 55, '500|345', 1, 1742336394, 14, 'nukeviet-cms.jpg', 'nukeviet cms'),
('nukeviet-n...jpg', 'jpg', 'image', 18611, 'assets/news/nukeviet-nhantaidatviet2011.jpg', 80, 54, '400|268', 1, 1742336394, 14, 'nukeviet-nhantaidatviet2011.jpg', 'nukeviet nhantaidatviet2011'),
('tap-huan-p...jpg', 'jpg', 'image', 132379, 'assets/news/tap-huan-pgd-ha-dong-2015.jpg', 80, 52, '460|295', 1, 1742336394, 14, 'tap-huan-pgd-ha-dong-2015.jpg', 'tap huan pgd ha dong 2015'),
('thuc-tap-sinh.jpg', 'jpg', 'image', 71135, 'assets/news/thuc-tap-sinh.jpg', 80, 63, '460|360', 1, 1742336394, 14, 'thuc-tap-sinh.jpg', 'thuc tap sinh'),
('tuyen-dung...png', 'png', 'image', 118910, 'assets/news/tuyen-dung-nvkd.png', 80, 56, '400|279', 1, 1742336394, 14, 'tuyen-dung-nvkd.png', 'tuyen dung nvkd'),
('tuyendung-...jpg', 'jpg', 'image', 83783, 'assets/news/tuyendung-kythuat.jpg', 80, 80, '300|300', 1, 1742336394, 14, 'tuyendung-kythuat.jpg', 'tuyendung kythuat');

-- --------------------------------------------------------

--
-- Table structure for table `nv5_users`
--

DROP TABLE IF EXISTS `nv5_users`;
CREATE TABLE `nv5_users` (
  `userid` mediumint(8) UNSIGNED NOT NULL,
  `group_id` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `username` varchar(100) NOT NULL DEFAULT '',
  `md5username` char(32) NOT NULL DEFAULT '',
  `password` varchar(150) NOT NULL DEFAULT '',
  `email` varchar(100) NOT NULL DEFAULT '',
  `first_name` varchar(100) NOT NULL DEFAULT '',
  `last_name` varchar(100) NOT NULL DEFAULT '',
  `gender` char(1) DEFAULT '',
  `photo` varchar(255) DEFAULT '',
  `birthday` int(11) NOT NULL,
  `sig` text DEFAULT NULL,
  `regdate` int(11) NOT NULL DEFAULT 0,
  `question` varchar(255) NOT NULL,
  `answer` varchar(255) NOT NULL DEFAULT '',
  `passlostkey` varchar(50) DEFAULT '',
  `view_mail` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `remember` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `in_groups` varchar(255) DEFAULT '',
  `active` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `active2step` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `secretkey` varchar(20) DEFAULT '',
  `pref_2fa` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Xác thực 2 bước ưu tiên: 0 chưa chọn để hệ thống tự xác định, 1 mã ứng dụng, 2 khóa truy cập',
  `sec_keys` smallint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Số khóa bảo mật hoặc passkey',
  `checknum` varchar(40) DEFAULT '',
  `last_login` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `last_ip` varchar(45) DEFAULT '',
  `last_agent` varchar(255) DEFAULT '',
  `last_openid` varchar(255) DEFAULT '',
  `last_passkey` varchar(100) NOT NULL DEFAULT '' COMMENT 'Nickname của passkey cuối cùng',
  `last_update` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Thời điểm cập nhật thông tin lần cuối',
  `idsite` int(11) NOT NULL DEFAULT 0,
  `safemode` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `safekey` varchar(40) DEFAULT '',
  `pass_creation_time` int(11) NOT NULL DEFAULT 0,
  `pass_reset_request` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Yêu cầu thay đổi mật khẩu: 0: không; 1: Bắt buộc; 2: Khuyến khích',
  `email_creation_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Thời gian cập nhật email',
  `email_reset_request` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Yêu cầu thay đổi email: 0: không; 1: Bắt buộc; 2: Khuyến khích',
  `email_verification_time` int(11) NOT NULL DEFAULT -1 COMMENT '-3: Tài khoản sys, -2: Admin kích hoạt, -1 không cần kích hoạt, 0: Chưa xác minh, > 0 thời gian xác minh',
  `active_obj` varchar(50) NOT NULL DEFAULT 'SYSTEM' COMMENT 'SYSTEM, EMAIL, OAUTH:xxxx, quản trị kích hoạt thì lưu userid',
  `language` char(2) NOT NULL DEFAULT '' COMMENT 'Ngôn ngữ giao diện'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_users`
--

INSERT INTO `nv5_users` (`userid`, `group_id`, `username`, `md5username`, `password`, `email`, `first_name`, `last_name`, `gender`, `photo`, `birthday`, `sig`, `regdate`, `question`, `answer`, `passlostkey`, `view_mail`, `remember`, `in_groups`, `active`, `active2step`, `secretkey`, `pref_2fa`, `sec_keys`, `checknum`, `last_login`, `last_ip`, `last_agent`, `last_openid`, `last_passkey`, `last_update`, `idsite`, `safemode`, `safekey`, `pass_creation_time`, `pass_reset_request`, `email_creation_time`, `email_reset_request`, `email_verification_time`, `active_obj`, `language`) VALUES
(1, 1, 'webmaster', '50a9c7dbf0fa09e8969978317dca12e8', '{SSHA512}ScGy0jkdK4UcQ6enNbOzyiIRZgZeODud7BK+U9WFHKwxzzygWPdREOCEhiybYnXhoFV3YXWtxMYxmFxSMx2JYzY5MmY=', 'webmaster@blanas.local', 'webmaster', '', '', '', 0, '', 1742685427, 'NukeViet', 'NukeVietCMS', '', 0, 1, '1,4', 1, 0, '', 0, 0, '4f015b432fa90908cbec5d4abfafc894', 1742689573, '172.19.1.0', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '', '', 0, 0, 0, '', 1742685427, 0, 1742685427, 0, -3, 'SYSTEM', '');

-- --------------------------------------------------------

--
-- Table structure for table `nv5_users_backupcodes`
--

DROP TABLE IF EXISTS `nv5_users_backupcodes`;
CREATE TABLE `nv5_users_backupcodes` (
  `userid` mediumint(8) UNSIGNED NOT NULL,
  `code` varchar(20) NOT NULL,
  `is_used` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `time_used` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `time_creat` int(11) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_users_config`
--

DROP TABLE IF EXISTS `nv5_users_config`;
CREATE TABLE `nv5_users_config` (
  `config` varchar(100) NOT NULL,
  `content` text DEFAULT NULL,
  `edit_time` int(11) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_users_config`
--

INSERT INTO `nv5_users_config` (`config`, `content`, `edit_time`) VALUES
('access_admin', 'a:8:{s:15:\"access_viewlist\";a:3:{i:1;b:1;i:2;b:1;i:3;b:1;}s:12:\"access_addus\";a:3:{i:1;b:1;i:2;b:1;i:3;b:1;}s:14:\"access_waiting\";a:3:{i:1;b:1;i:2;b:1;i:3;b:1;}s:17:\"access_editcensor\";a:3:{i:1;b:1;i:2;b:1;i:3;b:1;}s:13:\"access_editus\";a:3:{i:1;b:1;i:2;b:1;i:3;b:1;}s:12:\"access_delus\";a:3:{i:1;b:1;i:2;b:1;i:3;b:1;}s:13:\"access_passus\";a:3:{i:1;b:1;i:2;b:1;i:3;b:1;}s:13:\"access_groups\";a:3:{i:1;b:1;i:2;b:1;i:3;b:1;}}', 1742685231),
('password_simple', '000000|1234|2000|12345|111111|123123|123456|11223344|654321|696969|1234567|12345678|87654321|123456789|23456789|1234567890|66666666|68686868|66668888|88888888|99999999|999999999|1234569|12345679|aaaaaa|abc123|abc123@|abc@123|admin123|admin123@|admin@123|nuke123|nuke123@|nuke@123|adobe1|adobe123|azerty|baseball|dragon|football|harley|iloveyou|jennifer|jordan|letmein|macromedia|master|michael|monkey|mustang|password|photoshop|pussy|qwerty|shadow|superman|hoilamgi|khongbiet|khongco|khongcopass', 1742685231),
('deny_email', 'yoursite.com|mysite.com|localhost|xxx', 1742685231),
('deny_name', 'anonimo|anonymous|god|linux|nobody|operator|root', 1742685231),
('avatar_width', '80', 1742685231),
('avatar_height', '80', 1742685231),
('active_group_newusers', '0', 1742685231),
('active_editinfo_censor', '0', 1742685231),
('active_user_logs', '1', 1742685231),
('min_old_user', '16', 1742685231),
('register_active_time', '86400', 1742685231),
('auto_assign_oauthuser', '0', 1742685231),
('admin_email', '0', 1742685231),
('siteterms_vi', '<p> Để đăng ký Tài khoản người dùng, bạn phải cam kết đồng ý với các điều khoản dưới đây. Chúng tôi có thể thay đổi lại những điều khoản này vào bất cứ lúc nào và chúng tôi sẽ cố gắng thông báo đến bạn kịp thời.<br /> <br /> Bạn cam kết không gửi bất cứ bài viết có nội dung lừa đảo, thô tục, thiếu văn hoá; vu khống, khiêu khích, đe doạ người khác; liên quan đến các vấn đề tình dục hay bất cứ nội dung nào vi phạm luật pháp của quốc gia mà bạn đang sống, luật pháp của quốc gia nơi đặt máy chủ của website này hay luật pháp quốc tế. Nếu vẫn cố tình vi phạm, ngay lập tức bạn sẽ bị cấm tham gia vào website. Địa chỉ IP của tất cả các bài viết đều được ghi nhận lại để bảo vệ các điều khoản cam kết này trong trường hợp bạn không tuân thủ.<br /> <br /> Bạn đồng ý rằng website có quyền gỡ bỏ, sửa, di chuyển hoặc khoá bất kỳ bài viết nào trong website vào bất cứ lúc nào tuỳ theo nhu cầu công việc.<br /> <br />Đăng ký Tài khoản người dùng của chúng tôi, bạn cũng phải đồng ý rằng, bất kỳ thông tin cá nhân nào mà bạn cung cấp đều được lưu trữ trong cơ sở dữ liệu của hệ thống. Mặc dù những thông tin này sẽ không được cung cấp cho bất kỳ người thứ ba nào khác mà không được sự đồng ý của bạn, chúng tôi không chịu trách nhiệm về việc những thông tin cá nhân này của bạn bị lộ ra bên ngoài từ những kẻ phá hoại có ý đồ xấu tấn công vào cơ sở dữ liệu của hệ thống.</p>', 1274757129);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_users_edit`
--

DROP TABLE IF EXISTS `nv5_users_edit`;
CREATE TABLE `nv5_users_edit` (
  `userid` mediumint(8) UNSIGNED NOT NULL,
  `lastedit` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `info_basic` text NOT NULL,
  `info_custom` text NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_users_field`
--

DROP TABLE IF EXISTS `nv5_users_field`;
CREATE TABLE `nv5_users_field` (
  `fid` mediumint(8) NOT NULL,
  `field` varchar(25) NOT NULL,
  `weight` int(10) UNSIGNED NOT NULL DEFAULT 1,
  `field_type` enum('number','date','textbox','textarea','editor','select','radio','checkbox','multiselect','file') NOT NULL DEFAULT 'textbox',
  `field_choices` text NOT NULL,
  `sql_choices` text NOT NULL,
  `match_type` enum('none','alphanumeric','unicodename','email','url','regex','callback') NOT NULL DEFAULT 'none',
  `match_regex` varchar(250) NOT NULL DEFAULT '',
  `func_callback` varchar(75) NOT NULL DEFAULT '',
  `min_length` int(11) NOT NULL DEFAULT 0,
  `max_length` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `limited_values` text DEFAULT NULL,
  `for_admin` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `required` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `show_register` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `user_editable` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `show_profile` tinyint(4) NOT NULL DEFAULT 1,
  `class` varchar(50) NOT NULL,
  `language` text NOT NULL,
  `default_value` varchar(255) NOT NULL DEFAULT '',
  `is_system` tinyint(1) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_users_field`
--

INSERT INTO `nv5_users_field` (`fid`, `field`, `weight`, `field_type`, `field_choices`, `sql_choices`, `match_type`, `match_regex`, `func_callback`, `min_length`, `max_length`, `limited_values`, `for_admin`, `required`, `show_register`, `user_editable`, `show_profile`, `class`, `language`, `default_value`, `is_system`) VALUES
(1, 'first_name', 1, 'textbox', '', '', 'none', '', '', 0, 100, '', 0, 1, 1, 1, 1, 'input', 'a:1:{s:2:\"vi\";a:2:{i:0;s:4:\"Tên\";i:1;s:0:\"\";}}', '', 1),
(2, 'last_name', 2, 'textbox', '', '', 'none', '', '', 0, 100, '', 0, 0, 1, 1, 1, 'input', 'a:1:{s:2:\"vi\";a:2:{i:0;s:4:\"Họ\";i:1;s:0:\"\";}}', '', 1),
(3, 'gender', 3, 'select', 'a:3:{s:1:\"N\";s:0:\"\";s:1:\"M\";s:0:\"\";s:1:\"F\";s:0:\"\";}', '', 'none', '', '', 0, 1, '', 0, 0, 1, 1, 1, 'input', 'a:1:{s:2:\"vi\";a:2:{i:0;s:12:\"Giới tính\";i:1;s:0:\"\";}}', '2', 1),
(4, 'birthday', 4, 'date', 'a:1:{s:12:\"current_date\";i:0;}', '', 'none', '', '', 0, 0, '', 0, 1, 1, 1, 1, 'input', 'a:1:{s:2:\"vi\";a:2:{i:0;s:10:\"Ngày sinh\";i:1;s:0:\"\";}}', '0', 1),
(5, 'sig', 5, 'textarea', '', '', 'none', '', '', 0, 1000, '', 0, 0, 1, 1, 1, 'input', 'a:1:{s:2:\"vi\";a:2:{i:0;s:9:\"Chữ ký\";i:1;s:0:\"\";}}', '', 1),
(6, 'question', 6, 'textbox', '', '', 'none', '', '', 3, 255, '', 0, 1, 1, 1, 1, 'input', 'a:1:{s:2:\"vi\";a:2:{i:0;s:22:\"Câu hỏi bảo mật\";i:1;s:0:\"\";}}', '', 1),
(7, 'answer', 7, 'textbox', '', '', 'none', '', '', 3, 255, '', 0, 1, 1, 1, 1, 'input', 'a:1:{s:2:\"vi\";a:2:{i:0;s:16:\"Câu trả lời\";i:1;s:0:\"\";}}', '', 1);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_users_groups`
--

DROP TABLE IF EXISTS `nv5_users_groups`;
CREATE TABLE `nv5_users_groups` (
  `group_id` smallint(5) UNSIGNED NOT NULL,
  `alias` varchar(240) NOT NULL,
  `email` varchar(100) DEFAULT '',
  `group_type` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0:Sys, 1:approval, 2:public',
  `group_color` varchar(10) NOT NULL,
  `group_avatar` varchar(255) NOT NULL,
  `require_2step_admin` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `require_2step_site` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `is_default` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `add_time` int(11) NOT NULL,
  `exp_time` int(11) NOT NULL,
  `weight` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `act` tinyint(1) UNSIGNED NOT NULL,
  `idsite` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `numbers` mediumint(9) UNSIGNED NOT NULL DEFAULT 0,
  `siteus` tinyint(4) UNSIGNED NOT NULL DEFAULT 0,
  `config` varchar(250) DEFAULT ''
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_users_groups`
--

INSERT INTO `nv5_users_groups` (`group_id`, `alias`, `email`, `group_type`, `group_color`, `group_avatar`, `require_2step_admin`, `require_2step_site`, `is_default`, `add_time`, `exp_time`, `weight`, `act`, `idsite`, `numbers`, `siteus`, `config`) VALUES
(1, 'Super-Admin', '', 0, '', '', 0, 0, 0, 1742685231, 0, 1, 1, 0, 1, 0, 'a:7:{s:17:\"access_groups_add\";i:1;s:17:\"access_groups_del\";i:1;s:12:\"access_addus\";i:0;s:14:\"access_waiting\";i:0;s:13:\"access_editus\";i:0;s:12:\"access_delus\";i:0;s:13:\"access_passus\";i:0;}'),
(2, 'General-Admin', '', 0, '', '', 0, 0, 0, 1742685231, 0, 2, 1, 0, 0, 0, 'a:7:{s:17:\"access_groups_add\";i:1;s:17:\"access_groups_del\";i:1;s:12:\"access_addus\";i:0;s:14:\"access_waiting\";i:0;s:13:\"access_editus\";i:0;s:12:\"access_delus\";i:0;s:13:\"access_passus\";i:0;}'),
(3, 'Module-Admin', '', 0, '', '', 0, 0, 0, 1742685231, 0, 3, 1, 0, 0, 0, 'a:7:{s:17:\"access_groups_add\";i:1;s:17:\"access_groups_del\";i:1;s:12:\"access_addus\";i:0;s:14:\"access_waiting\";i:0;s:13:\"access_editus\";i:0;s:12:\"access_delus\";i:0;s:13:\"access_passus\";i:0;}'),
(4, 'Users', '', 0, '', '', 0, 0, 0, 1742685231, 0, 4, 1, 0, 1, 0, 'a:7:{s:17:\"access_groups_add\";i:1;s:17:\"access_groups_del\";i:1;s:12:\"access_addus\";i:0;s:14:\"access_waiting\";i:0;s:13:\"access_editus\";i:0;s:12:\"access_delus\";i:0;s:13:\"access_passus\";i:0;}'),
(7, 'New-Users', '', 0, '', '', 0, 0, 0, 1742685231, 0, 5, 1, 0, 0, 0, 'a:7:{s:17:\"access_groups_add\";i:1;s:17:\"access_groups_del\";i:1;s:12:\"access_addus\";i:0;s:14:\"access_waiting\";i:0;s:13:\"access_editus\";i:0;s:12:\"access_delus\";i:0;s:13:\"access_passus\";i:0;}'),
(5, 'Guest', '', 0, '', '', 0, 0, 0, 1742685231, 0, 6, 1, 0, 0, 0, 'a:7:{s:17:\"access_groups_add\";i:1;s:17:\"access_groups_del\";i:1;s:12:\"access_addus\";i:0;s:14:\"access_waiting\";i:0;s:13:\"access_editus\";i:0;s:12:\"access_delus\";i:0;s:13:\"access_passus\";i:0;}'),
(6, 'All', '', 0, '', '', 0, 0, 0, 1742685231, 0, 7, 1, 0, 0, 0, 'a:7:{s:17:\"access_groups_add\";i:1;s:17:\"access_groups_del\";i:1;s:12:\"access_addus\";i:0;s:14:\"access_waiting\";i:0;s:13:\"access_editus\";i:0;s:12:\"access_delus\";i:0;s:13:\"access_passus\";i:0;}'),
(10, 'NukeViet-Fans', '', 2, '', '', 0, 0, 1, 1742685231, 0, 8, 1, 0, 0, 0, 'a:7:{s:17:\"access_groups_add\";i:1;s:17:\"access_groups_del\";i:1;s:12:\"access_addus\";i:0;s:14:\"access_waiting\";i:0;s:13:\"access_editus\";i:0;s:12:\"access_delus\";i:0;s:13:\"access_passus\";i:0;}'),
(11, 'NukeViet-Admins', '', 2, '', '', 0, 0, 0, 1742685231, 0, 9, 1, 0, 0, 0, 'a:7:{s:17:\"access_groups_add\";i:1;s:17:\"access_groups_del\";i:1;s:12:\"access_addus\";i:0;s:14:\"access_waiting\";i:0;s:13:\"access_editus\";i:0;s:12:\"access_delus\";i:0;s:13:\"access_passus\";i:0;}'),
(12, 'NukeViet-Programmers', '', 1, '', '', 0, 0, 0, 1742685231, 0, 10, 1, 0, 0, 0, 'a:7:{s:17:\"access_groups_add\";i:1;s:17:\"access_groups_del\";i:1;s:12:\"access_addus\";i:0;s:14:\"access_waiting\";i:0;s:13:\"access_editus\";i:0;s:12:\"access_delus\";i:0;s:13:\"access_passus\";i:0;}');

-- --------------------------------------------------------

--
-- Table structure for table `nv5_users_groups_detail`
--

DROP TABLE IF EXISTS `nv5_users_groups_detail`;
CREATE TABLE `nv5_users_groups_detail` (
  `group_id` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `lang` char(2) NOT NULL DEFAULT '',
  `title` varchar(240) NOT NULL,
  `description` varchar(240) NOT NULL DEFAULT '',
  `content` text DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_users_groups_detail`
--

INSERT INTO `nv5_users_groups_detail` (`group_id`, `lang`, `title`, `description`, `content`) VALUES
(1, 'vi', 'Super Admin', '', ''),
(2, 'vi', 'General Admin', '', ''),
(3, 'vi', 'Module Admin', '', ''),
(4, 'vi', 'Users', '', ''),
(7, 'vi', 'New Users', '', ''),
(5, 'vi', 'Guest', '', ''),
(6, 'vi', 'All', '', ''),
(10, 'vi', 'Người hâm mộ', 'Nhóm những người hâm mộ hệ thống NukeViet', ''),
(11, 'vi', 'Người quản lý', 'Nhóm những người quản lý website xây dựng bằng hệ thống NukeViet', ''),
(12, 'vi', 'Lập trình viên', 'Nhóm Lập trình viên hệ thống NukeViet', '');

-- --------------------------------------------------------

--
-- Table structure for table `nv5_users_groups_users`
--

DROP TABLE IF EXISTS `nv5_users_groups_users`;
CREATE TABLE `nv5_users_groups_users` (
  `group_id` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `userid` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `is_leader` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `approved` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `data` text NOT NULL,
  `time_requested` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Thời gian yêu cầu tham gia',
  `time_approved` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Thời gian duyệt yêu cầu tham gia'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_users_groups_users`
--

INSERT INTO `nv5_users_groups_users` (`group_id`, `userid`, `is_leader`, `approved`, `data`, `time_requested`, `time_approved`) VALUES
(1, 1, 1, 1, '0', 1742685427, 1742685427);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_users_info`
--

DROP TABLE IF EXISTS `nv5_users_info`;
CREATE TABLE `nv5_users_info` (
  `userid` mediumint(8) UNSIGNED NOT NULL,
  `inform` char(30) NOT NULL DEFAULT ''
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_users_info`
--

INSERT INTO `nv5_users_info` (`userid`, `inform`) VALUES
(1, '');

-- --------------------------------------------------------

--
-- Table structure for table `nv5_users_login`
--

DROP TABLE IF EXISTS `nv5_users_login`;
CREATE TABLE `nv5_users_login` (
  `userid` mediumint(8) UNSIGNED NOT NULL,
  `clid` char(32) NOT NULL,
  `logtime` int(11) UNSIGNED NOT NULL,
  `mode` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `agent` varchar(255) NOT NULL,
  `ip` char(50) NOT NULL,
  `mode_extra` varchar(255) NOT NULL DEFAULT ''
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_users_login`
--

INSERT INTO `nv5_users_login` (`userid`, `clid`, `logtime`, `mode`, `agent`, `ip`, `mode_extra`) VALUES
(1, '85dea34af48f7f5c8e239b26652ca3c1', 1742689573, 0, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '172.19.1.0', '');

-- --------------------------------------------------------

--
-- Table structure for table `nv5_users_oldpass`
--

DROP TABLE IF EXISTS `nv5_users_oldpass`;
CREATE TABLE `nv5_users_oldpass` (
  `userid` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `password` varchar(150) NOT NULL DEFAULT '',
  `pass_creation_time` int(11) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_users_openid`
--

DROP TABLE IF EXISTS `nv5_users_openid`;
CREATE TABLE `nv5_users_openid` (
  `userid` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `openid` char(50) NOT NULL DEFAULT '',
  `opid` char(50) NOT NULL DEFAULT '',
  `id` char(50) NOT NULL DEFAULT '',
  `email` varchar(100) NOT NULL DEFAULT ''
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_users_passkey`
--

DROP TABLE IF EXISTS `nv5_users_passkey`;
CREATE TABLE `nv5_users_passkey` (
  `id` int(11) UNSIGNED NOT NULL,
  `userid` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `keyid` varchar(180) NOT NULL DEFAULT '' COMMENT 'Key ID',
  `publickey` text NOT NULL COMMENT 'Public key',
  `userhandle` varchar(100) NOT NULL DEFAULT '' COMMENT 'User handle',
  `counter` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Bộ đếm phát hiện thiết bị fake',
  `aaguid` varchar(50) NOT NULL DEFAULT '' COMMENT 'GUID thiết bị',
  `type` varchar(50) NOT NULL DEFAULT '' COMMENT 'Loại, thường chỉ là public-key',
  `created_at` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Tạo',
  `last_used_at` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Lần cuối sử dụng',
  `clid` varchar(32) NOT NULL DEFAULT '' COMMENT 'ID trình duyệt tạo ra nó',
  `enable_login` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Cho phép đăng nhập hay không',
  `nickname` varchar(100) NOT NULL DEFAULT '' COMMENT 'Đặt tên gợi nhớ'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Passkey của thành viên để đăng nhập/xác thực 2 bước';

-- --------------------------------------------------------

--
-- Table structure for table `nv5_users_question`
--

DROP TABLE IF EXISTS `nv5_users_question`;
CREATE TABLE `nv5_users_question` (
  `qid` smallint(5) UNSIGNED NOT NULL,
  `title` varchar(240) NOT NULL DEFAULT '',
  `lang` char(2) NOT NULL DEFAULT '',
  `weight` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `add_time` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `edit_time` int(11) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_users_question`
--

INSERT INTO `nv5_users_question` (`qid`, `title`, `lang`, `weight`, `add_time`, `edit_time`) VALUES
(1, 'Bạn thích môn thể thao nào nhất', 'vi', 1, 1274840238, 1274840238),
(2, 'Món ăn mà bạn yêu thích', 'vi', 2, 1274840250, 1274840250),
(3, 'Thần tượng điện ảnh của bạn', 'vi', 3, 1274840257, 1274840257),
(4, 'Bạn thích nhạc sỹ nào nhất', 'vi', 4, 1274840264, 1274840264),
(5, 'Quê ngoại của bạn ở đâu', 'vi', 5, 1274840270, 1274840270),
(6, 'Tên cuốn sách &quot;gối đầu giường&quot;', 'vi', 6, 1274840278, 1274840278),
(7, 'Ngày lễ mà bạn luôn mong đợi', 'vi', 7, 1274840285, 1274840285);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_users_reg`
--

DROP TABLE IF EXISTS `nv5_users_reg`;
CREATE TABLE `nv5_users_reg` (
  `userid` mediumint(8) UNSIGNED NOT NULL,
  `username` varchar(100) NOT NULL DEFAULT '',
  `md5username` char(32) NOT NULL DEFAULT '',
  `password` varchar(150) NOT NULL DEFAULT '',
  `email` varchar(100) NOT NULL DEFAULT '',
  `first_name` varchar(255) NOT NULL DEFAULT '',
  `last_name` varchar(255) NOT NULL DEFAULT '',
  `gender` char(1) NOT NULL DEFAULT '',
  `birthday` int(11) NOT NULL,
  `sig` text DEFAULT NULL,
  `regdate` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `question` varchar(255) NOT NULL,
  `answer` varchar(255) NOT NULL DEFAULT '',
  `checknum` varchar(50) NOT NULL DEFAULT '',
  `users_info` text DEFAULT NULL,
  `openid_info` text DEFAULT NULL,
  `idsite` mediumint(8) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_vi_about`
--

DROP TABLE IF EXISTS `nv5_vi_about`;
CREATE TABLE `nv5_vi_about` (
  `id` mediumint(8) UNSIGNED NOT NULL,
  `title` varchar(250) NOT NULL,
  `alias` varchar(250) NOT NULL,
  `image` varchar(255) DEFAULT '',
  `imagealt` varchar(255) DEFAULT '',
  `imageposition` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `description` text DEFAULT NULL,
  `bodytext` mediumtext NOT NULL,
  `keywords` text DEFAULT NULL,
  `socialbutton` tinyint(4) NOT NULL DEFAULT 0,
  `activecomm` varchar(255) DEFAULT '',
  `layout_func` varchar(100) DEFAULT '',
  `weight` smallint(4) NOT NULL DEFAULT 0,
  `admin_id` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `add_time` int(11) NOT NULL DEFAULT 0,
  `edit_time` int(11) NOT NULL DEFAULT 0,
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `hitstotal` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `hot_post` tinyint(1) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_vi_about`
--

INSERT INTO `nv5_vi_about` (`id`, `title`, `alias`, `image`, `imagealt`, `imageposition`, `description`, `bodytext`, `keywords`, `socialbutton`, `activecomm`, `layout_func`, `weight`, `admin_id`, `add_time`, `edit_time`, `status`, `hitstotal`, `hot_post`) VALUES
(1, 'Giới thiệu về NukeViet', 'gioi-thieu-ve-nukeviet', '', '', 0, '', '<h2><span style=\"font-size:20px;\"><strong>Giới thiệu khái quát</strong></span></h2>  <p>NukeViet là một ứng dụng trên nền web có thể sử dụng vào nhiều mục đích khác nhau. Phiên bản đang được phát hành theo giấy phép phần mềm tự do nguồn mở có tên gọi đầy đủ là <a href=\"/about/Gioi-thieu-ve-NukeViet-CMS.html\"><b>NukeViet CMS</b></a> gồm 2 phần chính là phần nhân (core) của hệ thống NukeViet và nhóm chức năng quản trị nội dung của CMS thường được sử dụng để xây dựng các website tin tức do đó người dùng thường nghĩ rằng NukeViet mạnh về hệ thống tin tức. Tuy nhiên, đội ngũ phát triển NukeViet đã phát triển nhiều hệ thống khác nhau cho NukeViet, nổi bật nhất là:</p>  <ul> 	<li>NukeViet Portal: Cổng thông tin hai chiều dùng cho doanh nghiệp.</li> 	<li><a href=\"http://edu.nukeviet.vn\" target=\"_blank\">NukeViet Edu Gate</a>: Cổng thông tin tích hợp nhiều website, sử dụng cho phòng giáo dục, sở giáo dục.</li> 	<li><a href=\"http://toasoandientu.vn\" target=\"_blank\">NukeViet Tòa Soạn Điện Tử</a>: Sử dụng cho các tòa soạn báo điện tử, trang tin điện tử.</li> </ul> Theo định hướng phát triển của NukeViet, ngoài NukeViet CMS đã được phát hành theo giấy phép tự do nguồn mở trong nhiều năm qua, NukeViet sẽ có thêm 2 nhóm ứng dụng nữa là:  <ul> 	<li>NukeViet Blog: Dành cho các website và người dùng tạo các trang nhật ký cá nhân.</li> 	<li>NukeViet Shop: dành cho các website thương mại điện tử với hoạt động chính là bán hàng trực tuyến, hiện đã có thể sử dụng bằng cách cài bổ sung <a href=\"https://github.com/nukeviet/module-shops\" target=\"_blank\">module Shop</a> lên NukeViet CMS.</li> </ul> &nbsp;  <h2><span style=\"font-size:20px;\"><strong>Video giới thiệu</strong></span></h2> <span style=\"font-size:14px;\">Video clip &quot;Giới thiệu mã nguồn mở NukeViet&quot; trong bản tin Tiêu điểm của chương trình Xã hội thông tin<br  /> (Đài truyền hình kỹ thuật số VTC) phát sóng lúc 20h chủ nhật, ngày 05-09-2010 trên VTC1</span>  <div style=\"text-align: center;\"> <div style=\"text-align: center;\"> <div class=\"youtube-embed-wrapper\" style=\"position:relative;padding-bottom:56.25%;padding-top:30px;height:0;overflow:hidden;\"><iframe allowfullscreen=\"\" height=\"480\" src=\"//www.youtube.com/embed/Cxp1kCyVhqY?rel=0&amp;autoplay=1\" style=\"position: absolute;top: 0;left: 0;width: 100%;height: 100%;\" width=\"640\"></iframe></div> <br  /> <span style=\"font-size:12px;\"><em>Video clip &quot;Giới thiệu mã nguồn mở NukeViet&quot;</em></span></div> </div>  <h2><br  /> <span style=\"font-size:20px;\"><strong><span class=\"mw-headline\" id=\".E1.BB.A8ng_d.E1.BB.A5ng\">Lịch sử phát triển</span></strong></span></h2> NukeViet ra đời từ năm 2004, bắt đầu từ việc sử dụng sản phẩm PHP-Nuke để làm cho website cá nhân, anh Nguyễn Anh Tú - một lưu học sinh người Việt tại Nga - đã cùng cộng đồng Việt hóa, cải tiến theo nhu cầu sử dụng của người Việt. Được sự đón nhận của đông đảo người sử dụng, NukeViet đã liên tục được phát triển và trở thành một ứng dụng thuần Việt. Cho đến phiên bản 3.0, NukeViet đã được phát triển thành một ứng dụng khác biệt hoàn toàn, và không chỉ là một CMS, NukeViet được định hướng để trở thành phần mềm đa chức năng trên nền web.<br  /> <br  /> Kể từ năm 2010, NukeViet đã phát triển theo mô hình chuyên nghiệp, đội ngũ quản trị đã thành lập doanh nghiệp chuyên quản và đạt được những tiến bộ vượt bậc. NukeViet đã trở thành hệ quản trị nội dung nguồn mở duy nhất của Việt Nam được Bộ GD&amp;ĐT khuyến khích sử dụng trong giáo dục (thông tư 08/2010/TT-BGDĐT). Tiếp đó, NukeViet CMS đã được trao giải Nhân Tài Đất Việt 2011 và trở thành phần mềm nguồn mở đầu tiên đạt giải thưởng cao quý này. <h2><br  /> <span style=\"font-size:20px;\"><strong><span class=\"mw-headline\" id=\"Di.E1.BB.85n_.C4.91.C3.A0n_NukeViet.vn\">Diễn đàn NukeViet.vn</span></strong></span></h2>  <p>Diễn đàn NukeViet hoạt động trên website: <a href=\"https://nukeviet.vn\">https://nukeviet.vn</a>, đây là kênh chính thức và hữu hiệu cho các bạn đam mê về NukeViet có thể chia sẻ các kiến thức về NukeViet với nhau. Tính đến tháng 12 năm 2015 diễn đàn đã có trên 34.500 thành viên tham gia, bao gồm học sinh, sinh viên &amp; nhiều thành phần khác thuộc giới trí thức ở trong và ngoài nước.</p>  <p>Là một diễn đàn của các nhà quản lý website, rất nhiều thành viên trong diễn đàn NukeViet là cán bộ, lãnh đạo từ đủ mọi lĩnh vực: công nghệ thông tin, xây dựng, văn hóa - xã hội, thể thao, dịch vụ - du lịch... từ cử nhân, bác sĩ, kỹ sư cho đến bộ đội, công an..</p>  <h2><br  /> <span style=\"font-size:20px;\"><span class=\"mw-headline\" id=\"Th.C3.A0nh_t.C3.ADch_.26_gi.E1.BA.A3i_th.C6.B0.E1.BB.9Fng\"><strong>Thành tích &amp; giải thưởng</strong></span></span></h2>  <h3><span style=\"font-size:14px;\"><em><strong><span class=\"mw-headline\" id=\"Khen_th.C6.B0.E1.BB.9Fng_.26_Th.C3.A0nh_t.C3.ADch\">Khen thưởng &amp; Thành tích</span></strong></em></span></h3>  <ul> 	<li>Giải Ba Nhân tài Đất Việt 2011 ở Lĩnh vực Công nghệ thông tin/Sản phẩm đã ứng dụng rộng rãi (không có giải nhất, nhì).</li> 	<li>Bằng khen của Hội Tin học Việt Nam vì những đóng góp xuất sắc cho sự phát triển của cộng đồng nguồn mở tại Việt Nam.</li> </ul> <span style=\"font-size:14px;\"><em><strong><span class=\"mw-headline\" id=\".C4.90.C6.B0.E1.BB.A3c_B.E1.BB.99_gi.C3.A1o_d.E1.BB.A5c_.26_.C4.90.C3.A0o_t.E1.BA.A1o_.E1.BB.A7ng_h.E1.BB.99\">Được Bộ giáo dục &amp; Đào tạo ủng hộ</span></strong></em></span>  <p>NukeViet CMS là hệ quản trị nội dung nguồn mở duy nhất của Việt Nam nằm trong danh mục các sản phẩm phần mềm nguồn mở được khuyến khích sử dụng trong thông tư số 08/2010/TT-BGDĐT do Bộ GD&amp;ĐT ban hành ngày 01-03-2010 quy định về sử dụng phần mềm tự do mã nguồn mở trong các cơ sở giáo dục). Trong bài thuyết trình &quot;Hiện trạng triển khai nội dung thông tư 08/2010/TT-BGDĐT về sử dụng PMNM trong các cơ sở giáo dục và định hướng cho thời gian tới&quot;<sup> </sup>tại Hội thảo phần mềm nguồn mở trong các cơ quan, tổ chức nhà nước năm 2012, Cục trưởng cục CNTT Quách Tuấn Ngọc cho biết: &quot;NukeViet có thể thay thế SharePoint server&quot;, &quot;NukeViet được nhiều cơ sở giáo dục thích dùng&quot;<sup> </sup>NukeViet được Bộ GD&amp;ĐT đưa vào văn bản hướng dẫn thực hiện nhiệm vụ CNTT năm học 2015 - 2016. Trong văn bản số 4983/BGDĐT-CNTT của Bộ Giáo dục và Đào tạo (Bộ GDĐT) hướng dẫn việc triển khai nhiệm vụ công nghệ thông tin (CNTT) cho năm học 2015 - 2016 có những nội dung như sau liên quan đến NukeViet:</p>  <ul> 	<li>Nhiệm vụ số &quot;5. Công tác bồi dưỡng ứng dụng CNTT cho giáo viên và cán bộ quản lý giáo dục&quot;, mục &quot;5.1 Một số nội dung cần bồi dưỡng&quot; có ghi &quot;Tập huấn sử dụng phần mềm nguồn mở NukeViet.&quot;</li> 	<li>Nhiệm vụ số &quot; 10. Khai thác, sử dụng và dạy học bằng phần mềm nguồn mở&quot; có ghi: &quot;Khai thác và áp dụng phần mềm nguồn mở NukeViet trong giáo dục.&quot;</li> 	<li>Phụ lục văn bản, có trong nội dung &quot;Khuyến cáo khi sử dụng các hệ thống CNTT&quot;, hạng mục số 3 ghi rõ &quot;Không nên làm website mã nguồn đóng&quot; và &quot;Nên làm NukeViet: phần mềm nguồn mở&quot;.</li> </ul>  <h3><span style=\"font-size:14px;\"><em><strong><span class=\"mw-headline\" id=\".C4.90.C6.B0.E1.BB.A3c_.C6.B0u_ti.C3.AAn_mua_s.E1.BA.AFm_s.E1.BB.AD_d.E1.BB.A5ng_trong_ch.C3.ADnh_ph.E1.BB.A7\">Được ưu tiên mua sắm sử dụng trong chính phủ</span></strong></em></span></h3>  <p>NukeViet CMS là hệ quản trị nội dung nguồn mở được quy định ưu tiên mua sắm, sử dụng trong các cơ quan, tổ chức nhà nước Việt Nam theo thông tư 20/2014/TT-BTTTT ký ngày 05/12/2014 và có hiệu lực từ ngày 20/1/2015 quy định về các sản phẩm phần mềm nguồn mở được ưu tiên mua sắm, sử dụng trong cơ quan, tổ chức nhà nước</p>  <h2><br  /> <span style=\"font-size:20px;\"><span class=\"mw-headline\" id=\"T.C3.ADnh_n.C4.83ng\"><strong>Tính năng</strong></span></span></h2>  <h3><span style=\"font-size:14px;\"><strong>NukeViet CMS 3.0 bản gốc có các module cơ bản là:</strong></span></h3>  <ul> 	<li>Quản lý Tin tức (<i>News</i>: Tạo bản tin chủ đề đa cấp, phân quyền theo chủ đề, hẹn giờ đăng tin, tạo bản in, bản tải về, thảo luận bản tin),</li> 	<li>Giới thiệu (<i>About</i>),</li> 	<li>Quản lý quảng cáo thương mại (banners),</li> 	<li>Quản lý người dùng (<i>users</i>),</li> 	<li>Liên hệ qua site (<i>Contact</i>),</li> 	<li>Cấp tin RSS (<i>RSS feeds</i>) và thu thập tin RSS (&quot;RSS reader&quot;),</li> 	<li>Bình chọn (thăm dò ý kiến - <i>Voting</i>),</li> 	<li>Thư viện file (<i>Download</i>),</li> 	<li>Thư viện Web (<i>Weblinks</i>),</li> 	<li>Hỏi nhanh đáp gọn(<i>Faq</i>),</li> 	<li>Thống kê truy cập (<i>statistics</i>),</li> 	<li>Tìm kiếm trong site (<i>Search</i>),</li> 	<li>Bán hàng trực tuyến (<i>Shop</i>) (có từ NukeViet 3.1)...</li> </ul>  <h3><span style=\"font-size:14px;\"><strong>Tính năng hệ thống:</strong></span></h3>  <ul> 	<li>Cài đặt, nâng cấp và đóng gói tự động.</li> 	<li>Hỗ trợ đa ngôn ngữ giao diện và đa ngôn ngữ Cơ sở dữ liệu 100%, cho phép người sử dụng tự xây dựng ngôn ngữ mới.</li> 	<li>Thay đổi &amp; tùy biến giao diện nhiều cấp độ, cho phép người sử dụng có thể cài thêm giao diện mới hoặc tùy biến giao diện trên site theo ý thích. Người sử dụng có thể tùy biến bố cục giao diện theo layout, theo block ở các khu vực khác nhau của website.</li> 	<li>Quản lý module với khả năng xử lý đa nhân module (ảo hóa module).</li> 	<li>Cho phép phân nhóm thành viên và phân quyền người quản trị theo nhiều cấp độ khác nhau.</li> 	<li>Hỗ trợ tối ưu hóa cho các công cụ tìm kiếm (SEO): Rewrite, tạo Sitemap, Ping sitemap, chẩn đoán site, phân tích từ khóa, tạo keyword, quản lý máy chủ tìm kiếm (Bot)...</li> 	<li>Quản lý và sao lưu cơ sở dữ liệu.</li> 	<li>Cấu hình tùy biến, tường lửa đa cấp, xử lý tiến trình tự động...</li> 	<li>Hỗ trợ thiết bị di động (mobile), cho phép thay đổi giao diện tương thích (từ phiên bản 3.3)</li> 	<li>...</li> </ul>  <h2><span style=\"font-size:20px;\"><strong><span class=\"mw-headline\" id=\".E1.BB.A8ng_d.E1.BB.A5ng\">Ứng dụng</span></strong></span></h2>  <p>NukeViet được sử dụng ở nhiều website, từ những website cá nhân cho tới những hệ thống website doanh nghiệp, nó cung cấp nhiều dịch vụ và ứng dụng nhờ khả năng tăng cường tính năng bằng cách cài thêm các module, block... Trước đây, NukeViet chủ yếu được sử dụng làm trang tin tức nhờ module News tích hợp sẵn trong NukeViet được viết rất công phu, nó lại đặc biệt phù hợp với yêu cầu và đặc điểm sử dụng cho hệ thống tin tức. Kể từ phiên bản NukeViet 3, đội ngũ phát triển NukeViet đã định nghĩa lại NukeViet, theo đó, NukeViet được coi như phần mềm trực tuyến mà chức năng CMS chỉ là một module của NukeViet. NukeViet có thể dễ dàng cài đặt, dễ dàng quản lý kể cả với những người mới sử dụng do đó thường được những đối tượng người dùng không chuyên ưa thích.<br  /> <br  /> NukeViet có mã nguồn mở do đó việc sử dụng NukeViet là hoàn toàn miễn phí cho tất cả mọi người trên thế giới. Từ bản 2.0 trở về trước, đối tượng người dùng chủ yếu của NukeViet là người Việt vì những đặc điểm của bản thân mã nguồn (có nguồn gốc từ PHP-Nuke) và vì chính sách của nhóm phát triển là: &quot;hệ thống Portal dành cho người Việt&quot;. Kể từ phiên bản 3.0, đội ngũ phát triển NukeViet định hướng đưa NukeViet ra cộng đồng quốc tế.</p>  <ul> 	<li>Các cổng thông tin điện tử</li> 	<li>Các tập đoàn kinh tế</li> 	<li>Giải trí trực tuyến, văn hóa, nghệ thuật.</li> 	<li>Báo điện tử, tạp chí điện tử</li> 	<li>Website của các doanh nghiệp vừa và nhỏ</li> 	<li>Website của các cơ quan, tổ chức chính phủ</li> 	<li>Website giáo dục, trường học</li> 	<li>Website của gia đình, cá nhân, nhóm sở thích...</li> </ul>  <p><br  /> Ngoài các ứng dụng website ở trên, thực tế NukeViet đã được ứng dụng làm rất nhiều phần mềm khác như: Phần mềm quản lý kho hàng, phần mềm bán hàng, phần mềm quản lý quán BI-A trợ giúp bật tắt điện đèn bàn bóng, phần mềm tòa soạn điện tử, phần mềm quản lý hồ sơ, quản lý nhân sự trực tuyến, phần mềm tra cứu điểm thi hỗ trợ SMS...</p>', '', 0, '4', '', 1, 1, 1742685231, 1742685231, 1, 0, 0),
(2, 'Giới thiệu về NukeViet CMS', 'gioi-thieu-ve-nukeviet-cms', '', '', 0, '', '<p>CMS là gì?<br  /> CMS là từ viết tắt từ Content Management System. Theo wikipedia</p>  <blockquote> <p><strong>Định nghĩa.</strong><br  /> Hệ quản trị nội dung, cũng được gọi là hệ thống quản lý nội dung hay CMS (từ Content Management System của tiếng Anh) là phần mềm để tổ chức và tạo môi trường cộng tác thuận lợi nhằm mục đích xây dựng một hệ thống tài liệu và các loại nội dung khác một cách thống nhất. Mới đây thuật ngữ này liên kết với chương trình quản lý nội dung của website. Quản lý nội dung web (web content management) cũng đồng nghĩa như vậy.<br  /> <br  /> <span class=\"mw-headline\" id=\"Ch.E1.BB.A9c_n.C4.83ng\"><strong>Chức năng</strong>.</span><br  /> Quản trị những nội dung tài liệu điện tử (bao gồm những tài liệu, văn bản số và đã được số hoá) của tổ chức. Những chức năng bao gồm:</p>  <ul> 	<li>Tạo lập nội dung;</li> 	<li>Lưu trữ nội dung;</li> 	<li>Chỉnh sửa nội dung;</li> 	<li>Chuyển tải nội dung;</li> 	<li>Chia sẻ nội dung;</li> 	<li>Tìm kiếm nội dung;</li> 	<li>Phân quyền người dùng và nội dung...</li> </ul>  <p><strong>Đặc điểm.</strong><br  /> Các đặc điểm cơ bản của CMS bao gồm:</p>  <ul> 	<li>Phê chuẩn việc tạo hoặc thay đổi nội dung trực tuyến</li> 	<li>Chế độ Soạn thảo &quot;Nhìn là biết&quot; WYSIWYG</li> 	<li>Quản lý người dùng</li> 	<li>Tìm kiếm và lập chỉ mục</li> 	<li>Lưu trữ</li> 	<li>Tùy biến giao diện</li> 	<li>Quản lý ảnh và các liên kết (URL)</li> </ul> </blockquote>  <p><br  /> NukeViet CMS là một <strong>hệ quản trị nội dung</strong> (<em>Content Management System - CMS</em>) cho phép bạn quản lý các cổng thông tin điện tử trên Internet. Nói đơn giản, NukeViet giống như một phần mềm giúp bạn<strong> xây dựng</strong> và <strong>vận hành</strong> các trang web của mình một cách dễ dàng nhất.</p>  <p>NukeViet CMS là một phần mềm <strong>mã nguồn mở</strong>, do đó việc sử dụng <strong>hoàn toàn miễn phí</strong>, bạn có thể tải NukeViet CMS về bất cứ lúc nào tại website chính thức của NukeViet là <strong><a href=\"https://nukeviet.vn\">nukeviet.vn</a></strong>. Bạn có thể cài NukeViet lên hosting để sử dụng hoặc cũng có thể thử nghiệm bằng cách cài ngay lên máy tính cá nhân.</p>  <p>NukeViet cho phép xây dựng một website động, đa chức năng, hiện đại một cách nhanh chóng mà người vận hành nó thậm chí <strong>không cần phải biết một tí gì về lập trình</strong> bởi tất cả các tác vụ quản lý phức tạp đều được tự động hóa ở mức cao. NukeViet đặc biệt dễ dàng sử dụng vì hoàn toàn bằng tiếng Việt và được thiết kế phù hợp nhất với thói quen sử dụng mạng của <strong>người Việt Nam</strong>.</p>  <p>Bằng việc sử dụng các công nghệ web mới nhất hiện nay, thiết kế hệ thống uyển chuyển và sở hữu những tính năng độc đáo, NukeViet sẽ giúp bạn triển khai các ứng dụng web từ nhỏ đến lớn một cách nhanh chóng và tiết kiệm: từ các website cá nhân cho tới các cổng thông tin điện tử; từ các gian hàng trực tuyến cho tới các mạng xã hội...</p> NukeViet là CMS <strong>mã nguồn mở đầu tiên của Việt Nam</strong> có quá trình phát triển lâu dài nhất, có lượng người sử dụng đông nhất. Hiện NukeViet cũng là một trong những mã nguồn mở chuyên nghiệp đầu tiên của Việt Nam, cơ quan chủ quản của NukeViet là <a href=\"https://vinades.vn\" target=\"_blank\">VINADES.,JSC</a> - đơn vị chịu trách nhiệm phát triển NukeViet và triển khai NukeViet thành các ứng dụng cụ thể cho doanh nghiệp.', '', 0, '4', '', 2, 1, 1742685231, 1742685231, 1, 0, 0),
(3, 'Logo và tên gọi NukeViet', 'logo-va-ten-goi-nukeviet', '', '', 0, '', '<p><span style=\"color: rgb(255, 0, 0);\"><span style=\"font-size: 14px;\"><strong>Tên gọi:</strong></span></span><br  /> <strong>NukeViet </strong>phát âm là <strong>&#91;Nu-Ke-Việt</strong>&#93;, đây là cách đọc riêng, không phải là cách phát âm chuẩn của tiếng Anh.<br  /> <br  /> <strong>Ý nghĩa:</strong><br  /> NukeViet là từ ghép từ chữ <strong>Nuke </strong>và <strong>Việt Nam</strong>.<br  /> <br  /> Sở dĩ có tên gọi này là vì phiên bản 1.0 và 2.0 của NukeViet được phát triển từ mã nguồn mở<strong> PHP-Nuke</strong>.</p>  <p>Mặc dù từ phiên bản 3.0, NukeViet được viết mới hoàn toàn và trong quá trình phát triển của mình, nhiều cái tên đã được đưa ra để thay thế nhưng cuối cùng cái tên NukeViet đã được giữ lại để nhớ rằng <strong>NukeViet </strong>được khởi đầu từ <strong>PHP-Nuke</strong> và để cảm ơn <strong>Franscisco Burzi</strong> - Tác giả PHP-Nuke - vì chính ông là nhân tố để có một cộng đồng mã nguồn mở NukeViet với hàng chục ngàn người dùng như hiện nay.</p>  <p><strong>Nuke</strong> trong tiếng Anh (từ lóng) có nghĩa là &quot;<strong>vũ khí hạt nhân</strong>&quot; (nuclear weapons). Xem: <a href=\"http://vi.wiktionary.org/wiki/nuke\" target=\"_blank\">http://vi.wiktionary.org/wiki/nuke</a></p>  <p>Đội ngũ phát triển cũng hy vọng rằng <strong>NukeViet </strong>sẽ phát triển bùng nổ như đúng tên gọi của nó.</p>  <p><span style=\"color: rgb(255, 0, 0);\"><span style=\"font-size: 14px;\"><strong>Logo NukeViet 3.0:</strong></span></span><br  /> Sau thời gian dài lựa chọn từ hàng chục mẫu thiết kế của thành viên diễn đàn NukeViet.VN và các nhà thiết kế đồ họa chuyên nghiệp... logo chính thức của NukeViet 3.0 đã được Ban Quản Trị chọn lựa đúng trước ngày Offline phát hành bản NukeViet 3.0 một ngày.<br  /> <br  /> Logo NukeViet 3.0 được lấy hình tượng từ Biển, Đêm, và Ánh Trăng trong khung hình giọt nước:</p>  <p style=\"text-align:center\"><img alt=\"w\" height=\"143\" src=\"/uploads/about/w.png\" style=\"width: 288px; height: 143px; border-width: 0px; border-style: solid;\" width=\"288\" /></p>  <p>Dưới nền trắng, cả logo nhìn như cảnh biển đêm huyền ảo, tĩnh mịch với mặt nước biển, bầu trời, thuyền buồm và ánh trăng. Đây là những hình ảnh biểu tượng cho sự thanh bình mà bất cứ ai cũng mong ước được thấy khi ngắm biển về đêm.<br  /> <br  /> Màu xanh thẫm là màu hòa quyện của của mặt biển, bầu trời về đêm, màu này cũng gần với màu xanh tượng trưng cho hòa bình.<br  /> Hai vệt khuyết chính là ánh trăng sáng màu bạc phản chiếu lên giọt nước.<br  /> <br  /> Giọt nước còn là biểu tượng cho sự sống, cho khát khao bất diệt của vạn vật trên trái đất này.<br  /> <br  /> <strong>Thông số chuẩn của màu logo:</strong><br  /> -&nbsp;&nbsp;&nbsp; Màu xanh: C80, M60, Y0, K0<br  /> <br  /> <strong>Tác giả mẫu thiết kế:</strong> Lê Thanh Xuân, chuyên viên thiết kế đồ họa của VINADES.,JSC</p>  <p><span style=\"color: rgb(255, 0, 0);\"><span style=\"font-size: 14px;\"><strong>Slogan NukeViet 3.0:</strong></span></span> “Chia sẻ thành công, kết nối đam mê”, Tiếng Anh: “Sharing success, connect passions”</p>  <p>Slogan này của tác giả HoaiNamDr, đây là slogan đã đoạt giải trong cuộc thi sáng tác slogan trên diễn đàn NukeViet.VN</p>  <div style=\"text-align:center\"><img alt=\"nukevietcms 180x84\" height=\"84\" src=\"/uploads/about/nukevietcms-180x84.png\" width=\"180\" /></div>  <p style=\"text-align: center;\">Mẫu phối Logo, slogan và tên NukeViet CMS (180x84px)<br  /> Tải về mẫu kích thước lớn <a href=\"/uploads/about/nukevietcms.png\">logo-nukeviet-cms.png</a> (1500x700px)</p>  <div style=\"text-align:center\"><img alt=\"nukevietcms mu noel 180x84\" height=\"84\" src=\"/uploads/about/nukevietcms_mu_noel_180x84.png\" width=\"180\" /></div>  <p style=\"text-align: center;\">Mẫu phối Logo, slogan và tên NukeViet CMS với chiếc mũ ông già Noel (184x84px)<br  /> &nbsp;</p>  <div style=\"text-align:center\"><img alt=\"logo nukeviet3 flag 180x75\" height=\"75\" src=\"/uploads/about/logo-nukeviet3-flag-180x75.png\" width=\"180\" /></div>  <p style=\"text-align: center;\">Mẫu phối Logo, slogan và tên NukeViet CMS cắm cờ Việt Nam (180x75px)<br  /> &nbsp;</p>  <div style=\"text-align:center\"><img alt=\"nukevietcms laco 180x57\" height=\"57\" src=\"/uploads/about/nukevietcms_laco_180x57.png\" width=\"180\" /></div>  <p style=\"text-align: center;\">Mẫu phối Logo, slogan và tên NukeViet CMS với chiếc ruy băng cờ Việt Nam (180x57px)</p>  <div style=\"text-align:center\"><img alt=\"nukevietvn 180x84\" height=\"84\" src=\"/uploads/about/nukevietvn_180x84.png\" width=\"180\" /></div>  <p style=\"text-align: center;\">Mẫu phối Logo, slogan và tên NukeViet.VN (180x84px)<br  /> Tải về mẫu kích thước lớn <a href=\"/uploads/about/nukevietvn.png\">logo-nukeviet-big.png</a> (1500x700px)</p>  <p><br  /> <strong>Tải về file đồ họa gốc:</strong><br  /> - <a href=\"https://nukeviet.vn/vi/download/Tai-lieu/NukeViet-logo/\">NukeViet logo</a> - hình ảnh gốc có độ phân giải cao, bao gồm cả font chữ, có thể sử dụng cho in ấn sticker, in logo lên áo hoặc in Backdrop, Standy khổ lớn.</p>', '', 0, '4', '', 3, 1, 1742685231, 1742685231, 1, 0, 0),
(4, 'Giấy phép sử dụng NukeViet', 'giay-phep-su-dung-nukeviet', '', '', 0, 'Giấy phép công cộng GNU (tiếng Anh: GNU General Public License, viết tắt GNU GPL hay chỉ GPL) là giấy phép phần mềm tự do được sử dụng để phân phối mã nguồn mở NukeViet.', '<p><strong>Bản dịch tiếng Việt của Giấy phép Công cộng GNU</strong></p>\r\n\r\n<p>Người dịch&nbsp;<a href=\"mailto:dangtuan@vietkey.net\">Đặng Minh Tuấn &lt;dangtuan@vietkey.net&gt;</a></p>\r\n\r\n<p>Đây là bản dịch tiếng Việt không chính thức của Giấy phép Công cộng GNU. Bản dịch này không phải do Tổ chức Phần mềm Tự do ấn hành, và nó không quy định về mặt pháp lý các điều khoản cho các phần mềm sử dụng giấy phép GNU GPL -- chỉ có bản tiếng Anh gốc của GNU GPL mới có tính pháp lý. Tuy nhiên, chúng tôi hy vọng rằng bản dịch này sẽ giúp cho những người nói tiếng Việt hiểu rõ hơn về GNU GPL.</p>\r\n\r\n<p>This is an unofficial translation of the GNU General Public License into Vietnamese. It was not published by the Free Software Foundation, and does not legally state the distribution terms for software that uses the GNU GPL--only the original English text of the GNU GPL does that. However, we hope that this translation will help Vietnamese speakers understand the GNU GPL better.</p>\r\n\r\n<hr  />\r\n<h3>GIẤY PHÉP CÔNG CỘNG GNU (GPL)</h3>\r\nGiấy phép công cộng GNU<br />\r\nPhiên bản 2, tháng 6/1991<br />\r\nCopyright (C) 1989, 1991 Free Software Foundation, Inc. &nbsp;<br />\r\n59 Temple Place - Suite 330, Boston, MA&nbsp; 02111-1307, USA\r\n<p>Mọi người đều được phép sao chép và lưu hành bản sao nguyên bản nhưng không được phép thay đổi nội dung của giấy phép này.<br />\r\n<br />\r\n<strong>Lời nói đầu</strong><br />\r\n<br />\r\nGiấy phép sử dụng của hầu hết các phần mềm đều được đưa ra nhằm hạn chế bạn tự do chia sẻ và thay đổi nó. Ngược lại, Giấy phép Công cộng của GNU có mục đích đảm bảo cho bạn có thể tự do chia sẻ và thay đổi phần mềm tự do - tức là đảm bảo rằng phần mềm đó là tự do đối với mọi người sử dụng. Giấy phép Công cộng này áp dụng cho hầu hết các phần mềm của Tổ chức Phần mềm Tự do và cho tất cả các chương trình khác mà tác giả cho phép sử dụng. (Đối với một số phần mềm khác của Tổ chức Phần Mềm Tự do, áp dụng Giấy phép Công cộng Hạn chế của GNU thay cho giấy phép công cộng). Bạn cũng có thể áp dụng nó cho các chương trình của mình.<br />\r\n<br />\r\nKhi nói đến phần mềm tự do, chúng ta nói đến sự tự do sử dụng chứ không quan tâm về giá cả. Giấy phép Công cộng của chúng tôi được thiết kế để đảm bảo rằng bạn hoàn toàn tự do cung cấp các bản sao của phần mềm tự do (cũng như kinh doanh dịch vụ này nếu bạn muốn), rằng bạn có thể nhận được mã nguồn nếu bạn có yêu cầu, rằng bạn có thể thay đổi phần mềm hoặc sử dụng các thành phần của phần mềm đó cho những chương trình tự do mới; và rằng bạn biết chắc là bạn có thể làm được những điều này.<br />\r\n<br />\r\nĐể bảo vệ bản quyền của bạn, chúng tôi cần đưa ra những hạn chế để ngăn chặn những ai chối bỏ quyền của bạn, hoặc yêu cầu bạn chối bỏ quyền của mình. Những hạn chế này cũng có nghĩa là những trách nhiệm nhất định của bạn khi cung cấp các bản sao phần mềm hoặc khi chỉnh sửa phần mềm đó.<br />\r\n<br />\r\nVí dụ, nếu bạn cung cấp các bản sao của một chương trình, dù miễn phí hay không, bạn phải cho người nhận tất cả các quyền mà bạn có. Bạn cũng phải đảm bảo rằng họ cũng nhận được hoặc tiếp cận được mã nguồn. Và bạn phải thông báo những điều khoản này cho họ để họ biết rõ về quyền của mình.<br />\r\n<br />\r\nChúng tôi bảo vệ quyền của bạn với hai bước: (1) bảo vệ bản quyền phần mềm, và (2) cung cấp giấy phép này để bạn có thể sao chép, lưu hành và/hoặc chỉnh sửa phần mềm một cách hợp pháp.<br />\r\n<br />\r\nNgoài ra, để bảo vệ các tác giả cũng như để bảo vệ chính mình, chúng tôi muốn chắc chắn rằng tất cả mọi người đều hiểu rõ rằng không hề có bảo hành đối với phần mềm tự do này. Nếu phần mềm được chỉnh sửa thay đổi bởi một người khác và sau đó lưu hành, thì chúng tôi muốn những người sử dụng biết rằng phiên bản họ đang có không phải là bản gốc, do đó tất cả những trục trặc do những người khác gây ra hoàn toàn không ảnh hưởng tới uy tín của tác giả ban đầu.<br />\r\n<br />\r\nCuối cùng, bất kỳ một chương trình tự do nào cũng đều thường xuyên có nguy cơ bị đe doạ về giấy phép bản quyền. Chúng tôi muốn tránh nguy cơ khi những người cung cấp lại một chương trình tự do có thể có được giấy phép bản quyền cho bản thân họ, từ đó trở thành độc quyền đối với chương trình đó. Để ngăn ngừa trường hợp này, chúng tôi đã nêu rõ rằng mỗi giấy phép bản quyền hoặc phải được cấp cho tất cả mọi người sử dụng một cách tự do hoặc hoàn toàn không cấp phép.<br />\r\n<br />\r\nDưới đây là những điều khoản và điều kiện rõ ràng đối với việc sao chép, lưu hành và chỉnh sửa.<br />\r\n<br />\r\n<strong>Những điều khoản và điều kiện đối với việc sao chép, lưu hành và chỉnh sửa</strong><br />\r\n<br />\r\n<strong>0.</strong>&nbsp;Giấy phép này áp dụng cho bất kỳ một chương trình hay sản phẩm nào mà người giữ bản quyền công bố rằng nó có thể được cung cấp trong khuôn khổ những điều khoản của Giấy phép Công cộng này. Từ “Chương trình” dưới đây có nghĩa là tất cả các chương trình hay sản phẩm như vậy, và “sản phẩm dựa trên Chương trình” có nghĩa là Chương trình hoặc bất kỳ một sản phẩm nào bắt nguồn từ chương trình đó tuân theo luật bản quyền, nghĩa là một sản phẩm dựa trên Chương trình hoặc một phần của nó, đúng nguyên bản hoặc có một số chỉnh sửa và/hoặc được dịch ra một ngôn ngữ khác. (Dưới đây, việc dịch cũng được hiểu trong khái niệm “chỉnh sửa”). Mỗi người được cấp phép được gọi là “bạn”.<br />\r\n<br />\r\nTrong Giấy phép này không đề cập tới các hoạt động khác ngoài việc sao chép, lưu hành và chỉnh sửa; chúng nằm ngoài phạm vi của giấy phép này. Hành động chạy chương trình không bị hạn chế, và những kết quả từ việc chạy chương trình chỉ được đề cập tới nếu nội dung của nó tạo thành một sản phẩm dựa trên chương trình (độc lập với việc chạy chương trình). Điều này đúng hay không là phụ thuộc vào Chương trình.<br />\r\n<br />\r\n<strong>1.</strong>&nbsp;Bạn có thể sao chép và lưu hành những phiên bản nguyên bản của mã nguồn Chương trình đúng như khi bạn nhận được, qua bất kỳ phương tiện phân phối nào, với điều kiện trên mỗi bản sao bạn đều kèm theo một ghi chú bản quyền rõ ràng và từ chối bảo hành; giữ nguyên tất cả các ghi chú về Giấy phép và về việc không có bất kỳ một sự bảo hành nào; và cùng với Chương trình bạn cung cấp cho người sử dụng một bản sao của Giấy phép này.<br />\r\n<br />\r\nBạn có thể tính phí cho việc chuyển giao bản sao, và tuỳ theo quyết định của mình bạn có thể cung cấp bảo hành để đổi lại với chi phí mà bạn đã tính.<br />\r\n<br />\r\n<strong>2.</strong>&nbsp;Bạn có thể chỉnh sửa bản sao của bạn hoặc các bản sao của Chương trình hoặc của bất kỳ phần nào của nó, từ đó hình thành một sản phẩm dựa trên Chương trình, và sao chép cũng như lưu hành sản phẩm đó hoặc những chỉnh sửa đó theo điều khoản trong Mục 1 ở trên, với điều kiện bạn đáp ứng được những điều kiện dưới đây:<br />\r\n•&nbsp;&nbsp; &nbsp;a) Bạn phải có ghi chú rõ ràng trong những tập tin đã chỉnh sửa là bạn đã chỉnh sửa nó, và ngày tháng của bất kỳ một thay đổi nào.<br />\r\n•&nbsp;&nbsp; &nbsp;b) Bạn phải cấp phép miễn phí cho tất cả các bên thứ ba đối với các sản phẩm bạn cung cấp hoặc phát hành, bao gồm Chương trình nguyên bản, từng phần của nó hay các sản phẩm dựa trên Chương trình hay dựa trên từng phần của Chương trình, theo những điều khoản của Giấy phép này.<br />\r\n•&nbsp;&nbsp; &nbsp;c) Nếu chương trình đã chỉnh sửa thường đọc lệnh tương tác trong khi chạy, bạn phải thực hiện sao cho khi bắt đầu chạy để sử dụng tương tác theo cách thông thường nhất phải có một thông báo bao gồm bản quyền và thông báo về việc không có bảo hành (hoặc thông báo bạn là người cung cấp bảo hành), và rằng người sử dụng có thể cung cấp lại Chương trình theo những điều kiện này, và thông báo để người sử dụng có thể xem bản sao của Giấy phép này. (Ngoại lệ: nếu bản thân Chương trình là tương tác nhưng không có một thông báo nào như trên, thì sản phẩm của bạn dựa trên Chương trình đó cũng không bắt buộc phải có thông báo như vậy).<br />\r\n<br />\r\nNhững yêu cầu trên áp dụng cho toàn bộ các sản phẩm chỉnh sửa. Nếu có những phần của sản phẩm rõ ràng không bắt nguồn từ Chương trình, và có thể được xem là độc lập và riêng biệt, thì Giấy phép này và các điều khoản của nó sẽ không áp dụng cho những phần đó khi bạn cung cấp chúng như những sản phẩm riêng biệt. Nhưng khi bạn cung cấp những phần đó như những phần nhỏ trong cả một sản phẩm dựa trên Chương trình, thì việc cung cấp này phải tuân theo những điều khoản của Giấy phép này, cho phép những người được cấp phép có quyền đối với toàn bộ sản phẩm, cũng như đối với từng phần trong đó, bất kể ai đã viết nó.<br />\r\n<br />\r\nNhư vậy, điều khoản này không nhằm mục đích xác nhận quyền hoặc tranh giành quyền của bạn đối với những sản phẩm hoàn toàn do bạn viết; mà mục đích của nó là nhằm thi hành quyền kiểm soát đối với việc cung cấp những sản phẩm bắt nguồn hoặc tổng hợp dựa trên Chương trình.<br />\r\n<br />\r\nNgoài ra, việc kết hợp thuần tuý Chương trình (hoặc một sản phẩm dựa trên Chương trình) với một sản phẩm không dựa trên Chương trình với mục đích lưu trữ hoặc quảng bá không đưa sản phẩm đó vào trong phạm vi áp dụng của Giấy phép này.<br />\r\n<br />\r\n<strong>3.</strong>&nbsp;Bạn có thể sao chép và cung cấp Chương trình (hoặc một sản phẩm dựa trên Chương trình, nêu trong Mục 2) dưới hình thức mã đã biên dịch hoặc dạng có thể thực thi được trong khuôn khổ các điều khoản nêu trong Mục 1 và 2 ở trên, nếu như bạn:<br />\r\n•&nbsp;&nbsp; &nbsp;a) Kèm theo đó một bản mã nguồn dạng đầy đủ có thể biên dịch được theo các điều khoản trong Mục 1 và 2 nêu trên trong một môi trường trao đổi phần mềm thông thường; hoặc,<br />\r\n•&nbsp;&nbsp; &nbsp;b) Kèm theo đó một đề nghị có hạn trong ít nhất 3 năm, theo đó cung cấp cho bất kỳ một bên thứ ba nào một bản sao đầy đủ của mã nguồn tương ứng, và phải được cung cấp với giá chi phí không cao hơn giá chi phí vật lý của việc cung cấp theo các điều khoản trong Mục 1 và 2 nêu trên trong một môi trường trao đổi phần mềm thông thường; hoặc<br />\r\n•&nbsp;&nbsp; &nbsp;c) Kèm theo đó thông tin bạn đã nhận được để đề nghị cung cấp mã nguồn tương ứng. (Phương án này chỉ được phép đối với việc cung cấp phi thương mại và chỉ với điều kiện nếu bạn nhận được Chương trình dưới hình thức mã đã biên dịch hoặc dạng có thể thực thi được cùng với lời đề nghị như vậy, theo phần b trong điều khoản nêu trên).<br />\r\n<br />\r\nMã nguồn của một sản phẩm là một dạng ưu tiên của sản phẩm dành cho việc chỉnh sửa nó. Với một sản phẩm có thể thi hành, mã nguồn hoàn chỉnh có nghĩa là tất cả các mã nguồn cho các môđun trong sản phẩm đó, cộng với tất cả các tệp tin định nghĩa giao diện đi kèm với nó, cộng với các hướng dẫn dùng để kiểm soát việc biên dịch và cài đặt các tệp thi hành. Tuy nhiên, một ngoại lệ đặc biệt là mã nguồn không cần chứa bất kỳ một thứ gì mà bình thường được cung cấp (từ nguồn khác hoặc hình thức nhị phân) cùng với những thành phần chính (chương trình biên dịch, nhân, và những phần tương tự) của hệ điều hành mà các chương trình chạy trong đó, trừ khi bản thân thành phần đó lại đi kèm với một tệp thi hành.<br />\r\n<br />\r\nNếu việc cung cấp lưu hành mã đã biên dịch hoặc tập tin thi hành được thực hiện qua việc cho phép tiếp cận và sao chép từ một địa điểm được chỉ định, thì việc cho phép tiếp cận tương đương tới việc sao chép mã nguồn từ cùng địa điểm cũng được tính như việc cung cấp mã nguồn, mặc dù thậm chí các bên thứ ba không bị buộc phải sao chép mã nguồn cùng với mã đã biên dịch.<br />\r\n<br />\r\n<strong>4.</strong>&nbsp;Bạn không được phép sao chép, chỉnh sửa, cấp phép hoặc cung cấp Chương trình trừ phi phải tuân thủ một cách chính xác các điều khoản trong Giấy phép. Bất kỳ ý định sao chép, chỉnh sửa, cấp phép hoặc cung cấp Chương trình theo cách khác đều làm mất hiệu lực và tự động huỷ bỏ quyền của bạn trong khuôn khổ Giấy phép này. Tuy nhiên, các bên đã nhận được bản sao hoặc quyền từ bạn với Giấy phép này sẽ không bị huỷ bỏ giấy phép nếu các bên đó vẫn tuân thủ đầy đủ các điều khoản của giấy phép.<br />\r\n<br />\r\n<strong>5.</strong>&nbsp;Bạn không bắt buộc phải chấp nhận Giấy phép này khi bạn chưa ký vào đó. Tuy nhiên, không có gì khác đảm bảo cho bạn được phép chỉnh sửa hoặc cung cấp Chương trình hoặc các sản phẩm bắt nguồn từ Chương trình. Những hành động này bị luật pháp nghiêm cấm nếu bạn không chấp nhận Giấy phép này. Do vậy, bằng việc chỉnh sửa hoặc cung cấp Chương trình (hoặc bất kỳ một sản phẩm nào dựa trên Chương trình), bạn đã thể hiện sự chấp thuận đối với Giấy phép này, cùng với tất cả các điều khoản và điều kiện đối với việc sao chép, cung cấp hoặc chỉnh sửa Chương trình hoặc các sản phẩm dựa trên nó.<br />\r\n<br />\r\n<strong>6.</strong> Mỗi khi bạn cung cấp lại Chương trình (hoặc bất kỳ một sản phẩm nào dựa trên Chương trình), người nhận sẽ tự động nhận được giấy phép từ người cấp phép đầu tiên cho phép sao chép, cung cấp và chỉnh sửa Chương trình theo các điều khoản và điều kiện này. Bạn không thể áp đặt bất cứ hạn chế nào khác đối với việc thực hiện quyền của người nhận đã được cấp phép từ thời điểm đó. Bạn cũng không phải chịu trách nhiệm bắt buộc các bên thứ ba tuân thủ theo Giấy phép này.<br />\r\n<br />\r\n<strong>7.</strong>&nbsp;Nếu như, theo quyết định của toà án hoặc với những bằng chứng về việc vi phạm bản quyền hoặc vì bất kỳ lý do nào khác (không giới hạn trong các vấn đề về bản quyền), mà bạn phải tuân theo các điều kiện (nêu ra trong lệnh của toà án, biên bản thoả thuận hoặc ở nơi khác) trái với các điều kiện của Giấy phép này, thì chúng cũng không thể miễn cho bạn khỏi những điều kiện của Giấy phép này. Nếu bạn không thể đồng thời thực hiện các nghĩa vụ của mình trong khuôn khổ Giấy phép này và các nghĩa vụ thích đáng khác, thì hậu quả là bạn hoàn toàn không được cung cấp Chương trình. Ví dụ, nếu trong giấy phép bản quyền không cho phép những người nhận được bản sao trực tiếp hoặc gián tiếp qua bạn có thể cung cấp lại Chương trình thì trong trường hợp này cách duy nhất bạn có thể thoả mãn cả hai điều kiện là hoàn toàn không cung cấp Chương trình.<br />\r\n<br />\r\nNếu bất kỳ một phần nào trong điều khoản này không có hiệu lực hoặc không thể thi hành trong một hoàn cảnh cụ thể, thì sẽ cân đối áp dụng các điều khoản, và toàn bộ điều khoản sẽ được áp dụng trong những hoàn cảnh khác.<br />\r\n<br />\r\nMục đích của điều khoản này không nhằm buộc bạn phải vi phạm bất kỳ một bản quyền nào hoặc các quyền sở hữu khác hoặc tranh luận về giá trị hiệu lực của bất kỳ quyền hạn nào như vậy; mục đích duy nhất của điều khoản này là nhằm bảo vệ sự toàn vẹn của hệ thống cung cấp phần mềm tự do đang được thực hiện với giấy phép công cộng. Nhiều người đã đóng góp rất nhiều vào sự đa dạng của các phần mềm tự do được cung cấp thông qua hệ thống này với sự tin tưởng rằng hệ thống được sử dụng một cách thống nhất; tác giả/người cung cấp có quyền quyết định rằng họ có mong muốn cung cấp phần mềm thông qua hệ thống nào khác hay không, và người được cấp phép không thể có ảnh hưởng tới sự lựa chọn này.<br />\r\n<br />\r\nĐiều khoản này nhằm làm rõ những hệ quả của các phần còn lại của Giấy phép này.<br />\r\n<br />\r\n<strong>8.</strong>&nbsp;Nếu việc cung cấp và/hoặc sử dụng Chương trình bị cấm ở một số nước nhất định bởi quy định về bản quyền, người giữ bản quyền gốc đã đưa Chương trình vào dưới Giấy phép này có thể bổ sung một điều khoản hạn chế việc cung cấp ở những nước đó, nghĩa là việc cung cấp chỉ được phép ở các nước không bị liệt kê trong danh sách hạn chế. Trong trường hợp này, Giấy phép đưa vào những hạn chế được ghi trong nội dung của nó.<br />\r\n<br />\r\n<strong>9.&nbsp;</strong>Tổ chức Phần mềm Tự do có thể theo thời gian công bố những phiên bản chỉnh sửa và/hoặc phiên bản mới của Giấy phép Công cộng. Những phiên bản đó sẽ đồng nhất với tinh thần của phiên bản hiện này, nhưng có thể khác ở một số chi tiết nhằm giải quyết những vấn đề hay những lo ngại mới.<br />\r\n<br />\r\nMỗi phiên bản sẽ có một mã số phiên bản riêng. Nếu Chương trình và &quot;bất kỳ một phiên bản nào sau đó&quot; có áp dụng một phiên bản Giấy phép cụ thể, bạn có quyền lựa chọn tuân theo những điều khoản và điều kiện của phiên bản giấy phép đó hoặc của bất kỳ một phiên bản nào sau đó do Tổ chức Phần mềm Tự do công bố. Nếu Chương trình không nêu cụ thể mã số phiên bản giấy phép, bạn có thể lựa chọn bất kỳ một phiên bản nào đã từng được công bố bởi Tổ chức Phần mềm Tự do.<br />\r\n<br />\r\n<strong>10.</strong>&nbsp;Nếu bạn muốn kết hợp các phần của Chương trình vào các chương trình tự do khác mà điều kiện cung cấp khác với chương trình này, hãy viết cho tác giả để được phép. Đối với các phần mềm được cấp bản quyền bởi Tổ chức Phầm mềm Tự do, hãy đề xuất với tổ chức này; đôi khi chúng tôi cũng có những ngoại lệ. Quyết định của chúng tôi sẽ dựa trên hai mục tiêu là bảo hộ tình trạng tự do của tất cả các sản phẩm bắt nguồn từ phần mềm tự do của chúng tôi, và thúc đẩy việc chia sẻ và tái sử dụng phần mềm nói chung.<br />\r\n<br />\r\n<strong>KHÔNG BẢO HÀNH</strong><br />\r\nDO CHƯƠNG TRÌNH ĐƯỢC CẤP PHÉP MIỄN PHÍ NÊN KHÔNG CÓ MỘT CHẾ ĐỘ BẢO HÀNH NÀO TRONG MỨC ĐỘ CHO PHÉP CỦA LUẬT PHÁP. TRỪ KHI ĐƯỢC CÔNG BỐ KHÁC ĐI BẰNG VĂN BẢN, NHỮNG NGƯỜI GIỮ BẢN QUYỀN VÀ/HOẶC CÁC BÊN CUNG CẤP CHƯƠNG TRÌNH NGUYÊN BẢN SẼ KHÔNG BẢO HÀNH DƯỚI BẤT KỲ HÌNH THỨC NÀO, BAO GỒM NHƯNG KHÔNG GIỚI HẠN TRONG CÁC HÌNH THỨC BẢO HÀNH ĐỐI VỚI TÍNH THƯƠNG MẠI CŨNG NHƯ TÍNH THÍCH HỢP CHO MỘT MỤC ĐÍCH CỤ THỂ. BẠN LÀ NGƯỜI CHỊU TOÀN BỘ RỦI RO VỀ CHẤT LƯỢNG CŨNG NHƯ VIỆC VẬN HÀNH CHƯƠNG TRÌNH. TRONG TRƯỜNG HỢP CHƯƠNG TRÌNH CÓ KHIẾM KHUYẾT, BẠN PHẢI CHỊU TOÀN BỘ CHI PHÍ CHO NHỮNG DỊCH VỤ SỬA CHỮA CẦN THIẾT.<br />\r\n<br />\r\nTRONG TẤT CẢ CÁC TRƯỜNG HỢP TRỪ KHI CÓ YÊU CẦU CỦA LUẬT PHÁP HOẶC CÓ THOẢ THUẬN BẰNG VĂN BẢN, NHỮNG NGƯỜI CÓ BẢN QUYỀN HOẶC BẤT KỲ MỘT BÊN NÀO CHỈNH SỬA VÀ/HOẶC CUNG CẤP LẠI CHƯƠNG TRÌNH TRONG CÁC ĐIỀU KIỆN NHƯ ĐÃ NÊU TRÊN ĐỀU KHÔNG CÓ TRÁCH NHIỆM VỚI BẠN VỀ CÁC LỖI HỎNG HÓC, BAO GỒM CÁC LỖI CHUNG HAY ĐẶC BIỆT, NGẪU NHIÊN HAY TẤT YẾU NẢY SINH DO VIỆC SỬ DỤNG HOẶC KHÔNG SỬ DỤNG ĐƯỢC CHƯƠNG TRÌNH (BAO GỒM NHƯNG KHÔNG GIỚI HẠN TRONG VIỆC MẤT DỮ LIỆU, DỮ LIỆU THIẾU CHÍNH XÁC HOẶC CHƯƠNG TRÌNH KHÔNG VẬN HÀNH ĐƯỢC VỚI CÁC CHƯƠNG TRÌNH KHÁC), THẬM CHÍ CẢ KHI NGƯỜI CÓ BẢN QUYỀN VÀ CÁC BÊN KHÁC ĐÃ ĐƯỢC THÔNG BÁO VỀ KHẢ NĂNG XẢY RA NHỮNG THIỆT HẠI ĐÓ.<br />\r\n<br />\r\n<strong>KẾT THÚC CÁC ĐIỀU KIỆN VÀ ĐIỀU KHOẢN.</strong></p>\r\n\r\n<p><strong>Áp dụng những điều khoản trên như thế nào đối với chương trình của bạn</strong><br />\r\n<br />\r\nNếu bạn xây dựng một chương trình mới, và bạn muốn cung cấp một cách tối đa cho công chúng sử dụng, thì biện pháp tốt nhất để đạt được điều này là phát triển chương trình đó thành phần mềm tự do để ai cũng có thể cung cấp lại và thay đổi theo những điều khoản như trên.<br />\r\n<br />\r\nĐể làm được việc này, hãy đính kèm những thông báo như sau cùng với chương trình của mình. An toàn nhất là đính kèm chúng trong phần đầu của tập tin mã nguồn để thông báo một cách hiệu quả nhất về việc không có bảo hành; và mỗi tệp tin đều phải có ít nhất một dòng về “bản quyền” và trỏ đến toàn bộ thông báo.</p>\r\n\r\n<blockquote>\r\n<p>&nbsp; &nbsp; &nbsp; &nbsp; <strong>Một dòng đề tên chương trình và nội dung của nó.<br />\r\n&nbsp; &nbsp; &nbsp; &nbsp; Bản quyền (C) năm,&nbsp; tên tác giả.</strong><br />\r\n<br />\r\nChương trình này là phần mềm tự do, bạn có thể cung cấp lại và/hoặc chỉnh sửa nó theo những điều khoản của Giấy phép Công cộng của GNU do Tổ chức Phần mềm Tự do công bố; phiên bản 2 của Giấy phép, hoặc bất kỳ một phiên bản sau đó (tuỳ sự lựa chọn của bạn).<br />\r\n<br />\r\nChương trình này được cung cấp với hy vọng nó sẽ hữu ích, tuy nhiên KHÔNG CÓ BẤT KỲ MỘT BẢO HÀNH NÀO; thậm chí kể cả bảo hành về KHẢ NĂNG THƯƠNG MẠI hoặc TÍNH THÍCH HỢP CHO MỘT MỤC ĐÍCH CỤ THỂ. Xin xem Giấy phép Công cộng của GNU để biết thêm chi tiết.<br />\r\n<br />\r\nBạn phải nhận được một bản sao của Giấy phép Công cộng của GNU kèm theo chương trình này; nếu bạn chưa nhận được, xin gửi thư về Tổ chức Phần mềm Tự do, 59 Temple Place - Suite 330, Boston, MA&nbsp; 02111-1307, USA.<br />\r\n<br />\r\nXin hãy bổ sung thông tin về địa chỉ liên lạc của bạn (thư điện tử và bưu điện).</p>\r\n</blockquote>\r\n\r\n<p>Nếu chương trình chạy tương tác, hãy đưa một thông báo ngắn khi bắt đầu chạy chương trình như sau:</p>\r\n\r\n<blockquote>\r\n<p>Gnomovision phiên bản 69, Copyright (C) năm, tên tác giả.<br />\r\n<br />\r\nGnomovision HOÀN TOÀN KHÔNG CÓ BẢO HÀNH; để xem chi tiết hãy gõ `show w&#039;.&nbsp; Đây là một phần mềm miễn phí, bạn có thể cung cấp lại với những điều kiện nhất định, gõ ‘show c’ để xem chi tiết.<br />\r\nGiả thiết lệnh `show w&#039; và `show c&#039; cho xem những phần tương ứng trong Giấy phép Công cộng. Tất nhiên những lệnh mà bạn dùng có thể khác với ‘show w&#039; và `show c&#039;; những lệnh này có thể là nhấn chuột hoặc lệnh trong thanh công cụ - tuỳ theo chương trình của bạn.</p>\r\n</blockquote>\r\n\r\n<p>Bạn cũng cần phải lấy chữ ký của người phụ trách (nếu bạn là người lập trình) hoặc của trường học (nếu có) xác nhận từ chối bản quyền đối với chương trình. Sau đây là ví dụ:</p>\r\n\r\n<blockquote>\r\n<p>Yoyodyne, Inc., tại đây từ chối tất cả các quyền lợi bản quyền đối với chương trình `Gnomovision&#039; viết bởi James Hacker.<br />\r\n<br />\r\nchữ ký của Ty Coon, 1 April 1989<br />\r\nTy Coon, Phó Tổng Giám đốc.</p>\r\n</blockquote>\r\n\r\n<p>Giấy phép Công cộng này không cho phép đưa chương trình của bạn vào trong các chương trình độc quyền. Nếu chương trình của bạn là một thư viện thủ tục phụ, bạn có thể thấy nó hữu ích hơn nếu cho thư viện liên kết với các ứng dụng độc quyền. Nếu đây là việc bạn muốn làm, hãy sử dụng Giấy phép Công cộng Hạn chế của GNU thay cho Giấy phép này.</p>\r\n\r\n<hr  />\r\n<p><strong>Bản gốc của giấy phép bằng tiếng Anh có tại các địa chỉ sau:</strong></p>\r\n\r\n<ol>\r\n	<li>GNU General Public License, version 1, February 1989:&nbsp;<a href=\"http://www.gnu.org/licenses/old-licenses/gpl-1.0.txt\" target=\"_blank\">http://www.gnu.org/licenses/old-licenses/gpl-1.0.txt</a></li>\r\n	<li>GNU General Public License, version 2, June 1991:&nbsp;<a href=\"http://www.gnu.org/licenses/old-licenses/gpl-2.0.html\" target=\"_blank\">http://www.gnu.org/licenses/old-licenses/gpl-2.0.html</a></li>\r\n	<li>GNU General Public License, version 3, 29 June 2007:&nbsp;<a href=\"http://www.gnu.org/licenses/gpl-3.0.txt\" target=\"_blank\">http://www.gnu.org/licenses/gpl-3.0.txt</a></li>\r\n</ol>\r\n\r\n<p><strong>Tài liệu tham khảo:</strong></p>\r\n\r\n<ol>\r\n	<li>Bản dịch tiếng Việt của Giấy phép Công cộng GNU tại OpenOffice.org:&nbsp;<br />\r\n	<a href=\"http://vi.openoffice.org/gplv.html\" target=\"_blank\">http://vi.openoffice.org/gplv.html</a></li>\r\n	<li>GPL tại&nbsp;Văn thư lưu trữ mở Wikisource:&nbsp;<a href=\"http://vi.wikisource.org/wiki/GPL\" target=\"_blank\">http://vi.wikisource.org/wiki/GPL</a></li>\r\n</ol>\r\n\r\n<p><strong>Xem thêm:</strong></p>\r\n\r\n<ol>\r\n	<li>LGPL tại&nbsp;Văn thư lưu trữ mở Wikisource:&nbsp;<a href=\"http://vi.wikisource.org/wiki/LGPL\" target=\"_blank\">http://vi.wikisource.org/wiki/LGPL</a></li>\r\n	<li>Giấy phép Công cộng GNU - WikiPedia:&nbsp;<br />\r\n	<a href=\"http://vi.wikipedia.org/wiki/Gi%E1%BA%A5y_ph%C3%A9p_C%C3%B4ng_c%E1%BB%99ng_GNU\" target=\"_blank\">http://vi.wikipedia.org/wiki/Giấy_phép_Công_cộng_GNU</a></li>\r\n	<li>Thảo luận giấy phép GNU GPL - HVA:<br />\r\n	&nbsp;<a href=\"http://www.hvaonline.net/hvaonline/posts/list/7120.hva\" target=\"_blank\">http://www.hvaonline.net/hvaonline/posts/list/7120.hva</a></li>\r\n	<li>Thảo luận tại diễn đàn:&nbsp;<a href=\"https://nukeviet.vn/phpbb/viewtopic.php?f=83&amp;t=1591\" target=\"_blank\">https://nukeviet.vn/phpbb/viewtopic.php?f=83&amp;t=1591</a></li>\r\n</ol>', 'giấy phép,công cộng,tiếng anh,gnu general,public license,gnu gpl,phần mềm,là tự,sử dụng,mã nguồn,bản dịch,tiếng việt,của gnu,đây là,này không,do tổ,chức tự,hành và,các điều,cho các,có bản,tuy nhiên,chúng tôi,cho những,phiên bản,mọi người,được phép,sao chép,lưu hành,bản sao,nguyên bản,nhưng không,và thay,nội dung,của này,hạn chế,tự do,chia sẻ,nukeviet,portal,mysql,php,cms,mã nguồn mở,thiết kế website', 0, '4', '', 4, 1, 1742685231, 1742685231, 1, 0, 0);
INSERT INTO `nv5_vi_about` (`id`, `title`, `alias`, `image`, `imagealt`, `imageposition`, `description`, `bodytext`, `keywords`, `socialbutton`, `activecomm`, `layout_func`, `weight`, `admin_id`, `add_time`, `edit_time`, `status`, `hitstotal`, `hot_post`) VALUES
(5, 'Những tính năng của NukeViet CMS 4.0', 'nhung-tinh-nang-cua-nukeviet-cms-4-0', '', '', 0, '', '<p><span style=\"font-size: 150%; line-height: 116%;\"><span style=\"font-weight: bold;\">Giới thiệu chung</span></span><br  /> <span style=\"font-weight: bold;\">Mã nguồn mở NukeViet là sản phẩm của sự làm việc chuyên nghiệp: </span><br  /> Để xây dựng lên NukeViet 4, đội ngũ phát triển đã thành lập công ty VINADES.,JSC. Trong quá trình phát triển NukeViet 4, VINADES.,JSC đã hợp tác với nhiều đơn vị cung cấp hosting trong và ngoài nước để thử nghiệm host, đảm bảo tương thích với đa số các hosting chuyên nghiệp.<br  /> NukeViet 4 cũng được vận hành thử nghiệm, góp ý bởi nhiều webmaster có kinh nghiệm quản trị ở nhiều hệ thống khác nhau nhằm tối ưu các tính năng hệ thống cho người sử dụng.<br  /> NukeViet 4 được lập trình bởi các lập trình viên mà kinh nghiệm và tên tuổi của họ đã được xác lập cùng với tên tuổi của bộ mã nguồn mở tạo web đầu tiên của Việt Nam.<br  /> <br  /> <span style=\"font-weight: bold;\">NukeViet 4 là một hệ thống mạnh:</span><br  /> Rút kinh nghiệm từ chính NukeViet 2, NukeViet 3, NukeViet 4 được viết mới hoàn toàn trên nền tảng kỹ thuật tiên tiến nhất hiện nay cho phép xây dựng các nền tảng ứng dụng trực tuyến lớn như Các cổng thông tin điện tử, các tòa soạn báo điện tử, các mạng xã hội và các hệ thống thương mại trực tuyến.<br  /> NukeViet 4 đã được thử nghiệm vận hành với dữ liệu lớn lên tới hàng triệu bản tin. Trên thực tế, NukeViet 4 cũng đã triển khai thành công cho các hiệp hội, doanh nghiệp có lượng truy cập rất lớn.<br  /> <br  /> <span style=\"font-weight: bold;\">NukeViet 4 thích hợp cho mọi đối tượng:</span><br  /> NukeViet lấy người sử dụng làm trọng tâm, những tính năng của NukeViet tạo nên chuẩn mực trong việc sử dụng và quản trị. Vì thế, NukeViet 4 tốt cho cả người sử dụng lẫn người phát triển.<br  /> Với người sử dụng, NukeViet 4 cho phép tùy biến dễ dàng và sử dụng ngay mà không cần can thiệp vào hệ thống.<br  /> Với người phát triển, sử dụng NukeViet cho phép nhanh chóng xây dựng các nền tảng khác nhau nhờ việc viết thêm các module cho hệ thống thay vì phải tự mình viết cả một hệ thống.</p>  <p><span style=\"font-size: 150%; line-height: 116%;\"><span style=\"font-weight: bold;\">Các tính năng của NukeViet 4</span></span></p> <span style=\"font-weight: bold;\">Nền tảng công nghệ</span>  <ul> 	<li><span id=\"cke_bm_178S\" style=\"display: none;\">&nbsp;</span>NukeViet CMS 4 lập trình trên PHP 5.4 và MySQL 5, Sử dụng PDO để kết nối với MySQL (Sẵn sàng kết nối với các CSDL khác) cho phép vận dụng tối đa sức mạnh của công nghệ mới.</li> 	<li>Sử dụng Composer để quản lý các thư viện PHP được cài vào hệ thống.</li> 	<li>Từng bước áp dụng các tiêu chuẩn viết code PHP theo khuyến nghị của http://www.php-fig.org/psr/</li> 	<li>Ứng dụng Xtemplate và jQuery cho phép vận dụng Ajax uyển chuyển từ trong nhân hệ thống.</li> 	<li>Giai diện trong NukeViet 4 được làm mới, tương thích với nhiều màn hình hơn, Sử dụng thư viện bootstrap để việc phát triển giao diện thống nhất và dễ dàng hơn.</li> 	<li>Tận dụng các thành tựu mã nguồn mở có sẵn nhưng NukeViet 4 vẫn đảm bảo rằng từng dòng code là được code tay. Điều này có nghĩa là NukeViet 4 hoàn toàn không lệ thuộc vào bất cứ framework nào trong quá trình phát triển của mình; Bạn hoàn toàn có thể đọc hiểu để tự lập trình trên NukeViet 4 nếu bạn biết PHP và MySQL (đồng nghĩa với việc NukeViet 4 hoàn toàn mở và dễ nghiên cứu cho bất cứ ai muốn tìm hiểu về code của NukeViet).<span id=\"cke_bm_178E\" style=\"display: none;\">&nbsp;</span></li> </ul>  <ul id=\"docs-internal-guid-7ec786f5-1ade-f016-4c9b-c9a8e36cc922\"> </ul>  <p><span style=\"font-weight: bold;\">Kiến trúc Module</span></p>  <ul> 	<li>NukeViet CMS 4 tái cấu trúc lại module, theo đó, toàn bộ tệp tin của mỗi module được gói gọn trong một thư mục riêng nhằm đơn giản trong việc quản lý và đóng gói ứng dụng. Kiến trúc module này tạo ra khái niệm block của module và theme của module giúp đa dạng hóa việc trình bày module.</li> 	<li>Hệ thống NukeViet 4 hỗ trợ công nghệ đa nhân module. Chúng tôi gọi đó là công nghệ ảo hóa module. Công nghệ này cho phép người sử dụng có thể khởi tạo hàng ngàn module một cách tự động mà không cần động đến một dòng code. Các module được sinh ra từ công nghệ này gọi là module ảo. Module ảo là module được nhân bản từ một module bất kỳ của hệ thống nukeviet nếu module đó cho phép tạo module ảo.</li> 	<li>NukeViet 4 cũng hỗ trợ việc cài đặt từ động 100% các module kèm theo block, theme từ Admin Control Panel, người sử dụng có thể cài module mà không cần làm bất cứ thao tác phức tạp nào. NukeViet 4 còn cho phép bạn đóng gói module để chia sẻ cho người khác.</li> 	<li>Hệ thống cho phép quản lý module từ trong Admin Control Panel, quản trị cấp cao có thể phân quyền truy cập cũng như tạm ngưng hoạt động hay thậm chí cài lại hoặc xóa module tùy theo nhu cầu sử dụng.</li> </ul>  <p><br  /> <span style=\"font-weight: bold;\">Đa ngôn ngữ</span></p>  <ul> 	<li>NukeViet 4 đa ngôn ngữ 100% với 2 loại: đa ngôn ngữ giao diện và đa ngôn ngữ xử lý dữ liệu (database).</li> 	<li>NukeViet 4 có tính năng cho phép người quản trị tự xây dựng ngôn ngữ mới cho site. Cho phép đóng gói file ngôn ngữ để chia sẻ cho cộng đồng...</li> 	<li>NukeViet cũng có trung tâm dịch thuật riêng dành cho việc chung tay góp sức xây dựng những ngôn ngữ mới tại địa chỉ: <a href=\"http://translate.nukeviet.vn\" target=\"_blank\">http://translate.nukeviet.vn</a></li> 	<li>NukeViet 4 tách bạch ngôn ngữ quản trị và ngôn ngữ người dùng, ngôn ngữ giao diện và ngôn ngữ database giúp dễ dàng xây dựng và quản lý các hệ thống đa ngôn ngữ.</li> 	<li>NukeViet 4 còn có khả năng tự động nhận diện và chuyển ngôn ngữ phù hợp cho người sử dụng.</li> 	<li>NukeViet 4 còn có sẵn 3 ngôn ngữ mặc định là Việt, Anh và Pháp.</li> </ul>  <p><span style=\"font-weight: bold;\">Phân quyền</span><strong> cấp độ hệ thống</strong><br  /> NukeViet 4 tách biệt 2 khu vực: Khu vực quản trị và Khu vực người dùng. Toàn bộ các tính năng quản lý nằm trong khu vực quản trị nhằm đảm bảo việc phân quyền được thực hiện chính xác và an toàn nhất.<br  /> <br  /> <span style=\"font-weight: bold;\">Phân quyền Quản trị</span><br  /> NukeViet 4 phân quyền theo module và theo ngôn ngữ, do đó dễ dàng xác lập quyền quản trị cho các hệ thống lớn, nhiều người quản trị cùng làm việc.<br  /> <br  /> <span style=\"font-weight: bold;\">Phân quyền thành viên</span><br  /> NukeViet 4 cho phép quản lý và phân nhóm người sử dụng thành các nhóm khác nhau để dễ dàng phân quyền người sử dụng theo từng module cụ thể.<br  /> <br  /> <strong>Phân quyền cấp độ module</strong><br  /> Ở cấp module, tùy chức năng module được thiết kế mà nó có thể được phân quyền theo các cơ chế khác nhau, việc này đặc biệt linh hoạt khi xây dựng các hệ thống lớn. Với module News tích hợp trong hệ thống được trang bị việc phân quyền tới từng chuyên mục.<br  /> <br  /> <span style=\"font-weight: bold;\">Đa giao diện</span></p>  <ul> 	<li>Cài đặt: NukeViet 4 hỗ trợ cài đặt và gỡ bỏ giao diện hoàn toàn tự động. Hơn thế nữa, bạn có thể đóng gói giao diện để chia sẻ cho website khác một cách dễ dàng.</li> 	<li>NukeViet hỗ trợ giao diện theo ngôn ngữ, giao diện theo module, định nghĩa giao diện mobile (NukeViet 4) và giao diện PC tùy theo ý người quản trị.</li> 	<li>NukeViet hỗ trợ hệ thống đa giao diện cực kỳ uyển chuyển cho cả người sử dụng lẫn người lập trình. Với NukeViet 4, người sử dụng có thể tùy biến một cách dễ dàng: gán giao diện theo module, thiết lập bố cục giao diện cho từng tính năng của module.</li> 	<li>Với người thiết kế giao diện: có thể tùy ý thiết kế không giới hạn bố cục giao diện. Giao diện đã được tách bạch phần HTML và CSS khỏi PHP vì vậy người thiết kế tùy trình độ mà có thể can thiệp vào các lớp giao diện để chỉnh sửa hoặc thiết kế giao diện mới một cách dễ dàng.</li> </ul>  <p><strong>Hỗ trợ truy cập từ điện thoại, máy tính bảng.</strong><br  /> Từ bản NukeViet 4, NukeViet có thể tự động nhận diện thiết bị di động để chuyển giao diện và chế độ tương tác phù hợp. Ngoài ra NukeViet 4 còn có giao diện tùy biến, để có thể hiển thị tốt trên các màn hình khác nhau.<br  /> <br  /> <span style=\"font-weight: bold;\">Tùy biến site bằng Block</span><br  /> NukeViet cho phép đa dạng hóa bố cục và chức năng cho website nhờ các khối (block) khác nhau trên website. Các khối này có thể là các ứng dụng, các khối quảng cáo hoặc dữ liệu bất kỳ nào được người sử dụng định nghĩa. Block của NukeViet 4 cũng phân theo 2 cấp: Block của hệ thống và block cho từng module.<br  /> Người sử dụng có thể tùy ý bố trí vị trí block ở các vị trí khác nhau: toàn bộ website, theo từng module và thậm chí là từng tính năng của module. Block có thể có các giao diện khác nhau theo theme. Có thể hẹn giờ bật/tắt cũng như phân quyền cho từng đối tượng người truy cập.<br  /> Việc bố trí block có thể thực hiện trong Admin Control Panel hoặc kéo thả trực quan ngay tại giao diện người dùng.<br  /> <br  /> <span style=\"font-weight: bold;\">An ninh, bảo mật</span><br  /> NukeViet 4 được thiết kế để nhận biết và chống các truy cập bất hợp pháp vào hệ thống cũng như gửi các dữ liệu có hại lên hệ thống.</p>  <ul> 	<li>Sau khi các chuyên giả bảo mật của HP gửi đánh giá, chúng tôi đã tối ưu NukeViet 4.0 để hệ thống an toàn hơn.</li> 	<li>Mã hóa các mật khẩu lưu trữ trong hệ thống: Các mật khẩu như FTP, SMTP,... đã được mã hóa, bảo mật thông tin người dùng.<br  /> 	Tường lửa Admin bảo vệ khu vực bằng mật khẩu và IP.</li> 	<li>Bộ lọc IP cấm và bộ lọc file cấm giúp ngăn ngừa các nguy cơ biết trước.</li> 	<li>Dữ liệu gửi qua hệ thống được kiểm duyệt bằng bộ lọc an ninh kép nhằm ngăn chặn các dữ liệu có khả năng tấn công vào hệ thống.</li> 	<li>NukeViet có khả năng ngăn chặn, theo dõi và kiểm soát truy cập vào hệ thống của tất cả các máy chủ tìm kiếm như yahoo và google hay bất cứ máy chủ tìm kiếm nào khác.</li> 	<li>Hệ thống có khả năng chống Spam bằng Captcha, chống lụt dữ liệu bằng nhiều hình thức như giới hạn thời gian gửi dữ liệu (sử dụng các công thức kép)...</li> 	<li>Hệ thống cho phép theo dõi, ghi nhận các thông số của máy tính truy cập đến site như: Hệ điều hành, Trình duyệt, quốc gia, các liên kết đến site (referer) để từ đó có thể kịp thời ngăn ngừa các nguy cơ tấn công bằng các hình thức như: kiểm tra và chặn các máy tình dùng proxy, chặn IP truy cập...</li> 	<li>hật ký hệ thống sẽ ghi nhận truy cập và thao tác tới cơ sở dữ liệu &amp; tệp tin, giúp người quản trị cũng như các thành viên dễ dàng phát hiện ra những đăng nhập bất hợp pháp từ lần đăng nhập trước đó.</li> 	<li>Hệ thống có thể phát hiện các bản nâng cấp mới của phần mềm để nhắc nhở người sử dụng nâng cấp và sửa chữa các lỗi (nếu có)</li> </ul>  <p><span style=\"font-weight: bold;\">Quản lý CSDL</span></p>  <ul> 	<li>NukeViet 4 cho phép quản lý CSDL, người sử dụng có thể tối ưu, sao lưu trên máy chủ và tải dữ liệu về để phục vụ cho công tác phục hồi nếu xảy ra sự cố.</li> 	<li>Hỗ trợ mô hình CSDL theo mô hình master/slave để phân tải CSDL.</li> </ul>  <p><span style=\"font-weight: bold;\">Kiểm soát lỗi tự động và báo lỗi thông minh</span></p>  <ul> 	<li>NukeViet 4 có hệ thống kiểm soát lỗi tự động và báo lỗi cho người dùng.</li> 	<li>Các lỗi (nếu có) sẽ được hệ thống kiểm soát có chủ đích, nó chỉ hiển thị lên màn hình người sử dụng ở lần đầu nó xuất hiện, sau đó hệ thống ghi nhận và báo về cho người quản trị qua email.</li> 	<li>Quản trị có thể cấu hình việc bật tắt việc có ghi nhận lỗi hay không.</li> </ul>  <p><span style=\"font-weight: bold;\">Tối ưu hóa cho công cụ tìm kiếm (SEO)</span></p>  <ul> 	<li>Loại bỏ tên module khỏi URL khi không dùng đa ngôn ngữ.</li> 	<li>Cho phép đổi đường dẫn module</li> 	<li>Thêm chức năng xác thực Google+ (Bản quyền tác giả)</li> 	<li>Thêm chức năng ping đến các công cụ tìm kiếm: Submit url mới đến google để việc hiển thị bài viết mới lên kết quả tìm kiếm nhanh chóng hơn.</li> 	<li>Hỗ trợ Meta OG của facebook</li> 	<li>Hỗ trợ chèn Meta GEO qua Cấu hình Meta-Tags<br  /> 	Hỗ trợ SEO link.</li> 	<li>Quản lý và tùy biến tiêu đề site, description</li> 	<li>Hỗ trợ quản lý các thẻ meta như: keywords, description</li> 	<li>Hỗ trợ sử dụng keywords để phát sinh trang thống kê một cách tự động nhờ công cụ tìm kiếm.</li> 	<li>Hỗ trợ quản lý máy chủ tìm kiếm.</li> 	<li>Hỗ trợ quản lý cấu hình robots.txt</li> 	<li>Hỗ trợ chuẩn đoán site (site Diagnostic).</li> </ul>  <p><span style=\"font-weight: bold;\">Sẵn sàng cho việc tích hợp các ứng dụng của bên thứ 3</span><br  /> NukeViet 3.4 sử dụng Cơ sở dữ liệu thành viên độc lập và xây dựng sẵn các phương thức kết nối với các ứng dụng Forum. Cơ sở dữ liệu thành viên độc lập giúp việc quản lý thành viên được chủ động, khi có nhu cầu kết nối hoặc trao quyền quản lý cho các ứng dụng từ bên thứ 3, NukeViet 3.4 vẫn hoàn toàn chủ động với dữ liệu thành viên của mình. Với NukeViet 3.4, các kết nối trực tiếp dành cho Forum như PHPBB hay VBB đều sẵn sàng.<br  /> <br  /> <span style=\"font-weight: bold;\">Hỗ trợ Đăng nhập phân tán</span><br  /> NukeViet hỗ trợ thư viện OAuth , cho phép người truy cập có thể đăng nhập phân tán từ các hệ thống như FaceBook và Google hay các hệ thống OpenID khác giúp các website mới xây dựng có cơ hội thu hút lượng người sử dụng khổng lồ từ các hệ thống lớn.<br  /> Trong mọi trường hợp, hệ thống cho phép admin kiểm duyệt việc login OAuth. Tùy nhu cầu sử dụng mà có thể thiết đặt mức độ login cao nhất (tự động) tới mức độ vẫn phải đăng ký thành viên (bớt bước kích hoạt qua email). Người sử dụng cũng có thể quản lý nhiều tài khoản OAuth để từ đó có thể đăng nhập bằng tài khoản bất kỳ (nếu hệ thống cho phép).</p>  <p><strong>Trình soạn thảo tích hợp sẵn:</strong></p>  <p>Tại những vị trí phù hợp, NukeViet tích hợp sẵn trình soạn thảo CKeditor 5 Classic giúp người sử dụng dễ dàng biên tập nội dung trên giao diện trực quan và thân thiện như làm việc với phần mềm Microsoft Word hay OpenOffice. Hiện tại NukeViet 4 cũng đã mở sẵn để tích hợp các trình soạn thảo khác.</p>  <p><span style=\"font-weight: bold;\">Các tiện ích khác</span><br  /> Hệ thống cho phép gửi mail bằng các phương thức: SMTP, Linux Mail, PHPmail.<br  /> Cho phép sử dụng phương thức FTP để ghi file nếu máy chủ không cho phép làm điều đó bằng PHP<br  /> Cho phép xây dựng và quản lý các tác vụ xử lý tự động như tự động sao lưu CSDL, tự động xóa các dữ liệu cũ hoặc gửi báo lỗi tới người quản trị...<br  /> Cung cấp đầy đủ các thông tin về hệ thống giúp nhà phát triển dễ dàng sử dụng các thông tin này phục vụ cho việc lập trình, kiểm tra và báo lỗi hệ thống.<br  /> <br  /> <span style=\"font-size: 150%; line-height: 116%;\"><span style=\"font-weight: bold;\">Các module tích hợp sẵn trong NukeViet CMS 4:</span></span><br  /> <span style=\"font-weight: bold;\">Quản lý Upload</span></p>  <ul> 	<li>Upload file từ máy tính hoặc một địa chỉ bất kỳ trên mạng.</li> 	<li>Quản lý: Di chuyển, đổi tên, sửa, xóa, tạo hình thu nhỏ...</li> 	<li>Hỗ trợ tìm kiểm các file và mô tả các file được upload lên trong khu vực quản trị.</li> </ul>  <p><span style=\"font-weight: bold;\">Quản trị và xuất bản Tin tức:</span> (cho phép tạo module ảo)<br  /> Hệ thống tin tức của NukeViet là hệ thống quản trị tin tức chuyên nghiệp đặc biệt phù hợp với các website tin tức. Nó cho phép xử lý nhiều tác vụ nền thông minh mà không cần người sử dụng can thiệp nhằm tối ưu cho hệ thống tin tức, Ví dụ: tạo hình thu nhỏ, tự động chia thư mục và sắp xếp hình vào các thư mục theo thời gian...</p>  <ul> 	<li>Quản lý chủ đề đa cấp trong đó bản tin có thể nằm ở 1 hoặc nhiều chủ đề không phụ thuộc quan hệ cha con giữa các chủ đề.</li> 	<li>Phân quyền cho người quản lý module, đến từng chủ đề</li> 	<li>Quản lý nhóm tin liên quan (phân luồn tin theo dòng đơn)</li> 	<li>Quản lý block tin (nhóm tin đa luồng)</li> 	<li>Quản lý Tags</li> 	<li>Quản lý nguồn tin</li> 	<li>Tùy chỉnh bố cục trang tin.</li> 	<li>Gửi bài viết, hẹn giờ đăng và nhiều tùy chỉnh khác: cho phép gửi bản tin, in, lưu bản tin.</li> 	<li>Cấp tin RSS</li> 	<li>Công cụ tương tác với mạng xã&nbsp; hội.</li> </ul>  <p><span style=\"font-weight: bold;\">Module Page:</span></p>  <ul> 	<li>Module này thích hợp làm các bài viết không cần quản lý chủ đề, như các module ảo: giới thiệu, nội quy site ...</li> 	<li>Hỗ trợ SEO: Ảnh minh họa, chú thích ảnh minh họa, mô tả, từ khóa cho bài viết, hiển thị các công cụ tương tác với các mạng xã hội.</li> 	<li>Hỗ trợ RSS</li> 	<li>Cấu hình phương án hiển thị các bài viết trên trang chính.</li> </ul>  <p><span style=\"font-weight: bold;\">Quản lý thành viên:</span></p>  <ul> 	<li>Quản lý việc đăng nhập, đăng ký.</li> 	<li>Quản lý phương thức đăng nhập: Qua openid hoặc đăng nhập trực tiếp.</li> 	<li>Quản lý câu hỏi bảo mật.</li> 	<li>Quản lý nội quy.</li> 	<li>Quản lý thông tin thành viên.</li> 	<li>Cho phép đăng nhập 1 lần tài khoản người dùng NukeViet với Alfresco, Zimbra, Moodle, Koha thông qua CAS.</li> 	<li>Chức năng tùy biến trường dữ liệu thành viên</li> 	<li>Chức năng phân quyền sử dụng module users</li> 	<li>Cấu hình Số ký tự username, độ phức tạp mật khẩu, tạo mật khảu ngẫu nhiên,....</li> 	<li>Cho phép sử dụng tên truy cập, hoặc email để đăng nhập</li> </ul>  <p><span style=\"font-weight: bold;\">Quản lý liên hệ gửi đến website</span></p>  <ul> 	<li>Quản lý thông tin liên hệ trên site.</li> 	<li>Quản lý các bộ phận tiếp nhận liên hệ.</li> 	<li>Quản lý và trả lời các thư gửi tới. Admin có thể trả lời khách nhiều lần, hệ thống lưu lại lịch sử trao đổi đó.</li> 	<li>Hệ thống nhận thông báo: đây là một tiện ích nhỏ, song nó rất hữu dụng để admin tương tác với hệ thống một cách nhanh chóng. Admin có thể nhận thông báo từ hệ thống (hoặc từ module) khi có sự kiện nào đó. Ví dụ: Khi có khách gửi liên hệ (qua module contact) đến thì hệ thống xuất hiện biểu tượng thông báo “Có liên hệ mới” ở góc phải, Admin sẽ nhận được ngay lập tức thông báo khi người dùng đang ở Admin control panel (ACP).</li> </ul>  <p><span style=\"font-weight: bold;\">Quản lý thăm dò ý kiến:</span></p>  <ul> 	<li>Tạo các thăm dò ý kiến</li> </ul>  <p><span style=\"font-weight: bold;\">Quản lý quảng cáo chuyên nghiệp:</span></p>  <ul> 	<li>Quản lý khách hàng.</li> 	<li>Quản lý các khu vực quảng cáo</li> 	<li>Quản lý các nội dung quảng cáo.</li> 	<li>Kết hợp với việc quản lý block. Các quản cáo có thể đặt vào các khu vực khác nhau, dễ dàng thay đổi theo nhu cầu của người dùng.</li> </ul>  <p><span style=\"font-weight: bold;\">Thống kê:</span> Thống kê theo năm, tháng, ngày, tuần, giờ.</p>  <ul> 	<li>Theo liên kết đến site</li> 	<li>Theo quốc gia</li> 	<li>Theo trình duyệt</li> 	<li>Theo hệ điều hành</li> 	<li>Máy chủ tìm kiếm</li> </ul>  <p><span style=\"font-weight: bold;\">Tìm kiếm</span></p>  <ul> 	<li>Tìm kiếm chung toàn hệ thống</li> 	<li>Tìm kiếm nâng cao từng khu vực</li> </ul>  <div><strong>Module menu:</strong></div>  <ul> 	<li>Module này cung cấp để quản lý các menu tùy biên, có thể lấy liên kết từ nhiều mục khác nhau.</li> 	<li>Phương án quản lý menu được thay đổi hướng tới việc quản lý menu nhanh chóng, tiện lợi nhất cho admin.</li> 	<li>Admin có thể nạp nhanh menu theo các tùy chọn mà hệ thống cung cấp.</li> 	<li>Mẫu menu cũng được thay đổi, đa dạng và hiển thị tốt với các giao diện hiện đại.</li> </ul>  <p><strong>Quản lý Bình luận</strong></p>  <ul> 	<li>Các bình luận của các module sẽ được tích hợp quản lý tập trung để cấu hình, phân quyền.</li> 	<li>Khi xây dựng mới module, Chỉ cần nhúng 1 đoạn mã vào. Tránh phải việc copy mã code gây khó khăn cho bảo trì.</li> </ul>  <p><br  /> Trên đây là các tính năng chính của bộ nhân hệ thống NukeViet 4, để xem đầy đủ hơn các tính năng <strong><a href=\"http://wiki.nukeviet.vn/nukeviet4:feature\">click vào đây</a></strong>. Với NukeViet, việc mở rộng thêm các tính năng là không hạn chế, đơn giản là cài thêm các module tương ứng hoặc xây dựng thêm các module đó cho NukeViet.</p>', '', 0, '4', '', 5, 1, 1742685231, 1742685231, 1, 0, 0),
(6, 'Yêu cầu sử dụng NukeViet 4', 'Yeu-cau-su-dung-NukeViet-4', '', '', 0, '', '<h2 class=\"sectionedit2\" id=\"moi_truong_may_chủ\">1. Môi trường máy chủ</h2>  <div class=\"level2\"> <p><strong>Yêu cầu bắt buộc</strong></p>  <ul> 	<li class=\"level1\"> 	<div class=\"li\">Hệ điều hành: Unix (Linux, Ubuntu, Fedora …) hoặc Windows</div> 	</li> 	<li class=\"level1\"> 	<div class=\"li\">PHP: PHP 5.4 hoặc phiên bản mới nhất.</div> 	</li> 	<li class=\"level1\"> 	<div class=\"li\">MySQL: MySQL 5.5 hoặc phiên bản mới nhất</div> 	</li> </ul>  <p><strong>Tùy chọn bổ sung</strong></p>  <ul> 	<li class=\"level1\"> 	<div class=\"li\">Máy chủ Apache cần hỗ trợ mod mod_rewrite.</div> 	</li> 	<li class=\"level1\"> 	<div class=\"li\">Máy chủ Nginx cấu hình các thông số rewite.</div> 	</li> 	<li class=\"level1\"> 	<div class=\"li\">Máy chủ IIS 7.0 hoặc IIS 7.5 cần cài thêm module rewrite</div> 	</li> 	<li class=\"level1\"> 	<div class=\"li\">Môi trường PHP mở rộng: Các thư viện PHP cần có: file_uploads, session, mbstring, curl, gd2, zlib, soap, php_zip.</div> 	</li> </ul>  <p><em class=\"u\"><strong>Ghi chú:</strong></em></p>  <ul> 	<li class=\"level1\"> 	<div class=\"li\">Những yêu cầu trên không có nghĩa là NukeViet 4 không làm việc trên các hệ thống khác, điều quan trọng là cần thiết lập môi trường làm việc phù hợp.</div> 	</li> 	<li class=\"level1\"> 	<div class=\"li\">Với những website sử dụng hosting, NukeViet 4 làm việc tốt nhất trên các hosting Linux cài sẵn Apache 2.2, PHP 5, MySQL 5, DirectAdmin hoặc Cpanel.</div> 	</li> 	<li class=\"level1\"> 	<div class=\"li\">Với các website cần chịu tải cao, nên sử dụng Nginx, PHP7 (php-fpm). Tham khảo thêm mô hình <a class=\"urlextern\" href=\"http://wiki.nukeviet.vn/web_server:cai-dat-server-chi-tai-cao\" rel=\"nofollow\" target=\"_blank\" title=\"http://wiki.nukeviet.vn/web_server:cai-dat-server-chi-tai-cao\">http://wiki.nukeviet.vn/web_server:cai-dat-server-chi-tai-cao</a></div> 	</li> </ul> </div>  <div class=\"secedit editbutton_section editbutton_2\">  <div class=\"no\">&nbsp;</div>  </div>  <h2 class=\"sectionedit3\" id=\"may_tinh_nguời_truy_cập\">2. Máy tính người truy cập</h2>  <div class=\"level2\"> <p>NukeViet 4 cho kết quả là chuẩn HTML5 và CSS 3, đây là định dạng chuẩn mà hầu hết các trình duyệt hiện nay đang hỗ trợ. Chính vì vậy các website làm trên nền NukeViet 4 có thể truy cập tốt trên các phiên bản mới nhất của trình duyệt FireFox, Internet Explorer 9, Google Chrome … Máy tính người truy cập chỉ cần cài một trong các trình duyệt này là có thể tương tác với NukeViet thông qua internet hoặc intranet.</p> </div>', '', 0, '4', '', 6, 1, 1742685231, 1742685231, 1, 0, 0),
(7, 'Giới thiệu về Công ty cổ phần phát triển nguồn mở Việt Nam', 'gioi-thieu-ve-cong-ty-co-phan-phat-trien-nguon-mo-viet-nam', '', '', 0, '', '<p><strong>Công ty cổ phần phát triển nguồn mở Việt Nam</strong> (VINADES.,JSC) là công ty mã nguồn mở đầu tiên của Việt Nam sở hữu riêng một mã nguồn mở nổi tiếng và đang được sử dụng ở hàng ngàn website lớn nhỏ trong mọi lĩnh vực. Wbsite đang hoạt động chính thức: <a href=\"https://vinades.vn/\">https://vinades.vn/</a><br  /> <br  /> Ra đời từ hoạt động của tổ chức nguồn mở NukeViet (từ năm 2004) và chính thức được thành lập đầu 2010 tại Hà Nội, khi đó báo chí đã gọi VINADES.,JSC là <em><strong>&quot;Công ty mã nguồn mở đầu tiên tại Việt Nam&quot;</strong></em>.<br  /> <br  /> Ngay sau khi thành lập, VINADES.,JSC đã thành công trong việc xây dựng <strong><a href=\"https://nukeviet.vn/\" target=\"_blank\">NukeViet</a></strong> thành một <a href=\"https://nukeviet.vn/\" target=\"_blank\">mã nguồn mở</a> thuần Việt. Với khả năng mạnh mẽ, cùng các ưu điểm vượt trội về công nghệ, độ an toàn và bảo mật, NukeViet đã được hàng ngàn website lựa chọn sử dụng trong năm qua. Ngay khi ra mắt phiên bản mới năm 2010, NukeViet đã tạo nên hiệu ứng truyền thông chưa từng có trong lịch sử mã nguồn mở Việt Nam. Tiếp đó, năm 2011 Mã nguồn mở NukeViet đã giành giải thưởng Nhân tài đất Việt cho sản phẩm Công nghệ thông tin đã được ứng dụng rộng rãi.</p>  <div style=\"text-align: center;\"> <div class=\"youtube-embed-wrapper\" style=\"position:relative;padding-bottom:56.25%;padding-top:30px;height:0;overflow:hidden;\"><iframe allowfullscreen=\"\" height=\"480\" src=\"//www.youtube.com/embed/ZOhu2bLE-eA?rel=0&amp;autoplay=1\" style=\"position: absolute;top: 0;left: 0;width: 100%;height: 100%;\" width=\"640\"></iframe></div> <br  /> <span style=\"font-size:12px;\"><strong>Video clip trao giải Nhân tài đất Việt 2011.</strong><br  /> Sản phẩm &quot;Mã nguồn mở NukeViet&quot; đã nhận giải cao nhất (Giải ba, không có giải nhất, giải nhì) của Giải thưởng Nhân Tài Đất Việt 2011 ở lĩnh vực Công nghệ thông tin - Sản phẩm đã có ứng dụng rộng rãi.</span></div>  <p><br  /> Tự chuyên nghiệp hóa mình, thoát khỏi mô hình phát triển tự phát, công ty đã nỗ lực vươn mình ra thế giới và đang phấn đấu trở thành một trong những hiện tượng của thời &quot;dotcom&quot; ở Việt Nam.<br  /> <br  /> Để phục vụ hoạt động của công ty, công ty liên tục mở rộng và tuyển thêm nhân sự ở các vị trí: Lập trình viên, chuyên viên đồ họa, nhân viên kinh doanh... Hãy liên hệ ngay để gia nhập VINADES.,JSC và cùng chúng tôi trở thành một công ty phát triển nguồn mở thành công nhất Việt Nam.</p>  <p>Nếu bạn có nhu cầu triển khai các hệ thống <strong><a href=\"http://toasoandientu.vn\" target=\"_blank\">Tòa Soạn Điện Tử</a></strong>, <strong><a href=\"http://webnhanh.vn\" target=\"_blank\">phần mềm trực tuyến</a></strong>, <strong><a href=\"https://vinades.vn\" target=\"_blank\">thiết kế website</a></strong> theo yêu cầu hoặc dịch vụ có liên quan, hãy liên hệ công ty chuyên quản NukeViet theo thông tin dưới đây:</p>  <p><strong><span style=\"font-family: Tahoma; color: rgb(255, 69, 0); font-size: 14px;\">CÔNG TY CỔ PHẦN PHÁT TRIỂN NGUỒN MỞ VIỆT NAM</span></strong><br  /> <strong>VIET NAM OPEN SOURCE DEVELOPMENT JOINT STOCK COMPANY</strong> (<strong>VINADES.,JSC</strong>)<br  /> Website: <a href=\"https://vinades.vn/\">https://vinades.vn</a> | <a href=\"https://nukeviet.vn/\">https://nukeviet.vn</a> | <a href=\"http://webnhanh.vn/\">http://webnhanh.vn</a><br  /> Trụ sở: Tầng 6, tòa nhà Sông Đà, 131 Trần Phú, Văn Quán, Hà Đông, Hà Nội.<br  /> - Tel: +84-4-85872007<br  /> - Fax: +84-4-35500914<br  /> - Email: <a href=\"mailto:contact@vinades.vn\">contact@vinades.vn</a></p>', 'giới thiệu,công ty,cổ phần,phát triển', 0, '4', '', 7, 1, 1742685231, 1742685231, 1, 0, 0),
(8, 'Ủng hộ, hỗ trợ và tham gia phát triển NukeViet', 'ung-ho-ho-tro-va-tham-gia-phat-trien-nukeviet', '', '', 0, 'Nếu bạn yêu thích NukeViet, bạn có thể ủng hộ và hỗ trợ NukeViet bằng nhiều cách', '<h2>1. Ủng hộ bằng tiền mặt vào Quỹ tài trợ NukeViet</h2>\r\nQua tài khoản Paypal:\r\n\r\n<p style=\"text-align:center\"><a href=\"https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&amp;hosted_button_id=5LUSNE2SV5RR2\" target=\"_blank\"><img alt=\"\" src=\"https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif\" /></a></p>\r\nChuyển khoản ngân hàng trực tiếp:\r\n\r\n<ul>\r\n	<li>Người đứng tên tài khoản:&nbsp;NGUYEN THE HUNG</li>\r\n	<li>Số tài khoản:&nbsp;0031000792053</li>\r\n	<li>Loại tài khoản: VND (Việt Nam Đồng)</li>\r\n	<li>Ngân hàng Vietcombank chi nhánh Hải Phòng.</li>\r\n	<li>Website:&nbsp;<a href=\"http://www.vietcombank.com.vn/\">http://www.vietcombank.com.vn</a></li>\r\n</ul>\r\n\r\n<div class=\"alert alert-info\">Lưu ý: Đây là tài khoản hợp lệ duy nhất mà NukeViet.VN sử dụng cho&nbsp;Quỹ tài trợ NukeViet.</div>\r\nThảo luận tại đây:&nbsp;<a href=\"http://forum.nukeviet.vn/viewtopic.php?f=3&amp;t=3592\" target=\"_blank\">http://forum.nukeviet.vn/viewtopic.php?f=3&amp;t=3592</a>\r\n\r\n<h2>2. Ủng hộ bằng cách sử dụng và phổ biến NukeViet đến nhiều người hơn</h2>\r\nCách đơn giản nhất để ủng hộ NukeViet phát triển là sử dụng NukeViet và giúp NukeViet phổ biến đến nhiều người hơn (ví dụ như giữ lại dòng chữ &quot;Powered by&nbsp;<a href=\"https://nukeviet.vn/\" target=\"_blank\">NukeViet</a>&quot; hoặc &quot;Sử dụng&nbsp;<a href=\"https://nukeviet.vn/\" target=\"_blank\">NukeViet</a>&quot; trên website của bạn, viết bài giới thiệu NukeViet đến mọi người).<br />\r\nNếu bạn có thời gian, bạn có thể tham gia&nbsp;<a href=\"http://forum.nukeviet.vn/\" target=\"_blank\">diễn đàn NukeViet</a>&nbsp;thường xuyên và giúp đỡ những người mới sử dụng NukeViet.\r\n\r\n<h2>3. Ủng hộ bằng cách tham gia phát triển NukeViet</h2>\r\n\r\n<h3>3.1. Phát triển module, giao diện cho NukeViet</h3>\r\nNếu bạn biết code, hãy tham gia viết module, block, theme cho NukeViet và đưa lên&nbsp;<a href=\"https://nukeviet.vn/vi/store/\" target=\"_blank\">NukeViet Store</a>&nbsp;để cung cấp cho cộng đồng. Bạn cũng có thể tham gia đội ngũ phát triển NukeViet.\r\n\r\n<h3>3.2. Tham gia phát triển nhân hệ thống</h3>\r\nToàn bộ code nhân hệ thống NukeViet đã được đưa lên GitHub.com (truy cập tắt:&nbsp;<a href=\"http://code.nukeviet.vn/\" target=\"_blank\">http://code.nukeviet.vn</a>), dù bạn là ai, cá nhân hay doanh nghiệp chỉ cần có một tài khoản tại GitHub và học cách sử dụng&nbsp;<a href=\"#git\">git&nbsp;(1)</a>&nbsp;là bạn có thể tham gia phát triển code NukeViet. Tìm hiểu thêm về việc tham gia phát triển code nhân hệ thống NukeViet tại đây:&nbsp;<a href=\"http://wiki.nukeviet.vn/programming:github_rule\" target=\"_blank\">http://wiki.nukeviet.vn/programming:github_rule</a>\r\n\r\n<h3>3.3. Tham gia dịch thuật</h3>\r\nNếu bạn biết ngoại ngữ, hãy đăng ký tham gia đội ngũ dịch thuật tình nguyện tại&nbsp;<a href=\"http://translate.nukeviet.vn/\" target=\"_blank\">NukeViet Stranslate System</a>&nbsp;để dịch thuật NukeViet sang các ngôn ngữ khác, quảng bá NukeViet ra với thế giới.\r\n\r\n<h3>3.4. Tham gia viết tài liệu hướng dẫn sử dụng</h3>\r\nNếu bạn không biết code, không biết ngoại ngữ, bạn vẫn có thể tham gia đóng góp cho NukeViet bằng cách biên soạn tài liệu hướng dẫn người dùng NukeViet tại thư viện tài liệu mở của NukeViet ở địa chỉ&nbsp;<a href=\"http://wiki.nukeviet.vn/\" target=\"_blank\">http://wiki.nukeviet.vn</a>\r\n\r\n<hr  /> <a id=\"git\" name=\"git\">(1)</a>: Tìm hiểu về git:&nbsp;<a href=\"http://wiki.nukeviet.vn/programming:vcs:git\" target=\"_blank\">http://wiki.nukeviet.vn/programming:vcs:git</a>', 'ủng hộ,hỗ trợ,tham gia,phát triển', 0, '4', '', 8, 1, 1742685231, 1742685231, 1, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_vi_about_config`
--

DROP TABLE IF EXISTS `nv5_vi_about_config`;
CREATE TABLE `nv5_vi_about_config` (
  `config_name` varchar(30) NOT NULL,
  `config_value` varchar(255) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_vi_about_config`
--

INSERT INTO `nv5_vi_about_config` (`config_name`, `config_value`) VALUES
('viewtype', '0'),
('facebookapi', ''),
('per_page', '20'),
('news_first', '0'),
('related_articles', '5'),
('copy_page', '0'),
('alias_lower', '1'),
('socialbutton', 'facebook,twitter');

-- --------------------------------------------------------

--
-- Table structure for table `nv5_vi_blocks_groups`
--

DROP TABLE IF EXISTS `nv5_vi_blocks_groups`;
CREATE TABLE `nv5_vi_blocks_groups` (
  `bid` mediumint(8) UNSIGNED NOT NULL,
  `theme` varchar(55) NOT NULL,
  `module` varchar(55) NOT NULL,
  `file_name` varchar(55) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `link` varchar(255) DEFAULT NULL,
  `template` varchar(55) DEFAULT NULL,
  `heading` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Thẻ heading mong muốn',
  `position` varchar(55) DEFAULT NULL,
  `dtime_type` char(50) NOT NULL DEFAULT 'regular',
  `dtime_details` text DEFAULT NULL,
  `active` varchar(10) DEFAULT '1',
  `act` tinyint(1) UNSIGNED NOT NULL DEFAULT 1,
  `groups_view` varchar(255) DEFAULT '',
  `all_func` tinyint(4) NOT NULL DEFAULT 0,
  `weight` int(11) NOT NULL DEFAULT 0,
  `config` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Danh sách block theo ngôn ngữ, giao diện';

--
-- Dumping data for table `nv5_vi_blocks_groups`
--

INSERT INTO `nv5_vi_blocks_groups` (`bid`, `theme`, `module`, `file_name`, `title`, `link`, `template`, `heading`, `position`, `dtime_type`, `dtime_details`, `active`, `act`, `groups_view`, `all_func`, `weight`, `config`) VALUES
(1, 'default', 'news', 'module.block_newscenter.php', 'Tin mới nhất', '', 'no_title', 0, '[TOP]', 'regular', '[]', '1', 1, '6', 0, 1, 'a:10:{s:6:\"numrow\";i:6;s:11:\"showtooltip\";i:1;s:16:\"tooltip_position\";s:6:\"bottom\";s:14:\"tooltip_length\";s:3:\"150\";s:12:\"length_title\";i:0;s:15:\"length_hometext\";i:0;s:17:\"length_othertitle\";i:60;s:5:\"width\";i:500;s:6:\"height\";i:0;s:7:\"nocatid\";a:0:{}}'),
(2, 'default', 'banners', 'global.banners.php', 'Quảng cáo giữa trang', '', 'no_title', 0, '[TOP]', 'regular', '[]', '1', 1, '6', 0, 2, 'a:1:{s:12:\"idplanbanner\";i:1;}'),
(3, 'default', 'news', 'global.block_category.php', 'Chủ đề', '', 'no_title', 0, '[LEFT]', 'regular', '[]', '1', 1, '6', 0, 1, 'a:2:{s:5:\"catid\";i:0;s:12:\"title_length\";i:0;}'),
(4, 'default', 'theme', 'global.module_menu.php', 'Module Menu', '', 'no_title', 0, '[LEFT]', 'regular', '[]', '1', 1, '6', 0, 2, ''),
(5, 'default', 'banners', 'global.banners.php', 'Quảng cáo cột trái', '', 'no_title', 0, '[LEFT]', 'regular', '[]', '1', 1, '6', 1, 3, 'a:1:{s:12:\"idplanbanner\";i:2;}'),
(6, 'default', 'statistics', 'global.counter.php', 'Thống kê', '', 'primary', 0, '[LEFT]', 'regular', '[]', '1', 1, '6', 1, 4, ''),
(7, 'default', 'about', 'global.about.php', 'Giới thiệu', '', 'border', 0, '[RIGHT]', 'regular', '[]', '1', 1, '6', 1, 1, ''),
(8, 'default', 'banners', 'global.banners.php', 'Quảng cáo cột phải', '', 'no_title', 0, '[RIGHT]', 'regular', '[]', '1', 1, '6', 1, 2, 'a:1:{s:12:\"idplanbanner\";i:3;}'),
(9, 'default', 'voting', 'global.voting_random.php', 'Thăm dò ý kiến', '', 'primary', 0, '[RIGHT]', 'regular', '[]', '1', 1, '6', 1, 3, ''),
(10, 'default', 'news', 'global.block_tophits.php', 'Tin xem nhiều', '', 'primary', 0, '[RIGHT]', 'regular', '[]', '1', 1, '6', 1, 4, 'a:6:{s:10:\"number_day\";i:3650;s:6:\"numrow\";i:10;s:11:\"showtooltip\";i:1;s:16:\"tooltip_position\";s:6:\"bottom\";s:14:\"tooltip_length\";s:3:\"150\";s:7:\"nocatid\";a:2:{i:0;i:10;i:1;i:11;}}'),
(11, 'default', 'theme', 'global.copyright.php', 'Copyright', '', 'no_title', 0, '[FOOTER_SITE]', 'regular', '[]', '1', 1, '6', 1, 1, 'a:5:{s:12:\"copyright_by\";s:0:\"\";s:13:\"copyright_url\";s:0:\"\";s:9:\"design_by\";s:12:\"VINADES.,JSC\";s:10:\"design_url\";s:19:\"https://vinades.vn/\";s:13:\"siteterms_url\";s:39:\"/index.php?language=vi&amp;nv=siteterms\";}'),
(12, 'default', 'contact', 'global.contact_form.php', 'Feedback', '', 'no_title', 0, '[FOOTER_SITE]', 'regular', '[]', '1', 1, '6', 1, 2, ''),
(13, 'default', 'theme', 'global.QR_code.php', 'QR code', '', 'no_title', 0, '[QR_CODE]', 'regular', '[]', '1', 1, '6', 1, 1, ''),
(14, 'default', 'statistics', 'global.counter_button.php', 'Online button', '', 'no_title', 0, '[QR_CODE]', 'regular', '[]', '1', 1, '6', 1, 2, ''),
(15, 'default', 'inform', 'global.inform.php', 'Thông báo', '', 'no_title', 0, '[PERSONALAREA]', 'regular', '[]', '1', 1, '6', 1, 1, ''),
(16, 'default', 'users', 'global.user_button.php', 'Đăng nhập người dùng', '', 'no_title', 0, '[PERSONALAREA]', 'regular', '[]', '1', 1, '6', 1, 2, ''),
(17, 'default', 'theme', 'global.company_info.php', 'Công ty chủ quản', '', 'simple', 0, '[COMPANY_INFO]', 'regular', '[]', '1', 1, '6', 1, 1, 'a:13:{s:12:\"company_name\";s:58:\"Công ty cổ phần phát triển nguồn mở Việt Nam\";s:15:\"company_address\";s:82:\"Tầng 6, tòa nhà Sông Đà, 131 Trần Phú, Văn Quán, Hà Đông, Hà Nội\";s:16:\"company_sortname\";s:12:\"VINADES.,JSC\";s:15:\"company_regcode\";s:0:\"\";s:16:\"company_regplace\";s:0:\"\";s:21:\"company_licensenumber\";s:0:\"\";s:22:\"company_responsibility\";s:0:\"\";s:15:\"company_showmap\";i:1;s:14:\"company_mapurl\";s:312:\"https://www.google.com/maps/embed?pb=!1m14!1m8!1m3!1d427.01613794022035!2d105.78849184070538!3d20.979995366268337!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3135ac93055e2f2f%3A0x91f4b423089193dd!2zQ8O0bmcgdHkgQ-G7lSBwaOG6p24gUGjDoXQgdHJp4buDbiBOZ3Xhu5NuIG3hu58gVmnhu4d0IE5hbQ!5e0!3m2!1svi!2s!4v1701239622249!5m2!1svi!2s\";s:13:\"company_phone\";s:30:\"+84-24-85872007[+842485872007]\";s:11:\"company_fax\";s:15:\"+84-24-35500914\";s:13:\"company_email\";s:18:\"contact@vinades.vn\";s:15:\"company_website\";s:18:\"https://vinades.vn\";}'),
(18, 'default', 'menu', 'global.bootstrap.php', 'Menu Site', '', 'no_title', 0, '[MENU_SITE]', 'regular', '[]', '1', 1, '6', 1, 1, 'a:2:{s:6:\"menuid\";i:1;s:12:\"title_length\";i:0;}'),
(19, 'default', 'contact', 'global.contact_default.php', 'Contact Default', '', 'no_title', 0, '[CONTACT_DEFAULT]', 'regular', '[]', '1', 1, '6', 1, 1, ''),
(20, 'default', 'theme', 'global.social.php', 'Social icon', '', 'no_title', 0, '[SOCIAL_ICONS]', 'regular', '[]', '1', 1, '6', 1, 1, 'a:3:{s:8:\"facebook\";s:32:\"http://www.facebook.com/nukeviet\";s:7:\"youtube\";s:37:\"https://www.youtube.com/user/nukeviet\";s:7:\"twitter\";s:28:\"https://twitter.com/nukeviet\";}'),
(21, 'default', 'theme', 'global.menu_footer.php', 'Các chuyên mục chính', '', 'simple', 0, '[MENU_FOOTER]', 'regular', '[]', '1', 1, '6', 1, 1, 'a:1:{s:14:\"module_in_menu\";a:8:{i:0;s:5:\"about\";i:1;s:4:\"news\";i:2;s:5:\"users\";i:3;s:7:\"contact\";i:4;s:6:\"voting\";i:5;s:7:\"banners\";i:6;s:4:\"seek\";i:7;s:5:\"feeds\";}}'),
(22, 'default', 'freecontent', 'global.free_content.php', 'Sản phẩm', '', 'no_title', 0, '[FEATURED_PRODUCT]', 'regular', '[]', '1', 1, '6', 1, 1, 'a:2:{s:7:\"blockid\";i:1;s:7:\"numrows\";i:2;}'),
(23, 'mobile_default', 'menu', 'global.metismenu.php', 'Menu Site', '', 'no_title', 0, '[MENU_SITE]', 'regular', '[]', '1', 1, '6', 1, 1, 'a:2:{s:6:\"menuid\";i:1;s:12:\"title_length\";i:0;}'),
(24, 'mobile_default', 'inform', 'global.inform.php', 'Thông báo', '', 'no_title', 0, '[MENU_SITE]', 'regular', '[]', '1', 1, '6', 1, 2, ''),
(25, 'mobile_default', 'users', 'global.user_button.php', 'Sign In', '', 'no_title', 0, '[MENU_SITE]', 'regular', '[]', '1', 1, '6', 1, 3, ''),
(26, 'mobile_default', 'contact', 'global.contact_default.php', 'Contact Default', '', 'no_title', 0, '[SOCIAL_ICONS]', 'regular', '[]', '1', 1, '6', 1, 1, ''),
(27, 'mobile_default', 'contact', 'global.contact_form.php', 'Feedback', '', 'no_title', 0, '[SOCIAL_ICONS]', 'regular', '[]', '1', 1, '6', 1, 2, ''),
(28, 'mobile_default', 'theme', 'global.social.php', 'Social icon', '', 'no_title', 0, '[SOCIAL_ICONS]', 'regular', '[]', '1', 1, '6', 1, 3, 'a:3:{s:8:\"facebook\";s:32:\"http://www.facebook.com/nukeviet\";s:7:\"youtube\";s:37:\"https://www.youtube.com/user/nukeviet\";s:7:\"twitter\";s:28:\"https://twitter.com/nukeviet\";}'),
(29, 'mobile_default', 'theme', 'global.QR_code.php', 'QR code', '', 'no_title', 0, '[SOCIAL_ICONS]', 'regular', '[]', '1', 1, '6', 1, 4, ''),
(30, 'mobile_default', 'theme', 'global.copyright.php', 'Copyright', '', 'no_title', 0, '[FOOTER_SITE]', 'regular', '[]', '1', 1, '6', 1, 1, 'a:5:{s:12:\"copyright_by\";s:0:\"\";s:13:\"copyright_url\";s:0:\"\";s:9:\"design_by\";s:12:\"VINADES.,JSC\";s:10:\"design_url\";s:19:\"https://vinades.vn/\";s:13:\"siteterms_url\";s:39:\"/index.php?language=vi&amp;nv=siteterms\";}'),
(31, 'mobile_default', 'theme', 'global.menu_footer.php', 'Các chuyên mục chính', '', 'primary', 0, '[MENU_FOOTER]', 'regular', '[]', '1', 1, '6', 1, 1, 'a:1:{s:14:\"module_in_menu\";a:9:{i:0;s:5:\"about\";i:1;s:4:\"news\";i:2;s:5:\"users\";i:3;s:7:\"contact\";i:4;s:6:\"voting\";i:5;s:7:\"banners\";i:6;s:4:\"seek\";i:7;s:5:\"feeds\";i:8;s:9:\"siteterms\";}}'),
(32, 'mobile_default', 'theme', 'global.company_info.php', 'Công ty chủ quản', '', 'primary', 0, '[COMPANY_INFO]', 'regular', '[]', '1', 1, '6', 1, 1, 'a:13:{s:12:\"company_name\";s:58:\"Công ty cổ phần phát triển nguồn mở Việt Nam\";s:15:\"company_address\";s:82:\"Tầng 6, tòa nhà Sông Đà, 131 Trần Phú, Văn Quán, Hà Đông, Hà Nội\";s:16:\"company_sortname\";s:12:\"VINADES.,JSC\";s:15:\"company_regcode\";s:0:\"\";s:16:\"company_regplace\";s:0:\"\";s:21:\"company_licensenumber\";s:0:\"\";s:22:\"company_responsibility\";s:0:\"\";s:15:\"company_showmap\";i:1;s:14:\"company_mapurl\";s:312:\"https://www.google.com/maps/embed?pb=!1m14!1m8!1m3!1d427.01613794022035!2d105.78849184070538!3d20.979995366268337!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3135ac93055e2f2f%3A0x91f4b423089193dd!2zQ8O0bmcgdHkgQ-G7lSBwaOG6p24gUGjDoXQgdHJp4buDbiBOZ3Xhu5NuIG3hu58gVmnhu4d0IE5hbQ!5e0!3m2!1svi!2s!4v1701239622249!5m2!1svi!2s\";s:13:\"company_phone\";s:30:\"+84-24-85872007[+842485872007]\";s:11:\"company_fax\";s:15:\"+84-24-35500914\";s:13:\"company_email\";s:18:\"contact@vinades.vn\";s:15:\"company_website\";s:18:\"https://vinades.vn\";}');

-- --------------------------------------------------------

--
-- Table structure for table `nv5_vi_blocks_weight`
--

DROP TABLE IF EXISTS `nv5_vi_blocks_weight`;
CREATE TABLE `nv5_vi_blocks_weight` (
  `bid` mediumint(8) NOT NULL DEFAULT 0,
  `func_id` mediumint(8) NOT NULL DEFAULT 0,
  `weight` mediumint(8) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Vị trí đặt các block';

--
-- Dumping data for table `nv5_vi_blocks_weight`
--

INSERT INTO `nv5_vi_blocks_weight` (`bid`, `func_id`, `weight`) VALUES
(1, 4, 1),
(2, 4, 2),
(3, 4, 1),
(3, 5, 1),
(3, 6, 1),
(3, 7, 1),
(3, 8, 1),
(3, 9, 1),
(3, 10, 1),
(3, 11, 1),
(3, 12, 1),
(4, 20, 1),
(4, 21, 1),
(4, 22, 1),
(4, 23, 1),
(4, 24, 1),
(4, 25, 1),
(4, 26, 1),
(4, 27, 1),
(4, 28, 1),
(4, 29, 1),
(4, 30, 1),
(4, 31, 1),
(4, 36, 1),
(4, 37, 1),
(4, 38, 1),
(4, 39, 1),
(4, 40, 1),
(4, 41, 1),
(4, 42, 1),
(5, 1, 1),
(5, 2, 1),
(5, 3, 1),
(5, 4, 2),
(5, 5, 2),
(5, 6, 2),
(5, 7, 2),
(5, 8, 2),
(5, 9, 2),
(5, 10, 2),
(5, 11, 2),
(5, 12, 2),
(5, 13, 1),
(5, 14, 1),
(5, 15, 1),
(5, 16, 1),
(5, 17, 1),
(5, 18, 1),
(5, 19, 1),
(5, 20, 2),
(5, 21, 2),
(5, 22, 2),
(5, 23, 2),
(5, 24, 2),
(5, 25, 2),
(5, 26, 2),
(5, 27, 2),
(5, 28, 2),
(5, 29, 2),
(5, 30, 2),
(5, 31, 2),
(5, 32, 1),
(5, 33, 1),
(5, 34, 1),
(5, 35, 1),
(5, 36, 2),
(5, 37, 2),
(5, 38, 2),
(5, 39, 2),
(5, 40, 2),
(5, 41, 2),
(5, 42, 2),
(5, 43, 1),
(5, 44, 1),
(5, 45, 1),
(5, 46, 1),
(5, 47, 1),
(5, 48, 1),
(5, 49, 1),
(5, 50, 1),
(5, 51, 1),
(5, 52, 1),
(5, 53, 1),
(5, 54, 1),
(5, 55, 1),
(5, 56, 1),
(5, 57, 1),
(5, 58, 1),
(5, 59, 1),
(5, 60, 1),
(5, 61, 1),
(5, 62, 1),
(5, 63, 1),
(5, 64, 1),
(5, 65, 1),
(5, 66, 1),
(5, 67, 1),
(5, 68, 1),
(5, 69, 1),
(5, 70, 1),
(5, 71, 1),
(5, 72, 1),
(5, 73, 1),
(5, 74, 1),
(5, 75, 1),
(6, 1, 2),
(6, 2, 2),
(6, 3, 2),
(6, 4, 3),
(6, 5, 3),
(6, 6, 3),
(6, 7, 3),
(6, 8, 3),
(6, 9, 3),
(6, 10, 3),
(6, 11, 3),
(6, 12, 3),
(6, 13, 2),
(6, 14, 2),
(6, 15, 2),
(6, 16, 2),
(6, 17, 2),
(6, 18, 2),
(6, 19, 2),
(6, 20, 3),
(6, 21, 3),
(6, 22, 3),
(6, 23, 3),
(6, 24, 3),
(6, 25, 3),
(6, 26, 3),
(6, 27, 3),
(6, 28, 3),
(6, 29, 3),
(6, 30, 3),
(6, 31, 3),
(6, 32, 2),
(6, 33, 2),
(6, 34, 2),
(6, 35, 2),
(6, 36, 3),
(6, 37, 3),
(6, 38, 3),
(6, 39, 3),
(6, 40, 3),
(6, 41, 3),
(6, 42, 3),
(6, 43, 2),
(6, 44, 2),
(6, 45, 2),
(6, 46, 2),
(6, 47, 2),
(6, 48, 2),
(6, 49, 2),
(6, 50, 2),
(6, 51, 2),
(6, 52, 2),
(6, 53, 2),
(6, 54, 2),
(6, 55, 2),
(6, 56, 2),
(6, 57, 2),
(6, 58, 2),
(6, 59, 2),
(6, 60, 2),
(6, 61, 2),
(6, 62, 2),
(6, 63, 2),
(6, 64, 2),
(6, 65, 2),
(6, 66, 2),
(6, 67, 2),
(6, 68, 2),
(6, 69, 2),
(6, 70, 2),
(6, 71, 2),
(6, 72, 2),
(6, 73, 2),
(6, 74, 2),
(6, 75, 2),
(7, 1, 1),
(7, 2, 1),
(7, 3, 1),
(7, 4, 1),
(7, 5, 1),
(7, 6, 1),
(7, 7, 1),
(7, 8, 1),
(7, 9, 1),
(7, 10, 1),
(7, 11, 1),
(7, 12, 1),
(7, 13, 1),
(7, 14, 1),
(7, 15, 1),
(7, 16, 1),
(7, 17, 1),
(7, 18, 1),
(7, 19, 1),
(7, 20, 1),
(7, 21, 1),
(7, 22, 1),
(7, 23, 1),
(7, 24, 1),
(7, 25, 1),
(7, 26, 1),
(7, 27, 1),
(7, 28, 1),
(7, 29, 1),
(7, 30, 1),
(7, 31, 1),
(7, 32, 1),
(7, 33, 1),
(7, 34, 1),
(7, 35, 1),
(7, 36, 1),
(7, 37, 1),
(7, 38, 1),
(7, 39, 1),
(7, 40, 1),
(7, 41, 1),
(7, 42, 1),
(7, 43, 1),
(7, 44, 1),
(7, 45, 1),
(7, 46, 1),
(7, 47, 1),
(7, 48, 1),
(7, 49, 1),
(7, 50, 1),
(7, 51, 1),
(7, 52, 1),
(7, 53, 1),
(7, 54, 1),
(7, 55, 1),
(7, 56, 1),
(7, 57, 1),
(7, 58, 1),
(7, 59, 1),
(7, 60, 1),
(7, 61, 1),
(7, 62, 1),
(7, 63, 1),
(7, 64, 1),
(7, 65, 1),
(7, 66, 1),
(7, 67, 1),
(7, 68, 1),
(7, 69, 1),
(7, 70, 1),
(7, 71, 1),
(7, 72, 1),
(7, 73, 1),
(7, 74, 1),
(7, 75, 1),
(8, 1, 2),
(8, 2, 2),
(8, 3, 2),
(8, 4, 2),
(8, 5, 2),
(8, 6, 2),
(8, 7, 2),
(8, 8, 2),
(8, 9, 2),
(8, 10, 2),
(8, 11, 2),
(8, 12, 2),
(8, 13, 2),
(8, 14, 2),
(8, 15, 2),
(8, 16, 2),
(8, 17, 2),
(8, 18, 2),
(8, 19, 2),
(8, 20, 2),
(8, 21, 2),
(8, 22, 2),
(8, 23, 2),
(8, 24, 2),
(8, 25, 2),
(8, 26, 2),
(8, 27, 2),
(8, 28, 2),
(8, 29, 2),
(8, 30, 2),
(8, 31, 2),
(8, 32, 2),
(8, 33, 2),
(8, 34, 2),
(8, 35, 2),
(8, 36, 2),
(8, 37, 2),
(8, 38, 2),
(8, 39, 2),
(8, 40, 2),
(8, 41, 2),
(8, 42, 2),
(8, 43, 2),
(8, 44, 2),
(8, 45, 2),
(8, 46, 2),
(8, 47, 2),
(8, 48, 2),
(8, 49, 2),
(8, 50, 2),
(8, 51, 2),
(8, 52, 2),
(8, 53, 2),
(8, 54, 2),
(8, 55, 2),
(8, 56, 2),
(8, 57, 2),
(8, 58, 2),
(8, 59, 2),
(8, 60, 2),
(8, 61, 2),
(8, 62, 2),
(8, 63, 2),
(8, 64, 2),
(8, 65, 2),
(8, 66, 2),
(8, 67, 2),
(8, 68, 2),
(8, 69, 2),
(8, 70, 2),
(8, 71, 2),
(8, 72, 2),
(8, 73, 2),
(8, 74, 2),
(8, 75, 2),
(9, 1, 3),
(9, 2, 3),
(9, 3, 3),
(9, 4, 3),
(9, 5, 3),
(9, 6, 3),
(9, 7, 3),
(9, 8, 3),
(9, 9, 3),
(9, 10, 3),
(9, 11, 3),
(9, 12, 3),
(9, 13, 3),
(9, 14, 3),
(9, 15, 3),
(9, 16, 3),
(9, 17, 3),
(9, 18, 3),
(9, 19, 3),
(9, 20, 3),
(9, 21, 3),
(9, 22, 3),
(9, 23, 3),
(9, 24, 3),
(9, 25, 3),
(9, 26, 3),
(9, 27, 3),
(9, 28, 3),
(9, 29, 3),
(9, 30, 3),
(9, 31, 3),
(9, 32, 3),
(9, 33, 3),
(9, 34, 3),
(9, 35, 3),
(9, 36, 3),
(9, 37, 3),
(9, 38, 3),
(9, 39, 3),
(9, 40, 3),
(9, 41, 3),
(9, 42, 3),
(9, 43, 3),
(9, 44, 3),
(9, 45, 3),
(9, 46, 3),
(9, 47, 3),
(9, 48, 3),
(9, 49, 3),
(9, 50, 3),
(9, 51, 3),
(9, 52, 3),
(9, 53, 3),
(9, 54, 3),
(9, 55, 3),
(9, 56, 3),
(9, 57, 3),
(9, 58, 3),
(9, 59, 3),
(9, 60, 3),
(9, 61, 3),
(9, 62, 3),
(9, 63, 3),
(9, 64, 3),
(9, 65, 3),
(9, 66, 3),
(9, 67, 3),
(9, 68, 3),
(9, 69, 3),
(9, 70, 3),
(9, 71, 3),
(9, 72, 3),
(9, 73, 3),
(9, 74, 3),
(9, 75, 3),
(10, 1, 4),
(10, 2, 4),
(10, 3, 4),
(10, 4, 4),
(10, 5, 4),
(10, 6, 4),
(10, 7, 4),
(10, 8, 4),
(10, 9, 4),
(10, 10, 4),
(10, 11, 4),
(10, 12, 4),
(10, 13, 4),
(10, 14, 4),
(10, 15, 4),
(10, 16, 4),
(10, 17, 4),
(10, 18, 4),
(10, 19, 4),
(10, 20, 4),
(10, 21, 4),
(10, 22, 4),
(10, 23, 4),
(10, 24, 4),
(10, 25, 4),
(10, 26, 4),
(10, 27, 4),
(10, 28, 4),
(10, 29, 4),
(10, 30, 4),
(10, 31, 4),
(10, 32, 4),
(10, 33, 4),
(10, 34, 4),
(10, 35, 4),
(10, 36, 4),
(10, 37, 4),
(10, 38, 4),
(10, 39, 4),
(10, 40, 4),
(10, 41, 4),
(10, 42, 4),
(10, 43, 4),
(10, 44, 4),
(10, 45, 4),
(10, 46, 4),
(10, 47, 4),
(10, 48, 4),
(10, 49, 4),
(10, 50, 4),
(10, 51, 4),
(10, 52, 4),
(10, 53, 4),
(10, 54, 4),
(10, 55, 4),
(10, 56, 4),
(10, 57, 4),
(10, 58, 4),
(10, 59, 4),
(10, 60, 4),
(10, 61, 4),
(10, 62, 4),
(10, 63, 4),
(10, 64, 4),
(10, 65, 4),
(10, 66, 4),
(10, 67, 4),
(10, 68, 4),
(10, 69, 4),
(10, 70, 4),
(10, 71, 4),
(10, 72, 4),
(10, 73, 4),
(10, 74, 4),
(10, 75, 4),
(11, 1, 1),
(11, 2, 1),
(11, 3, 1),
(11, 4, 1),
(11, 5, 1),
(11, 6, 1),
(11, 7, 1),
(11, 8, 1),
(11, 9, 1),
(11, 10, 1),
(11, 11, 1),
(11, 12, 1),
(11, 13, 1),
(11, 14, 1),
(11, 15, 1),
(11, 16, 1),
(11, 17, 1),
(11, 18, 1),
(11, 19, 1),
(11, 20, 1),
(11, 21, 1),
(11, 22, 1),
(11, 23, 1),
(11, 24, 1),
(11, 25, 1),
(11, 26, 1),
(11, 27, 1),
(11, 28, 1),
(11, 29, 1),
(11, 30, 1),
(11, 31, 1),
(11, 32, 1),
(11, 33, 1),
(11, 34, 1),
(11, 35, 1),
(11, 36, 1),
(11, 37, 1),
(11, 38, 1),
(11, 39, 1),
(11, 40, 1),
(11, 41, 1),
(11, 42, 1),
(11, 43, 1),
(11, 44, 1),
(11, 45, 1),
(11, 46, 1),
(11, 47, 1),
(11, 48, 1),
(11, 49, 1),
(11, 50, 1),
(11, 51, 1),
(11, 52, 1),
(11, 53, 1),
(11, 54, 1),
(11, 55, 1),
(11, 56, 1),
(11, 57, 1),
(11, 58, 1),
(11, 59, 1),
(11, 60, 1),
(11, 61, 1),
(11, 62, 1),
(11, 63, 1),
(11, 64, 1),
(11, 65, 1),
(11, 66, 1),
(11, 67, 1),
(11, 68, 1),
(11, 69, 1),
(11, 70, 1),
(11, 71, 1),
(11, 72, 1),
(11, 73, 1),
(11, 74, 1),
(11, 75, 1),
(12, 1, 2),
(12, 2, 2),
(12, 3, 2),
(12, 4, 2),
(12, 5, 2),
(12, 6, 2),
(12, 7, 2),
(12, 8, 2),
(12, 9, 2),
(12, 10, 2),
(12, 11, 2),
(12, 12, 2),
(12, 13, 2),
(12, 14, 2),
(12, 15, 2),
(12, 16, 2),
(12, 17, 2),
(12, 18, 2),
(12, 19, 2),
(12, 20, 2),
(12, 21, 2),
(12, 22, 2),
(12, 23, 2),
(12, 24, 2),
(12, 25, 2),
(12, 26, 2),
(12, 27, 2),
(12, 28, 2),
(12, 29, 2),
(12, 30, 2),
(12, 31, 2),
(12, 32, 2),
(12, 33, 2),
(12, 34, 2),
(12, 35, 2),
(12, 36, 2),
(12, 37, 2),
(12, 38, 2),
(12, 39, 2),
(12, 40, 2),
(12, 41, 2),
(12, 42, 2),
(12, 43, 2),
(12, 44, 2),
(12, 45, 2),
(12, 46, 2),
(12, 47, 2),
(12, 48, 2),
(12, 49, 2),
(12, 50, 2),
(12, 51, 2),
(12, 52, 2),
(12, 53, 2),
(12, 54, 2),
(12, 55, 2),
(12, 56, 2),
(12, 57, 2),
(12, 58, 2),
(12, 59, 2),
(12, 60, 2),
(12, 61, 2),
(12, 62, 2),
(12, 63, 2),
(12, 64, 2),
(12, 65, 2),
(12, 66, 2),
(12, 67, 2),
(12, 68, 2),
(12, 69, 2),
(12, 70, 2),
(12, 71, 2),
(12, 72, 2),
(12, 73, 2),
(12, 74, 2),
(12, 75, 2),
(13, 1, 1),
(13, 2, 1),
(13, 3, 1),
(13, 4, 1),
(13, 5, 1),
(13, 6, 1),
(13, 7, 1),
(13, 8, 1),
(13, 9, 1),
(13, 10, 1),
(13, 11, 1),
(13, 12, 1),
(13, 13, 1),
(13, 14, 1),
(13, 15, 1),
(13, 16, 1),
(13, 17, 1),
(13, 18, 1),
(13, 19, 1),
(13, 20, 1),
(13, 21, 1),
(13, 22, 1),
(13, 23, 1),
(13, 24, 1),
(13, 25, 1),
(13, 26, 1),
(13, 27, 1),
(13, 28, 1),
(13, 29, 1),
(13, 30, 1),
(13, 31, 1),
(13, 32, 1),
(13, 33, 1),
(13, 34, 1),
(13, 35, 1),
(13, 36, 1),
(13, 37, 1),
(13, 38, 1),
(13, 39, 1),
(13, 40, 1),
(13, 41, 1),
(13, 42, 1),
(13, 43, 1),
(13, 44, 1),
(13, 45, 1),
(13, 46, 1),
(13, 47, 1),
(13, 48, 1),
(13, 49, 1),
(13, 50, 1),
(13, 51, 1),
(13, 52, 1),
(13, 53, 1),
(13, 54, 1),
(13, 55, 1),
(13, 56, 1),
(13, 57, 1),
(13, 58, 1),
(13, 59, 1),
(13, 60, 1),
(13, 61, 1),
(13, 62, 1),
(13, 63, 1),
(13, 64, 1),
(13, 65, 1),
(13, 66, 1),
(13, 67, 1),
(13, 68, 1),
(13, 69, 1),
(13, 70, 1),
(13, 71, 1),
(13, 72, 1),
(13, 73, 1),
(13, 74, 1),
(13, 75, 1),
(14, 1, 2),
(14, 2, 2),
(14, 3, 2),
(14, 4, 2),
(14, 5, 2),
(14, 6, 2),
(14, 7, 2),
(14, 8, 2),
(14, 9, 2),
(14, 10, 2),
(14, 11, 2),
(14, 12, 2),
(14, 13, 2),
(14, 14, 2),
(14, 15, 2),
(14, 16, 2),
(14, 17, 2),
(14, 18, 2),
(14, 19, 2),
(14, 20, 2),
(14, 21, 2),
(14, 22, 2),
(14, 23, 2),
(14, 24, 2),
(14, 25, 2),
(14, 26, 2),
(14, 27, 2),
(14, 28, 2),
(14, 29, 2),
(14, 30, 2),
(14, 31, 2),
(14, 32, 2),
(14, 33, 2),
(14, 34, 2),
(14, 35, 2),
(14, 36, 2),
(14, 37, 2),
(14, 38, 2),
(14, 39, 2),
(14, 40, 2),
(14, 41, 2),
(14, 42, 2),
(14, 43, 2),
(14, 44, 2),
(14, 45, 2),
(14, 46, 2),
(14, 47, 2),
(14, 48, 2),
(14, 49, 2),
(14, 50, 2),
(14, 51, 2),
(14, 52, 2),
(14, 53, 2),
(14, 54, 2),
(14, 55, 2),
(14, 56, 2),
(14, 57, 2),
(14, 58, 2),
(14, 59, 2),
(14, 60, 2),
(14, 61, 2),
(14, 62, 2),
(14, 63, 2),
(14, 64, 2),
(14, 65, 2),
(14, 66, 2),
(14, 67, 2),
(14, 68, 2),
(14, 69, 2),
(14, 70, 2),
(14, 71, 2),
(14, 72, 2),
(14, 73, 2),
(14, 74, 2),
(14, 75, 2),
(15, 1, 1),
(15, 2, 1),
(15, 3, 1),
(15, 4, 1),
(15, 5, 1),
(15, 6, 1),
(15, 7, 1),
(15, 8, 1),
(15, 9, 1),
(15, 10, 1),
(15, 11, 1),
(15, 12, 1),
(15, 13, 1),
(15, 14, 1),
(15, 15, 1),
(15, 16, 1),
(15, 17, 1),
(15, 18, 1),
(15, 19, 1),
(15, 20, 1),
(15, 21, 1),
(15, 22, 1),
(15, 23, 1),
(15, 24, 1),
(15, 25, 1),
(15, 26, 1),
(15, 27, 1),
(15, 28, 1),
(15, 29, 1),
(15, 30, 1),
(15, 31, 1),
(15, 32, 1),
(15, 33, 1),
(15, 34, 1),
(15, 35, 1),
(15, 36, 1),
(15, 37, 1),
(15, 38, 1),
(15, 39, 1),
(15, 40, 1),
(15, 41, 1),
(15, 42, 1),
(15, 43, 1),
(15, 44, 1),
(15, 45, 1),
(15, 46, 1),
(15, 47, 1),
(15, 48, 1),
(15, 49, 1),
(15, 50, 1),
(15, 51, 1),
(15, 52, 1),
(15, 53, 1),
(15, 54, 1),
(15, 55, 1),
(15, 56, 1),
(15, 57, 1),
(15, 58, 1),
(15, 59, 1),
(15, 60, 1),
(15, 61, 1),
(15, 62, 1),
(15, 63, 1),
(15, 64, 1),
(15, 65, 1),
(15, 66, 1),
(15, 67, 1),
(15, 68, 1),
(15, 69, 1),
(15, 70, 1),
(15, 71, 1),
(15, 72, 1),
(15, 73, 1),
(15, 74, 1),
(15, 75, 1),
(16, 1, 2),
(16, 2, 2),
(16, 3, 2),
(16, 4, 2),
(16, 5, 2),
(16, 6, 2),
(16, 7, 2),
(16, 8, 2),
(16, 9, 2),
(16, 10, 2),
(16, 11, 2),
(16, 12, 2),
(16, 13, 2),
(16, 14, 2),
(16, 15, 2),
(16, 16, 2),
(16, 17, 2),
(16, 18, 2),
(16, 19, 2),
(16, 20, 2),
(16, 21, 2),
(16, 22, 2),
(16, 23, 2),
(16, 24, 2),
(16, 25, 2),
(16, 26, 2),
(16, 27, 2),
(16, 28, 2),
(16, 29, 2),
(16, 30, 2),
(16, 31, 2),
(16, 32, 2),
(16, 33, 2),
(16, 34, 2),
(16, 35, 2),
(16, 36, 2),
(16, 37, 2),
(16, 38, 2),
(16, 39, 2),
(16, 40, 2),
(16, 41, 2),
(16, 42, 2),
(16, 43, 2),
(16, 44, 2),
(16, 45, 2),
(16, 46, 2),
(16, 47, 2),
(16, 48, 2),
(16, 49, 2),
(16, 50, 2),
(16, 51, 2),
(16, 52, 2),
(16, 53, 2),
(16, 54, 2),
(16, 55, 2),
(16, 56, 2),
(16, 57, 2),
(16, 58, 2),
(16, 59, 2),
(16, 60, 2),
(16, 61, 2),
(16, 62, 2),
(16, 63, 2),
(16, 64, 2),
(16, 65, 2),
(16, 66, 2),
(16, 67, 2),
(16, 68, 2),
(16, 69, 2),
(16, 70, 2),
(16, 71, 2),
(16, 72, 2),
(16, 73, 2),
(16, 74, 2),
(16, 75, 2),
(17, 1, 1),
(17, 2, 1),
(17, 3, 1),
(17, 4, 1),
(17, 5, 1),
(17, 6, 1),
(17, 7, 1),
(17, 8, 1),
(17, 9, 1),
(17, 10, 1),
(17, 11, 1),
(17, 12, 1),
(17, 13, 1),
(17, 14, 1),
(17, 15, 1),
(17, 16, 1),
(17, 17, 1),
(17, 18, 1),
(17, 19, 1),
(17, 20, 1),
(17, 21, 1),
(17, 22, 1),
(17, 23, 1),
(17, 24, 1),
(17, 25, 1),
(17, 26, 1),
(17, 27, 1),
(17, 28, 1),
(17, 29, 1),
(17, 30, 1),
(17, 31, 1),
(17, 32, 1),
(17, 33, 1),
(17, 34, 1),
(17, 35, 1),
(17, 36, 1),
(17, 37, 1),
(17, 38, 1),
(17, 39, 1),
(17, 40, 1),
(17, 41, 1),
(17, 42, 1),
(17, 43, 1),
(17, 44, 1),
(17, 45, 1),
(17, 46, 1),
(17, 47, 1),
(17, 48, 1),
(17, 49, 1),
(17, 50, 1),
(17, 51, 1),
(17, 52, 1),
(17, 53, 1),
(17, 54, 1),
(17, 55, 1),
(17, 56, 1),
(17, 57, 1),
(17, 58, 1),
(17, 59, 1),
(17, 60, 1),
(17, 61, 1),
(17, 62, 1),
(17, 63, 1),
(17, 64, 1),
(17, 65, 1),
(17, 66, 1),
(17, 67, 1),
(17, 68, 1),
(17, 69, 1),
(17, 70, 1),
(17, 71, 1),
(17, 72, 1),
(17, 73, 1),
(17, 74, 1),
(17, 75, 1),
(18, 1, 1),
(18, 2, 1),
(18, 3, 1),
(18, 4, 1),
(18, 5, 1),
(18, 6, 1),
(18, 7, 1),
(18, 8, 1),
(18, 9, 1),
(18, 10, 1),
(18, 11, 1),
(18, 12, 1),
(18, 13, 1),
(18, 14, 1),
(18, 15, 1),
(18, 16, 1),
(18, 17, 1),
(18, 18, 1),
(18, 19, 1),
(18, 20, 1),
(18, 21, 1),
(18, 22, 1),
(18, 23, 1),
(18, 24, 1),
(18, 25, 1),
(18, 26, 1),
(18, 27, 1),
(18, 28, 1),
(18, 29, 1),
(18, 30, 1),
(18, 31, 1),
(18, 32, 1),
(18, 33, 1),
(18, 34, 1),
(18, 35, 1),
(18, 36, 1),
(18, 37, 1),
(18, 38, 1),
(18, 39, 1),
(18, 40, 1),
(18, 41, 1),
(18, 42, 1),
(18, 43, 1),
(18, 44, 1),
(18, 45, 1),
(18, 46, 1),
(18, 47, 1),
(18, 48, 1),
(18, 49, 1),
(18, 50, 1),
(18, 51, 1),
(18, 52, 1),
(18, 53, 1),
(18, 54, 1),
(18, 55, 1),
(18, 56, 1),
(18, 57, 1),
(18, 58, 1),
(18, 59, 1),
(18, 60, 1),
(18, 61, 1),
(18, 62, 1),
(18, 63, 1),
(18, 64, 1),
(18, 65, 1),
(18, 66, 1),
(18, 67, 1),
(18, 68, 1),
(18, 69, 1),
(18, 70, 1),
(18, 71, 1),
(18, 72, 1),
(18, 73, 1),
(18, 74, 1),
(18, 75, 1),
(19, 1, 1),
(19, 2, 1),
(19, 3, 1),
(19, 4, 1),
(19, 5, 1),
(19, 6, 1),
(19, 7, 1),
(19, 8, 1),
(19, 9, 1),
(19, 10, 1),
(19, 11, 1),
(19, 12, 1),
(19, 13, 1),
(19, 14, 1),
(19, 15, 1),
(19, 16, 1),
(19, 17, 1),
(19, 18, 1),
(19, 19, 1),
(19, 20, 1),
(19, 21, 1),
(19, 22, 1),
(19, 23, 1),
(19, 24, 1),
(19, 25, 1),
(19, 26, 1),
(19, 27, 1),
(19, 28, 1),
(19, 29, 1),
(19, 30, 1),
(19, 31, 1),
(19, 32, 1),
(19, 33, 1),
(19, 34, 1),
(19, 35, 1),
(19, 36, 1),
(19, 37, 1),
(19, 38, 1),
(19, 39, 1),
(19, 40, 1),
(19, 41, 1),
(19, 42, 1),
(19, 43, 1),
(19, 44, 1),
(19, 45, 1),
(19, 46, 1),
(19, 47, 1),
(19, 48, 1),
(19, 49, 1),
(19, 50, 1),
(19, 51, 1),
(19, 52, 1),
(19, 53, 1),
(19, 54, 1),
(19, 55, 1),
(19, 56, 1),
(19, 57, 1),
(19, 58, 1),
(19, 59, 1),
(19, 60, 1),
(19, 61, 1),
(19, 62, 1),
(19, 63, 1),
(19, 64, 1),
(19, 65, 1),
(19, 66, 1),
(19, 67, 1),
(19, 68, 1),
(19, 69, 1),
(19, 70, 1),
(19, 71, 1),
(19, 72, 1),
(19, 73, 1),
(19, 74, 1),
(19, 75, 1),
(20, 1, 1),
(20, 2, 1),
(20, 3, 1),
(20, 4, 1),
(20, 5, 1),
(20, 6, 1),
(20, 7, 1),
(20, 8, 1),
(20, 9, 1),
(20, 10, 1),
(20, 11, 1),
(20, 12, 1),
(20, 13, 1),
(20, 14, 1),
(20, 15, 1),
(20, 16, 1),
(20, 17, 1),
(20, 18, 1),
(20, 19, 1),
(20, 20, 1),
(20, 21, 1),
(20, 22, 1),
(20, 23, 1),
(20, 24, 1),
(20, 25, 1),
(20, 26, 1),
(20, 27, 1),
(20, 28, 1),
(20, 29, 1),
(20, 30, 1),
(20, 31, 1),
(20, 32, 1),
(20, 33, 1),
(20, 34, 1),
(20, 35, 1),
(20, 36, 1),
(20, 37, 1),
(20, 38, 1),
(20, 39, 1),
(20, 40, 1),
(20, 41, 1),
(20, 42, 1),
(20, 43, 1),
(20, 44, 1),
(20, 45, 1),
(20, 46, 1),
(20, 47, 1),
(20, 48, 1),
(20, 49, 1),
(20, 50, 1),
(20, 51, 1),
(20, 52, 1),
(20, 53, 1),
(20, 54, 1),
(20, 55, 1),
(20, 56, 1),
(20, 57, 1),
(20, 58, 1),
(20, 59, 1),
(20, 60, 1),
(20, 61, 1),
(20, 62, 1),
(20, 63, 1),
(20, 64, 1),
(20, 65, 1),
(20, 66, 1),
(20, 67, 1),
(20, 68, 1),
(20, 69, 1),
(20, 70, 1),
(20, 71, 1),
(20, 72, 1),
(20, 73, 1),
(20, 74, 1),
(20, 75, 1),
(21, 1, 1),
(21, 2, 1),
(21, 3, 1),
(21, 4, 1),
(21, 5, 1),
(21, 6, 1),
(21, 7, 1),
(21, 8, 1),
(21, 9, 1),
(21, 10, 1),
(21, 11, 1),
(21, 12, 1),
(21, 13, 1),
(21, 14, 1),
(21, 15, 1),
(21, 16, 1),
(21, 17, 1),
(21, 18, 1),
(21, 19, 1),
(21, 20, 1),
(21, 21, 1),
(21, 22, 1),
(21, 23, 1),
(21, 24, 1),
(21, 25, 1),
(21, 26, 1),
(21, 27, 1),
(21, 28, 1),
(21, 29, 1),
(21, 30, 1),
(21, 31, 1),
(21, 32, 1),
(21, 33, 1),
(21, 34, 1),
(21, 35, 1),
(21, 36, 1),
(21, 37, 1),
(21, 38, 1),
(21, 39, 1),
(21, 40, 1),
(21, 41, 1),
(21, 42, 1),
(21, 43, 1),
(21, 44, 1),
(21, 45, 1),
(21, 46, 1),
(21, 47, 1),
(21, 48, 1),
(21, 49, 1),
(21, 50, 1),
(21, 51, 1),
(21, 52, 1),
(21, 53, 1),
(21, 54, 1),
(21, 55, 1),
(21, 56, 1),
(21, 57, 1),
(21, 58, 1),
(21, 59, 1),
(21, 60, 1),
(21, 61, 1),
(21, 62, 1),
(21, 63, 1),
(21, 64, 1),
(21, 65, 1),
(21, 66, 1),
(21, 67, 1),
(21, 68, 1),
(21, 69, 1),
(21, 70, 1),
(21, 71, 1),
(21, 72, 1),
(21, 73, 1),
(21, 74, 1),
(21, 75, 1),
(22, 1, 1),
(22, 2, 1),
(22, 3, 1),
(22, 4, 1),
(22, 5, 1),
(22, 6, 1),
(22, 7, 1),
(22, 8, 1),
(22, 9, 1),
(22, 10, 1),
(22, 11, 1),
(22, 12, 1),
(22, 13, 1),
(22, 14, 1),
(22, 15, 1),
(22, 16, 1),
(22, 17, 1),
(22, 18, 1),
(22, 19, 1),
(22, 20, 1),
(22, 21, 1),
(22, 22, 1),
(22, 23, 1),
(22, 24, 1),
(22, 25, 1),
(22, 26, 1),
(22, 27, 1),
(22, 28, 1),
(22, 29, 1),
(22, 30, 1),
(22, 31, 1),
(22, 32, 1),
(22, 33, 1),
(22, 34, 1),
(22, 35, 1),
(22, 36, 1),
(22, 37, 1),
(22, 38, 1),
(22, 39, 1),
(22, 40, 1),
(22, 41, 1),
(22, 42, 1),
(22, 43, 1),
(22, 44, 1),
(22, 45, 1),
(22, 46, 1),
(22, 47, 1),
(22, 48, 1),
(22, 49, 1),
(22, 50, 1),
(22, 51, 1),
(22, 52, 1),
(22, 53, 1),
(22, 54, 1),
(22, 55, 1),
(22, 56, 1),
(22, 57, 1),
(22, 58, 1),
(22, 59, 1),
(22, 60, 1),
(22, 61, 1),
(22, 62, 1),
(22, 63, 1),
(22, 64, 1),
(22, 65, 1),
(22, 66, 1),
(22, 67, 1),
(22, 68, 1),
(22, 69, 1),
(22, 70, 1),
(22, 71, 1),
(22, 72, 1),
(22, 73, 1),
(22, 74, 1),
(22, 75, 1),
(23, 1, 1),
(23, 2, 1),
(23, 3, 1),
(23, 4, 1),
(23, 5, 1),
(23, 6, 1),
(23, 7, 1),
(23, 8, 1),
(23, 9, 1),
(23, 10, 1),
(23, 11, 1),
(23, 12, 1),
(23, 13, 1),
(23, 14, 1),
(23, 15, 1),
(23, 16, 1),
(23, 17, 1),
(23, 18, 1),
(23, 19, 1),
(23, 20, 1),
(23, 21, 1),
(23, 22, 1),
(23, 23, 1),
(23, 24, 1),
(23, 25, 1),
(23, 26, 1),
(23, 27, 1),
(23, 28, 1),
(23, 29, 1),
(23, 30, 1),
(23, 31, 1),
(23, 32, 1),
(23, 33, 1),
(23, 34, 1),
(23, 35, 1),
(23, 36, 1),
(23, 37, 1),
(23, 38, 1),
(23, 39, 1),
(23, 40, 1),
(23, 41, 1),
(23, 42, 1),
(23, 43, 1),
(23, 44, 1),
(23, 45, 1),
(23, 46, 1),
(23, 47, 1),
(23, 48, 1),
(23, 49, 1),
(23, 50, 1),
(23, 51, 1),
(23, 52, 1),
(23, 53, 1),
(23, 54, 1),
(23, 55, 1),
(23, 56, 1),
(23, 57, 1),
(23, 58, 1),
(23, 59, 1),
(23, 60, 1),
(23, 61, 1),
(23, 62, 1),
(23, 63, 1),
(23, 64, 1),
(23, 65, 1),
(23, 66, 1),
(23, 67, 1),
(23, 68, 1),
(23, 69, 1),
(23, 70, 1),
(23, 71, 1),
(23, 72, 1),
(23, 73, 1),
(23, 74, 1),
(23, 75, 1),
(24, 1, 2),
(24, 2, 2),
(24, 3, 2),
(24, 4, 2),
(24, 5, 2),
(24, 6, 2),
(24, 7, 2),
(24, 8, 2),
(24, 9, 2),
(24, 10, 2),
(24, 11, 2),
(24, 12, 2),
(24, 13, 2),
(24, 14, 2),
(24, 15, 2),
(24, 16, 2),
(24, 17, 2),
(24, 18, 2),
(24, 19, 2),
(24, 20, 2),
(24, 21, 2),
(24, 22, 2),
(24, 23, 2),
(24, 24, 2),
(24, 25, 2),
(24, 26, 2),
(24, 27, 2),
(24, 28, 2),
(24, 29, 2),
(24, 30, 2),
(24, 31, 2),
(24, 32, 2),
(24, 33, 2),
(24, 34, 2),
(24, 35, 2),
(24, 36, 2),
(24, 37, 2),
(24, 38, 2),
(24, 39, 2),
(24, 40, 2),
(24, 41, 2),
(24, 42, 2),
(24, 43, 2),
(24, 44, 2),
(24, 45, 2),
(24, 46, 2),
(24, 47, 2),
(24, 48, 2),
(24, 49, 2),
(24, 50, 2),
(24, 51, 2),
(24, 52, 2),
(24, 53, 2),
(24, 54, 2),
(24, 55, 2),
(24, 56, 2),
(24, 57, 2),
(24, 58, 2),
(24, 59, 2),
(24, 60, 2),
(24, 61, 2),
(24, 62, 2),
(24, 63, 2),
(24, 64, 2),
(24, 65, 2),
(24, 66, 2),
(24, 67, 2),
(24, 68, 2),
(24, 69, 2),
(24, 70, 2),
(24, 71, 2),
(24, 72, 2),
(24, 73, 2),
(24, 74, 2),
(24, 75, 2),
(25, 1, 3),
(25, 2, 3),
(25, 3, 3),
(25, 4, 3),
(25, 5, 3),
(25, 6, 3),
(25, 7, 3),
(25, 8, 3),
(25, 9, 3),
(25, 10, 3),
(25, 11, 3),
(25, 12, 3),
(25, 13, 3),
(25, 14, 3),
(25, 15, 3),
(25, 16, 3),
(25, 17, 3),
(25, 18, 3),
(25, 19, 3),
(25, 20, 3),
(25, 21, 3),
(25, 22, 3),
(25, 23, 3),
(25, 24, 3),
(25, 25, 3),
(25, 26, 3),
(25, 27, 3),
(25, 28, 3),
(25, 29, 3),
(25, 30, 3),
(25, 31, 3),
(25, 32, 3),
(25, 33, 3),
(25, 34, 3),
(25, 35, 3),
(25, 36, 3),
(25, 37, 3),
(25, 38, 3),
(25, 39, 3),
(25, 40, 3),
(25, 41, 3),
(25, 42, 3),
(25, 43, 3),
(25, 44, 3),
(25, 45, 3),
(25, 46, 3),
(25, 47, 3),
(25, 48, 3),
(25, 49, 3),
(25, 50, 3),
(25, 51, 3),
(25, 52, 3),
(25, 53, 3),
(25, 54, 3),
(25, 55, 3),
(25, 56, 3),
(25, 57, 3),
(25, 58, 3),
(25, 59, 3),
(25, 60, 3),
(25, 61, 3),
(25, 62, 3),
(25, 63, 3),
(25, 64, 3),
(25, 65, 3),
(25, 66, 3),
(25, 67, 3),
(25, 68, 3),
(25, 69, 3),
(25, 70, 3),
(25, 71, 3),
(25, 72, 3),
(25, 73, 3),
(25, 74, 3),
(25, 75, 3),
(26, 1, 1),
(26, 2, 1),
(26, 3, 1),
(26, 4, 1),
(26, 5, 1),
(26, 6, 1),
(26, 7, 1),
(26, 8, 1),
(26, 9, 1),
(26, 10, 1),
(26, 11, 1),
(26, 12, 1),
(26, 13, 1),
(26, 14, 1),
(26, 15, 1),
(26, 16, 1),
(26, 17, 1),
(26, 18, 1),
(26, 19, 1),
(26, 20, 1),
(26, 21, 1),
(26, 22, 1),
(26, 23, 1),
(26, 24, 1),
(26, 25, 1),
(26, 26, 1),
(26, 27, 1),
(26, 28, 1),
(26, 29, 1),
(26, 30, 1),
(26, 31, 1),
(26, 32, 1),
(26, 33, 1),
(26, 34, 1),
(26, 35, 1),
(26, 36, 1),
(26, 37, 1),
(26, 38, 1),
(26, 39, 1),
(26, 40, 1),
(26, 41, 1),
(26, 42, 1),
(26, 43, 1),
(26, 44, 1),
(26, 45, 1),
(26, 46, 1),
(26, 47, 1),
(26, 48, 1),
(26, 49, 1),
(26, 50, 1),
(26, 51, 1),
(26, 52, 1),
(26, 53, 1),
(26, 54, 1),
(26, 55, 1),
(26, 56, 1),
(26, 57, 1),
(26, 58, 1),
(26, 59, 1),
(26, 60, 1),
(26, 61, 1),
(26, 62, 1),
(26, 63, 1),
(26, 64, 1),
(26, 65, 1),
(26, 66, 1),
(26, 67, 1),
(26, 68, 1),
(26, 69, 1),
(26, 70, 1),
(26, 71, 1),
(26, 72, 1),
(26, 73, 1),
(26, 74, 1),
(26, 75, 1),
(27, 1, 2),
(27, 2, 2),
(27, 3, 2),
(27, 4, 2),
(27, 5, 2),
(27, 6, 2),
(27, 7, 2),
(27, 8, 2),
(27, 9, 2),
(27, 10, 2),
(27, 11, 2),
(27, 12, 2),
(27, 13, 2),
(27, 14, 2),
(27, 15, 2),
(27, 16, 2),
(27, 17, 2),
(27, 18, 2),
(27, 19, 2),
(27, 20, 2),
(27, 21, 2),
(27, 22, 2),
(27, 23, 2),
(27, 24, 2),
(27, 25, 2),
(27, 26, 2),
(27, 27, 2),
(27, 28, 2),
(27, 29, 2),
(27, 30, 2),
(27, 31, 2),
(27, 32, 2),
(27, 33, 2),
(27, 34, 2),
(27, 35, 2),
(27, 36, 2),
(27, 37, 2),
(27, 38, 2),
(27, 39, 2),
(27, 40, 2),
(27, 41, 2),
(27, 42, 2),
(27, 43, 2),
(27, 44, 2),
(27, 45, 2),
(27, 46, 2),
(27, 47, 2),
(27, 48, 2),
(27, 49, 2),
(27, 50, 2),
(27, 51, 2),
(27, 52, 2),
(27, 53, 2),
(27, 54, 2),
(27, 55, 2),
(27, 56, 2),
(27, 57, 2),
(27, 58, 2),
(27, 59, 2),
(27, 60, 2),
(27, 61, 2),
(27, 62, 2),
(27, 63, 2),
(27, 64, 2),
(27, 65, 2),
(27, 66, 2),
(27, 67, 2),
(27, 68, 2),
(27, 69, 2),
(27, 70, 2),
(27, 71, 2),
(27, 72, 2),
(27, 73, 2),
(27, 74, 2),
(27, 75, 2),
(28, 1, 3),
(28, 2, 3),
(28, 3, 3),
(28, 4, 3),
(28, 5, 3),
(28, 6, 3),
(28, 7, 3),
(28, 8, 3),
(28, 9, 3),
(28, 10, 3),
(28, 11, 3),
(28, 12, 3),
(28, 13, 3),
(28, 14, 3),
(28, 15, 3),
(28, 16, 3),
(28, 17, 3),
(28, 18, 3),
(28, 19, 3),
(28, 20, 3),
(28, 21, 3),
(28, 22, 3),
(28, 23, 3),
(28, 24, 3),
(28, 25, 3),
(28, 26, 3),
(28, 27, 3),
(28, 28, 3),
(28, 29, 3),
(28, 30, 3),
(28, 31, 3),
(28, 32, 3),
(28, 33, 3),
(28, 34, 3),
(28, 35, 3),
(28, 36, 3),
(28, 37, 3),
(28, 38, 3),
(28, 39, 3),
(28, 40, 3),
(28, 41, 3),
(28, 42, 3),
(28, 43, 3),
(28, 44, 3),
(28, 45, 3),
(28, 46, 3),
(28, 47, 3),
(28, 48, 3),
(28, 49, 3),
(28, 50, 3),
(28, 51, 3),
(28, 52, 3),
(28, 53, 3),
(28, 54, 3),
(28, 55, 3),
(28, 56, 3),
(28, 57, 3),
(28, 58, 3),
(28, 59, 3),
(28, 60, 3),
(28, 61, 3),
(28, 62, 3),
(28, 63, 3),
(28, 64, 3),
(28, 65, 3),
(28, 66, 3),
(28, 67, 3),
(28, 68, 3),
(28, 69, 3),
(28, 70, 3),
(28, 71, 3),
(28, 72, 3),
(28, 73, 3),
(28, 74, 3),
(28, 75, 3),
(29, 1, 4),
(29, 2, 4),
(29, 3, 4),
(29, 4, 4),
(29, 5, 4),
(29, 6, 4),
(29, 7, 4),
(29, 8, 4),
(29, 9, 4),
(29, 10, 4),
(29, 11, 4),
(29, 12, 4),
(29, 13, 4),
(29, 14, 4),
(29, 15, 4),
(29, 16, 4),
(29, 17, 4),
(29, 18, 4),
(29, 19, 4),
(29, 20, 4),
(29, 21, 4),
(29, 22, 4),
(29, 23, 4),
(29, 24, 4),
(29, 25, 4),
(29, 26, 4),
(29, 27, 4),
(29, 28, 4),
(29, 29, 4),
(29, 30, 4),
(29, 31, 4),
(29, 32, 4),
(29, 33, 4),
(29, 34, 4),
(29, 35, 4),
(29, 36, 4),
(29, 37, 4),
(29, 38, 4),
(29, 39, 4),
(29, 40, 4),
(29, 41, 4),
(29, 42, 4),
(29, 43, 4),
(29, 44, 4),
(29, 45, 4),
(29, 46, 4),
(29, 47, 4),
(29, 48, 4),
(29, 49, 4),
(29, 50, 4),
(29, 51, 4),
(29, 52, 4),
(29, 53, 4),
(29, 54, 4),
(29, 55, 4),
(29, 56, 4),
(29, 57, 4),
(29, 58, 4),
(29, 59, 4),
(29, 60, 4),
(29, 61, 4),
(29, 62, 4),
(29, 63, 4),
(29, 64, 4),
(29, 65, 4),
(29, 66, 4),
(29, 67, 4),
(29, 68, 4),
(29, 69, 4),
(29, 70, 4),
(29, 71, 4),
(29, 72, 4),
(29, 73, 4),
(29, 74, 4),
(29, 75, 4),
(30, 1, 1),
(30, 2, 1),
(30, 3, 1),
(30, 4, 1),
(30, 5, 1),
(30, 6, 1),
(30, 7, 1),
(30, 8, 1),
(30, 9, 1),
(30, 10, 1),
(30, 11, 1),
(30, 12, 1),
(30, 13, 1),
(30, 14, 1),
(30, 15, 1),
(30, 16, 1),
(30, 17, 1),
(30, 18, 1),
(30, 19, 1),
(30, 20, 1),
(30, 21, 1),
(30, 22, 1),
(30, 23, 1),
(30, 24, 1),
(30, 25, 1),
(30, 26, 1),
(30, 27, 1),
(30, 28, 1),
(30, 29, 1),
(30, 30, 1),
(30, 31, 1),
(30, 32, 1),
(30, 33, 1),
(30, 34, 1),
(30, 35, 1),
(30, 36, 1),
(30, 37, 1),
(30, 38, 1),
(30, 39, 1),
(30, 40, 1),
(30, 41, 1),
(30, 42, 1),
(30, 43, 1),
(30, 44, 1),
(30, 45, 1),
(30, 46, 1),
(30, 47, 1),
(30, 48, 1),
(30, 49, 1),
(30, 50, 1),
(30, 51, 1),
(30, 52, 1),
(30, 53, 1),
(30, 54, 1),
(30, 55, 1),
(30, 56, 1),
(30, 57, 1),
(30, 58, 1),
(30, 59, 1),
(30, 60, 1),
(30, 61, 1),
(30, 62, 1),
(30, 63, 1),
(30, 64, 1),
(30, 65, 1),
(30, 66, 1),
(30, 67, 1),
(30, 68, 1),
(30, 69, 1),
(30, 70, 1),
(30, 71, 1),
(30, 72, 1),
(30, 73, 1),
(30, 74, 1),
(30, 75, 1),
(31, 1, 1),
(31, 2, 1),
(31, 3, 1),
(31, 4, 1),
(31, 5, 1),
(31, 6, 1),
(31, 7, 1),
(31, 8, 1),
(31, 9, 1),
(31, 10, 1),
(31, 11, 1),
(31, 12, 1),
(31, 13, 1),
(31, 14, 1),
(31, 15, 1),
(31, 16, 1),
(31, 17, 1),
(31, 18, 1),
(31, 19, 1),
(31, 20, 1),
(31, 21, 1),
(31, 22, 1),
(31, 23, 1),
(31, 24, 1),
(31, 25, 1),
(31, 26, 1),
(31, 27, 1),
(31, 28, 1),
(31, 29, 1),
(31, 30, 1),
(31, 31, 1),
(31, 32, 1),
(31, 33, 1),
(31, 34, 1),
(31, 35, 1),
(31, 36, 1),
(31, 37, 1),
(31, 38, 1),
(31, 39, 1),
(31, 40, 1),
(31, 41, 1),
(31, 42, 1),
(31, 43, 1),
(31, 44, 1),
(31, 45, 1),
(31, 46, 1),
(31, 47, 1),
(31, 48, 1),
(31, 49, 1),
(31, 50, 1),
(31, 51, 1),
(31, 52, 1),
(31, 53, 1),
(31, 54, 1),
(31, 55, 1),
(31, 56, 1),
(31, 57, 1),
(31, 58, 1),
(31, 59, 1),
(31, 60, 1),
(31, 61, 1),
(31, 62, 1),
(31, 63, 1),
(31, 64, 1),
(31, 65, 1),
(31, 66, 1),
(31, 67, 1),
(31, 68, 1),
(31, 69, 1),
(31, 70, 1),
(31, 71, 1),
(31, 72, 1),
(31, 73, 1),
(31, 74, 1),
(31, 75, 1),
(32, 1, 1),
(32, 2, 1),
(32, 3, 1),
(32, 4, 1),
(32, 5, 1),
(32, 6, 1),
(32, 7, 1),
(32, 8, 1),
(32, 9, 1),
(32, 10, 1),
(32, 11, 1),
(32, 12, 1),
(32, 13, 1),
(32, 14, 1),
(32, 15, 1),
(32, 16, 1),
(32, 17, 1),
(32, 18, 1),
(32, 19, 1),
(32, 20, 1),
(32, 21, 1),
(32, 22, 1),
(32, 23, 1),
(32, 24, 1),
(32, 25, 1),
(32, 26, 1),
(32, 27, 1),
(32, 28, 1),
(32, 29, 1),
(32, 30, 1),
(32, 31, 1),
(32, 32, 1),
(32, 33, 1),
(32, 34, 1),
(32, 35, 1),
(32, 36, 1),
(32, 37, 1),
(32, 38, 1),
(32, 39, 1),
(32, 40, 1),
(32, 41, 1),
(32, 42, 1),
(32, 43, 1),
(32, 44, 1),
(32, 45, 1),
(32, 46, 1),
(32, 47, 1),
(32, 48, 1),
(32, 49, 1),
(32, 50, 1),
(32, 51, 1),
(32, 52, 1),
(32, 53, 1),
(32, 54, 1),
(32, 55, 1),
(32, 56, 1),
(32, 57, 1),
(32, 58, 1),
(32, 59, 1),
(32, 60, 1),
(32, 61, 1),
(32, 62, 1),
(32, 63, 1),
(32, 64, 1),
(32, 65, 1),
(32, 66, 1),
(32, 67, 1),
(32, 68, 1),
(32, 69, 1),
(32, 70, 1),
(32, 71, 1),
(32, 72, 1),
(32, 73, 1),
(32, 74, 1),
(32, 75, 1);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_vi_comment`
--

DROP TABLE IF EXISTS `nv5_vi_comment`;
CREATE TABLE `nv5_vi_comment` (
  `cid` mediumint(8) UNSIGNED NOT NULL,
  `module` varchar(55) NOT NULL,
  `area` char(50) NOT NULL DEFAULT '',
  `id` char(50) NOT NULL DEFAULT '',
  `pid` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `content` text NOT NULL,
  `attach` varchar(255) NOT NULL DEFAULT '',
  `post_time` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `userid` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `post_name` varchar(100) NOT NULL,
  `post_email` varchar(100) NOT NULL,
  `post_ip` varchar(39) NOT NULL DEFAULT '',
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `likes` mediumint(9) NOT NULL DEFAULT 0,
  `dislikes` mediumint(9) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_vi_contact_department`
--

DROP TABLE IF EXISTS `nv5_vi_contact_department`;
CREATE TABLE `nv5_vi_contact_department` (
  `id` smallint(5) UNSIGNED NOT NULL,
  `full_name` varchar(250) NOT NULL,
  `alias` varchar(250) NOT NULL,
  `image` varchar(255) NOT NULL DEFAULT '',
  `phone` varchar(255) NOT NULL,
  `fax` varchar(255) NOT NULL,
  `email` varchar(100) NOT NULL,
  `address` varchar(255) NOT NULL,
  `note` text NOT NULL,
  `others` text NOT NULL,
  `cats` text NOT NULL,
  `admins` text NOT NULL,
  `act` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `weight` smallint(5) NOT NULL,
  `is_default` tinyint(1) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_vi_contact_department`
--

INSERT INTO `nv5_vi_contact_department` (`id`, `full_name`, `alias`, `image`, `phone`, `fax`, `email`, `address`, `note`, `others`, `cats`, `admins`, `act`, `weight`, `is_default`) VALUES
(1, 'Phòng Chăm sóc khách hàng', 'Cham-soc-khach-hang', '', '(08) 38.000.000[+84838000000]', '08 38.000.001', 'customer@mysite.com', '', 'Bộ phận tiếp nhận và giải quyết các yêu cầu, đề nghị, ý kiến liên quan đến hoạt động chính của doanh nghiệp', '{\"viber\":\"myViber\",\"skype\":\"mySkype\",\"zalo\":\"0933456789\"}', '[\"Tư vấn\",\"Khiếu nại, phản ánh\",\"Đề nghị hợp tác\"]', '', 1, 1, 1),
(2, 'Phòng Kỹ thuật', 'Ky-thuat', '', '(08) 38.000.002[+84838000002]', '08 38.000.003', 'technical@mysite.com', '', 'Bộ phận tiếp nhận và giải quyết các câu hỏi liên quan đến kỹ thuật', '{\"viber\":\"myViber2\",\"skype\":\"mySkype2\",\"zalo\":\"0923456789\"}', '[\"Thông báo lỗi\",\"Góp ý cải tiến\"]', '', 1, 2, 0);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_vi_contact_reply`
--

DROP TABLE IF EXISTS `nv5_vi_contact_reply`;
CREATE TABLE `nv5_vi_contact_reply` (
  `rid` mediumint(8) UNSIGNED NOT NULL,
  `id` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `reply_recipient` varchar(255) NOT NULL DEFAULT '',
  `reply_cc` varchar(255) NOT NULL DEFAULT '',
  `reply_content` text DEFAULT NULL,
  `reply_time` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `reply_aid` mediumint(8) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_vi_contact_send`
--

DROP TABLE IF EXISTS `nv5_vi_contact_send`;
CREATE TABLE `nv5_vi_contact_send` (
  `id` mediumint(8) UNSIGNED NOT NULL,
  `cid` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `cat` varchar(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `send_time` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `sender_id` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `sender_name` varchar(100) NOT NULL,
  `sender_address` varchar(250) NOT NULL,
  `sender_email` varchar(100) NOT NULL,
  `sender_phone` varchar(20) DEFAULT '',
  `sender_ip` varchar(39) NOT NULL DEFAULT '',
  `auto_forward` varchar(250) NOT NULL DEFAULT '',
  `is_read` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `is_reply` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `read_admins` text DEFAULT NULL,
  `is_processed` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `processed_by` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `processed_time` int(11) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_vi_contact_supporter`
--

DROP TABLE IF EXISTS `nv5_vi_contact_supporter`;
CREATE TABLE `nv5_vi_contact_supporter` (
  `id` smallint(5) UNSIGNED NOT NULL,
  `departmentid` smallint(5) UNSIGNED NOT NULL,
  `full_name` varchar(255) NOT NULL,
  `image` varchar(255) NOT NULL DEFAULT '',
  `phone` varchar(255) NOT NULL,
  `email` varchar(100) NOT NULL,
  `others` text NOT NULL,
  `act` tinyint(1) UNSIGNED NOT NULL DEFAULT 1,
  `weight` smallint(5) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_vi_freecontent_blocks`
--

DROP TABLE IF EXISTS `nv5_vi_freecontent_blocks`;
CREATE TABLE `nv5_vi_freecontent_blocks` (
  `bid` mediumint(8) UNSIGNED NOT NULL,
  `title` varchar(255) NOT NULL DEFAULT '',
  `description` mediumtext NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_vi_freecontent_blocks`
--

INSERT INTO `nv5_vi_freecontent_blocks` (`bid`, `title`, `description`) VALUES
(1, 'Sản phẩm', 'Sản phẩm của công ty cổ phần phát triển nguồn mở Việt Nam - VINADES.,JSC');

-- --------------------------------------------------------

--
-- Table structure for table `nv5_vi_freecontent_rows`
--

DROP TABLE IF EXISTS `nv5_vi_freecontent_rows`;
CREATE TABLE `nv5_vi_freecontent_rows` (
  `id` mediumint(8) UNSIGNED NOT NULL,
  `bid` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `title` varchar(255) NOT NULL DEFAULT '',
  `description` mediumtext NOT NULL,
  `link` varchar(255) NOT NULL DEFAULT '',
  `target` varchar(10) NOT NULL DEFAULT '' COMMENT '_blank|_self|_parent|_top',
  `image` varchar(255) NOT NULL DEFAULT '',
  `start_time` int(11) NOT NULL DEFAULT 0,
  `end_time` int(11) NOT NULL DEFAULT 0,
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0: In-Active, 1: Active, 2: Expired'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_vi_freecontent_rows`
--

INSERT INTO `nv5_vi_freecontent_rows` (`id`, `bid`, `title`, `description`, `link`, `target`, `image`, `start_time`, `end_time`, `status`) VALUES
(1, 1, 'Hệ quản trị nội dung NukeViet', '<ul>\n	<li>Giải thưởng Nhân tài đất Việt 2011, 10.000+ website đang sử dụng</li>\n	<li>Được Bộ GD&amp;ĐT khuyến khích sử dụng trong các cơ sở giáo dục</li>\n	<li>Bộ TT&amp;TT quy định ưu tiên sử dụng trong cơ quan nhà nước</li>\n</ul>', 'https://vinades.vn/vi/san-pham/nukeviet/', '_blank', 'cms.jpg', 1742685231, 0, 1),
(2, 1, 'Cổng thông tin doanh nghiệp', '<ul>\n	<li>Tích hợp bán hàng trực tuyến</li>\n	<li>Tích hợp các nghiệp vụ quản lý (quản lý khách hàng, quản lý nhân sự, quản lý tài liệu)</li>\n</ul>', 'https://vinades.vn/vi/san-pham/Cong-thong-tin-doanh-nghiep-NukeViet-portal/', '_blank', 'portal.jpg', 1742685231, 0, 1),
(3, 1, 'Cổng thông tin Phòng giáo dục, Sở giáo dục', '<ul>\n	<li>Tích hợp chung website hàng trăm trường</li>\n	<li>Tích hợp các ứng dụng trực tuyến (Tra điểm SMS, Tra cứu văn bằng, Học bạ điện tử ...)</li>\n</ul>', 'https://vinades.vn/vi/san-pham/Cong-thong-tin-giao-duc-NukeViet-Edugate/', '_blank', 'edugate.jpg', 1742685231, 0, 1),
(4, 1, 'Tòa soạn báo điện tử chuyên nghiệp', '<ul>\n	<li>Bảo mật đa tầng, phân quyền linh hoạt</li>\n	<li>Hệ thống bóc tin tự động, đăng bài tự động, cùng nhiều chức năng tiên tiến khác...</li>\n</ul>', 'https://vinades.vn/vi/san-pham/Toa-soan-bao-dien-tu/', '_blank', 'toa-soan-dien-tu.jpg', 1742685231, 0, 1),
(5, 1, 'Giải pháp bán hàng trực tuyến', '<ul><li>Tích hợp các tính năng cơ bản bán hàng trực tuyến</li><li>Tích hợp với các cổng thanh toán, ví điện tử trên toàn quốc</li></ul>', 'https://vinades.vn', '_blank', 'shop.jpg', 1742685231, 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_vi_menu`
--

DROP TABLE IF EXISTS `nv5_vi_menu`;
CREATE TABLE `nv5_vi_menu` (
  `id` smallint(5) UNSIGNED NOT NULL,
  `title` varchar(50) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_vi_menu`
--

INSERT INTO `nv5_vi_menu` (`id`, `title`) VALUES
(1, 'Top Menu');

-- --------------------------------------------------------

--
-- Table structure for table `nv5_vi_menu_rows`
--

DROP TABLE IF EXISTS `nv5_vi_menu_rows`;
CREATE TABLE `nv5_vi_menu_rows` (
  `id` mediumint(5) NOT NULL,
  `parentid` mediumint(5) UNSIGNED NOT NULL,
  `mid` smallint(5) NOT NULL DEFAULT 0,
  `title` varchar(255) NOT NULL,
  `link` text NOT NULL,
  `icon` varchar(255) DEFAULT '',
  `image` varchar(255) DEFAULT '',
  `note` varchar(255) DEFAULT '',
  `weight` int(11) NOT NULL,
  `sort` int(11) NOT NULL DEFAULT 0,
  `lev` int(11) NOT NULL DEFAULT 0,
  `subitem` text DEFAULT NULL,
  `groups_view` varchar(255) DEFAULT '',
  `module_name` varchar(255) DEFAULT '',
  `op` varchar(255) DEFAULT '',
  `target` tinyint(4) DEFAULT 0,
  `css` varchar(255) DEFAULT '',
  `active_type` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_vi_menu_rows`
--

INSERT INTO `nv5_vi_menu_rows` (`id`, `parentid`, `mid`, `title`, `link`, `icon`, `image`, `note`, `weight`, `sort`, `lev`, `subitem`, `groups_view`, `module_name`, `op`, `target`, `css`, `active_type`, `status`) VALUES
(1, 0, 1, 'Giới thiệu', '/index.php?language=vi&nv=about', '', '', '', 1, 1, 0, '8,9,10,11,12,13,14,15', '6', 'about', '', 1, '', 1, 1),
(2, 0, 1, 'Tin Tức', '/index.php?language=vi&nv=news', '', '', '', 2, 10, 0, '16,17,18,19,20,21,22', '6', 'news', '', 1, '', 1, 1),
(3, 0, 1, 'Tài khoản người dùng', '/index.php?language=vi&nv=users', '', '', '', 3, 18, 0, '', '6', 'users', '', 1, '', 1, 1),
(4, 0, 1, 'Thống kê', '/index.php?language=vi&nv=statistics', '', '', '', 4, 19, 0, '', '2', 'statistics', '', 1, '', 1, 1),
(5, 0, 1, 'Thăm dò ý kiến', '/index.php?language=vi&nv=voting', '', '', '', 5, 20, 0, '', '6', 'voting', '', 1, '', 1, 1),
(6, 0, 1, 'Tìm kiếm', '/index.php?language=vi&nv=seek', '', '', '', 6, 21, 0, '', '6', 'seek', '', 1, '', 1, 1),
(7, 0, 1, 'Liên hệ', '/index.php?language=vi&nv=contact', '', '', '', 7, 22, 0, '', '6', 'contact', '', 1, '', 1, 1),
(8, 1, 1, 'Giới thiệu về NukeViet', '/index.php?language=vi&nv=about&op=gioi-thieu-ve-nukeviet.html', '', '', '', 1, 2, 1, '', '6', 'about', 'gioi-thieu-ve-nukeviet', 1, '', 1, 1),
(9, 1, 1, 'Giới thiệu về NukeViet CMS', '/index.php?language=vi&nv=about&op=gioi-thieu-ve-nukeviet-cms.html', '', '', '', 2, 3, 1, '', '6', 'about', 'gioi-thieu-ve-nukeviet-cms', 1, '', 1, 1),
(10, 1, 1, 'Logo và tên gọi NukeViet', '/index.php?language=vi&nv=about&op=logo-va-ten-goi-nukeviet.html', '', '', '', 3, 4, 1, '', '6', 'about', 'logo-va-ten-goi-nukeviet', 1, '', 1, 1),
(11, 1, 1, 'Giấy phép sử dụng NukeViet', '/index.php?language=vi&nv=about&op=giay-phep-su-dung-nukeviet.html', '', '', '', 4, 5, 1, '', '6,7', 'about', 'giay-phep-su-dung-nukeviet', 1, '', 1, 1),
(12, 1, 1, 'Những tính năng của NukeViet CMS 4.0', '/index.php?language=vi&nv=about&op=nhung-tinh-nang-cua-nukeviet-cms-4-0.html', '', '', '', 5, 6, 1, '', '6', 'about', 'nhung-tinh-nang-cua-nukeviet-cms-4-0', 1, '', 1, 1),
(13, 1, 1, 'Yêu cầu sử dụng NukeViet 4', '/index.php?language=vi&nv=about&op=Yeu-cau-su-dung-NukeViet-4.html', '', '', '', 6, 7, 1, '', '6', 'about', 'Yeu-cau-su-dung-NukeViet-4', 1, '', 1, 1),
(14, 1, 1, 'Giới thiệu về Công ty cổ phần phát triển nguồn mở Việt Nam', '/index.php?language=vi&nv=about&op=gioi-thieu-ve-cong-ty-co-phan-phat-trien-nguon-mo-viet-nam.html', '', '', '', 7, 8, 1, '', '6', 'about', 'gioi-thieu-ve-cong-ty-co-phan-phat-trien-nguon-mo-viet-nam', 1, '', 1, 1),
(15, 1, 1, 'Ủng hộ, hỗ trợ và tham gia phát triển NukeViet', '/index.php?language=vi&nv=about&op=ung-ho-ho-tro-va-tham-gia-phat-trien-nukeviet.html', '', '', '', 8, 9, 1, '', '6', 'about', 'ung-ho-ho-tro-va-tham-gia-phat-trien-nukeviet', 1, '', 1, 1),
(16, 2, 1, 'Đối tác', '/index.php?language=vi&nv=news&op=Doi-tac', '', '', '', 1, 11, 1, '', '6', 'news', 'Doi-tac', 1, '', 1, 1),
(17, 2, 1, 'Tuyển dụng', '/index.php?language=vi&nv=news&op=Tuyen-dung', '', '', '', 2, 12, 1, '', '6', 'news', 'Tuyen-dung', 1, '', 1, 1),
(18, 2, 1, 'Rss', '/index.php?language=vi&nv=news&op=rss', '', '', '', 3, 13, 1, '', '6', 'news', 'rss', 1, '', 1, 1),
(19, 2, 1, 'Quản lý bài viết', '/index.php?language=vi&nv=news&op=content', '', '', '', 4, 14, 1, '', '6', 'news', 'content', 1, '', 1, 1),
(20, 2, 1, 'Tìm kiếm', '/index.php?language=vi&nv=news&op=search', '', '', '', 5, 15, 1, '', '6', 'news', 'search', 1, '', 1, 1),
(21, 2, 1, 'Tin tức', '/index.php?language=vi&nv=news&op=Tin-tuc', '', '', '', 6, 16, 1, '', '6', 'news', 'Tin-tuc', 1, '', 1, 1),
(22, 2, 1, 'Sản phẩm', '/index.php?language=vi&nv=news&op=San-pham', '', '', '', 7, 17, 1, '', '6', 'news', 'San-pham', 1, '', 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_vi_modfuncs`
--

DROP TABLE IF EXISTS `nv5_vi_modfuncs`;
CREATE TABLE `nv5_vi_modfuncs` (
  `func_id` mediumint(8) UNSIGNED NOT NULL,
  `func_name` varchar(55) NOT NULL,
  `alias` varchar(55) NOT NULL DEFAULT '',
  `func_custom_name` varchar(255) NOT NULL,
  `func_site_title` varchar(255) NOT NULL DEFAULT '',
  `description` varchar(255) NOT NULL DEFAULT '',
  `in_module` varchar(50) NOT NULL,
  `show_func` tinyint(4) NOT NULL DEFAULT 0,
  `in_submenu` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `subweight` smallint(2) UNSIGNED NOT NULL DEFAULT 1,
  `setting` varchar(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Func của module';

--
-- Dumping data for table `nv5_vi_modfuncs`
--

INSERT INTO `nv5_vi_modfuncs` (`func_id`, `func_name`, `alias`, `func_custom_name`, `func_site_title`, `description`, `in_module`, `show_func`, `in_submenu`, `subweight`, `setting`) VALUES
(1, 'main', 'main', 'Main', '', '', 'about', 1, 0, 1, ''),
(2, 'sitemap', 'sitemap', 'Sitemap', '', '', 'about', 0, 0, 0, ''),
(3, 'rss', 'rss', 'Rss', '', '', 'about', 0, 0, 0, ''),
(4, 'main', 'main', 'Main', '', '', 'news', 1, 0, 1, ''),
(5, 'viewcat', 'viewcat', 'Viewcat', '', '', 'news', 1, 0, 2, ''),
(6, 'topic', 'topic', 'Topic', '', '', 'news', 1, 0, 3, ''),
(7, 'content', 'content', 'Content', '', '', 'news', 1, 1, 4, ''),
(8, 'detail', 'detail', 'Detail', '', '', 'news', 1, 0, 5, ''),
(9, 'tag', 'tag', 'Tag', '', '', 'news', 1, 0, 6, ''),
(10, 'rss', 'rss', 'Rss', '', '', 'news', 1, 1, 7, ''),
(11, 'search', 'search', 'Search', '', '', 'news', 1, 1, 8, ''),
(12, 'groups', 'groups', 'Groups', '', '', 'news', 1, 0, 9, ''),
(13, 'author', 'author', 'Author', '', '', 'news', 1, 0, 10, ''),
(14, 'sitemap', 'sitemap', 'Sitemap', '', '', 'news', 0, 0, 0, ''),
(15, 'print', 'print', 'Print', '', '', 'news', 0, 0, 0, ''),
(16, 'rating', 'rating', 'Rating', '', '', 'news', 0, 0, 0, ''),
(17, 'savefile', 'savefile', 'Savefile', '', '', 'news', 0, 0, 0, ''),
(18, 'sendmail', 'sendmail', 'Sendmail', '', '', 'news', 0, 0, 0, ''),
(19, 'instant-rss', 'instant-rss', 'Instant Articles RSS', '', '', 'news', 0, 0, 0, ''),
(20, 'main', 'main', 'Main', '', '', 'users', 1, 0, 1, ''),
(21, 'login', 'login', 'Đăng nhập', '', '', 'users', 1, 1, 2, ''),
(22, 'register', 'register', 'Đăng ký', '', '', 'users', 1, 1, 3, ''),
(23, 'lostpass', 'lostpass', 'Khôi phục mật khẩu', '', '', 'users', 1, 1, 4, ''),
(24, 'active', 'active', 'Kích hoạt tài khoản', '', '', 'users', 1, 0, 5, ''),
(25, 'lostactivelink', 'lostactivelink', 'Lấy lại link kích hoạt', '', '', 'users', 1, 0, 6, ''),
(26, 'r2s', 'r2s', 'Tắt xác thực 2 bước', '', '', 'users', 1, 0, 7, ''),
(27, 'editinfo', 'editinfo', 'Thiết lập tài khoản', '', '', 'users', 1, 1, 8, ''),
(28, 'memberlist', 'memberlist', 'Danh sách người dùng', '', '', 'users', 1, 1, 9, ''),
(29, 'groups', 'groups', 'Quản lý nhóm', '', '', 'users', 1, 1, 10, ''),
(30, 'avatar', 'avatar', 'Avatar', '', '', 'users', 1, 0, 11, ''),
(31, 'logout', 'logout', 'Thoát', '', '', 'users', 1, 1, 12, ''),
(32, 'oauth', 'oauth', 'Oauth', '', '', 'users', 0, 0, 0, ''),
(33, 'main', 'main', 'Main', '', '', 'myapi', 1, 0, 1, ''),
(34, 'main', 'main', 'Main', '', '', 'inform', 1, 0, 1, ''),
(35, 'main', 'main', 'Main', '', '', 'contact', 1, 0, 1, ''),
(36, 'main', 'main', 'Main', '', '', 'statistics', 1, 0, 1, ''),
(37, 'allreferers', 'allreferers', 'Theo đường dẫn đến site', '', '', 'statistics', 1, 1, 2, ''),
(38, 'allcountries', 'allcountries', 'Theo quốc gia', '', '', 'statistics', 1, 1, 3, ''),
(39, 'allbrowsers', 'allbrowsers', 'Theo trình duyệt', '', '', 'statistics', 1, 1, 4, ''),
(40, 'allos', 'allos', 'Theo hệ điều hành', '', '', 'statistics', 1, 1, 5, ''),
(41, 'allbots', 'allbots', 'Theo máy chủ tìm kiếm', '', '', 'statistics', 1, 1, 6, ''),
(42, 'referer', 'referer', 'Đường dẫn đến site theo tháng', '', '', 'statistics', 1, 0, 7, ''),
(43, 'main', 'main', 'Main', '', '', 'voting', 1, 0, 1, ''),
(44, 'main', 'main', 'Main', '', '', 'banners', 1, 0, 1, ''),
(45, 'addads', 'addads', 'Addads', '', '', 'banners', 1, 0, 2, ''),
(46, 'clientinfo', 'clientinfo', 'Clientinfo', '', '', 'banners', 1, 0, 3, ''),
(47, 'stats', 'stats', 'Stats', '', '', 'banners', 1, 0, 4, ''),
(48, 'cledit', 'cledit', 'Cledit', '', '', 'banners', 0, 0, 0, ''),
(49, 'click', 'click', 'Click', '', '', 'banners', 0, 0, 0, ''),
(50, 'clinfo', 'clinfo', 'Clinfo', '', '', 'banners', 0, 0, 0, ''),
(51, 'logininfo', 'logininfo', 'Logininfo', '', '', 'banners', 0, 0, 0, ''),
(52, 'viewmap', 'viewmap', 'Viewmap', '', '', 'banners', 0, 0, 0, ''),
(53, 'main', 'main', 'Main', '', '', 'seek', 1, 0, 1, ''),
(54, 'opensearch', 'opensearch', 'Opensearch', '', '', 'seek', 0, 0, 0, ''),
(55, 'main', 'main', 'Main', '', '', 'feeds', 1, 0, 1, ''),
(56, 'main', 'main', 'Main', '', '', 'page', 1, 0, 1, ''),
(57, 'sitemap', 'sitemap', 'Sitemap', '', '', 'page', 0, 0, 0, ''),
(58, 'rss', 'rss', 'Rss', '', '', 'page', 0, 0, 0, ''),
(59, 'main', 'main', 'Main', '', '', 'comment', 1, 0, 1, ''),
(60, 'post', 'post', 'Post', '', '', 'comment', 1, 0, 2, ''),
(61, 'like', 'like', 'Like', '', '', 'comment', 1, 0, 3, ''),
(62, 'delete', 'delete', 'Delete', '', '', 'comment', 1, 0, 4, ''),
(63, 'down', 'down', 'Down', '', '', 'comment', 1, 0, 5, ''),
(64, 'main', 'main', 'Main', '', '', 'siteterms', 1, 0, 1, ''),
(65, 'rss', 'rss', 'Rss', '', '', 'siteterms', 1, 0, 2, ''),
(66, 'sitemap', 'sitemap', 'Sitemap', '', '', 'siteterms', 0, 0, 0, ''),
(67, 'main', 'main', 'Main', '', '', 'two-step-verification', 1, 0, 1, ''),
(68, 'confirm', 'confirm', 'Confirm', '', '', 'two-step-verification', 1, 0, 2, ''),
(69, 'setup', 'setup', 'Setup', '', '', 'two-step-verification', 1, 0, 3, ''),
(70, 'qrimg', 'qrimg', 'Qrimg', '', '', 'two-step-verification', 0, 0, 0, ''),
(71, 'drive-connect', 'drive-connect', 'Drive-connect', '', '', 'nas', 1, 1, 3, ''),
(72, 'file-manager', 'file-manager', 'File-manager', '', '', 'nas', 1, 1, 4, ''),
(73, 'file-zone', 'file-zone', 'File-zone', '', '', 'nas', 1, 1, 1, ''),
(74, 'main', 'main', 'Main', '', '', 'nas', 1, 0, 5, ''),
(75, 'rtc-transfer', 'rtc-transfer', 'Rtc-transfer', '', '', 'nas', 1, 1, 2, '');

-- --------------------------------------------------------

--
-- Table structure for table `nv5_vi_modthemes`
--

DROP TABLE IF EXISTS `nv5_vi_modthemes`;
CREATE TABLE `nv5_vi_modthemes` (
  `func_id` mediumint(8) DEFAULT NULL,
  `layout` varchar(100) DEFAULT NULL,
  `theme` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Layout của giao diện theo từng khu vực';

--
-- Dumping data for table `nv5_vi_modthemes`
--

INSERT INTO `nv5_vi_modthemes` (`func_id`, `layout`, `theme`) VALUES
(0, 'left-main-right', 'default'),
(0, 'main', 'blanas'),
(0, 'main', 'mobile_default'),
(1, 'left-main-right', 'default'),
(1, 'main', 'blanas'),
(1, 'main', 'mobile_default'),
(4, 'left-main-right', 'default'),
(4, 'main', 'blanas'),
(4, 'main', 'mobile_default'),
(5, 'left-main-right', 'default'),
(5, 'main', 'blanas'),
(5, 'main', 'mobile_default'),
(6, 'left-main-right', 'default'),
(6, 'main', 'blanas'),
(6, 'main', 'mobile_default'),
(7, 'left-main-right', 'default'),
(7, 'main', 'blanas'),
(7, 'main', 'mobile_default'),
(8, 'left-main-right', 'default'),
(8, 'main', 'blanas'),
(8, 'main', 'mobile_default'),
(9, 'left-main-right', 'default'),
(9, 'main', 'blanas'),
(9, 'main', 'mobile_default'),
(10, 'left-main-right', 'default'),
(10, 'main', 'blanas'),
(11, 'left-main-right', 'default'),
(11, 'main', 'blanas'),
(11, 'main', 'mobile_default'),
(12, 'left-main-right', 'default'),
(12, 'main', 'blanas'),
(12, 'main', 'mobile_default'),
(13, 'left-main-right', 'default'),
(13, 'main', 'blanas'),
(13, 'main', 'mobile_default'),
(20, 'left-main', 'default'),
(20, 'main', 'blanas'),
(20, 'main', 'mobile_default'),
(21, 'left-main', 'default'),
(21, 'main', 'blanas'),
(21, 'main', 'mobile_default'),
(22, 'left-main', 'default'),
(22, 'main', 'blanas'),
(22, 'main', 'mobile_default'),
(23, 'left-main', 'default'),
(23, 'main', 'blanas'),
(23, 'main', 'mobile_default'),
(24, 'left-main', 'default'),
(24, 'main', 'blanas'),
(24, 'main', 'mobile_default'),
(25, 'left-main', 'default'),
(25, 'main', 'blanas'),
(25, 'main', 'mobile_default'),
(26, 'left-main', 'default'),
(26, 'main', 'blanas'),
(26, 'main', 'mobile_default'),
(27, 'left-main', 'default'),
(27, 'main', 'blanas'),
(27, 'main', 'mobile_default'),
(28, 'left-main', 'default'),
(28, 'main', 'blanas'),
(28, 'main', 'mobile_default'),
(29, 'left-main', 'default'),
(29, 'main', 'blanas'),
(29, 'main', 'mobile_default'),
(30, 'left-main', 'default'),
(30, 'main', 'blanas'),
(31, 'left-main', 'default'),
(31, 'main', 'blanas'),
(31, 'main', 'mobile_default'),
(33, 'main', 'blanas'),
(33, 'main', 'default'),
(33, 'main', 'mobile_default'),
(34, 'left-main', 'default'),
(34, 'main', 'blanas'),
(34, 'main', 'mobile_default'),
(35, 'left-main', 'default'),
(35, 'main', 'blanas'),
(35, 'main', 'mobile_default'),
(36, 'left-main', 'default'),
(36, 'main', 'blanas'),
(36, 'main', 'mobile_default'),
(37, 'left-main', 'default'),
(37, 'main', 'blanas'),
(37, 'main', 'mobile_default'),
(38, 'left-main', 'default'),
(38, 'main', 'blanas'),
(38, 'main', 'mobile_default'),
(39, 'left-main', 'default'),
(39, 'main', 'blanas'),
(39, 'main', 'mobile_default'),
(40, 'left-main', 'default'),
(40, 'main', 'blanas'),
(40, 'main', 'mobile_default'),
(41, 'left-main', 'default'),
(41, 'main', 'blanas'),
(41, 'main', 'mobile_default'),
(42, 'left-main', 'default'),
(42, 'main', 'blanas'),
(42, 'main', 'mobile_default'),
(43, 'left-main', 'default'),
(43, 'main', 'blanas'),
(43, 'main', 'mobile_default'),
(44, 'left-main-right', 'default'),
(44, 'main', 'blanas'),
(44, 'main', 'mobile_default'),
(45, 'left-main-right', 'default'),
(45, 'main', 'blanas'),
(45, 'main', 'mobile_default'),
(46, 'left-main-right', 'default'),
(46, 'main', 'blanas'),
(46, 'main', 'mobile_default'),
(47, 'left-main-right', 'default'),
(47, 'main', 'blanas'),
(47, 'main', 'mobile_default'),
(53, 'left-main-right', 'default'),
(53, 'main', 'blanas'),
(53, 'main', 'mobile_default'),
(55, 'left-main-right', 'default'),
(55, 'main', 'blanas'),
(55, 'main', 'mobile_default'),
(56, 'left-main', 'default'),
(56, 'main', 'blanas'),
(56, 'main', 'mobile_default'),
(59, 'left-main-right', 'default'),
(59, 'main', 'blanas'),
(59, 'main', 'mobile_default'),
(60, 'left-main-right', 'default'),
(60, 'main', 'blanas'),
(60, 'main', 'mobile_default'),
(61, 'left-main-right', 'default'),
(61, 'main', 'blanas'),
(61, 'main', 'mobile_default'),
(62, 'left-main-right', 'default'),
(62, 'main', 'blanas'),
(62, 'main', 'mobile_default'),
(63, 'main', 'blanas'),
(64, 'left-main-right', 'default'),
(64, 'main', 'blanas'),
(64, 'main', 'mobile_default'),
(65, 'left-main-right', 'default'),
(65, 'main', 'blanas'),
(65, 'main', 'mobile_default'),
(67, 'left-main-right', 'default'),
(67, 'main', 'blanas'),
(67, 'main', 'mobile_default'),
(68, 'left-main-right', 'default'),
(68, 'main', 'blanas'),
(68, 'main', 'mobile_default'),
(69, 'left-main-right', 'default'),
(69, 'main', 'blanas'),
(69, 'main', 'mobile_default'),
(71, 'left-main-right', 'default'),
(71, 'main', 'blanas'),
(71, 'main', 'mobile_default'),
(72, 'left-main-right', 'default'),
(72, 'main', 'blanas'),
(72, 'main', 'mobile_default'),
(73, 'left-main-right', 'default'),
(73, 'main', 'blanas'),
(73, 'main', 'mobile_default'),
(74, 'left-main-right', 'default'),
(74, 'main', 'blanas'),
(74, 'main', 'mobile_default'),
(75, 'left-main-right', 'default'),
(75, 'main', 'blanas'),
(75, 'main', 'mobile_default');

-- --------------------------------------------------------

--
-- Table structure for table `nv5_vi_modules`
--

DROP TABLE IF EXISTS `nv5_vi_modules`;
CREATE TABLE `nv5_vi_modules` (
  `title` varchar(50) NOT NULL,
  `module_file` varchar(50) NOT NULL DEFAULT '',
  `module_data` varchar(50) NOT NULL DEFAULT '',
  `module_upload` varchar(50) NOT NULL DEFAULT '',
  `module_theme` varchar(50) NOT NULL DEFAULT '',
  `custom_title` varchar(255) NOT NULL,
  `site_title` varchar(255) NOT NULL DEFAULT '',
  `admin_title` varchar(255) NOT NULL DEFAULT '',
  `set_time` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `main_file` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `admin_file` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `theme` varchar(100) DEFAULT '',
  `mobile` varchar(100) DEFAULT '',
  `description` varchar(255) DEFAULT '',
  `keywords` text DEFAULT NULL,
  `icon` varchar(100) NOT NULL DEFAULT '' COMMENT 'Icon',
  `groups_view` varchar(255) NOT NULL,
  `weight` tinyint(3) UNSIGNED NOT NULL DEFAULT 1,
  `act` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `admins` varchar(4000) DEFAULT '',
  `rss` tinyint(4) NOT NULL DEFAULT 1,
  `sitemap` tinyint(4) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Module ngoài site theo ngôn ngữ';

--
-- Dumping data for table `nv5_vi_modules`
--

INSERT INTO `nv5_vi_modules` (`title`, `module_file`, `module_data`, `module_upload`, `module_theme`, `custom_title`, `site_title`, `admin_title`, `set_time`, `main_file`, `admin_file`, `theme`, `mobile`, `description`, `keywords`, `icon`, `groups_view`, `weight`, `act`, `admins`, `rss`, `sitemap`) VALUES
('about', 'page', 'about', 'about', 'page', 'Giới thiệu', '', '', 1742685231, 1, 1, '', '', '', '', 'fa-solid fa-campground', '6', 2, 1, '', 1, 1),
('banners', 'banners', 'banners', 'banners', 'banners', 'Quảng cáo', '', '', 1742685231, 1, 1, '', '', '', '', 'fa-solid fa-rectangle-ad', '6', 11, 1, '', 0, 1),
('comment', 'comment', 'comment', 'comment', 'comment', 'Bình luận', '', 'Quản lý bình luận', 1742685231, 0, 1, '', '', '', '', 'fa-solid fa-comments', '6', 16, 1, '', 0, 1),
('contact', 'contact', 'contact', 'contact', 'contact', 'Liên hệ', '', '', 1742685231, 1, 1, '', '', '', '', 'fa-solid fa-phone', '6', 8, 1, '', 0, 1),
('feeds', 'feeds', 'feeds', 'feeds', 'feeds', 'RSS-feeds', '', '', 1742685231, 1, 1, '', '', '', '', 'fa-solid fa-rss', '6', 14, 1, '', 0, 1),
('freecontent', 'freecontent', 'freecontent', 'freecontent', 'freecontent', 'Giới thiệu sản phẩm', '', '', 1742685231, 0, 1, '', '', '', '', 'fa-solid fa-cube', '6', 18, 1, '', 0, 1),
('inform', 'inform', 'inform', 'inform', 'inform', 'Thông báo', '', '', 1742685231, 1, 1, '', '', '', '', 'fa-solid fa-bell', '4', 7, 1, '', 0, 0),
('menu', 'menu', 'menu', 'menu', 'menu', 'Menu Site', '', '', 1742685231, 0, 1, '', '', '', '', 'fa-solid fa-network-wired', '6', 13, 1, '', 0, 1),
('myapi', 'myapi', 'myapi', 'myapi', 'myapi', 'API của tôi', '', '', 1742685231, 1, 1, '', '', '', '', 'fa-brands fa-nfc-symbol', '6', 6, 1, '', 0, 0),
('nas', 'nas', 'nas', 'nas', 'nas', 'BlaNAS', '', 'Quản lí NAS', 1742685564, 1, 1, 'blanas', ':pcmod', '', '', 'fa-regular fa-hard-drive', '6', 1, 1, '', 0, 0),
('news', 'news', 'news', 'news', 'news', 'Tin Tức', '', '', 1742685231, 1, 1, '', '', '', '', 'fa-solid fa-newspaper', '6', 4, 1, '', 1, 1),
('page', 'page', 'page', 'page', 'page', 'Page', '', '', 1742685231, 1, 1, '', '', '', '', 'fa-solid fa-file-pen', '6', 15, 1, '', 1, 0),
('seek', 'seek', 'seek', 'seek', 'seek', 'Tìm kiếm', '', '', 1742685231, 1, 0, '', '', '', '', 'fa-solid fa-magnifying-glass', '6', 12, 1, '', 0, 1),
('siteterms', 'page', 'siteterms', 'siteterms', 'page', 'Điều khoản sử dụng', '', '', 1742685231, 1, 1, '', '', '', '', 'fa-solid fa-gavel', '6', 17, 1, '', 1, 1),
('statistics', 'statistics', 'statistics', 'statistics', 'statistics', 'Thống kê', '', '', 1742685231, 1, 1, '', '', '', 'online, statistics', 'fa-solid fa-chart-simple', '6', 9, 1, '', 0, 1),
('two-step-verification', 'two-step-verification', 'two_step_verification', 'two_step_verification', 'two-step-verification', 'Xác thực hai bước', '', '', 1742685231, 1, 0, '', '', '', '', 'fa-solid fa-shield-halved', '6', 19, 1, '', 0, 1),
('users', 'users', 'users', 'users', 'users', 'Tài khoản người dùng', '', 'Tài khoản', 1742685231, 1, 1, '', '', '', '', 'fa-solid fa-users', '6', 5, 1, '', 0, 1),
('voting', 'voting', 'voting', 'voting', 'voting', 'Thăm dò ý kiến', '', '', 1742685231, 1, 1, '', '', '', '', 'fa-solid fa-square-poll-vertical', '6', 10, 1, '', 1, 1),
('zalo', 'zalo', 'zalo', 'zalo', 'zalo', 'Zalo', '', 'Zalo', 1742685231, 0, 1, '', '', '', '', 'fa-solid fa-z', '3', 3, 1, '', 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_vi_nas_api_credentials`
--

DROP TABLE IF EXISTS `nv5_vi_nas_api_credentials`;
CREATE TABLE `nv5_vi_nas_api_credentials` (
  `id` int(11) UNSIGNED NOT NULL COMMENT 'ID tự tăng',
  `userid` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Sở hữu của ai',
  `add_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Thời gian thêm',
  `edit_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Thời gian sửa',
  `title` varchar(100) NOT NULL DEFAULT '' COMMENT 'Tên gợi nhớ',
  `client_id` varchar(200) NOT NULL DEFAULT '' COMMENT 'Client ID',
  `client_secret` varchar(200) NOT NULL DEFAULT '' COMMENT 'Client secret',
  `token` text DEFAULT NULL COMMENT 'Token json',
  `is_setup` tinyint(1) NOT NULL DEFAULT 0 COMMENT '0: chưa cài, 1: đã cài',
  `is_error` tinyint(1) NOT NULL DEFAULT 0 COMMENT '0: chưa lỗi, 1: đã bị lỗi cần kết nối lại'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='API App của người dùng';

-- --------------------------------------------------------

--
-- Table structure for table `nv5_vi_nas_nodes`
--

DROP TABLE IF EXISTS `nv5_vi_nas_nodes`;
CREATE TABLE `nv5_vi_nas_nodes` (
  `id` int(11) UNSIGNED NOT NULL COMMENT 'ID node',
  `parentid` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'ID thư mục cha',
  `parentids` varchar(250) NOT NULL DEFAULT '' COMMENT 'Lưu danh sách thư mục cha của nó tính ra bên ngoài',
  `userid` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Sở hữu của ai',
  `node_type` tinyint(1) NOT NULL DEFAULT 0 COMMENT '0: File, 1: Thư mục',
  `add_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Thời gian thêm',
  `edit_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Thời gian sửa',
  `rename_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Thời gian sửa tên',
  `title` varchar(200) NOT NULL DEFAULT '' COMMENT 'Tên thật',
  `alias` varchar(200) NOT NULL DEFAULT '' COMMENT 'Tên thư mục, tên file',
  `path` varchar(2000) NOT NULL DEFAULT '' COMMENT 'Đường dẫn đến tập tin, thư mục tính từ thư mục user',
  `weight` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Thứ tự trong cùng một cấp (thường xếp theo tên)',
  `sort` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Thứ tự toàn bộ',
  `lev` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Thư mục cấp mấy, cấp cha thì=0',
  `numsubcat` int(11) NOT NULL DEFAULT 0 COMMENT 'Số item con trong nó',
  `subcatid` varchar(1000) NOT NULL DEFAULT '' COMMENT 'ID item con cấp liền kề của nó phân cách bởi dấu phảy',
  `subcatids` varchar(5000) NOT NULL DEFAULT '' COMMENT 'ID item con tất cả các cấp của nó phân cách bởi dấu phảy',
  `node_size` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Dung lượng tập tin',
  `duration` int(11) NOT NULL DEFAULT 0 COMMENT 'Thời lượng video',
  `node_mime` varchar(200) NOT NULL DEFAULT '' COMMENT 'Mine tập tin',
  `node_ext` varchar(50) NOT NULL DEFAULT '' COMMENT 'Đuôi tập tin',
  `properties` text DEFAULT NULL COMMENT 'Json cấu hình',
  `image_width` smallint(5) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Chiều rộng ảnh',
  `image_height` smallint(5) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Chiều cao ảnh',
  `thumb` tinyint(1) NOT NULL DEFAULT 0 COMMENT '0: Không có ảnh đại diện, 1: Ảnh đại diện chính là path của file',
  `bookmarked` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Thời gian đánh dấu',
  `shared_users` varchar(250) NOT NULL DEFAULT '' COMMENT 'Chia sẻ cho người dùng khác',
  `shared_groups` varchar(250) NOT NULL DEFAULT '' COMMENT 'Chia sẻ cho nhóm khác',
  `trash` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Thời gian xóa',
  `trash_parent` tinyint(1) NOT NULL DEFAULT 0 COMMENT '1 là bị xóa bởi thư mục cha của nó',
  `is_tmp` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0 là file hoàn tất >0 là file đang trong quá trình upload',
  `uniqid` varchar(32) NOT NULL DEFAULT '' COMMENT 'Key kiểm tra file duy nhất trong quá trình upload',
  `sync_appid` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'ID app đồng bộ',
  `sync_folderid` varchar(50) NOT NULL DEFAULT '' COMMENT 'ID thư mục đồng bộ hoặc ID đã đồng bộ lên với file',
  `sync_lastime` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Lần đồng bộ gần đây',
  `sync_iserror` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0 là không lỗi, >0 là thời gian lỗi',
  `sync_disabled` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Thư mục cha bật đồng bộ thì set cái này lên 1 của thư mục con => Không cho nó đồng bộ',
  `process_time` bigint(20) NOT NULL DEFAULT 0 COMMENT 'Xử lý node: 0 là chưa xử lý, >0 thời gian xử lý thành công, <0 thời gian xử lý thất bại',
  `zoned_time` int(11) NOT NULL DEFAULT 0 COMMENT '0 không chia sẻ, -1 vĩnh viễn, >0 hết hạn lúc'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Danh sách tập tin, thư mục';

-- --------------------------------------------------------

--
-- Table structure for table `nv5_vi_nas_nodes_refs`
--

DROP TABLE IF EXISTS `nv5_vi_nas_nodes_refs`;
CREATE TABLE `nv5_vi_nas_nodes_refs` (
  `node_id` int(11) UNSIGNED NOT NULL COMMENT 'ID node',
  `image_cover` varchar(255) NOT NULL DEFAULT '' COMMENT 'Đường dẫn ảnh đại diện tùy chỉnh',
  `sync_messerror` text DEFAULT NULL COMMENT 'Message lỗi khi đồng bộ'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Các trường mở rộng của tệp tin, thư mục';

-- --------------------------------------------------------

--
-- Table structure for table `nv5_vi_nas_users`
--

DROP TABLE IF EXISTS `nv5_vi_nas_users`;
CREATE TABLE `nv5_vi_nas_users` (
  `userid` int(11) UNSIGNED NOT NULL COMMENT 'ID người dùng',
  `add_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Thời gian thêm',
  `edit_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Thời gian sửa',
  `quota_limit` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Hạn ngạch bằng bytes. 0 là không giới hạn',
  `quota_current` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Dung lượng hiện đang sử dụng',
  `last_activity` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Hoạt động gần đây lúc',
  `last_ip` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'IP cho hoạt động gần đây',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Trạng thái 1 bật 0 tắt'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Danh sách người dùng';

--
-- Dumping data for table `nv5_vi_nas_users`
--

INSERT INTO `nv5_vi_nas_users` (`userid`, `add_time`, `edit_time`, `quota_limit`, `quota_current`, `last_activity`, `last_ip`, `status`) VALUES
(1, 1742686039, 0, 536870912000, 0, 0, 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_vi_nas_users_config`
--

DROP TABLE IF EXISTS `nv5_vi_nas_users_config`;
CREATE TABLE `nv5_vi_nas_users_config` (
  `userid` int(11) UNSIGNED NOT NULL COMMENT 'ID thành viên',
  `config_name` varchar(50) NOT NULL COMMENT 'Khóa cấu hình',
  `config_value` text NOT NULL COMMENT 'Nội dung cấu hình'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Thiết lập theo người dùng';

--
-- Dumping data for table `nv5_vi_nas_users_config`
--

INSERT INTO `nv5_vi_nas_users_config` (`userid`, `config_name`, `config_value`) VALUES
(0, 'view_sort', 'add_desc'),
(0, 'view_type', 'grid'),
(1, 'view_type', 'grid');

-- --------------------------------------------------------

--
-- Table structure for table `nv5_vi_nas_users_notices`
--

DROP TABLE IF EXISTS `nv5_vi_nas_users_notices`;
CREATE TABLE `nv5_vi_nas_users_notices` (
  `id` int(11) UNSIGNED NOT NULL COMMENT 'ID tự tăng',
  `userid` int(11) UNSIGNED NOT NULL COMMENT 'ID thành viên',
  `channel` varchar(50) NOT NULL COMMENT 'Kênh',
  `notice_key` varchar(50) NOT NULL COMMENT 'Loại thông báo',
  `notice_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Thời gian thông báo',
  `subject` varchar(250) NOT NULL COMMENT 'Tiêu đề',
  `message` longtext NOT NULL COMMENT 'Nội dung thông báo',
  `send_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Thời gian xử lý',
  `send_message` longtext DEFAULT NULL COMMENT 'Message nếu xử lý có lỗi'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Các thông báo cho người dùng';

-- --------------------------------------------------------

--
-- Table structure for table `nv5_vi_news_1`
--

DROP TABLE IF EXISTS `nv5_vi_news_1`;
CREATE TABLE `nv5_vi_news_1` (
  `id` int(11) UNSIGNED NOT NULL,
  `catid` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `listcatid` varchar(255) NOT NULL DEFAULT '',
  `topicid` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `admin_id` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `author` varchar(250) DEFAULT '',
  `sourceid` mediumint(8) NOT NULL DEFAULT 0,
  `addtime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `edittime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `status` tinyint(4) NOT NULL DEFAULT 1,
  `weight` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `publtime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `exptime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `archive` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `title` varchar(250) NOT NULL DEFAULT '',
  `alias` varchar(250) NOT NULL DEFAULT '',
  `hometext` text NOT NULL,
  `homeimgfile` varchar(255) DEFAULT '',
  `homeimgalt` varchar(255) DEFAULT '',
  `homeimgthumb` tinyint(4) NOT NULL DEFAULT 0,
  `inhome` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `allowed_comm` varchar(255) DEFAULT '',
  `allowed_rating` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `external_link` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `hitstotal` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `hitscm` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `total_rating` int(11) NOT NULL DEFAULT 0,
  `click_rating` int(11) NOT NULL DEFAULT 0,
  `instant_active` tinyint(1) NOT NULL DEFAULT 0,
  `instant_template` varchar(100) NOT NULL DEFAULT '',
  `instant_creatauto` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_vi_news_1`
--

INSERT INTO `nv5_vi_news_1` (`id`, `catid`, `listcatid`, `topicid`, `admin_id`, `author`, `sourceid`, `addtime`, `edittime`, `status`, `weight`, `publtime`, `exptime`, `archive`, `title`, `alias`, `hometext`, `homeimgfile`, `homeimgalt`, `homeimgthumb`, `inhome`, `allowed_comm`, `allowed_rating`, `external_link`, `hitstotal`, `hitscm`, `total_rating`, `click_rating`, `instant_active`, `instant_template`, `instant_creatauto`) VALUES
(1, 1, '1,5,7', 0, 1, 'Quỳnh Nhi', 1, 1274989177, 1275318126, 1, 1, 1274989140, 0, 2, 'Ra mắt công ty mã nguồn mở đầu tiên tại Việt Nam', 'Ra-mat-cong-ty-ma-nguon-mo-dau-tien-tai-Viet-Nam', 'Mã nguồn mở NukeViet vốn đã quá quen thuộc với cộng đồng CNTT Việt Nam trong mấy năm qua. Tuy chưa hoạt động chính thức, nhưng chỉ trong khoảng 5 năm gần đây, mã nguồn mở NukeViet đã được dùng phổ biến ở Việt Nam, áp dụng ở hầu hết các lĩnh vực, từ tin tức đến thương mại điện tử, từ các website cá nhân cho tới những hệ thống website doanh nghiệp.', 'nangly.jpg', 'Thành lập VINADES.,JSC', 1, 1, '6', 1, 0, 2, 0, 0, 0, 0, '', 0),
(6, 1, '1,6', 0, 1, '', 3, 1322685920, 1322686042, 1, 2, 1322685920, 0, 2, 'Mã nguồn mở NukeViet giành giải ba Nhân tài đất Việt 2011', 'Ma-nguon-mo-NukeViet-gianh-giai-ba-Nhan-tai-dat-Viet-2011', 'Không có giải nhất và giải nhì, sản phẩm Mã nguồn mở NukeViet của VINADES.,JSC là một trong ba sản phẩm đã đoạt giải ba Nhân tài đất Việt 2011 - Lĩnh vực Công nghệ thông tin (Sản phẩm đã ứng dụng rộng rãi).', 'nukeviet-nhantaidatviet2011.jpg', 'Mã nguồn mở NukeViet giành giải ba Nhân tài đất Việt 2011', 1, 1, '6', 1, 0, 1, 0, 0, 0, 0, '', 0),
(7, 1, '1', 0, 1, '', 4, 1445309676, 1445309676, 1, 3, 1445309520, 0, 2, 'NukeViet được ưu tiên mua sắm, sử dụng trong cơ quan, tổ chức nhà nước', 'nukeviet-duoc-uu-tien-mua-sam-su-dung-trong-co-quan-to-chuc-nha-nuoc', 'Ngày 5/12/2014, Bộ trưởng Bộ TT&TT Nguyễn Bắc Son đã ký ban hành Thông tư 20/2014/TT-BTTTT (Thông tư 20) quy định về các sản phẩm phần mềm nguồn mở (PMNM) được ưu tiên mua sắm, sử dụng trong cơ quan, tổ chức nhà nước. NukeViet (phiên bản 3.4.02 trở lên) là phần mềm được nằm trong danh sách này.', 'chuc-mung-nukeviet-thong-tu-20-bo-tttt.jpg', 'NukeViet được ưu tiên mua sắm, sử dụng trong cơ quan, tổ chức nhà nước', 1, 1, '4', 1, 0, 2, 0, 0, 0, 0, '', 0),
(9, 1, '1,4', 0, 1, 'Trần Thị Thu', 0, 1445391118, 1445394180, 1, 7, 1445391060, 0, 2, 'Chương trình thực tập sinh tại công ty VINADES', 'chuong-trinh-thuc-tap-sinh-tai-cong-ty-vinades', 'Cơ hội để những sinh viên năng động được học tập, trải nghiệm, thử thách sớm với những tình huống thực tế, được làm việc cùng các chuyên gia có nhiều kinh nghiệm của công ty VINADES.', 'thuc-tap-sinh.jpg', '', 1, 1, '4', 1, 0, 0, 0, 0, 0, 0, '', 0),
(11, 1, '1', 0, 1, '', 0, 1445391182, 1445394133, 1, 9, 1445391120, 0, 2, 'NukeViet được Bộ GD&amp;ĐT đưa vào Hướng dẫn thực hiện nhiệm vụ CNTT năm học 2015 - 2016', 'nukeviet-duoc-bo-gd-dt-dua-vao-huong-dan-thuc-hien-nhiem-vu-cntt-nam-hoc-2015-2016', 'Trong Hướng dẫn thực hiện nhiệm vụ CNTT năm học 2015 - 2016 của Bộ Giáo dục và Đào tạo, NukeViet được đưa vào các hạng mục: Tập huấn sử dụng phần mềm nguồn mở cho giáo viên và cán bộ quản lý giáo dục; Khai thác, sử dụng và dạy học; đặc biệt phần &quot;khuyến cáo khi sử dụng các hệ thống CNTT&quot; có chỉ rõ &quot;Không nên làm website mã nguồn đóng&quot; và &quot;Nên làm NukeViet: phần mềm nguồn mở&quot;.', 'nukeviet-cms.jpg', '', 1, 1, '4', 1, 0, 0, 0, 0, 0, 0, '', 0),
(12, 1, '1,3', 0, 1, '', 0, 1445391217, 1445393997, 1, 10, 1445391180, 0, 2, 'Hỗ trợ tập huấn và triển khai NukeViet cho các Phòng, Sở GD&amp;ĐT', 'ho-tro-tap-huan-va-trien-khai-nukeviet-cho-cac-phong-so-gd-dt', 'Trên cơ sở Hướng dẫn thực hiện nhiệm vụ CNTT năm học 2015 - 2016 của Bộ Giáo dục và Đào tạo, Công ty cổ phần phát triển nguồn mở Việt Nam và các doanh nghiệp phát triển NukeViet trong cộng đồng NukeViet đang tích cực công tác hỗ trợ cho các phòng GD&ĐT, Sở GD&ĐT triển khai 2 nội dung chính: Hỗ trợ công tác đào tạo tập huấn hướng dẫn sử dụng NukeViet và Hỗ trợ triển khai NukeViet cho các trường, Phòng và Sở GD&ĐT', 'tap-huan-pgd-ha-dong-2015.jpg', 'Tập huấn triển khai NukeViet tại Phòng Giáo dục và Đào tạo Hà Đông - Hà Nội', 1, 1, '4', 1, 0, 1, 0, 0, 0, 0, '', 0),
(2, 7, '1,7', 0, 1, 'Nguyễn Thế Hùng', 7, 1453192444, 1453192444, 1, 12, 1453192444, 0, 2, 'Hãy trở thành nhà cung cấp dịch vụ của NukeViet&#33;', 'hay-tro-thanh-nha-cung-cap-dich-vu-cua-nukeviet', 'Nếu bạn là công ty hosting, là công ty thiết kế web có sử dụng mã nguồn NukeViet, là cơ sở đào tạo NukeViet hay là công ty bất kỳ có kinh doanh dịch vụ liên quan đến NukeViet... hãy cho chúng tôi biết thông tin liên hệ của bạn để NukeViet hỗ trợ bạn trong công việc kinh doanh nhé!', 'hoptac.jpg', '', 1, 1, '6', 1, 0, 13, 0, 0, 0, 0, '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_vi_news_2`
--

DROP TABLE IF EXISTS `nv5_vi_news_2`;
CREATE TABLE `nv5_vi_news_2` (
  `id` int(11) UNSIGNED NOT NULL,
  `catid` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `listcatid` varchar(255) NOT NULL DEFAULT '',
  `topicid` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `admin_id` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `author` varchar(250) DEFAULT '',
  `sourceid` mediumint(8) NOT NULL DEFAULT 0,
  `addtime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `edittime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `status` tinyint(4) NOT NULL DEFAULT 1,
  `weight` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `publtime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `exptime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `archive` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `title` varchar(250) NOT NULL DEFAULT '',
  `alias` varchar(250) NOT NULL DEFAULT '',
  `hometext` text NOT NULL,
  `homeimgfile` varchar(255) DEFAULT '',
  `homeimgalt` varchar(255) DEFAULT '',
  `homeimgthumb` tinyint(4) NOT NULL DEFAULT 0,
  `inhome` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `allowed_comm` varchar(255) DEFAULT '',
  `allowed_rating` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `external_link` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `hitstotal` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `hitscm` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `total_rating` int(11) NOT NULL DEFAULT 0,
  `click_rating` int(11) NOT NULL DEFAULT 0,
  `instant_active` tinyint(1) NOT NULL DEFAULT 0,
  `instant_template` varchar(100) NOT NULL DEFAULT '',
  `instant_creatauto` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_vi_news_2`
--

INSERT INTO `nv5_vi_news_2` (`id`, `catid`, `listcatid`, `topicid`, `admin_id`, `author`, `sourceid`, `addtime`, `edittime`, `status`, `weight`, `publtime`, `exptime`, `archive`, `title`, `alias`, `hometext`, `homeimgfile`, `homeimgalt`, `homeimgthumb`, `inhome`, `allowed_comm`, `allowed_rating`, `external_link`, `hitstotal`, `hitscm`, `total_rating`, `click_rating`, `instant_active`, `instant_template`, `instant_creatauto`) VALUES
(13, 2, '2', 0, 1, 'VINADES', 0, 1453194455, 1453194455, 1, 13, 1453194455, 0, 2, 'NukeViet 4.0 có gì mới?', 'nukeviet-4-0-co-gi-moi', 'NukeViet 4 là phiên bản NukeViet được cộng đồng đánh giá cao, hứa hẹn nhiều điểm vượt trội về công nghệ đến thời điểm hiện tại. NukeViet 4 thay đổi gần như hoàn toàn từ nhân hệ thống đến chức năng, giao diện người dùng. Vậy, có gì mới trong phiên bản này?', 'chuc-mung-nukeviet-thong-tu-20-bo-tttt.jpg', '', 1, 1, '4', 1, 0, 2, 0, 0, 0, 0, '', 0),
(14, 2, '2', 0, 1, 'VINADES', 0, 1501837620, 1501837620, 1, 14, 1501837620, 0, 2, 'NukeViet 4.2 có gì mới?', 'nukeviet-4-2-co-gi-moi', 'NukeViet 4.2 là phiên bản nâng cấp của phiên bản NukeViet 4.0 tập trung vào việc fix các vấn đề bất cập còn tồn tại của NukeViet 4.0, Thêm các tính năng mới để tăng cường bảo mật của hệ thống cũng như tối ưu trải nghiệm của người dùng.', 'chuc-mung-nukeviet-thong-tu-20-bo-tttt.jpg', '', 1, 1, '4', 1, 1, 2, 0, 0, 0, 0, '', 0),
(15, 2, '2', 0, 1, 'VINADES', 0, 1510215907, 1510215907, 1, 15, 1510215907, 0, 2, 'NukeViet 4.3 có gì mới?', 'nukeviet-4-3-co-gi-moi', 'NukeViet 4.3 là phiên bản nâng cấp của phiên bản NukeViet 4.2 tập trung vào việc fix các vấn đề bất cập còn tồn tại, tối ưu trải nghiệm của người dùng.', 'chuc-mung-nukeviet-thong-tu-20-bo-tttt.jpg', '', 1, 1, '4', 1, 1, 2, 0, 0, 0, 0, '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_vi_news_3`
--

DROP TABLE IF EXISTS `nv5_vi_news_3`;
CREATE TABLE `nv5_vi_news_3` (
  `id` int(11) UNSIGNED NOT NULL,
  `catid` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `listcatid` varchar(255) NOT NULL DEFAULT '',
  `topicid` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `admin_id` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `author` varchar(250) DEFAULT '',
  `sourceid` mediumint(8) NOT NULL DEFAULT 0,
  `addtime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `edittime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `status` tinyint(4) NOT NULL DEFAULT 1,
  `weight` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `publtime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `exptime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `archive` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `title` varchar(250) NOT NULL DEFAULT '',
  `alias` varchar(250) NOT NULL DEFAULT '',
  `hometext` text NOT NULL,
  `homeimgfile` varchar(255) DEFAULT '',
  `homeimgalt` varchar(255) DEFAULT '',
  `homeimgthumb` tinyint(4) NOT NULL DEFAULT 0,
  `inhome` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `allowed_comm` varchar(255) DEFAULT '',
  `allowed_rating` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `external_link` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `hitstotal` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `hitscm` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `total_rating` int(11) NOT NULL DEFAULT 0,
  `click_rating` int(11) NOT NULL DEFAULT 0,
  `instant_active` tinyint(1) NOT NULL DEFAULT 0,
  `instant_template` varchar(100) NOT NULL DEFAULT '',
  `instant_creatauto` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_vi_news_3`
--

INSERT INTO `nv5_vi_news_3` (`id`, `catid`, `listcatid`, `topicid`, `admin_id`, `author`, `sourceid`, `addtime`, `edittime`, `status`, `weight`, `publtime`, `exptime`, `archive`, `title`, `alias`, `hometext`, `homeimgfile`, `homeimgalt`, `homeimgthumb`, `inhome`, `allowed_comm`, `allowed_rating`, `external_link`, `hitstotal`, `hitscm`, `total_rating`, `click_rating`, `instant_active`, `instant_template`, `instant_creatauto`) VALUES
(12, 1, '1,3', 0, 1, '', 0, 1445391217, 1445393997, 1, 10, 1445391180, 0, 2, 'Hỗ trợ tập huấn và triển khai NukeViet cho các Phòng, Sở GD&amp;ĐT', 'ho-tro-tap-huan-va-trien-khai-nukeviet-cho-cac-phong-so-gd-dt', 'Trên cơ sở Hướng dẫn thực hiện nhiệm vụ CNTT năm học 2015 - 2016 của Bộ Giáo dục và Đào tạo, Công ty cổ phần phát triển nguồn mở Việt Nam và các doanh nghiệp phát triển NukeViet trong cộng đồng NukeViet đang tích cực công tác hỗ trợ cho các phòng GD&ĐT, Sở GD&ĐT triển khai 2 nội dung chính: Hỗ trợ công tác đào tạo tập huấn hướng dẫn sử dụng NukeViet và Hỗ trợ triển khai NukeViet cho các trường, Phòng và Sở GD&ĐT', 'tap-huan-pgd-ha-dong-2015.jpg', 'Tập huấn triển khai NukeViet tại Phòng Giáo dục và Đào tạo Hà Đông - Hà Nội', 1, 1, '4', 1, 0, 1, 0, 0, 0, 0, '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_vi_news_4`
--

DROP TABLE IF EXISTS `nv5_vi_news_4`;
CREATE TABLE `nv5_vi_news_4` (
  `id` int(11) UNSIGNED NOT NULL,
  `catid` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `listcatid` varchar(255) NOT NULL DEFAULT '',
  `topicid` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `admin_id` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `author` varchar(250) DEFAULT '',
  `sourceid` mediumint(8) NOT NULL DEFAULT 0,
  `addtime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `edittime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `status` tinyint(4) NOT NULL DEFAULT 1,
  `weight` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `publtime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `exptime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `archive` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `title` varchar(250) NOT NULL DEFAULT '',
  `alias` varchar(250) NOT NULL DEFAULT '',
  `hometext` text NOT NULL,
  `homeimgfile` varchar(255) DEFAULT '',
  `homeimgalt` varchar(255) DEFAULT '',
  `homeimgthumb` tinyint(4) NOT NULL DEFAULT 0,
  `inhome` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `allowed_comm` varchar(255) DEFAULT '',
  `allowed_rating` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `external_link` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `hitstotal` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `hitscm` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `total_rating` int(11) NOT NULL DEFAULT 0,
  `click_rating` int(11) NOT NULL DEFAULT 0,
  `instant_active` tinyint(1) NOT NULL DEFAULT 0,
  `instant_template` varchar(100) NOT NULL DEFAULT '',
  `instant_creatauto` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_vi_news_4`
--

INSERT INTO `nv5_vi_news_4` (`id`, `catid`, `listcatid`, `topicid`, `admin_id`, `author`, `sourceid`, `addtime`, `edittime`, `status`, `weight`, `publtime`, `exptime`, `archive`, `title`, `alias`, `hometext`, `homeimgfile`, `homeimgalt`, `homeimgthumb`, `inhome`, `allowed_comm`, `allowed_rating`, `external_link`, `hitstotal`, `hitscm`, `total_rating`, `click_rating`, `instant_active`, `instant_template`, `instant_creatauto`) VALUES
(8, 4, '4', 0, 1, 'Vũ Bích Ngọc', 0, 1445391061, 1445394203, 1, 4, 1445391000, 0, 2, 'Công ty VINADES tuyển dụng nhân viên kinh doanh', 'cong-ty-vinades-tuyen-dung-nhan-vien-kinh-doanh', 'Công ty cổ phần phát triển nguồn mở Việt Nam là đơn vị chủ quản của phần mềm mã nguồn mở NukeViet - một mã nguồn được tin dùng trong cơ quan nhà nước, đặc biệt là ngành giáo dục. Chúng tôi cần tuyển 05 nhân viên kinh doanh cho lĩnh vực này.', 'tuyen-dung-nvkd.png', '', 1, 1, '4', 1, 0, 0, 0, 0, 0, 0, '', 0),
(4, 4, '4', 0, 1, 'Phạm Quốc Tiến', 0, 1445391089, 1445394192, 1, 5, 1445391060, 0, 2, 'Tuyển dụng chuyên viên đồ hoạ phát triển NukeViet', 'Tuyen-dung-chuyen-vien-do-hoa', 'Bạn đam mê nguồn mở? Bạn là chuyên gia đồ họa? Chúng tôi sẽ giúp bạn hiện thực hóa ước mơ của mình với một mức lương đảm bảo. Hãy gia nhập VINADES.,JSC để xây dựng mã nguồn mở hàng đầu cho Việt Nam.', 'tuyendung-kythuat.jpg', 'Tuyển dụng', 1, 1, '6', 1, 0, 0, 0, 0, 0, 0, '', 0),
(5, 4, '4', 0, 1, 'Phạm Quốc Tiến', 0, 1445391090, 1445394193, 1, 6, 1445391060, 0, 2, 'Tuyển dụng lập trình viên front-end (HTML/CSS/JS) phát triển NukeViet', 'Tuyen-dung-lap-trinh-vien-front-end-HTML-CSS-JS', 'Bạn đam mê nguồn mở? Bạn đang cần tìm một công việc phù hợp với thế mạnh của bạn về front-end (HTML/CSS/JS)? Hãy gia nhập VINADES.,JSC để xây dựng mã nguồn mở hàng đầu cho Việt Nam.', 'tuyendung-kythuat.jpg', 'Tuyển dụng', 1, 1, '6', 1, 0, 0, 0, 0, 0, 0, '', 0),
(9, 1, '1,4', 0, 1, 'Trần Thị Thu', 0, 1445391118, 1445394180, 1, 7, 1445391060, 0, 2, 'Chương trình thực tập sinh tại công ty VINADES', 'chuong-trinh-thuc-tap-sinh-tai-cong-ty-vinades', 'Cơ hội để những sinh viên năng động được học tập, trải nghiệm, thử thách sớm với những tình huống thực tế, được làm việc cùng các chuyên gia có nhiều kinh nghiệm của công ty VINADES.', 'thuc-tap-sinh.jpg', '', 1, 1, '4', 1, 0, 0, 0, 0, 0, 0, '', 0),
(10, 4, '4', 0, 1, 'Trần Thị Thu', 0, 1445391135, 1445394444, 1, 8, 1445391120, 0, 2, 'Học việc tại công ty VINADES', 'hoc-viec-tai-cong-ty-vinades', 'Công ty cổ phần phát triển nguồn mở Việt Nam tạo cơ hội việc làm và học việc miễn phí cho những ứng viên có đam mê thiết kế web, lập trình PHP… được học tập và rèn luyện cùng đội ngũ lập trình viên phát triển NukeViet.', 'hoc-viec-tai-cong-ty-vinades.jpg', '', 1, 1, '4', 1, 0, 0, 0, 0, 0, 0, '', 0),
(3, 4, '4', 0, 1, 'Phạm Quốc Tiến', 2, 1453192400, 1453192400, 1, 11, 1453192400, 0, 2, 'Tuyển dụng lập trình viên PHP phát triển NukeViet', 'Tuyen-dung-lap-trinh-vien-PHP', 'Bạn đam mê nguồn mở? Bạn đang cần tìm một công việc phù hợp với thế mạnh của bạn về PHP và MySQL? Hãy gia nhập VINADES.,JSC để xây dựng mã nguồn mở hàng đầu cho Việt Nam.', 'tuyendung-kythuat.jpg', 'Tuyển dụng', 1, 1, '6', 1, 0, 0, 0, 0, 0, 0, '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_vi_news_5`
--

DROP TABLE IF EXISTS `nv5_vi_news_5`;
CREATE TABLE `nv5_vi_news_5` (
  `id` int(11) UNSIGNED NOT NULL,
  `catid` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `listcatid` varchar(255) NOT NULL DEFAULT '',
  `topicid` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `admin_id` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `author` varchar(250) DEFAULT '',
  `sourceid` mediumint(8) NOT NULL DEFAULT 0,
  `addtime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `edittime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `status` tinyint(4) NOT NULL DEFAULT 1,
  `weight` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `publtime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `exptime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `archive` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `title` varchar(250) NOT NULL DEFAULT '',
  `alias` varchar(250) NOT NULL DEFAULT '',
  `hometext` text NOT NULL,
  `homeimgfile` varchar(255) DEFAULT '',
  `homeimgalt` varchar(255) DEFAULT '',
  `homeimgthumb` tinyint(4) NOT NULL DEFAULT 0,
  `inhome` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `allowed_comm` varchar(255) DEFAULT '',
  `allowed_rating` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `external_link` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `hitstotal` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `hitscm` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `total_rating` int(11) NOT NULL DEFAULT 0,
  `click_rating` int(11) NOT NULL DEFAULT 0,
  `instant_active` tinyint(1) NOT NULL DEFAULT 0,
  `instant_template` varchar(100) NOT NULL DEFAULT '',
  `instant_creatauto` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_vi_news_5`
--

INSERT INTO `nv5_vi_news_5` (`id`, `catid`, `listcatid`, `topicid`, `admin_id`, `author`, `sourceid`, `addtime`, `edittime`, `status`, `weight`, `publtime`, `exptime`, `archive`, `title`, `alias`, `hometext`, `homeimgfile`, `homeimgalt`, `homeimgthumb`, `inhome`, `allowed_comm`, `allowed_rating`, `external_link`, `hitstotal`, `hitscm`, `total_rating`, `click_rating`, `instant_active`, `instant_template`, `instant_creatauto`) VALUES
(1, 1, '1,5,7', 0, 1, 'Quỳnh Nhi', 1, 1274989177, 1275318126, 1, 1, 1274989140, 0, 2, 'Ra mắt công ty mã nguồn mở đầu tiên tại Việt Nam', 'Ra-mat-cong-ty-ma-nguon-mo-dau-tien-tai-Viet-Nam', 'Mã nguồn mở NukeViet vốn đã quá quen thuộc với cộng đồng CNTT Việt Nam trong mấy năm qua. Tuy chưa hoạt động chính thức, nhưng chỉ trong khoảng 5 năm gần đây, mã nguồn mở NukeViet đã được dùng phổ biến ở Việt Nam, áp dụng ở hầu hết các lĩnh vực, từ tin tức đến thương mại điện tử, từ các website cá nhân cho tới những hệ thống website doanh nghiệp.', 'nangly.jpg', 'Thành lập VINADES.,JSC', 1, 1, '6', 1, 0, 2, 0, 0, 0, 0, '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_vi_news_6`
--

DROP TABLE IF EXISTS `nv5_vi_news_6`;
CREATE TABLE `nv5_vi_news_6` (
  `id` int(11) UNSIGNED NOT NULL,
  `catid` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `listcatid` varchar(255) NOT NULL DEFAULT '',
  `topicid` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `admin_id` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `author` varchar(250) DEFAULT '',
  `sourceid` mediumint(8) NOT NULL DEFAULT 0,
  `addtime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `edittime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `status` tinyint(4) NOT NULL DEFAULT 1,
  `weight` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `publtime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `exptime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `archive` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `title` varchar(250) NOT NULL DEFAULT '',
  `alias` varchar(250) NOT NULL DEFAULT '',
  `hometext` text NOT NULL,
  `homeimgfile` varchar(255) DEFAULT '',
  `homeimgalt` varchar(255) DEFAULT '',
  `homeimgthumb` tinyint(4) NOT NULL DEFAULT 0,
  `inhome` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `allowed_comm` varchar(255) DEFAULT '',
  `allowed_rating` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `external_link` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `hitstotal` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `hitscm` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `total_rating` int(11) NOT NULL DEFAULT 0,
  `click_rating` int(11) NOT NULL DEFAULT 0,
  `instant_active` tinyint(1) NOT NULL DEFAULT 0,
  `instant_template` varchar(100) NOT NULL DEFAULT '',
  `instant_creatauto` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_vi_news_6`
--

INSERT INTO `nv5_vi_news_6` (`id`, `catid`, `listcatid`, `topicid`, `admin_id`, `author`, `sourceid`, `addtime`, `edittime`, `status`, `weight`, `publtime`, `exptime`, `archive`, `title`, `alias`, `hometext`, `homeimgfile`, `homeimgalt`, `homeimgthumb`, `inhome`, `allowed_comm`, `allowed_rating`, `external_link`, `hitstotal`, `hitscm`, `total_rating`, `click_rating`, `instant_active`, `instant_template`, `instant_creatauto`) VALUES
(6, 1, '1,6', 0, 1, '', 3, 1322685920, 1322686042, 1, 2, 1322685920, 0, 2, 'Mã nguồn mở NukeViet giành giải ba Nhân tài đất Việt 2011', 'Ma-nguon-mo-NukeViet-gianh-giai-ba-Nhan-tai-dat-Viet-2011', 'Không có giải nhất và giải nhì, sản phẩm Mã nguồn mở NukeViet của VINADES.,JSC là một trong ba sản phẩm đã đoạt giải ba Nhân tài đất Việt 2011 - Lĩnh vực Công nghệ thông tin (Sản phẩm đã ứng dụng rộng rãi).', 'nukeviet-nhantaidatviet2011.jpg', 'Mã nguồn mở NukeViet giành giải ba Nhân tài đất Việt 2011', 1, 1, '6', 1, 0, 1, 0, 0, 0, 0, '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_vi_news_7`
--

DROP TABLE IF EXISTS `nv5_vi_news_7`;
CREATE TABLE `nv5_vi_news_7` (
  `id` int(11) UNSIGNED NOT NULL,
  `catid` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `listcatid` varchar(255) NOT NULL DEFAULT '',
  `topicid` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `admin_id` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `author` varchar(250) DEFAULT '',
  `sourceid` mediumint(8) NOT NULL DEFAULT 0,
  `addtime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `edittime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `status` tinyint(4) NOT NULL DEFAULT 1,
  `weight` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `publtime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `exptime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `archive` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `title` varchar(250) NOT NULL DEFAULT '',
  `alias` varchar(250) NOT NULL DEFAULT '',
  `hometext` text NOT NULL,
  `homeimgfile` varchar(255) DEFAULT '',
  `homeimgalt` varchar(255) DEFAULT '',
  `homeimgthumb` tinyint(4) NOT NULL DEFAULT 0,
  `inhome` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `allowed_comm` varchar(255) DEFAULT '',
  `allowed_rating` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `external_link` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `hitstotal` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `hitscm` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `total_rating` int(11) NOT NULL DEFAULT 0,
  `click_rating` int(11) NOT NULL DEFAULT 0,
  `instant_active` tinyint(1) NOT NULL DEFAULT 0,
  `instant_template` varchar(100) NOT NULL DEFAULT '',
  `instant_creatauto` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_vi_news_7`
--

INSERT INTO `nv5_vi_news_7` (`id`, `catid`, `listcatid`, `topicid`, `admin_id`, `author`, `sourceid`, `addtime`, `edittime`, `status`, `weight`, `publtime`, `exptime`, `archive`, `title`, `alias`, `hometext`, `homeimgfile`, `homeimgalt`, `homeimgthumb`, `inhome`, `allowed_comm`, `allowed_rating`, `external_link`, `hitstotal`, `hitscm`, `total_rating`, `click_rating`, `instant_active`, `instant_template`, `instant_creatauto`) VALUES
(1, 1, '1,5,7', 0, 1, 'Quỳnh Nhi', 1, 1274989177, 1275318126, 1, 1, 1274989140, 0, 2, 'Ra mắt công ty mã nguồn mở đầu tiên tại Việt Nam', 'Ra-mat-cong-ty-ma-nguon-mo-dau-tien-tai-Viet-Nam', 'Mã nguồn mở NukeViet vốn đã quá quen thuộc với cộng đồng CNTT Việt Nam trong mấy năm qua. Tuy chưa hoạt động chính thức, nhưng chỉ trong khoảng 5 năm gần đây, mã nguồn mở NukeViet đã được dùng phổ biến ở Việt Nam, áp dụng ở hầu hết các lĩnh vực, từ tin tức đến thương mại điện tử, từ các website cá nhân cho tới những hệ thống website doanh nghiệp.', 'nangly.jpg', 'Thành lập VINADES.,JSC', 1, 1, '6', 1, 0, 2, 0, 0, 0, 0, '', 0),
(2, 7, '1,7', 0, 1, 'Nguyễn Thế Hùng', 7, 1453192444, 1453192444, 1, 12, 1453192444, 0, 2, 'Hãy trở thành nhà cung cấp dịch vụ của NukeViet&#33;', 'hay-tro-thanh-nha-cung-cap-dich-vu-cua-nukeviet', 'Nếu bạn là công ty hosting, là công ty thiết kế web có sử dụng mã nguồn NukeViet, là cơ sở đào tạo NukeViet hay là công ty bất kỳ có kinh doanh dịch vụ liên quan đến NukeViet... hãy cho chúng tôi biết thông tin liên hệ của bạn để NukeViet hỗ trợ bạn trong công việc kinh doanh nhé!', 'hoptac.jpg', '', 1, 1, '6', 1, 0, 13, 0, 0, 0, 0, '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_vi_news_admins`
--

DROP TABLE IF EXISTS `nv5_vi_news_admins`;
CREATE TABLE `nv5_vi_news_admins` (
  `userid` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `catid` smallint(5) NOT NULL DEFAULT 0,
  `admin` tinyint(4) NOT NULL DEFAULT 0,
  `add_content` tinyint(4) NOT NULL DEFAULT 0,
  `pub_content` tinyint(4) NOT NULL DEFAULT 0,
  `edit_content` tinyint(4) NOT NULL DEFAULT 0,
  `del_content` tinyint(4) NOT NULL DEFAULT 0,
  `app_content` tinyint(4) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_vi_news_author`
--

DROP TABLE IF EXISTS `nv5_vi_news_author`;
CREATE TABLE `nv5_vi_news_author` (
  `id` mediumint(8) UNSIGNED NOT NULL,
  `uid` int(11) UNSIGNED NOT NULL,
  `alias` varchar(100) NOT NULL DEFAULT '',
  `pseudonym` varchar(100) NOT NULL DEFAULT '',
  `image` varchar(255) DEFAULT '',
  `description` text DEFAULT NULL,
  `add_time` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `edit_time` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `active` tinyint(1) UNSIGNED NOT NULL DEFAULT 1,
  `numnews` mediumint(8) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_vi_news_authorlist`
--

DROP TABLE IF EXISTS `nv5_vi_news_authorlist`;
CREATE TABLE `nv5_vi_news_authorlist` (
  `id` int(11) NOT NULL,
  `aid` mediumint(8) NOT NULL,
  `alias` varchar(100) NOT NULL DEFAULT '',
  `pseudonym` varchar(100) NOT NULL DEFAULT ''
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_vi_news_block`
--

DROP TABLE IF EXISTS `nv5_vi_news_block`;
CREATE TABLE `nv5_vi_news_block` (
  `bid` smallint(5) UNSIGNED NOT NULL,
  `id` int(11) UNSIGNED NOT NULL,
  `weight` int(11) UNSIGNED NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_vi_news_block`
--

INSERT INTO `nv5_vi_news_block` (`bid`, `id`, `weight`) VALUES
(1, 1, 1),
(2, 12, 1),
(2, 11, 2),
(2, 10, 3),
(2, 9, 4),
(2, 8, 5),
(2, 7, 6),
(2, 1, 7),
(2, 2, 8);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_vi_news_block_cat`
--

DROP TABLE IF EXISTS `nv5_vi_news_block_cat`;
CREATE TABLE `nv5_vi_news_block_cat` (
  `bid` smallint(5) UNSIGNED NOT NULL,
  `adddefault` tinyint(4) NOT NULL DEFAULT 0,
  `numbers` smallint(5) NOT NULL DEFAULT 10,
  `title` varchar(250) NOT NULL DEFAULT '',
  `alias` varchar(250) NOT NULL DEFAULT '',
  `image` varchar(255) DEFAULT '',
  `description` varchar(255) DEFAULT '',
  `weight` smallint(5) NOT NULL DEFAULT 0,
  `keywords` text DEFAULT NULL,
  `add_time` int(11) NOT NULL DEFAULT 0,
  `edit_time` int(11) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_vi_news_block_cat`
--

INSERT INTO `nv5_vi_news_block_cat` (`bid`, `adddefault`, `numbers`, `title`, `alias`, `image`, `description`, `weight`, `keywords`, `add_time`, `edit_time`) VALUES
(1, 0, 4, 'Tin tiêu điểm', 'Tin-tieu-diem', '', 'Tin tiêu điểm', 1, '', 1279945710, 1279956943),
(2, 1, 4, 'Tin mới nhất', 'Tin-moi-nhat', '', 'Tin mới nhất', 2, '', 1279945725, 1279956445);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_vi_news_cat`
--

DROP TABLE IF EXISTS `nv5_vi_news_cat`;
CREATE TABLE `nv5_vi_news_cat` (
  `catid` smallint(5) UNSIGNED NOT NULL,
  `parentid` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `title` varchar(250) NOT NULL,
  `titlesite` varchar(250) DEFAULT '',
  `alias` varchar(250) NOT NULL DEFAULT '',
  `description` text DEFAULT NULL,
  `descriptionhtml` text DEFAULT NULL,
  `image` varchar(255) DEFAULT '',
  `viewdescription` tinyint(2) NOT NULL DEFAULT 0,
  `weight` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `sort` smallint(5) NOT NULL DEFAULT 0,
  `lev` smallint(5) NOT NULL DEFAULT 0,
  `viewcat` varchar(50) NOT NULL DEFAULT 'viewcat_page_new',
  `numsubcat` smallint(5) NOT NULL DEFAULT 0,
  `subcatid` varchar(255) DEFAULT '',
  `numlinks` tinyint(2) UNSIGNED NOT NULL DEFAULT 3,
  `newday` tinyint(2) UNSIGNED NOT NULL DEFAULT 2,
  `featured` int(11) NOT NULL DEFAULT 0,
  `ad_block_cat` varchar(255) NOT NULL DEFAULT '',
  `layout_func` varchar(100) NOT NULL DEFAULT '' COMMENT 'Layout khi xem chuyên mục',
  `keywords` text DEFAULT NULL,
  `admins` text DEFAULT NULL,
  `add_time` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `edit_time` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `groups_view` varchar(255) DEFAULT '',
  `status` smallint(4) NOT NULL DEFAULT 1
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_vi_news_cat`
--

INSERT INTO `nv5_vi_news_cat` (`catid`, `parentid`, `title`, `titlesite`, `alias`, `description`, `descriptionhtml`, `image`, `viewdescription`, `weight`, `sort`, `lev`, `viewcat`, `numsubcat`, `subcatid`, `numlinks`, `newday`, `featured`, `ad_block_cat`, `layout_func`, `keywords`, `admins`, `add_time`, `edit_time`, `groups_view`, `status`) VALUES
(1, 0, 'Tin tức', '', 'Tin-tuc', '', '', '', 0, 1, 1, 0, 'viewcat_main_right', 3, '5,6,7', 4, 2, 0, '', '', '', '', 1274986690, 1274986690, '6', 1),
(2, 0, 'Sản phẩm', '', 'San-pham', '', '', '', 0, 2, 5, 0, 'viewcat_page_new', 0, '', 4, 2, 0, '', '', '', '', 1274986705, 1274986705, '6', 1),
(3, 0, 'Đối tác', '', 'Doi-tac', '', '', '', 0, 3, 9, 0, 'viewcat_page_new', 0, '', 4, 2, 0, '', '', '', '', 1274987460, 1274987460, '6', 1),
(4, 0, 'Tuyển dụng', '', 'Tuyen-dung', '', '', '', 0, 4, 12, 0, 'viewcat_page_new', 0, '', 4, 2, 0, '', '', '', '', 1274987538, 1274987538, '6', 1),
(5, 1, 'Thông cáo báo chí', '', 'thong-cao-bao-chi', '', '', '', 0, 1, 2, 1, 'viewcat_page_new', 0, '', 4, 2, 0, '', '', '', '', 1274987105, 1274987244, '6', 1),
(6, 1, 'Tin công nghệ', '', 'Tin-cong-nghe', '', '', '', 0, 3, 4, 1, 'viewcat_page_new', 0, '', 4, 2, 0, '', '', '', '', 1274987212, 1274987212, '6', 1),
(7, 1, 'Bản tin nội bộ', '', 'Ban-tin-noi-bo', '', '', '', 0, 2, 3, 1, 'viewcat_page_new', 0, '', 4, 2, 0, '', '', '', '', 1274987902, 1274987902, '6', 1);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_vi_news_config_post`
--

DROP TABLE IF EXISTS `nv5_vi_news_config_post`;
CREATE TABLE `nv5_vi_news_config_post` (
  `group_id` smallint(5) NOT NULL,
  `addcontent` tinyint(4) NOT NULL,
  `postcontent` tinyint(4) NOT NULL,
  `editcontent` tinyint(4) NOT NULL,
  `delcontent` tinyint(4) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_vi_news_detail`
--

DROP TABLE IF EXISTS `nv5_vi_news_detail`;
CREATE TABLE `nv5_vi_news_detail` (
  `id` int(11) UNSIGNED NOT NULL,
  `titlesite` varchar(255) NOT NULL DEFAULT '',
  `description` text NOT NULL,
  `bodyhtml` longtext NOT NULL,
  `voicedata` text DEFAULT NULL COMMENT 'Data giọng đọc json',
  `keywords` varchar(255) DEFAULT '',
  `sourcetext` varchar(255) DEFAULT '',
  `files` text DEFAULT NULL,
  `imgposition` tinyint(1) NOT NULL DEFAULT 1,
  `layout_func` varchar(100) DEFAULT '',
  `copyright` tinyint(1) NOT NULL DEFAULT 0,
  `allowed_send` tinyint(1) NOT NULL DEFAULT 0,
  `allowed_print` tinyint(1) NOT NULL DEFAULT 0,
  `allowed_save` tinyint(1) NOT NULL DEFAULT 0,
  `auto_nav` tinyint(1) NOT NULL DEFAULT 0,
  `group_view` varchar(255) DEFAULT '',
  `localization` text DEFAULT NULL COMMENT 'Json url ngôn ngữ khác của bài viết',
  `related_ids` varchar(255) NOT NULL DEFAULT '' COMMENT 'ID bài đăng liên quan',
  `related_pos` tinyint(1) NOT NULL DEFAULT 2 COMMENT 'Vị trí bài liên quan: 0 tắt, 1 dưới mô tả ngắn gọn, 2 dưới cùng bài đăng'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_vi_news_detail`
--

INSERT INTO `nv5_vi_news_detail` (`id`, `titlesite`, `description`, `bodyhtml`, `voicedata`, `keywords`, `sourcetext`, `files`, `imgposition`, `layout_func`, `copyright`, `allowed_send`, `allowed_print`, `allowed_save`, `auto_nav`, `group_view`, `localization`, `related_ids`, `related_pos`) VALUES
(1, '', '', '<p>Để chuyên nghiệp hóa việc phát hành mã nguồn mở NukeViet, Ban quản trị NukeViet quyết định thành lập doanh nghiệp chuyên quản NukeViet mang tên Công ty cổ phần Phát triển nguồn mở Việt Nam (Viết tắt là VINADES.,JSC), chính thức ra mắt vào ngày 25-2-2010 (trụ sở tại Hà Nội) nhằm phát triển, phổ biến hệ thống NukeViet tại Việt Nam.<br /> <br /> Theo ông Nguyễn Anh Tú, Chủ tịch HĐQT VINADES, công ty sẽ phát triển bộ mã nguồn NukeViet nhất quán theo con đường mã nguồn mở đã chọn, chuyên nghiệp và quy mô hơn bao giờ hết. Đặc biệt là hoàn toàn miễn phí đúng tinh thần mã nguồn mở quốc tế.<br /> <br /> NukeViet là một hệ quản trị nội dung mã nguồn mở (Opensource Content Management System) thuần Việt từ nền tảng PHP-Nuke và cơ sở dữ liệu MySQL. Người sử dụng thường gọi NukeViet là portal vì nó có khả năng tích hợp nhiều ứng dụng trên nền web, cho phép người sử dụng có thể dễ dàng xuất bản và quản trị các nội dung của họ lên internet hoặc intranet.<br /> <br /> NukeViet cung cấp nhiều dịch vụ và ứng dụng nhờ khả năng tăng cường tính năng thêm các module, block... tạo sự dễ dàng cài đặt, quản lý, ngay cả với những người mới tiếp cận với website. Người dùng có thể tìm hiểu thêm thông tin và tải về sản phẩm tại địa chỉ https://nukeviet.vn</p><blockquote> <p> <em>Thông tin ra mắt công ty VINADES có thể tìm thấy trên trang 7 báo Hà Nội Mới ra ngày 25/02/2010 (<a href=\"http://hanoimoi.com.vn/newsdetail/Cong_nghe/309750/ra-mat-cong-ty-ma-nguon-mo-dau-tien-tai-viet-nam.htm\" target=\"_blank\">xem chi tiết</a>), Bản tin tiếng Anh của đài tiếng nói Việt Nam ngày 26/02/2010 (<a href=\"http://english.vovnews.vn/Home/First-opensource-company-starts-operation/20102/112960.vov\" target=\"_blank\">xem chi tiết</a>); trang 7 báo An ninh Thủ Đô số 2858 ra vào thứ 2 ngày 01/03/2010 và các trang tin tức, báo điện tử khác.</em></p></blockquote>', NULL, '', 'http://hanoimoi.com.vn/newsdetail/Cong_nghe/309750/ra-mat-cong-ty-ma-nguon-mo-dau-tien-tai-viet-nam.htm', NULL, 2, '', 0, 1, 1, 1, 0, '', NULL, '', 2),
(2, '', '', '<div>Tính đến năm 2015, ước tính có hơn 10.000 website đang sử dụng NukeViet. Nhu cầu triển khai NukeViet không chỉ dừng lại ở các cá nhân, doanh nghiệp, cơ sở giáo dục mà đã lan rộng ra khối chính phủ.</div><div><br  />Cộng đồng NukeViet cũng đã lớn mạnh hơn trước. Nếu như đầu năm 2010, ngoài Công ty VINADES chỉ có một vài công ty cung cấp dịch vụ cho NukeViet nhưng không chuyên, thì theo thống kê năm 2015 đã có hàng trăm doanh nghiệp đang cung cấp dịch vụ có liên quan đến NukeViet như: đào tạo NukeViet, thiết kế web, phát triển phần mềm, cung cấp giao diện, module... trên nền tảng NukeViet. Đặc biệt có nhiều doanh nghiệp hoàn toàn cung cấp dịch vụ thiết kế web, cung cấp giao diện, module... sử dụng nền tảng NukeViet. Nhiều sản phẩm phái sinh từ NukeViet đã ra đời, NukeViet được phát triển thành nhiều phần mềm quản lý sử dụng trên mạng LAN hay trên internet, được phát triển thành các phần mềm dùng riêng hay sử dụng như một nền tảng để cung cấp dịch vụ online, thậm chí đã được thử nghiệm tích hợp vào trong các thiết bị phần cứng để bán cùng thiết bị (NukeViet Captive Portal - dùng để quản lý người dùng truy cập internet, tích hợp trong thiết bị quản lý wifi)...<br  /><br  />Tuy nhiên, cùng với những cơ hội, cộng đồng NukeViet đang đứng trước một thách thức mới. NukeViet cần tập hợp tất cả các doanh nghiệp, tổ chức và cá nhân đang cung cấp dịch vụ cho NukeViet và liên kết các đơn vị này với nhau để giúp nhau chuyên nghiệp hóa, cùng nhau chia sẻ những cơ hội kinh doanh và trở lên lớn mạnh hơn.<br  /><br  />Nếu cộng đồng NukeViet có 500 công ty siêu nhỏ chỉ 2-3 người và những công ty này đứng riêng rẽ như hiện nay thì NukeViet mãi bé nhỏ và sẽ không làm được việc gì. Nhưng nếu 500 công ty này biết nhau, cùng làm một số việc, cùng tham gia phát triển NukeViet, đó sẽ là sức mạnh rất lớn cho một phần mềm nguồn mở như NukeViet, và đó cũng là cơ hội rất lớn để các công ty nhỏ ấy trở lên chuyên nghiệp và vững mạnh.<br  /><br  />Cho dù bạn là doanh nghiệp hay một nhóm kinh doanh, cho dù bạn đang cung cấp bất kỳ dịch vụ có liên quan trực tiếp đến NukeViet như: đào tạo NukeViet, thiết kế web, phát triển phần mềm, cung cấp giao diện, module... hoặc gián tiếp có liên quan đến NukeViet (ví dụ các công ty hosting, các nhà cung cấp dịch vụ thanh toán điện tử...). Bạn đều là một thành phần quan trọng của NukeViet. Dù bạn là công ty to hay một nhóm nhỏ, hãy đăng ký vào danh sách các đối tác của NukeViet để thiết lập kênh liên lạc với các doanh nghiệp khác trong cộng đồng NukeViet và nhận sự hỗ trợ từ Ban Quản Trị NukeViet cũng như từ các cơ quan nhà nước đang có nhu cầu tìm kiếm các đơn vị cung ứng dịch vụ cho NukeViet.<br  /><br  />Hãy gửi email cho Ban Quản Trị NukeViet về địa chỉ: admin@nukeviet.vn để đăng ký vào danh sách các đơn vị hỗ trợ NukeViet.<br  /><br  />Tiêu đề email: Đăng ký vào danh sách các đơn vị cung cấp dịch vụ dựa trên NukeViet<br  />Nội dung email: Thông tin về đơn vị, dịch vụ cung cấp.<br  /><br  />Hoặc gửi yêu cầu tại đây: <a href=\"https://nukeviet.vn/vi/contact/\" target=\"_blank\">https://nukeviet.vn/vi/contact/</a><br  /><br  />Mọi yêu cầu sẽ được phản hồi trong vòng 24h. Trường hợp không nhận được phản hồi, hãy liên hệ với Ban Quản Trị NukeViet qua các kênh liên lạc khác như:<br  /><br  />- Diễn đàn doanh nghiệp NukeViet: <a href=\"http://forum.nukeviet.vn/viewforum.php?f=4\" target=\"_blank\">http://forum.nukeviet.vn/viewforum.php?f=4</a><br  />- Fanpage NukeViet trên FaceBook: <a href=\"http://fb.com/nukeviet/\" target=\"_blank\">http://fb.com/nukeviet/</a><br  /><br  />Vui lòng truy cập địa chỉ sau để xem danh sách các đơn vị: <a href=\"https://nukeviet.vn/vi/partner/\" target=\"_blank\">https://nukeviet.vn/vi/partner/</a></div>', NULL, '', 'https://vinades.vn/vi/news/thong-cao-bao-chi/Thu-moi-hop-tac-6/', NULL, 2, '', 0, 1, 1, 1, 0, '', NULL, '', 2),
(3, '', '', 'Công ty cổ phần phát triển nguồn mở Việt Nam (VINADES.,JSC) đang thu hút tuyển dụng nhân tài ở các vị trí:<ol><li><a href=\"/Tuyen-dung/Tuyen-dung-lap-trinh-vien-PHP-7.html\">Lập trình viên PHP và MySQL.</a></li><li><a href=\"/Tuyen-dung/Tuyen-dung-lap-trinh-vien-front-end-HTML-CSS-JS-9.html\">Lập trình viên front-end (HTML/CSS/JS).</a></li><li><a href=\"/Tuyen-dung/Tuyen-dung-chuyen-vien-do-hoa-8.html\">Chuyên Viên Đồ Hoạ.</a></li></ol><br />Tại VINADES.,JSC bạn sẽ được tham gia các dự án của công ty, tham gia xây dựng và phát triển bộ nhân hệ thống NukeViet, được học hỏi và trau dồi nâng cao kiến thức và kỹ năng cá nhân. Ngoài ra, nếu bạn đam mê về nguồn mở và có mong muốn cống hiến cho quá trình phát triển nguồn mở của Việt Nam nói riêng và của thế giới nói chung, thì đây là cơ hội lớn nhất để bạn đạt được mong muốn của mình. Tham gia công tác tại công ty là bạn đã góp phần xây dựng một cộng đồng nguồn mở chuyên nghiệp cho Việt Nam để vươn xa ra thế giới.<br /><br /><span style=\"font-size:16px;\"><strong>1. Vị trí dự tuyển:</strong></span> Lập trình viên PHP và MySQL<br /><br /><span style=\"font-size:16px;\"><strong>2. Mô tả công việc:</strong></span><ul><li>Phát triển hệ thống NukeViet.</li><li>Phân tích yêu cầu và lập trình riêng cho các dự án cụ thể.</li><li>Thực hiện các công đoạn để dưa website vào hoạt động như upload dữ liệu lên host, xử lý lỗi, sự cố liên quan.</li><li>Chịu trách nhiệm về chất lượng, trải nghiệm người dùng của sản phẩm trong khi sản phẩm hoạt động.</li><li>Thực hiện các công việc theo sự phân công của cấp trên.</li><li>Chịu trách nhiệm về chất lượng và tiến độ công việc.</li></ul><br /><span style=\"font-size:16px;\"><strong>3. Yêu cầu:</strong></span><ul><li>Nắm vững kiến thức hướng đối tượng, cấu trúc dữ liệu và giải thuật.</li><li>Có kinh nghiệm về PHP và các hệ cơ sở dữ liệu MySQL.…</li><li>Tư duy lập trình tốt, thiết kế CSDL chuẩn, biết xử lý nhanh các vấn đề khi phát sinh nghiệp vụ mới.</li><li>Sửa được các lỗi, nâng cấp tính năng cho các module đã có. 6. Viết module mới.</li><li>Biết đưa website lên host, xử lý lỗi, sự cố liên quan.</li><li>Chịu trách nhiệm về chất lượng và tiến độ công việc phụ trách.</li><li>Khả năng sáng tạo.</li><li>Đam mê công việc về lập trình web.</li></ul><br /><em><strong>Ưu tiên các ứng viên:</strong></em><ul><li>Có kiến thức cơ bản về quản trị website NukeViệt.</li><li>Sử dụng và nắm rõ các tính năng, block thường dùng của NukeViet.</li><li>Biết sử dụng git để quản lý source code (nếu ứng viên chưa biết công ty sẽ đào tạo thêm).</li><li>Có khả năng giao tiếp với khách hàng (Trực tiếp, điện thoại, email).</li><li>Có khả năng làm việc độc lập và làm việc theo nhóm.</li><li>Có tinh thần trách nhiệm cao và chủ động trong công việc.</li><li>Có khả năng trình bày ý tưởng.</li></ul><br /><span style=\"font-size:16px;\"><strong>4. Quyền lợi:</strong></span><ul><li>Lương thoả thuận, trả qua ATM.</li><li>Thưởng theo dự án, các ngày lễ tết.</li><li>Hưởng các chế độ khác theo quy định của công ty và pháp luật: Bảo hiểm y tế, bảo hiểm xã hội...</li></ul><br /><span style=\"font-size:16px;\"><strong>5. Thời gian làm việc:</strong></span> Toàn thời gian cố định hoặc làm online.<br /><br /><span style=\"font-size:16px;\"><strong>6. Hạn nộp hồ sơ:</strong></span> Không hạn chế, vui lòng kiểm tra tại <a href=\"https://vinades.vn/vi/news/Tuyen-dung/\">https://vinades.vn/vi/news/Tuyen-dung/</a><br /><br /><span style=\"font-size:16px;\"><strong>7. Cách thức đăng ký dự tuyển:</strong></span> Làm Hồ sơ xin việc<em><strong> (download tại đây: <strong><a href=\"https://vinades.vn/vi/download/Tai-lieu/Ban-khai-so-yeu-ly-lich-ky-thuat-vien/\" target=\"_blank\"><u>Mẫu lý lịch ứng viên</u></a></strong>)</strong></em> và gửi về hòm thư <a href=\"mailto:tuyendung@vinades.vn\">tuyendung@vinades.vn</a><br /><br /><span style=\"font-size:16px;\"><strong>8. Hồ sơ bao gồm:</strong></span><ul><li>Đơn xin việc: Tự biên soạn.</li><li>Thông tin ứng viên: Theo mẫu của VINADES.,JSC</li></ul>&nbsp;<p><strong>Chi tiết vui lòng tham khảo tại:</strong> <a href=\"https://vinades.vn/vi/news/Tuyen-dung/\" target=\"_blank\">https://vinades.vn/vi/news/Tuyen-dung/</a><br /><br /><strong>Mọi thắc mắc vui lòng liên hệ:</strong></p><blockquote><p><strong>Công ty cổ phần phát triển nguồn mở Việt Nam.</strong><br />Trụ sở chính: Tầng 6, tòa nhà Sông Đà, 131 Trần Phú, Văn Quán, Hà Đông, Hà Nội.</p><div>- Tel: +84-24-85872007 - Fax: +84-24-35500914<br />- Email: <a href=\"mailto:contact@vinades.vn\">contact@vinades.vn</a> - Website: <a href=\"http://www.vinades.vn/\">http://www.vinades.vn</a></div></blockquote>', NULL, '', 'https://vinades.vn/vi/news/Tuyen-dung/', NULL, 2, '', 0, 1, 1, 1, 0, '', NULL, '', 2),
(4, '', '', 'Công ty cổ phần phát triển nguồn mở Việt Nam (VINADES.,JSC) đang thu hút tuyển dụng nhân tài ở các vị trí:<ol><li><a href=\"/Tuyen-dung/Tuyen-dung-lap-trinh-vien-PHP-7.html\">Lập trình viên PHP và MySQL.</a></li><li><a href=\"/Tuyen-dung/Tuyen-dung-lap-trinh-vien-front-end-HTML-CSS-JS-9.html\">Lập trình viên front-end (HTML/CSS/JS).</a></li><li><a href=\"/Tuyen-dung/Tuyen-dung-chuyen-vien-do-hoa-8.html\">Chuyên Viên Đồ Hoạ.</a></li></ol><br />Tại VINADES.,JSC bạn sẽ được tham gia các dự án của công ty, tham gia xây dựng và phát triển bộ nhân hệ thống NukeViet, được học hỏi và trau dồi nâng cao kiến thức và kỹ năng cá nhân. Ngoài ra, nếu bạn đam mê về nguồn mở và có mong muốn cống hiến cho quá trình phát triển nguồn mở của Việt Nam nói riêng và của thế giới nói chung, thì đây là cơ hội lớn nhất để bạn đạt được mong muốn của mình. Tham gia công tác tại công ty là bạn đã góp phần xây dựng một cộng đồng nguồn mở chuyên nghiệp cho Việt Nam để vươn xa ra thế giới.<br /><br /><span style=\"font-size:16px;\"><strong>1. Vị trí dự tuyển:</strong></span> Chuyên viên đồ hoạ.<br /><br /><span style=\"font-size:16px;\"><strong>2. Mô tả công việc:</strong></span><br /><br /><em><strong>Công việc chính:</strong></em><ul><li>Thiết kế layout, banner, logo website theo yêu cầu của dự án.</li><li>Đưa ra sản phẩm sáng tạo dựa trên ý tưởng của khách hàng.</li><li>Thực hiện các công việc theo sự phân công của cấp trên.</li><li>Chịu trách nhiệm về chất lượng và tiến độ công việc.</li></ul><br /><em><strong>Ngoài ra bạn cần có khả năng thực hiện các công việc sau:</strong></em><ul><li>Cắt và ghép giao diện cho hệ thống.</li><li>Valid CSS, xHTML.</li></ul><br /><span style=\"font-size:16px;\"><strong>3. Yêu cầu:</strong></span><ul><li>Sử dụng thành thạo phần mềm thiết kế: Photoshop ngoài ra cần biết cách sử dụng các phần mềm thiết kế khác là một lợi thế.</li><li>Có kiến thức cơ bản về thiết kế website: Am hiểu các dạng layout, thành phần của một website.</li><li>Có kinh nghiệm, kỹ năng thiết kế giao diện web, logo, banner.</li><li>Chịu trách nhiệm về chất lượng và tiến độ công việc phụ trách.</li><li>Khả năng sáng tạo, tính thẩm mỹ tốt</li><li>Đam mê công việc thiết kế và website.</li></ul><br /><em><strong>Ưu tiên các ứng viên:</strong></em><ul><li>Có kiến thức cơ bản về quản trị website NukeViệt</li><li>Am hiểu về Responsive và có thể thiết kế giao diện, layout trên mobile (Boostrap).</li><li>Sử dụng và nắm rõ các tính năng, block thường dùng của NukeViet.</li><li>Biết sử dụng git để quản lý source code (nếu ứng viên chưa biết công ty sẽ đào tạo thêm).</li><li>Sử dụng thành thạo HTML5, CSS3 &amp; Javascrip/Jquery và Xtemplate</li><li>Khả năng chuyển PSD sang NukeViet tốt.</li><li>Hiểu rõ và nắm chắc cách làm Theme/Template.</li><li>Có khả năng giao tiếp với khách hàng (Trực tiếp, điện thoại, email).</li><li>Có khả năng làm việc độc lập và làm việc theo nhóm.</li><li>Có tinh thần trách nhiệm cao và chủ động trong công việc.</li><li>Có khả năng trình bày ý tưởng</li></ul><br /><span style=\"font-size:16px;\"><strong>4. Quyền lợi:</strong></span><ul><li>Lương thoả thuận, trả qua ATM.</li><li>Thưởng theo dự án, các ngày lễ tết.</li><li>Hưởng các chế độ khác theo quy định của công ty và pháp luật: Bảo hiểm y tế, bảo hiểm xã hội...</li></ul><br /><span style=\"font-size:16px;\"><strong>5. Thời gian làm việc:</strong></span> Toàn thời gian cố định hoặc làm online.<br /><br /><span style=\"font-size:16px;\"><strong>6. Hạn nộp hồ sơ:</strong></span> Không hạn chế, vui lòng kiểm tra tại <a href=\"https://vinades.vn/vi/news/Tuyen-dung/\">https://vinades.vn/vi/news/Tuyen-dung/</a><br /><br /><span style=\"font-size:16px;\"><strong>7. Cách thức đăng ký dự tuyển:</strong></span> Làm Hồ sơ xin việc<em><strong> (download tại đây: <strong><a href=\"https://vinades.vn/vi/download/Tai-lieu/Ban-khai-so-yeu-ly-lich-ky-thuat-vien/\" target=\"_blank\"><u>Mẫu lý lịch ứng viên</u></a></strong>)</strong></em> và gửi về hòm thư <a href=\"mailto:tuyendung@vinades.vn\">tuyendung@vinades.vn</a><br /><br /><span style=\"font-size:16px;\"><strong>8. Hồ sơ bao gồm:</strong></span><ul><li>Đơn xin việc: Tự biên soạn.</li><li>Thông tin ứng viên: Theo mẫu của VINADES.,JSC</li></ul>&nbsp;<p><strong>Chi tiết vui lòng tham khảo tại:</strong> <a href=\"https://vinades.vn/vi/news/Tuyen-dung/\" target=\"_blank\">https://vinades.vn/vi/news/Tuyen-dung/</a><br /><br /><strong>Mọi thắc mắc vui lòng liên hệ:</strong></p><blockquote><p><strong>Công ty cổ phần phát triển nguồn mở Việt Nam.</strong><br />Trụ sở chính: Tầng 6, tòa nhà Sông Đà, 131 Trần Phú, Văn Quán, Hà Đông, Hà Nội.</p><div>- Tel: +84-24-85872007 - Fax: +84-24-35500914<br />- Email: <a href=\"mailto:contact@vinades.vn\">contact@vinades.vn</a> - Website: <a href=\"http://www.vinades.vn/\">http://www.vinades.vn</a></div></blockquote>', NULL, '', '', NULL, 2, '', 0, 1, 1, 1, 0, '', NULL, '', 2),
(5, '', '', 'Công ty cổ phần phát triển nguồn mở Việt Nam (VINADES.,JSC) đang thu hút tuyển dụng nhân tài ở các vị trí:<ol><li><a href=\"/Tuyen-dung/Tuyen-dung-lap-trinh-vien-PHP-7.html\">Lập trình viên PHP và MySQL.</a></li><li><a href=\"/Tuyen-dung/Tuyen-dung-lap-trinh-vien-front-end-HTML-CSS-JS-9.html\">Lập trình viên front-end (HTML/CSS/JS).</a></li><li><a href=\"/Tuyen-dung/Tuyen-dung-chuyen-vien-do-hoa-8.html\">Chuyên Viên Đồ Hoạ.</a></li></ol><br />Tại VINADES.,JSC bạn sẽ được tham gia các dự án của công ty, tham gia xây dựng và phát triển bộ nhân hệ thống NukeViet, được học hỏi và trau dồi nâng cao kiến thức và kỹ năng cá nhân. Ngoài ra, nếu bạn đam mê về nguồn mở và có mong muốn cống hiến cho quá trình phát triển nguồn mở của Việt Nam nói riêng và của thế giới nói chung, thì đây là cơ hội lớn nhất để bạn đạt được mong muốn của mình. Tham gia công tác tại công ty là bạn đã góp phần xây dựng một cộng đồng nguồn mở chuyên nghiệp cho Việt Nam để vươn xa ra thế giới.<br /><br /><span style=\"font-size:16px;\"><strong>1. Vị trí dự tuyển:</strong></span> Lập trình viên front-end (HTML/ CSS/ JS)<br /><br /><span style=\"font-size:16px;\"><strong>2. Mô tả công việc:</strong></span><ul><li>Cắt, làm giao diện website từ bản thiết kế (sử dụng Photoshop) trên nền hệ thống NukeViet.</li><li>Tham gia vào việc phát triển Front-End các ứng dụng nền web.</li><li>Thực hiện các công đoạn để dưa website vào hoạt động như upload dữ liệu lên host, xử lý lỗi, sự cố liên quan.</li><li>Chịu trách nhiệm về chất lượng, trải nghiệm người dùng, thẩm mỹ của sản phẩm trong khi sản phẩm hoạt động Tham mưu, tư vấn về chất lượng, thẩm mỹ, trải nghiệm người dùng về các sản phẩm.</li><li>Đảm bảo website theo các tiêu chuẩn web (W3c, XHTML, CSS 3.0, Tableless, no inline style, … ).</li><li>Đảm bảo website hiển thị đúng trên tất cả các trình duyệt.</li><li>Đảm bảo website theo chuẩn “Responsive Web Design.</li><li>Đảm bảo việc đưa sản phẩm thiết kế đến người dùng cuối cùng một cách chính xác và đẹp.</li><li>Thực hiện các công việc theo sự phân công của cấp trên.</li><li>Chịu trách nhiệm về chất lượng và tiến độ công việc.</li></ul><br /><span style=\"font-size:16px;\"><strong>3. Yêu cầu:</strong></span><ul><li>Có kiến thức cơ bản về thiết kế website: Am hiểu các dạng layout, thành phần của một website.</li><li>Hiểu rõ và nắm chắc cách làm Theme/Template.</li><li>Sử dụng thành thạo HTML5, CSS3 &amp; Javascrip/Jquery và Xtemplate</li><li>Khả năng chuyển PSD sang NukeViet tốt.</li><li>Biết đưa website lên host, xử lý lỗi, sự cố liên quan.</li><li>Chịu trách nhiệm về chất lượng và tiến độ công việc phụ trách.</li><li>Khả năng sáng tạo, tính thẩm mỹ tốt.</li><li>Đam mê công việc về web.</li></ul><br /><em><strong>Ưu tiên các ứng viên:</strong></em><ul><li>Có kiến thức cơ bản về quản trị website NukeViệt.</li><li>Am hiểu về Responsive và có thể thiết kế giao diện, layout trên mobile (Boostrap).</li><li>Sử dụng và nắm rõ các tính năng, block thường dùng của NukeViet.</li><li>Biết sử dụng git để quản lý source code (nếu ứng viên chưa biết công ty sẽ đào tạo thêm).</li><li>Có khả năng giao tiếp với khách hàng (Trực tiếp, điện thoại, email).</li><li>Có khả năng làm việc độc lập và làm việc theo nhóm.</li><li>Có tinh thần trách nhiệm cao và chủ động trong công việc.</li><li>Có khả năng trình bày ý tưởng.</li></ul><br /><span style=\"font-size:16px;\"><strong>4. Quyền lợi:</strong></span><ul><li>Lương thoả thuận, trả qua ATM.</li><li>Thưởng theo dự án, các ngày lễ tết.</li><li>Hưởng các chế độ khác theo quy định của công ty và pháp luật: Bảo hiểm y tế, bảo hiểm xã hội...</li></ul><br /><span style=\"font-size:16px;\"><strong>5. Thời gian làm việc:</strong></span> Toàn thời gian cố định hoặc làm online.<br /><br /><span style=\"font-size:16px;\"><strong>6. Hạn nộp hồ sơ:</strong></span> Không hạn chế, vui lòng kiểm tra tại <a href=\"https://vinades.vn/vi/news/Tuyen-dung/\">https://vinades.vn/vi/news/Tuyen-dung/</a><br /><br /><span style=\"font-size:16px;\"><strong>7. Cách thức đăng ký dự tuyển:</strong></span> Làm Hồ sơ xin việc<em><strong> (download tại đây: <strong><a href=\"https://vinades.vn/vi/download/Tai-lieu/Ban-khai-so-yeu-ly-lich-ky-thuat-vien/\" target=\"_blank\"><u>Mẫu lý lịch ứng viên</u></a></strong>)</strong></em> và gửi về hòm thư <a href=\"mailto:tuyendung@vinades.vn\">tuyendung@vinades.vn</a><br /><br /><span style=\"font-size:16px;\"><strong>8. Hồ sơ bao gồm:</strong></span><ul><li>Đơn xin việc: Tự biên soạn.</li><li>Thông tin ứng viên: Theo mẫu của VINADES.,JSC</li></ul>&nbsp;<p><strong>Chi tiết vui lòng tham khảo tại:</strong> <a href=\"https://vinades.vn/vi/news/Tuyen-dung/\" target=\"_blank\">https://vinades.vn/vi/news/Tuyen-dung/</a><br /><br /><strong>Mọi thắc mắc vui lòng liên hệ:</strong></p><blockquote><p><strong>Công ty cổ phần phát triển nguồn mở Việt Nam.</strong><br />Trụ sở chính: Tầng 6, tòa nhà Sông Đà, 131 Trần Phú, Văn Quán, Hà Đông, Hà Nội.</p><div>- Tel: +84-24-85872007 - Fax: +84-24-35500914<br />- Email: <a href=\"mailto:contact@vinades.vn\">contact@vinades.vn</a> - Website: <a href=\"http://www.vinades.vn/\">http://www.vinades.vn</a></div></blockquote>', NULL, '', '', NULL, 2, '', 0, 1, 1, 1, 0, '', NULL, '', 2),
(6, '', '', 'Cả hội trường như vỡ òa, rộn tiếng vỗ tay, tiếng cười nói chúc mừng các nhà khoa học, các nhóm tác giả đoạt Giải thưởng Nhân tài Đất Việt năm 2011. Năm thứ 7 liên tiếp, Giải thưởng đã phát hiện và tôn vinh nhiều tài năng của đất nước.<div align=\"center\"> <img _fl=\"\" align=\"middle\" src=\"http://dantri4.vcmedia.vn/xFKfMbJ7RTXgah5W1cc/File/2011/01_b7d3f.jpg\" style=\"MARGIN: 5px\" width=\"450\" /></div><div align=\"center\"> <span style=\"FONT-SIZE: 10pt; FONT-FAMILY: Tahoma\">Sân khấu trước lễ trao giải.</span></div><div> &nbsp;</div><div align=\"center\"> &nbsp;</div><div align=\"left\"> Cơ cấu Giải thưởng của Nhân tài Đất Việt 2011 trong lĩnh vực CNTT bao gồm 2 hệ thống giải dành cho “Sản phẩm có tiềm năng ứng dụng” và “Sản phẩm đã ứng dụng rộng rãi trong thực tế”. Mỗi hệ thống giải sẽ có 1 giải Nhất, 1 giải Nhì và 1 giải Ba với trị giá giải thưởng tương đương là 100 triệu đồng, 50 triệu đồng và 30 triệu đồng cùng phần thưởng của các đơn vị tài trợ.</div><div align=\"center\"> &nbsp;</div><div align=\"center\"> <div align=\"center\"> <img _fl=\"\" align=\"middle\" src=\"http://dantri4.vcmedia.vn/xFKfMbJ7RTXgah5W1cc/File/2011/03_f19bd.jpg\" width=\"350\" /></div> <div align=\"center\"> Nhiều tác giả, nhóm tác giả đến lễ trao giải từ rất sớm.</div></div><p> Giải thưởng Nhân tài Đất Việt 2011 trong lĩnh vực Khoa học Tự nhiên được gọi chính thức là Giải thưởng Khoa học Tự nhiên Việt Nam sẽ có tối đa 6 giải, trị giá 100 triệu đồng/giải dành cho các lĩnh vực: Toán học, Cơ học, Vật lý, Hoá học, Các khoa học về sự sống, Các khoa học về trái đất (gồm cả biển) và môi trường, và các lĩnh vực khoa học liên ngành hoặc đa ngành của hai hoặc nhiều ngành nói trên. Viện Khoa học và Công nghệ Việt Nam thành lập Hội đồng giám khảo gồm các nhà khoa học tự nhiên hàng đầu trong nước để thực hiện việc đánh giá và trao giải.</p><div> Sau thành công của việc trao Giải thưởng Nhân tài Đất Việt trong lĩnh vực Y dược năm 2010, Ban Tổ chức tiếp tục tìm kiếm những chủ nhân xứng đáng cho Giải thưởng này trong năm 2011.</div><div> &nbsp;</div><div align=\"center\"> <img _fl=\"\" align=\"middle\" src=\"http://dantri4.vcmedia.vn/xFKfMbJ7RTXgah5W1cc/File/2011/07_78b85.jpg\" style=\"MARGIN: 5px\" width=\"450\" /></div><div align=\"center\"> <span style=\"FONT-SIZE: 10pt; FONT-FAMILY: Tahoma\">Nguyên Tổng Bí thư BCH TW Đảng Cộng sản Việt Nam Lê Khả Phiêu tới&nbsp;dự Lễ trao giải.</span></div><div> &nbsp;</div><div> 45 phút trước lễ trao giải, không khí tại Cung Văn hóa Hữu nghị Việt - Xô đã trở nên nhộn nhịp. Sảnh phía trước Cung gần như chật kín. Rất đông bạn trẻ yêu thích công nghệ thông tin, sinh viên các trường đại học đã đổ về đây, cùng với đó là những bó hoa tươi tắn sẽ được dành cho các tác giả, nhóm tác giả đoạt giải.</div><div> &nbsp;</div><div align=\"center\"> <img _fl=\"\" align=\"middle\" src=\"http://dantri4.vcmedia.vn/xFKfMbJ7RTXgah5W1cc/File/2011/09_aef87.jpg\" style=\"MARGIN: 5px\" width=\"450\" /></div><div align=\"center\"> <span style=\"FONT-SIZE: 10pt; FONT-FAMILY: Tahoma\">Phó Chủ tịch nước CHXHCN Việt Nam Nguyễn Thị Doan.</span></div><div> &nbsp;</div><div> Các vị khách quý cũng đến từ rất sớm. Tới tham dự lễ trao giải năm nay có ông Lê Khả Phiêu, nguyên Tổng Bí thư BCH TW Đảng Cộng sản Việt Nam; bà Nguyễn Thị Doan, Phó Chủ tịch nước CHXHCN Việt Nam; ông Vũ Oanh, nguyên Ủy viên Bộ Chính trị, nguyên Chủ tịch Hội Khuyến học Việt Nam; ông Nguyễn Bắc Son, Bộ trưởng Bộ Thông tin và Truyền thông; ông Đặng Ngọc Tùng, Chủ tịch Tổng Liên đoàn lao động Việt Nam; ông Phạm Văn Linh, Phó trưởng ban Tuyên giáo Trung ương; ông Đỗ Trung Tá, Phái viên của Thủ tướng Chính phủ về CNTT, Chủ tịch Hội đồng Khoa học công nghệ quốc gia; ông Nguyễn Quốc Triệu, nguyên Bộ trưởng Bộ Y tế, Trưởng Ban Bảo vệ Sức khỏe TƯ; bà Cù Thị Hậu, Chủ tịch Hội người cao tuổi Việt Nam; ông Lê Doãn Hợp, nguyên Bộ trưởng Bộ Thông tin Truyền thông, Chủ tịch Hội thông tin truyền thông số…</div><div> &nbsp;</div><div align=\"center\"> <img _fl=\"\" align=\"middle\" src=\"http://dantri4.vcmedia.vn/xFKfMbJ7RTXgah5W1cc/File/2011/08_ba46c.jpg\" style=\"MARGIN: 5px\" width=\"450\" /></div><div align=\"center\"> <span style=\"FONT-SIZE: 10pt; FONT-FAMILY: Tahoma\">Bộ trưởng Bộ Thông tin và Truyền thông Nguyễn Bắc Son.</span></div><div align=\"center\"> &nbsp;</div><div align=\"center\"> <img _fl=\"\" align=\"middle\" src=\"http://dantri4.vcmedia.vn/xFKfMbJ7RTXgah5W1cc/File/2011/06_29592.jpg\" style=\"MARGIN: 5px\" width=\"450\" /></div><div align=\"center\"> <span style=\"FONT-SIZE: 10pt; FONT-FAMILY: Tahoma\">Giáo sư - Viện sỹ Nguyễn Văn Hiệu.</span></div><div align=\"center\"> &nbsp;</div><div align=\"center\"> <img _fl=\"\" align=\"middle\" src=\"http://dantri4.vcmedia.vn/xFKfMbJ7RTXgah5W1cc/File/2011/04_051f2.jpg\" style=\"MARGIN: 5px\" width=\"450\" /></div><div align=\"center\"> <span style=\"FONT-SIZE: 10pt; FONT-FAMILY: Tahoma\">Nguyên Bộ trưởng Bộ Y tế Nguyễn Quốc Triệu.</span></div><div align=\"center\"> &nbsp;</div><div align=\"center\"> <img _fl=\"\" align=\"middle\" src=\"http://dantri4.vcmedia.vn/xFKfMbJ7RTXgah5W1cc/File/2011/05_c7ea4.jpg\" style=\"MARGIN: 5px\" width=\"450\" /></div><div align=\"center\"> <span style=\"FONT-SIZE: 10pt; FONT-FAMILY: Tahoma\">Ông Vũ Oanh, nguyên Ủy viên Bộ Chính trị, nguyên Chủ tịch Hội Khuyến học Việt Nam.</span></div><p> Do tuổi cao, sức yếu hoặc bận công tác không đến tham dự lễ trao giải nhưng Đại tướng Võ Nguyên Giáp và Chủ tịch nước Trương Tấn Sang cũng gửi lẵng hoa đến chúc mừng lễ trao giải.</p><div> Đúng 20h, Lễ trao giải bắt đầu với bài hát “Nhân tài Đất Việt” do ca sỹ Thái Thùy Linh cùng ca sĩ nhí và nhóm múa biểu diễn. Các nhóm tác giả tham dự Giải thưởng năm 2011 và những tác giả của các năm trước từ từ bước ra sân khấu trong tiếng vỗ tay tán dương của khán giả.</div><div> &nbsp;</div><div align=\"center\"> <img _fl=\"\" align=\"middle\" src=\"http://dantri4.vcmedia.vn/xFKfMbJ7RTXgah5W1cc/File/2011/12_74abf.jpg\" style=\"MARGIN: 5px\" width=\"450\" /></div><div align=\"center\"> &nbsp;</div><div align=\"center\"> <div> <img _fl=\"\" align=\"middle\" src=\"http://dantri4.vcmedia.vn/xFKfMbJ7RTXgah5W1cc/File/2011/PHN15999_3e629.jpg\" style=\"MARGIN: 5px\" width=\"450\" /></div></div><div align=\"center\"> <span style=\"FONT-SIZE: 10pt; FONT-FAMILY: Tahoma\">Tiết mục mở màn Lễ trao giải.</span></div><p> Trước Lễ trao giải Giải thưởng Nhân tài Đất Việt năm 2011, Đại tướng Võ Nguyên Giáp, Chủ tịch danh dự Hội Khuyến học Việt Nam, đã gửi thư chúc mừng, khích lệ Ban tổ chức Giải thưởng cũng như các nhà khoa học, các tác giả tham dự.</p><blockquote> <p> <em><span style=\"FONT-STYLE: italic\">Hà Nội, ngày 16 tháng 11 năm 2011</span></em></p> <div> <em>Giải thưởng “Nhân tài đất Việt” do Hội Khuyến học Việt Nam khởi xướng đã bước vào năm thứ bảy (2005 - 2011) với ba lĩnh vực: Công nghệ thông tin, Khoa học tự nhiên và Y dược.</em></div></blockquote><div align=\"center\"> <img _fl=\"\" align=\"middle\" src=\"http://dantri4.vcmedia.vn/xFKfMbJ7RTXgah5W1cc/File/2011/thuDaituong1_767f4.jpg\" style=\"MARGIN: 5px\" width=\"400\" /></div><div align=\"center\"> <span style=\"FONT-SIZE: 10pt; FONT-FAMILY: Tahoma\">Thư của Đại tướng Võ Nguyên Giáp gửi BTC Giải thưởng Nhân tài đất Việt.</span></div><blockquote> <p> <em>Tôi gửi lời chúc mừng các nhà khoa học và các thí sinh được nhận giải thưởng “Nhân tài đất Việt” năm nay.</em></p> <p> <em>Mong rằng, các sản phẩm và các công trình nghiên cứu được trao giải sẽ được tiếp tục hoàn thiện và được ứng dụng rộng rãi trong đời sống, đem lại hiệu quả kinh tế và xã hội thiết thực.</em></p> <p> <em>Nhân ngày “Nhà giáo Việt Nam”, chúc Hội Khuyến học Việt nam, chúc các thầy giáo và cô giáo, với tâm huyết và trí tuệ của mình, sẽ đóng góp xứng đáng vào công cuộc đổi mới căn bản và toàn diện nền giáo dục nước nhà, để cho nền giáo dục Việt Nam thực sự là cội nguồn của nguyên khí quốc gia, đảm bảo cho mọi nhân cách và tài năng đất Việt được vun đắp và phát huy vì sự trường tồn, sự phát triển tiến bộ và bền vững của đất nước trong thời đại toàn cầu hóa và hội nhập quốc tế.</em></p> <p> <em>Chào thân ái,</em></p> <p> <strong><em>Chủ tịch danh dự Hội Khuyến học Việt Nam</em></strong></p> <p> <strong><em>Đại tướng Võ Nguyên Giáp</em></strong></p></blockquote><p> Phát biểu khai mạc Lễ trao giải, Nhà báo Phạm Huy Hoàn, TBT báo điện tử Dân trí, Trưởng Ban tổ chức, bày tỏ lời cám ơn chân thành về những tình cảm cao đẹp và sự quan tâm chăm sóc của Đại tướng Võ Nguyên Giáp và Chủ tịch nước Trương Tấn Sang đã và đang dành cho Nhân tài Đất Việt.</p><div> Nhà báo Phạm Huy Hoàn nhấn mạnh, Giải thưởng Nhân tài Đất Việt suốt 7 năm qua đều nhận được sự quan tâm của các vị lãnh đạo Đảng, Nhà nước và của toàn xã hội. Tại Lễ trao giải, Ban tổ chức luôn có vinh dự được đón tiếp&nbsp;các vị lãnh đạo&nbsp; Đảng và Nhà nước đến dự và trực tiếp trao Giải thưởng.</div><div> &nbsp;</div><div align=\"center\"> <img _fl=\"\" align=\"middle\" src=\"http://dantri4.vcmedia.vn/xFKfMbJ7RTXgah5W1cc/File/2011/15_4670c.jpg\" style=\"MARGIN: 5px\" width=\"450\" /></div><div align=\"center\"> <span style=\"FONT-SIZE: 10pt; FONT-FAMILY: Tahoma\">Trưởng Ban tổ chức Phạm Huy Hoàn phát biểu khai mạc buổi lễ.</span></div><p> Năm 2011, Giải thưởng có 3 lĩnh vực được xét trao giải là CNTT, Khoa học tự nhiên và Y dược. Lĩnh&nbsp; vực CNTT đã đón nhận 204 sản phẩm tham dự từ mọi miền đất nước và cả nước ngoài như thí sinh Nguyễn Thái Bình từ bang California - Hoa Kỳ và một thí sinh ở Pháp cũng đăng ký tham gia.</p><div> “Cùng với lĩnh vực CNTT, năm nay, Hội đồng khoa học của Viện khoa học và công nghệ Việt Nam và Hội đồng khoa học - Bộ Y tế tiếp tục giới thiệu những nhà khoa học xuất&nbsp; sắc, có công trình nghiên cứu đem lại nhiều lợi ích cho xã hội trong lĩnh vực khoa học tự nhiên và lĩnh vực y dược. Đó là những bác sĩ tài năng, những nhà khoa học mẫn tuệ, những người đang ngày đêm thầm lặng cống hiến trí tuệ sáng tạo của mình cho xã hội trong công cuộc xây dựng đất nước.” - nhà báo Phạm Huy Hoàn nói.</div><div> &nbsp;</div><div align=\"center\"> <img _fl=\"\" align=\"middle\" src=\"http://dantri4.vcmedia.vn/xFKfMbJ7RTXgah5W1cc/File/2011/14_6e18f.jpg\" style=\"MARGIN: 5px\" width=\"450\" /></div><div align=\"center\"> <span style=\"FONT-SIZE: 10pt; FONT-FAMILY: Tahoma\">Nhà báo Phạm Huy Hoàn, TBT báo điện tử Dân trí, Trưởng BTC Giải thưởng và ông Phan Hoàng Đức, Phó TGĐ Tập đoàn VNPT nhận lẵng hoa chúc mừng của Đại tướng Võ Nguyên Giáp và Chủ tịch nước Trương Tấn Sang.</span></div><p> Cũng theo Trưởng Ban tổ chức Phạm Huy Hoàn, đến nay, vị Chủ tịch danh dự đầu tiên của Hội Khuyến học Việt Nam, Đại tướng Võ Nguyên Giáp, đã bước qua tuổi 100 nhưng vẫn luôn dõi theo và động viên từng bước phát triển của Giải thưởng Nhân tài Đất Việt. Đại tướng luôn quan tâm chăm sóc Giải thưởng ngay từ khi Giải thưởng&nbsp; mới ra đời cách đây 7 năm.</p><p> Trước lễ trao giải, Đại tướng Võ Nguyên Giáp đã gửi thư chúc mừng, động viên Ban tổ chức. Trong thư, Đại tướng viết: “Mong rằng, các sản phẩm và các công trình nghiên cứu được trao giải sẽ được tiếp tục hoàn thiện và được ứng dụng rộng rãi trong đời sống, đem lại hiệu quả kinh tế và xã hội thiết thực.</p><p> Sau phần khai mạc, cả hội trường hồi hội chờ đợi phút vinh danh các nhà khoa học và các tác giả, nhóm tác giả đoạt giải.</p><div> <span style=\"FONT-WEIGHT: bold\">* Giải thưởng Khoa học Tự nhiên Việt Nam </span>thuộc về 2 nhà khoa học GS.TS Trần Đức Thiệp và GS.TS Nguyễn Văn Đỗ - Viện Vật lý, Viện Khoa học công nghệ Việt Nam với công trình “Nghiên cứu cấu trúc hạt nhân và các phản ứng hạt nhân”.</div><div> &nbsp;</div><div align=\"center\"> <div> <img _fl=\"\" align=\"middle\" src=\"http://dantri4.vcmedia.vn/xFKfMbJ7RTXgah5W1cc/File/2011/khtn_d4aae.jpg\" style=\"MARGIN: 5px\" width=\"450\" /></div></div><p> Hai nhà khoa học đã tiến hành thành công các nghiên cứu về phản ứng hạt nhân với nơtron, phản ứng quang hạt nhân, quang phân hạch và các phản ứng hạt nhân khác có cơ chế phức tạp trên các máy gia tốc như máy phát nơtron, Microtron và các máy gia tốc thẳng của Việt Nam và Quốc tế. Các nghiên cứu này đã góp phần làm sáng tỏ cấu trúc hạt nhân và cơ chế phản ứng hạt nhân, đồng thời cung cấp nhiều số liệu hạt nhân mới có giá trị cho Kho tàng số liệu hạt nhân.</p><p> GS.TS Trần Đức Thiệp và GS.TS Nguyễn Văn Đỗ đã khai thác hiệu quả hai máy gia tốc đầu tiên của Việt Nam là máy phát nơtron NA-3-C và Microtron MT-17 trong nghiên cứu cơ bản, nghiên cứu ứng dụng và đào tạo nhân lực. Trên cơ sở các thiết bị này, hai nhà khoa học đã tiến hành thành công những nghiên cứu cơ bản thực nghiệm đầu tiên về phản ứng hạt nhân ở Việt Nam; nghiên cứu và phát triển các phương pháp phân tích hạt nhân hiện đại và áp dụng thành công ở Việt Nam.</p><div> Bà Nguyễn Thị Doan, Phó Chủ tịch nước CHXHCNVN và Giáo sư - Viện sỹ Nguyễn Văn Hiệu trao giải thưởng cho 2 nhà khoa học.</div><div> &nbsp;</div><div align=\"center\"> <img _fl=\"\" align=\"middle\" src=\"http://dantri4.vcmedia.vn/xFKfMbJ7RTXgah5W1cc/File/2011/khtn2_e2865.jpg\" style=\"MARGIN: 5px\" width=\"450\" /></div><div align=\"center\"> <span style=\"FONT-SIZE: 10pt; FONT-FAMILY: Tahoma\">Phó Chủ tịch nước CHXHCNVN Nguyễn Thị Doan và Giáo sư - Viện sỹ Nguyễn Văn Hiệu trao giải thưởng cho 2 nhà khoa học GS.TS Trần Đức Thiệp và GS.TS Nguyễn Văn Đỗ.</span></div><p> GS.VS Nguyễn Văn Hiệu chia sẻ: “Cách đây không lâu, Chính phủ đã ký quyết định xây dựng nhà máy điện hạt nhân trong điều kiện đất nước còn nhỏ bé, nghèo khó và vì thế việc đào tạo nhân lực là nhiệm vụ số 1 hiện nay. Rất may, Việt Nam có 2 nhà khoa học cực kỳ tâm huyết và nổi tiếng trong cả nước cũng như trên thế giới. Hội đồng khoa học chúng tôi muốn xướng tên 2 nhà khoa học này để Chính phủ huy động cùng phát triển xây dựng nhà máy điện hạt nhân.”</p><p> GS.VS Hiệu nhấn mạnh, mặc dù điều kiện làm việc của 2 nhà khoa học không được quan tâm, làm việc trên những máy móc cũ kỹ được mua từ năm 1992 nhưng 2 ông vẫn xay mê cống hiến hết mình cho lĩnh Khoa học tự nhiên Việt Nam.</p><p> <span style=\"FONT-WEIGHT: bold\">* Giải thưởng Nhân tài Đất Việt trong lĩnh vực Y Dược:</span> 2 giải</p><div> <span style=\"FONT-WEIGHT: bold\">1.</span> Nhóm nghiên cứu của Bệnh viện Hữu nghị Việt - Đức với công trình <span style=\"FONT-STYLE: italic\">“Nghiên cứu triển khai ghép gan, thận, tim lấy từ người cho chết não”</span>.</div><div> &nbsp;</div><div align=\"center\"> <div> <img _fl=\"\" align=\"middle\" src=\"http://dantri4.vcmedia.vn/xFKfMbJ7RTXgah5W1cc/File/2011/y_3dca2.jpg\" style=\"MARGIN: 5px\" width=\"450\" /></div></div><div> &nbsp;</div><div> Tại bệnh viện Việt Đức, tháng 4/2011, các ca ghép tạng từ nguồn cho là người bệnh chết não được triển khai liên tục. Với 4 người cho chết não hiến tạng, bệnh viện đã ghép tim cho một trường hợp,&nbsp;2 người được ghép gan, 8 người được ghép thận, 2 người được ghép van tim và tất cả các ca ghép này đều thành công, người bệnh được ghép đã có một cuộc sống tốt hơn với tình trạng sức khỏe ổn định.</div><div> &nbsp;</div><div align=\"center\"> <img _fl=\"\" align=\"middle\" src=\"http://dantri4.vcmedia.vn/xFKfMbJ7RTXgah5W1cc/File/2011/y2_cb5a1.jpg\" style=\"MARGIN: 5px\" width=\"450\" /></div><div align=\"center\"> <span style=\"FONT-SIZE: 10pt; FONT-FAMILY: Tahoma\">Nguyên Tổng Bí Ban chấp hành TW Đảng CSVN Lê Khả Phiêu và ông Vũ Văn Tiền, Chủ tịch Hội đồng quản trị Ngân hàng An Bình trao giải thưởng cho nhóm nghiên cứu của BV Hữu nghị Việt - Đức.</span></div><p> Công trong việc ghép tạng từ người cho chết não không chỉ thể hiện năng lực, trình độ, tay nghề của bác sĩ Việt Nam mà nó còn mang một ý nghĩa nhân văn to lớn, mang một thông điệp gửi đến những con người giàu lòng nhân ái với nghĩa cử cao đẹp đã hiến tạng để cứu sống những người bệnh khác.</p><p> <span style=\"FONT-WEIGHT: bold\">2.</span> Hội đồng ghép tim Bệnh viện Trung ương Huế với công trình nghiên cứu <span style=\"FONT-STYLE: italic\">“Triển khai ghép tim trên người lấy từ người cho chết não”</span>.</p><div> Đề tài được thực hiện dựa trên ca mổ ghép tim thành công lần đầu tiên ở Việt Nam của chính 100% đội ngũ y, bác sĩ của Bệnh viện Trung ương Huế đầu tháng 3/2011. Bệnh nhân được ghép tim thành công là anh Trần Mậu Đức (26 tuổi, ở phường Phú Hội, TP. Huế).</div><div> &nbsp;</div><div align=\"center\"> <img _fl=\"\" align=\"middle\" src=\"http://dantri4.vcmedia.vn/xFKfMbJ7RTXgah5W1cc/File/2011/y3_7768c.jpg\" style=\"MARGIN: 5px\" width=\"450\" /></div><div align=\"center\"> <span style=\"FONT-SIZE: 10pt; FONT-FAMILY: Tahoma\">Hội đồng ghép tim BV Trung ương Huế nhận Giải thưởng Nhân tài Đất Việt.</span></div><p> Ghép tim từ người cho chết não đến người bị bệnh tim cần được ghép tim phải đảm bảo các yêu cầu: đánh giá chức năng các cơ quan; đánh giá tương hợp miễn dịch và phát hiện nguy cơ tiềm ẩn có thể xảy ra trong và sau khi ghép tim để từ đó có phương thức điều trị thích hợp. Có tới 30 xét nghiệm cận lâm sàng trung và cao cấp tiến hành cho cả người cho tim chết não và người sẽ nhận ghép tim tại hệ thống labo của bệnh viện.</p><p> ---------------------</p><p> <span style=\"FONT-WEIGHT: bold\">* Giải thưởng Nhân tài đất Việt Lĩnh vực Công nghệ thông tin.</span></p><p> <span style=\"FONT-STYLE: italic\">Hệ thống sản phẩm đã ứng dụng thực tế:</span></p><p> <span style=\"FONT-STYLE: italic\">Giải Nhất:</span> Không có.</p><p> <span style=\"FONT-STYLE: italic\">Giải Nhì:</span> Không có</p><p> <span style=\"FONT-STYLE: italic\">Giải Ba:</span> 3 giải, mỗi giải trị giá 30 triệu đồng.</p><div> <span style=\"FONT-WEIGHT: bold\">1.</span> <span style=\"FONT-STYLE: italic\">“Bộ cạc xử lý tín hiệu HDTV”</span> của nhóm HD Việt Nam.</div><div> &nbsp;</div><div align=\"center\"> <img _fl=\"\" align=\"middle\" src=\"http://dantri4.vcmedia.vn/xFKfMbJ7RTXgah5W1cc/File/2011/hdtv_13b10.jpg\" style=\"MARGIN: 5px\" width=\"450\" /></div><div align=\"center\"> <span style=\"FONT-SIZE: 10pt; FONT-FAMILY: Tahoma\">Nhóm HDTV Việt Nam lên nhận giải.</span></div><p> Đây là bộ cạc xử lý tín hiệu HDTV đầu tiên tại Việt Nam đạt tiêu chuẩn OpenGear. Bộ thiết bị bao gồm 2 sản phẩm là cạc khuếch đại phân chia tín hiệu HD DA và cạc xử lý tín hiệu HD FX1. Nhờ bộ cạc này mà người sử dụng cũng có thể điều chỉnh mức âm thanh hoặc video để tín hiệu của kênh tuân theo mức chuẩn và không phụ thuộc vào chương trình đầu vào.</p><div> <span style=\"FONT-WEIGHT: bold; FONT-STYLE: italic\">2.</span> <span style=\"FONT-STYLE: italic\">“Mã nguồn mở NukeViet”</span> của nhóm tác giả Công ty cổ phần phát triển nguồn mở Việt Nam (VINADES.,JSC).</div><div> &nbsp;</div><div align=\"center\"> <div> <img _fl=\"\" align=\"middle\" alt=\"NukeViet nhận giải ba Nhân tài đất Việt 2011\" src=\"/uploads/news/nukeviet-nhantaidatviet2011.jpg\" style=\"margin: 5px; width: 450px; height: 301px;\" /></div></div><p> NukeViet là CMS mã nguồn mở đầu tiên của Việt Nam có quá trình phát triển lâu dài nhất, có lượng người sử dụng đông nhất. Hiện NukeViet cũng là một trong những mã nguồn mở chuyên nghiệp đầu tiên của Việt Nam, cơ quan chủ quản của NukeViet là VINADES.,JSC - đơn vị chịu trách nhiệm phát triển NukeViet và triển khai NukeViet thành các ứng dụng cụ thể cho doanh nghiệp.</p><div> <span style=\"FONT-WEIGHT: bold\">3.</span> <span style=\"FONT-STYLE: italic\">“Hệ thống ngôi nhà thông minh homeON”</span> của nhóm Smart home group.</div><div> &nbsp;</div><div align=\"center\"> <div> <img _fl=\"\" align=\"middle\" src=\"http://dantri4.vcmedia.vn/xFKfMbJ7RTXgah5W1cc/File/2011/PHN16132_82014.jpg\" style=\"MARGIN: 5px\" width=\"450\" /></div></div><p> Sản phẩm là kết quả từ những nghiên cứu miệt mài nhằm xây dựng một ngôi nhà thông minh, một cuộc sống xanh với tiêu chí: An toàn, tiện nghi, sang trọng và tiết kiệm năng lượng, hưởng ứng lời kêu gọi tiết kiệm năng lượng của Chính phủ.&nbsp;</p><p> <strong><span style=\"FONT-STYLE: italic\">* Hệ thống sản phẩm có tiềm năng ứng dụng:</span></strong></p><p> <span style=\"FONT-STYLE: italic\">Giải Nhất: </span>Không có.</p><div> <span style=\"FONT-STYLE: italic\">Giải Nhì:</span> trị giá 50 triệu đồng: <span style=\"FONT-STYLE: italic\">“Dịch vụ Thông tin và Tri thức du lịch ứng dụng cộng nghệ ngữ nghĩa - iCompanion”</span> của nhóm tác giả SIG.</div><div> &nbsp;</div><div align=\"center\"> <img _fl=\"\" align=\"middle\" src=\"http://dantri4.vcmedia.vn/xFKfMbJ7RTXgah5W1cc/File/2011/nhi_7eee0.jpg\" style=\"MARGIN: 5px\" width=\"450\" /></div><div align=\"center\"> <span style=\"FONT-SIZE: 10pt; FONT-FAMILY: Tahoma\">Nhóm tác giả SIG nhận giải Nhì Nhân tài đất Việt 2011 ở hệ thống sản phẩm có tiềm năng ứng dụng.</span></div><p> ICompanion là hệ thống thông tin đầu tiên ứng dụng công nghệ ngữ nghĩa trong lĩnh vực du lịch - với đặc thù khác biệt là cung cấp các dịch vụ tìm kiếm, gợi ý thông tin “thông minh” hơn, hướng người dùng và kết hợp khai thác các tính năng hiện đại của môi trường di động.</p><p> Đại diện nhóm SIG chia sẻ: “Tinh thần sáng tạo và lòng khát khao muốn được tạo ra các sản phẩm mới có khả năng ứng dụng cao trong thực tiễn luôn có trong lòng của những người trẻ Việt Nam. Cảm ơn ban tổ chức và những nhà tài trợ đã giúp chúng tôi có một sân chơi thú vị để khuyến khích và chắp cánh thực hiện ước mơ của mình. Xin cảm ơn trường ĐH Bách Khoa đã tạo ra một môi trường nghiên cứu và sáng tạo, gắn kết 5 thành viên trong nhóm.”</p><p> <span style=\"FONT-STYLE: italic\">Giải Ba:</span> 2 giải, mỗi giải trị giá 30 triệu đồng.</p><div> <span style=\"FONT-WEIGHT: bold\">1. </span><span style=\"FONT-STYLE: italic\">“Bộ điều khiển IPNET”</span> của nhóm IPNET</div><div> &nbsp;</div><div align=\"center\"> <img _fl=\"\" align=\"middle\" src=\"http://dantri4.vcmedia.vn/xFKfMbJ7RTXgah5W1cc/File/2011/PHN16149_ed58d.jpg\" style=\"MARGIN: 5px\" width=\"450\" /></div><div align=\"center\"> <span style=\"FONT-SIZE: 10pt; FONT-FAMILY: Tahoma\">Nhà báo Phạm Huy Hoàn, Trưởng Ban Tổ chức Giải thưởng NTĐV, Tổng Biên tập báo điện tử Dân trí và ông Tạ Hữu Thanh - Phó TGĐ Jetstar Pacific trao giải cho nhóm IPNET.</span></div><p> Bằng cách sử dụng kiến thức thiên văn học để tính giờ mặt trời lặn và mọc tại vị trí cần chiếu sáng được sáng định bởi kinh độ, vĩ độ cao độ, hàng ngày sản phẩm sẽ tính lại thời gian cần bật/tắt đèn cho phù hợp với giờ mặt trời lặn/mọc.</p><div> <span style=\"FONT-WEIGHT: bold\">2.</span> <span style=\"FONT-STYLE: italic\">“Hệ thống lập kế hoạch xạ trị ung thư quản lý thông tin bệnh nhân trên web - LYNX”</span> của nhóm LYNX.</div><div> &nbsp;</div><div align=\"center\"> <div> <img _fl=\"\" align=\"middle\" src=\"http://dantri4.vcmedia.vn/xFKfMbJ7RTXgah5W1cc/File/2011/3tiem-nang_32fee.jpg\" style=\"MARGIN: 5px\" width=\"450\" /></div></div><p> Đây là loại phần mềm hoàn toàn mới ở Việt Nam, là hệ thống lập kế hoạch và quản lý thông tin của bệnh nhân ung thư qua Internet (LYNX) dựa vào nền tảng Silverlight của Microsoft và kiến thức chuyên ngành Vật lý y học. LYNX giúp ích cho các nhà khoa học, bác sĩ, kỹ sư vật lý, bệnh nhân và mọi thành viên trong việc quản lý và theo dõi hệ thống xạ trị ung thư một cách tổng thể. LYNX có thể được sử dụng thông qua các thiết bị như máy tính cá nhân, máy tính bảng… và các trình duyệt Internet Explorer, Firefox, Chrome…</p><div> Chương trình trao giải đã được truyền hình trực tiếp trên VTV2 - Đài Truyền hình Việt Nam và tường thuật trực&nbsp;tuyến trên báo điện tử Dân trí từ 20h tối 20/11/2011.</div><div> &nbsp;</div><div align=\"center\"> <img _fl=\"\" align=\"middle\" src=\"http://dantri4.vcmedia.vn/xFKfMbJ7RTXgah5W1cc/File/2011/NVH0545_c898e.jpg\" style=\"MARGIN: 5px\" width=\"450\" /></div><div align=\"center\"> &nbsp;</div><div align=\"center\"> <img _fl=\"\" align=\"middle\" src=\"http://dantri4.vcmedia.vn/xFKfMbJ7RTXgah5W1cc/File/2011/NVH0560_c995c.jpg\" style=\"MARGIN: 5px\" width=\"450\" /></div><div align=\"center\"> &nbsp;</div><div align=\"center\"> <img _fl=\"\" align=\"middle\" src=\"http://dantri4.vcmedia.vn/xFKfMbJ7RTXgah5W1cc/File/2011/PHN16199_36a5c.jpg\" style=\"MARGIN: 5px\" width=\"450\" /></div><div align=\"center\"> &nbsp;</div><div align=\"center\"> <div align=\"center\"> <table border=\"1\" cellpadding=\"0\" cellspacing=\"0\" width=\"90%\"> <tbody> <tr> <td> <div> <span style=\"FONT-WEIGHT: bold\"><span style=\"FONT-WEIGHT: normal; FONT-SIZE: 10pt; FONT-FAMILY: Tahoma\">Khởi xướng từ năm 2005, Giải thưởng Nhân tài Đất Việt đã phát hiện và tôn vinh nhiều tài năng trong lĩnh vực CNTT-TT, Khoa học tự nhiên và Y dược, trở thành một sân chơi bổ ích cho những người yêu thích CNTT. Mỗi năm, Giải thưởng ngày càng thu hút số lượng tác giả và sản phẩm tham gia đông đảo và nhận được sự quan tâm sâu sắc của lãnh đạo Đảng, Nhà nước cũng như công chúng.</span></span></div> <div> <span style=\"FONT-WEIGHT: bold\">&nbsp;</span></div> <div> <span style=\"FONT-WEIGHT: bold\"><span style=\"FONT-WEIGHT: normal; FONT-SIZE: 10pt; FONT-FAMILY: Tahoma\">Đối tượng tham gia Giải thưởng trong lĩnh vực CNTT là những người Việt Nam ở mọi lứa tuổi, đang sinh sống trong cũng như ngoài nước. Năm 2006, Giải thưởng có sự tham gia của thí sinh đến từ 8 nước trên thế giới và 40 tỉnh thành của Việt Nam. Từ năm 2009, Giải thưởng được mở rộng sang lĩnh vực Khoa học tự nhiên, và năm 2010 là lĩnh vực Y dược, vinh danh những nhà khoa học trong các lĩnh vực này.</span>&nbsp;</span></div> <div> <span style=\"FONT-WEIGHT: bold\">&nbsp;</span></div> </td> </tr> </tbody> </table> </div></div>', NULL, '', '', NULL, 2, '', 0, 1, 1, 1, 0, '', NULL, '', 2);
INSERT INTO `nv5_vi_news_detail` (`id`, `titlesite`, `description`, `bodyhtml`, `voicedata`, `keywords`, `sourcetext`, `files`, `imgposition`, `layout_func`, `copyright`, `allowed_send`, `allowed_print`, `allowed_save`, `auto_nav`, `group_view`, `localization`, `related_ids`, `related_pos`) VALUES
(7, '', '', '<div>Có hiệu lực từ ngày 20/1/2015, Thông tư này thay thế cho Thông tư 41/2009/TT-BTTTT (Thông tư 41) ngày 30/12/2009 ban hành Danh mục các sản phẩm phần mềm nguồn mở đáp ứng yêu cầu sử dụng trong cơ quan, tổ chức nhà nước.<br />\r\n<br />\r\nSản phẩm phần mềm nguồn mở được ưu tiên mua sắm, sử dụng trong cơ quan, tổ chức nhà nước trong Thông tư 41/2009/TT-BTTTT vừa được Bộ TT&amp;TT ban hành, là những&nbsp;sản phẩm đã đáp ứng các tiêu chí về tính năng kỹ thuật cũng như tính mở và bền vững, và NukeViet là một trong số đó.</div>\r\n\r\n<p>Cụ thể, theo Thông tư 20, sản phẩm phần mềm nguồn mở được ưu tiên mua sắm, sử dụng trong cơ quan, tổ chức nhà nước phải đáp các tiêu chí về chức năng, tính năng kỹ thuật bao gồm: phần mềm có các chức năng, tính năng kỹ thuật phù hợp với các yêu cầu nghiệp vụ hoặc các quy định, hướng dẫn tương ứng về ứng dụng CNTT trong các cơ quan, tổ chức nhà nước; phần mềm đáp ứng được yêu cầu tương thích với hệ thống thông tin, cơ sở dữ liệu hiện có của các cơ quan, tổ chức.</p>\r\n\r\n<p>Bên cạnh đó, các sản phẩm phần mềm nguồn mở được ưu tiên mua sắm, sử dụng trong cơ quan, tổ chức nhà nước còn phải đáp ứng tiêu chí về tính mở và tính bền vững của phần mềm. Cụ thể, phần mềm phải đảm bảo các quyền: tự do sử dụng phần mềm không phải trả phí bản quyền, tự do phân phối lại phần mềm, tự do sửa đổi phần mềm theo nhu cầu sử dụng, tự do phân phối lại phần mềm đã chỉnh sửa (có thể thu phí hoặc miễn phí); phần mềm phải có bản mã nguồn, bản cài đặt được cung cấp miễn phí trên mạng; có điểm ngưỡng thất bại PoF từ 50 điểm trở xuống và điểm mô hình độ chín nguồn mở OSMM từ 60 điểm trở lên.</p>\r\n\r\n<p>Căn cứ những tiêu chuẩn trên, thông tư 20 quy định cụ thể Danh mục 31 sản phẩm thuộc 11 loại phần mềm được ưu tiên mua sắm, sử dụng trong cơ quan, tổ chức nhà nước.&nbsp;NukeViet thuộc danh mục hệ quản trị nội dung nguồn mở. Chi tiết thông tư và danh sách 31 sản phẩm phần mềm nguồn mở được ưu tiên mua sắm, sử dụng trong cơ quan, tổ chức nhà nước có&nbsp;<a href=\"https://vinades.vn/vi/download/van-ban-luat/Thong-tu-20-2014-TT-BTTTT/\" target=\"_blank\">tại đây</a>.</p>\r\n\r\n<p>Thông tư 20/2014/TT-BTTTT quy định rõ: Các cơ quan, tổ chức nhà nước khi có nhu cầu sử dụng vốn nhà nước để đầu tư xây dựng, mua sắm hoặc thuê sử dụng các loại phần mềm có trong Danh mục hoặc các loại phần mềm trên thị trường đã có sản phẩm phần mềm nguồn mở tương ứng thỏa mãn các tiêu chí trên (quy định tại Điều 3 Thông tư 20) thì phải&nbsp;ưu tiên lựa chọn các sản phẩm phần mềm nguồn mở tương ứng, đồng thời phải thể hiện rõ sự ưu tiên này trong các tài liệu&nbsp;như thiết kế sơ bộ, thiết kế thi công, kế hoạch đấu thầu, kế hoạch đầu tư, hồ sơ mời thầu, yêu cầu chào hàng, yêu cầu báo giá hoặc các yêu cầu mua sắm khác.</p>\r\n\r\n<p>Đồng thời,&nbsp;các cơ quan, tổ chức nhà nước phải đảm bảo không đưa ra các yêu cầu, điều kiện, tính năng kỹ thuật có thể dẫn đến việc loại bỏ các sản phẩm phần mềm nguồn mở&nbsp;trong các tài liệu như thiết kế sơ bộ, thiết kế thi công, kế hoạch đấu thầu, kế hoạch đầu tư, hồ sơ mời thầu, yêu cầu chào hàng, yêu cầu báo giá hoặc các yêu cầu mua sắm khác.</p>\r\n\r\n<p>Như vậy, sau thông tư số 08/2010/TT-BGDĐT của Bộ GD&amp;ĐT ban hành ngày 01-03-2010 quy định về sử dụng phần mềm tự do mã nguồn mở trong các cơ sở giáo dục trong đó đưa NukeViet vào danh sách các mã nguồn mở được khuyến khích sử dụng trong giáo dục, thông tư 20/2014/TT-BTTTT đã mở đường cho NukeViet vào sử dụng cho các cơ quan, tổ chức nhà nước. Các đơn vị hỗ trợ triển khai NukeViet cho các cơ quan nhà nước có thể sử dụng quy định này để được ưu tiên triển khai cho các dự án website, cổng thông tin cho các cơ quan, tổ chức nhà nước.<br />\r\n<br />\r\nThời gian tới, Công ty cổ phần phát triển nguồn mở Việt Nam (<a href=\"https://vinades.vn/\" target=\"_blank\">VINADES.,JSC</a>) - đơn vị chủ quản của NukeViet - sẽ cùng với Ban Quản Trị NukeViet tiếp tục hỗ trợ các doanh nghiệp đào tạo nguồn nhân lực chính quy phát triển NukeViet nhằm cung cấp dịch vụ ngày một tốt hơn cho chính phủ và các cơ quan nhà nước, từng bước xây dựng và hình thành liên minh các doanh nghiệp phát triển NukeViet, đưa sản phẩm phần mềm nguồn mở Việt không những phục vụ tốt thị trường Việt Nam mà còn từng bước tiến ra thị trường khu vực và các nước đang phát triển khác trên thế giới nhờ vào lợi thế phần mềm nguồn mở đang được chính phủ nhiều nước ưu tiên phát triển.</p>', NULL, '', 'mic.gov.vn', NULL, 2, '', 0, 1, 1, 1, 0, '', NULL, '', 2),
(8, '', '', '<div>Trong năm 2016, chúng tôi xác định là đơn vị sát cánh cùng các đơn vị giáo dục- là đơn vị xây dựng nhiều website cho ngành giáo dục nhất trên cả nước.<br  />Với phần mềm mã nguồn mở NukeViet hiện có nhiều lợi thế:<br  />+ Được Bộ giáo dục khuyến khích sử dụng.<br  />+ Được bộ thông tin truyền thông chỉ định sử dụng trong khối cơ quan nhà nước.<br  />+Được cục công nghệ thông tin ghi rõ tên sản phẩm NukeViet nên dùng theo hướng dẫn thực hiện CNTT 2015-2016.<br  />Chúng tôi cần các bạn góp phần xây dựng nền giáo dục nước nhà ngày càng phát triển.</div><div>&nbsp;</div><table align=\"left\" border=\"1\" cellpadding=\"20\" cellspacing=\"0\" class=\"table table-striped table-bordered table-hover\" style=\"width:100%;\" width=\"653\">	<tbody>		<tr>			<td style=\"width: 27.66%;\"><strong>Vị trí tuyển dụng:</strong></td>			<td style=\"width: 72.34%;\">Nhân viên kinh doanh</td>		</tr>		<tr>			<td style=\"width: 27.66%;\"><strong>Chức vụ:</strong></td>			<td style=\"width: 72.34%;\">Nhân viên</td>		</tr>		<tr>			<td style=\"width: 27.66%;\"><strong>Ngành nghề:</strong></td>			<td style=\"width: 72.34%;\"><strong>Sản phẩm:</strong><br  />			Cổng thông tin, website cho các phòng, sở giáo dục và đào tạo các trường học.</td>		</tr>		<tr>			<td style=\"width: 27.66%;\"><strong>Hình thức làm việc:</strong></td>			<td style=\"width: 72.34%;\">Toàn thời gian cố định</td>		</tr>		<tr>			<td style=\"width: 27.66%;\"><strong>Địa điểm làm việc:</strong></td>			<td style=\"width: 72.34%;\">Văn phòng công ty (Được đi công tác theo hợp đồng đã ký)</td>		</tr>		<tr>			<td style=\"width: 27.66%;\"><strong>Mức lương:</strong></td>			<td style=\"width: 72.34%;\">&nbsp;Lương cố định + Thưởng vượt doanh số + thưởng theo từng hợp đồng (từ 2-7%).</td>		</tr>		<tr>			<td style=\"width: 27.66%;\"><strong>Mô tả công việc:</strong></td>			<td style=\"width: 72.34%;\">Chúng tôi có khách hàng mục tiêu và danh sách khách hàng, công việc đòi hỏi ứng viên sử dụng thành thạo vi tính văn phòng, các phần mềm liên quan đến công việc và có laptop để phục vụ công việc.<br  />			- Sales Online, quảng bá ký kết, liên kết, với các đối tác qua INTERNET. Xây dưng mối quan hệ phát triển bền vững với các đối tác.<br  />			- Gọi điện, giới thiệu dịch vụ, sản phẩm của công ty đến đối tác.<br  />			- Xử lý các cuộc gọi của khách hàng liên quan đến, sản phẩm, dịch vụ công ty.<br  />			- Đàm phán, thương thuyết, ký kết hợp đồng với khách hàng đang có nhu cầu thiết kế website , SEO website , PR thương hiệu trên Internet&nbsp;<br  />			- Duy trì và chăm sóc mối quan hệ lâu dài với khách hàng, mở rộng khách hàng tiềm năng nhằm thúc đẩy doanh số bán hàng<br  />			- Hỗ trợ khách hàng khi được yêu cầu</td>		</tr>		<tr>			<td style=\"width: 27.66%;\"><strong>Số lượng cần tuyển:</strong></td>			<td style=\"width: 72.34%;\">05</td>		</tr>		<tr>			<td style=\"width: 27.66%;\"><strong>Quyền lợi được hưởng:</strong></td>			<td style=\"width: 72.34%;\">- Được đào tạo kĩ năng bán hàng, được công ty hỗ trợ tham gia khóa học bán hàng chuyên nghiệp.<br  />			- Lương cứng: 3.000.000 VNĐ+ hoa hồng dự án (2-7%/năm/hợp đồng). Lương trả qua ATM, được xét tăng lương 3 tháng một lần dựa trên doanh thu.<br  />			- Bậc lương xét trên năng lực bán hàng.<br  />			- Thưởng theo dự án, các ngày lễ tết.<br  />			- Hưởng các chế độ khác theo quy định của công ty và pháp luật: Bảo hiểm y tế, bảo hiểm xã hội.<br  />			- Cơ hội làm việc và gắn bó lâu dài trong công ty, được thưởng cổ phần nếu doanh thu tốt.</td>		</tr>		<tr>			<td style=\"width: 27.66%;\"><strong>Số năm kinh nghiệm:</strong></td>			<td style=\"width: 72.34%;\">Trên 6 tháng</td>		</tr>		<tr>			<td style=\"width: 27.66%;\"><strong>Yêu cầu bằng cấp:</strong></td>			<td style=\"width: 72.34%;\">Cao đẳng, Đại học</td>		</tr>		<tr>			<td style=\"width: 27.66%;\"><strong>Yêu cầu giới tính:</strong></td>			<td style=\"width: 72.34%;\">Không yêu cầu</td>		</tr>		<tr>			<td style=\"width: 27.66%;\"><strong>Yêu cầu độ tuổi:</strong></td>			<td style=\"width: 72.34%;\">Không yêu cầu</td>		</tr>		<tr>			<td style=\"width: 27.66%;\"><strong>Yêu cầu khác:</strong></td>			<td style=\"width: 72.34%;\">- Yêu thích và đam mê Internet Marketing, thích online, thương mại điện tử<br  />			- Giọng nói dễ nghe, không nói ngọng.<br  />			- Có khả năng giao tiếp qua điện thoại.<br  />			- Ngoại hình ưa nhìn là một lợi thế<br  />			- Có tính cẩn thận trong công việc, luôn cố gắng học hỏi.<br  />			- Kỹ năng sales online tốt.<br  />			-Trung thực, năng động, nhiệt tình,siêng năng, nhiệt huyết trong công việc.</td>		</tr>		<tr>			<td style=\"width: 27.66%;\"><strong>Hồ sơ bao gồm:</strong></td>			<td style=\"width: 72.34%;\"><strong>* Yêu cầu Hồ sơ:</strong><br  />			<strong>Cách thức đăng ký dự tuyển</strong>: Làm Hồ sơ xin việc (file mềm) và gửi về hòm thư <a href=\"mailto:tuyendung@vinades.vn\">tuyendung@vinades.vn</a><br  />			<br  />			<strong>Nội dung hồ sơ xin việc file mềm gồm</strong>:<br  />			<strong>+ Đơn xin việc:</strong>&nbsp;Theo hướng dẫn bên dưới.<br  />			<strong>+ Thông tin ứng viên:</strong>&nbsp;Theo mẫu của VINADES.,JSC <strong><em>(download tại đây:&nbsp;<a href=\"https://vinades.vn/vi/download/Tai-lieu/Ban-khai-so-yeu-ly-lich-kinh-doanh/\">Mẫu lý lịch ứng viên</a>)</em></strong><br  />			<strong>* Hồ sơ xin việc (Bản in thông thường) bao gồm</strong>:<br  />			- Giấy khám sức khoẻ của cơ quan y tế.<br  />			- Bản sao hộ khẩu (có công chứng)<br  />			- Bản sao giấy khai sinh (có công chứng)<br  />			- Bản sao quá trình học tập (bảng điểm tốt nghiệp), các văn -bằng chứng chỉ (có công chứng)<br  />			- Sơ yếu lý lịch có xác nhận của cơ quan công tác trước đó (nếu có) hoặc xác nhận của chính quyền địa phương nơi bạn đăng ký hộ khẩu thường trú.<br  />			- Thư giới thiệu (nếu có)<br  />			- Ảnh 4x6: 4 chiếc (đã bao gồm 1 chiếc gắn trên sơ yếu lý lịch).<br  />			<br  />			<strong>*Hướng dẫn</strong>:<br  />			- Với bản in của hồ sơ ứng tuyển, ứng viên sẽ phải nộp trước cho Ban tuyển dụng hoặc muộn nhất là mang theo khi có lịch phỏng vấn. Bản in sẽ không được trả lại ngay cả khi ứng viên không đạt yêu cầu.<br  />			- Nếu không thể bố trí thời gian phỏng vấn như sắp xếp của -Ban tuyển dụng, thí sinh cần thông báo ngay để được đổi lịch.<br  />			- Nếu có bất cứ thắc mắc gì bạn có thể liên hệ với Ms. Thu qua email: tuyendung@vinades.vn. Có thể gọi điện theo số điện thoại: 01255723353</td>		</tr>		<tr>			<td style=\"width: 27.66%;\"><strong>Hạn nộp hồ sơ:</strong></td>			<td style=\"width: 72.34%;\">Không hạn chế cho tới khi tuyển đủ.</td>		</tr>		<tr>			<td style=\"width: 27.66%;\"><strong>Hình thức nộp hồ sơ:</strong></td>			<td style=\"width: 72.34%;\">Qua Email</td>		</tr>		<tr>			<td colspan=\"2\" style=\"width:100.0%;\">			<h3>THÔNG TIN LIÊN HỆ</h3>			</td>		</tr>		<tr>			<td style=\"width: 27.66%;\"><strong>Điện thoại liên hệ:</strong></td>			<td style=\"width: 72.34%;\">01255723353- Ms. Thu</td>		</tr>		<tr>			<td style=\"width: 27.66%;\"><strong>Địa chỉ liên hệ:</strong></td>			<td style=\"width: 72.34%;\">Phòng 1706 - Tòa nhà CT2 Nàng Hương, 583 Nguyễn Trãi, Hà Nội.</td>		</tr>		<tr>			<td style=\"width: 27.66%;\"><strong>Email liên hệ:</strong></td><td style=\"width: 72.34%;\">tuyendung@vinades.vn</td></tr></tbody></table>', NULL, '', '', NULL, 2, '', 0, 1, 1, 1, 0, '', NULL, '', 2),
(9, '', '', '<p>Nếu bạn yêu thích công nghệ, thích kinh doanh hoặc lập trình web và mong muốn trải nghiệm, học hỏi, thậm chí là đi làm ngay từ khi còn ngồi trên ghế nhà trường, hãy tham gia chương trình thực tập sinh tại công ty VINADES.</p><p>Công ty cổ phần phát triển nguồn mở Việt Nam (VINADES.,JSC) là đơn vị chịu trách nhiệm chính trong việc phát triển phần mềm NukeViet và có nhiệm vụ hỗ trợ cộng đồng người dùng NukeViet &#91;<u><a href=\"https://vinades.vn/vi/about/history/\" target=\"_blank\">xem thêm giới thiệu về lịch sử hình thành VINADES</a></u>&#93;. Là công ty được thành lập từ cộng đồng phần mềm nguồn mở, hàng năm công ty dành những vị trí đặc biệt cho các bạn sinh viên được học tập, trải nghiệm, làm việc tại công ty.<br  />&nbsp;</p><h2><b>C</b><b>ác vị trí thực tập</b></h2><ul>	<li><strong>Kinh doanh:</strong> Cổng thông tin doanh nghiệp, Cổng thông tin giáo dục Edu Gate…</li>	<li><strong>Kỹ thuật:</strong> Chuyên viên đồ họa, Lập trình viên…</li></ul><h2><b>Quyền lợi của thực tập sinh</b></h2><ul>	<li>Được&nbsp;tiếp xúc với văn hóa doanh nghiệp, trải nghiệm trong môi trường làm việc chuyên nghiệp, năng động.</li>	<li>Được&nbsp;giao tiếp và học hỏi kiến thức từ những SEO, các lập trình viên chính của đội code NukeViet; qua đó&nbsp;nâng cao không chỉ kỹ năng chuyên môn liên quan đến công việc mà còn các kỹ năng mềm trong quá trình làm việc hàng ngày.</li>	<li>Có cơ hội tìm hiểu, phát triển định hướng của bản thân.</li>	<li>Tham gia các chương trình ngoại khóa, các hoạt động nội bộ của công ty.</li>	<li>Cơ&nbsp;hội được học việc để trở thành nhân viên chính thức nếu có kết quả thực tập tốt.</li>	<li>Thực tập không hưởng lương nhưng có thể được trả thù lao cho một số công việc được giao theo đơn hàng.</li></ul><h2><b>Thời gian làm việc</b></h2><ul>	<li>Toàn thời gian cố định hoặc làm online.</li>	<li>Thời gian làm việc là:&nbsp;8:00 – 17:00, Thứ hai – Thứ sáu</li>	<li>Ngày làm việc và thời gian làm việc có thể thay đổi linh hoạt tùy thuộc vào điều kiện của ứng viên và tình hình thực tế.</li></ul><h2><b>Đối tượng và điều kiện ứng tuyển</b></h2><p>Tất cả các bạn sinh viên năm cuối/mới tốt nghiệp các trường CĐ - ĐH đáp ứng được những yêu cầu sau:</p><ul>	<li>Sinh viên khối ngành kinh tế: yêu thích marketing online, mong muốn thực tập trong lĩnh vực kinh doanh phần mềm.</li>	<li>Sinh viên khối ngành kỹ thuật: yêu thích thiết kế, lập trình web.</li></ul><p>Có kỹ năng giao tiếp và tư duy logic tốt, năng động và ham học hỏi.</p><p>Có máy tính xách tay để làm việc.</p><p>Ưu tiên các ứng viên đam mê phần mềm nguồn mở, đặc biệt là các ứng viên đã từng tham gia và có bài viết diễn đàn NukeViet (<a href=\"http://forum.nukeviet.vn/\">forum.nukeviet.vn</a>).</p><h2><b>Cách thức ứng tuyển</b></h2><p>Gửi bản mềm đơn đăng ký ứng tuyển tới:&nbsp;<a href=\"mailto:tuyendung@vinades.vn\">tuyendung@vinades.vn</a>;</p><p>Tiêu đề mail ghi rõ: &#91;Họ tên&#93; –Ứng tuyển thực tập &#91;Bộ phận ứng tuyển&#93;.</p><p>Ví dụ: Lê Văn Nam –&nbsp;Ứng tuyển thực tập sinh bộ phận đồ họa</p><p>Hồ sơ bản cứng cần chuẩn bị (sẽ gửi sau nếu đạt yêu cầu) gồm:</p><ul>	<li>Giấy khám sức khoẻ của cơ quan y tế</li>	<li>Bản sao giấy khai sinh (có công chứng).</li>	<li>Bản sao quá trình học tập (bảng điểm tốt nghiệp), các văn bằng chứng chỉ (có công chứng) nếu đã tốt nghiệp.</li>	<li>Sơ yếu lý lịch có xác nhận của cơ quan công tác trước đó (nếu có) hoặc xác nhận của chính quyền địa phương nơi bạn đăng ký hộ khẩu thường trú.</li>	<li>Chứng minh thư (photo không cần công chứng).</li>	<li>Thư giới thiệu (nếu có)</li>	<li>Ảnh 4x6: 4 chiếc (đã bao gồm 1 chiếc gắn trên sơ yếu lý lịch).</li></ul><p><br  /><strong>Chi tiết vui lòng tham khảo tại:</strong>&nbsp;<a href=\"https://vinades.vn/vi/news/Tuyen-dung/\" target=\"_blank\">https://vinades.vn/vi/news/Tuyen-dung/</a><br  /><br  /><strong>Mọi thắc mắc vui lòng liên hệ:</strong></p><blockquote><p><strong>Công ty cổ phần phát triển nguồn mở Việt Nam.</strong><br  />Trụ sở chính: Tầng 6, tòa nhà Sông Đà, 131 Trần Phú, Văn Quán, Hà Đông, Hà Nội.<br  /><br  />- Tel: +84-24-85872007 - Fax: +84-24-35500914<br  />- Email:&nbsp;<a href=\"mailto:contact@vinades.vn\">contact@vinades.vn</a>&nbsp;- Website:&nbsp;<a href=\"http://www.vinades.vn/\">http://www.vinades.vn</a></p></blockquote>', NULL, '', '', NULL, 2, '', 0, 1, 1, 1, 0, '', NULL, '', 2),
(10, '', '', '<p>Công ty cổ phần phát triển nguồn mở Việt Nam (VINADES.,JSC) là đơn vị chịu trách nhiệm chính trong việc phát triển phần mềm NukeViet và có nhiệm vụ hỗ trợ cộng đồng người dùng NukeViet &#91;<u><a href=\"https://vinades.vn/vi/about/history/\" target=\"_blank\">xem thêm giới thiệu về lịch sử hình thành VINADES</a></u>&#93;.</p><p>Nếu bạn yêu thích phần mềm nguồn mở, triết lý của phần mềm tự do nguồn mở hoặc đơn giản là yêu NukeViet, hãy liên hệ ngay để gia nhập công ty VINADES, cùng chúng tôi phát triển NukeViet – Phần mềm nguồn mở Việt Nam – và tạo ra những sản phẩm web tuyệt vời cho cộng đồng.</p><h2><b>Các vị trí nhận học việc</b></h2><ul>	<li><strong>Kinh doanh:</strong> Cổng thông tin doanh nghiệp, Cổng thông tin giáo dục Edu Gate…</li>	<li><strong>Kỹ thuật:</strong> Chuyên viên đồ họa, Lập trình viên…</li></ul><h2><b>Quyền lợi của học viên</b></h2><ul>	<li>Được hưởng trợ cấp ăn trưa.</li>	<li>Được trợ cấp vé gửi xe.</li>	<li>Được hưởng lương khoán theo từng dự án (nếu có).</li>	<li>Được hỗ trợ học phí tham gia các khóa học nâng cao các kỹ năng (nếu có).</li>	<li>Được&nbsp;tiếp xúc với văn hóa doanh nghiệp, trải nghiệm trong môi trường làm việc chuyên nghiệp, năng động.</li>	<li>Được&nbsp;giao tiếp và học hỏi kiến thức từ những SEO, các lập trình viên chính của đội code NukeViet; qua đó&nbsp;nâng cao không chỉ kỹ năng chuyên môn liên quan đến công việc mà còn các kỹ năng mềm trong quá trình làm việc hàng ngày.</li>	<li>Tham gia các chương trình ngoại khóa, các hoạt động nội bộ của công ty.</li>	<li>Cơ&nbsp;hội ưu tiên (không cần qua thử việc) trở thành nhân viên chính thức nếu có kết quả học việc tốt.</li></ul><h2><b>Thời gian làm việc</b></h2><ul>	<li>Toàn thời gian cố định hoặc làm online.</li>	<li>Thời gian làm việc là:&nbsp;8:00 – 17:00, Thứ hai – Thứ sáu</li>	<li>Ngày làm việc và thời gian làm việc có thể thay đổi linh hoạt tùy thuộc vào điều kiện của ứng viên và tình hình thực tế.</li></ul><h2><b>Đối tượng</b></h2><p>Tất cả các bạn sinh viên năm cuối/mới tốt nghiệp các trường CĐ - ĐH đáp ứng được những yêu cầu sau:</p><ul>	<li>Sinh viên khối ngành kinh tế: yêu thích marketing online, mong muốn thực tập trong lĩnh vực kinh doanh phần mềm.</li>	<li>Sinh viên khối ngành kỹ thuật: yêu thích thiết kế, lập trình web.</li></ul><p>Có kỹ năng giao tiếp và tư duy logic tốt, năng động và ham học hỏi.</p><p>Ưu tiên các ứng viên đam mê phần mềm nguồn mở, đặc biệt là các ứng viên đã từng tham gia và có bài viết diễn đàn NukeViet (<a href=\"http://forum.nukeviet.vn/\">forum.nukeviet.vn</a>)</p><h2><b>Điều kiện</b></h2><p>Có máy tính xách tay để làm việc.</p><p>Ứng viên sẽ được ký hợp đồng học việc (có thời hạn cụ thể). Nếu được nhận vào làm việc chính thức, người lao động phải làm ở công ty ít nhất 2 năm, nếu không làm hoặc nghỉ trước thời hạn sẽ phải hoàn lại tiền đào tạo. Chi phí này được tính là 3.000.000 VND</p><p>Nếu được cử đi học, người lao động phải làm ở công ty ít nhất 2 năm, nếu không làm hoặc nghỉ trước thời hạn sẽ phải hoàn lại tiền học phí.</p><p>Thực hiện theo các quy định khác của công ty...</p><h2><b>Cách thức ứng tuyển</b></h2><p>Gửi bản mềm đơn đăng ký ứng tuyển tới:&nbsp;<a href=\"mailto:tuyendung@vinades.vn\">tuyendung@vinades.vn</a>;</p><p>Tiêu đề mail ghi rõ: &#91;Họ tên&#93; –Ứng tuyển học việc&#91;Bộ phận ứng tuyển&#93;;</p><p>Ví dụ: Lê Văn Nam –&nbsp;Ứng tuyển học việc bộ phận đồ họa</p><p>Hồ sơ bản cứng cần chuẩn bị (sẽ gửi sau nếu đạt yêu cầu) gồm:</p><ul>	<li>Giấy khám sức khoẻ của cơ quan y tế</li>	<li>Bản sao giấy khai sinh (có công chứng).</li>	<li>Bản sao quá trình học tập (bảng điểm tốt nghiệp), các văn bằng chứng chỉ (có công chứng) nếu đã tốt nghiệp.</li>	<li>Sơ yếu lý lịch có xác nhận của cơ quan công tác trước đó (nếu có) hoặc xác nhận của chính quyền địa phương nơi bạn đăng ký hộ khẩu thường trú.</li>	<li>Chứng minh thư (photo không cần công chứng).</li>	<li>Thư giới thiệu (nếu có)</li>	<li>Ảnh 4x6: 4 chiếc (đã bao gồm 1 chiếc gắn trên sơ yếu lý lịch).</li></ul><p><br  /><strong>Chi tiết vui lòng tham khảo tại:</strong>&nbsp;<a href=\"https://vinades.vn/vi/news/Tuyen-dung/\" target=\"_blank\">https://vinades.vn/vi/news/Tuyen-dung/</a><br  /><br  /><strong>Mọi thắc mắc vui lòng liên hệ:</strong></p><blockquote><p><strong>Công ty cổ phần phát triển nguồn mở Việt Nam.</strong><br  />Trụ sở chính: Tầng 6, tòa nhà Sông Đà, 131 Trần Phú, Văn Quán, Hà Đông, Hà Nội.<br  /><br  />- Tel: +84-24-85872007 - Fax: +84-24-35500914<br  />- Email:&nbsp;<a href=\"mailto:contact@vinades.vn\">contact@vinades.vn</a>&nbsp;- Website:&nbsp;<a href=\"http://www.vinades.vn/\">http://www.vinades.vn</a></p></blockquote>', NULL, '', '', NULL, 2, '', 0, 1, 1, 1, 0, '', NULL, '', 2),
(11, '', '', '<div class=\"details-content clearfix\" id=\"bodytext\"><strong>Hướng dẫn thực hiện nhiệm vụ CNTT năm học 2015 - 2016 của Bộ Giáo dục và Đào tạo có gì mới?</strong><br  /><br  />Trong các hướng dẫn thực hiện nhiệm vụ CNTT từ năm 2010 đến nay liên tục chỉ đạo việc đẩy mạnh công tác triển khai sử dụng phần mềm nguồn mở trong nhà trường và các cơ quan quản lý giáo dục. Tuy nhiên Hướng dẫn thực hiện nhiệm vụ CNTT năm học 2015 - 2016 của Bộ Giáo dục và Đào tạo có nhiều thay đổi mạnh mẽ đáng chú ý, đặc biệt việc chỉ đạo triển khai các phần mềm nguồn mở vào trong các cơ sở quản lý giao dục được rõ ràng và cụ thể hơn rất nhiều.<br  /><br  />Một điểm thay đổi đáng chú ý đối với phần mềm nguồn mở, trong đó đã thay hẳn thuật ngữ &quot;phần mềm tự do mã nguồn mở&quot; hoặc &quot;phần mềm mã nguồn mở&quot; thành &quot;phần mềm nguồn mở&quot;, phản ánh xu thế sử dụng thuật ngữ phần mềm nguồn mở đã phổ biến trong cộng đồng nguồn mở thời gian vài năm trở lại đây.<br  /><br  /><strong>NukeViet - Phần mềm nguồn mở Việt - không chỉ được khuyến khích mà đã được hướng dẫn thực thi</strong><br  /><br  />Từ 5 năm trước, thông tư số 08/2010/TT-BGDĐT của Bộ GD&amp;ĐTquy định về sử dụng phần mềm tự do mã nguồn mở trong các cơ sở giáo dục, NukeViet đã được đưa vào danh sách các mã nguồn mở <strong>được khuyến khích sử dụng trong giáo dục</strong>. Tuy nhiên, việc sử dụng chưa được thực hiện một cách đồng bộ mà chủ yếu làm nhỏ lẻ rải rác tại một số trường, Phòng và Sở GD&amp;ĐT.<br  /><br  />Trong Hướng dẫn thực hiện nhiệm vụ CNTT năm học 2015 - 2016 của Bộ Giáo dục và Đào tạo lần này, NukeViet&nbsp; không chỉ được khuyến khích mà đã được hướng dẫn thực thi, không những thế NukeViet còn được đưa vào hầu hết các nhiệm vụ chính, cụ thể:<div><div><div>&nbsp;</div>- <strong>Nhiệm vụ số 5</strong> &quot;<strong>Công tác bồi dưỡng ứng dụng CNTT cho giáo viên và cán bộ quản lý giáo dục</strong>&quot;, mục 5.1 &quot;Một số nội dung cần bồi dưỡng&quot; có ghi &quot;<strong>Tập huấn sử dụng phần mềm nguồn mở NukeViet.</strong>&quot;<br  />&nbsp;</div>- <strong>Nhiệm vụ số 10 &quot;Khai thác, sử dụng và dạy học bằng phần mềm nguồn mở</strong>&quot; có ghi: &quot;<strong>Khai thác và áp dụng phần mềm nguồn mở NukeViet trong giáo dục.&quot;</strong><br  />&nbsp;</div>- Phụ lục văn bản, có trong nội dung &quot;Khuyến cáo khi sử dụng các hệ thống CNTT&quot;, hạng mục số 3 ghi rõ &quot;<strong>Không nên làm website mã nguồn đóng&quot; và &quot;Nên làm NukeViet: phần mềm nguồn mở&quot;.</strong><br  />&nbsp;<div>Hiện giờ văn bản này đã được đăng lên website của Bộ GD&amp;ĐT: <a href=\"http://moet.gov.vn/?page=1.10&amp;view=983&amp;opt=brpage\" target=\"_blank\">http://moet.gov.vn/?page=1.10&amp;view=983&amp;opt=brpage</a></div><p><br  />Hoặc có thể tải về tại đây: <a href=\"https://vinades.vn/vi/download/van-ban-luat/Huong-dan-thuc-hien-nhiem-vu-CNTT-nam-hoc-2015-2016/\" target=\"_blank\">https://vinades.vn/vi/download/van-ban-luat/Huong-dan-thuc-hien-nhiem-vu-CNTT-nam-hoc-2015-2016/</a></p><blockquote><p><em>Trên cơ sở hướng dẫn của Bộ GD&amp;ĐT, Công ty cổ phần phát triển nguồn mở Việt Nam và các doanh nghiệp phát triển NukeViet trong cộng đồng NukeViet đang tích cực công tác hỗ trợ cho các phòng GD&amp;ĐT, Sở GD&amp;ĐT triển khai 2 nội dung chính: Hỗ trợ công tác đào tạo tập huấn hướng dẫn sử dụng NukeViet và Hỗ trợ triển khai NukeViet cho các trường, Phòng và Sở GD&amp;ĐT.<br  /><br  />Các Phòng, Sở GD&amp;ĐT có nhu cầu có thể xem thêm thông tin chi tiết tại đây: <a href=\"https://vinades.vn/vi/news/thong-cao-bao-chi/Ho-tro-trien-khai-dao-tao-va-trien-khai-NukeViet-cho-cac-Phong-So-GD-DT-264/\" target=\"_blank\">Hỗ trợ triển khai đào tạo và triển khai NukeViet cho các Phòng, Sở GD&amp;ĐT</a></em></p></blockquote></div>', NULL, '', '', NULL, 2, '', 0, 1, 1, 1, 0, '', NULL, '', 2),
(12, '', '', '<div class=\"details-content clearfix\" id=\"bodytext\"><span style=\"font-size:16px;\"><strong>Hỗ trợ công tác đào tạo tập huấn hướng dẫn sử dụng phần mềm nguồn mở NukeViet</strong></span><br  /><br  />Công tác hỗ trợ công tác đào tạo tập huấn hướng dẫn sử dụng phần mềm nguồn mở NukeViet sẽ được thực hiện bởi đội ngũ chuyên gia giàu kinh nghiệm về NukeViet được tuyển chọn từ lực lượng lập trình viên, chuyên viên kỹ thuật hiện đang tham gia phát triển và hỗ trợ về NukeViet từ Ban Quản Trị NukeViet và Công ty cổ phần phát triển nguồn mở Việt Nam và các đối tác thuộc Liên minh phần mềm giáo dục nguồn mở NukeViet.<br  /><br  />Với kinh nghiệm tập huấn đã được tổ chức thành công cho nhiều Phòng giáo dục và đào tạo, các chuyên gia về NukeViet sẽ giúp chuyển giao giáo trình, chương trình, kịch bản đào tạo cho các Phòng, Sở GD&amp;ĐT; hỗ trợ các giáo viên và cán bộ quản lý giáo dục sử dụng trong suốt thời gian sau đào tạo.<br  /><br  />Đặc biệt, đối với các đơn vị sử dụng NukeViet làm website và cổng thông tin đồng bộ theo quy mô cấp Phòng và Sở, cán bộ tập huấn của NukeViet sẽ có nhiều chương trình hỗ trợ khác như chương trình thi đua giữa các website sử dụng NukeViet trong cùng đơn vị cấp Phòng, Sở và trên toàn quốc; Chương trình báo cáo và giám sát và xếp hạng website hàng tháng; Chương trình tập huấn nâng cao trình độ sử dụng NukeViet hàng năm cho giáo viên và cán bộ quản lý giáo dục đang thực hiện công tác quản trị các hệ thống sử dụng nền tảng NukeViet.<br  /><br  /><span style=\"font-size:16px;\"><strong>Hỗ trợ triển khai NukeViet cho các trường, Phòng và Sở GD&amp;ĐT</strong></span><br  /><br  />Nhằm hỗ trợ triển khai NukeViet cho các trường, Phòng và Sở GD&amp;ĐT một cách toàn diện, đồng bộ và tiết kiệm, hiện tại, Liên minh phần mềm nguồn mở giáo dục NukeViet chuẩn bị ra mắt. Liên minh này do Công ty cổ phần phát triển nguồn mở Việt Nam đứng dầu và thực hiện việc điều phối công các hỗ trợ và phối hợp giữa các đơn vị trên toàn quốc. Thành viên của liên minh là các doanh nghiệp cung cấp sản phẩm và dịch vụ phần mềm hỗ trợ cho giáo dục (kể cả những đơn vị chỉ tham gia lập trình và những đơn vị chỉ tham gia khai thác thương mại). Liên minh sẽ cùng nhau làm việc để xây dựng một hệ thống phần mềm thống nhất cho giáo dục, có khả năng liên thông và kết nối với nhau, hoàn toàn dựa trên nền tảng phần mềm nguồn mở. Liên minh cũng hỗ trợ và phân phối phần mềm cho các đơn vị làm phần mềm trong ngành giáo dục với mục tiêu là tiết kiệm tối đa chi phí trong khâu thương mại, mang tới cơ hội cho các đơn vị làm phần mềm giáo dục mà không cần phải lo lắng về việc phân phối phần mềm. Các doanh nghiệp quan tâm đến cơ hội kinh doanh bằng phần mềm nguồn mở, muốn tìm hiểu và tham gia liên minh có thể đăng ký tại đây: <a href=\"http://edu.nukeviet.vn/lienminh-dangky.html\" target=\"_blank\">http://edu.nukeviet.vn/lienminh-dangky.html</a><br  /><br  />Liên minh phần mềm nguồn mở giáo dục NukeViet đang cung cấp giải pháp cổng thông tin chuyên dùng cho phòng và Sở GD&amp;ĐT (NukeViet Edu Gate) cung cấp dưới dạng dịch vụ công nghệ thông tin (theo mô hình của <a href=\"https://vinades.vn/vi/download/van-ban-luat/Quyet-dinh-80-ve-thue-dich-vu-CNTT/\" target=\"_blank\">Quyết định số 80/2014/QĐ-TTg của Thủ tướng Chính phủ</a>) có thể hỗ trợ cho các trường, Phòng và Sở GD&amp;ĐT triển khai NukeViet ngay lập tức.<br  /><br  />Giải pháp cổng thông tin chuyên dùng cho phòng và Sở GD&amp;ĐT (NukeViet Edu Gate) có tích hợp website các trường (liên thông 3 cấp: trường - phòng - sở) cho phép tích hợp hàng ngàn website của các trường cùng nhiều dịch vụ khác trên cùng một hệ thống giúp tiết kiệm chi phí đầu tư, chi phí triển khai và bảo trì hệ thống bởi toàn bộ hệ thống được vận hành bằng một phần mềm duy nhất. Ngoài giải pháp cổng thông tin giáo dục tích hợp, Liên minh phần mềm nguồn mở giáo dục NukeViet cũng đang phát triển một số&nbsp;sản phẩm phần mềm dựa trên phần mềm nguồn mở NukeViet và sẽ sớm ra mắt trong thời gian tới.<div><br  />Hiện nay,&nbsp;NukeViet Edu Gate cũng&nbsp;đã được triển khai rộng rãi và nhận được sự ủng hộ của&nbsp;nhiều Phòng, Sở GD&amp;ĐT trên toàn quốc.&nbsp;Các phòng, sở GD&amp;ĐT quan tâm đến giải pháp NukeViet Edu Gate có thể truy cập&nbsp;<a href=\"http://edu.nukeviet.vn/\" target=\"_blank\">http://edu.nukeviet.vn</a>&nbsp;để tìm hiểu thêm hoặc liên hệ:<br  /><br  /><span style=\"font-size:14px;\"><strong>Liên minh phần mềm nguồn mở giáo dục NukeViet</strong></span><br  />Đại diện: <strong>Công ty cổ phần phát triển nguồn mở Việt Nam (VINADES.,JSC)</strong><br  /><strong>Địa chỉ</strong>: Tầng 6, tòa nhà Sông Đà, 131 Trần Phú, Văn Quán, Hà Đông, Hà Nội<br  /><strong>Email</strong>: contact@vinades.vn, Tel: 024-85872007, <strong>Fax</strong>: 024-35500914,<br  /><strong>Hotline</strong>: 0904762534 (Mr. Hùng), 0936226385 (Ms. Ngọc),&nbsp;<span style=\"color: rgb(38, 38, 38); font-family: arial, sans-serif; font-size: 13px; line-height: 16px;\">0904719186 (Mr. Hậu)</span><br  />Các Phòng GD&amp;ĐT, Sở GD&amp;ĐT có thể đăng ký tìm hiểu, tổ chức hội thảo, tập huấn, triển khai NukeViet trực tiếp tại đây: <a href=\"http://edu.nukeviet.vn/dangky.html\" target=\"_blank\">http://edu.nukeviet.vn/dangky.html</a><br  /><br  /><span style=\"font-size:16px;\"><strong>Tìm hiểu về phương thức chuyển đổi các hệ thống website cổng thông tin sang NukeViet theo mô hình tích hợp liên thông từ trưởng, lên Phòng, Sở GD&amp;ĐT:</strong></span><br  /><br  />Đối với các Phòng, Sở GD&amp;ĐT, trường Nầm non, tiểu học, THCS, THPT... chưa có website, Liên minh phần mềm nguồn mở giáo dục NukeViet sẽ hỗ trợ triển khai NukeViet theo mô hình cổng thông tin liên cấp như quy định tại <a href=\"https://vinades.vn/vi/download/van-ban-luat/Thong-tu-quy-dinh-ve-ve-to-chuc-hoat-dong-su-dung-thu-dien-tu/\" target=\"_blank\">thông tư số <strong>53/2012/TT-BGDĐT</strong> của Bộ GD&amp;ĐT</a> ban hành ngày 20-12-2012 quy định về quy định về về tổ chức hoạt động, sử dụng thư điện tử và cổng thông tin điện tử tại sở giáo dục và đào tạo, phòng giáo dục và đào tạo và các cơ sở GDMN, GDPT và GDTX.<br  /><br  />Trường hợp các đơn vị có website và đang sử dụng NukeViet theo dạng rời rạc thì việc chuyển đổi và tích hợp các website NukeViet rời rạc vào NukeViet Edu Gate của Phòng và Sở có thể thực hiện dễ dàng và giữ nguyên toàn bộ dữ liệu.<br  /><br  />Trường hợp các đơn vị có website và nhưng không sử dụng NukeViet cũng có thể chuyển đổi sang sử dụng NukeViet để hợp nhất vào hệ thống cổng thông tin giáo dục cấp Phòng, Sở. Tuy nhiên mức độ và tỉ lệ dữ liệu được chuyển đổi thành công sẽ phụ thuộc vào tình hình thực tế của từng website.</div></div>', NULL, '', '', NULL, 2, '', 0, 1, 1, 1, 0, '', NULL, '', 2),
(13, '', '', '<p dir=\"ltr\">Trải qua hơn 10 năm phát triển, từ một mã nguồn chỉ mang tính cá nhân, NukeViet đã phát triển thành công theo hướng cộng đồng. Năm 2010, NukeViet 3 ra đời đánh dấu một mốc lớn trong quá trình đi lên của NukeViet, phát triển theo hướng chuyên nghiệp với sự hậu thuẫn của Công ty cổ phần phát triển nguồn mở Việt Nam (VINADES.,JSC). NukeViet 3 đã và được sử dụng rộng rãi trong cộng đồng, từ các cổng thông tin tổ chức, hệ thống giáo dục, cho đến các website cá nhân, thương mại, mang lại các trải nghiệm vượt trội của mã nguồn thương hiệu Việt so với các mã nguồn nổi tiếng khác trên thế giới.<br  /><br  />Năm 2016, NukeViet 4 ra đời được xem là một cuộc cách mạng lớn trong chuỗi sự kiện phát triển NukeViet, cũng như xu thế công nghệ hiện tại. Hệ thống gần như được đổi mới hoàn toàn từ nhân hệ thống đến giao diện, nâng cao đáng kể hiệu suất và trải nghiệm người dùng.<br  /><br  /><span style=\"line-height: 1.6;\"><strong>Dưới đây là một số thay đổi của NukeViet 4.</strong></span><br  /><strong><span style=\"line-height: 1.6;\">Các thay đổi từ nhân hệ thống:</span></strong></p><ul>	<li dir=\"ltr\">	<p dir=\"ltr\"><strong>Các công nghệ mới được áp dụng.</strong></p>	<ul>		<li dir=\"ltr\">		<p dir=\"ltr\">Sử dụng composer để quản lý các thư viện PHP được cài vào hệ thống.</p>		</li>		<li dir=\"ltr\">		<p dir=\"ltr\">Từng bước áp dụng &nbsp;các tiêu chuẩn viết code PHP theo khuyến nghị của <a href=\"http://www.php-fig.org/psr/\">http://www.php-fig.org/psr/</a></p>		</li>		<li dir=\"ltr\">		<p dir=\"ltr\">Sử dụng PDO để thay cho extension MySQL.</p>		</li>	</ul>	</li></ul><ul>	<li dir=\"ltr\">	<p dir=\"ltr\"><strong>Tăng cường khả năng bảo mật</strong></p>	<ul>		<li dir=\"ltr\">		<p dir=\"ltr\">Sau khi các chuyên giả bảo mật của HP gửi đánh giá, chúng tôi đã tối ưu NukeViet 4.0 để hệ thống an toàn hơn.</p>		</li>		<li dir=\"ltr\">		<p dir=\"ltr\">Mã hóa các mật khẩu lưu trữ trong hệ thống: Các mật khẩu như FTP, SMTP,... đã được mã hóa, bảo mật thông tin người dùng.</p>		</li>	</ul>	</li></ul><ul>	<li dir=\"ltr\">	<p dir=\"ltr\"><strong>Tối ưu SEO:</strong></p>	<ul>		<li dir=\"ltr\">		<p dir=\"ltr\">SEO được xem là một trong những ưu tiên hàng đầu được phát triển trong phiên bản này. NukeViet 4 tập trung tối ưu hóa SEO Onpage mạnh mẽ. Các công cụ hỗ trợ SEO được tập hợp lại qua module “Công cụ SEO”. Các chức năng được thêm mới:</p>		<ul>			<li dir=\"ltr\">			<p dir=\"ltr\">Loại bỏ tên module khỏi URL khi không dùng đa ngôn ngữ</p>			</li>			<li dir=\"ltr\">			<p dir=\"ltr\">Cho phép đổi đường dẫn module</p>			</li>			<li dir=\"ltr\">			<p dir=\"ltr\">Thêm chức năng xác thực Google+ (Bản quyền tác giả)</p>			</li>			<li dir=\"ltr\">			<p dir=\"ltr\">Thêm chức năng ping đến các công cụ tìm kiếm: Submit url mới đến google để việc hiển thị bài viết mới lên kết quả tìm kiếm nhanh chóng hơn.</p>			</li>			<li dir=\"ltr\">			<p dir=\"ltr\">Hỗ trợ Meta OG của facebook</p>			</li>			<li dir=\"ltr\">			<p dir=\"ltr\">Hỗ trợ chèn Meta GEO qua Cấu hình Meta-Tags</p>			</li>		</ul>		</li>		<li dir=\"ltr\">		<p dir=\"ltr\">Cùng với đó, các module cũng được tối ưu hóa bằng các form hỗ trợ khai báo tiêu đề, mô tả (description), từ khóa (keywods) cho từng khu vực, từng trang. &nbsp;</p>		</li>		<li dir=\"ltr\">		<p dir=\"ltr\">Với sự hỗ trợ tối đa này, người quản trị (admin) có thể tùy biến lại website theo phong cách SEO riêng biệt.</p>		</li>	</ul>	</li>	<li dir=\"ltr\">	<p dir=\"ltr\"><strong>Thay đổi giao diện, sử dụng giao diện tuỳ biến</strong></p>	<ul>		<li dir=\"ltr\">		<p dir=\"ltr\">Giao diện trong NukeViet 4 được làm mới, tương thích với nhiều màn hình hơn.</p>		</li>		<li dir=\"ltr\">		<p dir=\"ltr\">Sử dụng thư viện bootstrap để việc phát triển giao diện thống nhất và dễ dàng hơn.</p>		</li>	</ul>	</li>	<li dir=\"ltr\">	<p dir=\"ltr\"><strong>Hệ thống nhận thông báo:&nbsp;</strong><span style=\"line-height: 1.6;\">Có thể gọi đây là một tiện ích nhỏ, song nó rất hữu dụng để admin tương tác với hệ thống một cách nhanh chóng. Admin có thể nhận thông báo từ hệ thống (hoặc từ module) khi có sự kiện nào đó.</span></p>	</li></ul><p dir=\"ltr\" style=\"margin-left: 40px;\"><strong>Ví dụ:</strong> Khi có khách gửi liên hệ (qua module contact) đến thì hệ thống xuất hiện biểu tượng thông báo “Có liên hệ mới” ở góc phải, Admin sẽ nhận được ngay lập tức thông báo khi người dùng đang ở Admin control panel (ACP).</p><ul>	<li dir=\"ltr\">	<p dir=\"ltr\"><strong>Thay đổi cơ chế quản lý block:</strong></p>	<ul>		<li dir=\"ltr\">		<p dir=\"ltr\">Nhận thấy việc hiển thị block ở lightbox trong NukeViet 3 dẫn đến một số bất tiện trong quá trình quản lý, NukeViet 4 đã thay thế cách hiển thị này ở dạng cửa sổ popup. Dễ nhận thấy sự thay đổi này khi admin thêm (hoặc sửa) một block nào đó.</p>		</li>		<li dir=\"ltr\">		<p dir=\"ltr\">“Cấu hình hiển thị block trên các thiết bị” cũng được đưa vào phần cấu hình block, admin có thể tùy chọn cho phép block hiển thị trên các thiết bị nào (tất cả thiết bị, thiết bị di động, máy tính bảng, thiết bị khác).<span style=\"line-height: 1.6;\">&nbsp;</span></p>		</li>	</ul>	</li></ul><ul>	<li dir=\"ltr\">	<p dir=\"ltr\"><strong>Thêm ngôn ngữ tiếng Pháp:</strong> website cài đặt mới có sẵn 3 ngôn ngữ mặc định là Việt, Anh và Pháp.</p>	</li></ul><p dir=\"ltr\"><strong>Các thay đổi của module:</strong></p><ul>	<li dir=\"ltr\">	<p dir=\"ltr\"><strong>Module menu:</strong></p>	<ul>		<li dir=\"ltr\">		<p dir=\"ltr\">Phương án quản lý menu được thay đổi hướng tới việc quản lý menu nhanh chóng, tiện lợi nhất cho admin. Admin có thể nạp nhanh menu theo các tùy chọn mà hệ thống cung cấp.</p>		</li>		<li dir=\"ltr\">		<p dir=\"ltr\">Mẫu menu cũng được thay đổi, đa dạng và hiển thị tốt với các giao diện hiện đại.</p>		</li>	</ul>	</li>	<li dir=\"ltr\">	<p dir=\"ltr\"><strong>Module contact (Liên hệ):</strong></p>	<ul>		<li dir=\"ltr\">		<p dir=\"ltr\">Bổ sung các trường thông tin về bộ phận (Điện thoại, fax, email, các trường liên hệ khác,...).</p>		</li>		<li dir=\"ltr\">		<p dir=\"ltr\">Admin có thể trả lời khách nhiều lần, hệ thống lưu lại lịch sử trao đổi đó.</p>		</li>	</ul>	</li>	<li dir=\"ltr\">	<p dir=\"ltr\"><strong>Module users (Tài khoản):</strong></p>	<ul>		<li dir=\"ltr\">		<p dir=\"ltr\">Thay thế OpenID bằng thư viện OAuth - hỗ trợ tích hợp đăng nhập qua tài khoản mạng xã hội</p>		</li>		<li dir=\"ltr\">		<p dir=\"ltr\">Cho phép đăng nhập 1 lần tài khoản người dùng NukeViet với Alfresco, Zimbra, Moodle, Koha</p>		</li>		<li dir=\"ltr\">		<p dir=\"ltr\">Thêm chức năng tùy biến trường dữ liệu thành viên</p>		</li>		<li dir=\"ltr\">		<p dir=\"ltr\">Thêm chức năng phân quyền sử dụng module users</p>		</li>		<li dir=\"ltr\">		<p dir=\"ltr\">Thêm cấu hình: Số ký tự username, độ phức tạp mật khẩu, tạo mật khảu ngẫu nhiên,....</p>		</li>		<li dir=\"ltr\">		<p dir=\"ltr\">Cho phép sử dụng tên truy cập, hoặc email để đăng nhập</p>		</li>	</ul>	</li>	<li dir=\"ltr\">	<p dir=\"ltr\"><strong>Module about:</strong></p>	<ul>		<li dir=\"ltr\">		<p dir=\"ltr\">Module about ở NukeViet 3 được đổi tên thành module page</p>		</li>		<li dir=\"ltr\">		<p dir=\"ltr\">Thêm các cấu hình hỗ trợ SEO: Ảnh minh họa, chú thích ảnh minh họa, mô tả, từ khóa cho bài viết, hiển thị các công cụ tương tác với các mạng xã hội.</p>		</li>		<li dir=\"ltr\">		<p dir=\"ltr\">Thêm RSS</p>		</li>		<li dir=\"ltr\">		<p dir=\"ltr\">Cấu hình phương án hiển thị các bài viết trên trang chính</p>		</li>	</ul>	</li>	<li dir=\"ltr\">	<p dir=\"ltr\"><strong>Module news (Tin tức):</strong></p>	<ul>		<li dir=\"ltr\">		<p dir=\"ltr\">Thêm phân quyền cho người quản lý module, đến từng chủ đề</p>		</li>		<li dir=\"ltr\">		<p dir=\"ltr\">Thay đổi phương án lọc từ khóa bài viết, lọc từ khóa theo các từ khóa đã có trong tags thay vì đọc từ từ điển.</p>		</li>		<li dir=\"ltr\">		<p dir=\"ltr\">Bổ sung các trạng thái bài viết</p>		</li>		<li dir=\"ltr\">		<p dir=\"ltr\">Thêm cấu hình mặc định hiển thị ảnh minh họa trên trang xem chi tiết bài viết</p>		</li>		<li dir=\"ltr\">		<p dir=\"ltr\">Thêm các công cụ tương tác với mạng xã &nbsp;hội.</p>		</li>	</ul>	</li></ul><p dir=\"ltr\"><strong>Quản lý Bình luận</strong></p><ul>	<li dir=\"ltr\">	<p dir=\"ltr\">Các bình luận của các module sẽ được tích hợp quản lý tập trung để cấu hình.</p>	</li>	<li dir=\"ltr\">Khi xây dựng mới module, Chỉ cần nhúng 1 đoạn mã vào. Tránh phải việc copy mã code gây khó khăn cho bảo trì.</li></ul>', NULL, '', '', NULL, 2, '', 0, 1, 1, 1, 0, '', NULL, '', 2),
(14, '', '', '<strong>Hệ thống:</strong><br  />- Sửa code theo khuyến nghị của codacy: https://www.codacy.com/app/nukeviet/nukeviet/dashboard<br  />- Cải thiện an ninh hệ thống theo đánh giá của các phần mềm bảo mật OWASP ZAP 2.6<br  />- Cải tiến chức năng Rewrite<br  />- Thêm tính năng bật tắt sitemap cho các module<br  />- Thêm link hướng dẫn sử dụng website dẫn tới từng chức năng tại https://wiki.nukeviet.vn/<br  />- Cập nhật trình soạn thảo&nbsp; CKEditor 4.7.1 để hỗ trợ việc copy nội dung từ Word, Excel, Hỗ trợ việc kéo thả ảnh, file từ máy tính vào trình soạn thảo tốt hơn: http://ckeditor.com/blog/CKEditor-4.7-released<br  />- Tích hợp thêm <a href=\\\"https://nukeviet.vn/vi/news/Tin-tuc/nukeviet-4-1-se-ho-tro-redis-de-cache-435.html\\\">Redis để cache</a> cho hệ thống<br  /><br  /><strong>Module Tài khoản:</strong><br  />- Tùy biến các trường hệ thống của module users giúp quản trị có thể cho ẩn/hiện khi đăng ký và đổi tên các trường này.<br  />- Thêm chức năng&nbsp; xác thực hai bước cho từng nhóm thành viên, Cấu hình yêu cầu xác thực hai bước cho từng nhóm thành viên.<br  />- Tích hợp reCAPTCHA<br  /><br  /><strong>Module Tin tức:</strong><br  />- Thêm cấu hình có bật tính năng copy bài viết, để dùng module này đăng cái bài viết có cạc trình bày tương tự nhau.<br  />- Cải thiện tính năng cho bài viết Facebook Instant Articles<br  />- Cảnh báo tránh cùng&nbsp; một lúc nhiều người sửa bài viết.<br  /><br  /><strong>Module banners</strong><br  />- Bỏ phần quản lý khách hàng tại quảng cáo, chuyển sang dùng tài khoản chung của site<br  />- Phần cấu hình khối quảng cáo được viết lại để cấu hình nhóm&nbsp; thành viên được đăng quảng cáo ngoài site, sau đó quản trị duyệt lại quảng cáo để hiển thị ngoài site.<br  />- Thêm cấu hình về thời gian chung áp dụng cho quảng cáo theo khối.<br  />- Sửa lại link quản cáo để tránh các click ảo.<br  />- Sửa hiển thị quản lý quảng cáo để tiện quản lý hơn.<br  /><br  />Và nhiều cập nhật sửa lỗi khác, xem chi tiết tại: https://github.com/nukeviet/nukeviet/blob/develop/CHANGELOG.txt<br  />', NULL, '', 'https://nukeviet.vn/vi/news/Tin-tuc/nukeviet-4-2-co-gi-moi-505.html', NULL, 2, '', 0, 1, 1, 1, 0, '', NULL, '', 2),
(15, '', '', '<strong>Hệ thống:</strong><br  />- Thay đổi phần quản lý block để dễ dùng hơn khi module có quá nhiều chức năng.<br  />- Thêm các tham số cấu hình&nbsp; SSL cho&nbsp; SMTP<br  />- Module Upload: Thêm cấu hình có thể chia nhỏ các file khi upload để có thể upload<br  />- Plugin:Thêm vị trí chạy sau khi thực hiện module, cải tiến mỗi Plugin sẽ chạy được ở các vị trí nhất định theo người lập trình quy định.<br  />- Tích hợp thêm thư viện PDF.js<br  />- Thêm tính năng xuất dữ liệu mẫu để khi tiết hành cài đặt có thể dựng luôn site hoàn chỉnh tường tự như cài đặt NukeViet eGovernment<br  /><br  /><strong>Module comment: </strong><br  />- Cho phép cấu hình có sử dụng trình soạn thảo ở phần bình luận hay không.<br  />- Cho phép cấu hình có sử dụng file đính kèm ở phần bình luận hay không.<br  />- Module news: Allow deactive category, allow search for locked posts, Allows attaching files to posts<br  />- Config module display on admin index for authors<br  />&nbsp;<br  /><strong>Module Tài khoản:</strong><br  />- Module users: Allowed to delete and change status multiple account, fix block login, update Openid icon, fix sort groups, fix delete group<br  />- Người điều hành chung của site có thể cấu hình 1 số thông số. (Lúc trước chỉ quản trị tối cao mới cấu hình được)<br  />- Với mỗi tài khoản quản trị, có thể chọn module mặc định sau khi đăng nhập quản trị.<br  /><br  /><strong>Module Tin tức:</strong><br  />-&nbsp; Thay đổi chức năng quản lý chủ đề có thể: Hiển thị trên trang chủ, không hiển thị trên trang chủ hoặc Khóa chủ đề.<br  />-&nbsp; Cho phép đính kèm file vào các bài viết (Không cần thông qua trình soạn thảo)<br  />- Thêm tính năng sắp xếp các bài viết.<br  />- Cho phép cấu hình layout khi xem chi tiết bài viết (Tưong tự module page đã có trước)<br  /><br  /><strong>Module page</strong><br  />-&nbsp; Thêm cấu hình alias lower khi thêm bài viết mới.<br  /><br  />Và nhiều cập nhật sửa lỗi khác, xem chi tiết tại: <a href=\"https://github.com/nukeviet/nukeviet/blob/develop/CHANGELOG.txt\">https://github.com/nukeviet/nukeviet/blob/develop/CHANGELOG.txt</a>', NULL, '', 'https://nukeviet.vn/vi/news/Tin-tuc/nukeviet-4-3-co-gi-moi-540.html', NULL, 2, '', 0, 1, 1, 1, 0, '', NULL, '', 2);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_vi_news_logs`
--

DROP TABLE IF EXISTS `nv5_vi_news_logs`;
CREATE TABLE `nv5_vi_news_logs` (
  `id` mediumint(8) UNSIGNED NOT NULL,
  `sid` mediumint(8) NOT NULL DEFAULT 0,
  `userid` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `log_key` varchar(60) NOT NULL DEFAULT '' COMMENT 'Khóa loại log, tùy vào lập trình',
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `note` varchar(255) NOT NULL DEFAULT '',
  `set_time` int(11) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_vi_news_report`
--

DROP TABLE IF EXISTS `nv5_vi_news_report`;
CREATE TABLE `nv5_vi_news_report` (
  `id` int(11) UNSIGNED NOT NULL,
  `newsid` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `md5content` char(32) NOT NULL DEFAULT '',
  `post_ip` char(50) NOT NULL DEFAULT '',
  `post_email` varchar(100) NOT NULL DEFAULT '',
  `post_time` int(11) NOT NULL DEFAULT 0,
  `orig_content` varchar(255) NOT NULL DEFAULT '',
  `repl_content` varchar(255) NOT NULL DEFAULT ''
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_vi_news_rows`
--

DROP TABLE IF EXISTS `nv5_vi_news_rows`;
CREATE TABLE `nv5_vi_news_rows` (
  `id` int(11) UNSIGNED NOT NULL,
  `catid` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `listcatid` varchar(255) NOT NULL DEFAULT '',
  `topicid` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `admin_id` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `author` varchar(250) DEFAULT '',
  `sourceid` mediumint(8) NOT NULL DEFAULT 0,
  `addtime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `edittime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `status` tinyint(4) NOT NULL DEFAULT 1,
  `weight` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `publtime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `exptime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `archive` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `title` varchar(250) NOT NULL DEFAULT '',
  `alias` varchar(250) NOT NULL DEFAULT '',
  `hometext` text NOT NULL,
  `homeimgfile` varchar(255) DEFAULT '',
  `homeimgalt` varchar(255) DEFAULT '',
  `homeimgthumb` tinyint(4) NOT NULL DEFAULT 0,
  `inhome` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `allowed_comm` varchar(255) DEFAULT '',
  `allowed_rating` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `external_link` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `hitstotal` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `hitscm` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `total_rating` int(11) NOT NULL DEFAULT 0,
  `click_rating` int(11) NOT NULL DEFAULT 0,
  `instant_active` tinyint(1) NOT NULL DEFAULT 0,
  `instant_template` varchar(100) NOT NULL DEFAULT '',
  `instant_creatauto` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_vi_news_rows`
--

INSERT INTO `nv5_vi_news_rows` (`id`, `catid`, `listcatid`, `topicid`, `admin_id`, `author`, `sourceid`, `addtime`, `edittime`, `status`, `weight`, `publtime`, `exptime`, `archive`, `title`, `alias`, `hometext`, `homeimgfile`, `homeimgalt`, `homeimgthumb`, `inhome`, `allowed_comm`, `allowed_rating`, `external_link`, `hitstotal`, `hitscm`, `total_rating`, `click_rating`, `instant_active`, `instant_template`, `instant_creatauto`) VALUES
(1, 1, '1,5,7', 0, 1, 'Quỳnh Nhi', 1, 1274989177, 1275318126, 1, 1, 1274989140, 0, 2, 'Ra mắt công ty mã nguồn mở đầu tiên tại Việt Nam', 'Ra-mat-cong-ty-ma-nguon-mo-dau-tien-tai-Viet-Nam', 'Mã nguồn mở NukeViet vốn đã quá quen thuộc với cộng đồng CNTT Việt Nam trong mấy năm qua. Tuy chưa hoạt động chính thức, nhưng chỉ trong khoảng 5 năm gần đây, mã nguồn mở NukeViet đã được dùng phổ biến ở Việt Nam, áp dụng ở hầu hết các lĩnh vực, từ tin tức đến thương mại điện tử, từ các website cá nhân cho tới những hệ thống website doanh nghiệp.', 'nangly.jpg', 'Thành lập VINADES.,JSC', 1, 1, '6', 1, 0, 2, 0, 0, 0, 0, '', 0),
(2, 7, '1,7', 0, 1, 'Nguyễn Thế Hùng', 7, 1453192444, 1453192444, 1, 12, 1453192444, 0, 2, 'Hãy trở thành nhà cung cấp dịch vụ của NukeViet&#33;', 'hay-tro-thanh-nha-cung-cap-dich-vu-cua-nukeviet', 'Nếu bạn là công ty hosting, là công ty thiết kế web có sử dụng mã nguồn NukeViet, là cơ sở đào tạo NukeViet hay là công ty bất kỳ có kinh doanh dịch vụ liên quan đến NukeViet... hãy cho chúng tôi biết thông tin liên hệ của bạn để NukeViet hỗ trợ bạn trong công việc kinh doanh nhé!', 'hoptac.jpg', '', 1, 1, '6', 1, 0, 13, 0, 0, 0, 0, '', 0),
(3, 4, '4', 0, 1, 'Phạm Quốc Tiến', 2, 1453192400, 1453192400, 1, 11, 1453192400, 0, 2, 'Tuyển dụng lập trình viên PHP phát triển NukeViet', 'Tuyen-dung-lap-trinh-vien-PHP', 'Bạn đam mê nguồn mở? Bạn đang cần tìm một công việc phù hợp với thế mạnh của bạn về PHP và MySQL? Hãy gia nhập VINADES.,JSC để xây dựng mã nguồn mở hàng đầu cho Việt Nam.', 'tuyendung-kythuat.jpg', 'Tuyển dụng', 1, 1, '6', 1, 0, 0, 0, 0, 0, 0, '', 0),
(4, 4, '4', 0, 1, 'Phạm Quốc Tiến', 0, 1445391089, 1445394192, 1, 5, 1445391060, 0, 2, 'Tuyển dụng chuyên viên đồ hoạ phát triển NukeViet', 'Tuyen-dung-chuyen-vien-do-hoa', 'Bạn đam mê nguồn mở? Bạn là chuyên gia đồ họa? Chúng tôi sẽ giúp bạn hiện thực hóa ước mơ của mình với một mức lương đảm bảo. Hãy gia nhập VINADES.,JSC để xây dựng mã nguồn mở hàng đầu cho Việt Nam.', 'tuyendung-kythuat.jpg', 'Tuyển dụng', 1, 1, '6', 1, 0, 0, 0, 0, 0, 0, '', 0),
(5, 4, '4', 0, 1, 'Phạm Quốc Tiến', 0, 1445391090, 1445394193, 1, 6, 1445391060, 0, 2, 'Tuyển dụng lập trình viên front-end (HTML/CSS/JS) phát triển NukeViet', 'Tuyen-dung-lap-trinh-vien-front-end-HTML-CSS-JS', 'Bạn đam mê nguồn mở? Bạn đang cần tìm một công việc phù hợp với thế mạnh của bạn về front-end (HTML/CSS/JS)? Hãy gia nhập VINADES.,JSC để xây dựng mã nguồn mở hàng đầu cho Việt Nam.', 'tuyendung-kythuat.jpg', 'Tuyển dụng', 1, 1, '6', 1, 0, 0, 0, 0, 0, 0, '', 0),
(6, 1, '1,6', 0, 1, '', 3, 1322685920, 1322686042, 1, 2, 1322685920, 0, 2, 'Mã nguồn mở NukeViet giành giải ba Nhân tài đất Việt 2011', 'Ma-nguon-mo-NukeViet-gianh-giai-ba-Nhan-tai-dat-Viet-2011', 'Không có giải nhất và giải nhì, sản phẩm Mã nguồn mở NukeViet của VINADES.,JSC là một trong ba sản phẩm đã đoạt giải ba Nhân tài đất Việt 2011 - Lĩnh vực Công nghệ thông tin (Sản phẩm đã ứng dụng rộng rãi).', 'nukeviet-nhantaidatviet2011.jpg', 'Mã nguồn mở NukeViet giành giải ba Nhân tài đất Việt 2011', 1, 1, '6', 1, 0, 1, 0, 0, 0, 0, '', 0),
(7, 1, '1', 0, 1, '', 4, 1445309676, 1445309676, 1, 3, 1445309520, 0, 2, 'NukeViet được ưu tiên mua sắm, sử dụng trong cơ quan, tổ chức nhà nước', 'nukeviet-duoc-uu-tien-mua-sam-su-dung-trong-co-quan-to-chuc-nha-nuoc', 'Ngày 5/12/2014, Bộ trưởng Bộ TT&TT Nguyễn Bắc Son đã ký ban hành Thông tư 20/2014/TT-BTTTT (Thông tư 20) quy định về các sản phẩm phần mềm nguồn mở (PMNM) được ưu tiên mua sắm, sử dụng trong cơ quan, tổ chức nhà nước. NukeViet (phiên bản 3.4.02 trở lên) là phần mềm được nằm trong danh sách này.', 'chuc-mung-nukeviet-thong-tu-20-bo-tttt.jpg', 'NukeViet được ưu tiên mua sắm, sử dụng trong cơ quan, tổ chức nhà nước', 1, 1, '4', 1, 0, 2, 0, 0, 0, 0, '', 0),
(8, 4, '4', 0, 1, 'Vũ Bích Ngọc', 0, 1445391061, 1445394203, 1, 4, 1445391000, 0, 2, 'Công ty VINADES tuyển dụng nhân viên kinh doanh', 'cong-ty-vinades-tuyen-dung-nhan-vien-kinh-doanh', 'Công ty cổ phần phát triển nguồn mở Việt Nam là đơn vị chủ quản của phần mềm mã nguồn mở NukeViet - một mã nguồn được tin dùng trong cơ quan nhà nước, đặc biệt là ngành giáo dục. Chúng tôi cần tuyển 05 nhân viên kinh doanh cho lĩnh vực này.', 'tuyen-dung-nvkd.png', '', 1, 1, '4', 1, 0, 0, 0, 0, 0, 0, '', 0),
(9, 1, '1,4', 0, 1, 'Trần Thị Thu', 0, 1445391118, 1445394180, 1, 7, 1445391060, 0, 2, 'Chương trình thực tập sinh tại công ty VINADES', 'chuong-trinh-thuc-tap-sinh-tai-cong-ty-vinades', 'Cơ hội để những sinh viên năng động được học tập, trải nghiệm, thử thách sớm với những tình huống thực tế, được làm việc cùng các chuyên gia có nhiều kinh nghiệm của công ty VINADES.', 'thuc-tap-sinh.jpg', '', 1, 1, '4', 1, 0, 0, 0, 0, 0, 0, '', 0),
(10, 4, '4', 0, 1, 'Trần Thị Thu', 0, 1445391135, 1445394444, 1, 8, 1445391120, 0, 2, 'Học việc tại công ty VINADES', 'hoc-viec-tai-cong-ty-vinades', 'Công ty cổ phần phát triển nguồn mở Việt Nam tạo cơ hội việc làm và học việc miễn phí cho những ứng viên có đam mê thiết kế web, lập trình PHP… được học tập và rèn luyện cùng đội ngũ lập trình viên phát triển NukeViet.', 'hoc-viec-tai-cong-ty-vinades.jpg', '', 1, 1, '4', 1, 0, 0, 0, 0, 0, 0, '', 0),
(11, 1, '1', 0, 1, '', 0, 1445391182, 1445394133, 1, 9, 1445391120, 0, 2, 'NukeViet được Bộ GD&amp;ĐT đưa vào Hướng dẫn thực hiện nhiệm vụ CNTT năm học 2015 - 2016', 'nukeviet-duoc-bo-gd-dt-dua-vao-huong-dan-thuc-hien-nhiem-vu-cntt-nam-hoc-2015-2016', 'Trong Hướng dẫn thực hiện nhiệm vụ CNTT năm học 2015 - 2016 của Bộ Giáo dục và Đào tạo, NukeViet được đưa vào các hạng mục: Tập huấn sử dụng phần mềm nguồn mở cho giáo viên và cán bộ quản lý giáo dục; Khai thác, sử dụng và dạy học; đặc biệt phần &quot;khuyến cáo khi sử dụng các hệ thống CNTT&quot; có chỉ rõ &quot;Không nên làm website mã nguồn đóng&quot; và &quot;Nên làm NukeViet: phần mềm nguồn mở&quot;.', 'nukeviet-cms.jpg', '', 1, 1, '4', 1, 0, 0, 0, 0, 0, 0, '', 0),
(12, 1, '1,3', 0, 1, '', 0, 1445391217, 1445393997, 1, 10, 1445391180, 0, 2, 'Hỗ trợ tập huấn và triển khai NukeViet cho các Phòng, Sở GD&amp;ĐT', 'ho-tro-tap-huan-va-trien-khai-nukeviet-cho-cac-phong-so-gd-dt', 'Trên cơ sở Hướng dẫn thực hiện nhiệm vụ CNTT năm học 2015 - 2016 của Bộ Giáo dục và Đào tạo, Công ty cổ phần phát triển nguồn mở Việt Nam và các doanh nghiệp phát triển NukeViet trong cộng đồng NukeViet đang tích cực công tác hỗ trợ cho các phòng GD&ĐT, Sở GD&ĐT triển khai 2 nội dung chính: Hỗ trợ công tác đào tạo tập huấn hướng dẫn sử dụng NukeViet và Hỗ trợ triển khai NukeViet cho các trường, Phòng và Sở GD&ĐT', 'tap-huan-pgd-ha-dong-2015.jpg', 'Tập huấn triển khai NukeViet tại Phòng Giáo dục và Đào tạo Hà Đông - Hà Nội', 1, 1, '4', 1, 0, 1, 0, 0, 0, 0, '', 0),
(13, 2, '2', 0, 1, 'VINADES', 0, 1453194455, 1453194455, 1, 13, 1453194455, 0, 2, 'NukeViet 4.0 có gì mới?', 'nukeviet-4-0-co-gi-moi', 'NukeViet 4 là phiên bản NukeViet được cộng đồng đánh giá cao, hứa hẹn nhiều điểm vượt trội về công nghệ đến thời điểm hiện tại. NukeViet 4 thay đổi gần như hoàn toàn từ nhân hệ thống đến chức năng, giao diện người dùng. Vậy, có gì mới trong phiên bản này?', 'chuc-mung-nukeviet-thong-tu-20-bo-tttt.jpg', '', 1, 1, '4', 1, 0, 2, 0, 0, 0, 0, '', 0),
(14, 2, '2', 0, 1, 'VINADES', 0, 1501837620, 1501837620, 1, 14, 1501837620, 0, 2, 'NukeViet 4.2 có gì mới?', 'nukeviet-4-2-co-gi-moi', 'NukeViet 4.2 là phiên bản nâng cấp của phiên bản NukeViet 4.0 tập trung vào việc fix các vấn đề bất cập còn tồn tại của NukeViet 4.0, Thêm các tính năng mới để tăng cường bảo mật của hệ thống cũng như tối ưu trải nghiệm của người dùng.', 'chuc-mung-nukeviet-thong-tu-20-bo-tttt.jpg', '', 1, 1, '4', 1, 1, 2, 0, 0, 0, 0, '', 0),
(15, 2, '2', 0, 1, 'VINADES', 0, 1510215907, 1510215907, 1, 15, 1510215907, 0, 2, 'NukeViet 4.3 có gì mới?', 'nukeviet-4-3-co-gi-moi', 'NukeViet 4.3 là phiên bản nâng cấp của phiên bản NukeViet 4.2 tập trung vào việc fix các vấn đề bất cập còn tồn tại, tối ưu trải nghiệm của người dùng.', 'chuc-mung-nukeviet-thong-tu-20-bo-tttt.jpg', '', 1, 1, '4', 1, 1, 2, 0, 0, 0, 0, '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_vi_news_row_histories`
--

DROP TABLE IF EXISTS `nv5_vi_news_row_histories`;
CREATE TABLE `nv5_vi_news_row_histories` (
  `id` int(11) UNSIGNED NOT NULL,
  `new_id` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `historytime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `catid` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `listcatid` varchar(255) NOT NULL DEFAULT '',
  `topicid` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `admin_id` mediumint(8) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'ID người đăng',
  `author` varchar(250) NOT NULL DEFAULT '',
  `sourceid` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `publtime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `exptime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `archive` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `title` varchar(250) NOT NULL DEFAULT '',
  `alias` varchar(250) NOT NULL DEFAULT '',
  `hometext` text NOT NULL,
  `homeimgfile` varchar(255) DEFAULT '',
  `homeimgalt` varchar(255) DEFAULT '',
  `inhome` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `allowed_comm` varchar(255) DEFAULT '',
  `allowed_rating` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `external_link` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `instant_active` tinyint(1) NOT NULL DEFAULT 0,
  `instant_template` varchar(100) NOT NULL DEFAULT '',
  `instant_creatauto` tinyint(1) NOT NULL DEFAULT 0,
  `titlesite` varchar(255) NOT NULL DEFAULT '',
  `description` text NOT NULL,
  `bodyhtml` longtext NOT NULL,
  `voicedata` text DEFAULT NULL COMMENT 'Data giọng đọc json',
  `keywords` varchar(255) DEFAULT '',
  `sourcetext` varchar(255) DEFAULT '',
  `files` text DEFAULT NULL,
  `tags` text DEFAULT NULL,
  `internal_authors` varchar(255) NOT NULL DEFAULT '',
  `imgposition` tinyint(1) NOT NULL DEFAULT 1,
  `layout_func` varchar(100) DEFAULT '',
  `copyright` tinyint(1) NOT NULL DEFAULT 0,
  `allowed_send` tinyint(1) NOT NULL DEFAULT 0,
  `allowed_print` tinyint(1) NOT NULL DEFAULT 0,
  `allowed_save` tinyint(1) NOT NULL DEFAULT 0,
  `auto_nav` tinyint(1) NOT NULL DEFAULT 0,
  `group_view` varchar(255) DEFAULT '',
  `changed_fields` text NOT NULL COMMENT 'Các field thay đổi'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Lịch sử bài viết';

-- --------------------------------------------------------

--
-- Table structure for table `nv5_vi_news_sources`
--

DROP TABLE IF EXISTS `nv5_vi_news_sources`;
CREATE TABLE `nv5_vi_news_sources` (
  `sourceid` mediumint(8) UNSIGNED NOT NULL,
  `title` varchar(250) NOT NULL DEFAULT '',
  `link` varchar(255) DEFAULT '',
  `logo` varchar(255) DEFAULT '',
  `weight` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `add_time` int(11) UNSIGNED NOT NULL,
  `edit_time` int(11) UNSIGNED NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_vi_news_sources`
--

INSERT INTO `nv5_vi_news_sources` (`sourceid`, `title`, `link`, `logo`, `weight`, `add_time`, `edit_time`) VALUES
(1, 'Báo Hà Nội Mới', 'http://hanoimoi.com.vn', '', 1, 1274989177, 1274989177),
(2, 'VINADES.,JSC', 'https://vinades.vn', '', 2, 1274989787, 1274989787),
(3, 'Báo điện tử Dân Trí', 'http://dantri.com.vn', '', 3, 1322685396, 1322685396),
(4, 'Bộ Thông tin và Truyền thông', 'http://http://mic.gov.vn', '', 4, 1445309676, 1445309676);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_vi_news_tags`
--

DROP TABLE IF EXISTS `nv5_vi_news_tags`;
CREATE TABLE `nv5_vi_news_tags` (
  `tid` mediumint(8) UNSIGNED NOT NULL,
  `numnews` mediumint(8) NOT NULL DEFAULT 0,
  `title` varchar(250) NOT NULL DEFAULT '',
  `alias` varchar(250) NOT NULL DEFAULT '',
  `image` varchar(255) DEFAULT '',
  `description` text DEFAULT NULL,
  `keywords` varchar(255) DEFAULT ''
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_vi_news_tags`
--

INSERT INTO `nv5_vi_news_tags` (`tid`, `numnews`, `title`, `alias`, `image`, `description`, `keywords`) VALUES
(1, 0, 'Nguồn mở', 'nguồn-mở', '', '', 'nguồn mở'),
(2, 0, 'Quen thuộc', 'quen-thuộc', '', '', 'quen thuộc'),
(3, 0, 'Cộng đồng', 'cộng-đồng', '', '', 'cộng đồng'),
(4, 0, 'Việt Nam', 'việt-nam', '', '', 'việt nam'),
(5, 0, 'Hoạt động', 'hoạt-động', '', '', 'hoạt động'),
(6, 0, 'Tin tức', 'tin-tức', '', '', 'tin tức'),
(7, 1, 'Thương mại điện', 'thương-mại-điện', '', '', 'thương mại điện'),
(8, 0, 'Điện tử', 'điện-tử', '', '', 'điện tử'),
(9, 13, 'Nukeviet', 'nukeviet', '', '', 'nukeviet'),
(10, 8, 'VINADES', 'vinades', '', '', 'vinades'),
(11, 3, 'Lập trình viên', 'lập-trình-viên', '', '', 'lập trình viên'),
(12, 3, 'Chuyên viên đồ họa', 'chuyên-viên-đồ-họa', '', '', 'chuyên viên đồ họa'),
(13, 3, 'Php', 'php', '', '', 'php'),
(14, 2, 'Mysql', 'mysql', '', '', 'mysql'),
(15, 1, 'Nhân tài đất Việt 2011', 'nhân-tài-đất-việt-2011', '', '', 'nhân tài đất việt 2011'),
(16, 9, 'Mã nguồn mở', 'mã-nguồn-mở', '', '', 'mã nguồn mở'),
(17, 2, 'Nukeviet4', 'nukeviet4', '', '', 'nukeviet4'),
(18, 1, 'Mail', 'mail', '', '', 'mail'),
(19, 1, 'Fpt', 'fpt', '', '', 'fpt'),
(20, 1, 'Smtp', 'smtp', '', '', 'smtp'),
(21, 1, 'Bootstrap', 'bootstrap', '', '', 'bootstrap'),
(22, 1, 'Block', 'block', '', '', 'block'),
(23, 1, 'Modules', 'modules', '', '', 'modules'),
(24, 2, 'Banner', 'banner', '', '', 'banner'),
(25, 1, 'Liên kết', 'liên-kết', '', '', 'liên kết'),
(26, 2, 'Hosting', 'hosting', '', '', 'hosting'),
(27, 1, 'Hỗ trợ', 'hỗ-trợ', '', '', 'hỗ trợ'),
(28, 1, 'Hợp tác', 'hợp-tác', '', '', 'hợp tác'),
(29, 1, 'Tốc độ', 'tốc-độ', '', '', 'tốc độ'),
(30, 2, 'Website', 'website', '', '', 'website'),
(31, 1, 'Bảo mật', 'bảo-mật', '', '', 'bảo mật'),
(32, 4, 'Giáo dục', 'giáo-dục', '', '', 'giáo dục'),
(33, 1, 'Edu gate', 'edu-gate', '', '', 'edu gate'),
(34, 2, 'Lập trình', 'lập-trình', '', '', 'lập trình'),
(35, 1, 'Logo', 'logo', '', '', 'logo'),
(36, 1, 'Code', 'code', '', '', 'code'),
(37, 1, 'Thực tập', 'thực-tập', '', '', 'thực tập'),
(38, 1, 'Kinh doanh', 'kinh-doanh', '', '', 'kinh doanh'),
(39, 1, 'Nhân viên', 'nhân-viên', '', '', 'nhân viên'),
(40, 1, 'Bộ GD&ĐT', 'bộ-gd-đt', '', '', 'bộ gd&đt'),
(41, 1, 'Module', 'module', '', '', 'module'),
(42, 1, 'Php Nuke', 'php-nuke', '', '', 'php-nuke');

-- --------------------------------------------------------

--
-- Table structure for table `nv5_vi_news_tags_id`
--

DROP TABLE IF EXISTS `nv5_vi_news_tags_id`;
CREATE TABLE `nv5_vi_news_tags_id` (
  `id` int(11) NOT NULL,
  `tid` mediumint(9) NOT NULL,
  `keyword` varchar(65) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_vi_news_tags_id`
--

INSERT INTO `nv5_vi_news_tags_id` (`id`, `tid`, `keyword`) VALUES
(1, 7, 'thương mại điện'),
(1, 9, 'nukeviet'),
(1, 41, 'module'),
(1, 16, 'mã nguồn mở'),
(1, 42, 'php-nuke'),
(2, 16, 'mã nguồn mở'),
(2, 9, 'nukeviet'),
(2, 17, 'nukeviet4'),
(2, 10, 'vinades'),
(2, 24, 'banner'),
(2, 25, 'liên kết'),
(2, 26, 'hosting'),
(2, 27, 'hỗ trợ'),
(2, 28, 'hợp tác'),
(3, 10, 'vinades'),
(3, 9, 'nukeviet'),
(3, 11, 'lập trình viên'),
(3, 12, 'chuyên viên đồ họa'),
(3, 13, 'php'),
(3, 14, 'mysql'),
(4, 10, 'vinades'),
(4, 34, 'lập trình'),
(4, 35, 'logo'),
(4, 24, 'banner'),
(4, 30, 'website'),
(4, 36, 'code'),
(4, 13, 'php'),
(5, 16, 'mã nguồn mở'),
(5, 10, 'vinades'),
(5, 34, 'lập trình'),
(5, 9, 'nukeviet'),
(6, 15, 'nhân tài đất việt 2011'),
(6, 16, 'mã nguồn mở'),
(6, 9, 'nukeviet'),
(7, 16, 'mã nguồn mở'),
(7, 9, 'nukeviet'),
(7, 40, 'bộ gd&đt'),
(7, 32, 'giáo dục'),
(8, 38, 'kinh doanh'),
(8, 9, 'nukeviet'),
(8, 32, 'giáo dục'),
(8, 39, 'nhân viên'),
(9, 37, 'thực tập'),
(9, 10, 'vinades'),
(9, 12, 'chuyên viên đồ họa'),
(9, 11, 'lập trình viên'),
(9, 9, 'nukeviet'),
(9, 16, 'mã nguồn mở'),
(10, 16, 'mã nguồn mở'),
(10, 10, 'vinades'),
(10, 9, 'nukeviet'),
(10, 11, 'lập trình viên'),
(10, 12, 'chuyên viên đồ họa'),
(11, 9, 'nukeviet'),
(11, 16, 'mã nguồn mở'),
(11, 32, 'giáo dục'),
(12, 9, 'nukeviet'),
(12, 32, 'giáo dục'),
(12, 33, 'edu gate'),
(13, 17, 'nukeviet4'),
(13, 9, 'nukeviet'),
(13, 10, 'vinades'),
(13, 13, 'php'),
(13, 14, 'mysql'),
(13, 18, 'mail'),
(13, 19, 'fpt'),
(13, 20, 'smtp'),
(13, 21, 'bootstrap'),
(13, 22, 'block'),
(13, 23, 'modules'),
(13, 16, 'mã nguồn mở');

-- --------------------------------------------------------

--
-- Table structure for table `nv5_vi_news_tmp`
--

DROP TABLE IF EXISTS `nv5_vi_news_tmp`;
CREATE TABLE `nv5_vi_news_tmp` (
  `id` int(11) UNSIGNED NOT NULL,
  `type` tinyint(1) NOT NULL DEFAULT 0 COMMENT '0: thao tác sửa bài, 1: bản nháp',
  `new_id` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'ID bài viết',
  `admin_id` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'ID người thao tác',
  `time_edit` int(11) NOT NULL DEFAULT 0 COMMENT 'Thời gian thao tác',
  `time_late` int(11) NOT NULL DEFAULT 0 COMMENT 'Thời gian cuối cùng thao tác',
  `ip` varchar(40) NOT NULL DEFAULT '' COMMENT 'IP thao tác',
  `uuid` varchar(36) NOT NULL DEFAULT '' COMMENT 'ID bản nháp nếu soạn bài mới',
  `properties` mediumtext DEFAULT NULL COMMENT 'Json khác'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bản nháp và ghi nhận sửa bài';

-- --------------------------------------------------------

--
-- Table structure for table `nv5_vi_news_topics`
--

DROP TABLE IF EXISTS `nv5_vi_news_topics`;
CREATE TABLE `nv5_vi_news_topics` (
  `topicid` smallint(5) UNSIGNED NOT NULL,
  `title` varchar(250) NOT NULL DEFAULT '',
  `alias` varchar(250) NOT NULL DEFAULT '',
  `image` varchar(255) DEFAULT '',
  `description` varchar(255) DEFAULT '',
  `weight` smallint(5) NOT NULL DEFAULT 0,
  `keywords` text DEFAULT NULL,
  `add_time` int(11) NOT NULL DEFAULT 0,
  `edit_time` int(11) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_vi_news_topics`
--

INSERT INTO `nv5_vi_news_topics` (`topicid`, `title`, `alias`, `image`, `description`, `weight`, `keywords`, `add_time`, `edit_time`) VALUES
(1, 'NukeViet 4', 'NukeViet-4', '', 'NukeViet 4', 1, 'NukeViet 4', 1445396011, 1445396011);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_vi_news_voices`
--

DROP TABLE IF EXISTS `nv5_vi_news_voices`;
CREATE TABLE `nv5_vi_news_voices` (
  `id` smallint(4) UNSIGNED NOT NULL,
  `voice_key` varchar(50) NOT NULL DEFAULT '' COMMENT 'Khóa dùng trong Api sau này',
  `title` varchar(250) NOT NULL DEFAULT '',
  `description` text NOT NULL,
  `add_time` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `edit_time` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `weight` smallint(4) UNSIGNED NOT NULL DEFAULT 0,
  `status` tinyint(4) NOT NULL DEFAULT 1 COMMENT '0: Dừng, 1: Hoạt động'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_vi_page`
--

DROP TABLE IF EXISTS `nv5_vi_page`;
CREATE TABLE `nv5_vi_page` (
  `id` mediumint(8) UNSIGNED NOT NULL,
  `title` varchar(250) NOT NULL,
  `alias` varchar(250) NOT NULL,
  `image` varchar(255) DEFAULT '',
  `imagealt` varchar(255) DEFAULT '',
  `imageposition` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `description` text DEFAULT NULL,
  `bodytext` mediumtext NOT NULL,
  `keywords` text DEFAULT NULL,
  `socialbutton` tinyint(4) NOT NULL DEFAULT 0,
  `activecomm` varchar(255) DEFAULT '',
  `layout_func` varchar(100) DEFAULT '',
  `weight` smallint(4) NOT NULL DEFAULT 0,
  `admin_id` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `add_time` int(11) NOT NULL DEFAULT 0,
  `edit_time` int(11) NOT NULL DEFAULT 0,
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `hitstotal` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `hot_post` tinyint(1) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_vi_page_config`
--

DROP TABLE IF EXISTS `nv5_vi_page_config`;
CREATE TABLE `nv5_vi_page_config` (
  `config_name` varchar(30) NOT NULL,
  `config_value` varchar(255) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_vi_page_config`
--

INSERT INTO `nv5_vi_page_config` (`config_name`, `config_value`) VALUES
('viewtype', '0'),
('facebookapi', ''),
('per_page', '20'),
('news_first', '0'),
('related_articles', '5'),
('copy_page', '0'),
('alias_lower', '1'),
('socialbutton', 'facebook,twitter');

-- --------------------------------------------------------

--
-- Table structure for table `nv5_vi_referer_stats`
--

DROP TABLE IF EXISTS `nv5_vi_referer_stats`;
CREATE TABLE `nv5_vi_referer_stats` (
  `host` varchar(250) NOT NULL,
  `total` int(11) NOT NULL DEFAULT 0,
  `month01` int(11) NOT NULL DEFAULT 0,
  `month02` int(11) NOT NULL DEFAULT 0,
  `month03` int(11) NOT NULL DEFAULT 0,
  `month04` int(11) NOT NULL DEFAULT 0,
  `month05` int(11) NOT NULL DEFAULT 0,
  `month06` int(11) NOT NULL DEFAULT 0,
  `month07` int(11) NOT NULL DEFAULT 0,
  `month08` int(11) NOT NULL DEFAULT 0,
  `month09` int(11) NOT NULL DEFAULT 0,
  `month10` int(11) NOT NULL DEFAULT 0,
  `month11` int(11) NOT NULL DEFAULT 0,
  `month12` int(11) NOT NULL DEFAULT 0,
  `last_update` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Thống kê đường dẫn đến site';

-- --------------------------------------------------------

--
-- Table structure for table `nv5_vi_searchkeys`
--

DROP TABLE IF EXISTS `nv5_vi_searchkeys`;
CREATE TABLE `nv5_vi_searchkeys` (
  `id` varchar(32) NOT NULL DEFAULT '',
  `skey` varchar(250) NOT NULL,
  `total` int(11) NOT NULL DEFAULT 0,
  `search_engine` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Từ khóa tìm kiếm';

-- --------------------------------------------------------

--
-- Table structure for table `nv5_vi_siteterms`
--

DROP TABLE IF EXISTS `nv5_vi_siteterms`;
CREATE TABLE `nv5_vi_siteterms` (
  `id` mediumint(8) UNSIGNED NOT NULL,
  `title` varchar(250) NOT NULL,
  `alias` varchar(250) NOT NULL,
  `image` varchar(255) DEFAULT '',
  `imagealt` varchar(255) DEFAULT '',
  `imageposition` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `description` text DEFAULT NULL,
  `bodytext` mediumtext NOT NULL,
  `keywords` text DEFAULT NULL,
  `socialbutton` tinyint(4) NOT NULL DEFAULT 0,
  `activecomm` varchar(255) DEFAULT '',
  `layout_func` varchar(100) DEFAULT '',
  `weight` smallint(4) NOT NULL DEFAULT 0,
  `admin_id` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `add_time` int(11) NOT NULL DEFAULT 0,
  `edit_time` int(11) NOT NULL DEFAULT 0,
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `hitstotal` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `hot_post` tinyint(1) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_vi_siteterms`
--

INSERT INTO `nv5_vi_siteterms` (`id`, `title`, `alias`, `image`, `imagealt`, `imageposition`, `description`, `bodytext`, `keywords`, `socialbutton`, `activecomm`, `layout_func`, `weight`, `admin_id`, `add_time`, `edit_time`, `status`, `hitstotal`, `hot_post`) VALUES
(1, 'Chính sách bảo mật (Quyền riêng tư)', 'privacy', '', '', 0, 'Tài liệu này cung cấp cho bạn (người truy cập và sử dụng website) chính sách liên quan đến bảo mật và quyền riêng tư của bạn', '<strong><a id=\"index\" name=\"index\"></a>Danh mục</strong><br /> <a href=\"#1\">Điều 1: Thu thập thông tin</a><br /> <a href=\"#2\">Điều 2: Lưu trữ &amp; Bảo vệ thông tin</a><br /> <a href=\"#3\">Điều 3: Sử dụng thông tin </a><br /> <a href=\"#4\">Điều 4: Tiếp nhận thông tin từ các đối tác </a><br /> <a href=\"#5\">Điều 5: Chia sẻ thông tin với bên thứ ba</a><br /> <a href=\"#6\">Điều 6: Thay đổi chính sách bảo mật</a>  <hr  /> <h2><a id=\"1\" name=\"1\"></a>Điều 1: Thu thập thông tin</h2>  <h3>1.1. Thu thập tự động:</h3>  <div>Hệ thống này được xây dựng bằng mã nguồn NukeViet. Như mọi website hiện đại khác, chúng tôi sẽ thu thập địa chỉ IP và các thông tin web tiêu chuẩn khác của bạn như: loại trình duyệt, các trang bạn truy cập trong quá trình sử dụng dịch vụ, thông tin về máy tính &amp; thiết bị mạng v.v… cho mục đích phân tích thông tin phục vụ việc bảo mật và giữ an toàn cho hệ thống.</div>  <h3>1.2. Thu thập từ các khai báo của chính bạn:</h3>  <div>Các thông tin do bạn khai báo cho chúng tôi trong quá trình làm việc như: đăng ký tài khoản, liên hệ với chúng tôi... cũng sẽ được chúng tôi lưu trữ phục vụ công việc chăm sóc khách hàng sau này.</div>  <h3>1.3. Thu thập thông tin thông qua việc đặt cookies:</h3>  <p>Như mọi website hiện đại khác, khi bạn truy cập website, chúng tôi (hoặc các công cụ theo dõi hoặc thống kê hoạt động của website do các đối tác cung cấp) sẽ đặt một số File dữ liệu gọi là Cookies lên đĩa cứng hoặc bộ nhớ máy tính của bạn.</p>  <p>Một trong số những Cookies này có thể tồn tại lâu để thuận tiện cho bạn trong quá trình sử dụng, ví dụ như: lưu Email của bạn trong trang đăng nhập để bạn không phải nhập lại v.v…</p>  <h3>1.4. Thu thập và lưu trữ thông tin trong quá khứ:</h3>  <p>Bạn có thể thay đổi thông tin cá nhân của mình bất kỳ lúc nào bằng cách sử dụng chức năng tương ứng. Tuy nhiên chúng tôi sẽ lưu lại những thông tin bị thay đổi để chống các hành vi xóa dấu vết gian lận.</p>  <p style=\"text-align: right;\"><a href=\"#index\">Trở lại danh mục</a></p>  <h2><a id=\"2\" name=\"2\"></a>Điều 2: Lưu trữ &amp; Bảo vệ thông tin</h2>  <div>Hầu hết các thông tin được thu thập sẽ được lưu trữ tại cơ sở dữ liệu của chúng tôi.<br /> <br /> Chúng tôi bảo vệ dữ liệu cá nhân của các bạn bằng các hình thức như: mật khẩu, tường lửa, mã hóa cùng các hình thức thích hợp khác và chỉ cấp phép việc truy cập và xử lý dữ liệu cho các đối tượng phù hợp, ví dụ chính bạn hoặc các nhân viên có trách nhiệm xử lý thông tin với bạn thông qua các bước xác định danh tính phù hợp.<br /> <br /> Mật khẩu của bạn được lưu trữ và bảo vệ bằng phương pháp mã hoá trong cơ sở dữ liệu của hệ thống, vì thế nó rất an toàn. Tuy nhiên, chúng tôi khuyên bạn không nên dùng lại mật khẩu này trên các website khác. Mật khẩu của bạn là cách duy nhất để bạn đăng nhập vào tài khoản thành viên của mình trong website này, vì thế hãy cất giữ nó cẩn thận. Trong mọi trường hợp bạn không nên cung cấp thông tin mật khẩu cho bất kỳ người nào dù là người của chúng tôi, người của NukeViet hay bất kỳ người thứ ba nào khác trừ khi bạn hiểu rõ các rủi ro khi để lộ mật khẩu. Nếu quên mật khẩu, bạn có thể sử dụng chức năng “<a href=\"/users/lostpass/\">Quên mật khẩu</a>” trên website. Để thực hiện việc này, bạn cần phải cung cấp cho hệ thống biết tên thành viên hoặc địa chỉ Email đang sử dụng của mình trong tài khoản, sau đó hệ thống sẽ tạo ra cho bạn mật khẩu mới và gửi đến cho bạn để bạn vẫn có thể đăng nhập vào tài khoản thành viên của mình.  <p style=\"text-align: right;\"><a href=\"#index\">Trở lại danh mục</a></p> </div>  <h2><a id=\"3\" name=\"3\"></a>Điều 3: Sử dụng thông tin</h2>  <p>Thông tin thu thập được sẽ được chúng tôi sử dụng để:</p>  <div>- Cung cấp các dịch vụ hỗ trợ &amp; chăm sóc khách hàng.</div>  <div>- Thực hiện giao dịch thanh toán &amp; gửi các thông báo trong quá trình giao dịch.</div>  <div>- Xử lý khiếu nại, thu phí &amp; giải quyết sự cố.</div>  <div>- Ngăn chặn các hành vi có nguy cơ rủi ro, bị cấm hoặc bất hợp pháp và đảm bảo tuân thủ đúng chính sách “Thỏa thuận người dùng”.</div>  <div>- Đo đạc, tùy biến &amp; cải tiến dịch vụ, nội dung và hình thức của website.</div>  <div>- Gửi bạn các thông tin về chương trình Marketing, các thông báo &amp; chương trình khuyến mại.</div>  <div>- So sánh độ chính xác của thông tin cá nhân của bạn trong quá trình kiểm tra với bên thứ ba.</div>  <p style=\"text-align: right;\"><a href=\"#index\">Trở lại danh mục</a></p>  <h2><a id=\"4\" name=\"4\"></a>Điều 4: Tiếp nhận thông tin từ các đối tác</h2>  <div>Khi sử dụng các công cụ giao dịch và thanh toán thông qua internet, chúng tôi có thể tiếp nhận thêm các thông tin về bạn như địa chỉ username, Email, số tài khoản ngân hàng... Chúng tôi kiểm tra những thông tin này với cơ sở dữ liệu người dùng của mình nhằm xác nhận rằng bạn có phải là khách hàng của chúng tôi hay không nhằm giúp việc thực hiện các dịch vụ cho bạn được thuận lợi.<br /> <br /> Các thông tin tiếp nhận được sẽ được chúng tôi bảo mật như những thông tin mà chúng tôi thu thập được trực tiếp từ bạn.</div>  <p style=\"text-align: right;\"><a href=\"#index\">Trở lại danh mục</a></p>  <h2><a id=\"5\" name=\"5\"></a>Điều 5: Chia sẻ thông tin với bên thứ ba</h2>  <p>Chúng tôi sẽ không chia sẻ thông tin cá nhân, thông tin tài chính... của bạn cho các bên thứ 3 trừ khi được sự đồng ý của chính bạn hoặc khi chúng tôi buộc phải tuân thủ theo các quy định pháp luật hoặc khi có yêu cầu từ cơ quan công quyền có thẩm quyền.</p>  <p style=\"text-align: right;\"><a href=\"#index\">Trở lại danh mục</a></p>  <h2><a id=\"6\" name=\"6\"></a>Điều 6: Thay đổi chính sách bảo mật</h2>  <p>Chính sách Bảo mật này có thể thay đổi theo thời gian. Chúng tôi sẽ không giảm quyền của bạn theo Chính sách Bảo mật này mà không có sự đồng ý rõ ràng của bạn. Chúng tôi sẽ đăng bất kỳ thay đổi Chính sách Bảo mật nào trên trang này và, nếu những thay đổi này quan trọng, chúng tôi sẽ cung cấp thông báo nổi bật hơn (bao gồm, đối với một số dịch vụ nhất định, thông báo bằng email về các thay đổi của Chính sách Bảo mật).</p>  <p style=\"text-align: right;\"><a href=\"#index\">Trở lại danh mục</a></p>  <p style=\"text-align: right;\">Chính sách bảo mật mặc định này được xây dựng cho <a href=\"https://nukeviet.vn\" target=\"_blank\">NukeViet CMS</a>, được tham khảo từ website <a href=\"http://webnhanh.vn/vi/thiet-ke-web/detail/Chinh-sach-bao-mat-Quyen-rieng-tu-Privacy-Policy-2147/\">webnhanh.vn</a></p>', '', 0, '4', '', 1, 1, 1742685231, 1742685231, 1, 0, 0),
(2, 'Điều khoản và điều kiện sử dụng', 'terms-and-conditions', '', '', 0, 'Đây là các điều khoản và điều kiện áp dụng cho website này. Truy cập và sử dụng website tức là bạn đã đồng ý với các quy định này.', '<div>Cảm ơn bạn đã sử dụng. Xin vui lòng đọc các Điều khoản một cách cẩn thận, và <a href=\"/contact/\">liên hệ</a> với chúng tôi nếu bạn có bất kỳ câu hỏi. Bằng việc truy cập hoặc sử dụng website của chúng tôi, bạn đồng ý bị ràng buộc bởi các <a href=\"/siteterms/terms-and-conditions.html\">Điều khoản và điều kiện</a> sử dụng cũng như <a href=\"/siteterms/privacy.html\">Chính sách bảo mật</a> của chúng tôi. Nếu không đồng ý với các quy định này, bạn vui lòng ngưng sử dụng website.<br /> <br /> <strong><a id=\"index\" name=\"index\"></a>Danh mục</strong><br /> <a href=\"#1\">Điều 1: Điều khoản liên quan đến phần mềm vận hành website</a><br /> <a href=\"#2\">Điều 2: Giới hạn cho việc sử dụng Website và các tài liệu trên website</a><br /> <a href=\"#3\">Điều 3: Sử dụng thương hiệu</a><br /> <a href=\"#4\">Điều 4: Các hành vi bị nghiêm cấm</a><br /> <a href=\"#5\">Điều 5: Các đường liên kết đến các website khác</a><br /> <a href=\"#6\">Điều 6: Từ chối bảo đảm</a><br /> <a href=\"#7\">Điều 7: Luật áp dụng và cơ quan giải quyết tranh chấp</a><br /> <a href=\"#8\">Điều 8: Thay đổi điều khoản và điều kiện sử dụng</a></div>  <hr  /> <h2><a id=\"1\" name=\"1\"></a>Điều khoản liên quan đến phần mềm vận hành website</h2>  <p>- Website của chúng tôi sử dụng hệ thống NukeViet, là giải pháp về website/ cổng thông tin nguồn mở được phát hành theo giấy phép bản quyền phần mềm tự do nguồn mở “<a href=\"http://www.gnu.org/licenses/old-licenses/gpl-2.0.html\" target=\"_blank\">GNU General Public License</a>” (viết tắt là GNU/GPL hay GPL) và có thể tải về miễn phí tại trang web <a href=\"http://www.nukeviet.vn\" target=\"_blank\">www.nukeviet.vn</a>.<br /> - Website này do chúng tôi sở hữu, điều hành và duy trì. NukeViet (hiểu ở đây là “hệ thống NukeViet” (bao gồm nhân hệ thống NukeViet và các sản phẩm phái sinh như NukeViet CMS, NukeViet Portal, <a href=\"http://edu.nukeviet.vn\" target=\"_blank\">NukeViet Edu Gate</a>...), “www.nukeviet.vn”, “tổ chức NukeViet”, “ban điều hành NukeViet”, &quot;Ban Quản Trị NukeViet&quot; và nói chung là những gì liên quan đến NukeViet...) không liên quan gì đến việc chúng tôi điều hành website cũng như quy định bạn được phép làm và không được phép làm gì trên website này.<br /> - Hệ thống NukeViet là bộ mã nguồn được phát triển để xây dựng các website/ cổng thông tin trên mạng. Chúng tôi (chủ sở hữu, điều hành và duy trì website này) không hỗ trợ và khẳng định hay ngụ ý về việc có liên quan đến NukeViet. Để biết thêm nhiều thông tin về NukeViet, hãy ghé thăm website của NukeViet tại địa chỉ: <a href=\"https://nukeviet.vn\" target=\"_blank\">https://nukeviet.vn</a>.</p>  <p style=\"text-align: right;\"><a href=\"#index\">Trở lại danh mục</a></p>  <h2><a id=\"2\" name=\"2\"></a>Giới hạn cho việc sử dụng Website và các tài liệu trên website</h2>  <p>- Tất cả các quyền liên quan đến tất cả tài liệu và thông tin được hiển thị và/ hoặc được tạo ra sẵn cho Website này (ví dụ như những tài liệu được cung cấp để tải về) được quản lý, sở hữu hoặc được cho phép sử dụng bởi chúng tôi hoặc chủ sở hữu tương ứng với giấy phép tương ứng. Việc sử dụng các tài liệu và thông tin phải được tuân thủ theo giấy phép tương ứng được áp dụng cho chúng.<br /> - Ngoại trừ các tài liệu được cấp phép rõ ràng dưới dạng giấy phép tư liệu mở&nbsp;Creative Commons (gọi là giấy phép CC) cho phép bạn khai thác và chia sẻ theo quy định của giấy phép tư liệu mở, đối với các loại tài liệu không ghi giấy phép rõ ràng thì bạn không được phép sử dụng (bao gồm nhưng không giới hạn việc sao chép, chỉnh sửa toàn bộ hay một phần, đăng tải, phân phối, cấp phép, bán và xuất bản) bất cứ tài liệu nào mà không có sự cho phép trước bằng văn bản của chúng tôi ngoại trừ việc sử dụng cho mục đích cá nhân, nội bộ, phi thương mại.<br /> - Một số tài liệu hoặc thông tin có những điều khoản và điều kiện áp dụng riêng cho chúng không phải là giấy phép tư liệu mở, trong trường hợp như vậy, bạn được yêu cầu phải chấp nhận các điều khoản và điều kiện đó khi truy cập vào các tài liệu và thông tin này.</p>  <p style=\"text-align: right;\"><a href=\"#index\">Trở lại danh mục</a></p>  <h2><a id=\"3\" name=\"3\"></a>Sử dụng thương hiệu</h2>  <p>- VINADES.,JSC, NukeViet và thương hiệu gắn với NukeViet (ví dụ NukeViet CMS, NukeViet Portal, NukeViet Edu Gate...), logo công ty VINADES thuộc sở hữu của Công ty cổ phần phát triển nguồn mở Việt Nam.<br /> - Những tên sản phẩm, tên dịch vụ khác, logo và/ hoặc những tên công ty được sử dụng trong Website này là những tài sản đã được đăng ký độc quyền và được giữ bản quyền bởi những người sở hữu và/ hoặc người cấp phép tương ứng.</p>  <p style=\"text-align: right;\"><a href=\"#index\">Trở lại danh mục</a></p>  <h2><a id=\"4\" name=\"4\"></a>Các hành vi bị nghiêm cấm</h2>  <p>Người truy cập website này không được thực hiện những hành vi dưới đây khi sử dụng website:<br /> - Xâm phạm các quyền hợp pháp (bao gồm nhưng không giới hạn đối với các quyền riêng tư và chung) của người khác.<br /> - Gây ra sự thiệt hại hoặc bất lợi cho người khác.<br /> - Làm xáo trộn trật tự công cộng.<br /> - Hành vi liên quan đến tội phạm.<br /> - Tải lên hoặc phát tán thông tin riêng tư của tổ chức, cá nhân khác mà không được sự chấp thuận của họ.<br /> - Sử dụng Website này vào mục đích thương mại mà chưa được sự cho phép của chúng tôi.<br /> - Nói xấu, làm nhục, phỉ báng người khác.<br /> - Tải lên các tập tin chứa virus hoặc các tập tin bị hư mà có thể gây thiệt hại đến sự vận hành của máy tính khác.<br /> - Những hoạt động có khả năng ảnh hưởng đến hoạt động bình thường của website.<br /> - Những hoạt động mà chúng tôi cho là không thích hợp.<br /> - Những hoạt động bất hợp pháp hoặc bị cấm bởi pháp luật hiện hành.</p>  <p style=\"text-align: right;\"><a href=\"#index\">Trở lại danh mục</a></p>  <h2><a id=\"5\" name=\"5\"></a>Các đường liên kết đến các website khác</h2>  <p>- Các website của các bên thứ ba (không phải các trang do chúng tôi quản lý) được liên kết đến hoặc từ website này (&quot;Các website khác&quot;) được điều hành và duy trì hoàn toàn độc lập bởi các bên thứ ba đó và không nằm trong quyền điều khiển và/hoặc giám sát của chúng tôi. Việc truy cập các website khác phải được tuân thủ theo các điều khoản và điều kiện quy định bởi ban điều hành của website đó.<br /> - Chúng tôi không chịu trách nhiệm cho sự mất mát hoặc thiệt hại do việc truy cập và sử dụng các website bên ngoài, và bạn phải chịu mọi rủi ro khi truy cập các website đó.<br /> - Không có nội dung nào trong Website này thể hiện như một sự đảm bảo của chúng tôi về nội dung của các website khác và các sản phẩm và/ hoặc các dịch vụ xuất hiện và/ hoặc được cung cấp tại các website khác.</p>  <p style=\"text-align: right;\"><a href=\"#index\">Trở lại danh mục</a></p>  <h2><a id=\"6\" name=\"6\"></a>Từ chối bảo đảm</h2>  <p>NGOẠI TRỪ PHẠM VI BỊ CẤM THEO LUẬT PHÁP HIỆN HÀNH, CHÚNG TÔI SẼ:<br /> - KHÔNG CHỊU TRÁCH NHIỆM HAY BẢO ĐẢM, MỘT CÁCH RÕ RÀNG HAY NGỤ Ý, BAO GỒM SỰ BẢO ĐẢM VỀ TÍNH CHÍNH XÁC, MỨC ĐỘ TIN CẬY, HOÀN THIỆN, PHÙ HỢP CHO MỤC ĐÍCH CỤ THỂ, SỰ KHÔNG XÂM PHẠM QUYỀN CỦA BÊN THỨ 3 VÀ/HOẶC TÍNH AN TOÀN CỦA NỘI DỤNG WEBSITE NÀY, VÀ NHỮNG TUYÊN BỐ, ĐẢM BẢO CÓ LIÊN QUAN.<br /> - KHÔNG CHỊU TRÁCH NHIỆM CHO BẤT KỲ SỰ THIỆT HẠI HAY MẤT MÁT PHÁT SINH TỪ VIỆC TRUY CẬP VÀ SỬ DỤNG WEBSITE HAY VIỆC KHÔNG THỂ SỬ DỤNG WEBSITE.<br /> - CHÚNG TÔI CÓ THỂ THAY ĐỔI VÀ/HOẶC THAY THẾ NỘI DUNG CỦA WEBSITE NÀY, HOẶC TẠM HOÃN HOẶC NGƯNG CUNG CẤP CÁC DỊCH VỤ QUA WEBSITE NÀY VÀO BẤT KỲ THỜI ĐIỂM NÀO MÀ KHÔNG CẦN THÔNG BÁO TRƯỚC. CHÚNG TÔI SẼ KHÔNG CHỊU TRÁCH NHIỆM CHO BẤT CỨ THIỆT HẠI NÀO PHÁT SINH DO SỰ THAY ĐỔI HOẶC THAY THẾ NỘI DUNG CỦA WEBSITE.</p>  <p style=\"text-align: right;\"><a href=\"#index\">Trở lại danh mục</a></p>  <h2><a id=\"7\" name=\"7\"></a>Luật áp dụng và cơ quan giải quyết tranh chấp</h2>  <p>- Các Điều Khoản và Điều Kiện này được điều chỉnh và giải thích theo luật của Việt Nam trừ khi có điều khoản khác được cung cấp thêm. Tất cả tranh chấp phát sinh liên quan đến website này và các Điều Khoản và Điều Kiện sử dụng này sẽ được giải quyết tại các tòa án ở Việt Nam.<br /> - Nếu một phần nào đó của các Điều Khoản và Điều Kiện bị xem là không có giá trị, vô hiệu, hoặc không áp dụng được vì lý do nào đó, phần đó được xem như là phần riêng biệt và không ảnh hưởng đến tính hiệu lực của phần còn lại.<br /> - Trong trường hợp có sự mâu thuẫn giữa bản Tiếng Anh và bản Tiếng Việt của bản Điều Khoản và Điều Kiện này, bản Tiếng Việt sẽ được ưu tiên áp dụng.</p>  <p style=\"text-align: right;\"><a href=\"#index\">Trở lại danh mục</a></p>  <h2><a id=\"8\" name=\"8\"></a>Thay đổi điều khoản và điều kiện sử dụng</h2>  <div>Điều khoản và điều kiện sử dụng có thể thay đổi theo thời gian. Chúng tôi bảo lưu quyền thay đổi hoặc sửa đổi bất kỳ điều khoản và điều kiện cũng như các quy định khác, bất cứ lúc nào và theo ý mình. Chúng tôi sẽ có thông báo trên website khi có sự thay đổi. Tiếp tục sử dụng trang web này sau khi đăng các thay đổi tức là bạn đã chấp nhận các thay đổi đó. <p style=\"text-align: right;\"><a href=\"#index\">Trở lại danh mục</a></p> </div>', '', 0, '4', '', 2, 1, 1742685231, 1742685231, 1, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_vi_siteterms_config`
--

DROP TABLE IF EXISTS `nv5_vi_siteterms_config`;
CREATE TABLE `nv5_vi_siteterms_config` (
  `config_name` varchar(30) NOT NULL,
  `config_value` varchar(255) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_vi_siteterms_config`
--

INSERT INTO `nv5_vi_siteterms_config` (`config_name`, `config_value`) VALUES
('viewtype', '0'),
('facebookapi', ''),
('per_page', '20'),
('news_first', '0'),
('related_articles', '5'),
('copy_page', '0'),
('alias_lower', '1'),
('socialbutton', 'facebook,twitter');

-- --------------------------------------------------------

--
-- Table structure for table `nv5_vi_voting`
--

DROP TABLE IF EXISTS `nv5_vi_voting`;
CREATE TABLE `nv5_vi_voting` (
  `vid` smallint(5) UNSIGNED NOT NULL,
  `question` varchar(250) NOT NULL,
  `link` varchar(255) DEFAULT '',
  `acceptcm` int(2) NOT NULL DEFAULT 1,
  `active_captcha` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `admin_id` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `groups_view` varchar(255) DEFAULT '',
  `publ_time` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `exp_time` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `act` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `vote_one` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0 cho phép vote nhiều lần 1 cho phép vote 1 lần'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_vi_voting`
--

INSERT INTO `nv5_vi_voting` (`vid`, `question`, `link`, `acceptcm`, `active_captcha`, `admin_id`, `groups_view`, `publ_time`, `exp_time`, `act`, `vote_one`) VALUES
(2, 'Bạn biết gì về NukeViet 4?', '', 1, 0, 1, '6', 1742685231, 0, 1, 0),
(3, 'Lợi ích của phần mềm nguồn mở là gì?', '', 1, 0, 1, '6', 1742685231, 0, 1, 0);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_vi_voting_rows`
--

DROP TABLE IF EXISTS `nv5_vi_voting_rows`;
CREATE TABLE `nv5_vi_voting_rows` (
  `id` mediumint(8) UNSIGNED NOT NULL,
  `vid` smallint(5) UNSIGNED NOT NULL,
  `title` varchar(245) NOT NULL DEFAULT '',
  `url` varchar(255) DEFAULT '',
  `hitstotal` int(11) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nv5_vi_voting_rows`
--

INSERT INTO `nv5_vi_voting_rows` (`id`, `vid`, `title`, `url`, `hitstotal`) VALUES
(5, 2, 'Một bộ sourcecode cho web hoàn toàn mới.', '', 0),
(6, 2, 'Mã nguồn mở, sử dụng miễn phí.', '', 0),
(7, 2, 'Sử dụng HTML5, CSS3 và hỗ trợ Ajax', '', 0),
(8, 2, 'Tất cả các ý kiến trên', '', 0),
(9, 3, 'Liên tục được cải tiến, sửa đổi bởi cả thế giới.', '', 0),
(10, 3, 'Được sử dụng miễn phí không mất tiền.', '', 0),
(11, 3, 'Được tự do khám phá, sửa đổi theo ý thích.', '', 0),
(12, 3, 'Phù hợp để học tập, nghiên cứu vì được tự do sửa đổi theo ý thích.', '', 0),
(13, 3, 'Tất cả các ý kiến trên', '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `nv5_vi_voting_voted`
--

DROP TABLE IF EXISTS `nv5_vi_voting_voted`;
CREATE TABLE `nv5_vi_voting_voted` (
  `vid` smallint(5) UNSIGNED NOT NULL,
  `voted` text DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_zalo_article`
--

DROP TABLE IF EXISTS `nv5_zalo_article`;
CREATE TABLE `nv5_zalo_article` (
  `id` mediumint(8) NOT NULL,
  `zalo_id` char(100) NOT NULL DEFAULT '',
  `token` text NOT NULL,
  `type` char(10) NOT NULL DEFAULT '',
  `title` varchar(150) NOT NULL DEFAULT '',
  `author` char(50) NOT NULL DEFAULT '',
  `cover_type` char(20) NOT NULL DEFAULT '',
  `cover_photo_url` varchar(250) NOT NULL DEFAULT '',
  `cover_video_id` char(100) NOT NULL DEFAULT '',
  `cover_view` char(10) NOT NULL DEFAULT 'horizontal',
  `cover_status` char(10) NOT NULL DEFAULT 'hide',
  `description` text NOT NULL,
  `body` text NOT NULL,
  `related_medias` text NOT NULL,
  `tracking_link` varchar(250) NOT NULL DEFAULT '',
  `video_id` char(100) NOT NULL DEFAULT '',
  `video_avatar` varchar(250) NOT NULL DEFAULT '',
  `status` char(10) NOT NULL DEFAULT 'show',
  `comment` char(10) NOT NULL DEFAULT 'show',
  `create_date` int(11) NOT NULL DEFAULT 0,
  `update_date` int(11) NOT NULL DEFAULT 0,
  `total_view` int(11) NOT NULL DEFAULT 0,
  `total_share` int(11) NOT NULL DEFAULT 0,
  `is_sync` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_zalo_conversation`
--

DROP TABLE IF EXISTS `nv5_zalo_conversation`;
CREATE TABLE `nv5_zalo_conversation` (
  `message_id` char(50) NOT NULL,
  `user_id` char(30) NOT NULL,
  `src` tinyint(1) NOT NULL DEFAULT 0,
  `time` int(11) NOT NULL DEFAULT 0,
  `type` char(20) NOT NULL DEFAULT '',
  `message` text NOT NULL,
  `links` text NOT NULL,
  `thumb` varchar(250) NOT NULL DEFAULT '',
  `url` varchar(250) NOT NULL DEFAULT '',
  `description` text NOT NULL,
  `location` char(150) NOT NULL DEFAULT '',
  `note` text NOT NULL,
  `displayed` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_zalo_followers`
--

DROP TABLE IF EXISTS `nv5_zalo_followers`;
CREATE TABLE `nv5_zalo_followers` (
  `user_id` char(30) NOT NULL,
  `app_id` char(30) NOT NULL,
  `user_id_by_app` char(30) NOT NULL DEFAULT '',
  `display_name` varchar(250) NOT NULL DEFAULT '',
  `is_sensitive` tinyint(1) NOT NULL DEFAULT 0,
  `avatar120` varchar(250) NOT NULL DEFAULT '',
  `avatar240` varchar(250) NOT NULL DEFAULT '',
  `user_gender` char(1) NOT NULL DEFAULT '',
  `tags_info` text NOT NULL,
  `notes_info` text NOT NULL,
  `isfollow` tinyint(1) NOT NULL DEFAULT 1,
  `weight` mediumint(8) NOT NULL DEFAULT 0,
  `name` char(100) NOT NULL DEFAULT '',
  `phone_code` char(10) NOT NULL DEFAULT '',
  `phone_number` char(20) NOT NULL DEFAULT '',
  `address` varchar(250) NOT NULL DEFAULT '',
  `city_id` char(10) NOT NULL DEFAULT '',
  `district_id` char(10) NOT NULL DEFAULT '',
  `is_sync` tinyint(1) NOT NULL DEFAULT 0,
  `updatetime` int(11) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_zalo_settings`
--

DROP TABLE IF EXISTS `nv5_zalo_settings`;
CREATE TABLE `nv5_zalo_settings` (
  `skey` char(100) NOT NULL,
  `type` char(20) NOT NULL DEFAULT '',
  `svalue` text NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_zalo_tags`
--

DROP TABLE IF EXISTS `nv5_zalo_tags`;
CREATE TABLE `nv5_zalo_tags` (
  `alias` char(50) NOT NULL,
  `name` char(100) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_zalo_tags_follower`
--

DROP TABLE IF EXISTS `nv5_zalo_tags_follower`;
CREATE TABLE `nv5_zalo_tags_follower` (
  `tag` char(50) NOT NULL,
  `user_id` char(30) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_zalo_template`
--

DROP TABLE IF EXISTS `nv5_zalo_template`;
CREATE TABLE `nv5_zalo_template` (
  `id` smallint(4) NOT NULL,
  `type` char(10) NOT NULL,
  `content` text NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_zalo_upload`
--

DROP TABLE IF EXISTS `nv5_zalo_upload`;
CREATE TABLE `nv5_zalo_upload` (
  `id` tinyint(8) NOT NULL,
  `type` char(50) NOT NULL,
  `extension` char(10) NOT NULL,
  `file` varchar(250) NOT NULL,
  `localfile` varchar(250) NOT NULL DEFAULT '',
  `width` smallint(4) NOT NULL DEFAULT 0,
  `height` smallint(4) NOT NULL DEFAULT 0,
  `zalo_id` varchar(250) NOT NULL DEFAULT '',
  `description` varchar(250) NOT NULL DEFAULT '',
  `addtime` int(11) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nv5_zalo_video`
--

DROP TABLE IF EXISTS `nv5_zalo_video`;
CREATE TABLE `nv5_zalo_video` (
  `id` mediumint(8) NOT NULL,
  `video_id` char(100) NOT NULL DEFAULT '',
  `token` text NOT NULL,
  `video_name` char(100) NOT NULL DEFAULT '',
  `video_size` int(11) NOT NULL DEFAULT 0,
  `description` varchar(250) NOT NULL DEFAULT '',
  `view` char(10) NOT NULL DEFAULT 'horizontal',
  `thumb` varchar(250) NOT NULL DEFAULT '',
  `status` tinyint(1) NOT NULL DEFAULT 0,
  `status_message` char(100) NOT NULL DEFAULT '',
  `convert_percent` int(11) NOT NULL DEFAULT 0,
  `convert_error_code` int(11) NOT NULL DEFAULT 0,
  `addtime` int(11) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `nv5_api_role`
--
ALTER TABLE `nv5_api_role`
  ADD PRIMARY KEY (`role_id`),
  ADD UNIQUE KEY `role_md5title` (`role_md5title`);

--
-- Indexes for table `nv5_api_role_credential`
--
ALTER TABLE `nv5_api_role_credential`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `userid_role_id` (`userid`,`role_id`);

--
-- Indexes for table `nv5_api_role_logs`
--
ALTER TABLE `nv5_api_role_logs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `nv5_api_user`
--
ALTER TABLE `nv5_api_user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `userid_method` (`userid`,`method`),
  ADD UNIQUE KEY `ident` (`ident`),
  ADD UNIQUE KEY `secret` (`secret`);

--
-- Indexes for table `nv5_authors`
--
ALTER TABLE `nv5_authors`
  ADD PRIMARY KEY (`admin_id`);

--
-- Indexes for table `nv5_authors_config`
--
ALTER TABLE `nv5_authors_config`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `keyname` (`keyname`);

--
-- Indexes for table `nv5_authors_module`
--
ALTER TABLE `nv5_authors_module`
  ADD PRIMARY KEY (`mid`),
  ADD UNIQUE KEY `module` (`module`);

--
-- Indexes for table `nv5_authors_oauth`
--
ALTER TABLE `nv5_authors_oauth`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `admin_id` (`admin_id`,`oauth_server`,`oauth_uid`),
  ADD KEY `oauth_email` (`oauth_email`);

--
-- Indexes for table `nv5_authors_vars`
--
ALTER TABLE `nv5_authors_vars`
  ADD PRIMARY KEY (`id`),
  ADD KEY `admin_id` (`admin_id`),
  ADD KEY `lang` (`lang`),
  ADD KEY `theme` (`theme`),
  ADD KEY `config_name` (`config_name`),
  ADD KEY `weight` (`weight`);

--
-- Indexes for table `nv5_banners_click`
--
ALTER TABLE `nv5_banners_click`
  ADD PRIMARY KEY (`id`),
  ADD KEY `bid` (`bid`),
  ADD KEY `click_day` (`click_day`),
  ADD KEY `click_ip` (`click_ip`),
  ADD KEY `click_country` (`click_country`),
  ADD KEY `click_browse_key` (`click_browse_key`),
  ADD KEY `click_os_key` (`click_os_key`);

--
-- Indexes for table `nv5_banners_plans`
--
ALTER TABLE `nv5_banners_plans`
  ADD PRIMARY KEY (`id`),
  ADD KEY `title` (`title`);

--
-- Indexes for table `nv5_banners_rows`
--
ALTER TABLE `nv5_banners_rows`
  ADD PRIMARY KEY (`id`),
  ADD KEY `pid` (`pid`),
  ADD KEY `clid` (`clid`);

--
-- Indexes for table `nv5_config`
--
ALTER TABLE `nv5_config`
  ADD UNIQUE KEY `lang` (`lang`,`module`,`config_name`);

--
-- Indexes for table `nv5_cookies`
--
ALTER TABLE `nv5_cookies`
  ADD UNIQUE KEY `cookiename` (`name`,`domain`,`path`),
  ADD KEY `name` (`name`);

--
-- Indexes for table `nv5_counter`
--
ALTER TABLE `nv5_counter`
  ADD UNIQUE KEY `c_type` (`c_type`,`c_val`);

--
-- Indexes for table `nv5_cronjobs`
--
ALTER TABLE `nv5_cronjobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `is_sys` (`is_sys`);

--
-- Indexes for table `nv5_emailtemplates`
--
ALTER TABLE `nv5_emailtemplates`
  ADD PRIMARY KEY (`emailid`),
  ADD UNIQUE KEY `module_id` (`lang`,`module_name`,`id`),
  ADD KEY `lang` (`lang`),
  ADD KEY `module_file` (`module_file`),
  ADD KEY `catid` (`catid`),
  ADD KEY `time_add` (`time_add`),
  ADD KEY `time_update` (`time_update`),
  ADD KEY `vi_title` (`vi_title`);

--
-- Indexes for table `nv5_emailtemplates_categories`
--
ALTER TABLE `nv5_emailtemplates_categories`
  ADD PRIMARY KEY (`catid`),
  ADD UNIQUE KEY `vi_title` (`vi_title`(191)),
  ADD KEY `status` (`status`);

--
-- Indexes for table `nv5_extension_files`
--
ALTER TABLE `nv5_extension_files`
  ADD PRIMARY KEY (`idfile`);

--
-- Indexes for table `nv5_inform`
--
ALTER TABLE `nv5_inform`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `nv5_inform_status`
--
ALTER TABLE `nv5_inform_status`
  ADD UNIQUE KEY `pid_userid` (`pid`,`userid`);

--
-- Indexes for table `nv5_ips`
--
ALTER TABLE `nv5_ips`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ip` (`ip`,`type`);

--
-- Indexes for table `nv5_language`
--
ALTER TABLE `nv5_language`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `filelang` (`idfile`,`lang_key`,`langtype`);

--
-- Indexes for table `nv5_language_file`
--
ALTER TABLE `nv5_language_file`
  ADD PRIMARY KEY (`idfile`),
  ADD UNIQUE KEY `module` (`module`,`admin_file`);

--
-- Indexes for table `nv5_logs`
--
ALTER TABLE `nv5_logs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `nv5_notification`
--
ALTER TABLE `nv5_notification`
  ADD PRIMARY KEY (`id`),
  ADD KEY `send_to` (`send_to`),
  ADD KEY `admin_view_allowed` (`admin_view_allowed`),
  ADD KEY `logic_mode` (`logic_mode`);

--
-- Indexes for table `nv5_plugins`
--
ALTER TABLE `nv5_plugins`
  ADD PRIMARY KEY (`pid`),
  ADD UNIQUE KEY `plugin` (`plugin_lang`,`plugin_file`,`plugin_area`,`plugin_module_name`,`hook_module`);

--
-- Indexes for table `nv5_sessions`
--
ALTER TABLE `nv5_sessions`
  ADD UNIQUE KEY `session_id` (`session_id`),
  ADD KEY `onl_time` (`onl_time`);

--
-- Indexes for table `nv5_setup_extensions`
--
ALTER TABLE `nv5_setup_extensions`
  ADD UNIQUE KEY `title` (`type`,`title`),
  ADD KEY `id` (`id`),
  ADD KEY `type` (`type`);

--
-- Indexes for table `nv5_setup_language`
--
ALTER TABLE `nv5_setup_language`
  ADD PRIMARY KEY (`lang`);

--
-- Indexes for table `nv5_upload_dir`
--
ALTER TABLE `nv5_upload_dir`
  ADD PRIMARY KEY (`did`),
  ADD UNIQUE KEY `name` (`dirname`);

--
-- Indexes for table `nv5_upload_file`
--
ALTER TABLE `nv5_upload_file`
  ADD UNIQUE KEY `did` (`did`,`title`),
  ADD KEY `userid` (`userid`),
  ADD KEY `type` (`type`);

--
-- Indexes for table `nv5_users`
--
ALTER TABLE `nv5_users`
  ADD PRIMARY KEY (`userid`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `md5username` (`md5username`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idsite` (`idsite`);

--
-- Indexes for table `nv5_users_backupcodes`
--
ALTER TABLE `nv5_users_backupcodes`
  ADD UNIQUE KEY `userid` (`userid`,`code`);

--
-- Indexes for table `nv5_users_config`
--
ALTER TABLE `nv5_users_config`
  ADD PRIMARY KEY (`config`);

--
-- Indexes for table `nv5_users_edit`
--
ALTER TABLE `nv5_users_edit`
  ADD PRIMARY KEY (`userid`);

--
-- Indexes for table `nv5_users_field`
--
ALTER TABLE `nv5_users_field`
  ADD PRIMARY KEY (`fid`),
  ADD UNIQUE KEY `field` (`field`);

--
-- Indexes for table `nv5_users_groups`
--
ALTER TABLE `nv5_users_groups`
  ADD PRIMARY KEY (`group_id`),
  ADD UNIQUE KEY `kalias` (`alias`,`idsite`),
  ADD KEY `exp_time` (`exp_time`);

--
-- Indexes for table `nv5_users_groups_detail`
--
ALTER TABLE `nv5_users_groups_detail`
  ADD UNIQUE KEY `group_id_lang` (`lang`,`group_id`);

--
-- Indexes for table `nv5_users_groups_users`
--
ALTER TABLE `nv5_users_groups_users`
  ADD PRIMARY KEY (`group_id`,`userid`);

--
-- Indexes for table `nv5_users_info`
--
ALTER TABLE `nv5_users_info`
  ADD PRIMARY KEY (`userid`);

--
-- Indexes for table `nv5_users_login`
--
ALTER TABLE `nv5_users_login`
  ADD UNIQUE KEY `userid` (`userid`,`clid`);

--
-- Indexes for table `nv5_users_oldpass`
--
ALTER TABLE `nv5_users_oldpass`
  ADD UNIQUE KEY `pass_creation_time` (`userid`,`pass_creation_time`);

--
-- Indexes for table `nv5_users_openid`
--
ALTER TABLE `nv5_users_openid`
  ADD UNIQUE KEY `opid` (`openid`,`opid`),
  ADD KEY `userid` (`userid`),
  ADD KEY `email` (`email`);

--
-- Indexes for table `nv5_users_passkey`
--
ALTER TABLE `nv5_users_passkey`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uid` (`userid`,`keyid`),
  ADD UNIQUE KEY `userhandle` (`userhandle`);

--
-- Indexes for table `nv5_users_question`
--
ALTER TABLE `nv5_users_question`
  ADD PRIMARY KEY (`qid`),
  ADD UNIQUE KEY `title` (`title`,`lang`);

--
-- Indexes for table `nv5_users_reg`
--
ALTER TABLE `nv5_users_reg`
  ADD PRIMARY KEY (`userid`),
  ADD UNIQUE KEY `login` (`username`),
  ADD UNIQUE KEY `md5username` (`md5username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `nv5_vi_about`
--
ALTER TABLE `nv5_vi_about`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `alias` (`alias`);

--
-- Indexes for table `nv5_vi_about_config`
--
ALTER TABLE `nv5_vi_about_config`
  ADD UNIQUE KEY `config_name` (`config_name`);

--
-- Indexes for table `nv5_vi_blocks_groups`
--
ALTER TABLE `nv5_vi_blocks_groups`
  ADD PRIMARY KEY (`bid`),
  ADD KEY `theme` (`theme`),
  ADD KEY `module` (`module`),
  ADD KEY `position` (`position`);

--
-- Indexes for table `nv5_vi_blocks_weight`
--
ALTER TABLE `nv5_vi_blocks_weight`
  ADD UNIQUE KEY `bid` (`bid`,`func_id`);

--
-- Indexes for table `nv5_vi_comment`
--
ALTER TABLE `nv5_vi_comment`
  ADD PRIMARY KEY (`cid`),
  ADD KEY `mod_id` (`module`,`area`,`id`),
  ADD KEY `post_time` (`post_time`);

--
-- Indexes for table `nv5_vi_contact_department`
--
ALTER TABLE `nv5_vi_contact_department`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `full_name` (`full_name`),
  ADD UNIQUE KEY `alias` (`alias`);

--
-- Indexes for table `nv5_vi_contact_reply`
--
ALTER TABLE `nv5_vi_contact_reply`
  ADD PRIMARY KEY (`rid`),
  ADD KEY `id` (`id`);

--
-- Indexes for table `nv5_vi_contact_send`
--
ALTER TABLE `nv5_vi_contact_send`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sender_name` (`sender_name`);

--
-- Indexes for table `nv5_vi_contact_supporter`
--
ALTER TABLE `nv5_vi_contact_supporter`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `nv5_vi_freecontent_blocks`
--
ALTER TABLE `nv5_vi_freecontent_blocks`
  ADD PRIMARY KEY (`bid`);

--
-- Indexes for table `nv5_vi_freecontent_rows`
--
ALTER TABLE `nv5_vi_freecontent_rows`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `nv5_vi_menu`
--
ALTER TABLE `nv5_vi_menu`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `title` (`title`);

--
-- Indexes for table `nv5_vi_menu_rows`
--
ALTER TABLE `nv5_vi_menu_rows`
  ADD PRIMARY KEY (`id`),
  ADD KEY `parentid` (`parentid`,`mid`);

--
-- Indexes for table `nv5_vi_modfuncs`
--
ALTER TABLE `nv5_vi_modfuncs`
  ADD PRIMARY KEY (`func_id`),
  ADD UNIQUE KEY `func_name` (`func_name`,`in_module`),
  ADD UNIQUE KEY `alias` (`alias`,`in_module`);

--
-- Indexes for table `nv5_vi_modthemes`
--
ALTER TABLE `nv5_vi_modthemes`
  ADD UNIQUE KEY `func_id` (`func_id`,`layout`,`theme`);

--
-- Indexes for table `nv5_vi_modules`
--
ALTER TABLE `nv5_vi_modules`
  ADD PRIMARY KEY (`title`);

--
-- Indexes for table `nv5_vi_nas_api_credentials`
--
ALTER TABLE `nv5_vi_nas_api_credentials`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `crid1` (`userid`,`title`),
  ADD KEY `userid` (`userid`),
  ADD KEY `title` (`title`),
  ADD KEY `is_setup` (`is_setup`),
  ADD KEY `is_error` (`is_error`);

--
-- Indexes for table `nv5_vi_nas_nodes`
--
ALTER TABLE `nv5_vi_nas_nodes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `parentid` (`parentid`),
  ADD KEY `parentids` (`parentids`),
  ADD KEY `node_type` (`node_type`),
  ADD KEY `add_time` (`add_time`),
  ADD KEY `edit_time` (`edit_time`),
  ADD KEY `rename_time` (`rename_time`),
  ADD KEY `title` (`title`),
  ADD KEY `alias` (`alias`),
  ADD KEY `weight` (`weight`),
  ADD KEY `sort` (`sort`),
  ADD KEY `trash` (`trash`),
  ADD KEY `trash_parent` (`trash_parent`),
  ADD KEY `bookmarked` (`bookmarked`),
  ADD KEY `shared_users` (`shared_users`),
  ADD KEY `shared_groups` (`shared_groups`),
  ADD KEY `node_ext` (`node_ext`),
  ADD KEY `is_tmp` (`is_tmp`),
  ADD KEY `id_tmp` (`is_tmp`,`uniqid`),
  ADD KEY `lev` (`lev`),
  ADD KEY `sync_appid` (`sync_appid`),
  ADD KEY `sync_folderid` (`sync_folderid`),
  ADD KEY `sync_lastime` (`sync_lastime`),
  ADD KEY `sync_iserror` (`sync_iserror`),
  ADD KEY `sync_disabled` (`sync_disabled`),
  ADD KEY `process_time` (`process_time`),
  ADD KEY `zoned_time` (`zoned_time`);

--
-- Indexes for table `nv5_vi_nas_nodes_refs`
--
ALTER TABLE `nv5_vi_nas_nodes_refs`
  ADD PRIMARY KEY (`node_id`),
  ADD KEY `node_id` (`node_id`);

--
-- Indexes for table `nv5_vi_nas_users`
--
ALTER TABLE `nv5_vi_nas_users`
  ADD PRIMARY KEY (`userid`),
  ADD KEY `add_time` (`add_time`),
  ADD KEY `status` (`status`);

--
-- Indexes for table `nv5_vi_nas_users_config`
--
ALTER TABLE `nv5_vi_nas_users_config`
  ADD UNIQUE KEY `config_name` (`userid`,`config_name`),
  ADD KEY `userid` (`userid`);

--
-- Indexes for table `nv5_vi_nas_users_notices`
--
ALTER TABLE `nv5_vi_nas_users_notices`
  ADD PRIMARY KEY (`id`),
  ADD KEY `userid` (`userid`),
  ADD KEY `channel` (`channel`),
  ADD KEY `notice_key` (`notice_key`),
  ADD KEY `notice_time` (`notice_time`),
  ADD KEY `send_time` (`send_time`);

--
-- Indexes for table `nv5_vi_news_1`
--
ALTER TABLE `nv5_vi_news_1`
  ADD PRIMARY KEY (`id`),
  ADD KEY `catid` (`catid`),
  ADD KEY `topicid` (`topicid`),
  ADD KEY `admin_id` (`admin_id`),
  ADD KEY `author` (`author`),
  ADD KEY `title` (`title`),
  ADD KEY `addtime` (`addtime`),
  ADD KEY `edittime` (`edittime`),
  ADD KEY `publtime` (`publtime`),
  ADD KEY `exptime` (`exptime`),
  ADD KEY `status` (`status`),
  ADD KEY `instant_active` (`instant_active`),
  ADD KEY `instant_creatauto` (`instant_creatauto`);

--
-- Indexes for table `nv5_vi_news_2`
--
ALTER TABLE `nv5_vi_news_2`
  ADD PRIMARY KEY (`id`),
  ADD KEY `catid` (`catid`),
  ADD KEY `topicid` (`topicid`),
  ADD KEY `admin_id` (`admin_id`),
  ADD KEY `author` (`author`),
  ADD KEY `title` (`title`),
  ADD KEY `addtime` (`addtime`),
  ADD KEY `edittime` (`edittime`),
  ADD KEY `publtime` (`publtime`),
  ADD KEY `exptime` (`exptime`),
  ADD KEY `status` (`status`),
  ADD KEY `instant_active` (`instant_active`),
  ADD KEY `instant_creatauto` (`instant_creatauto`);

--
-- Indexes for table `nv5_vi_news_3`
--
ALTER TABLE `nv5_vi_news_3`
  ADD PRIMARY KEY (`id`),
  ADD KEY `catid` (`catid`),
  ADD KEY `topicid` (`topicid`),
  ADD KEY `admin_id` (`admin_id`),
  ADD KEY `author` (`author`),
  ADD KEY `title` (`title`),
  ADD KEY `addtime` (`addtime`),
  ADD KEY `edittime` (`edittime`),
  ADD KEY `publtime` (`publtime`),
  ADD KEY `exptime` (`exptime`),
  ADD KEY `status` (`status`),
  ADD KEY `instant_active` (`instant_active`),
  ADD KEY `instant_creatauto` (`instant_creatauto`);

--
-- Indexes for table `nv5_vi_news_4`
--
ALTER TABLE `nv5_vi_news_4`
  ADD PRIMARY KEY (`id`),
  ADD KEY `catid` (`catid`),
  ADD KEY `topicid` (`topicid`),
  ADD KEY `admin_id` (`admin_id`),
  ADD KEY `author` (`author`),
  ADD KEY `title` (`title`),
  ADD KEY `addtime` (`addtime`),
  ADD KEY `edittime` (`edittime`),
  ADD KEY `publtime` (`publtime`),
  ADD KEY `exptime` (`exptime`),
  ADD KEY `status` (`status`),
  ADD KEY `instant_active` (`instant_active`),
  ADD KEY `instant_creatauto` (`instant_creatauto`);

--
-- Indexes for table `nv5_vi_news_5`
--
ALTER TABLE `nv5_vi_news_5`
  ADD PRIMARY KEY (`id`),
  ADD KEY `catid` (`catid`),
  ADD KEY `topicid` (`topicid`),
  ADD KEY `admin_id` (`admin_id`),
  ADD KEY `author` (`author`),
  ADD KEY `title` (`title`),
  ADD KEY `addtime` (`addtime`),
  ADD KEY `edittime` (`edittime`),
  ADD KEY `publtime` (`publtime`),
  ADD KEY `exptime` (`exptime`),
  ADD KEY `status` (`status`),
  ADD KEY `instant_active` (`instant_active`),
  ADD KEY `instant_creatauto` (`instant_creatauto`);

--
-- Indexes for table `nv5_vi_news_6`
--
ALTER TABLE `nv5_vi_news_6`
  ADD PRIMARY KEY (`id`),
  ADD KEY `catid` (`catid`),
  ADD KEY `topicid` (`topicid`),
  ADD KEY `admin_id` (`admin_id`),
  ADD KEY `author` (`author`),
  ADD KEY `title` (`title`),
  ADD KEY `addtime` (`addtime`),
  ADD KEY `edittime` (`edittime`),
  ADD KEY `publtime` (`publtime`),
  ADD KEY `exptime` (`exptime`),
  ADD KEY `status` (`status`),
  ADD KEY `instant_active` (`instant_active`),
  ADD KEY `instant_creatauto` (`instant_creatauto`);

--
-- Indexes for table `nv5_vi_news_7`
--
ALTER TABLE `nv5_vi_news_7`
  ADD PRIMARY KEY (`id`),
  ADD KEY `catid` (`catid`),
  ADD KEY `topicid` (`topicid`),
  ADD KEY `admin_id` (`admin_id`),
  ADD KEY `author` (`author`),
  ADD KEY `title` (`title`),
  ADD KEY `addtime` (`addtime`),
  ADD KEY `edittime` (`edittime`),
  ADD KEY `publtime` (`publtime`),
  ADD KEY `exptime` (`exptime`),
  ADD KEY `status` (`status`),
  ADD KEY `instant_active` (`instant_active`),
  ADD KEY `instant_creatauto` (`instant_creatauto`);

--
-- Indexes for table `nv5_vi_news_admins`
--
ALTER TABLE `nv5_vi_news_admins`
  ADD UNIQUE KEY `userid` (`userid`,`catid`);

--
-- Indexes for table `nv5_vi_news_author`
--
ALTER TABLE `nv5_vi_news_author`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uid` (`uid`),
  ADD UNIQUE KEY `alias` (`alias`);

--
-- Indexes for table `nv5_vi_news_authorlist`
--
ALTER TABLE `nv5_vi_news_authorlist`
  ADD UNIQUE KEY `id_aid` (`id`,`aid`),
  ADD KEY `aid` (`aid`),
  ADD KEY `alias` (`alias`);

--
-- Indexes for table `nv5_vi_news_block`
--
ALTER TABLE `nv5_vi_news_block`
  ADD UNIQUE KEY `bid` (`bid`,`id`);

--
-- Indexes for table `nv5_vi_news_block_cat`
--
ALTER TABLE `nv5_vi_news_block_cat`
  ADD PRIMARY KEY (`bid`),
  ADD UNIQUE KEY `title` (`title`),
  ADD UNIQUE KEY `alias` (`alias`);

--
-- Indexes for table `nv5_vi_news_cat`
--
ALTER TABLE `nv5_vi_news_cat`
  ADD PRIMARY KEY (`catid`),
  ADD UNIQUE KEY `alias` (`alias`),
  ADD KEY `parentid` (`parentid`),
  ADD KEY `status` (`status`);

--
-- Indexes for table `nv5_vi_news_config_post`
--
ALTER TABLE `nv5_vi_news_config_post`
  ADD PRIMARY KEY (`group_id`);

--
-- Indexes for table `nv5_vi_news_detail`
--
ALTER TABLE `nv5_vi_news_detail`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `nv5_vi_news_logs`
--
ALTER TABLE `nv5_vi_news_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sid` (`sid`),
  ADD KEY `log_key` (`log_key`),
  ADD KEY `status` (`status`),
  ADD KEY `userid` (`userid`);

--
-- Indexes for table `nv5_vi_news_report`
--
ALTER TABLE `nv5_vi_news_report`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `newsid_md5content_post_ip` (`newsid`,`md5content`,`post_ip`);

--
-- Indexes for table `nv5_vi_news_rows`
--
ALTER TABLE `nv5_vi_news_rows`
  ADD PRIMARY KEY (`id`),
  ADD KEY `catid` (`catid`),
  ADD KEY `topicid` (`topicid`),
  ADD KEY `admin_id` (`admin_id`),
  ADD KEY `author` (`author`),
  ADD KEY `title` (`title`),
  ADD KEY `addtime` (`addtime`),
  ADD KEY `edittime` (`edittime`),
  ADD KEY `publtime` (`publtime`),
  ADD KEY `exptime` (`exptime`),
  ADD KEY `status` (`status`),
  ADD KEY `instant_active` (`instant_active`),
  ADD KEY `instant_creatauto` (`instant_creatauto`);

--
-- Indexes for table `nv5_vi_news_row_histories`
--
ALTER TABLE `nv5_vi_news_row_histories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `new_id` (`new_id`),
  ADD KEY `historytime` (`historytime`),
  ADD KEY `admin_id` (`admin_id`);

--
-- Indexes for table `nv5_vi_news_sources`
--
ALTER TABLE `nv5_vi_news_sources`
  ADD PRIMARY KEY (`sourceid`),
  ADD UNIQUE KEY `title` (`title`);

--
-- Indexes for table `nv5_vi_news_tags`
--
ALTER TABLE `nv5_vi_news_tags`
  ADD PRIMARY KEY (`tid`),
  ADD UNIQUE KEY `alias` (`alias`);

--
-- Indexes for table `nv5_vi_news_tags_id`
--
ALTER TABLE `nv5_vi_news_tags_id`
  ADD UNIQUE KEY `id_tid` (`id`,`tid`),
  ADD KEY `tid` (`tid`);

--
-- Indexes for table `nv5_vi_news_tmp`
--
ALTER TABLE `nv5_vi_news_tmp`
  ADD PRIMARY KEY (`id`),
  ADD KEY `tmp_id` (`new_id`,`type`,`admin_id`),
  ADD KEY `draft_id` (`admin_id`,`type`),
  ADD KEY `uuid` (`uuid`);

--
-- Indexes for table `nv5_vi_news_topics`
--
ALTER TABLE `nv5_vi_news_topics`
  ADD PRIMARY KEY (`topicid`),
  ADD UNIQUE KEY `title` (`title`),
  ADD UNIQUE KEY `alias` (`alias`);

--
-- Indexes for table `nv5_vi_news_voices`
--
ALTER TABLE `nv5_vi_news_voices`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `title` (`title`),
  ADD KEY `weight` (`weight`),
  ADD KEY `status` (`status`);

--
-- Indexes for table `nv5_vi_page`
--
ALTER TABLE `nv5_vi_page`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `alias` (`alias`);

--
-- Indexes for table `nv5_vi_page_config`
--
ALTER TABLE `nv5_vi_page_config`
  ADD UNIQUE KEY `config_name` (`config_name`);

--
-- Indexes for table `nv5_vi_referer_stats`
--
ALTER TABLE `nv5_vi_referer_stats`
  ADD UNIQUE KEY `host` (`host`),
  ADD KEY `total` (`total`);

--
-- Indexes for table `nv5_vi_searchkeys`
--
ALTER TABLE `nv5_vi_searchkeys`
  ADD KEY `id` (`id`),
  ADD KEY `skey` (`skey`),
  ADD KEY `search_engine` (`search_engine`);

--
-- Indexes for table `nv5_vi_siteterms`
--
ALTER TABLE `nv5_vi_siteterms`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `alias` (`alias`);

--
-- Indexes for table `nv5_vi_siteterms_config`
--
ALTER TABLE `nv5_vi_siteterms_config`
  ADD UNIQUE KEY `config_name` (`config_name`);

--
-- Indexes for table `nv5_vi_voting`
--
ALTER TABLE `nv5_vi_voting`
  ADD PRIMARY KEY (`vid`),
  ADD UNIQUE KEY `question` (`question`);

--
-- Indexes for table `nv5_vi_voting_rows`
--
ALTER TABLE `nv5_vi_voting_rows`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `vid` (`vid`,`title`);

--
-- Indexes for table `nv5_vi_voting_voted`
--
ALTER TABLE `nv5_vi_voting_voted`
  ADD UNIQUE KEY `vid` (`vid`);

--
-- Indexes for table `nv5_zalo_article`
--
ALTER TABLE `nv5_zalo_article`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `zalo_id` (`zalo_id`),
  ADD KEY `is_sync` (`is_sync`);

--
-- Indexes for table `nv5_zalo_conversation`
--
ALTER TABLE `nv5_zalo_conversation`
  ADD PRIMARY KEY (`message_id`);

--
-- Indexes for table `nv5_zalo_followers`
--
ALTER TABLE `nv5_zalo_followers`
  ADD UNIQUE KEY `user_id` (`user_id`);

--
-- Indexes for table `nv5_zalo_settings`
--
ALTER TABLE `nv5_zalo_settings`
  ADD UNIQUE KEY `info_key` (`skey`,`type`);

--
-- Indexes for table `nv5_zalo_tags`
--
ALTER TABLE `nv5_zalo_tags`
  ADD UNIQUE KEY `alias` (`alias`);

--
-- Indexes for table `nv5_zalo_tags_follower`
--
ALTER TABLE `nv5_zalo_tags_follower`
  ADD UNIQUE KEY `tag` (`tag`,`user_id`);

--
-- Indexes for table `nv5_zalo_template`
--
ALTER TABLE `nv5_zalo_template`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `nv5_zalo_upload`
--
ALTER TABLE `nv5_zalo_upload`
  ADD PRIMARY KEY (`id`),
  ADD KEY `type` (`type`);

--
-- Indexes for table `nv5_zalo_video`
--
ALTER TABLE `nv5_zalo_video`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `nv5_api_role`
--
ALTER TABLE `nv5_api_role`
  MODIFY `role_id` smallint(4) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_api_role_credential`
--
ALTER TABLE `nv5_api_role_credential`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_api_role_logs`
--
ALTER TABLE `nv5_api_role_logs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_api_user`
--
ALTER TABLE `nv5_api_user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_authors_config`
--
ALTER TABLE `nv5_authors_config`
  MODIFY `id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_authors_module`
--
ALTER TABLE `nv5_authors_module`
  MODIFY `mid` mediumint(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `nv5_authors_oauth`
--
ALTER TABLE `nv5_authors_oauth`
  MODIFY `id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_authors_vars`
--
ALTER TABLE `nv5_authors_vars`
  MODIFY `id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_banners_click`
--
ALTER TABLE `nv5_banners_click`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_banners_plans`
--
ALTER TABLE `nv5_banners_plans`
  MODIFY `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `nv5_banners_rows`
--
ALTER TABLE `nv5_banners_rows`
  MODIFY `id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `nv5_cronjobs`
--
ALTER TABLE `nv5_cronjobs`
  MODIFY `id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `nv5_emailtemplates`
--
ALTER TABLE `nv5_emailtemplates`
  MODIFY `emailid` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1037;

--
-- AUTO_INCREMENT for table `nv5_emailtemplates_categories`
--
ALTER TABLE `nv5_emailtemplates_categories`
  MODIFY `catid` smallint(4) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=101;

--
-- AUTO_INCREMENT for table `nv5_extension_files`
--
ALTER TABLE `nv5_extension_files`
  MODIFY `idfile` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_inform`
--
ALTER TABLE `nv5_inform`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_ips`
--
ALTER TABLE `nv5_ips`
  MODIFY `id` mediumint(8) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_language`
--
ALTER TABLE `nv5_language`
  MODIFY `id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_language_file`
--
ALTER TABLE `nv5_language_file`
  MODIFY `idfile` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_logs`
--
ALTER TABLE `nv5_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `nv5_notification`
--
ALTER TABLE `nv5_notification`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_plugins`
--
ALTER TABLE `nv5_plugins`
  MODIFY `pid` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1001;

--
-- AUTO_INCREMENT for table `nv5_upload_dir`
--
ALTER TABLE `nv5_upload_dir`
  MODIFY `did` mediumint(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `nv5_users`
--
ALTER TABLE `nv5_users`
  MODIFY `userid` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `nv5_users_backupcodes`
--
ALTER TABLE `nv5_users_backupcodes`
  MODIFY `userid` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_users_field`
--
ALTER TABLE `nv5_users_field`
  MODIFY `fid` mediumint(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `nv5_users_groups`
--
ALTER TABLE `nv5_users_groups`
  MODIFY `group_id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `nv5_users_passkey`
--
ALTER TABLE `nv5_users_passkey`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_users_question`
--
ALTER TABLE `nv5_users_question`
  MODIFY `qid` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `nv5_users_reg`
--
ALTER TABLE `nv5_users_reg`
  MODIFY `userid` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_vi_about`
--
ALTER TABLE `nv5_vi_about`
  MODIFY `id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `nv5_vi_blocks_groups`
--
ALTER TABLE `nv5_vi_blocks_groups`
  MODIFY `bid` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT for table `nv5_vi_comment`
--
ALTER TABLE `nv5_vi_comment`
  MODIFY `cid` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_vi_contact_department`
--
ALTER TABLE `nv5_vi_contact_department`
  MODIFY `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `nv5_vi_contact_reply`
--
ALTER TABLE `nv5_vi_contact_reply`
  MODIFY `rid` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_vi_contact_send`
--
ALTER TABLE `nv5_vi_contact_send`
  MODIFY `id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_vi_contact_supporter`
--
ALTER TABLE `nv5_vi_contact_supporter`
  MODIFY `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_vi_freecontent_blocks`
--
ALTER TABLE `nv5_vi_freecontent_blocks`
  MODIFY `bid` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `nv5_vi_freecontent_rows`
--
ALTER TABLE `nv5_vi_freecontent_rows`
  MODIFY `id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `nv5_vi_menu`
--
ALTER TABLE `nv5_vi_menu`
  MODIFY `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `nv5_vi_menu_rows`
--
ALTER TABLE `nv5_vi_menu_rows`
  MODIFY `id` mediumint(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `nv5_vi_modfuncs`
--
ALTER TABLE `nv5_vi_modfuncs`
  MODIFY `func_id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=76;

--
-- AUTO_INCREMENT for table `nv5_vi_nas_api_credentials`
--
ALTER TABLE `nv5_vi_nas_api_credentials`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID tự tăng';

--
-- AUTO_INCREMENT for table `nv5_vi_nas_nodes`
--
ALTER TABLE `nv5_vi_nas_nodes`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID node', AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `nv5_vi_nas_users`
--
ALTER TABLE `nv5_vi_nas_users`
  MODIFY `userid` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID người dùng', AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `nv5_vi_nas_users_notices`
--
ALTER TABLE `nv5_vi_nas_users_notices`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID tự tăng';

--
-- AUTO_INCREMENT for table `nv5_vi_news_1`
--
ALTER TABLE `nv5_vi_news_1`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `nv5_vi_news_2`
--
ALTER TABLE `nv5_vi_news_2`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `nv5_vi_news_3`
--
ALTER TABLE `nv5_vi_news_3`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `nv5_vi_news_4`
--
ALTER TABLE `nv5_vi_news_4`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `nv5_vi_news_5`
--
ALTER TABLE `nv5_vi_news_5`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `nv5_vi_news_6`
--
ALTER TABLE `nv5_vi_news_6`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `nv5_vi_news_7`
--
ALTER TABLE `nv5_vi_news_7`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `nv5_vi_news_author`
--
ALTER TABLE `nv5_vi_news_author`
  MODIFY `id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_vi_news_block_cat`
--
ALTER TABLE `nv5_vi_news_block_cat`
  MODIFY `bid` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `nv5_vi_news_cat`
--
ALTER TABLE `nv5_vi_news_cat`
  MODIFY `catid` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `nv5_vi_news_logs`
--
ALTER TABLE `nv5_vi_news_logs`
  MODIFY `id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_vi_news_report`
--
ALTER TABLE `nv5_vi_news_report`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_vi_news_rows`
--
ALTER TABLE `nv5_vi_news_rows`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `nv5_vi_news_row_histories`
--
ALTER TABLE `nv5_vi_news_row_histories`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_vi_news_sources`
--
ALTER TABLE `nv5_vi_news_sources`
  MODIFY `sourceid` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `nv5_vi_news_tags`
--
ALTER TABLE `nv5_vi_news_tags`
  MODIFY `tid` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT for table `nv5_vi_news_tmp`
--
ALTER TABLE `nv5_vi_news_tmp`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_vi_news_topics`
--
ALTER TABLE `nv5_vi_news_topics`
  MODIFY `topicid` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `nv5_vi_news_voices`
--
ALTER TABLE `nv5_vi_news_voices`
  MODIFY `id` smallint(4) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_vi_page`
--
ALTER TABLE `nv5_vi_page`
  MODIFY `id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_vi_siteterms`
--
ALTER TABLE `nv5_vi_siteterms`
  MODIFY `id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `nv5_vi_voting`
--
ALTER TABLE `nv5_vi_voting`
  MODIFY `vid` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `nv5_vi_voting_rows`
--
ALTER TABLE `nv5_vi_voting_rows`
  MODIFY `id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `nv5_zalo_article`
--
ALTER TABLE `nv5_zalo_article`
  MODIFY `id` mediumint(8) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_zalo_template`
--
ALTER TABLE `nv5_zalo_template`
  MODIFY `id` smallint(4) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_zalo_upload`
--
ALTER TABLE `nv5_zalo_upload`
  MODIFY `id` tinyint(8) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nv5_zalo_video`
--
ALTER TABLE `nv5_zalo_video`
  MODIFY `id` mediumint(8) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
