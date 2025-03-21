<?php

/**
 * NukeViet Content Management System
 * @version 4.x
 * @author VINADES.,JSC <contact@vinades.vn>
 * @copyright (C) 2009-2021 VINADES.,JSC. All rights reserved
 * @license GNU/GPL version 2 or any later version
 * @see https://github.com/nukeviet The NukeViet CMS GitHub project
 */

if (!defined('NV_MAINFILE')) {
    exit('Stop!!!');
}

$lang_translator['author'] = 'VINADES.,JSC <contact@vinades.vn>';
$lang_translator['createdate'] = '04/03/2010, 15:22';
$lang_translator['copyright'] = '@Copyright (C) 2009-2021 VINADES.,JSC. All rights reserved';
$lang_translator['info'] = '';
$lang_translator['langtype'] = 'lang_module';

/**
 * Dịch thêm các khu vực:
 * themes/blanas/modules/nas/drive-connect.tpl
 * themes/blanas/modules/nas/rtc-transfer.tpl
 */

$lang_module['add'] = 'Thêm';
$lang_module['title'] = 'Tiêu đề';
$lang_module['alias'] = 'Liên kết tĩnh';
$lang_module['errorsave'] = 'Vì một lý do nào đó mà dữ liệu không thể lưu lại được';
$lang_module['function'] = 'Chức năng';
$lang_module['order'] = 'Thứ tự';
$lang_module['status'] = 'Hoạt động';
$lang_module['status1'] = 'Kích hoạt';
$lang_module['keywords'] = 'Từ khóa';
$lang_module['search_keywords'] = 'Từ khóa tìm kiếm';
$lang_module['description'] = 'Mô tả';
$lang_module['illustrating_images'] = 'Ảnh minh họa';
$lang_module['note'] = 'Chú ý';
$lang_module['enter_search_key'] = 'Nhập từ khóa';
$lang_module['select2_pick'] = 'Nhập từ khóa để tìm và chọn';
$lang_module['addtime'] = 'Tạo lúc';
$lang_module['edittime'] = 'Cập nhật lúc';
$lang_module['approval'] = 'Duyệt bài đăng';
$lang_module['msgnocheck'] = 'Vui lòng chọn ít nhất một dòng để thực hiện';
$lang_module['to'] = 'đến';
$lang_module['from_day'] = 'Từ ngày';
$lang_module['to_day'] = 'Đến ngày';
$lang_module['is_required'] = 'là mục bắt buộc';

$lang_module['system_quota'] = 'Dung lượng của hệ thống';
$lang_module['system_quota_auto'] = 'Tính tự động';
$lang_module['system_quota_no'] = 'Máy chủ của bạn không hỗ trợ công cụ tính toán tự động. Hãy nhập tay';
$lang_module['system_quota_hint'] = 'Nhập dạng 1mb|gb|tb. Để trống tương đương với không giới hạn dung lượng. Giá trị này nếu tự tính chỉ nên tính khi chưa có dữ liệu';
$lang_module['quota_limit'] = 'Dung lượng giới hạn';
$lang_module['quota_limit_sort'] = 'Giới hạn';
$lang_module['quota_current'] = 'Đã dùng';
$lang_module['quota_limit_hint'] = 'Nhập dạng 1mb|gb|tb. Để trống thì không giới hạn';
$lang_module['quota_limit_error'] = 'Định dạng không hợp lệ';
$lang_module['ulists'] = 'Danh sách người dùng';
$lang_module['user'] = 'Người dùng';
$lang_module['user_add'] = 'Thêm người dùng';
$lang_module['user_edit'] = 'Sửa người dùng';
$lang_module['user_pick'] = 'Chỉ định thành viên';
$lang_module['user_pick1'] = 'Lựa chọn';
$lang_module['user_pick_error'] = 'Chưa chỉ định thành viên';
$lang_module['user_pick_exists'] = 'Thành viên này không tồn tại';
$lang_module['user_pick_exists1'] = 'Thành viên này đã được chỉnh định làm người dùng trước đó rồi';
$lang_module['websocket_url'] = 'Máy chủ Signaling';

