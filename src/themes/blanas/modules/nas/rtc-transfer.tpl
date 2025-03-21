<script type="text/javascript" src="{$smarty.const.NV_STATIC_URL}themes/{$GCONFIG.module_theme}/js/nas.rtc.js"></script>
<div class="px-4 py-3">
    <h1 class="mb-3 fs-3">{$LANG->getModule('app_rtct')} <a href="#" data-bs-toggle="modal" data-bs-target="#mdRTCTip"><i class="fa-solid fa-circle-question text-info"></i></a></h1>
    {if empty($ROOM)}
    <div class="row justify-content-center">
        <div class="col-sm-8 col-lg-6 col-xl-5 col-xxl-3">
            <div class="alert alert-danger d-none" id="rtcNotSupported">{$LANG->getModule('rtct_not_supported')}</div>
            <div class="card" id="rtcMainForm" data-base-url="{$smarty.const.NV_BASE_SITEURL}index.php?{$smarty.const.NV_LANG_VARIABLE}={$smarty.const.NV_LANG_DATA}&amp;{$smarty.const.NV_NAME_VARIABLE}={$MODULE_NAME}&amp;{$smarty.const.NV_OP_VARIABLE}={$OP}">
                <div class="card-body py-5">
                    <div class="mb-3">
                        <form id="rtcMainFormJoinForm" data-error-1="{$LANG->getModule('rtct_join_error1')}" data-error-2="{$LANG->getModule('rtct_join_error2')}">
                            <label for="rtcMainFormJoinIpt" class="form-label">{$LANG->getModule('rtct_join')}:</label>
                            <div class="input-group">
                                <input id="rtcMainFormJoinIpt" type="text" name="join" class="form-control form-control-lg" placeholder="xxxx" aria-label="{$LANG->getModule('rtct_join')}" aria-describedby="rtcMainFormJoinBtn">
                                <button class="btn btn-lg btn-outline-success" type="submit" id="rtcMainFormJoinBtn">{$LANG->getModule('rtct_join_btn')}</button>
                            </div>
                        </form>
                    </div>
                    <div>
                        <label for="rtcMainFormCreateBtn" class="form-label">{$LANG->getModule('rtct_or')}:</label>
                        <div class="d-grid">
                            <button id="rtcMainFormCreateBtn" type="button" class="btn btn-success btn-lg">{$LANG->getModule('rtct_create')}</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    {else}
    <div class="rtc-room" id="rtcRoom"
        data-room-id="{$ROOM}"
        data-owner-name="{$USER.full_name ?? ''}"
        data-owner-image="{$USER.avata ?? ''}"
        data-path-image="{$smarty.const.NV_STATIC_URL}themes/{$GCONFIG.module_theme}/images/avatar/"
        data-server-url="{$CONFIG.websocket_url}"
        data-lang-cancel-request="{$LANG->getModule('ui_cancel_request')}"
        data-lang-error-ws="{$LANG->getModule('rtct_error_ws')}"
        data-lang-closed-ws="{$LANG->getModule('rtct_error_ws1')}"
        data-lang-confirm1="{$LANG->getModule('rtct_confirm1')}"
        data-lang-confirm2="{$LANG->getModule('rtct_confirm2')}"
        data-lang-confirm3="{$LANG->getModule('rtct_confirm3')}"
        data-lang-confirm4="{$LANG->getModule('rtct_confirm4')}"
        data-lang-confirm5="{$LANG->getModule('rtct_confirm5')}"
        data-lang-confirm6="{$LANG->getModule('rtct_confirm6')}"
        data-lang-confirm7="{$LANG->getModule('rtct_confirm7')}"
        data-lang-status1="{$LANG->getModule('rtct_status1')}"
        data-lang-status2="{$LANG->getModule('rtct_status2')}"
        data-lang-status3="{$LANG->getModule('rtct_status3')}"
        data-lang-status4="{$LANG->getModule('rtct_status4')}"
        data-lang-status5="{$LANG->getModule('rtct_status5')}"
        data-lang-yes="{$LANG->getGlobal('yes')}"
        data-lang-no="{$LANG->getGlobal('no')}"
        data-lang-confirm="{$LANG->getModule('ui_confirm')}"
        data-ice-servers="{$ICESERVERS}"
    >
        <div class="user others"></div>
        <div class="user you"></div>
        <svg class="circles" viewBox="-0.5 -0.5 1140 700">
            <circle class="circle" cx="570" cy="570" r="30" stroke="rgba(160,160,160, 1)"></circle>
            <circle class="circle" cx="570" cy="570" r="100" stroke="rgba(160,160,160,.9)"></circle>
            <circle class="circle" cx="570" cy="570" r="200" stroke="rgba(160,160,160,.8)"></circle>
            <circle class="circle" cx="570" cy="570" r="300" stroke="rgba(160,160,160,.7)"></circle>
            <circle class="circle" cx="570" cy="570" r="400" stroke="rgba(160,160,160,.6)"></circle>
            <circle class="circle" cx="570" cy="570" r="500" stroke="rgba(160,160,160,.5)"></circle>
        </svg>
    </div>
    {/if}
</div>
<div class="modal fade" id="mdRTCTip" tabindex="-1" aria-labelledby="mdRTCTipLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <div class="modal-title fs-5" id="mdRTCTipLabel">{$LANG->getModule('app_rtct_tip')}</div>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="{$LANG->getGlobal('close')}"></button>
            </div>
            <div class="modal-body">
                {* Hỗ trợ ngôn ngữ khác thì dịch thêm vào đây *}
                <ol>
                    <li>Bạn hoặc người muốn chuyển tạo kênh chuyển dữ liệu và tham gia vào đó. Kênh này có thể có nhiều hơn 2 người</li>
                    <li>
                        Máy chủ của chúng tôi sẽ giúp các bạn nhìn thấy nhau và giao tiếp với nhau.
                        Giao tiếp ở đây ở mức độ gửi yêu cầu truyền tệp tin và chấp nhận yêu cầu truyền tệp tin.
                    </li>
                    <li>
                        Sau khi nhận ra nhau và xác nhận các yêu cầu của nhau quá trình truyền dữ liệu được bắt đầu.
                        Dữ liệu được truyền trực tiếp giữa 2 máy tính và không được gửi lên máy chủ của chúng tôi.
                        Cách thức truyền là dùng WebRTC.
                    </li>
                </ol>
                <h5>WebRTC</h5>
                WebRTC (Web Real-Time Communications) là một công nghệ mã nguồn mở cho phép truyền trực tiếp các dữ liệu âm thanh,
                hình ảnh và video giữa các trình duyệt web, giúp tạo ra các ứng dụng truyền thông trực tuyến như cuộc gọi video,
                hội nghị trực tuyến và chia sẻ tệp. Nó được hỗ trợ bởi Apple, Google, Microsoft, Mozilla và một số tổ chức khác.
                Chi tiết thêm tại đây <a href="https://webrtc.org/">https://webrtc.org/</a>
                <h5 class="mt-4">Dữ liệu của tôi có được an toàn không?</h5>
                Dữ liệu của bạn an toàn tuyệt đối, bởi nó không được gửi tới bên thứ 3 mà gửi và nhận trực tiếp giữa hai người.
            </div>
        </div>
    </div>
</div>
