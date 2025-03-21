<script type="text/javascript" src="{$smarty.const.ASSETS_STATIC_URL}/js/plupload/plupload.full.min.js"></script>
<script type="text/javascript" src="{$smarty.const.ASSETS_LANG_STATIC_URL}/js/language/plupload-{$smarty.const.NV_LANG_INTERFACE}.js"></script>
<script type="text/javascript" src="{$smarty.const.ASSETS_STATIC_URL}/js/jquery-ui/jquery-ui.min.js"></script>
<script type="text/javascript" src="{$smarty.const.ASSETS_STATIC_URL}/js/plupload/plupload.full.min.js"></script>
<script type="text/javascript" src="{$smarty.const.ASSETS_LANG_STATIC_URL}/js/language/plupload-{$smarty.const.NV_LANG_INTERFACE}.js"></script>
<script type="text/javascript" src="{$smarty.const.ASSETS_STATIC_URL}/js/clipboard/clipboard.min.js"></script>
<script type="text/javascript" src="{$smarty.const.NV_STATIC_URL}themes/{$GCONFIG.module_theme}/js/nas.file.js"></script>
<script src="{$smarty.const.ASSETS_STATIC_URL}/js/plyr/plyr.polyfilled.js"></script>
<link rel="stylesheet" type="text/css" href="{$smarty.const.ASSETS_STATIC_URL}/js/jquery-ui/jquery-ui.min.css">
<link rel="stylesheet" type="text/css" href="{$smarty.const.ASSETS_STATIC_URL}/js/plyr/plyr.css">
<div class="file-manager-wrapper d-lg-flex gap-1 p-1" id="nasFileManager"
    data-lang-delete="{$LANG->getGlobal('delete')}"
    data-lang-create-folder-sub="{$LANG->getModule('ui_create_folder_sub')}"
    data-lang-empty-trash="{$LANG->getModule('ui_empty_trash')}"
    data-lang-download="{$LANG->getModule('ui_download')}"
    data-lang-untrash="{$LANG->getModule('ui_untrash')}"
    data-lang-delete-permanently="{$LANG->getModule('ui_delete_permanently')}"
    data-lang-confirm-permanently="{$LANG->getModule('ui_confirm_permanently')}"
    data-lang-beforeunload="{$LANG->getModule('upload_beforeunload')}"
    data-lang-file="{$LANG->getModule('ui_file')}"
    data-lang-uploading="{$LANG->getModule('ui_uploading')}"
    data-lang-uploaded="{$LANG->getModule('ui_uploaded')}"
    data-lang-access="{$LANG->getModule('ui_access')}"
    data-lang-sync-gdrive="{$LANG->getModule('ui_sync_googledrive')}"
    data-lang-sync-off-gdrive="{$LANG->getModule('ui_sync_off_googledrive')}"
    data-lang-sync-off-message="{$LANG->getModule('ui_sync_off_message')}"
    data-lang-file-selected="{$LANG->getModule('ui_selected')}"
    data-lang-rename="{$LANG->getModule('ui_rename')}"
    data-lang-play-video="{$LANG->getModule('ui_play_video')}"
    data-lang-settings="{$LANG->getModule('ui_settings')}"
    data-lang-recreate-cover="{$LANG->getModule('ui_recreate_cover')}"
    data-lang-unzone="{$LANG->getModule('ui_unzone')}"
    data-lang-zone-permanently="{$LANG->getModule('ui_zone_permanently')}"
    data-lang-zone-temporary="{$LANG->getModule('ui_zone_temporary')}"
    data-checkss="{$smarty.const.NV_CHECK_SESSION}"
    data-folder-id="{$REQUEST.folder_id}"
    data-drive="{$REQUEST.drive}"
    data-sort-request="{$REQUEST.sort}"
    data-sort-user="{$NUSER_CONFIG.view_sort}"
    data-max-size="{$UPLOAD_MAXSIZE}"
    data-max-size-show="{$UPLOAD_MAXSIZE_VIEW}"
    data-chunk-size="{$GCONFIG.upload_chunk_size}"
