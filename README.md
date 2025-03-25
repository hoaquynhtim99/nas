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



## Giấy phép
Dự án được phát hành theo giấy phép **GPL-2.0+**.

## Ủng hộ
Nếu bạn thấy dự án hữu ích, hãy ủng hộ chúng tôi:

- [![Donate via PayPal](https://img.shields.io/badge/Donate-PayPal-blue.svg)](https://paypal.me/tandung?country.x=VN&locale.x=vi_VN)  
- [![GitHub Sponsors](https://img.shields.io/github/sponsors/hoaquynhtim99)](https://github.com/sponsors/hoaquynhtim99)

Cảm ơn bạn đã ủng hộ và sử dụng BlaNAS!
