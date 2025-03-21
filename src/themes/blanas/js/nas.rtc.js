/**
 * NukeViet Content Management System
 * @version 4.x
 * @author VINADES.,JSC <contact@vinades.vn>
 * @copyright (C) 2009-2024 VINADES.,JSC. All rights reserved
 * @license GNU/GPL version 2 or any later version
 * @see https://github.com/nukeviet The NukeViet CMS GitHub project
 */

'use strict';

$(function() {
    let debug = true;

    // Hàm tạo mã ngẫu nhiên
    function generateRandomString() {
        const characters = 'abcdefghijklmnopqrstuvwxyz0123456789';
        let result = '';
        for (let i = 0; i < 4; i++) {
            const randomIndex = Math.floor(Math.random() * characters.length);
            result += characters[randomIndex];
        }
        return result;
    }

    // Hàm tạo UUID v4
    function generateUUID4() {
        return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
            var r = Math.random() * 16 | 0, v = c === 'x' ? r : (r & 0x3 | 0x8);
            return v.toString(16);
        });
    }

    // Hàm tạo tên ngẫu nhiên
    function getRandomFullName() {
        const ho = [
            "Nguyễn", "Trần", "Lê", "Phạm", "Hoàng", "Huỳnh", "Phan", "Vũ", "Võ", "Đặng",
            "Bùi", "Đỗ", "Hồ", "Ngô", "Dương", "Lý", "Hà", "Phùng", "Mai", "Trương"
        ];
        const tenDem = [
            "Văn", "Thị", "Minh", "Hồng", "Ngọc", "Quốc", "Hữu", "Thanh", "Đình", "Xuân",
            "Anh", "Tấn", "Bảo", "Công", "Khánh", "Chí", "Mạnh", "Phương", "Thế", "Nhật"
        ];
        const ten = [
            "An", "Bình", "Chi", "Dung", "Dũng", "Đạt", "Hiếu", "Hạnh", "Hoàng", "Hương",
            "Khôi", "Lan", "Linh", "Minh", "Nam", "Nhung", "Phúc", "Quang", "Quỳnh", "Sơn",
            "Tâm", "Thảo", "Thành", "Thúy", "Tú", "Tuấn", "Vân", "Việt", "Yến", "Trung"
        ];

        function getRandomInt(min, max) {
            return Math.floor(Math.random() * (max - min + 1)) + min;
        }

        // Chọn ngẫu nhiên họ, tên đệm và tên
        const hoRandom = ho[getRandomInt(0, ho.length - 1)];
        const tenDemRandom = tenDem[getRandomInt(0, tenDem.length - 1)];
        const tenRandom = ten[getRandomInt(0, ten.length - 1)];

        // Trả về họ tên đầy đủ
        return `${hoRandom} ${tenDemRandom} ${tenRandom}`;
    }

    // Hàm hiển thị dung lượng tệp tin
    function formatFileSize(bytes) {
        if (bytes === 0) return '0 Bytes';

        const sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
        const i = Math.floor(Math.log(bytes) / Math.log(1024));
        const fileSize = bytes / Math.pow(1024, i);

        // Làm tròn đến 2 chữ số thập phân
        return fileSize.toFixed(2) + ' ' + sizes[i];
    }

    // Giả lập php
    function sprintf(format, ...args) {
        let i = 0;
        return format.replace(/%s/g, () => args[i++]);
    }

    // Kiểm tra trình duyệt có hỗ trợ chức năng không
    let mainForm = $('#rtcMainForm');
    if (mainForm.length) {
        debug && console.log('Main page RTC');

        if (!WebSocket || !RTCPeerConnection || !FileReader || !JSON) {
            debug && console.warn('Device not supported!');
            $('#rtcNotSupported').removeClass('d-none');
            mainForm.addClass('d-none');
        } else {
            debug && console.log('Device is OK!');
        }
    }

    // Tạo và vào phòng ngẫu nhiên
    $('#rtcMainFormCreateBtn').on('click', function(e) {
        e.preventDefault();
        let url = mainForm.data('base-url');
        if (url.indexOf('?') >= 0) {
            url += '/';
        }
        url += generateRandomString();
        if (url.indexOf('?') == -1) {
            url += '/';
        }
        window.location = url;
    });

    // Tham gia phòng
    $('#rtcMainFormJoinForm').on('submit', function(e) {
        e.preventDefault();
        let form = $(this);
        let room = trim($('#rtcMainFormJoinIpt').val());
        if (room == '') {
            nvToast(form.data('error-1'), 'error');
            return;
        }
        room = room.endsWith("/") ? room.slice(0, -1) : room;
        room = room.replace(location.origin + mainForm.data('base-url'), "");
        if (!/^[a-z0-9]{4}$/.test(room)) {
            nvToast(form.data('error-2'), 'error');
            return;
        }
        let url = mainForm.data('base-url');
        if (url.indexOf('?') >= 0) {
            url += '/';
        }
        url += room;
        if (url.indexOf('?') == -1) {
            url += '/';
        }
        window.location = url;
    });

    let room = $('#rtcRoom');
    if (room.length > 0) {
        debug && console.log('Room area');

        let conReady = false;
        let me = {};
        let eleMe = $('.user.you', room);
        let eleOthers = $('.user.others', room);
        let cTransfer = {};
        let cReceiver = {};
        let rtcConfig = {
            iceCandidatePoolSize: 10
        };
        if (room.data('ice-servers') != '') {
            let iceServers;
            if (typeof room.data('ice-servers') == 'object') {
                iceServers = room.data('ice-servers');
            } else {
                try {
                    iceServers = JSON.parse(room.data('ice-servers'));
                } catch (err) {
                    iceServers = null;
                }
            }
            if (iceServers) {
                rtcConfig.iceServers = iceServers;
            }
        }

        // Thu thập và lưu tạm tất cả các ICE candidates theo peer_id
        let iceCandidatesQueue = {};

        me.uuid = generateUUID4();
        me.name = room.data('owner-name') == '' ? getRandomFullName() : room.data('owner-name');
        me.avatar = room.data('owner-image') == '' ? (room.data('path-image') + (Math.floor(Math.random() * (320 - 101 + 1)) + 101) + '.png') : room.data('owner-image');

        // Ghi ra tôi
        let html;
        html = `
        <div class="peer">
            <div class="avatar">
                <img alt="` + me.name + `" src="` + me.avatar + `">
            </div>
            <div class="user-info">
                <div class="user-ip text-truncate">
                    <span data-toggle="indicator" class="d-none" data-bs-toggle="tooltip" data-bs-trigger="hover" data-bs-title="TT"><i class="fa-solid fa-ban"></i></span>
                    <span>`+ me.name +`</span>
                </div>
            </div>
        </div>`;
        eleMe.html(html);

        debug && console.log('My data: ', me);

        // Xử lý đóng kết nối, xóa kênh chuyển dữ liệu
        function cleanChannelTransfer(peer_id) {
            if (cTransfer[peer_id]) {
                if (cTransfer[peer_id].intervalId) {
                    clearInterval(cTransfer[peer_id].intervalId);
                }
                // Đóng các kết nối nếu có
                if (cTransfer[peer_id].channel) {
                    cTransfer[peer_id].channel.close();
                }
                if (cTransfer[peer_id].conn) {
                    cTransfer[peer_id].conn.close();
                }
                // Xóa kênh truyền
                delete cTransfer[peer_id];
            }
            // Xóa tất cả các ICE Candidates tạm
            if (iceCandidatesQueue[peer_id]) {
                delete iceCandidatesQueue[peer_id];
            }
            let peerCtn = $('#' + peer_id);
            if (peerCtn.length) {
                // Hủy chọn file đã chọn
                $('[data-toggle="iptfile"]', peerCtn)[0].value = '';

                // Hủy popover của peer
                bootstrap.Popover.getOrCreateInstance($('.avatar', peerCtn)[0]).dispose();
            }
        }

        // Xử lý đóng kết nối
        function cleanChannelReceiver(peer_id) {
            if (cReceiver[peer_id]) {
                if (cReceiver[peer_id].intervalId) {
                    clearInterval(cReceiver[peer_id].intervalId);
                }
                // Đóng các kết nối nếu có
                if (cReceiver[peer_id].channel) {
                    cReceiver[peer_id].channel.close();
                }
                if (cReceiver[peer_id].conn) {
                    cReceiver[peer_id].conn.close();
                }
                // Xóa kênh nhận
                delete cReceiver[peer_id];
            }
            // Xóa tất cả các ICE Candidates tạm
            if (iceCandidatesQueue[peer_id]) {
                delete iceCandidatesQueue[peer_id];
            }
            let peerCtn = $('#' + peer_id);
            if (peerCtn.length) {
                // Hủy popover của peer
                bootstrap.Popover.getOrCreateInstance($('.avatar', peerCtn)[0]).dispose();
            }
        }

        const ws = new WebSocket(room.data('server-url'));
        let wsTimer = null;

        // Lỗi kết nối
        ws.onerror = () => {
            debug && console.error('WebSocket server error');
            nvToast(room.data('lang-error-ws'), 'error');
            let idr = $('[data-toggle="indicator"]', eleMe);
            let icon = $('i', idr);
            conReady = false;

            icon.attr('class', 'fa-solid fa-circle-exclamation text-danger');
            idr.removeClass('d-none');

            let ttp = bootstrap.Tooltip.getOrCreateInstance(idr[0]);
            ttp.setContent({
                '.tooltip-inner': room.data('lang-error-ws')
            });
            if (wsTimer) {
                clearInterval(wsTimer);
            }
        };

        // Kết nối thành công
        ws.onopen = () => {
            debug && console.log('Connected to Signaling server');
            conReady = true;
            ws.send(JSON.stringify({
                type: 'register',
                room: room.data('room-id'),
                data: me
            }));
            // Ping định kì 30s để duy trì kết nối websocket
            wsTimer = setInterval(() => {
                if (!conReady) {
                    return;
                }
                ws.send('0');
            }, 30000);
        };

        // Đóng kết nối
        ws.onclose = () => {
            debug && console.log('Disconnected from Signaling server');

            if (conReady) {
                conReady = false;
                nvToast(room.data('lang-closed-ws'), 'error');
                let idr = $('[data-toggle="indicator"]', eleMe);
                let icon = $('i', idr);
                icon.attr('class', 'fa-solid fa-circle-exclamation text-danger');
                idr.removeClass('d-none');

                let ttp = bootstrap.Tooltip.getOrCreateInstance(idr[0]);
                ttp.setContent({
                    '.tooltip-inner': room.data('lang-closed-ws')
                });
            }
            if (wsTimer) {
                clearInterval(wsTimer);
            }
        };

        // Khi nhận từ server
        ws.onmessage = event => {
            debug && console.log('Received from Signaling server: ', event.data);
            let json;
            try {
                json = JSON.parse(event.data);
            } catch (err) {
                // Message không là json thì không xử lý
                return;
            }
            if (json.type == "clientsList") {
                // Build danh sách các client
                let clients = [];
                json.data.forEach(client => {
                    if (client.uuid == me.uuid) {
                        return;
                    }
                    clients.push(client.uuid);
                    if ($('#' + client.uuid).length > 0) {
                        return;
                    }
                    html = `
                    <div class="peer" id="`+ client.uuid +`" data-name="`+ client.name +`" data-peer-id="`+ client.uuid +`" data-toggle="peer">
                        <div class="avatar" data-bs-toggle="popover" data-bs-content="C" data-bs-title="T" data-bs-trigger="manual" data-bs-html="true" data-bs-sanitize="false">
                            <img alt="` + client.name + `" src="` + client.avatar + `">
                        </div>
                        <div class="user-info">
                            <div class="user-ip text-truncate">
                                <span data-toggle="indicator" class="d-none" data-bs-toggle="tooltip" data-bs-trigger="hover" data-bs-title="TT"><i class="fa-solid fa-ban"></i></span>
                                <span>`+ client.name +`</span>
                            </div>
                        </div>
                        <input data-toggle="iptfile" type="file">
                    </div>`;
                    eleOthers.append(html);
                });
                $('.peer', eleOthers).each(function() {
                    if (clients.indexOf($(this).data('peer-id')) == -1) {
                        cleanChannelTransfer($(this).data('peer-id'));
                        $(this).remove();
                    }
                });
                return;
            }
            if (json.type == 'offer') {
                // Nhận offer của một client khác
                if (!json.from || !json.to || json.to != me.uuid || cReceiver[json.from]) {
                    // Json lỗi hoặc đang nhận offer hoặc không phải gửi đến tôi thì dừng
                    return;
                }
                let peer_id = json.from;
                let peerCtn = $('#' + peer_id);
                if (!peerCtn.length) {
                    return;
                }

                debug && console.log('Receive offer, create RTC connection to communicate and show promt to accept');

                // Tạo connection trả lời đối tác
                cReceiver[peer_id] = json;
                cReceiver[peer_id].accepted = false; // Tạo kết nối nhưng đánh dấu trạng thái là chưa chấp nhận
                cReceiver[peer_id].conn = new RTCPeerConnection(rtcConfig);
                cReceiver[peer_id].conn.ondatachannel = event => {
                    cReceiver[peer_id].channel = event.channel;
                    cReceiver[peer_id].receivedBuffer = [];
                    cReceiver[peer_id].receivedSize = 0;
                    cReceiver[peer_id].lastReceivedSize = 0;
                    cReceiver[peer_id].receivedSpeed = 0;
                    cReceiver[peer_id].intervalId = null;

                    cReceiver[peer_id].channel.onopen = () => {
                        debug && console.log('Data channel receive is open');
                        if (!cReceiver[peer_id].accepted) {
                            return;
                        }

                        // Thay đổi popover sang trạng thái nhận
                        bootstrap.Popover.getOrCreateInstance($('.avatar', peerCtn)[0]).dispose();
                        const po = bootstrap.Popover.getOrCreateInstance($('.avatar', peerCtn)[0], {
                            html: true,
                            sanitize: false
                        });
                        po.setContent({
                            '.popover-header': room.data('lang-status4'),
                            '.popover-body': `
                            <div class="progress fw-175" role="progressbar" aria-label="` + room.data('lang-status4') + `" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100">
                                <div class="progress-bar bg-success" style="width: 0%;"></div>
                            </div>
                            <div class="mt-2" data-toggle="progress">` + sprintf(room.data('lang-status2'), '0b', cReceiver[peer_id].file.size_show, '0b/s') + `</div>
                            `
                        });
                        po.show();

                        // Đo tốc độ nhận
                        cReceiver[peer_id].intervalId = setInterval(() => {
                            let avt = $('.avatar', peerCtn);
                            let poId = avt.attr('aria-describedby');
                            let poCtn = [];
                            if (poId) {
                                poCtn = $('#' + poId);
                            }
                            cReceiver[peer_id].receivedSpeed = cReceiver[peer_id].receivedSize - cReceiver[peer_id].lastReceivedSize;
                            cReceiver[peer_id].lastReceivedSize = cReceiver[peer_id].receivedSize;

                            if (poCtn.length) {
                                let percent = cReceiver[peer_id].receivedSize / cReceiver[peer_id].file.size * 100;
                                $('[role="progressbar"]', poCtn).attr('aria-valuenow', percent);
                                $('.progress-bar', poCtn).css({
                                    width: percent + '%'
                                });
                                $('[data-toggle="progress"]').html(sprintf(room.data('lang-status2'), formatFileSize(cReceiver[peer_id].receivedSize), cReceiver[peer_id].file.size_show, (formatFileSize(cReceiver[peer_id].receivedSpeed) + '/s')));
                            }
                        }, 1000);
                    }
                    cReceiver[peer_id].channel.onclose = () => {
                        debug && console.log('Data channel receive is closed');
                    }
                    cReceiver[peer_id].channel.onmessage = event => {
                        debug && console.log('Data channel Received data: ', event.data);
                        if (!cReceiver[peer_id].accepted) {
                            return;
                        }

                        // Lưu các chunk vào receivedBuffer
                        cReceiver[peer_id].receivedBuffer.push(event.data);
                        cReceiver[peer_id].receivedSize += event.data.byteLength;

                        // Nhận đủ, ghép thành tệp, tải về, hiển thị thông báo đã xong
                        if (cReceiver[peer_id].receivedSize >= cReceiver[peer_id].file.size) {
                            const receivedFile = new Blob(cReceiver[peer_id].receivedBuffer);
                            const downloadLink = document.createElement('a');
                            downloadLink.href = URL.createObjectURL(receivedFile);
                            downloadLink.download = cReceiver[peer_id].file.name;
                            downloadLink.click();
                            delete cReceiver[peer_id].receivedBuffer;

                            // Hiển thị thông báo đã nhận xong
                            if (cReceiver[peer_id].intervalId) {
                                clearInterval(cReceiver[peer_id].intervalId);
                            }

                            // Thay đổi thông báo sang đã nhận xong
                            let avt = $('.avatar', peerCtn);
                            let poId = avt.attr('aria-describedby');
                            let poCtn = [];
                            if (poId) {
                                poCtn = $('#' + poId);
                            }
                            if (poCtn.length) {
                                $('[role="progressbar"]', poCtn).attr('aria-valuenow', 100);
                                $('.progress-bar', poCtn).css({
                                    width: '100%'
                                });
                                $('[data-toggle="progress"]').addClass('text-center').html(`
                                <button type="button" data-toggle="acceptReceiveComplete" data-peer-id="` + peer_id + `" class="btn btn-success btn-sm"><i class="fa-solid fa-check"></i> ` + room.data('lang-status5') + `</button>
                                `);
                            }
                        }
                    }
                };

                // Thu thập ICE candidates
                cReceiver[peer_id].conn.onicecandidate = event => {
                    if (event.candidate) {
                        debug && console.log('Connection receive candidate: ', event.candidate);
                        ws.send(JSON.stringify({
                            type: 'candidate',
                            candidate: event.candidate,
                            from: me.uuid,
                            from_name: me.name,
                            to: peer_id
                        }));
                    }
                };

                // Debug trạng thái của ICE
                cReceiver[peer_id].conn.oniceconnectionstatechange = () => {
                    debug && console.log('Connection receive ICE Connection State: ', cReceiver[peer_id].conn.iceConnectionState);
                }

                // Hiển thị promt để xác nhận
                const po = bootstrap.Popover.getOrCreateInstance($('.avatar', peerCtn)[0], {
                    html: true,
                    sanitize: false
                });
                po.setContent({
                    '.popover-header': room.data('lang-confirm3'),
                    '.popover-body': `
                    <div>` + sprintf(room.data('lang-confirm5'), json.from_name, json.file.name, json.file.size_show) + `</div>
                    <div class="mt-2 hstack gap-2 justify-content-end">
                        <button data-toggle="acceptReceive" data-peer-id="` + json.from + `" type="button" class="btn btn-sm btn-success"><i class="fa-solid fa-check"></i> ` + room.data('lang-yes') + `</button>
                        <button data-toggle="cancelReceive" data-peer-id="` + json.from + `" type="button" class="btn btn-sm btn-secondary"><i class="fa-solid fa-xmark text-danger"></i> ` + room.data('lang-no') + `</button>
                    </div>
                    `
                });
                po.show();
                return;
            }
            if (json.type == 'answer') {
                if (!json.from || !json.to || json.to != me.uuid || !cTransfer[json.from] || !cTransfer[json.from].conn || !cTransfer[json.from].channel) {
                    // Json lỗi hoặc đang nhận offer hoặc không phải gửi đến tôi thì dừng
                    return;
                }

                debug && console.log('Receive answer, begin send file');
                cTransfer[json.from].conn.setRemoteDescription(new RTCSessionDescription(json.sdp));
                return;
            }
            if (json.type == 'candidate') {
                /**
                 * Nhận candidate bên người gửi gửi cho, gắn vào kết nối nhận
                 * Hoặc
                 * Nhận candidate bên người nhận truyền ngược lại cho người gửi gắn vào kết nối gửi
                 * ICE candidate diễn ra 2 chiều nhằm 2 kết nối tìm đường đến nhau
                 */
                if (!json.from || !json.to || json.to != me.uuid) {
                    // Json lỗi hoặc không phải gửi đến tôi thì dừng
                    return;
                }
                let peer_id = json.from;
                // Chiều gửi > nhận
                if (cReceiver[peer_id] && cReceiver[peer_id].conn) {
                    debug && console.log('Receive candidate from sender, add to receive connection');
                    if (cReceiver[peer_id].conn.remoteDescription) {
                        // Khi đã answer rồi thì gắn trực tiếp
                        cReceiver[peer_id].conn.addIceCandidate(new RTCIceCandidate(json.candidate));
                    } else {
                        // Khi chưa answer thì đưa vào hàng đợi, chờ sự kiện answer sẽ gắn hết vào
                        if (!iceCandidatesQueue[peer_id]) {
                            iceCandidatesQueue[peer_id] = [];
                        }
                        iceCandidatesQueue[peer_id].push(json.candidate);
                    }
                }
                // Chiều nhận > gửi
                if (cTransfer[peer_id] && cTransfer[peer_id].conn) {
                    debug && console.log('Receive candidate from receiver, add to transfer connection');

                    // Chiều nhận > gửi luôn luôn gắn trực tiếp vì kết nối gửi mở trước đó
                    cTransfer[peer_id].conn.addIceCandidate(new RTCIceCandidate(json.candidate));
                }
                return;
            }
            if (json.type == 'reject') {
                // Client từ chối offer của mình
                if (!json.from || json.to != me.uuid || !cTransfer[json.from]) {
                    return;
                }
                let peerCtn = $('#' + json.from);
                if (!peerCtn.length) {
                    return;
                }

                debug && console.log('Receive reject, show promt to notice');

                // Hiển thị promt để thông báo
                bootstrap.Popover.getOrCreateInstance($('.avatar', peerCtn)[0]).dispose();
                const po = bootstrap.Popover.getOrCreateInstance($('.avatar', peerCtn)[0], {
                    html: true,
                    sanitize: false
                });
                po.setContent({
                    '.popover-header': room.data('lang-confirm3'),
                    '.popover-body': `
                    <div>` + sprintf(room.data('lang-confirm6'), json.from_name) + `</div>
                    <div class="mt-2 hstack gap-2 justify-content-end">
                        <button data-toggle="acceptReject" data-peer-id="` + json.from + `" type="button" class="btn btn-sm btn-success"><i class="fa-solid fa-check"></i> ` + room.data('lang-confirm') + `</button>
                    </div>
                    `
                });
                po.show();
                return;
            }
            if (json.type == 'cancel_offer') {
                // Client hủy offer đang đợi mình chấp nhận
                if (!json.from || !json.to || json.to != me.uuid || !cReceiver[json.from]) {
                    // Json lỗi hoặc không có offer hoặc không phải gửi đến tôi thì dừng
                    return;
                }
                let peerCtn = $('#' + json.from);
                if (!peerCtn.length) {
                    return;
                }

                debug && console.log('Receive cancel_offer, show promt to notice');

                // Hiển thị promt để xác nhận
                bootstrap.Popover.getOrCreateInstance($('.avatar', peerCtn)[0]).dispose();
                const po = bootstrap.Popover.getOrCreateInstance($('.avatar', peerCtn)[0], {
                    html: true,
                    sanitize: false
                });
                po.setContent({
                    '.popover-header': room.data('lang-confirm3'),
                    '.popover-body': `
                    <div>` + sprintf(room.data('lang-confirm7'), json.from_name) + `</div>
                    <div class="mt-2 hstack gap-2 justify-content-end">
                        <button data-toggle="acceptCancelOffer" data-peer-id="` + json.from + `" type="button" class="btn btn-sm btn-success"><i class="fa-solid fa-check"></i> ` + room.data('lang-confirm') + `</button>
                    </div>
                    `
                });
                po.show();
                return;
            }
            debug && console.warn('Unknow message type: ' + json.type);
        };

        // Dừng event click vào peer khi chọn tệp tin
        $('body').on('click', '[data-toggle="iptfile"]', function(e) {
            debug && console.log('File browse start');
            e.stopPropagation();
        });

        // Xử lý event khi chọn tệp tin để gửi
        $('body').on('change', '[data-toggle="iptfile"]', function(e) {
            debug && console.log('File change');
            e.stopPropagation();

            let ipt = this;
            let peerCtn = $(ipt).closest('.peer');
            if (ipt.files.length < 1) {
                return;
            }
            const fi = ipt.files[0];

            // Khởi tạo đối tượng tryền để xử lý
            cTransfer[peerCtn.data('peer-id')] = {
                peer_id: peerCtn.data('peer-id'),
                peer_name: peerCtn.data('name'),
                file: {
                    name: fi.name,
                    size: fi.size,
                    size_show: formatFileSize(fi.size)
                }
            };
            debug && console.log('Init file transfer to peer: ', cTransfer[peerCtn.data('peer-id')]);

            const po = bootstrap.Popover.getOrCreateInstance($('.avatar', peerCtn)[0], {
                html: true,
                sanitize: false
            });
            po.setContent({
                '.popover-header': room.data('lang-confirm2'),
                '.popover-body': `
                <div>` + sprintf(room.data('lang-confirm1'), fi.name, formatFileSize(fi.size), peerCtn.data('name')) + `</div>
                <div class="mt-2 hstack gap-2 justify-content-end">
                    <button data-toggle="acceptSend" data-peer-id="` + peerCtn.data('peer-id') + `" type="button" class="btn btn-sm btn-success"><i class="fa-solid fa-check"></i> ` + room.data('lang-yes') + `</button>
                    <button data-toggle="cancelSend" data-peer-id="` + peerCtn.data('peer-id') + `" type="button" class="btn btn-sm btn-secondary"><i class="fa-solid fa-xmark text-danger"></i> ` + room.data('lang-no') + `</button>
                </div>
                `
            });
            po.show();
        });

        // Click chấp nhận gửi, tạo connection và channel gửi
        $('body').on('click', '[data-toggle="acceptSend"]', function(e) {
            debug && console.log('acceptSend, create new peerConnection for fileTransfer');
            e.preventDefault();
            e.stopPropagation();

            // Bắt đầu tạo kênh và gửi offer lên server để chờ đối tác chấp nhận
            let btn = $(this);
            let peer_id = btn.data('peer-id');
            let peerCtn = $('#' + peer_id);

            btn.prop('disabled', true);

            cTransfer[peer_id].conn = new RTCPeerConnection(rtcConfig);
            cTransfer[peer_id].channel = cTransfer[peer_id].conn.createDataChannel('fileTransfer');
            cTransfer[peer_id].channel.onopen = () => {
                debug && console.log('Data channel transfer is open');

                // Gửi tệp qua chunk sau khi channel đã sẵn sàng mở kết nối
                cTransfer[peer_id].reader = new FileReader();
                cTransfer[peer_id].offset = 0;
                cTransfer[peer_id].sentSize = 0;
                cTransfer[peer_id].lastSentSize = 0;
                cTransfer[peer_id].sendSpeed = 0;
                cTransfer[peer_id].intervalId = null;
                cTransfer[peer_id].chunkSize = 16 * 1024; // Mỗi chunk có kích thước 16KB
                cTransfer[peer_id].finfo = $('[data-toggle="iptfile"]', peerCtn)[0].files[0];

                cTransfer[peer_id].reader.onload = (event) => {
                    cTransfer[peer_id].channel.send(event.target.result);
                    cTransfer[peer_id].offset += cTransfer[peer_id].chunkSize;
                    cTransfer[peer_id].sentSize += event.target.result.byteLength;

                    // Tiếp tục send chunk cho đến khi xong
                    if (cTransfer[peer_id].offset < cTransfer[peer_id].finfo.size) {
                        readSlice(cTransfer[peer_id].offset);
                    } else {
                        if (cTransfer[peer_id].intervalId) {
                            clearInterval(cTransfer[peer_id].intervalId);
                        }
                        console.log("Send file complete!");
                        let avt = $('.avatar', peerCtn);
                        let poId = avt.attr('aria-describedby');
                        let poCtn = [];
                        if (poId) {
                            poCtn = $('#' + poId);
                        }
                        if (poCtn.length) {
                            $('[role="progressbar"]', poCtn).attr('aria-valuenow', 100);
                            $('.progress-bar', poCtn).css({
                                width: '100%'
                            });
                            $('[data-toggle="progress"]').addClass('text-center').html(`
                            <button type="button" data-toggle="acceptSendComplete" data-peer-id="` + peer_id + `" class="btn btn-success btn-sm"><i class="fa-solid fa-check"></i> ` + room.data('lang-status3') + `</button>
                            `);
                        }
                    }
                };

                const readSlice = (o) => {
                    const slice = cTransfer[peer_id].finfo.slice(o, o + cTransfer[peer_id].chunkSize);
                    cTransfer[peer_id].reader.readAsArrayBuffer(slice);
                };

                // Thay đổi popover sang trạng thái truyền
                bootstrap.Popover.getOrCreateInstance($('.avatar', peerCtn)[0]).dispose();
                const po = bootstrap.Popover.getOrCreateInstance($('.avatar', peerCtn)[0], {
                    html: true,
                    sanitize: false
                });
                po.setContent({
                    '.popover-header': room.data('lang-status1'),
                    '.popover-body': `
                    <div class="progress fw-175" role="progressbar" aria-label="` + room.data('lang-status1') + `" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100">
                        <div class="progress-bar bg-success" style="width: 0%;"></div>
                    </div>
                    <div class="mt-2" data-toggle="progress">` + sprintf(room.data('lang-status2'), '0b', cTransfer[peer_id].file.size_show, '0b/s') + `</div>
                    `
                });
                po.show();
                readSlice(0);

                // Đo tốc độ gửi
                cTransfer[peer_id].intervalId = setInterval(() => {
                    let avt = $('.avatar', peerCtn);
                    let poId = avt.attr('aria-describedby');
                    let poCtn = [];
                    if (poId) {
                        poCtn = $('#' + poId);
                    }
                    cTransfer[peer_id].sendSpeed = cTransfer[peer_id].sentSize - cTransfer[peer_id].lastSentSize;
                    cTransfer[peer_id].lastSentSize = cTransfer[peer_id].sentSize;

                    if (poCtn.length) {
                        let percent = cTransfer[peer_id].sentSize / cTransfer[peer_id].file.size * 100;
                        $('[role="progressbar"]', poCtn).attr('aria-valuenow', percent);
                        $('.progress-bar', poCtn).css({
                            width: percent + '%'
                        });
                        $('[data-toggle="progress"]').html(sprintf(room.data('lang-status2'), formatFileSize(cTransfer[peer_id].sentSize), cTransfer[peer_id].file.size_show, (formatFileSize(cTransfer[peer_id].sendSpeed) + '/s')));
                    }
                }, 1000);
            }
            cTransfer[peer_id].channel.onclose = () => {
                debug && console.log('Data channel transfer is closed');
            }

            /**
             * Thu thập ICE candidates > gửi cho bên nhận. Event này diễn ra ngay sau khi
             * createOffer bên dưới thực hiện, do đó bên nhận khi nhận được offer thì phải mở ngay kết nối nhận
             * để đón candidate. Sau đó mới quyết định answer hay reject
             */
            cTransfer[peer_id].conn.onicecandidate = event => {
                if (event.candidate) {
                    debug && console.log('Connection transfer candidate: ', event.candidate);
                    ws.send(JSON.stringify({
                        type: 'candidate',
                        candidate: event.candidate,
                        from: me.uuid,
                        from_name: me.name,
                        to: peer_id
                    }));
                }
            };

            // Debug trạng thái của ICE
            cTransfer[peer_id].conn.oniceconnectionstatechange = () => {
                debug && console.log('Connection transfer ICE Connection State: ', cTransfer[peer_id].conn.iceConnectionState);
            }

            // Tạo offer gửi cho Signaling server
            cTransfer[peer_id].conn.createOffer().then(offer => {
                return cTransfer[peer_id].conn.setLocalDescription(offer);
            }).then(() => {
                debug && console.log('Send offer: ', cTransfer[peer_id].conn.localDescription);
                ws.send(JSON.stringify({
                    type: 'offer',
                    sdp: cTransfer[peer_id].conn.localDescription,
                    from: me.uuid,
                    from_name: me.name,
                    to: peer_id,
                    file: cTransfer[peer_id].file
                }));

                // Hủy Popover hiện tại và hiển thị nội dung mới
                bootstrap.Popover.getOrCreateInstance($('.avatar', peerCtn)[0]).dispose();
                const po = bootstrap.Popover.getOrCreateInstance($('.avatar', peerCtn)[0], {
                    html: true,
                    sanitize: false
                });
                po.setContent({
                    '.popover-header': room.data('lang-confirm3'),
                    '.popover-body': `
                    <div>` + sprintf(room.data('lang-confirm4'), cTransfer[peer_id].peer_name) + `</div>
                    <div class="mt-2 hstack gap-2 justify-content-end">
                        <button data-toggle="cancelSend" data-peer-id="` + peerCtn.data('peer-id') + `" type="button" class="btn btn-sm btn-secondary"><i class="fa-solid fa-xmark text-danger"></i> ` + room.data('lang-cancel-request') + `</button>
                    </div>
                    `
                });
                po.show();
            });
        });

        // Event hủy gửi (hủy trước khi xảy ra offer)
        $('body').on('click', '[data-toggle="cancelSend"]', function(e) {
            debug && console.log('cancelSend');
            e.preventDefault();
            e.stopPropagation();

            // Gửi message hủy offer để Signaling Server thông báo cho người nhận offer trước đó
            ws.send(JSON.stringify({
                type: 'cancel_offer',
                from: me.uuid,
                from_name: me.name,
                to: $(this).data('peer-id')
            }));

            // Dọn dẹp
            cleanChannelTransfer($(this).data('peer-id'));
        });

        // Click chấp nhận offer (người nhận)
        $('body').on('click', '[data-toggle="acceptReceive"]', function(e) {
            debug && console.log('acceptReceive (answer)');
            e.preventDefault();
            e.stopPropagation();

            let btn = $(this);
            let peer_id = btn.data('peer-id');

            btn.prop('disabled', true);

            if (cReceiver[peer_id].file.size > (100 * 1024 * 1024)) {
                // FIXME tệp quá lớn, làm sau
                nvToast('Tệp tin này có dung lượng lớn hơn 100MB. Chúng tôi đang phát triển tính năng nhận tệp tin lớn. Tạm thời chưa khả dụng', 'warning');
                return;
            }

            // Đánh dấu đã xác nhận
            cReceiver[peer_id].accepted = true;

            // Gắn SDP bên người gửi vào kết nối nhận, tạo SDP trả lại bên người gửi
            cReceiver[peer_id].conn.setRemoteDescription(new RTCSessionDescription(cReceiver[peer_id].sdp)).then(() => {
                return cReceiver[peer_id].conn.createAnswer();
            }).then(answer => {
                return cReceiver[peer_id].conn.setLocalDescription(answer);
            }).then(() => {
                // Gửi SDP answer lại cho người gửi qua signaling server
                debug && console.log('Send answer: ', cReceiver[peer_id].conn.localDescription);
                ws.send(JSON.stringify({
                    type: 'answer',
                    sdp: cReceiver[peer_id].conn.localDescription,
                    from: me.uuid,
                    from_name: me.name,
                    to: peer_id
                }));

                // Sau khi remote description được thiết lập, thêm các ICE candidates đã lưu nếu có
                if (iceCandidatesQueue[peer_id]) {
                    iceCandidatesQueue[peer_id].forEach(candidate => {
                        cReceiver[peer_id].conn.addIceCandidate(new RTCIceCandidate(candidate));
                    });
                    delete iceCandidatesQueue[peer_id];
                }
            });
        });

        // Click từ chối offer (người nhận)
        $('body').on('click', '[data-toggle="cancelReceive"]', function(e) {
            debug && console.log('Reject offer');
            e.preventDefault();
            e.stopPropagation();

            // Gửi message từ chối để Signaling Server phân phát cho người đề nghị
            ws.send(JSON.stringify({
                type: 'reject',
                from: me.uuid,
                from_name: me.name,
                to: $(this).data('peer-id')
            }));

            // Dọn dẹp
            cleanChannelReceiver($(this).data('peer-id'));
        });

        // Click xác nhận client đã từ chối yêu cầu (người gửi)
        $('body').on('click', '[data-toggle="acceptReject"]', function(e) {
            debug && console.log('acceptReject, clean transfer channel');
            e.preventDefault();
            e.stopPropagation();
            // Dọn dẹp
            cleanChannelTransfer($(this).data('peer-id'));
        });

        // Click xác nhận client đã hủy yêu cầu (người gửi)
        $('body').on('click', '[data-toggle="acceptCancelOffer"]', function(e) {
            debug && console.log('acceptCancelOffer, clean transfer channel');
            e.preventDefault();
            e.stopPropagation();
            // Dọn dẹp
            cleanChannelTransfer($(this).data('peer-id'));
        });

        // Click xác nhận đã gửi xong (người gửi)
        $('body').on('click', '[data-toggle="acceptSendComplete"]', function(e) {
            debug && console.log('acceptSendComplete, clean transfer channel');
            e.preventDefault();
            e.stopPropagation();
            // Dọn dẹp
            cleanChannelTransfer($(this).data('peer-id'));
        });

        // Click xác nhận đã nhận xong (người nhận)
        $('body').on('click', '[data-toggle="acceptReceiveComplete"]', function(e) {
            debug && console.log('acceptReceiveComplete, clean receiver channel');
            e.preventDefault();
            e.stopPropagation();
            // Dọn dẹp
            cleanChannelReceiver($(this).data('peer-id'));
        });

        // Click vào đối tác, kiểm tra và chọn tệp tin
        $('body').on('click', '[data-toggle="peer"]', function() {
            debug && console.log('Peer click');
            if (!conReady) {
                nvToast(room.data('lang-error-ws'), 'error');
                return;
            }
            let pr = $(this);

            // Click vào đối tác đang trong quá trình thao tác (truyền hoặc nhận) thì không làm gì
            if (cTransfer[pr.data('peer-id')] || cReceiver[pr.data('peer-id')]) {
                return;
            }

            // Đối tác rỗng thì bắt đầu mở chọn file để gửi
            $('[data-toggle="iptfile"]', pr)[0].click();
        });
    }
});