>
    <div class="file-manager-sidebar" data-toggle="folderSidebar">
        <div class="p-3 d-flex flex-column h-100">
            <div class="mb-3">
                <div class="fs-5 mb-0 fw-semibold">{$LANG->getModule('ui_my_drive')}</div>
            </div>
            <div class="dropdown mb-3">
                <button data-toggle="btnCreateMenu" class="btn btn-success w-100 text-center" type="button" data-bs-toggle="dropdown" aria-expanded="false"{if $REQUEST.drive neq '' and $REQUEST.drive neq 'drive'} disabled{/if}>{$LANG->getModule('ui_create')}</button>
                <ul class="dropdown-menu">
                    <li><a class="dropdown-item" href="#" data-toggle="btnUploadLocal"><i class="bx bx-fw text-center bx-upload"></i> {$LANG->getModule('ui_create_upload')}</a></li>
                    <li><a class="dropdown-item" href="#" data-toggle="btnUploadRemote"><i class="bx bx-fw text-center bx-cloud-upload"></i> {$LANG->getModule('ui_create_remote')}</a></li>
                    <li><a class="dropdown-item" href="#" data-toggle="btnCreateFolder"><i class="bx bx-fw text-center bx-folder-plus"></i> {$LANG->getModule('ui_create_folder')}</a></li>
                </ul>
            </div>
            <form class="search-box" id="nasFileManagerSearch" method="get" novalidate>
                <input name="q" type="text" class="form-control bg-light border-light" placeholder="{$LANG->getModule('ui_search_file')}" autocomplete="off" maxlength="100">
                <i class="bx bx-search search-icon"></i>
            </form>
            <div class="nas-folders-tree" id="nasFileManagerFolders">
                <div id="nasFileManagerFoldersElements">
                    {include file='file-manager-folders.tpl'}
                </div>
            </div>
            <div class="mt-auto">
                <div class="strorage-status text-muted text-uppercase mb-3">{$LANG->getModule('ui_quota')}</div>
                <div class="d-flex align-items-center">
                    <div class="flex-shrink-0">
                        <i class="bx bxs-data"></i>
                    </div>
                    <div class="flex-grow-1 ms-3 overflow-hidden">
                        <div class="progress mb-2 progress-sm">
                            <div class="progress-bar bg-{if $NUSER.quota_percent gt 80}danger{elseif $NUSER.quota_percent gt 60}warning{else}success{/if}" role="progressbar" style="width: {$NUSER.quota_percent}%;" aria-valuenow="{$NUSER.quota_percent}" aria-valuemin="0" aria-valuemax="100"></div>
                        </div>
                        <span class="strorage-text text-muted fs-12 d-block text-truncate">{$LANG->getModule('ui_storage_current')} <b>{$NUSER.quota_current_show}/{$NUSER.quota_limit_show}</b></span>
                    </div>
                </div>
            </div>
        </div>
    </div>
    {assign var="forceGrid" value=(($RQ.drive eq '' or $RQ.drive eq 'drive') and $RQ.folder_id>0 and isset($ARRAY_FOLDERS[$RQ.folder_id], $ARRAY_FOLDERS[$RQ.folder_id].properties.show_type) and $ARRAY_FOLDERS[$RQ.folder_id].properties.show_type eq 'grid') nocache}
    <div class="file-manager-content p-3">
        <div class="file-manager-tools">
            <div class="tool-inner mb-3">
                <div class="t-titles">
                    <button type="button" class="btn btn-sm btn-success me-2 toggle-folder" data-toggle="toggleFolder">
                        <i class="fa-solid fa-align-left pe-none"></i>
                    </button>
                    <div class="fs-5 fw-medium text-truncate" data-toggle="driveName">{$DRIVE_NAME}</div>
                </div>
                <div class="t-filters" data-toggle="filesLoaderOuter">
                    <div class="d-flex gap-2 align-items-center">
                        <i data-toggle="filesLoader" class="fa-solid fa-spinner fa-spin-pulse text-danger d-none"></i>
                        <select class="form-select flex-shrink-1" name="filterType" aria-label="{$LANG->getModule('ui_view_bytype')}">
                            {foreach from=$FILETYPES item=value}
                            <option value="{$value}"{if $value eq $REQUEST.type} selected{/if}>{$LANG->getModule("ui_view_bytype_`$value`")}</option>
                            {/foreach}
                        </select>
                        <select class="form-select flex-shrink-1" name="filterSort" aria-label="{$LANG->getModule('ui_sort')}">
                            {foreach from=$FILEORDERS item=value}
                            <option value="{$value}"{if $value eq $REQUEST.sort} selected{/if}>{$LANG->getModule("ui_sort_`$value`")}</option>
                            {/foreach}
                        </select>
                        <div data-toggle="changeViewTypeCtn" class="btn-group{$forceGrid ? ' d-none' : ''}" role="group" aria-label="{$LANG->getModule('ui_view_mode')}">
                            <button data-toggle="changeViewType" data-type="grid" data-current="{$NUSER_CONFIG.view_type}" type="button" class="btn btn-{$NUSER_CONFIG.view_type eq 'grid' ? 'success' : 'light'}" aria-label="{$LANG->getModule('ui_view_grid')}"><i class="bx bx-fs-btn bx-grid-alt d-block align-middle" data-icon="bx-grid-alt"></i></button>
                            <button data-toggle="changeViewType" data-type="list" data-current="{$NUSER_CONFIG.view_type}" type="button" class="btn btn-{$NUSER_CONFIG.view_type eq 'list' ? 'success' : 'light'}" aria-label="{$LANG->getModule('ui_view_list')}"><i class="bx bx-fs-btn bx-list-ul d-block align-middle" data-icon="bx-list-ul"></i></button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="file-manager-lists view-{$NUSER_CONFIG.view_type}{if $forceGrid} force-grid{/if} position-relative" id="nasFileManagerFilesOuter">
            <div class="files-header">
                <div class="file-item">
                    <div class="file-item-inner">
                        <div class="col-file-name">{$LANG->getModule('ui_name')}</div>
                        <div class="col-file-size">{$LANG->getModule('ui_size')}</div>
                        <div class="col-file-type">{$LANG->getModule('ui_type')}</div>
                        <div class="col-file-date">{$LANG->getModule('ui_last_modified')}</div>
                        <div class="col-file-actions">{$LANG->getGlobal('function')}</div>
                    </div>
                </div>
            </div>
            <div class="files-body" id="nasFileManagerFiles">
                <div class="files-body-inner" id="nasFileManagerFilesElements">
                    {include file='file-manager-files.tpl'}
                </div>
            </div>
            <div class="dropzone-area" id="nasFileManagerDropToUpload">
                <div class="text-center pe-none">
                    <div class="mb-1 pe-none">
                        <i class="bx bxs-cloud-upload pe-none"></i>
                    </div>
                    <div class="fs-5 fw-medium pe-none">{$LANG->getModule('ui_upload_drop')}</div>
                </div>
            </div>
        </div>
    </div>
    <div class="file-manager-upload d-none" id="nasLocalUpload">
        <div class="file-manager-upload-header py-1 ps-3 pe-2">
            <div class="d-flex justify-content-between align-items-center">
                <div data-toggle="titleUploader"></div>
                <div class="d-flex align-items-center">
                    <a href="#" data-toggle="minimizeUploader" class="upload-action action-minimize fs-4 ms-1 text-white d-inline-flex justify-content-center align-items-center rounded-circle">
                        <i class="bx bxs-chevron-down"></i>
                    </a>
                    <a href="#" data-toggle="stopUploader" class="upload-action fs-4 text-white d-inline-flex justify-content-center align-items-center rounded-circle">
                        <i class="bx bx-x"></i>
                    </a>
                </div>
            </div>
        </div>
        <div class="file-manager-upload-content" id="nasLocalUploadScroller">
            <ul class="upload-lists" id="nasLocalUploadItems">
            </ul>
        </div>
    </div>
