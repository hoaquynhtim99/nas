{if empty($ARRAY_NODES)}
<div class="alert alert-info my-3" role="alert">{$LANG->getModule('ui_no_nodes')}</div>
{else}
{foreach from=$ARRAY_NODES item=node}
{include file='define.tpl'}
<div class="file-item"
    data-id="{$node.id}"
    data-title="{$node.title}"
    data-node-type="{$node.node_type}"
    data-ext="{$node.node_ext}"
    data-width="{$node.image_width}"
    data-height="{$node.image_height}"
    data-trash="{$node.trash}"
    data-bookmarked="{$node.bookmarked}"
    data-ownership="{$node.ownership}"
    {if $node.node_type eq 0}data-link-download="{$node.link_download}"{/if}
    data-link-folder="{$node.link_folder}"
    data-zone="{($node.zoned_time eq -1 or $node.zoned_time gt $smarty.const.NV_CURRENTTIME) ? 1 : 0}"
>
    <div class="file-item-inner file-item-selectable">
        <div class="col-file-name">
            <div class="file-icons-titles">
                <div class="file-icons">
                    <div class="stock-icon{if $node.thumb or (isset($ARRAY_NODES_REFS[$node.id]) and !empty($ARRAY_NODES_REFS[$node.id].image_cover))} has-thumb{/if}">{$fileIcons[$node.icon] ?? $fileIcons.file}</div>
                    {if $node.thumb}
                    <div class="thumb-icon">
                        <img alt="{$node.title}" src="{$smarty.const.NV_BASE_SITEURL}{$smarty.const.NV_ASSETS_DIR}/nas-data/{$NUSER.user_dir}/{$node.path}">
                    </div>
                    {elseif isset($ARRAY_NODES_REFS[$node.id]) and !empty($ARRAY_NODES_REFS[$node.id].image_cover)}
                    <div class="thumb-icon">
                        <img alt="{$node.title}" src="{$smarty.const.NV_BASE_SITEURL}{$smarty.const.NV_ASSETS_DIR}/nas-cover/{$ARRAY_NODES_REFS[$node.id].image_cover}">
                    </div>
                    {/if}
                </div>
                <div class="file-titles">
                    <div class="file-title text-break text-truncate-2" title="{$node.title}">{$node.title}</div>
                    <div class="file-type text-muted fs-sm">{$node.node_ext ?: $LANG->getModule('ui_folder')}</div>
                    <div class="file-size text-muted fs-sm">
                        {$node.node_size_show}{if not empty($node.duration_show)}, {$node.duration_show}s{/if}
                    </div>
                </div>
            </div>
        </div>
        <div class="col-file-size">
            <div class="text-break">{$node.node_size_show}{if not empty($node.duration_show)}, {$node.duration_show}s{/if}</div>
        </div>
        <div class="col-file-type">
            <div class="text-break">{$node.node_ext ?: $LANG->getModule('ui_folder')}</div>
        </div>
        <div class="col-file-date">
            <div class="text-break">{$node.edit_time_show}</div>
        </div>
        <div class="col-file-actions">
            <div class="hstack gap-2">
                {if $node.node_type eq 0 and $node.trash eq 0}
                <button class="btn btn-light btn-sm" data-toggle="fileBookmark" aria-label="{$LANG->getModule('ui_toggle_bookmark')}"><i class="fa-solid fa-star text-{$node.bookmarked ? 'warning' : 'muted'}"></i></button>
                {/if}
                <button class="btn btn-light btn-sm" data-toggle="menuFile" aria-label="{$LANG->getModule('ui_open_menu_file')}"><i class="fa-solid fa-grip text-muted pe-none"></i></button>
            </div>
        </div>
    </div>
</div>
{/foreach}
{if not empty($PAGINATION)}
<div class="d-flex justify-content-end mt-3 pagination-wrap" data-toggle="filePagination">
    {$PAGINATION}
</div>
{/if}
{/if}
