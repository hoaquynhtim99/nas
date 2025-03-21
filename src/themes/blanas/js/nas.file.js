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
    let fmn = $('#nasFileManager');
    if (!fmn.length) {
        return;
    }

    function isMobile() {
        return 'ontouchstart' in window || navigator.maxTouchPoints > 0;
    }

    function calculateTimeFraction(timeLeft, time_limit) {
        var rawTimeFraction = timeLeft / time_limit;
        return rawTimeFraction - (1 / time_limit) * (1 - rawTimeFraction);
    }

    function getCircleDasharray(timeLeft, time_limit) {
        return (calculateTimeFraction(timeLeft, time_limit) * 283).toFixed(0) + " 283";
    }

    // Lấy tọa độ chuột từ event
    function getMousePositionFromEvent(event) {
        let mouseX, mouseY;

        if (event.changedTouches && event.changedTouches[0] && event.changedTouches[0].clientY > 0) {
            mouseX = event.changedTouches[0].clientX;
            mouseY = event.changedTouches[0].clientY;
        } else if (event.originalEvent && typeof event.originalEvent.detail == 'object') {
            mouseX = event.originalEvent.detail.clientX;
            mouseY = event.originalEvent.detail.clientY;
        } else if (event.originalEvent && event.originalEvent.clientX) {
            mouseX = event.originalEvent.clientX;
            mouseY = event.originalEvent.clientY;
        } else if (event.clientX) {
            mouseX = event.clientX;
            mouseY = event.clientY;
        } else {
            nvToast('Error get mouse position!!!', 'error');
            return [false, false];
        }
        if (mouseX < 0) {
            mouseX = 0;
        }
        if (mouseY < 0) {
            mouseY = 0;
        }
        return [mouseX, mouseY];
    }

    // Hiển thị menu tùy thuộc vị trí con trỏ chuột
    function showMenuDependingMouse(menu, mouseX, mouseY) {
        menu.css({
            ///transform: 'translate(' + mouseX + 'px, ' + mouseY + 'px)',
            transform: 'translate(0px, 0px)',
            left: -9999,
            top: -9999,
        });
        menu.addClass('show');
        let mW = menu.innerWidth();
        let mH = menu.innerHeight();
        let wW = $(window).width();
        let wH = $(window).height();
        let tranX = mouseX, tranY = mouseY;

        if (tranX + 10 + mW > wW) {
            tranX -= (tranX + 10 + mW) - wW;
        }
        if (tranY + 10 + mH > wH) {
            tranY -= (tranY + 10 + mH) - wH;
        }

        menu.css({
            transform: 'translate(' + tranX + 'px, ' + tranY + 'px)',
            left: 0,
            top: 0,
        });
    }

    function initfolderPS() {
        return new PerfectScrollbar('#nasFileManagerFolders', {
            wheelPropagation: false
        });
    }
    function initfilePS() {
        return new PerfectScrollbar('#nasFileManagerFiles', {
            wheelPropagation: false
        });
    }
    function initupPS() {
        return new PerfectScrollbar('#nasLocalUploadScroller', {
            wheelPropagation: false
        });
    }
    let folderPS = initfolderPS();
    let filePS = initfilePS();
    let upPS = initupPS();
    let fdCtn = $('#nasFileManagerFolders');
    let fiCtn = $('#nasFileManagerFiles');
    let fdMenu = $('#nasFileManagerFolderMenus');
    let fiMenu = $('#nasFileManagerFileMenus');
    let mdFolderCt = $('#mdCreateFolder');
    let mdUpRemote = $('#mdUploadRemote');
    let uploader = false;
    let upScroller = $('#nasLocalUploadScroller');
    let upItemsCtn = $('#nasLocalUploadItems');
    let upCtn = $('#nasLocalUpload');
    let userGesture = 0;
    let frmSearch = $('#nasFileManagerSearch');
    let mdRename = $('#mdRename');

    let longPress = 0;
    let lastTouchTime = 0;
    let doubleTap = false;

    // Xử lý cuộn danh sách file lên, xuống khi kéo thả ra bên ngoài container của nó
    let scHand = false;
    let scHandStart = {};
    let scLast = 0;
    let scTimer;
    let slableState = false;
    function scGoUp() {
        let cte = false;
        if (fiCtn[0].scrollTop > 25) {
            fiCtn[0].scrollTop -= 25;
            cte = true;
        } else if (fiCtn[0].scrollTop > 0) {
            fiCtn[0].scrollTop -= fiCtn[0].scrollTop;
            cte = true;
        }
        if (cte && scHand) {
            scTimer = setTimeout(() => {
                scGoUp();
            }, 200);
        }
    }
    function scGoDown() {
        let cte = false;
        let max = fiCtn[0].scrollHeight - fiCtn[0].clientHeight;
        if (fiCtn[0].scrollTop < max - 25) {
            fiCtn[0].scrollTop += 25;
            cte = true;
        } else {
            let am = max - fiCtn[0].scrollTop;
            if (am > 0) {
                fiCtn[0].scrollTop += am;
                cte = true;
            }
        }
        if (cte && scHand) {
            scTimer = setTimeout(() => {
                scGoDown();
            }, 200);
        }
    }
    document.addEventListener('mousemove', function(event) {
        let cTime = (new Date().getTime());
        if (!scHand || cTime - scLast < 200) {
            return;
        }
        clearTimeout(scTimer);
        scLast = cTime;
        let mPos = getMousePositionFromEvent(event);
        let fiTop = (fiCtn[0].getBoundingClientRect().top + (window.pageYOffset || document.documentElement.scrollTop));
        if (scHandStart.y > fiTop && mPos[1] < fiTop) {
            scGoUp();
        }
        if (mPos[1] > (fiTop + fiCtn.height())) {
            scGoDown();
        }
    });

    // Xử lý kéo thả chuột để chọn file
    if (!isMobile()) {
        $('.file-manager-content').selectable({
            //appendTo: '.file-manager-content',
            cancel: '.file-item-selectable,select,input,button,[data-toggle="driveName"],.pagination-wrap',
            filter: '.file-item-selectable',
            start: (event) => {
                $('body').css('overflow', 'hidden');
                let m = getMousePositionFromEvent(event);
                scHandStart = {
                    x: m[0],
                    y: m[1]
                }
                scHand = true;
                hideFolderMenu();
                hideFileMenu();
                bootstrap.Dropdown.getOrCreateInstance($('[data-toggle="btnCreateMenu"]', fmn)[0]).hide();
            },
            stop: () => {
                $('body').css('overflow', '');
                scHand = false;
            },
            selecting: () => {
                slableState = true;
            },
            /*selected: (event, ui) => {
                $(ui.selected).data('selected', 1);
            },
            unselected: (event, ui) => {
                $(ui.selected).data('selected', 0);
            }*/
        });
    }

    // Xử lý single click 1 file
    $(document).on('click', '.file-item-selectable', function() {
        //$('.file-item-selectable', fmn).removeClass('ui-selected');
        //$(this).addClass('ui-selected');
    });

    // Load danh sách tập tin qua ajax
    function refreshFiles(url, sort, callback) {
        if (typeof callback == 'undefined') {
            callback = () => {};
        }
        if (url) {
            url += ((url.indexOf('?') < 0 ? '?' : '&') + 'nocache=' + new Date().getTime());
        } else {
            let q = trim($('input', frmSearch).val());
            url = nv_base_siteurl + 'index.php?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=' + nv_func_name;
            url += '&folder_id=' + fmn.data('folder-id');
            url += '&drive=' + fmn.data('drive');
            if (q != '') {
                url += '&q=' + encodeURIComponent(q);
            }
            url += '&type=' + $('[name="filterType"]', fmn).val();
            url += '&sort=' + $('[name="filterSort"]', fmn).val();
            if (sort) {
                url += '&change_sort=1';
            }
            url += '&nocache=' + new Date().getTime();
        }
        url += '&checkss=' + fmn.data('checkss');
        $('[data-toggle="filesLoaderOuter"]', fmn).addClass('loading');
        $('[data-toggle="filesLoader"]', fmn).removeClass('d-none');
        $.ajax({
            type: 'GET',
            url: url,
            dataType: 'json',
            cache: false,
            success: function(respon) {
                $('[data-toggle="filesLoader"]', fmn).addClass('d-none');
                $('[data-toggle="filesLoaderOuter"]', fmn).removeClass('loading');
                if (!respon.success) {
                    nvToast(respon.text, 'error');
                    return;
                }
                $('#nasFileManagerFilesElements').html(respon.html);
                callback();
                $('[data-toggle="driveName"]', fmn).text(respon.drive_name);
                fiCtn[0].scrollTop = 0;
                if (filePS !== false) {
                    filePS.update();
                }
            },
            error: function(xhr, text, err) {
                $('[data-toggle="filesLoader"]', fmn).addClass('d-none');
                $('[data-toggle="filesLoaderOuter"]', fmn).removeClass('loading');
                nvToast(err, 'error');
                console.log(xhr, text, err);
            }
        });
    }

    // Xử lý load thư mục đó ra
    fdCtn.on('click', 'a', function(e) {
        e.preventDefault();
        let folder = $(this);
        if (folder.is('.folder-tree-collapse')) {
            return;
        }

        fmn.data('folder-id', folder.data('folder-id'));
        fmn.data('drive', folder.data('drive'));
        $('[data-toggle="btnCreateMenu"]', fmn).prop('disabled', !(folder.data('drive') == '' || folder.data('drive') == 'drive'));

        $('li', fdCtn).removeClass('active');
        folder.closest('li').addClass('active');

        // Click thư mục thì reset bộ lọc về tất cả
        $('[name="filterType"]', fmn).val('all');

        if (folder.data('drive') == 'history') {
            // Gần đây thì chuyển sắp xếp về gần đây
            $('[name="filterSort"]', fmn).val('edit_desc');
            fmn.data('sort-request', 'edit_desc');
        } else if (fmn.data('sort-request') != fmn.data('sort-user')) {
            // Nếu kiểu sắp xếp hiện tại khác với kiểu của user và request đó không lưu DB thì đổi lại về của user
            $('[name="filterSort"]', fmn).val(fmn.data('sort-user'));
            fmn.data('sort-request', fmn.data('sort-user'));
        }

        locationReplace(folder.attr('href'));
        $('[data-toggle="folderSidebar"]').removeClass('show');
        $('input', frmSearch).val('');
        refreshFiles(null, null, () => {
            if (folder.data('view-type') == 'grid') {
                $('[data-toggle="changeViewTypeCtn"]').addClass('d-none');
                $('#nasFileManagerFilesOuter').addClass('force-grid');
            } else {
                $('[data-toggle="changeViewTypeCtn"]').removeClass('d-none');
                $('#nasFileManagerFilesOuter').removeClass('force-grid');
            }
        });
    });

    // Xử lý icon khi đóng mở thư mục
    $('[data-toggle="collapseFolder"]', fdCtn).on('hidden.bs.collapse', function(e) {
        debug && console.log('Event folder tree collapsed', e);
        if (!$(e.currentTarget).is('.show')) {
            $(this).closest('li').removeClass('open');
        }
    });
    $('[data-toggle="collapseFolder"]', fdCtn).on('show.bs.collapse', function(e) {
        debug && console.log('Event folder tree open', e);
        $(this).closest('li').addClass('open');
    });

    // Xử lý mở menu thư mục khi chuột phải hoặc nhấn (touch) giữ >=500ms
    function getFolderMenu(folder, event) {
        let [mouseX, mouseY] = getMousePositionFromEvent(event);
        if (mouseX === false) {
            return;
        }

        let html = '<li><div class="dropdown-header text-truncate" title="' + folder.data('title') + '">' + folder.data('title') + '</div></li>';
        let tools = 0;
        if (folder.data('drive') == 'drive' || folder.data('drive') == '') {
            // Tạo thư mục con
            html += `<li>
                <a class="dropdown-item" href="#"
                    data-toggle="createFolder" data-folder-id="` + folder.data('folder-id') + `"
                >
                    <i class="fa-solid fa-folder-plus fa-fw text-center text-muted" data-icon="fa-folder-plus"></i> ` + fmn.data('lang-create-folder-sub') + `
                </a>
            </li>`;
            tools++;

            // Đổi tên
            html += `<li>
                <a class="dropdown-item" href="#"
                    data-toggle="renameNode" data-id="` + folder.data('folder-id') + `"
                    data-title="` + folder.data('title') + `"
                >
                    <i class="fa-solid fa-pen fa-fw text-center text-muted" data-icon="fa-pen"></i> ` + fmn.data('lang-rename') + `
                </a>
            </li>`;
            tools++;

            // Tùy chỉnh
            if (folder.data('folder-id') > 0) {
                html += `<li>
                    <a class="dropdown-item" href="#"
                        data-toggle="settingFolder" data-id="` + folder.data('folder-id') + `"
                        data-title="` + folder.data('title') + `"
                    >
                        <i class="fa-solid fa-gear fa-fw text-center text-muted" data-icon="fa-gear"></i> ` + fmn.data('lang-settings') + `
                    </a>
                </li>`;
                tools++;
            }
        }
        // Bật đồng bộ lên Google Drive
        if (folder.data('folder-id') > 0 && (fmn.data('drive') == 'drive' || fmn.data('drive') == '') && !folder.data('synced') && !folder.data('sync-disabled')) {
            html += `<li>
                <a class="dropdown-item" href="#"
                    data-toggle="syncGoogleDriveFolder" data-folder-id="` + folder.data('folder-id') + `"
                >
                    <i class="fa-brands fa-google-drive fa-fw text-center text-muted" data-icon="fa-google-drive"></i> ` + fmn.data('lang-sync-gdrive') + `
                </a>
            </li>`;
            tools++;
        }
        // Tắt đồng bộ lên Google Drive
        if (folder.data('synced')) {
            html += `<li>
                <a class="dropdown-item" href="#"
                    data-toggle="offSyncGoogleDriveFolder" data-folder-id="` + folder.data('folder-id') + `"
                >
                    <i class="fa-brands fa-google-drive fa-fw text-center text-warning" data-icon="fa-google-drive"></i> ` + fmn.data('lang-sync-off-gdrive') + `
                </a>
            </li>`;
            tools++;
        }
        // Xóa thư mục
        if (folder.data('folder-id') > 0) {
            tools++;
            html += `<li>
                <a class="dropdown-item" href="#"
                    data-toggle="trashNode" data-type="folder" data-id="` + folder.data('folder-id') + `"
                >
                    <i class="fa-solid fa-trash fa-fw text-center text-danger" data-icon="fa-trash"></i> ` + fmn.data('lang-delete') + `
                </a>
            </li>`;
        }
        // Dọn sạch thùng rác
        if (folder.data('drive') == 'trash') {
            html += `<li>
                <a class="dropdown-item" href="#" data-toggle="emptyTrash">
                    <i class="fa-solid fa-ban fa-fw text-center text-danger" data-icon="fa-ban"></i> ` + fmn.data('lang-empty-trash') + `
                </a>
            </li>`;
            tools++;
        }
        if (tools < 1) {
            return;
        }

        event.preventDefault();
        hideFileMenu();
        fdMenu.html(html);
        showMenuDependingMouse(fdMenu, mouseX, mouseY);

        // Dừng không cho cuộn thư mục nữa
        if (folderPS !== false) {
            folderPS.destroy();
            folderPS = false;
        }
    }
    function hideFolderMenu() {
        fdMenu.removeClass('show').html('');
        // Cho cuộn thư mục trở lại
        if (folderPS === false) {
            folderPS = initfolderPS();
        }
    }
    fdCtn.on('contextmenu', 'a', function(e) {
        getFolderMenu($(this), e);
    });
    fdCtn.on('long-press', 'a', function(e) {
        debug && console.log('Fire long-press');
        if (isMobile()) {
            longPress = 1;
            return;
        }
        getFolderMenu($(this), e);
    });
    if (isMobile()) {
        $('a:not(.folder-tree-collapse)', fdCtn).swipe({
            swipeRight: function(event, direction, distance, duration, fingerCount) {
                debug && console.log('Event swipeLeft', event, direction, distance, duration, fingerCount, this);
                getFolderMenu($(this), event);
            },
            threshold: 30
        });
    }

    // Xử lý mở menu tệp tin/thư mục (trong danh sách) khi chuột phải hoặc nhấn (touch) giữ >=500ms ở chế độ grid
    // hoặc ấn vào icon công cụ ở chế độ list
    function getFileMenu(file, event) {
        let [mouseX, mouseY] = getMousePositionFromEvent(event);
        debug && console.log('getFileMenu');
        if (mouseX === false) {
            debug && console.log('Error getMousePositionFromEvent');
            return;
        }

        // Xác định các tệp tin nếu có selectable
        let fileSelected = [];
        $('.ui-selected', fiCtn).each(function() {
            let file = $(this).closest('.file-item');
            fileSelected.push(file.data('id'));
        });

        let titleMenu = file.data('title');
        let multi = false;
        let id = file.data('id');
        if (fileSelected.length > 0) {
            if (fileSelected.includes(file.data('id'))) {
                // Chuột phải vào chính vùng đã chọn thì chấp nhận
                titleMenu = fmn.data('lang-file-selected').replace('%s', fileSelected.length);
                multi = true;
                id = fileSelected.join(',');
            } else {
                // Chuột phải vào tệp khác thì xem như bỏ chọn
                $('.ui-selected', fiCtn).removeClass('ui-selected');
                $('.file-manager-content').selectable('refresh');
                debug && console.log('Unselected other files');
            }
        }

        let html = '<li><div class="dropdown-header text-truncate-2 text-break text-wrap py-0 mt-2 mb-1" title="' + titleMenu + '">' + titleMenu + '</div></li>';
        let tools = 0;
        if (file.data('trash') == 0 && file.data('node-type') == 0 && !multi) {
            // Tải về (file và chưa xóa)
            tools++;
            html += `<li>
                <a class="dropdown-item" href="` + file.data('link-download') + `" data-toggle="downloadFile">
                    <i class="fa-solid fa-download fa-fw text-center text-muted" data-icon="fa-download"></i> ` + fmn.data('lang-download') + `
                </a>
            </li>`;

            // Phát video
            if (['mp4', 'webm', 'ogv', 'avi', 'mkv', 'flv'].includes(file.data('ext'))) {
                tools++;
                html += `<li>
                    <a class="dropdown-item" href="` + file.data('link-download') + `" data-toggle="playVideo"
                        data-title="` + file.data('title') + `"
                        data-width="` + file.data('width') + `"
                        data-height="` + file.data('height') + `"
                    >
                        <i class="fa-solid fa-play fa-fw text-center text-success" data-icon="fa-play"></i> ` + fmn.data('lang-play-video') + `
                    </a>
                </li>`;
            }
            // Tạo lại ảnh bìa
            if (['mp4', 'avi', 'mkv', 'mov', 'wmv', 'flv', 'webm', 'm4v', 'mpg', 'mpeg', '3gp'].includes(file.data('ext')) && file.data('ownership') == 1) {
                tools++;
                html += `<li>
                    <a class="dropdown-item" href="#" data-toggle="recreateCover"
                        data-id="` + id + `" data-title="` + file.data('title') + `"
                    >
                        <i class="fa-solid fa-camera-rotate fa-fw text-center text-muted" data-icon="fa-camera-rotate"></i> ` + fmn.data('lang-recreate-cover') + `
                    </a>
                </li>`;
            }
        }
        // Truy cập thư mục con
        if ((fmn.data('drive') == '' || fmn.data('drive') == 'drive') && file.data('node-type') == 1 && !multi) {
            tools++;
            html += `<li>
                <a class="dropdown-item" href="` + file.data('link-folder') + `">
                    <i class="fa-solid fa-folder-open fa-fw text-center text-muted" data-icon="fa-folder-open"></i> ` + fmn.data('lang-access') + `
                </a>
            </li>`;
        }
        if (file.data('ownership') == 1 && file.data('trash') == 0 && !multi) {
            // Đổi tên: Quyền sở hữu, chưa xóa và chọn 1 node
            tools++;
            html += `<li>
                <a class="dropdown-item" href="#"
                    data-toggle="renameNode" data-id="` + id + `" data-title="` + file.data('title') + `"
                >
                    <i class="fa-solid fa-pen fa-fw text-center text-muted" data-icon="fa-pen"></i> ` + fmn.data('lang-rename') + `
                </a>
            </li>`;

            if (file.data('node-type') == 0) {
                if (file.data('zone') == 1) {
                    // Hủy zone
                    html += `<li>
                        <a class="dropdown-item" href="#"
                            data-toggle="unZoneNode" data-id="` + id + `" data-title="` + file.data('title') + `"
                        >
                            <i class="fa-solid fa-arrow-down-up-lock fa-fw text-center text-danger" data-icon="fa-arrow-down-up-lock"></i> ` + fmn.data('lang-unzone') + `
                        </a>
                    </li>`;
                } else {
                    // Zone
                    html += `<li>
                        <a class="dropdown-item" href="#"
                            data-toggle="zoneNode" data-mode="temporary" data-id="` + id + `" data-title="` + file.data('title') + `"
                        >
                            <i class="fa-solid fa-globe fa-fw text-center text-muted" data-icon="fa-globe"></i> ` + fmn.data('lang-zone-temporary') + `
                        </a>
                    </li>`;
                    html += `<li>
                        <a class="dropdown-item" href="#"
                            data-toggle="zoneNode" data-mode="permanently" data-id="` + id + `" data-title="` + file.data('title') + `"
                        >
                            <i class="fa-solid fa-earth-asia fa-fw text-center text-muted" data-icon="fa-earth-asia"></i> ` + fmn.data('lang-zone-permanently') + `
                        </a>
                    </li>`;
                }
            }
        }
        // Xóa file
        if (file.data('ownership') == 1 && file.data('trash') == 0) {
            tools++;
            html += `<li>
                <a class="dropdown-item" href="#"
                    data-toggle="trashNode" data-id="` + id + `"
                >
                    <i class="fa-solid fa-trash fa-fw text-center text-danger" data-icon="fa-trash"></i> ` + fmn.data('lang-delete') + `
                </a>
            </li>`;
        }
        // Khôi phục + xóa vĩnh viễn
        if (file.data('trash') > 0) {
            tools++;
            html += `<li>
                <a class="dropdown-item" href="#"
                    data-toggle="untrashNode" data-id="` + id + `"
                >
                    <i class="fa-solid fa-trash-arrow-up fa-fw text-center text-muted" data-icon="fa-trash-arrow-up"></i> ` + fmn.data('lang-untrash') + `
                </a>
            </li>`;
            html += `<li>
                <a class="dropdown-item" href="#"
                    data-toggle="deletePermanentlyNode" data-id="` + id + `"
                >
                    <i class="fa-solid fa-ban fa-fw text-center text-danger" data-icon="fa-ban"></i> ` + fmn.data('lang-delete-permanently') + `
                </a>
            </li>`;
        }
        if (tools < 1) {
            return;
        }

        event.preventDefault();
        hideFolderMenu();
        fiMenu.html(html);
        showMenuDependingMouse(fiMenu, mouseX, mouseY);

        // Dừng không cho cuộn file nữa
        if (filePS !== false) {
            filePS.destroy();
            filePS = false;
        }
    }
    function hideFileMenu() {
        fiMenu.removeClass('show').html('');
        // Cho cuộn thư mục trở lại
        if (filePS === false) {
            filePS = initfilePS();
        }
    }
    fiCtn.on('contextmenu', '.file-item-selectable', function(e) {
        let pr = $(this).parents('#nasFileManagerFilesOuter');
        if (pr.is('.view-list') && !pr.is('.force-grid')) {
            return;
        }
        debug && console.log('Get file menu contextmenu');
        getFileMenu($(this).closest('.file-item'), e);
    });
    fiCtn.on('long-press', '.file-item-selectable', function(e) {
        let pr = $(this).parents('#nasFileManagerFilesOuter');
        if (pr.is('.view-list') && !pr.is('.force-grid')) {
            return;
        }
        debug && console.log('Fire long-press');
        if (isMobile()) {
            longPress = 2;
            return;
        }
        getFileMenu($(this).closest('.file-item'), e);
    });
    fiCtn.on('click', '[data-toggle="menuFile"]', function(e) {
        e.stopPropagation();
        getFileMenu($(this).closest('.file-item'), e);
    });

    /**
     * Xử lý theo dõi click chuột hoặc touch
     * Nguyên nhân trên mobile khi chưa touchend mà long-press đã diễn ra
     * Làm cho dropdown mở lên không focus được, phải nhấp 1 lần nữa giống như double-click
     */
    $(document).on('touchstart', function() {
        debug && console.log('Event touchstart');
        longPress = 0;
        const currentTime = new Date().getTime();
        const timeDifference = currentTime - lastTouchTime;
        if (timeDifference < 300 && timeDifference > 0) {
            debug && console.log('Double tap detected!');
            doubleTap = true;
        }
        lastTouchTime = currentTime;
    });
    $(document).on('touchend', function(e) {
        debug && console.log('Event touchend', e, longPress, doubleTap);

        if (longPress == 2) {
            getFileMenu($(e.target).closest('.file-item'), e);
        } else if (longPress == 1) {
            getFolderMenu($(e.target), e);
        } else if (doubleTap) {
            let file = $(e.target).closest('.file-item');
            if (file.length) {
                if (file.data('node-type') == 1) {
                    // Double nhấp vào thư mục thì mở nó
                    window.location = file.data('link-folder');
                }  else {
                    // Double nhấp vào tệp tin thì mở menu
                    getFileMenu(file, e);
                }
            }
        }

        doubleTap = false;
    });

    // Xử lý các event khi click chuột bất kì đâu
    $(document).on('click', function(e) {
        userGesture = 1;
        let clickModal = !!($(e.target).is('.modal') || $(e.target).closest('.modal').length);
        // Nếu đang mở menu chuột phải thư mục thì đóng
        if (longPress != 1 && fdMenu.is(':visible') && !($(e.target).is(fdMenu) || $(e.target).closest(fdMenu).length) && !clickModal) {
            hideFolderMenu();
        }
        // Nếu đang mở menu chuột phải file thì đóng
        if (longPress != 2 && fiMenu.is(':visible') && !($(e.target).is(fiMenu) || $(e.target).closest(fiMenu).length || $(e.target).is('[data-toggle="menuFile"]')) && !clickModal) {
            hideFileMenu();
        }
        // Không kéo thả mà click thì hủy chọn các tệp đang chọn
        if (!slableState && !clickModal && !($(e.target).is('.file-item-selectable') || $(e.target).closest('.file-item-selectable').length)) {
            $('.file-item-selectable', fmn).removeClass('ui-selected');
        }
        // Thu gọn folder trên thanh mobile khi ấn vào bên ngoài
        if (longPress != 1 && $('[data-toggle="folderSidebar"]', fmn).is('.show') && !fdMenu.is('.show') && !(
            $(e.target).is('[data-toggle="toggleFolder"]') || $(e.target).is('[data-toggle="folderSidebar"]') || $(e.target).closest('[data-toggle="folderSidebar"]').length
        )) {
            $('[data-toggle="folderSidebar"]', fmn).removeClass('show');
        }
        debug && console.log('Event click document', e);
        // Khi kéo thả để chọn tệp tin thì cờ này set lên true, dừng kéo thả set về false
        slableState = false;
        longPress = 0;
    });

    // Tạo thư mục con
    $(document).on('click', '[data-toggle="createFolder"]', function(e) {
        e.preventDefault();
        $('[name="folder_id"]', mdFolderCt).val($(this).data('folder-id'));
        hideFolderMenu();
        (bootstrap.Modal.getOrCreateInstance(mdFolderCt[0])).show();
    });
    mdFolderCt.on('shown.bs.modal', function() {
        $('[name="title"]', mdFolderCt).focus();
    });

    // Tạo thư mục con (nút chính)
    $(document).on('click', '[data-toggle="btnCreateFolder"]', function(e) {
        e.preventDefault();
        $('[name="folder_id"]', mdFolderCt).val(fmn.data('folder-id'));
        (bootstrap.Modal.getOrCreateInstance(mdFolderCt[0])).show();
    });

    // Upload remove (nút chính)
    $(document).on('click', '[data-toggle="btnUploadRemote"]', function(e) {
        e.preventDefault();
        $('[name="folder_id"]', mdUpRemote).val(fmn.data('folder-id'));
        $('[name="title"]', mdUpRemote).val('');
        $('[name="url"]', mdUpRemote).val('');
        (bootstrap.Modal.getOrCreateInstance(mdUpRemote[0])).show();
    });
    mdUpRemote.on('shown.bs.modal', function() {
        $('[name="url"]', mdUpRemote).focus();
    });

    // Đổi kiểu hiển thị danh sách, lưới
    $('[data-toggle="changeViewType"]', fmn).on('click', function(e) {
        e.preventDefault();

        let btn = $(this);
        let icon = $('i', btn);
        if (icon.is('.bx-spin') || btn.data('type') == btn.data('current')) {
            return;
        }
        icon.removeClass(icon.data('icon')).addClass('bx-spin bx-loader');
        $.ajax({
            type: 'POST',
            url: nv_base_siteurl + 'index.php?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=' + nv_func_name + '&nocache=' + new Date().getTime(),
            data: {
                checkss: fmn.data('checkss'),
                change_view_type: btn.data('type')
            },
            dataType: 'json',
            cache: false,
            success: function(respon) {
                icon.removeClass('bx-spin bx-loader').addClass(icon.data('icon'));
                if (!respon.success) {
                    nvToast(respon.text, 'error');
                    return;
                }
                $('[data-toggle="changeViewType"]', fmn).data('current', btn.data('type'));
                if (btn.data('type') == 'grid') {
                    $('[data-toggle="changeViewType"][data-type="grid"]', fmn).removeClass('btn-light').addClass('btn-success');
                    $('[data-toggle="changeViewType"][data-type="list"]', fmn).removeClass('btn-success').addClass('btn-light');
                    $('#nasFileManagerFilesOuter').removeClass('view-list').addClass('view-grid');
                } else {
                    $('[data-toggle="changeViewType"][data-type="grid"]', fmn).removeClass('btn-success').addClass('btn-light');
                    $('[data-toggle="changeViewType"][data-type="list"]', fmn).removeClass('btn-light').addClass('btn-success');
                    $('#nasFileManagerFilesOuter').removeClass('view-grid').addClass('view-list');
                }
                if (filePS !== false) {
                    filePS.update();
                }
            },
            error: function(xhr, text, err) {
                icon.removeClass('bx-spin bx-loader').addClass(icon.data('icon'));
                nvToast(err, 'error');
                console.log(xhr, text, err);
            }
        });
    });

    // Phân trang dạng ajax
    $(document).on('click', '[data-toggle="filePagination"] a', function(e) {
        e.preventDefault();
        let href = $(this).attr('href');
        if (href == '' || href.indexOf('#') >= 0) {
            return;
        }
        locationReplace(href);
        refreshFiles(href);
    });

    // Đổi kiểu sắp xếp tập tin
    $('[name="filterSort"]', fmn).on('change', function() {
        refreshFiles(false, 1);
        fmn.data('sort-request', $(this).val());
        fmn.data('sort-user', $(this).val());
    });

    // Đổi loại tập tin lọc
    $('[name="filterType"]', fmn).on('change', function() {
        refreshFiles();
    });

    // Đánh dấu/bỏ đánh dấu tập tin
    $(document).on('click', '[data-toggle="fileBookmark"]', function(e) {
        e.preventDefault();
        let btn = $(this);
        let icon = $('i', btn);
        if (icon.is('.fa-spinner')) {
            return;
        }
        let file = btn.parents('.file-item');
        icon.removeClass(icon.data('icon')).addClass('fa-spinner fa-spin-pulse');
        $.ajax({
            type: 'POST',
            url: nv_base_siteurl + 'index.php?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=' + nv_func_name + '&nocache=' + new Date().getTime(),
            data: {
                checkss: fmn.data('checkss'),
                bookmark_file: file.data('id')
            },
            dataType: 'json',
            cache: false,
            success: function(respon) {
                icon.removeClass('fa-spinner fa-spin-pulse').addClass(icon.data('icon'));
                if (!respon.success) {
                    nvToast(respon.text, 'error');
                    return;
                }
                if (respon.bookmarked > 0) {
                    icon.removeClass('text-muted').addClass('text-warning');
                } else {
                    icon.removeClass('text-warning').addClass('text-muted');
                }
            },
            error: function(xhr, text, err) {
                icon.removeClass('fa-spinner fa-spin-pulse').addClass(icon.data('icon'));
                nvToast(err, 'error');
                console.log(xhr, text, err);
            }
        });
    });

    // Click nút tải về => Ẩn menu file
    $(document).on('click', '[data-toggle="downloadFile"]', function() {
        hideFileMenu();
    });

    // Xóa thư mục/tệp tin
    $(document).on('click', '[data-toggle="trashNode"]', function(e) {
        e.preventDefault();
        let btn = $(this);
        let icon = $('i', btn);
        if (icon.is('.fa-spinner')) {
            return;
        }
        icon.removeClass(icon.data('icon')).addClass('fa-spinner fa-spin-pulse');
        $.ajax({
            type: 'POST',
            url: nv_base_siteurl + 'index.php?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=' + nv_func_name + '&nocache=' + new Date().getTime(),
            data: {
                checkss: fmn.data('checkss'),
                trash_node: btn.data('id')
            },
            dataType: 'json',
            cache: false,
            success: function(respon) {
                icon.removeClass('fa-spinner fa-spin-pulse').addClass(icon.data('icon'));
                if (!respon.success) {
                    nvToast(respon.text, 'error');
                    return;
                }
                hideFileMenu();
                if (respon.reload) {
                    refreshFiles();
                    return;
                }
                window.location = respon.redirect;
            },
            error: function(xhr, text, err) {
                icon.removeClass('fa-spinner fa-spin-pulse').addClass(icon.data('icon'));
                nvToast(err, 'error');
                console.log(xhr, text, err);
            }
        });
    });

    // Hoàn tác xóa tệp/thư mục
    $(document).on('click', '[data-toggle="untrashNode"]', function(e) {
        e.preventDefault();
        let btn = $(this);
        let icon = $('i', btn);
        if (icon.is('.fa-spinner')) {
            return;
        }
        icon.removeClass(icon.data('icon')).addClass('fa-spinner fa-spin-pulse');
        $.ajax({
            type: 'POST',
            url: nv_base_siteurl + 'index.php?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=' + nv_func_name + '&nocache=' + new Date().getTime(),
            data: {
                checkss: fmn.data('checkss'),
                untrash_node: btn.data('id')
            },
            dataType: 'json',
            cache: false,
            success: function(respon) {
                icon.removeClass('fa-spinner fa-spin-pulse').addClass(icon.data('icon'));
                if (!respon.success) {
                    nvToast(respon.text, 'error');
                    return;
                }
                if (respon.reload) {
                    location.reload();
                    return;
                }
                hideFileMenu();
                refreshFiles();
            },
            error: function(xhr, text, err) {
                icon.removeClass('fa-spinner fa-spin-pulse').addClass(icon.data('icon'));
                nvToast(err, 'error');
                console.log(xhr, text, err);
            }
        });
    });

    // Xóa vĩnh viễn tệp/thư mục
    $(document).on('click', '[data-toggle="deletePermanentlyNode"]', function(e) {
        e.preventDefault();
        let btn = $(this);
        let icon = $('i', btn);
        if (icon.is('.fa-spinner')) {
            return;
        }
        nvConfirm(fmn.data('lang-confirm-permanently'), () => {
            icon.removeClass(icon.data('icon')).addClass('fa-spinner fa-spin-pulse');
            $.ajax({
                type: 'POST',
                url: nv_base_siteurl + 'index.php?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=' + nv_func_name + '&nocache=' + new Date().getTime(),
                data: {
                    checkss: fmn.data('checkss'),
                    delete_permanently_node: btn.data('id')
                },
                dataType: 'json',
                cache: false,
                success: function(respon) {
                    icon.removeClass('fa-spinner fa-spin-pulse').addClass(icon.data('icon'));
                    if (!respon.success) {
                        nvToast(respon.text, 'error');
                        return;
                    }
                    hideFileMenu();
                    refreshFiles();
                },
                error: function(xhr, text, err) {
                    icon.removeClass('fa-spinner fa-spin-pulse').addClass(icon.data('icon'));
                    nvToast(err, 'error');
                    console.log(xhr, text, err);
                }
            });
        });
    });

    // Làm rỗng thùng rác
    $(document).on('click', '[data-toggle="emptyTrash"]', function(e) {
        e.preventDefault();
        let btn = $(this);
        let icon = $('i', btn);
        if (icon.is('.fa-spinner')) {
            return;
        }
        nvConfirm(fmn.data('lang-confirm-permanently'), () => {
            icon.removeClass(icon.data('icon')).addClass('fa-spinner fa-spin-pulse');
            $.ajax({
                type: 'POST',
                url: nv_base_siteurl + 'index.php?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=' + nv_func_name + '&nocache=' + new Date().getTime(),
                data: {
                    checkss: fmn.data('checkss'),
                    empty_trash: 1
                },
                dataType: 'json',
                cache: false,
                success: function(respon) {
                    icon.removeClass('fa-spinner fa-spin-pulse').addClass(icon.data('icon'));
                    if (!respon.success) {
                        nvToast(respon.text, 'error');
                        return;
                    }
                    hideFolderMenu();
                    refreshFiles();
                },
                error: function(xhr, text, err) {
                    icon.removeClass('fa-spinner fa-spin-pulse').addClass(icon.data('icon'));
                    nvToast(err, 'error');
                    console.log(xhr, text, err);
                }
            });
        });
    });

    /**
     * Xử lý upload local
     */
    // Cuộn xuống cuối khung upload
    function upScrollBottom() {
        upScroller[0].scrollTop = (upScroller[0].scrollHeight - upScroller[0].clientHeight);
        upPS.update();
    }

    // Hiển thị hoặc ẩn queue nếu nó có item trong đó
    function upHandlerQueue() {
        let num = $('li', upItemsCtn).length;
        if (num > 0) {
            upCtn.removeClass('d-none');
            upScroller.removeClass('minimized');
            $('[data-toggle="minimizeUploader"]', fmn).removeClass('minimized');
        } else {
            upCtn.addClass('d-none');
        }
    }

    // Xử lý status của mỗi file
    function upHandlerFileStatus(file, message) {
        let eFile = $('#' + file.id);
        eFile.removeClass('status-pending');

        if (file.status == plupload.UPLOADING) {
            $('[data-toggle="up-item-percent-path"]', eFile).attr('stroke-dasharray', getCircleDasharray(file.percent, 100));
            if (!eFile.is('.status-uploading')) {
                eFile.addClass('status-uploading');
            }
        } else if (file.status == plupload.FAILED) {
            eFile.removeClass('status-uploading');
            if (!eFile.is('.status-failed')) {
                eFile.addClass('status-failed');
            }
            eFile.attr('title', message);
        } else if (file.status == plupload.DONE) {
            eFile.removeClass('status-uploading');
            if (!eFile.is('.status-done')) {
                eFile.addClass('status-done');
            }
        } else {
            debug && console.log('Status unreconized: ' + file.status);
        }
    }

    function upHandlerHeader() {
        let numFile = 0;
        let numQueue = 0;
        let numSuccess = 0;
        for (const file of uploader.files) {
            numFile++;
            if (file.status == plupload.QUEUED || file.status == plupload.UPLOADING) {
                numQueue++;
            }
            if (file.status == plupload.DONE) {
                numSuccess++;
            }
        }
        if (numFile == 0) {
            $('[data-toggle="titleUploader"]', fmn).text('');
            return;
        }
        if (numQueue > 0) {
            $('[data-toggle="titleUploader"]', fmn).text(fmn.data('lang-uploading') + ' ' + numQueue + ' ' + fmn.data('lang-file'));
            return;
        }
        if (numSuccess > 0) {
            $('[data-toggle="titleUploader"]', fmn).text(fmn.data('lang-uploaded') + ' ' + numSuccess + ' ' + fmn.data('lang-file'));
            return;
        }
        $('[data-toggle="titleUploader"]', fmn).text('!!!!');
    }

    // Init upload
    function getUploader() {
        return new plupload.Uploader({
            browse_button: $('[data-toggle="btnUploadLocal"]', fmn)[0],
            url: nv_base_siteurl + 'index.php?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=' + nv_func_name + '&nocache=' + new Date().getTime(),
            runtimes: 'html5',
            multipart: true,
            multipart_params: {
                checkss: fmn.data('checkss'),
                upload_file: 1,
                folder_id: 0,
                upload_size: 0,
                upload_time: 0,
            },
            filters: {
                max_file_size: fmn.data('max-size'),
                mime_types: [],
                //prevent_duplicates: true
            },
            drop_element: 'nasFileManagerDropToUpload',
            file_data_name: 'fileupload',
            chunk_size: fmn.data('chunk-size'),
            init: {
                Init: () => {
                    debug && console.log('UploadEvent Init');
                },
                PostInit: () => {
                    debug && console.log('UploadEvent PostInit');
                },
                OptionChanged: () => {
                    debug && console.log('UploadEvent OptionChanged');
                },
                //Refresh: () => {
                //    debug && console.log('UploadEvent Refresh');
                //},
                //StateChanged: () => {
                //    debug && console.log('UploadEvent StateChanged');
                //},
                //Browse: () => {
                //    debug && console.log('UploadEvent Browse');
                //},
                //FileFiltered: () => {
                //    debug && console.log('UploadEvent FileFiltered');
                //},
                Error: (up, error) => {
                    debug && console.log('UploadEvent Error', error, up);
                    let message = error.message;
                    try {
                        if (error.response) {
                            message = JSON.parse(error.response).text;
                        }
                    } catch (err) {
                        message = err.message;
                    }
                    if (error.file) {
                        if ($('#' + error.file.id).length) {
                            upHandlerFileStatus(error.file, message);
                        } else {
                            nvToast(message, 'error');
                        }
                    }
                },
                //QueueChanged: () => {
                //    debug && console.log('UploadEvent QueueChanged');
                //},
                FilesAdded: (up, files) => {
                    debug && console.log('UploadEvent FilesAdded', files);
                    for (const file of files) {
                        upItemsCtn.append(`
                        <li class="px-3 py-2 status-pending" id="` + file.id + `" data-folder-id="` + fmn.data('folder-id') + `">
                            <div class="d-flex align-items-center">
                                <div class="item-upload-icon d-inline-flex justify-content-center align-items-center">
                                    <i class="bx bx-fw bxs-image-alt"></i>
                                </div>
                                <div class="flex-shrink-1 flex-grow-1 mx-2 text-truncate" data-toggle="up-item-name"></div>
                                <div class="item-upload-info d-inline-flex justify-content-center align-items-center" data-toggle="up-item-status-ctn">
                                    <svg class="upload-percent" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
                                        <g class="upload-percent-circle">
                                            <circle class="upload-percent-path-elapsed" cx="50" cy="50" r="45" />
                                            <path data-toggle="up-item-percent-path" stroke-dasharray="0 283" class="device-percent-path-remaining" d="M 50, 50 m -45, 0 a 45,45 0 1,0 90,0 a 45,45 0 1,0 -90,0"></path>
                                        </g>
                                    </svg>
                                    <a class="icon justify-content-center align-items-center" data-toggle="up-item-remove" href="#">
                                        <i class="bx bx-x text-danger"></i>
                                    </a>
                                    <a class="icon justify-content-center align-items-center" data-toggle="up-item-done" href="#">
                                        <i class="bx bxs-check-circle text-success"></i>
                                    </a>
                                    <a class="icon justify-content-center align-items-center" data-toggle="up-item-failed" href="#">
                                        <i class="bx bxs-error text-danger"></i>
                                    </a>
                                    <a class="icon justify-content-center align-items-center" data-toggle="up-item-link" href="#">
                                        <i class="bx bxs-folder-open text-muted"></i>
                                    </a>
                                </div>
                            </div>
                        </li>
                        `);
                        let eFile = $('#' + file.id);
                        $('[data-toggle="up-item-name"]', eFile).text(file.name);
                    };
                    upHandlerQueue();
                    upScrollBottom();
                    up.start();
                },
                FilesRemoved: () => {
                    debug && console.log('UploadEvent FilesRemoved');
                    upHandlerQueue();
                    upPS.update();
                },
                BeforeUpload: (up, file) => {
                    debug && console.log('UploadEvent BeforeUpload', file, up);
                    uploader.settings.multipart_params.folder_id = $('#' + file.id).data('folder-id');
                    uploader.settings.multipart_params.upload_size = file.origSize;
                    uploader.settings.multipart_params.upload_time = Math.floor(Date.now() / 1000);
                },
                //UploadFile: () => {
                //    debug && console.log('UploadEvent UploadFile');
                //},
                UploadProgress: (up, file) => {
                    debug && console.log('UploadEvent UploadProgress', file, 'Status: ' + file.status, up);
                    upHandlerFileStatus(file);
                    upHandlerHeader();
                },
                //BeforeChunkUpload: () => {
                //    debug && console.log('UploadEvent BeforeChunkUpload');
                //},
                //ChunkUploaded: () => {
                //    debug && console.log('UploadEvent ChunkUploaded');
                //},
                FileUploaded: (up, file, result) => {
                    debug && console.log('UploadEvent FileUploaded', file, result, up);
                    let message = '';
                    try {
                        let json = JSON.parse(result.response);
                        if (!json.success) {
                            file.status = plupload.FAILED;
                        }
                        if (json.link != '') {
                            $('[data-toggle="up-item-link"]', $('#' + file.id)).attr('href', json.link);
                        }
                        message = json.text;
                    } catch (error) {
                        message = error.message;
                        file.status = plupload.FAILED;
                    }

                    upHandlerFileStatus(file, message);
                    upHandlerHeader();
                },
                UploadComplete: () => {
                    debug && console.log('UploadEvent UploadComplete');
                    upHandlerHeader();
                    refreshFiles();
                },
                Destroy: () => {
                    debug && console.log('UploadEvent Destroy');
                }
            }
        });
    }
    debug && console.log('Init uploader');
    uploader = getUploader();
    uploader.init();

    // Thu nhỏ trình upload lại
    $('[data-toggle="minimizeUploader"]', fmn).on('click', function(e) {
        e.preventDefault();
        upScroller.toggleClass('minimized');
        $(this).toggleClass('minimized');
    });

    // Hủy upload local
    function stopUploader() {
        if (uploader) {
            uploader.destroy();
            uploader = false;
        }
        uploader = getUploader();
        uploader.init();
        upItemsCtn.html('');
        if (upPS) {
            upPS.update();
        }
        upCtn.addClass('d-none');
        upScroller.removeClass('minimized');
        $('[data-toggle="minimizeUploader"]', fmn).removeClass('minimized');
    }
    $('[data-toggle="stopUploader"]', fmn).on('click', function(e) {
        e.preventDefault();
        let numPending = 0;
        for (const file of uploader.files) {
            if (file.status == plupload.QUEUED || file.status == plupload.UPLOADING) {
                numPending++;
            }
        }
        if (numPending > 0) {
            nvConfirm(fmn.data('lang-beforeunload'), () => {
                stopUploader();
            });
            return;
        }
        stopUploader();
    });

    // Kiểm tra cảnh báo trước khi chuyển trang nếu có tập tin đang tải hoặc chờ tải
    $(window).on('beforeunload', function(e) {
        if (!userGesture || !uploader) {
            return;
        }
        let numPending = 0;
        for (const file of uploader.files) {
            if (file.status == plupload.QUEUED || file.status == plupload.UPLOADING) {
                numPending++;
            }
        }
        if (numPending < 1) {
            return;
        }
        e.returnValue = fmn.data('lang-beforeunload');
        return fmn.data('lang-beforeunload');
    });

    // Xóa file chờ upload
    $(document).on('click', '[data-toggle="up-item-remove"]', function(e) {
        e.preventDefault();
        let eFile = $(this).parents('li');
        let id = eFile.attr('id');
        uploader.removeFile(id);
        debug && console.log('Remove queue upload file ' + id, uploader.files);
        eFile.remove();
        //upHandlerQueue();
    });

    // Xử lý drag&drop
    let dropArea = $('#nasFileManagerDropToUpload');
    $(document).on('dragenter', function() {
        debug && console.log('dragenter document event');
        dropArea.addClass('dragging');
    });
    $(document).on('dragleave', function(e) {
        debug && console.log('dragleave document event', e);
        if (e.target === document) {
            dropArea.removeClass('dragging dragover');
        }
    });
    $(document).on('dragover', function(e) {
        e.preventDefault();
        debug && console.log('dragover document event');
    });
    $(document).on('drop', function() {
        debug && console.log('drop document event');
        dropArea.removeClass('dragging dragover');
    });

    dropArea.on('dragenter', function() {
        debug && console.log('dragenter dropArea event');
        dropArea.addClass('dragover');
    });
    dropArea.on('dragleave', function(e) {
        debug && console.log('dragleave dropArea event', e);
        if ($(e.target).is('#nasFileManagerDropToUpload')) {
            dropArea.removeClass('dragover');
        }
    });
    dropArea.on('dragover', function(e) {
        e.preventDefault();
        debug && console.log('dragover dropArea event');
    });
    dropArea.on('drop', function() {
        debug && console.log('drop dropArea event');
        dropArea.removeClass('dragging dragover');
    });

    // Xử lý key
    $(document).on('keyup', function(e) {
        debug && console.log('Document event keyup', e);
        // ESC
        if (e.keyCode == 27) {
            dropArea.removeClass('dragging dragover');
        }
    });

    // Đóng mở menu ở giao diện mobile
    $('[data-toggle="toggleFolder"]', fmn).on('click', function() {
        $('[data-toggle="folderSidebar"]', fmn).toggleClass('show');
    });

    // Form tìm kiếm
    $('input', frmSearch).on('keyup', function(e) {
        if (e.keyCode == 13) {
            return;
        }
        $('input', frmSearch).removeClass('is-invalid');
    });
    frmSearch.on('submit', function(e) {
        e.preventDefault();
        let q = trim($('input', frmSearch).val());
        if (q == '') {
            $('input', frmSearch).addClass('is-invalid');
            return;
        }
        refreshFiles();
    });

    /**
     * Đoạn xử lý thiết lập đồng bộ 1 thư mục lên Google Drive
     */
    // Thiết lập đồng bộ thư mục lên Google Drive
    let mdSGDrive = $('#mdSetupSyncGoogleDrive');
    let gDriveStack = {};
    $(document).on('click', '[data-toggle="syncGoogleDriveFolder"]', function(e) {
        e.preventDefault();
        let md = bootstrap.Modal.getOrCreateInstance(mdSGDrive[0]);
        let btn = $(this);

        $('[name="folder_id"]', mdSGDrive).val(btn.data('folder-id'));
        $('[name="id"]', mdSGDrive).val('0');
        $('.form-content', mdSGDrive).html('');
        $('.form-loader', mdSGDrive).addClass('d-none');
        md.show();
        hideFolderMenu();
    });

    // Chọn APP
    $('[name="id"]', mdSGDrive).on('change', function() {
        let btn = $(this);;
        let id = $(this).val();
        gDriveStack = {};

        $('.form-content', mdSGDrive).html('');
        if (id == 0) {
            return;
        }
        $('.form-loader', mdSGDrive).removeClass('d-none');
        btn.prop('disabled', true);

        $.ajax({
            type: 'POST',
            url: nv_base_siteurl + 'index.php?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=' + nv_func_name + '&nocache=' + new Date().getTime(),
            data: {
                checkss: fmn.data('checkss'),
                app_id: id,
                folder_id: '',
                fetch_gdrive_folder: 1
            },
            dataType: 'json',
            cache: false,
            success: function(respon) {
                $('.form-loader', mdSGDrive).addClass('d-none');
                btn.prop('disabled', false);
                if (!respon.success) {
                    nvToast(respon.text, 'error');
                    return;
                }
                debug && console.log(respon.objects);
                $('.form-content', mdSGDrive).html(respon.html);
            },
            error: function(xhr, text, err) {
                $('.form-loader', mdSGDrive).addClass('d-none');
                btn.prop('disabled', false);
                nvToast(err, 'error');
                console.log(xhr, text, err);
            }
        });
    });
    $(document).on('click', '[data-toggle="loadGoogleDriveFolder"]', function(e) {
        e.preventDefault();
        let btn = $(this);
        let icon = $('i', btn);
        if (icon.is('.fa-spinner')) {
            return;
        }
        icon.removeClass(icon.data('icon')).addClass('fa-spinner fa-spin-pulse');

        let folder_id = btn.data('id');
        let folder_name = btn.data('name');
        // Click back thì quay lại cái lưu trước đó
        if (btn.data('mode') == 'back') {
            folder_id = 0;
            folder_name = '';
            if (gDriveStack[btn.data('parent-id')]) {
                folder_id = gDriveStack[btn.data('parent-id')].id;
                folder_name = gDriveStack[btn.data('parent-id')].name;
            }
        }

        $.ajax({
            type: 'POST',
            url: nv_base_siteurl + 'index.php?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=' + nv_func_name + '&nocache=' + new Date().getTime(),
            data: {
                checkss: fmn.data('checkss'),
                app_id: $('[name="id"]', mdSGDrive).val(),
                folder_id: folder_id,
                folder_name: folder_name,
                fetch_gdrive_folder: 1
            },
            dataType: 'json',
            cache: false,
            success: function(respon) {
                icon.removeClass('fa-spinner fa-spin-pulse').addClass(icon.data('icon'));
                if (!respon.success) {
                    nvToast(respon.text, 'error');
                    return;
                }
                debug && console.log(respon.objects);
                if (btn.data('mode') == 'next') {
                    gDriveStack[btn.data('id')] = {
                        id: btn.data('parent-id'),
                        name: btn.data('parent-name')
                    }
                }
                $('.form-content', mdSGDrive).html(respon.html);
            },
            error: function(xhr, text, err) {
                icon.removeClass('fa-spinner fa-spin-pulse').addClass(icon.data('icon'));
                nvToast(err, 'error');
                console.log(xhr, text, err);
            }
        });
    });

    // Tắt đồng bộ lên Google Drive
    $(document).on('click', '[data-toggle="offSyncGoogleDriveFolder"]', function(e) {
        e.preventDefault();
        let btn = $(this);
        let icon = $('i', btn);
        if (icon.is('.fa-spinner')) {
            return;
        }
        nvConfirm(fmn.data('lang-sync-off-message'), () => {
            icon.removeClass(icon.data('icon')).addClass('fa-spinner fa-spin-pulse');
            $.ajax({
                type: 'POST',
                url: nv_base_siteurl + 'index.php?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=' + nv_func_name + '&nocache=' + new Date().getTime(),
                data: {
                    checkss: fmn.data('checkss'),
                    offsyncgoogledrive: btn.data('folder-id')
                },
                dataType: 'json',
                cache: false,
                success: function(respon) {
                    icon.removeClass('fa-spinner fa-spin-pulse').addClass(icon.data('icon'));
                    if (!respon.success) {
                        nvToast(respon.text, 'error');
                        return;
                    }
                    location.reload();
                },
                error: function(xhr, text, err) {
                    icon.removeClass('fa-spinner fa-spin-pulse').addClass(icon.data('icon'));
                    nvToast(err, 'error');
                    console.log(xhr, text, err);
                }
            });
        });
    });

    // Đổi tên thư mục/tệp tin
    $(document).on('click', '[data-toggle="renameNode"]', function(e) {
        e.preventDefault();
        $('[name="id"]', mdRename).val($(this).data('id'));
        $('[name="old_name"],[name="new_name"]', mdRename).val($(this).data('title'));
        $('.is-invalid', mdRename).removeClass('is-invalid');
        bootstrap.Modal.getOrCreateInstance(mdRename[0]).show();
    });
    mdRename.on('shown.bs.modal', function() {
        $('[name="new_name"]', mdRename).focus();
    });

    // Play video
    window.nasPlayer = null;
    $(document).on('click', '[data-toggle="playVideo"]', function(e) {
        e.preventDefault();
        let btn = $(this);
        let md = $('#mdPlayVideo');
        let ratio = null;
        if (btn.data('width') > 0 && btn.data('height')) {
            ratio = btn.data('width') + ':' + btn.data('height');
        } else {
            ratio = '1:1';
        }
        $('#mdPlayVideoLabel').html(btn.data('title'));
        window.nasPlayer = new Plyr('#mdPlayVideoElement', {
            controls: ['play-large', 'rewind', 'play', 'fast-forward', 'progress', 'current-time', 'mute', 'fullscreen'],
            autoplay: true,
            ratio: ratio,
            seekTime: 20,
            volume: 1,
            resetOnEnd: true
        });
        window.nasPlayer.source = {
            type: 'video',
            title: btn.data('title'),
            sources: [{
                src: btn.attr('href')
            }]
        };
        window.nasPlayer.on('enterfullscreen', event => {
            const instance = event.detail.plyr;
            $(instance.elements.container).addClass('plyr-nas-fullscreen');
        });
        window.nasPlayer.on('exitfullscreen', event => {
            const instance = event.detail.plyr;
            $(instance.elements.container).removeClass('plyr-nas-fullscreen');
        });
        bootstrap.Modal.getOrCreateInstance(md[0]).show();
        hideFileMenu();
    });
    $('#mdPlayVideo').on('hidden.bs.modal', function() {
        window.nasPlayer.destroy();
    });

    // Tùy chỉnh thư mục
    let mdFlSet = $('#mdFolderSetting');
    $(document).on('click', '[data-toggle="settingFolder"]', function(e) {
        e.preventDefault();
        let btn = $(this);
        let icon = $('i', btn);
        if (icon.is('.fa-spinner')) {
            return;
        }
        icon.removeClass(icon.data('icon')).addClass('fa-spinner fa-spin-pulse');
        $.ajax({
            type: 'POST',
            url: nv_base_siteurl + 'index.php?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=' + nv_func_name + '&nocache=' + new Date().getTime(),
            data: {
                checkss: fmn.data('checkss'),
                get_info_folder: btn.data('id')
            },
            dataType: 'json',
            cache: false,
            success: function(respon) {
                icon.removeClass('fa-spinner fa-spin-pulse').addClass(icon.data('icon'));
                if (!respon.success) {
                    nvToast(respon.text, 'error');
                    return;
                }
                let data = respon.folder;
                hideFolderMenu();
                $('[data-toggle="md-title"]', mdFlSet).html(data.title);
                $('[name="folder_id"]', mdFlSet).val(data.id);

                if (data.properties && data.properties.show_type == 'grid') {
                    $('[name="show_type"]', mdFlSet).prop('checked', true);
                } else {
                    $('[name="show_type"]', mdFlSet).prop('checked', false);
                }
                if (data.properties && data.properties.hide_media == 1) {
                    $('[name="hide_media"]', mdFlSet).prop('checked', true);
                } else {
                    $('[name="hide_media"]', mdFlSet).prop('checked', false);
                }

                bootstrap.Modal.getOrCreateInstance(mdFlSet[0]).show();
            },
            error: function(xhr, text, err) {
                icon.removeClass('fa-spinner fa-spin-pulse').addClass(icon.data('icon'));
                nvToast(err, 'error');
                console.log(xhr, text, err);
            }
        });
    });

    // Tạo lại ảnh bìa: Đồng thời tính thời lượng và độ phân giải của video
    $(document).on('click', '[data-toggle="recreateCover"]', function(e) {
        e.preventDefault();
        let btn = $(this);
        let icon = $('i', btn);
        if (icon.is('.fa-spinner')) {
            return;
        }
        icon.removeClass(icon.data('icon')).addClass('fa-spinner fa-spin-pulse');
        $.ajax({
            type: 'POST',
            url: nv_base_siteurl + 'index.php?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=' + nv_func_name + '&nocache=' + new Date().getTime(),
            data: {
                checkss: fmn.data('checkss'),
                reprocess_video: btn.data('id')
            },
            dataType: 'json',
            cache: false,
            success: function(respon) {
                icon.removeClass('fa-spinner fa-spin-pulse').addClass(icon.data('icon'));
                hideFileMenu();
                if (!respon.success) {
                    nvToast(respon.text, 'error');
                    return;
                }
                nvToast(respon.text, 'success');
            },
            error: function(xhr, text, err) {
                icon.removeClass('fa-spinner fa-spin-pulse').addClass(icon.data('icon'));
                nvToast(err, 'error');
                console.log(xhr, text, err);
            }
        });
    });

    // Làm mới danh sách tệp tin/thư mục
    $('[data-toggle="uiReloadFileLists"]').on('click', function(e) {
        hideFileMenu();
        hideFolderMenu();
        refreshFiles();
    });

    // Hủy Zone tệp tin
    $(document).on('click', '[data-toggle="unZoneNode"]', function(e) {
        e.preventDefault();
        let btn = $(this);
        let icon = $('i', btn);
        if (icon.is('.fa-spinner')) {
            return;
        }
        icon.removeClass(icon.data('icon')).addClass('fa-spinner fa-spin-pulse');
        $.ajax({
            type: 'POST',
            url: nv_base_siteurl + 'index.php?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=' + nv_func_name + '&nocache=' + new Date().getTime(),
            data: {
                checkss: fmn.data('checkss'),
                zone_unzone: btn.data('id')
            },
            dataType: 'json',
            cache: false,
            success: function(respon) {
                icon.removeClass('fa-spinner fa-spin-pulse').addClass(icon.data('icon'));
                if (!respon.success) {
                    nvToast(respon.text, 'error');
                    return;
                }
                nvToast(respon.text, 'success');
                hideFileMenu();
                $('[class="file-item"][data-id="' + btn.data('id') + '"]').data('zone', respon.zone);
            },
            error: function(xhr, text, err) {
                icon.removeClass('fa-spinner fa-spin-pulse').addClass(icon.data('icon'));
                nvToast(err, 'error');
                console.log(xhr, text, err);
            }
        });
    });

    // Zone tệp tin
    $(document).on('click', '[data-toggle="zoneNode"]', function(e) {
        e.preventDefault();
        let btn = $(this);
        let icon = $('i', btn);
        if (icon.is('.fa-spinner')) {
            return;
        }
        icon.removeClass(icon.data('icon')).addClass('fa-spinner fa-spin-pulse');
        $.ajax({
            type: 'POST',
            url: nv_base_siteurl + 'index.php?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=' + nv_func_name + '&nocache=' + new Date().getTime(),
            data: {
                checkss: fmn.data('checkss'),
                zone_unzone: btn.data('id'),
                mode: btn.data('mode')
            },
            dataType: 'json',
            cache: false,
            success: function(respon) {
                icon.removeClass('fa-spinner fa-spin-pulse').addClass(icon.data('icon'));
                if (!respon.success) {
                    nvToast(respon.text, 'error');
                    return;
                }
                nvToast(respon.text, 'success');
                hideFileMenu();
                $('[class="file-item"][data-id="' + btn.data('id') + '"]').data('zone', respon.zone);
            },
            error: function(xhr, text, err) {
                icon.removeClass('fa-spinner fa-spin-pulse').addClass(icon.data('icon'));
                nvToast(err, 'error');
                console.log(xhr, text, err);
            }
        });
    });
});