</div>

{* Tạo thư mục *}
<div class="modal fade" id="mdCreateFolder" tabindex="-1" aria-labelledby="mdCreateFolderLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <div class="modal-title fs-5" id="mdCreateFolderLabel">{$LANG->getModule('ui_create_folder')}</div>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="{$LANG->getGlobal('close')}"></button>
            </div>
            <div class="modal-body">
                <form method="post" class="ajax-submit" action="{$smarty.const.NV_BASE_SITEURL}index.php?{$smarty.const.NV_LANG_VARIABLE}={$smarty.const.NV_LANG_DATA}&amp;{$smarty.const.NV_NAME_VARIABLE}={$MODULE_NAME}&amp;{$smarty.const.NV_OP_VARIABLE}={$OP}" novalidate>
                    <div class="mb-3">
                        <label for="mdCreateFolderName" class="col-form-label fw-medium">{$LANG->getModule('ui_name_folder')} <span class="text-danger">(*)</span>:</label>
                        <input type="text" class="form-control" id="mdCreateFolderName" name="title" value="">
                        <div class="invalid-feedback">{$LANG->getGlobal('required_invalid')}</div>
                    </div>
                    <div class="hstack gap-2 justify-content-end">
                        <button type="submit" class="btn btn-primary"><i class="fa-solid fa-floppy-disk"></i> {$LANG->getGlobal('save')}</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal"><i class="fa-solid fa-xmark"></i> {$LANG->getGlobal('close')}</button>
                    </div>
                    <input type="hidden" name="folder_id" value="0">
                    <input type="hidden" name="add_folder" value="1">
                    <input type="hidden" name="checkss" value="{$smarty.const.NV_CHECK_SESSION}">
                </form>
            </div>
        </div>
    </div>