$lang_module['config'] = 'Thiết lập';
$lang_module['config_general'] = 'Thiết lập chung';
$lang_module['config_rtc'] = 'Thiết lập tính năng WebRTC';
$lang_module['config_turn_enabled'] = 'Bật STUN/TURN server';
$lang_module['config_turn_type'] = 'Kiểu STUN/TURN';
$lang_module['config_turn_type0'] = 'Dịch vụ STUN/TURN';
$lang_module['config_turn_type1'] = 'Máy chủ Coturn';
$lang_module['config_coturn_server'] = 'Coturn: URL';
$lang_module['config_coturn_auth'] = 'Coturn: Kiểu xác thực';
$lang_module['config_coturn_auth0'] = 'Long-Term credentials';
$lang_module['config_coturn_auth1'] = 'Short-Term Credentials';
$lang_module['config_coturn_user'] = 'Coturn: Static user';
$lang_module['config_coturn_pass'] = 'Coturn: Static user password';
$lang_module['config_coturn_secret'] = 'Coturn: Mã bí mật';
$lang_module['config_coturn_live'] = 'Thời gian (s) token';
$lang_module['config_ice_urls_note'] = 'mỗi url một dòng';
$lang_module['config_turn_public'] = 'Đối tượng áp dụng TURN/STUN';
$lang_module['config_turn_public0'] = 'Người dùng đã đăng nhập';
$lang_module['config_turn_public1'] = 'Tự do';

