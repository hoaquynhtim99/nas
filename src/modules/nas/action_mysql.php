<?php

/**
 * NukeViet Content Management System
 * @version 4.x
 * @author VINADES.,JSC <contact@vinades.vn>
 * @copyright (C) 2009-2021 VINADES.,JSC. All rights reserved
 * @license GNU/GPL version 2 or any later version
 * @see https://github.com/nukeviet The NukeViet CMS GitHub project
 */

if (!defined('NV_IS_FILE_MODULES')) {
    exit('Stop!!!');
}

$sql_drop_module = [];

$sql_drop_module[] = "DROP TABLE IF EXISTS " . $db_config['prefix'] . "_" . $lang . "_" . $module_data . "_users";
$sql_drop_module[] = "DROP TABLE IF EXISTS " . $db_config['prefix'] . "_" . $lang . "_" . $module_data . "_users_config";
$sql_drop_module[] = "DROP TABLE IF EXISTS " . $db_config['prefix'] . "_" . $lang . "_" . $module_data . "_users_notices";
$sql_drop_module[] = "DROP TABLE IF EXISTS " . $db_config['prefix'] . "_" . $lang . "_" . $module_data . "_nodes";
$sql_drop_module[] = "DROP TABLE IF EXISTS " . $db_config['prefix'] . "_" . $lang . "_" . $module_data . "_nodes_refs";
$sql_drop_module[] = "DROP TABLE IF EXISTS " . $db_config['prefix'] . "_" . $lang . "_" . $module_data . "_api_credentials";

$sql_create_module = $sql_drop_module;

// Danh sách người dùng
$sql_create_module[] = "CREATE TABLE " . $db_config['prefix'] . "_" . $lang . "_" . $module_data . "_users (
  userid int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID người dùng',
  add_time int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'Thời gian thêm',
  edit_time int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'Thời gian sửa',
  quota_limit bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT 'Hạn ngạch bằng bytes. 0 là không giới hạn',
  quota_current bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT 'Dung lượng hiện đang sử dụng',
  last_activity int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'Hoạt động gần đây lúc',
  last_ip int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'IP cho hoạt động gần đây',
  status tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Trạng thái 1 bật 0 tắt',
  PRIMARY KEY (userid),
  KEY add_time (add_time),
  KEY status (status)
) ENGINE=InnoDB COMMENT 'Danh sách người dùng'";

