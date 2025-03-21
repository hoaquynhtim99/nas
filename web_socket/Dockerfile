# Sử dụng hình ảnh chính thức của Go
FROM golang:1.21

# Cài đặt thư mục làm việc
WORKDIR /app/src

# Sao chép toàn bộ mã nguồn vào container
COPY src/ .

# Tải các dependency cần thiết
RUN go mod tidy

# Biên dịch mã nguồn Go
#RUN go build -o /app/src/blahome_ws_server

# Đặt cổng cần expose
#EXPOSE 3000

# Command để chạy ứng dụng
#CMD ["./blahome_ws_server"]

# Command mặc định
CMD ["/bin/bash"]
