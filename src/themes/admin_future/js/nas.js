/**
 * NukeViet Content Management System
 * @version 4.x
 * @author VINADES.,JSC <contact@vinades.vn>
 * @copyright (C) 2009-2024 VINADES.,JSC. All rights reserved
 * @license GNU/GPL version 2 or any later version
 * @see https://github.com/nukeviet The NukeViet CMS GitHub project
 */

$(function() {
    let frmUsr = $('#mdUserContent');
    if (frmUsr.length) {
        let md = bootstrap.Modal.getOrCreateInstance(frmUsr[0]);

        // Chọn thành viên để gán vào người dùng
        $('#element_username_btn').on('click', function() {
            nv_open_browse(script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=users&' + nv_fc_variable + '=getuserid&area=element_username&return=username', 'NVImg', 850, 500, 'resizable=no,scrollbars=no,toolbar=no,location=no,status=no');
        });

        // Mở form thêm thành viên
        $('[data-toggle="addUser"]').on('click', function(e) {
            e.preventDefault();

            $('.modal-title', frmUsr).text(frmUsr.data('mess-add'));
            $('[name="username"]', frmUsr).val('').prop('disabled', false);
            $('#element_username_btn').prop('disabled', false);
            $('[name="userid"]', frmUsr).val('0');
            $('[name="quota_limit"]', frmUsr).val('');

            md.show();
        });

        // Mở form sửa thành viên
        $('[data-toggle="editUser"]').on('click', function(e) {
            e.preventDefault();

            $('.modal-title', frmUsr).text(frmUsr.data('mess-edit'));
            $('[name="username"]', frmUsr).val($(this).data('username')).prop('disabled', true);
            $('#element_username_btn').prop('disabled', true);
            $('[name="userid"]', frmUsr).val($(this).data('userid'));
            $('[name="quota_limit"]', frmUsr).val($(this).data('quota'));

            md.show();
        });

        // Đóng modal thì tắt các lỗi
        frmUsr.on('hidden.bs.modal', function() {
            $('.is-invalid', frmUsr).removeClass('is-invalid');
        });
    }

    // Đình chỉ/kích hoạt hiển thị ngoài site ngôn ngữ data
    $('[data-toggle="statusUser"]').on('change', function(e) {
        e.preventDefault();
        let btn = $(this);
        if (btn.is(':disabled')) {
            return;
        }
        btn.prop('disabled', true);
        $.ajax({
            type: 'POST',
            url: script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=' + nv_func_name + '&nocache=' + new Date().getTime(),
            dataType: 'json',
            cache: false,
            data: {
                changestatus: $('body').data('checksess'),
                userid: btn.attr('value')
            },
            success: function(respon) {
                btn.prop('disabled', false);
                if (!respon.success) {
                    nvToast(respon.text, 'error');
                    btn.prop('checked', (btn.is(':checked') ? false : true));
                    return;
                }
            },
            error: function(xhr, text, err) {
                btn.prop('disabled', false);
                btn.prop('checked', (btn.is(':checked') ? false : true));
                nvToast(err, 'error');
                console.log(xhr, text, err);
            }
        });
    });

    // Xóa 1 user
    $('[data-toggle="delUser"]').on('click', function(e) {
        e.preventDefault();
        let btn = $(this);
        let icon = $('i', btn);
        if (icon.is('.fa-spinner')) {
            return;
        }
        nvConfirm(nv_is_del_confirm[0], () => {
            icon.removeClass(icon.data('icon')).addClass('fa-spinner fa-spin-pulse');
            $.ajax({
                type: 'POST',
                url: script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=' + nv_func_name + '&nocache=' + new Date().getTime(),
                data: {
                    delete: $('body').data('checksess'),
                    id: btn.data('userid')
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

    // Chọn 1/nhiều user và thực hiện các chức năng
    $('[data-toggle="actionUser"]').on('click', function(e) {
        e.preventDefault();
        let btn = $(this);
        if (btn.is(':disabled')) {
            return;
        }
        let listid = [];
        $('[data-toggle="checkSingle"]:checked').each(function() {
            listid.push($(this).val());
        });
        if (listid.length < 1)  {
            nvAlert(nv_please_check);
            return;
        }
        let action = $('#element_action').val();

        if (action == 'delete') {
            nvConfirm(nv_is_del_confirm[0], () => {
                btn.prop('disabled', true);
                $('#element_action').prop('disabled', true);
                $.ajax({
                    type: 'POST',
                    url: script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=' + nv_func_name + '&nocache=' + new Date().getTime(),
                    data: {
                        delete: $('body').data('checksess'),
                        listid: listid.join(',')
                    },
                    success: function(respon) {
                        btn.prop('disabled', false);
                        $('#element_action').prop('disabled', false);
                        if (!respon.success) {
                            nvToast(respon.text, 'error');
                            return;
                        }
                        location.reload();
                    },
                    error: function(xhr, text, err) {
                        btn.prop('disabled', false);
                        $('#element_action').prop('disabled', false);
                        nvToast(err, 'error');
                        console.log(xhr, text, err);
                    }
                });
            });
        }
    });

    // Tính dung lượng hệ thống tự động
    $('[data-toggle="getSystemQuote"]').on('click', function(e) {
        e.preventDefault();
        let btn = $(this);
        let icon = $('i', btn);
        if (icon.is('.fa-spinner')) {
            return;
        }
        icon.removeClass(icon.data('icon')).addClass('fa-spinner fa-spin-pulse');
        $.ajax({
            type: 'POST',
            url: script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=' + nv_func_name + '&nocache=' + new Date().getTime(),
            data: {
                getquota: $('body').data('checksess')
            },
            dataType: 'json',
            cache: false,
            success: function(respon) {
                icon.removeClass('fa-spinner fa-spin-pulse').addClass(icon.data('icon'));
                if (!respon.success) {
                    nvToast(respon.text, 'error');
                    return;
                }
                $('#element_system_quota').val(respon.text);
            },
            error: function(xhr, text, err) {
                icon.removeClass('fa-spinner fa-spin-pulse').addClass(icon.data('icon'));
                nvToast(err, 'error');
                console.log(xhr, text, err);
            }
        });
    });

    // Thêm ICE
    $('body').on('click', '[data-toggle="addIceServers"]', function() {
        let item = $(this).closest('.item');
        let newitem = item.clone();
        $('input,textarea', newitem).val('');
        $('.grup', newitem).each(function() {
            let grup = $(this);
            let id = nv_randomPassword(8);
            $('.lbl', grup).attr('for', id);
            $('.ipt', grup).attr('id', id);
        });
        item.after(newitem);
    });

    // Xóa ICE
    $('body').on('click', '[data-toggle="delIceServers"]', function() {
        let item = $(this).closest('.item');
        let ctn = $(this).closest('.items');
        if ($('.item', ctn).length > 1) {
            item.remove();
            return;
        }
        $('input,textarea', item).val('');
    });
});
