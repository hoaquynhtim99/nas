/**
 * NukeViet Content Management System
 * @version 4.x
 * @author VINADES.,JSC <contact@vinades.vn>
 * @copyright (C) 2009-2024 VINADES.,JSC. All rights reserved
 * @license GNU/GPL version 2 or any later version
 * @see https://github.com/nukeviet The NukeViet CMS GitHub project
 */

'use strict';

if ('serviceWorker' in navigator) {
    window.addEventListener('load', function() {
        navigator.serviceWorker.register('/NASSDKWorker.js').then(function(registration) {
            console.log('ServiceWorker registration successful with scope: ', registration.scope);

            // Kiểm tra thông báo với người dùng tải lại trang nếu có cập nhật ở Service Worker
            registration.onupdatefound = () => {
                const newWorker = registration.installing;
                newWorker.onstatechange = () => {
                    if (newWorker.state === 'installed' && navigator.serviceWorker.controller) {
                        window.location.reload();
                    }
                };
            };
        }, function(err) {
            console.log('ServiceWorker registration failed: ', err);
        });
    });
}

// Không hiển thị thanh gợi ý cài App
window.addEventListener('beforeinstallprompt', (e) => {
    e.preventDefault();
    //deferredPrompt = e;
});

window.psToast = null;

// Hàm mở toast lên
const nvToast = (text, level, halign, valign) => {
    var toasts = $('#site-toasts');
    var id = nv_randomPassword(8);

    const tLevel = {
        'secondary': 'text-bg-secondary',
        'error': 'text-bg-danger',
        'danger': 'text-bg-danger',
        'primary': 'text-bg-primary',
        'success': 'text-bg-success',
        'info': 'text-bg-info',
        'warning': 'text-bg-warning',
        'light': 'text-bg-light',
        'dark': 'text-bg-dark',
    };
    const hAlign = {
        's': ' toast-start',
        'c': ' toast-center',
    };
    const vAlign = {
        't': ' toast-top',
        'm': ' toast-middle',
        'c': ' toast-middle',
    };
    level = tLevel[level] || ' ';
    halign = hAlign[halign] || '';
    valign = vAlign[valign] || '';
    var align = halign + valign;
    var allAlign = 'toast-top toast-start toast-center toast-middle';

    $('.toast-items', toasts).append(`
    <div data-id="` + id + `" id="toast-` + id + `" class="toast align-items-center ` + level + ` border-0" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="d-flex">
            <div class="toast-body text-break"></div>
            <button type="button" class="btn-close me-2 m-auto" data-bs-dismiss="toast" aria-label="` + nv_close + `"></button>
        </div>
    </div>`);
    $('#toast-' + id + ' .toast-body').text(text);
    if (align != '') {
        toasts.removeClass(allAlign).addClass(align);
    }
    toasts.removeClass('d-none');
    $('.toast-lists', toasts)[0].scrollTop = $('.toast-lists', toasts)[0].scrollHeight;

    if (!psToast) {
        psToast = new PerfectScrollbar($('.toast-lists', toasts)[0], {
            wheelPropagation: false
        });
    } else {
        psToast.update();
    }

    // Show toast
    var toaster = $('#toast-' + id);
    (new bootstrap.Toast(toaster[0])).show();

    // Xử lý khi mỗi toast ẩn
    toaster.on('hidden.bs.toast', () => {
        toaster.remove();
        if ($('.toast-items>.toast', toasts).length < 1) {
            if (psToast) {
                psToast.destroy();
                psToast = null;
            }
            toasts.addClass('d-none').removeClass(allAlign);
        }
    });
}

// Độ rộng thanh cuộn
const nvGetScrollbarWidth = () => {
    const outer = document.createElement('div');
    outer.style.visibility = 'hidden';
    outer.style.overflow = 'scroll';
    outer.style.msOverflowStyle = 'scrollbar';
    outer.style.position = 'fixed';
    document.body.appendChild(outer);

    const inner = document.createElement('div');
    outer.appendChild(inner);

    const scrollbarWidth = outer.offsetWidth - inner.offsetWidth;

    outer.parentNode.removeChild(outer);

    return scrollbarWidth;
}

// Thay thế cho alert
const nvAlert = (message, callback) => {
    if (typeof callback == 'undefined') {
        callback = () => {};
    }
    nvConfirm(message, callback, () => {}, false);
}