// Danh sách tập tin, thư mục
$sql_create_module[] = "CREATE TABLE " . $db_config['prefix'] . "_" . $lang . "_" . $module_data . "_nodes (
  id int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID node',
  parentid int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'ID thư mục cha',
  parentids varchar(250) NOT NULL DEFAULT '' COMMENT 'Lưu danh sách thư mục cha của nó tính ra bên ngoài',
  userid int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'Sở hữu của ai',
  node_type tinyint(1) NOT NULL DEFAULT '0' COMMENT '0: File, 1: Thư mục',
  add_time int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'Thời gian thêm',
  edit_time int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'Thời gian sửa',
  rename_time int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'Thời gian sửa tên',
  title varchar(200) NOT NULL DEFAULT '' COMMENT 'Tên thật',
  alias varchar(200) NOT NULL DEFAULT '' COMMENT 'Tên thư mục, tên file',
  path varchar(2000) NOT NULL DEFAULT '' COMMENT 'Đường dẫn đến tập tin, thư mục tính từ thư mục user',
  weight int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'Thứ tự trong cùng một cấp (thường xếp theo tên)',
  sort int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'Thứ tự toàn bộ',
  lev int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'Thư mục cấp mấy, cấp cha thì=0',
  numsubcat int(11) NOT NULL DEFAULT '0' COMMENT 'Số item con trong nó',
  subcatid varchar(1000) NOT NULL DEFAULT '' COMMENT 'ID item con cấp liền kề của nó phân cách bởi dấu phảy',
  subcatids varchar(5000) NOT NULL DEFAULT '' COMMENT 'ID item con tất cả các cấp của nó phân cách bởi dấu phảy',
  node_size bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT 'Dung lượng tập tin',
  duration int(11) NOT NULL DEFAULT '0' COMMENT 'Thời lượng video',
  node_mime varchar(200) NOT NULL DEFAULT '' COMMENT 'Mine tập tin',
  node_ext varchar(50) NOT NULL DEFAULT '' COMMENT 'Đuôi tập tin',
  properties text NULL DEFAULT NULL COMMENT 'Json cấu hình',
  image_width smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT 'Chiều rộng ảnh',
  image_height smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT 'Chiều cao ảnh',
  thumb tinyint(1) NOT NULL DEFAULT '0' COMMENT '0: Không có ảnh đại diện, 1: Ảnh đại diện chính là path của file',
  bookmarked int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'Thời gian đánh dấu',
  shared_users varchar(250) NOT NULL DEFAULT '' COMMENT 'Chia sẻ cho người dùng khác',
  shared_groups varchar(250) NOT NULL DEFAULT '' COMMENT 'Chia sẻ cho nhóm khác',
  trash int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'Thời gian xóa',
  trash_parent tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 là bị xóa bởi thư mục cha của nó',
  is_tmp int(11) unsigned NOT NULL DEFAULT '0' COMMENT '0 là file hoàn tất >0 là file đang trong quá trình upload',
  uniqid varchar(32) NOT NULL DEFAULT '' COMMENT 'Key kiểm tra file duy nhất trong quá trình upload',
  sync_appid int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'ID app đồng bộ',
  sync_folderid varchar(50) NOT NULL DEFAULT '' COMMENT 'ID thư mục đồng bộ hoặc ID đã đồng bộ lên với file',
  sync_lastime int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'Lần đồng bộ gần đây',
  sync_iserror int(11) unsigned NOT NULL DEFAULT '0' COMMENT '0 là không lỗi, >0 là thời gian lỗi',
  sync_disabled tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Thư mục cha bật đồng bộ thì set cái này lên 1 của thư mục con => Không cho nó đồng bộ',
  process_time bigint(20) NOT NULL DEFAULT '0' COMMENT 'Xử lý node: 0 là chưa xử lý, >0 thời gian xử lý thành công, <0 thời gian xử lý thất bại',
  zoned_time int(11) NOT NULL DEFAULT '0' COMMENT '0 không chia sẻ, -1 vĩnh viễn, >0 hết hạn lúc',
  PRIMARY KEY (id),
  KEY parentid (parentid),
  KEY parentids (parentids),
  KEY node_type (node_type),
  KEY add_time (add_time),
  KEY edit_time (edit_time),
  KEY rename_time (rename_time),
  KEY title (title),
  KEY alias (alias),
  KEY weight (weight),
  KEY sort (sort),
  KEY trash (trash),
  KEY trash_parent (trash_parent),
  KEY bookmarked (bookmarked),
  KEY shared_users (shared_users),
  KEY shared_groups (shared_groups),
  KEY node_ext (node_ext),
  KEY is_tmp (is_tmp),
  KEY id_tmp (is_tmp, uniqid),
  KEY lev (lev),
  KEY sync_appid (sync_appid),
  KEY sync_folderid (sync_folderid),
  KEY sync_lastime (sync_lastime),
  KEY sync_iserror (sync_iserror),
  KEY sync_disabled (sync_disabled),
  KEY process_time (process_time),
  KEY zoned_time (zoned_time)
) ENGINE=InnoDB COMMENT 'Danh sách tập tin, thư mục'";

// Các trường mở rộng của tệp tin, thư mục
$sql_create_module[] = "CREATE TABLE " . $db_config['prefix'] . "_" . $lang . "_" . $module_data . "_nodes_refs (
  node_id int(11) unsigned NOT NULL COMMENT 'ID node',
  image_cover varchar(255) NOT NULL DEFAULT '' COMMENT 'Đường dẫn ảnh đại diện tùy chỉnh',
  sync_messerror text NULL DEFAULT NULL COMMENT 'Message lỗi khi đồng bộ',
  PRIMARY KEY (node_id),
  KEY node_id (node_id)
) ENGINE=InnoDB COMMENT 'Các trường mở rộng của tệp tin, thư mục'";