</div>

{* Menu của thư mục và tệp tin *}
<ul id="nasFileManagerFolderMenus" class="dropdown-menu dropdown-menu-file-manager"></ul>
<ul id="nasFileManagerFileMenus" class="dropdown-menu dropdown-menu-file-manager"></ul>

{* Upload từ internet *}
<div class="modal fade" id="mdUploadRemote" tabindex="-1" aria-labelledby="mdUploadRemoteLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <div class="modal-title fs-5" id="mdUploadRemoteLabel">{$LANG->getModule('ui_create_remote')}</div>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="{$LANG->getGlobal('close')}"></button>
            </div>
            <div class="modal-body">
                <form method="post" class="ajax-submit" action="{$smarty.const.NV_BASE_SITEURL}index.php?{$smarty.const.NV_LANG_VARIABLE}={$smarty.const.NV_LANG_DATA}&amp;{$smarty.const.NV_NAME_VARIABLE}={$MODULE_NAME}&amp;{$smarty.const.NV_OP_VARIABLE}={$OP}" novalidate>
                    <div class="mb-3">
                        <label for="mdUploadRemoteUrl" class="col-form-label fw-medium">{$LANG->getModule('ui_link')} <span class="text-danger">(*)</span>:</label>
                        <input type="text" class="form-control" id="mdUploadRemoteUrl" name="url" value="" placeholder="https://domain.com/uploads/file.jpg" autocomplete="off">
                        <div class="invalid-feedback">{$LANG->getGlobal('required_invalid')}</div>
                    </div>
                    <div class="mb-3">
                        <label for="mdUploadRemoteTitle" class="col-form-label fw-medium">{$LANG->getModule('ui_file_name')}:</label>
                        <input type="text" class="form-control" id="mdUploadRemoteTitle" name="title" value="">
                        <div class="invalid-feedback">{$LANG->getGlobal('required_invalid')}</div>
                    </div>
                    <div class="hstack gap-2 justify-content-end">
                        <button type="submit" class="btn btn-primary"><i class="fa-solid fa-floppy-disk"></i> {$LANG->getModule('ui_upload')}</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal"><i class="fa-solid fa-xmark"></i> {$LANG->getGlobal('close')}</button>
                    </div>
                    <input type="hidden" name="folder_id" value="0">
                    <input type="hidden" name="upload_remote" value="1">
                    <input type="hidden" name="checkss" value="{$smarty.const.NV_CHECK_SESSION}">
                </form>
            </div>
        </div>
    </div>
