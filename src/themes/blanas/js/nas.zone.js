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
    // Hủy Zone tệp tin
    $(document).on('click', '[data-toggle="unzone"]', function(e) {
        e.preventDefault();
        let btn = $(this);
        let icon = $('i', btn);
        if (icon.is('.fa-spinner')) {
            return;
        }
        icon.removeClass(icon.data('icon')).addClass('fa-spinner fa-spin-pulse');
        $.ajax({
            type: 'POST',
            url: nv_base_siteurl + 'index.php?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=file-manager&nocache=' + new Date().getTime(),
            data: {
                checkss: btn.data('checkss'),
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