// Thay chế cho confirm
const nvConfirm = (message, cbConfirm, cbCancel, cancelBtn) => {
    const body = document.getElementsByTagName('body')[0];

    if (body.classList.contains('alert-open')) {
        return;
    }
    if (typeof cancelBtn == 'undefined') {
        cancelBtn = true;
    }
    if (typeof cbConfirm == 'undefined') {
        cbConfirm = () => {};
    }
    if (typeof cbCancel == 'undefined') {
        cbCancel = () => {};
    }

    const id = 'alert-' + nv_randomPassword(8);
    const isModal = body.classList.contains('modal-open');

    // Đối tượng box
    const box = document.createElement('div');
    box.classList.add('modal', 'alert-box', 'fade');
    box.id = id;
    box.setAttribute('aria-labelledby', id + '-body');
    box.innerHTML = `<div class="modal-dialog alert-box-dialog modal-dialog-scrollable">
        <div class="modal-content alert-box-content">
            <div class="modal-body alert-box-body" id="` + id + `-body"></div>
            <div class="modal-footer alert-box-footer" id="` + id + `-footer">
                <button type="button" class="btn btn-primary" id="` + id + `-confirm"><i class="fa-solid fa-check"></i> ` + nv_confirm + `</button>
                ` + (cancelBtn ? `<button type="button" class="btn btn-secondary" id="` + id + `-close"><i class="fa-solid fa-xmark"></i> ` + nv_close + `</button>` : '') + `
            </div>
        </div>
    </div>`;

    // Đối tượng backdrop
    const backdrop = document.createElement('div');
    backdrop.classList.add('alert-backdrop', 'fade');

    body.append(box, backdrop);
    $('#' + id + '-body').text(message);
    box.style.display = 'block';

    const cOverflow = body.style.overflow;
    const cPaddingRight = body.style.paddingRight;

    setTimeout(() => {
        box.classList.add('show');
        backdrop.classList.add('show');

        if (!isModal) {
            body.style.overflow = 'hidden';
            body.style.paddingRight = nvGetScrollbarWidth() + 'px';
        }
        body.classList.add('alert-open');
    }, 10);

    // Xử lý nút ấn
    const close = (event) => {
        ([...box.querySelectorAll('button')].map(ele => ele.setAttribute('disabled', 'disabled')));
        body.classList.remove('alert-open');
        if (!isModal) {
            if (cOverflow) {
                body.style.overflow = cOverflow;
            } else {
                body.style.removeProperty('overflow');
            }
            if (cPaddingRight) {
                body.style.paddingRight = paddingRight;
            } else {
                body.style.removeProperty('padding-right');
            }
        }
        box.classList.remove('show');
        backdrop.classList.remove('show');
        setTimeout(() => {
            box.style.display = 'none';
            body.removeChild(box);
            body.removeChild(backdrop);
            if (event == 'confirm') {
                cbConfirm();
            } else if (event == 'cancel') {
                cbCancel();
            }
        }, 150);
    }
    if (cancelBtn) {
        document.getElementById(id + '-close').addEventListener('click', () => {
            close('cancel');
        });
    }
    document.getElementById(id + '-confirm').addEventListener('click', () => {
        close('confirm');
    });
}

