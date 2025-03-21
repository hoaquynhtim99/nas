<script type="text/javascript" src="{$smarty.const.NV_STATIC_URL}themes/{$GCONFIG.module_theme}/js/nas.drive.js"></script>
<div class="px-4 py-3">
    <h1 class="mb-3 fs-3">{$LANG->getModule('drconnect')} <a href="#" data-bs-toggle="modal" data-bs-target="#mdDriveTip"><i class="fa-solid fa-circle-question text-info"></i></a></h1>
    <div class="mb-3">
        <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#mdDriveContent"><i class="fa-solid fa-link"></i> {$LANG->getModule('add')}</button>
    </div>
    {foreach from=$ARRAY item=row}
    <div class="card mb-2">
        <div class="card-body">
            <div class="d-flex justify-content-between align-items-center">
                <div>{$row.title}</div>
                <div class="ms-2">
                    <div class="hstack gap-2">
                        {if empty($row.is_setup)}
                        <button class="btn btn-sm btn-secondary" type="button" data-toggle="setupToken" data-id="{$row.id}" data-checkss="{$smarty.const.NV_CHECK_SESSION}"><i class="fa-solid fa-link-slash" data-icon="fa-link-slash"></i> {$LANG->getModule('drconnect_notyet')}</button>
                        {elseif not empty($row.is_error)}
                        <button class="btn btn-sm btn-danger" type="button" data-toggle="setupToken" data-id="{$row.id}" data-checkss="{$smarty.const.NV_CHECK_SESSION}"><i class="fa-solid fa-link-slash" data-icon="fa-link-slash"></i> {$LANG->getModule('drconnect_error')}</button>
                        {else}
                        <button type="button" class="btn btn-success btn-sm">{$LANG->getModule('drconnect_success')}</button>
                        {/if}
                        <div class="dropdown">
                            <button class="btn btn-info btn-sm dropdown-toggle" type="button" data-bs-toggle="dropdown" data-bs-auto-close="outside" aria-expanded="false"></button>
                            <ul class="dropdown-menu dropdown-menu-end">
                                {if not empty($row.is_setup)}
                                <li><a class="dropdown-item" href="#" data-toggle="test" data-id="{$row.id}" data-checkss="{$smarty.const.NV_CHECK_SESSION}"><i class="fa-solid fa-link" data-icon="fa-link"></i> {$LANG->getModule('drconnect_test')}</a></li>
                                {/if}
                                <li><a class="dropdown-item" href="#" data-toggle="delete" data-id="{$row.id}" data-checkss="{$smarty.const.NV_CHECK_SESSION}"><i class="fa-solid fa-trash text-danger" data-icon="fa-trash"></i> {$LANG->getGlobal('delete')}</a></li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    {/foreach}
</div>