$lang_module['ui_appsopen'] = 'Mở danh sách dứng dụng';
$lang_module['ui_logout'] = 'Đăng xuất';
$lang_module['ui_apps'] = 'Danh sách ứng dụng';
$lang_module['ui_gohome'] = 'Về trang chính';
$lang_module['ui_search_file'] = 'Tìm tệp tin, thư mục...';
$lang_module['ui_my_drive'] = 'Drive của tôi';
$lang_module['ui_quota'] = 'Dung lượng';
$lang_module['ui_not_nasuser'] = 'Quy cập bị từ chối';
$lang_module['ui_not_nasuser_content'] = 'Bạn chưa được cấp quyền sử dụng hệ thống. Xin mời liên hệ quản trị viên để được cấp quyền';
$lang_module['ui_storage_current'] = 'Đã dùng';
$lang_module['ui_create'] = 'Tạo';
$lang_module['ui_create_upload'] = 'Tải lên tệp tin từ thiết bị';
$lang_module['ui_create_remote'] = 'Tải lên tệp tin từ Internet';
$lang_module['ui_create_folder'] = 'Tạo thư mục mới';
$lang_module['ui_create_folder_sub'] = 'Tạo thư mục con';
$lang_module['ui_name_folder'] = 'Tên thư mục';
$lang_module['ui_file_name'] = 'Tên tệp tin';
$lang_module['ui_link'] = 'Đường dẫn';
$lang_module['ui_upload'] = 'Tải lên';
$lang_module['ui_view_bytype'] = 'Lọc theo loại file';
$lang_module['ui_view_bytype_all'] = 'Tất cả';
$lang_module['ui_view_bytype_document'] = 'Tài liệu';
$lang_module['ui_view_bytype_image'] = 'Ảnh';
$lang_module['ui_view_bytype_movie'] = 'Phim';
$lang_module['ui_view_bytype_music'] = 'Nhạc';
$lang_module['ui_view_mode'] = 'Chế độ xem';
$lang_module['ui_sort'] = 'Chế độ sắp xếp';
$lang_module['ui_sort_title_asc'] = 'Tên - Tăng dần';
$lang_module['ui_sort_title_desc'] = 'Tên - Giảm dần';
$lang_module['ui_sort_add_asc'] = 'Ngày tạo - Tăng dần';
$lang_module['ui_sort_add_desc'] = 'Ngày tạo - Giảm dần';
$lang_module['ui_sort_edit_asc'] = 'Ngày cập nhật - Tăng dần';
$lang_module['ui_sort_edit_desc'] = 'Ngày cập nhật - Giảm dần';
$lang_module['ui_sort_ext_asc'] = 'Định dạng tệp - Tăng dần';
$lang_module['ui_sort_ext_desc'] = 'Định dạng tệp - Giảm dần';
$lang_module['ui_view_grid'] = 'Lưới';
$lang_module['ui_view_list'] = 'Danh sách';
$lang_module['ui_no_nodes'] = 'Không có thư mục/tệp tin nào được tìm thấy';
$lang_module['ui_name'] = 'Tên';
$lang_module['ui_size'] = 'Kích thước';
$lang_module['ui_created'] = 'Ngày tạo';
$lang_module['ui_last_modified'] = 'Thay đổi';
$lang_module['ui_type'] = 'Loại';
$lang_module['ui_folder'] = 'Thư mục';
$lang_module['ui_empty_trash'] = 'Dọn sạch thùng rác';
$lang_module['ui_open_menu_file'] = 'Mở menu tệp tin';
$lang_module['ui_toggle_bookmark'] = 'Đánh dấu/bỏ đánh dấu tệp tin';
$lang_module['ui_download'] = 'Tải về';
$lang_module['ui_untrash'] = 'Khôi phục';
$lang_module['ui_delete_permanently'] = 'Xóa vĩnh viễn';
$lang_module['ui_confirm_permanently'] = 'Bạn có chắc chắn xóa vĩnh viễn không? Thao tác này không thể khôi phục!';
$lang_module['ui_upload_drop'] = 'Thả tệp vào đây dể tải lên';
$lang_module['ui_upload_drop'] = 'Thả tệp vào đây dể tải lên';
$lang_module['ui_uploading'] = 'Đang tải lên';
$lang_module['ui_uploaded'] = 'Đã tải lên';
$lang_module['ui_file'] = 'tệp';
$lang_module['ui_access'] = 'Truy cập';
$lang_module['ui_sync_googledrive'] = 'Đồng bộ Google Drive';
$lang_module['ui_sync_off_googledrive'] = 'Tắt đồng bộ G-Drive';
$lang_module['ui_sync_off_message'] = 'Sau khi tắt dữ liệu trên Google Drive nếu đã được đưa lên vẫn còn. Bạn có chắc chắn tắt không?';
$lang_module['ui_please_select'] = 'Vui lòng chọn';
$lang_module['ui_please_wait'] = 'Đang xử lý, vui lòng đợi';
$lang_module['ui_selected'] = '%s đối tượng đã chọn';
$lang_module['ui_rename'] = 'Đổi tên';
$lang_module['ui_play_video'] = 'Phát video';
$lang_module['ui_settings'] = 'Tùy chỉnh';
$lang_module['ui_admin'] = 'Quản trị';
$lang_module['ui_recreate_cover'] = 'Tạo lại ảnh bìa';
$lang_module['ui_recreate_cover_success'] = 'Đánh dấu tạo lại ảnh bìa thành công, nhanh nhất 1 phút nữa có hiệu lực';
$lang_module['ui_reload'] = 'Làm mới danh sách';
$lang_module['ui_cancel_request'] = 'Hủy yêu cầu';
$lang_module['ui_confirm'] = 'Xác nhận';
$lang_module['ui_adminmodule'] = 'Quản lí NAS';
$lang_module['ui_unzone'] = 'Hủy Zone';
$lang_module['ui_zone_permanently'] = 'Zone vĩnh viễn';
$lang_module['ui_zone_temporary'] = 'Zone 5 phút';
$lang_module['ui_guide'] = 'Hướng dẫn';

$lang_module['app_fmanager'] = 'Quản lí tệp tin';
$lang_module['app_fzone'] = 'FileZone';
$lang_module['app_drivecnt'] = 'Liên kết Google Drive';
$lang_module['app_muplayer'] = 'Music Player';
$lang_module['app_vdplayer'] = 'Video Player';

$lang_module['drive_doc'] = 'Tài liệu';
$lang_module['drive_media'] = 'Đa phương tiện';
$lang_module['drive_history'] = 'Gần đây';
$lang_module['drive_bookmark'] = 'Đã đánh dấu';
$lang_module['drive_trash'] = 'Thùng rác';
$lang_module['drive_shared'] = 'Được chia sẻ';

