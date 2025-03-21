        <!-- Captcha-Modal Required!!! -->
        <div id="modal-img-captcha" class="modal fade" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <div class="modal-title">{$LANG->getGlobal('securitycode1')}</div>
                    </div>
                    <div class="modal-body text-center">
                        <div class="margin-bottom">
                            <img class="captchaImg mr-1" src="{ASSETS_STATIC_URL}/images/pix.svg" width="{NV_GFX_WIDTH}" height="{NV_GFX_HEIGHT}" alt="" title="" /><span class="pointer" data-toggle="change_captcha" data-obj="#modal-captcha-value" title="{$LANG->getGlobal('captcharefresh')}"><em class="fa fa-refresh"></em></span>
                        </div>
                        <div class="margin-bottom">
                            <div>
                                <p>{$LANG->getGlobal('securitycode')}</p>
                                <p><input type="text" id="modal-captcha-value" value="" class="form-control display-inline-block required" maxlength="{NV_GFX_NUM}" style="width:200px" data-toggle="enterToEvent" data-obj="#modal-captcha-button" data-obj-event="click"/></p>
                                <div class="invalid-feedback"></div>
                            </div>
                        </div>
                        <p><button type="button" id="modal-captcha-button" class="btn btn-primary">{$LANG->getGlobal('confirm')}</button></p>
                    </div>
                </div>
            </div>
        </div>
        <div id="site-toasts" class="site-toasts d-none">
            <div class="position-relative toast-lists p-3">
                <div class="toast-items" aria-live="polite" aria-atomic="true">
                </div>
            </div>
        </div>
        <div id="timeoutsess" class="chromeframe d-none">
            {$LANG->getGlobal('timeoutsess_nouser')}, <a data-toggle="timeoutsesscancel" href="#">{$LANG->getGlobal('timeoutsess_click')}</a>. {$LANG->getGlobal('timeoutsess_timeout')}: <span id="secField"> 60 </span> {$LANG->getGlobal('sec')}
        </div>
        <div id="openidResult" class="nv-alert" style="display:none"></div>
        <div id="openidBt" data-result="" data-redirect=""></div>
        {if $smarty.const.SSO_REGISTER_DOMAIN}
        <script type="text/javascript">
        function nvgSSOReciver(event) {
            if (event.origin !== '{$smarty.const.SSO_REGISTER_DOMAIN}') {
                return false;
            }
            if (event.data == 'nv.reload') {
                location.reload();
            }
        }
        window.addEventListener('message', nvgSSOReciver, false);
        </script>
        {/if}
        <script src="{$smarty.const.NV_STATIC_URL}themes/{$GCONFIG.module_theme}/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
