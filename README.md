# BlaNAS

[![GitHub Sponsors](https://img.shields.io/github/sponsors/hoaquynhtim99?style=for-the-badge)](https://github.com/sponsors/hoaquynhtim99)
[![Donate via PayPal](https://img.shields.io/badge/Donate-PayPal-blue?style=for-the-badge)](https://paypal.me/tandung?country.x=VN&locale.x=vi_VN)

## Giới thiệu
BlaNAS là hệ thống quản lý chia sẻ, xem trước, đồng bộ tệp tin; hỗ trợ gửi và nhận tệp tin trực tiếp. Dự án vẫn đang phát triển phục vụ nhu cầu của tác giả và chia sẻ rộng rãi. Bạn có thể sử dụng ngay hoặc nghiên cứu học hỏi, phát triển sản phẩm riêng của mình dựa trên những gì nó hiện có.

## Tính năng

### Quản trị
- Thiết lập dung lượng tổng của hệ thống, thiết lập tính năng WebRTC
- Quản lý người dùng

### Người dùng
- Liên kết với Google Drive để đồng bộ
- **Drive:** Quản lý thư mục đa cấp, upload tệp tin, tự tạo ảnh bìa video, xem tệp tin video trực tuyến, tải về, công khai tệp tin
- **Truyền nhận tệp trực tiếp** qua giao thức WebRTC
- **FileZone:** Công khai tệp tin lên internet
- Hỗ trợ Progressive web apps như một ứng dụng di động

## Hướng dẫn cài đặt

Bạn có thể lựa chọn một trong 2 hình thức cài đặt sau

### Sử dụng Docker

Cách này khuyến nghị nếu bạn sử dụng để trải nghiệm hoặc phát triển, nếu bạn dùng để xây dựng ứng dụng thực tế cần đặc biệt lưu ý thay đổi một số thông tin sau:
- Thông tin tài khoản quản trị webmaster sẵn có
- Chứng chỉ SSL của nginx trong conf/nginx
- Chứng chỉ SSL của Coturn server trong conf/pkey.pem và conf/cert.pem
- Thông số về CSDL, sitekey trong src/config.php
- Các thông số static-auth-secret, user trong conf/coturn.conf và config tương ứng trong phần thiết lập (/admin/vi/nas/config/) của module nas

**Thực hiện:**  
- Tải nguyên bộ code về, tại thư mục có tệp docker-compose.yml vào thư mục setup chạy `bash setup-docker-auto.sh` và làm theo hướng dẫn cho đến khi hoàn tất. Chú ý trên Windows nếu bạn không chạy được `bash` hãy cài đặt [Git SCM](https://git-scm.com/downloads) sau đó mở "Open git bash here" ở thư mục setup và gõ lệnh trên.
- Truy cập site tại https://blanas.local:5443/ hoặc http://blanas.local:5080/
- Truy cập quản trị site tại https://blanas.local:5443/admin/ hoặc http://blanas.local:5080/admin/. Tài khoản quản trị là webmaster mật khẩu G7yNKvE5ifWWzTKuy8iu
- Truy cập CSDL qua phpmyadmin tại https://db.blanas.local:5443/ hoặc http://db.blanas.local:5080/

### Tự cài đặt từng phần

Cách này phù hợp khi bạn bắt đầu một ứng dụng công khai cho riêng mình. Hướng dẫn này viết cho máy chủ Ubuntu, nếu bạn sử dụng các máy chủ khác Debian bạn cần tự sửa một số lệnh để nó tương thích. Ví dụ apt-get bằng yum, dnf... Nếu bạn chạy máy chủ windows thì cần một số kiến thức nhất định để chuyển các hướng dẫn tại đây sang windows.

Các bước thực hiện:

**Chuẩn bị máy chủ:**

Cài đặt một máy chủ có thể chạy được NukeViet phiên bản 5.0. Xem các yêu cầu về môi trường cho NukeViet mục **Requirements** [ở đây](https://github.com/nukeviet/nukeviet/tree/nukeviet5.0?tab=readme-ov-file#for-users)

Ngoài ra BlaNAS yêu cầu cần có:
- MariaDB 10.0.5+ hoặc MySQL 8.0+
- Máy chủ cài ffmpeg, libavcodec-extra, nginx. Nếu bạn là người quản trị máy chủ thì không có gì khó để cài ffmpeg, libavcodec-extra, nginx
- Quyền root của máy chủ.

Sau khi bạn cài được và đảm bảo mã nguồn NukeViet có thể chạy được trên miền của bạn hãy làm tiếp các bước bên dưới.

**Cài đặt website và module:**

- Tải kho code này về lấy toàn bộ code và thư mục trong src upload lên hosting và truy cập https://domain.com/index.php để cài đặt
- Thiết lập module nas trong phần quản lí module (/admin/vi/modules/setup/)
- Chọn module nas làm module hiển thị tại trang chủ tại phần cấu hình, cấu hình site (/admin/vi/settings/)
- Vào quản lý giao diện (/admin/vi/themes/) tại giao diện BlaNas default ấn nút "Thiết lập các giá trị theo mặc định"
- Vào quản lý modules, sửa module nas (/admin/vi/modules/edit/?mod=nas) mục giao diện chọn blanas, mục Giao diện cho Mobile chọn Giao diện PC theo cấu hình module
- Mở config.php tại thư mục gốc (chứa api.php) thêm vào cuối file

```php
// Thư mục data (đường dẫn tuyệt đối)
define('NAS_DIR', '/var/www/private/nas');
```

Giá trị là đường dẫn tuyệt đối đến thưc mục chứa tệp tin người dùng. Chú ý giá trị này không nên đặt vào thư mục public trên hosting, mà đặt ở thư mục private. Ví dụ `/home/nas/private/nas-data`

- Thiết lập dung lượng hệ thống ở phần thiết lập (/admin/vi/nas/config/)
- Thêm người dùng ở phần quản lý module nas (/admin/vi/nas/)

Đến đây bạn có thể sử dụng các tính năng quản lí tệp tin, FileZone, Liên kết Google Drive

**Cài đặt tiến trình tự động:**

Bạn chép thư mục `private` trên code đã tải về lên một thư mục bí mật trên máy chủ ví dụ `/home/nas/private/` sau đó mở file server.php trên máy chủ sửa 

```php
$_SERVER['HTTP_HOST'] = 'blanas.local';
```

Thành tên miền của bạn. Các giá trị khác giữ nguyên và cài đặt crontab như sau

```sh
MAILTO=""
* * * * * bash /home/nas/private/every_minute.sh
0 23 * * * bash /home/nas/private/every_day.sh
```

Chú ý thay `/home/nas/private/` bằng giá trị đường dẫn tuyệt đối đến thư mục private bạn đã tạo ra để chép file vào. Các crontab này sẽ làm một số nhiệm vụ như sau:
- Xóa tệp tin tự động trong thùng rác của user quá 30 ngày
- Xóa tệp upload tạm bị lỗi sau 1 ngày
- Đồng bộ tệp tin lên Google Drive
- Xử lý video để lấy thông số độ phân giải, thời lượng, tạo ảnh bìa video
- Gửi lỗi qua email người dùng
- Kiểm tra các App đồng bộ Google Drive của người dùng nếu lỗi thông báo mỗi ngày
- Xóa các log quá hạn sinh ra phục vụ crontab chạy

**Cài đặt cho chức năng Gửi nhận tệp tin trực tiếp:**

Phần này nếu bạn không làm phần gửi tệp tin trực tiếp sẽ không hoạt động

- Chép tệp tin dist/blanas_signaling_server lên /root/blanas_signaling_server trên máy chủ. Bạn cũng có thể cài đặt GoLang và build ra từ web_socket/src nếu như máy chủ của bạn không phải linux.
- Chép web_socket/setup-server.sh lên /root/setup-server.sh
- Mở /root/setup-server.sh lên sửa một số cái như sau:
  + `user="blanas"` sửa blanas thành tên người dùng của bạn, ví dụ ở trên `/home/nas/private/` thì tên người dùng là nas
  + Tìm tất cả các đoạn `/home/${user}/blanas.local/private` và thay thế thành đường dẫn tới thư mục private của bạn cho đúng
- Chạy `bash /root/setup-server.sh` để cài đặt máy chủ Signalling cho WebRTC
- Quay lại thiết lập của module nas (/admin/vi/nas/config/) điền giá trị máy chủ signalling của bạn đã cài vào ô Máy chủ Signaling. Ví dụ ws://domain.com:3001. Nếu có kiến thức hãy dùng nginx để tạo Reverse Proxy, bật SSL cho nó.

Đến đây bạn có thể sử dụng tính năng gửi nhận tệp tin trực tiếp trong môi trường mạng LAN. Nếu bạn muốn chạy vượt ra ngoài Internet bạn cần cài TURN/STUN hoặc đăng ký dịch vụ TURN/STUN của bên thứ 3.

**Cài đặt Coturn làm TURN/STUN server cho WebRTC:**

- Đọc và làm theo hướng dẫn [tại đây](https://github.com/hoaquynhtim99/nas/wiki/H%C6%B0%E1%BB%9Bng-d%E1%BA%ABn-c%C3%A0i-%C4%91%E1%BA%B7t-Coturn)
- Quay lại thiết lập nas (/admin/vi/nas/config/) 
  + Bật STUN/TURN server
  + Đối tượng áp dụng TURN/STUN nên chọn Người dùng đã đăng nhập để không quá tải máy chủ
  + Kiểu STUN/TURN => Máy chủ Coturn
  + Coturn: URL => Nhập `SERVER_PUBLIC_IP:3478` với SERVER_PUBLIC_IP là IP công khai của máy chủ
  + Coturn: Kiểu xác thực nếu chọn Long-Term credentials thì nhập Coturn: Static user và Coturn: Static user password là giá trị YOUR_USERNAME, YOUR_PASSWORD đã cài đặt ở bước cài máy chủ Coturn. Nếu chọn Short-Term Credentials thì nhập Coturn: Mã bí mật là YOUR_MINIMUM_32_CHARS_PRIVATE_KEY đã điền ở bước cài Coturn

Đến đây bạn đã hoàn thành thiết lập đầy đủ toàn bộ hệ thống!

## Giấy phép
Dự án được phát hành theo giấy phép **GPL-2.0+**.

## Ủng hộ
Nếu bạn thấy dự án hữu ích, hãy ủng hộ chúng tôi:

- [![Donate via PayPal](https://img.shields.io/badge/Donate-PayPal-blue.svg)](https://paypal.me/tandung?country.x=VN&locale.x=vi_VN)  
- [![GitHub Sponsors](https://img.shields.io/github/sponsors/hoaquynhtim99)](https://github.com/sponsors/hoaquynhtim99)

Xin cảm ơn các nhà tài trợ đã đóng góp phát triển dự án:
- [An Hồ (Van An)](https://www.facebook.com/anhv.87)