$lang_module['upload_error_username'] = 'Tên đăng nhập của bạn chứa kí tự không hợp lệ nên không thể tạo thư mục';
$lang_module['upload_error_dirroot'] = 'Thư mục của bạn không tồn tại hoặc không thể tạo, vui lòng liên hệ nhà cung cấp';
$lang_module['upload_error_quota'] = 'Quá dung lượng được phép, xin vui lòng nâng cấp';
$lang_module['upload_error_name'] = 'Không xác định được tên tập tin, hãy thử đổi tên bao gồm tên + phần mở rộng một cách đầy đủ';
$lang_module['upload_error_nofile'] = 'Không có tệp nào được gửi lên';
$lang_module['upload_error_size'] = 'Không xác định được kích thước tệp gửi lên';
$lang_module['upload_error_oversize1'] = 'Tệp gửi lên quá dung lượng được phép';
$lang_module['upload_error_readtmp'] = 'Không thể đọc tệp tin đã tải lên';
$lang_module['upload_error_size1'] = 'Đối chiếu kích thước tệp tải lên thất bại';
$lang_module['upload_beforeunload'] = 'Có tệp tin đang tải lên hoặc chờ tải lên. Bạn có muốn chuyển trang ngay bây giờ không? Tiến trình tải lên hiện tại và tệp tin ở hàng chờ sẽ bị mất';

$lang_module['createdir_error_namerule'] = 'Xin vui lòng nhập có ít nhất một kí tự latin';
$lang_module['createdir_err_exists'] = 'Tên này đã được sử dụng, vui lòng nhập tên khác để tránh sự nhầm lẫn';
$lang_module['createdir_err_parent'] = 'Thư mục bạn thao tác không tồn tại';
$lang_module['createdir_err_assets'] = 'Lỗi tạo thư mục data trong assets';

$lang_module['drconnect'] = 'Kết nối Google Drive';
$lang_module['drconnect_tip1'] = 'Hướng dẫn kết nối Google Drive';
$lang_module['drconnect_add'] = 'Thêm API kết nối';
$lang_module['drconnect_title'] = 'Tên gợi nhớ';
$lang_module['drconnect_client_id'] = 'Client ID';
$lang_module['drconnect_client_secret'] = 'Client secret';
$lang_module['drconnect_e_title'] = 'Tên này đã được sử dụng, mời nhập tên khác';
$lang_module['drconnect_e_setuped'] = 'Client ID đã được kết nối thành công';
$lang_module['drconnect_e_refresh_token'] = 'Thiếu refresh_token';
$lang_module['drconnect_notyet'] = 'Chưa kết nối';
$lang_module['drconnect_error'] = 'Lỗi kết nối';
$lang_module['drconnect_success'] = 'Đã kết nối';
$lang_module['drconnect_test'] = 'Kiểm tra kết nối';
$lang_module['drconnect_test_success'] = 'Kết nối thành công';
$lang_module['drconnect_verification_code'] = 'Mã xác minh';
$lang_module['drconnect_token_guide1'] = 'Bước 1: Nhấp để mở';
$lang_module['drconnect_token_guide1_1'] = 'liên kết này';
$lang_module['drconnect_token_guide2'] = 'Bước 2: Thực hiện chọn tài khoản Google và xác nhận';
$lang_module['drconnect_token_guide3'] = 'Bước 3: Sau khi xác nhận xong, trình duyệt sẽ chuyển hướng bạn về một liên kết có dạng';
$lang_module['drconnect_token_guide3_1'] = 'Bạn không cần quan tâm đến nội dung, bạn chỉ cần quan tâm đến liên kết';
$lang_module['drconnect_token_guide4'] = 'Bước 4: Chép giá trị xxxxxxxxxx trong liên kết thật của bạn hiện tại, dán vào ô bên trên và nhấn nút thực hiện';