$(function() {
    $('[data-toggle="openApps"]').on('click', function(e) {
        e.preventDefault();
        let md = bootstrap.Modal.getOrCreateInstance('#mdNasApps');
        md.show();
    });

    // Ajax submit
    // Condition: The returned result must be in JSON format with the following elements:
    // status ('OK/error', required), mess (Error content), input (input name),
    // redirect (redirect URL if status is OK), refresh (Reload page if status is OK)
    const formAj = $('.ajax-submit');
    if (formAj.length > 0) {
        $('select', formAj).on('change keyup', function() {
            $(this).removeClass('is-invalid is-valid');
            if ($(this).parent().is('.input-group')) {
                $(this).parent().removeClass('is-invalid is-valid');
            }
        });
        $('[type="text"], [type="password"], [type="number"], [type="email"], textarea', formAj).on('change keyup', function() {
            let pr = $(this).parent();
            let prAlso = $(this).parent().is('.input-group');
            if (trim($(this).val()) == '' && $(this).is('.required')) {
                $(this).addClass('is-invalid');
                (prAlso && pr.addClass('is-invalid'));
            } else {
                $(this).removeClass('is-invalid is-valid');
                (prAlso && pr.removeClass('is-invalid is-valid'));
            }
        });
    }

    $('body').on('submit', '.ajax-submit', function(e) {
        e.preventDefault();

        if ($('.is-invalid:visible', this).length > 0) {
            let ipt = $('.is-invalid:visible:first', this);
            if (ipt.is('.input-group')) {
                ipt = $('input:first', ipt);
            }
            ipt.focus();
            return;
        }

        $('.is-invalid', this).removeClass('is-invalid');
        $('.is-valid', this).removeClass('is-valid');

        if (typeof(CKEDITOR) !== 'undefined') {
            for (let instance in CKEDITOR.instances) {
                CKEDITOR.instances[instance].updateElement();
                CKEDITOR.instances[instance].setReadOnly(true)
            }
        }

        var that = $(this),
            data = that.serialize(),
            callback = that.data('callback');
        $('input, textarea, select, button', that).prop('disabled', true);
        $.ajax({
            url: that.attr('action'),
            type: 'POST',
            data: data,
            cache: false,
            dataType: "json",
            success: function(a) {
                if (a.status == 'NO' || a.status == 'no' || a.status == 'error') {
                    $('input, textarea, select, button', that).prop('disabled', false);
                    if (a.tab) {
                        bootstrap.Tab.getOrCreateInstance(document.getElementById(a.tab)).show();
                    }
                    if (a.input) {
                        let ele = $('[name^=' + a.input + ']', that);
                        if (ele.length) {
                            let pr = ele.parent();
                            if (pr.is('.input-group')) {
                                pr.addClass('is-invalid');
                                pr = pr.parent();
                            }
                            $('.invalid-feedback', pr).html(a.mess);
                            ele.addClass('is-invalid').focus();
                            return;
                        }
                    }
                    nvToast(a.mess, 'error');
                    return;
                }

                if (a.status == 'OK' || a.status == 'ok' || a.status == 'success') {
                    let cb;
                    if ('function' === typeof callback) {
                        cb = callback(a);
                    } else if ('string' == typeof callback && "function" === typeof window[callback]) {
                        cb = window[callback](a);
                    }
                    if (cb === 0 || cb === false) {
                        return;
                    }
                    let timeout = 0;
                    if (a.mess) {
                        nvToast(a.mess, a.warning ? 'warning' : 'success');
                        timeout = a.timeout ? a.timeout : 2000;
                    }
                    if (a.redirect) {
                        setTimeout(() => {
                            window.location.href = a.redirect;
                        }, timeout);
                    } else if (a.refresh) {
                        setTimeout(() => {
                            window.location.reload();
                        }, timeout);
                    } else {
                        setTimeout(() => {
                            $('input, textarea, select, button', that).prop('disabled', false);
                            if (typeof(CKEDITOR) !== 'undefined') {
                                for (let instance in CKEDITOR.instances) {
                                    CKEDITOR.instances[instance].setReadOnly(false);
                                }
                            }
                        }, 1000);
                    }
                }
            },
            error: function(xhr, text, err) {
                $('input, textarea, select, button', that).prop('disabled', false);
                nvToast(err, 'error');
                console.log(xhr, text, err);
            }
        });
    });

    // Xử lý khi click trong điều kiện alertbox đang mở
    $(document).on('click', function(e) {
        if (!$('body').is('.alert-open') || $(e.target).is('.alert-box-content') || $(e.target).closest('.alert-box-content').length) {
            return;
        }
        const al = document.getElementsByClassName('alert-box')[0];
        if (al.classList.contains('modal-static')) {
            return;
        }
        al.classList.add('modal-static');
        setTimeout(() => {
            al.classList.remove('modal-static');
        }, 150);
    });

    // Tooltip
    ([...document.querySelectorAll('[data-bs-toggle="tooltip"]')].map(tipEle => new bootstrap.Tooltip(tipEle)));

    // Popover
    ([...document.querySelectorAll('[data-bs-toggle="popover"]')].map(popEle => new bootstrap.Popover(popEle)));

    // Default toasts
    ([...document.querySelectorAll('.toast')].map(toastEl => new bootstrap.Toast(toastEl)));

    // Default toasts
    ([...document.querySelectorAll('[data-nv-toggle="scroll"]')].map(scrollEl => new PerfectScrollbar(scrollEl, {
        wheelPropagation: true
    })));
});
