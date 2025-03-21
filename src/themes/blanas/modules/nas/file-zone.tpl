{include file='define.tpl'}
<script type="text/javascript" src="{$smarty.const.NV_STATIC_URL}themes/{$GCONFIG.module_theme}/js/nas.zone.js"></script>
<div class="px-4 py-3">
    <h1 class="mb-3 fs-3">{$LANG->getModule('app_fzone')}</h1>
    <form method="get" action="{if empty($GCONFIG.rewrite_enable)}{$smarty.const.NV_BASE_SITEURL}index.php{else}{$smarty.const.NV_BASE_SITEURL}index.php?{$smarty.const.NV_LANG_VARIABLE}={$smarty.const.NV_LANG_DATA}&amp;{$smarty.const.NV_NAME_VARIABLE}={$MODULE_NAME}&amp;{$smarty.const.NV_OP_VARIABLE}={$OP}{/if}">
        {if empty($GCONFIG.rewrite_enable)}
        <input type="hidden" name="{$smarty.const.NV_LANG_VARIABLE}" value="{$smarty.const.NV_LANG_DATA}">
        <input type="hidden" name="{$smarty.const.NV_NAME_VARIABLE}" value="{$smarty.const.MODULE_NAME}">
        <input type="hidden" name="{$smarty.const.NV_NAME_VARIABLE}" value="{$smarty.const.OP}">
        {/if}
        <div class="mb-4 d-flex gap-2 align-items-center">
            <input type="text" name="q" value="{$SEARCH.q}" class="form-control w-auto mw-100" placeholder="{$LANG->getGlobal('keyword')}" aria-label="{$LANG->getGlobal('keyword')}">
            <button type="submit" class="btn btn-primary text-nowrap"><i class="fa-solid fa-magnifying-glass"></i> {$LANG->getGlobal('search')}</button>
        </div>
    </form>
    {if empty($FILES)}
    {if not empty($SEARCH.q)}
    <div class="alert alert-info" role="alert">{$LANG->getModule('fzone_search_empty')}</div>
    {else}
    <div class="alert alert-info" role="alert">{$LANG->getModule('fzone_empty')}</div>
    {/if}
    {else}
    <div class="card py-3">
        <ul class="list-group list-group-flush">
            {foreach from=$FILES item=file}
            <li class="list-group-item">
                <div class="hstack gap-2 justify-content-between align-items-center">
                    <div class="text-break text-truncate-2">
                        <a class="fw-medium" href="{$file.link_download}">{$fileIcons[$file.icon] ?? $fileIcons.file} {$file.title}</a>
                        <span class="text-muted">({$file.node_size_show}{if not empty($file.duration_show)}, {$file.duration_show}s{/if})</span>
                    </div>
                    {if $smarty.const.NV_IS_USER and $USER.userid eq $file.userid}
                    <button type="button" class="btn btn-sm btn-info" data-toggle="unzone" data-id="{$file.id}" data-checkss="{$smarty.const.NV_CHECK_SESSION}"><i class="fa-solid fa-arrow-down-up-lock" data-icon="fa-arrow-down-up-lock"></i> {$LANG->getModule('ui_unzone')}</button>
                    {/if}
                </div>
            </li>
            {/foreach}
        </ul>
    </div>
    {/if}
    {if not empty($PAGINATION)}
    <div class="d-flex justify-content-end mt-3 pagination-wrap">
        {$PAGINATION}
    </div>
    {/if}
</div>