$lang_module['syncgdrive_error_noapi'] = 'Bạn chưa thiết lập API nào. Mời ấn <a href="%s">vào đây</a> để thiết lập trước mới có thể kết nối đồng bộ';
$lang_module['syncgdrive_error_apperror'] = 'APP này đang bị lỗi kết nối, mời kiểm tra lại trước';
$lang_module['syncgdrive_error_choose'] = 'Vui lòng chọn thư mục đồng bộ';
$lang_module['syncgdrive_error_chooseapp'] = 'Vui lòng chọn APP';
$lang_module['syncgdrive_error_exists'] = 'Thư mục trên Google Drive này đã được chọn đồng bộ cho một thư mục trên NAS khác. Vui lòng chọn cái khác để tránh sai sót dữ liệu';
$lang_module['syncgdrive_choose_api'] = 'Chọn APP';
$lang_module['syncgdrive_root_folder'] = 'Thư mục gốc';
$lang_module['syncgdrive_nosub_folder'] = 'Không có thư mục con trong này';
$lang_module['syncgdrive_note'] = 'Lưu ý: Hệ thống chỉ đồng bộ một chiều tức từ NAS lên Google Drive và không có chiều ngược lại';
$lang_module['syncgdrive_cerror_appfound1'] = 'APP không tìm thấy';
$lang_module['syncgdrive_cerror_appfound2'] = 'Lỗi khi đồng bộ thư mục %s. APP không còn tìm thấy. Vui lòng kiểm tra lại, tắt và đồng bộ lại với thư mục khác trên Google Drive';
$lang_module['syncgdrive_cerror_apperror1'] = 'APP không tìm thấy';
$lang_module['syncgdrive_cerror_apperror2'] = 'Lỗi khi đồng bộ thư mục %s. APP %s đang bị lỗi. Vui lòng kiểm tra và kết nối lại APP';
$lang_module['syncgdrive_cerror_apperror3'] = 'APP lỗi khi khởi tạo';
$lang_module['syncgdrive_cerror_apperror4'] = 'Lỗi khi đồng bộ thư mục %s. APP %s đang bị lỗi lúc khởi tạo như sau:<br />%s<br/>. Vui lòng kiểm tra và kết nối lại APP';
$lang_module['syncgdrive_cerror_parent1'] = 'Thư mục cha không tìm thấy';
$lang_module['syncgdrive_cerror_parent2'] = 'Lỗi khi đồng bộ thư mục/tệp tin %s. Cha của nó có ID %s không tìm thấy. Vui lòng kiểm tra lại dữ liệu';
$lang_module['syncgdrive_cerror_parent3'] = 'Thư mục cha đồng bộ bị lỗi';
$lang_module['syncgdrive_cerror_parent4'] = 'Lỗi khi đồng bộ thư mục/tệp tin %s. Cha của nó là %s đồng bộ bị lỗi nên nó cũng không đồng bộ được. Vui lòng kiểm tra lại dữ liệu';
$lang_module['syncgdrive_cerror_parent5'] = 'Thư mục cha đồng bộ thành công nhưng dữ liệu sai';
$lang_module['syncgdrive_cerror_parent6'] = 'Lỗi khi đồng bộ thư mục/tệp tin %s. Cha của nó là %s đồng bộ thành công nhưng trong CSDL lại không tìm thấy ID thư mục đã được đồng bộ lên nên nó cũng không đồng bộ được. Vui lòng kiểm tra lại dữ liệu';
$lang_module['syncgdrive_cerror_fileexists1'] = 'Tệp tin không tìm thấy';
$lang_module['syncgdrive_cerror_fileexists2'] = 'Lỗi khi đồng bộ tệp tin %s. File tệp tin trên ổ đĩa không còn tìm thấy. Vui lòng kiểm tra lại dữ liệu';
$lang_module['syncgdrive_cerror_upload1'] = 'Lỗi đẩy lên Google Drive';
$lang_module['syncgdrive_cerror_upload1'] = 'Lỗi khi đồng bộ tệp tin %s. Đẩy lên dạng chunks lỗi, hiện chưa rõ nguyên nhân';
$lang_module['syncgdrive_aerror_check1'] = 'Lỗi kiểm tra APP hàng ngày';
$lang_module['syncgdrive_aerror_check2'] = 'Lỗi khi kiểm tra APP %s. Kết nối API thử thất bại với lỗi trả về như sau<br /><br /><pre><code>%s</code></pre>';

$lang_module['cron_error_sendsubject'] = 'Thông báo lỗi từ NAS';