// API App của người dùng
$sql_create_module[] = "CREATE TABLE " . $db_config['prefix'] . "_" . $lang . "_" . $module_data . "_api_credentials (
  id int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID tự tăng',
  userid int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'Sở hữu của ai',
  add_time int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'Thời gian thêm',
  edit_time int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'Thời gian sửa',
  title varchar(100) NOT NULL DEFAULT '' COMMENT 'Tên gợi nhớ',
  client_id varchar(200) NOT NULL DEFAULT '' COMMENT 'Client ID',
  client_secret varchar(200) NOT NULL DEFAULT '' COMMENT 'Client secret',
  token text NULL DEFAULT NULL COMMENT 'Token json',
  is_setup tinyint(1) NOT NULL DEFAULT '0' COMMENT '0: chưa cài, 1: đã cài',
  is_error tinyint(1) NOT NULL DEFAULT '0' COMMENT '0: chưa lỗi, 1: đã bị lỗi cần kết nối lại',
  PRIMARY KEY (id),
  KEY userid (userid),
  KEY title (title),
  KEY is_setup (is_setup),
  KEY is_error (is_error),
  UNIQUE KEY crid1 (userid, title)
) ENGINE=InnoDB COMMENT 'API App của người dùng'";

// Thiết lập theo người dùng
$sql_create_module[] = "CREATE TABLE " . $db_config['prefix'] . "_" . $lang . "_" . $module_data . "_users_config (
  userid int(11) unsigned NOT NULL COMMENT 'ID thành viên',
  config_name varchar(50) NOT NULL COMMENT 'Khóa cấu hình',
  config_value text NOT NULL COMMENT 'Nội dung cấu hình',
  UNIQUE KEY config_name (userid, config_name),
  KEY userid (userid)
) ENGINE=InnoDB COMMENT 'Thiết lập theo người dùng'";

// Các thông báo cho người dùng
$sql_create_module[] = "CREATE TABLE " . $db_config['prefix'] . "_" . $lang . "_" . $module_data . "_users_notices (
  id int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID tự tăng',
  userid int(11) unsigned NOT NULL COMMENT 'ID thành viên',
  channel varchar(50) NOT NULL COMMENT 'Kênh',
  notice_key varchar(50) NOT NULL COMMENT 'Loại thông báo',
  notice_time int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'Thời gian thông báo',
  subject varchar(250) NOT NULL COMMENT 'Tiêu đề',
  message longtext NOT NULL COMMENT 'Nội dung thông báo',
  send_time int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'Thời gian xử lý',
  send_message longtext NULL DEFAULT NULL COMMENT 'Message nếu xử lý có lỗi',
  PRIMARY KEY (id),
  KEY userid (userid),
  KEY channel (channel),
  KEY notice_key (notice_key),
  KEY notice_time (notice_time),
  KEY send_time (send_time)
) ENGINE=InnoDB COMMENT 'Các thông báo cho người dùng'";

$sql_create_module[] = "INSERT INTO " . $db_config['prefix'] . "_" . $lang . "_" . $module_data . "_users_config (userid, config_name, config_value) VALUES
(0, 'view_type', 'grid'),
(0, 'view_sort', 'add_desc')
";

$sql_create_module[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES
('" . $lang . "', '" . $module_name . "', 'turn_enabled', '0'),
('" . $lang . "', '" . $module_name . "', 'turn_type', '0'),
('" . $lang . "', '" . $module_name . "', 'coturn_auth', '0'),
('" . $lang . "', '" . $module_name . "', 'coturn_user', ''),
('" . $lang . "', '" . $module_name . "', 'coturn_pass', ''),
('" . $lang . "', '" . $module_name . "', 'coturn_secret', ''),
('" . $lang . "', '" . $module_name . "', 'coturn_live', '600'),
('" . $lang . "', '" . $module_name . "', 'coturn_server', ''),
('" . $lang . "', '" . $module_name . "', 'ice_servers', ''),
('" . $lang . "', '" . $module_name . "', 'turn_public', '0'),
('" . $lang . "', '" . $module_name . "', 'websocket_url', ''),
('" . $lang . "', '" . $module_name . "', 'system_quota', '')";