</div>

{* Thiết lập đồng bộ lên Google Drive *}
<div class="modal fade" id="mdSetupSyncGoogleDrive" tabindex="-1" aria-labelledby="mdSetupSyncGoogleDriveLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <div class="modal-title fs-5" id="mdSetupSyncGoogleDriveLabel">{$LANG->getModule('drconnect')}</div>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="{$LANG->getGlobal('close')}"></button>
            </div>
            <div class="modal-body">
                {if empty($API_GOOGLE_DRIVE)}
                <div class="alert alert-warning mb-0">
                    {$LANG->getModule('syncgdrive_error_noapi', "{$smarty.const.NV_BASE_SITEURL}index.php?{$smarty.const.NV_LANG_VARIABLE}={$smarty.const.NV_LANG_DATA}&amp;{$smarty.const.NV_NAME_VARIABLE}={$MODULE_NAME}&amp;{$smarty.const.NV_OP_VARIABLE}=drive-connect")}
                </div>
                {else}
                <form method="post" class="ajax-submit" action="{$smarty.const.NV_BASE_SITEURL}index.php?{$smarty.const.NV_LANG_VARIABLE}={$smarty.const.NV_LANG_DATA}&amp;{$smarty.const.NV_NAME_VARIABLE}={$MODULE_NAME}&amp;{$smarty.const.NV_OP_VARIABLE}={$OP}" novalidate>
                    <div class="mb-3">
                        <label for="mdSetupSyncGoogleDriveApiID" class="col-form-label fw-medium">{$LANG->getModule('syncgdrive_choose_api')} <span class="text-danger">(*)</span>:</label>
                        <select class="form-select" name="id" id="mdSetupSyncGoogleDriveApiID">
                            <option value="0">{$LANG->getModule('ui_please_select')}</option>
                            {foreach from=$API_GOOGLE_DRIVE item=api}
                            <option value="{$api.id}">{$api.title}</option>
                            {/foreach}
                        </select>
                        <div class="invalid-feedback">{$LANG->getGlobal('required_invalid')}</div>
                    </div>
                    <div class="form-loader d-none">
                        <i class="fa-solid fa-spinner fa-spin-pulse"></i> {$LANG->getModule('ui_please_wait')}
                    </div>
                    <div class="form-content">
                    </div>
                    <div class="hstack gap-2 justify-content-end">
                        <button type="submit" class="btn btn-primary"><i class="fa-solid fa-floppy-disk"></i> {$LANG->getGlobal('submit')}</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal"><i class="fa-solid fa-xmark"></i> {$LANG->getGlobal('close')}</button>
                    </div>
                    <div class="alert alert-info mt-3 mb-0">
                        {$LANG->getModule('syncgdrive_note')}
                    </div>
                    <input type="hidden" name="folder_id" value="0">
                    <input type="hidden" name="setupsyncgoogledrive" value="1">
                    <input type="hidden" name="checkss" value="{$smarty.const.NV_CHECK_SESSION}">
                </form>
                {/if}
            </div>
        </div>
    </div>
</div>

