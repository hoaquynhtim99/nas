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
    // Đổi ngôn ngữ giao diện
    $('body').on('change', '[data-toggle=changeLang]', function(e) {
        e.preventDefault();
        const btn = $(this);
        btn.prop('disabled', true);
        $.ajax({
            type: 'GET',
            url: $(this).val(),
            cache: false
        }).done(function() {
            location.reload();
        }).fail(function(xhr, text, err) {
            btn.prop('disabled', false);
            nvToast(err, 'error');
            console.log(xhr, text, err);
        });
    });

    // Đăng xuất bước 1
    $('body').on('click', '[data-toggle=preLogout]', function(e) {
        e.preventDefault();
        $.ajax({
            type: 'GET',
            url: $(this).data('href'),
            cache: false
        }).done(function() {
            location.reload();
        }).fail(function(xhr, text, err) {
            nvToast(err, 'error');
            console.log(xhr, text, err);
        });
    });

    // Đổi captcha hình
    $('body').on('click', '[data-toggle=nv_change_captcha]', function(e) {
        e.preventDefault();
        $('#vimg').attr('src', nv_base_siteurl + "sload.php?scaptcha=captcha&nocache=" + nv_randomPassword(10));
        $('#seccode').val('');
    });

    // Click chuyển hướng (vượt qua preventDefault mặc định #)
    $('#adm-redirect').on('click', function(e) {
        e.preventDefault();
        location.href = $(this).attr('href');
    });

    // Đăng nhập bước 1
    $('body').on('submit', '[data-toggle=preForm]', function(e) {
        e.preventDefault();
        const form = $(this);
        const btn = $('[type="submit"]', form);

        // Kiểm tra form đăng nhập bước 1
        const uname = $('[name=nv_login]', this);
        const upass = $('[name=nv_password]', this);
        const seccode = $('[name=nv_seccode]', this);

        if (trim(uname.val()) == '') {
            $('[data-toggle="message"]', form).text(uname.data('error-mess')).removeClass('border-success text-success').addClass('border-danger text-danger');
            uname.focus();
            return;
        }
        if (trim(upass.val()) == '') {
            $('[data-toggle="message"]', form).text(upass.data('error-mess')).removeClass('border-success text-success').addClass('border-danger text-danger');
            upass.focus();
            return;
        }
        if (seccode.length && trim(seccode.val()) == '') {
            $('[data-toggle="message"]', form).text(seccode.data('error-mess')).removeClass('border-success text-success').addClass('border-danger text-danger');
            seccode.focus();
            return;
        }

        // Trì hoãn submit form cho đến khi lấy được token của recaptcha
        const recaptcha3 = ($('#reCaptcha').length < 1 && $("[name=g-recaptcha-response]").length > 0);
        if (recaptcha3 && !form.data('recaptcha3-executed')) {
            btn.prop('disabled', true);

            // Chờ recaptcha sẵn sàng sau đó tự submit lại
            if (!window.recaptcha3Ready) {
                if (!form.data('recaptcha3-registed')) {
                    // Chỉ  đăng kí sự kiện 1 lần
                    form.data('recaptcha3-registed', true);
                    document.addEventListener('nv.recaptcha3.ready', () => {
                        form.submit();
                    });
                }
                return;
            }

            // Lấy token rồi submit
            grecaptcha.execute(sitekey, {
                action: 'loginSubmit'
            }).then(function(token) {
                $("[name=g-recaptcha-response]").val(token);
                form.data('recaptcha3-executed', true);
                form.submit();
            });
            return;
        }

        const data = form.serialize();
        btn.prop('disabled', true);
        recaptcha3 && form.data('recaptcha3-executed', false);
        $.ajax({
            type: 'POST',
            cache: !1,
            url: $(this).attr('action'),
            data: data,
            dataType: 'json',
            success: function(e) {
                if (e.status == 'success') {
                    $('[data-toggle="form"]', form).addClass('d-none');
                    $('[data-toggle="message"]', form).html(e.mess).removeClass('border-danger text-danger mb-3').addClass('border-success text-success');
                    $('#langinterface').remove();
                    var hr = e.redirect != '' ? e.redirect : window.location.href;
                    $('#adm-redirect').attr('href', hr).toggleClass('d-none');
                    setTimeout(() => {
                        window.location.href = hr;
                    }, 3000);
                    return;
                }

                if (e.status == '2step') {
                    location.reload();
                    return;
                }

                btn.prop('disabled', false);
                if (typeof reCaptcha2 !== "undefined" && typeof grecaptcha !== "undefined") {
                    grecaptcha.reset(reCaptcha2);
                    btn.prop('disabled', true);
                } else if ($("[data-toggle=nv_change_captcha]", form).length) {
                    $("[data-toggle=nv_change_captcha]", form).trigger('click');
                }
                $('[data-toggle="message"]', form).html(e.mess).removeClass('border-success text-success').addClass('border-danger text-danger');
                if (e.input != '') {
                    $('[name=' + e.input + ']', form).focus();
                }
            },
            error: function(xhr, text, err) {
                btn.prop('disabled', false);
                nvToast(err, 'error');
                console.log(xhr, text, err);
            }
        });
    });

    // Đổi phương thức xác
    $('body').on('click', '[data-toggle=login2step_change]', function(e) {
        e.preventDefault();
        const ctn = $(this).closest('[data-toggle="methods"]');
        $('[type="text"]', ctn).val('');
        $('[data-toggle="method"]', ctn).toggleClass('d-none');
    });

    // Submit xác thực 2 bước bằng mã
    $('body').on('submit', '[data-toggle=step2Form]', function(e) {
        e.preventDefault();

        // Kiểm tra form xác thực 2 bước
        const form = $(this);
        const otp = $('#nv_totppin');
        const backupcode = $('#nv_backupcodepin');

        if (otp.is(':visible') && otp.val() == '') {
            $('[data-toggle="message"]', form).text(otp.data('error-mess')).removeClass('border-success text-success').addClass('border-danger text-danger');
            otp.focus();
            return;
        }
        if (backupcode.is(':visible') && backupcode.val() == '') {
            $('[data-toggle="message"]', form).text(backupcode.data('error-mess')).removeClass('border-success text-success').addClass('border-danger text-danger');
            backupcode.focus();
            return;
        }

        const data = form.serialize();
        $('input,button', form).prop('disabled', true);
        $.ajax({
            type: 'POST',
            cache: !1,
            url: $(this).attr('action'),
            data: data,
            dataType: 'json',
            success: function(e) {
                if (e.status == 'success') {
                    $('[data-toggle="form"]', form).addClass('d-none');
                    $('[data-toggle="message"]', form).html(e.mess).removeClass('border-danger text-danger mb-3').addClass('border-success text-success');
                    $('#langinterface').remove();
                    var hr = e.redirect != '' ? e.redirect : window.location.href;
                    $('#adm-redirect').attr('href', hr).toggleClass('d-none');
                    setTimeout(() => {
                        window.location.href = hr;
                    }, 3000);
                    return;
                }

                $('input,button', form).prop('disabled', false);
                $('[data-toggle="message"]', form).html(e.mess).removeClass('border-success text-success').addClass('border-danger text-danger');
                if (e.input != '') {
                    $('[name=' + e.input + ']', form).focus();
                }
            },
            error: function(xhr, text, err) {
                $('input,button', form).prop('disabled', false);
                nvToast(err, 'error');
                console.log(xhr, text, err);
            }
        });
    });

    // Mở popup (chưa sử dụng nhưng để đây phòng về sau)
    $('[data-toggle="popup-oauth"]').on('click', function(e) {
        nv_open_browse($(this)[0], "NVADMINOAUTH", 550, 500, "resizable=no,scrollbars=1,toolbar=no,location=no,titlebar=no,menubar=0,location=no,status=no");
        e.preventDefault();
    });

    // Để sẵn chuột vào ô nhập tài khoản
    if ($('#nv_login').length) {
        $('#nv_login').focus();
    }
});
