{include file='define.tpl'}
<script type="text/javascript" src="{$smarty.const.NV_STATIC_URL}themes/{$GCONFIG.module_theme}/js/nas.main.js"></script>
<div class="nas-main-scroller" id="nasMainScroller">
    <div class="nas-main-inner">
        <div class="p-3 nas-mainpage-grid">
            {foreach from=$ARRAY_APPS key=appop item=title}
            <div class="main-item {$appop}">
                <a class="main-item-inner" href="{$smarty.const.NV_BASE_SITEURL}index.php?{$smarty.const.NV_LANG_VARIABLE}={$smarty.const.NV_LANG_DATA}&amp;{$smarty.const.NV_NAME_VARIABLE}={$MODULE_NAME}&amp;{$smarty.const.NV_OP_VARIABLE}={$appop}" title="{$title}">
                    <div class="i-icon">
                        {$appIcons[$appop]}
                    </div>
                    <div class="i-name text-truncate-2">
                        {$title}
                    </div>
                </a>
            </div>
            {/foreach}
        </div>
    </div>
</div>