{* Đổi tên node *}
<div class="modal fade" id="mdRename" tabindex="-1" aria-labelledby="mdRenameLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <div class="modal-title fs-5" id="mdRenameLabel">{$LANG->getModule('ui_rename')}</div>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="{$LANG->getGlobal('close')}"></button>
            </div>
            <div class="modal-body">
                <form method="post" class="ajax-submit" action="{$smarty.const.NV_BASE_SITEURL}index.php?{$smarty.const.NV_LANG_VARIABLE}={$smarty.const.NV_LANG_DATA}&amp;{$smarty.const.NV_NAME_VARIABLE}={$MODULE_NAME}&amp;{$smarty.const.NV_OP_VARIABLE}={$OP}" novalidate>
                    <div class="mb-3">
                        <label for="mdRenameOld" class="col-form-label fw-medium">{$LANG->getModule('ui_link')}:</label>
                        <input type="text" class="form-control" id="mdRenameOld" name="old_name" value="" disabled>
                        <div class="invalid-feedback">{$LANG->getGlobal('required_invalid')}</div>
                    </div>
                    <div class="mb-3">
                        <label for="mdRenameNew" class="col-form-label fw-medium">{$LANG->getModule('ui_file_name')} <span class="text-danger">(*)</span>:</label>
                        <input type="text" class="form-control" id="mdRenameNew" name="new_name" value="">
                        <div class="invalid-feedback">{$LANG->getGlobal('required_invalid')}</div>
                    </div>
                    <div class="hstack gap-2 justify-content-end">
                        <button type="submit" class="btn btn-primary"><i class="fa-solid fa-floppy-disk"></i> {$LANG->getGlobal('submit')}</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal"><i class="fa-solid fa-xmark"></i> {$LANG->getGlobal('close')}</button>
                    </div>
                    <input type="hidden" name="id" value="0">
                    <input type="hidden" name="rename_node" value="1">
                    <input type="hidden" name="checkss" value="{$smarty.const.NV_CHECK_SESSION}">
                </form>
            </div>
        </div>
    </div>
</div>

{* Phát video *}
<div class="modal fade" id="mdPlayVideo" tabindex="-1" aria-labelledby="mdPlayVideoLabel" aria-hidden="true" data-bs-backdrop="static">
    <div class="modal-dialog modal-dialog-scrollable modal-dialog-centered modal-xl">
        <div class="modal-content">
            <div class="modal-header">
                <div class="modal-title fw-medium text-break" id="mdPlayVideoLabel"></div>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="{$LANG->getGlobal('close')}"></button>
            </div>
            <video id="mdPlayVideoElement" controls></video>
        </div>
    </div>
</div>

{* Tùy chỉnh thư mục *}
<div class="modal fade" id="mdFolderSetting" tabindex="-1" aria-labelledby="mdFolderSettingLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <div class="modal-title fs-5" id="mdFolderSettingLabel">{$LANG->getModule('ui_settings')} &quot;<span data-toggle="md-title"></span>&quot;</div>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="{$LANG->getGlobal('close')}"></button>
            </div>
            <div class="modal-body">
                <form method="post" class="ajax-submit" action="{$smarty.const.NV_BASE_SITEURL}index.php?{$smarty.const.NV_LANG_VARIABLE}={$smarty.const.NV_LANG_DATA}&amp;{$smarty.const.NV_NAME_VARIABLE}={$MODULE_NAME}&amp;{$smarty.const.NV_OP_VARIABLE}={$OP}" novalidate>
                    <div class="mb-3">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="show_type" value="grid" id="mdFolderSettingShowGird">
                            <label class="form-check-label" for="mdFolderSettingShowGird">{$LANG->getModule('setfolder_show_grid')}</label>
                        </div>
                        <div class="form-text">{$LANG->getModule('setfolder_show_grid_note')}</div>
                    </div>
                    <div class="mb-3">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="hide_media" value="1" id="mdFolderSettingHideMedia">
                            <label class="form-check-label" for="mdFolderSettingHideMedia">{$LANG->getModule('setfolder_hide_media')}</label>
                        </div>
                    </div>
                    <div class="hstack gap-2 justify-content-end">
                        <button type="submit" class="btn btn-primary"><i class="fa-solid fa-save"></i> {$LANG->getGlobal('submit')}</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal"><i class="fa-solid fa-xmark"></i> {$LANG->getGlobal('close')}</button>
                    </div>
                    <input type="hidden" name="folder_id" value="0">
                    <input type="hidden" name="save_setting_folder" value="1">
                    <input type="hidden" name="checkss" value="{$smarty.const.NV_CHECK_SESSION}">
                </form>
            </div>
        </div>
    </div>
</div>
