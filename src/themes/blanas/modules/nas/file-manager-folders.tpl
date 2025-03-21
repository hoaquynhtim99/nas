<div class="nas-folders-tree-inner">
    {assign var="catIcons" value=[
        "folder" => '<i class="bx bx-folder folder-icon pe-none"></i>',
        "folder_hassub" => '<i class="bx bx-folder-plus folder-icon pe-none"></i>',
        "drive" => '<i class="bx bx-folder folder-icon pe-none"></i>',
        "document" => '<i class="bx bx-file folder-icon pe-none"></i>',
        "media" => '<i class="bx bxs-file-image folder-icon pe-none"></i>',
        "history" => '<i class="bx bx-history folder-icon pe-none"></i>',
        "bookmark" => '<i class="bx bx-star folder-icon pe-none"></i>',
        "shared" => '<i class="bx bx-book-heart folder-icon pe-none"></i>',
        "trash" => '<i class="bx bx-trash folder-icon pe-none"></i>'
    ]}
    {function writeTrees parentid=0 tree=[]}
        {foreach from=$tree item=folder}
        {if $folder.parentid eq $parentid}
        {if in_array($REQUEST.folder_id, $folder.subcatids)}
        {assign var="is_open" value=1 nocache}
        {else}
        {assign var="is_open" value=0 nocache}
        {/if}
        <li class="{$folder.id eq $REQUEST.folder_id ? 'active ' : ''}{if $is_open} open{/if}">
            <div class="folder-item">
                {if $folder.numsubcat gt 0}
                <a class="me-1 folder-tree-collapse" data-bs-toggle="collapse" data-bs-target="#collapseFolder{$folder.id}" role="button" aria-expanded="{$is_open ? 'true' : 'false'}" aria-controls="collapseFolder{$folder.id}">{$catIcons.folder_hassub}</a>
                {/if}
                <a href="{$smarty.const.NV_BASE_SITEURL}index.php?{$smarty.const.NV_LANG_VARIABLE}={$smarty.const.NV_LANG_DATA}&amp;{$smarty.const.NV_NAME_VARIABLE}={$MODULE_NAME}&amp;{$smarty.const.NV_OP_VARIABLE}={$OP}&amp;folder_id={$folder.id}"
                    title="{$folder.title} ({$folder.node_size_show})"
                    data-title="{$folder.title}"
                    data-drive=""
                    data-folder-id="{$folder.id}"
                    data-view-type="{$folder.properties.show_type ?? ''}"
                    data-synced="{$folder.sync_appid ? 'true' : 'false'}"
                    data-sync-disabled="{$folder.sync_disabled ? 'true' : 'false'}"
                >
                    {if $folder.numsubcat le 0}
                    {$catIcons.folder}
                    {/if}
                    <span class="folder-name pe-none">{if $folder.sync_appid}<i class="fa-brands fa-google-drive icon-synced pe-none"></i> {/if}{$folder.title}</span>
                    {if $folder.node_size gt 0}
                    <small class="folder-size text-muted pe-none">(<span class="fw-bold">{$folder.node_size_show}</span>)</small>
                    {/if}
                </a>
            </div>
            {if $folder.numsubcat gt 0}
            <div class="collapse{$is_open ? ' show' : ''}" id="collapseFolder{$folder.id}" data-toggle="collapseFolder">
                <ul>
                    {writeTrees parentid=$folder.id tree=$tree}
                </ul>
            </div>
            {/if}
        </li>
        {/if}
        {/foreach}
    {/function}
    <ul class="folders">
        {foreach from=$CATEGORIES key=cat_type item=cat}
        <li class="{$cat.active ? 'active ' : ''}{$cat.open ? 'open ' : ''}">
            {if $cat_type eq 'drive'}
            {if not empty($ARRAY_FOLDERS)}
            <div class="folder-item">
                <a class="me-1 folder-tree-collapse" data-bs-toggle="collapse" data-bs-target="#collapseFolderRoot" role="button" aria-expanded="{$cat.open ? 'true' : 'false'}" aria-controls="collapseFolderRoot">{$catIcons.folder_hassub}</a>
                <a href="{$smarty.const.NV_BASE_SITEURL}index.php?{$smarty.const.NV_LANG_VARIABLE}={$smarty.const.NV_LANG_DATA}&amp;{$smarty.const.NV_NAME_VARIABLE}={$MODULE_NAME}&amp;{$smarty.const.NV_OP_VARIABLE}={$OP}"
                    data-title="{$cat.title}"
                    data-drive="{$cat_type}"
                    data-folder-id="0"
                    data-view-type=""
                >
                    <span class="folder-name pe-none">{$cat.title}</span>
                </a>
            </div>
            <div class="collapse{$cat.open ? ' show' : ''}" id="collapseFolderRoot" data-toggle="collapseFolder">
                <ul>
                    {writeTrees parentid=0 tree=$ARRAY_FOLDERS}
                </ul>
            </div>
            {else}
            <div class="folder-item">
                <a href="{$smarty.const.NV_BASE_SITEURL}index.php?{$smarty.const.NV_LANG_VARIABLE}={$smarty.const.NV_LANG_DATA}&amp;{$smarty.const.NV_NAME_VARIABLE}={$MODULE_NAME}&amp;{$smarty.const.NV_OP_VARIABLE}={$OP}"
                    data-title="{$cat.title}"
                    data-drive="{$cat_type}"
                    data-folder-id="0"
                    data-view-type=""
                >{$catIcons[$cat_type]} <span class="folder-name pe-none">{$cat.title}</span></a>
            </div>
            {/if}
            {else}
            <div class="folder-item">
                <a href="{$smarty.const.NV_BASE_SITEURL}index.php?{$smarty.const.NV_LANG_VARIABLE}={$smarty.const.NV_LANG_DATA}&amp;{$smarty.const.NV_NAME_VARIABLE}={$MODULE_NAME}&amp;{$smarty.const.NV_OP_VARIABLE}={$OP}&amp;drive={$cat_type}"
                    data-title="{$cat.title}"
                    data-drive="{$cat_type}"
                    data-folder-id="0"
                    data-view-type=""
                >{$catIcons[$cat_type]} <span class="folder-name pe-none">{$cat.title}</span></a>
            </div>
            {/if}
        </li>
        {/foreach}
    </ul>
</div>
