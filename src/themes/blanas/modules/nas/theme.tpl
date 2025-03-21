{include file='define.tpl'}
<div class="nas-app-body no-left-menu">
    <header class="nas-header d-flex justify-content-between">
        <div class="d-inline-flex align-items-center justify-content-center">
            <div class="m-0 fs-1 fw-bold">{$GCONFIG.site_name}</div>
        </div>
        <div>
            <div class="d-flex align-items-center nas-header-right">
                {if not $HOME}
                <div class="header-item d-flex align-items-center ms-1">
                    <a class="d-block btn-icon d-inline-flex align-items-center justify-content-center rounded-circle fs-3" href="{$smarty.const.NV_BASE_SITEURL}" data-bs-toggle="tooltip" data-bs-title="{$LANG->getModule('ui_gohome')}" data-bs-trigger="hover" aria-label="{$LANG->getModule('ui_gohome')}">
                        <i class="bx bx-home align-middle"></i>
                    </a>
                </div>
                {/if}
                {if $OP eq 'file-manager'}
                <div class="header-item d-flex align-items-center ms-1">
                    <a data-toggle="uiReloadFileLists" class="d-block btn-icon d-inline-flex align-items-center justify-content-center rounded-circle fs-3" href="#" data-bs-toggle="tooltip" data-bs-title="{$LANG->getModule('ui_reload')}" data-bs-trigger="hover" aria-label="{$LANG->getModule('ui_reload')}">
                        <i class="bx bx-refresh align-middle"></i>
                    </a>
                </div>
                {/if}
                {if not empty($ARRAY_APPS)}
                <div class="header-item d-flex align-items-center ms-1">
                    <a class="d-block btn-icon d-inline-flex align-items-center justify-content-center rounded-circle fs-3" href="#" data-bs-toggle="tooltip" data-bs-title="{$LANG->getModule('ui_appsopen')}" data-bs-trigger="hover" data-toggle="openApps" aria-label="{$LANG->getModule('ui_appsopen')}">
                        <i class="bx bx-category-alt align-middle"></i>
                    </a>
                </div>
                {/if}
                {if not $smarty.const.NV_IS_USER}
                <div class="user ms-2 d-flex align-items-center">
                    <a rel="nofollow" href="{$LOGIN_LINK}" class="btn btn-info"><i class="fa-solid fa-arrow-right-to-bracket"></i> {$LANG->getGlobal('signin')}</a>
                </div>
                {else}
                <div class="user dropdown ms-2">
                    <a class="user-dropdown d-inline-flex align-items-center justify-content-center" href="#" data-bs-toggle="dropdown" aria-expanded="false" data-bs-auto-close="outside">
                        {if not empty($USER.avata)}
                        <img class="rounded-circle" alt="{$USER.full_name}" src="{$USER.avata}">
                        {else}
                        <i class="no-avata bx bxs-user-circle fs-1"></i>
                        {/if}
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><div class="dropdown-header">{$USER.full_name}</div></li>
                        {if not empty($NUSER.admin_info)}
                        <li><a class="dropdown-item" href="{$smarty.const.NV_BASE_ADMINURL}index.php?{$smarty.const.NV_LANG_VARIABLE}={$smarty.const.NV_LANG_DATA}"><i class="fa-solid fa-user-tie fa-fw text-center"></i> {$LANG->getModule('ui_admin')}</a></li>
                        {if $NUSER.admin_info.lev lt 3}
                        <li><a class="dropdown-item" href="{$smarty.const.NV_BASE_ADMINURL}index.php?{$smarty.const.NV_LANG_VARIABLE}={$smarty.const.NV_LANG_DATA}&amp;{$smarty.const.NV_NAME_VARIABLE}={$MODULE_NAME}"><i class="fa-solid fa-screwdriver-wrench fa-fw text-center"></i> {$LANG->getModule('ui_adminmodule')}</a></li>
                        {/if}
                        {/if}
                        <li><a class="dropdown-item" href="{$smarty.const.NV_BASE_SITEURL}index.php?{$smarty.const.NV_LANG_VARIABLE}={$smarty.const.NV_LANG_DATA}&amp;{$smarty.const.NV_NAME_VARIABLE}=users&amp;{$smarty.const.NV_OP_VARIABLE}=logout"><i class="fa-solid fa-arrow-right-from-bracket fa-fw text-center text-danger fa-flip-horizontal"></i> {$LANG->getModule('ui_logout')}</a></li>
                    </ul>
                </div>
                {/if}
            </div>
        </div>
    </header>
    <nav class="nas-navbar-menu">
    </nav>
    <div class="nas-main-content">
        <div class="nas-main-content-inner">
            {$MODULE_CONTENTS}
        </div>
    </div>
</div>

<div class="modal fade" id="mdNasApps" tabindex="-1" aria-labelledby="mdNasAppsLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-dialog-centered modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <div class="modal-title fs-5" id="mdNasAppsLabel">{$LANG->getModule('ui_apps')}</div>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="{$LANG->getGlobal('close')}"></button>
            </div>
            <div class="modal-body">
                <div class="row g-3 justify-content-center">
                    {foreach from=$ARRAY_APPS key=appop item=appname}
                    <div class="col-auto">
                        <a class="nas-app-item text-center d-block" href="{$smarty.const.NV_BASE_SITEURL}index.php?{$smarty.const.NV_LANG_VARIABLE}={$smarty.const.NV_LANG_DATA}&amp;{$smarty.const.NV_NAME_VARIABLE}={$MODULE_NAME}&amp;{$smarty.const.NV_OP_VARIABLE}={$appop}" title="{$appname}">
                            <span class="app-icon {$appop} d-inline-flex align-items-center justify-content-center">{$appIcons[$appop]}</span>
                            <span class="app-link d-block text-truncate-2">{$appname}</span>
                        </a>
                    </div>
                    {/foreach}
                </div>
            </div>
        </div>
    </div>
</div>