$lang_module['rename_error_empty'] = 'Tên không được để trống';
$lang_module['rename_error_same'] = 'Tên mới không có thay đổi gì so với tên cũ';
$lang_module['rename_error_changedir'] = 'Không thể đổi tên trên ổ đĩa được';

$lang_module['setfolder_show_grid'] = 'Hiển thị dạng lưới với ảnh lớn';
$lang_module['setfolder_show_grid_note'] = 'Nếu không chọn cách hiển thị sẽ tùy vào kiểu hiển thị trong trình quản lí tệp tin';
$lang_module['setfolder_hide_media'] = 'Ẩn video/ảnh trong thư mục khỏi mục đa phương tiện';

$lang_module['app_rtct'] = 'Gửi nhận tệp trực tiếp';
$lang_module['app_rtct_tip'] = 'Giải thích cách thức hoạt động';
$lang_module['rtct_not_supported'] = 'Trình duyệt của bạn không hỗ trợ một trong các chức năng WebSocket, RTCPeerConnection, FileReader, JSON. Hãy sử dụng bất kì trình duyệt hiện đại nào khác như Chrome, Safari, Firefox, EDGE để sử dụng tính năng này';
$lang_module['rtct_join'] = 'Nhập mã hoặc liên kết của kênh';
$lang_module['rtct_join_btn'] = 'Tham gia';
$lang_module['rtct_create'] = 'Tạo kênh truyền dữ liệu';
$lang_module['rtct_or'] = 'Hoặc';
$lang_module['rtct_join_error1'] = 'Bạn chưa nhập mã kênh hoặc liên kết đến kênh truyền dữ liệu';
$lang_module['rtct_join_error2'] = 'Mã kênh hoặc liên kết của kênh không hợp lệ';
$lang_module['rtct_error_ws'] = 'Lỗi giao tiếp với máy chủ Signaling nên không thể tiếp tục, hãy thử tải lại trang';
$lang_module['rtct_error_ws1'] = 'Kết nối với máy chủ Signaling đã đóng nên không thể thực hiện được thêm chức năng. Hãy thử tải lại trang';
$lang_module['rtct_confirm1'] = 'Bạn có muốn gửi tệp tin <span class=\'fw-medium\'>%s</span> với dung lượng <span class=\'fw-medium\'>%s</span> đến <span class=\'fw-medium\'>%s</span> không?';
$lang_module['rtct_confirm2'] = 'Xác nhận gửi tệp tin';
$lang_module['rtct_confirm3'] = 'Chờ xác nhận';
$lang_module['rtct_confirm4'] = 'Đang đợi %s chấp nhận yêu cầu';
$lang_module['rtct_confirm5'] = '<span class=\'fw-medium\'>%s</span> muốn gửi tệp tin <span class=\'fw-medium\'>%s</span> với dung lượng <span class=\'fw-medium\'>%s</span> cho bạn. Có nhận hay không?';
$lang_module['rtct_confirm6'] = '<span class=\'fw-medium\'>%s</span> đã từ chối yêu cầu của bạn';
$lang_module['rtct_confirm7'] = '<span class=\'fw-medium\'>%s</span> đã hủy yêu cầu';
$lang_module['rtct_status1'] = 'Đang gửi tệp tin';
$lang_module['rtct_status2'] = '<span class=\'fw-medium\'>%s</span>/<span class=\'fw-medium\'>%s</span><br/>Tốc độ <span class=\'fw-medium\'>%s</span>';
$lang_module['rtct_status3'] = 'Đã gửi xong';
$lang_module['rtct_status4'] = 'Đang nhận tệp tin';
$lang_module['rtct_status5'] = 'Đã tải xuống';

$lang_module['fzone_empty'] = 'Không có tệp tin nào được chia sẻ';
$lang_module['fzone_search_empty'] = 'Không có kết quả nào phù hợp với điều kiện tìm kiếm';
$lang_module['fzone_zone_success0'] = 'Đã chia sẻ tệp tin trên Zone trong vòng 5 phút';
$lang_module['fzone_zone_success1'] = 'Đã chia sẻ tệp tin vĩnh viễn trên Zone';
$lang_module['fzone_unzone_success'] = 'Đã hủy chia sẻ tệp tin trên Zone';