<div class="modal fade" id="mdSetupToken" tabindex="-1" aria-labelledby="mdSetupTokenLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <div class="modal-title fs-5" id="mdSetupTokenLabel"></div>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="{$LANG->getGlobal('close')}"></button>
            </div>
            <div class="modal-body">
                <form method="post" class="ajax-submit" action="{$smarty.const.NV_BASE_SITEURL}index.php?{$smarty.const.NV_LANG_VARIABLE}={$smarty.const.NV_LANG_DATA}&amp;{$smarty.const.NV_NAME_VARIABLE}={$MODULE_NAME}&amp;{$smarty.const.NV_OP_VARIABLE}={$OP}" novalidate>
                    <div class="mb-3">
                        <label for="element_verification_code" class="col-form-label fw-medium">{$LANG->getModule('drconnect_verification_code')} <span class="text-danger">(*)</span>:</label>
                        <input type="text" class="form-control" id="element_verification_code" name="verification_code" value="">
                        <div class="invalid-feedback">{$LANG->getGlobal('required_invalid')}</div>
                    </div>
                    <div class="hstack gap-2 justify-content-end">
                        <button type="submit" class="btn btn-primary"><i class="fa-solid fa-floppy-disk"></i> {$LANG->getGlobal('submit')}</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal"><i class="fa-solid fa-xmark"></i> {$LANG->getGlobal('close')}</button>
                    </div>
                    <div class="mt-3 pt-3 border-top">
                        <div class="fs-5 mb-3">{$LANG->getModule('ui_guide')}:</div>
                        <ol>
                            <li class="text-break">{$LANG->getModule('drconnect_token_guide1')} <a href="#" data-toggle="link" target="_blank"><i class="fa-solid fa-up-right-from-square"></i> {$LANG->getModule('drconnect_token_guide1_1')}</a></li>
                            <li>{$LANG->getModule('drconnect_token_guide2')}</li>
                            <li class="text-break">
                                {$LANG->getModule('drconnect_token_guide3')}
                                <span class="text-primary">http://localhost/?code=<strong>xxxxxxxxxx</strong>&amp;scope=https://www.googleapis.com/auth/drive</span>.
                                {$LANG->getModule('drconnect_token_guide3_1')}.
                            </li>
                            <li>
                                {$LANG->getModule('drconnect_token_guide4')}
                            </li>
                        </ol>
                    </div>
                    <input type="hidden" name="savetoken" value="0">
                    <input type="hidden" name="checkss" value="{$smarty.const.NV_CHECK_SESSION}">
                </form>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="mdDriveContent" tabindex="-1" aria-labelledby="mdDriveContentLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <div class="modal-title fs-5" id="mdDriveContentLabel">{$LANG->getModule('drconnect_add')}</div>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="{$LANG->getGlobal('close')}"></button>
            </div>
            <div class="modal-body">
                <form method="post" class="ajax-submit" action="{$smarty.const.NV_BASE_SITEURL}index.php?{$smarty.const.NV_LANG_VARIABLE}={$smarty.const.NV_LANG_DATA}&amp;{$smarty.const.NV_NAME_VARIABLE}={$MODULE_NAME}&amp;{$smarty.const.NV_OP_VARIABLE}={$OP}" novalidate>
                    <div class="mb-3">
                        <label for="element_title" class="col-form-label fw-medium">{$LANG->getModule('drconnect_title')} <span class="text-danger">(*)</span>:</label>
                        <input type="text" class="form-control" id="element_title" name="title" value="" maxlength="100">
                        <div class="invalid-feedback">{$LANG->getGlobal('required_invalid')}</div>
                    </div>
                    <div class="mb-3">
                        <label for="element_client_id" class="col-form-label fw-medium">{$LANG->getModule('drconnect_client_id')} <span class="text-danger">(*)</span>:</label>
                        <input type="text" class="form-control" id="element_client_id" name="client_id" value="" maxlength="200" autocomplete="off">
                        <div class="invalid-feedback">{$LANG->getGlobal('required_invalid')}</div>
                    </div>
                    <div class="mb-3">
                        <label for="element_client_secret" class="col-form-label fw-medium">{$LANG->getModule('drconnect_client_secret')} <span class="text-danger">(*)</span>:</label>
                        <input type="text" class="form-control" id="element_client_secret" name="client_secret" value="" maxlength="200" autocomplete="off">
                        <div class="invalid-feedback">{$LANG->getGlobal('required_invalid')}</div>
                    </div>
                    <div class="hstack gap-2 justify-content-end">
                        <button type="submit" class="btn btn-primary"><i class="fa-solid fa-floppy-disk"></i> {$LANG->getGlobal('save')}</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal"><i class="fa-solid fa-xmark"></i> {$LANG->getGlobal('close')}</button>
                    </div>
                    <input type="hidden" name="id" value="0">
                    <input type="hidden" name="checkss" value="{$smarty.const.NV_CHECK_SESSION}">
                </form>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="mdDriveTip" tabindex="-1" aria-labelledby="mdDriveTipLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <div class="modal-title fs-5" id="mdDriveTipLabel">{$LANG->getModule('drconnect_tip1')}</div>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="{$LANG->getGlobal('close')}"></button>
            </div>
            <div class="modal-body">
                {* Hỗ trợ ngôn ngữ khác thì dịch thêm vào đây *}
                <p>Tại đây bạn tự nhập và quản lý dữ liệu kết nối của bạn. Chúng tôi cam kết không chia sẻ cho bên thứ ba hoặc sử dụng
                thông tin này vào mục đích khác dưới mọi hình thức. Tuy nhiên không thể đảm bảo nếu hệ thống bị đột nhập hoặc bị rò rỉ vì lý do nào đó.
                Bạn có quyền thực hiện hoặc không thực hiện nếu cảm thấy không an toàn.</p>
                <ol>
                    <li>
                        Truy cập <a href="https://console.cloud.google.com/"><i class="fa-solid fa-arrow-up-right-from-square"></i> Google Cloud Console</a>
                        bằng tài khoản Google của bạn. Nhấp chọn New Project hoặc nếu bạn có Project rồi thì chọn project đó.
                    </li>
                    <li>
                        Vào APIs &amp; Services &gt; OAuth consent screen chọn Create nếu chưa có sau đó điền các thông tin cần thiết:
                        <ul>
                            <li>
                                App name: Nhập tên mà bạn muốn đặt
                            </li>
                            <li>
                                User support email: Để mặc định email của bạn hoặc chọn theo nhu cầu
                            </li>
                            <li>
                                Không điền thêm thông tin vào phần <span class="text-primary">App logo, App domain, Authorized domains</span> nếu không bạn sẽ phải xác minh ứng dụng
                            </li>
                            <li>Ấn next cho đến khi hoàn tất</li>
                            <li>Sau đó quay lại phần <span class="text-primary">OAuth consent screen</span> chuyển trạng thái <span class="text-primary">Publishing status</span> thành <span class="text-primary">In production</span></li>
                        </ul>
                    </li>
                    <li>
                        Vào mục Credentials ấn Create credentials &gt; OAuth client ID:
                        <ul>
                            <li>Mục Application type chọn <strong>Desktop app</strong>, điền tên. Nhớ chọn đúng Desktop app nếu không xác thực của bạn sẽ bị hết hạn và không thể chạy nền để duy trì</li>
                            <li>Ấn Create. Sau đó lấy Client ID và Client secret để nhập vào form thêm APP bên dưới</li>
                        </ul>
                    </li>
                    <li>
                        Vào mục APIs &amp; Services nhấp chọn Enabled APIs &amp; services sau đó tìm kiếm Drive API,
                        ở kết quả trả về nhấp chọn Google Drive API và ấn Enable
                    </li>
                </ol>
            </div>
        </div>
    </div>
</div>
