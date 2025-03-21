<div class="card">
    <div class="card-body">
        <form method="get" action="{$smarty.const.NV_BASE_ADMINURL}index.php">
            <input type="hidden" name="{$smarty.const.NV_LANG_VARIABLE}" value="{$smarty.const.NV_LANG_DATA}">
            <input type="hidden" name="{$smarty.const.NV_NAME_VARIABLE}" value="{$MODULE_NAME}">
            <div class="row g-2 align-items-center">
                <div class="col-auto">
                    <div class="input-group">
                        <input type="text" class="form-control" name="q" value="{$SEARCH.q}" maxlength="64" placeholder="{$LANG->getGlobal('keyword')}" aria-label="{$LANG->getGlobal('keyword')}">
                        <button type="submit" class="btn btn-primary text-nowrap"><i class="fa-solid fa-magnifying-glass"></i> {$LANG->getGlobal('search')}</button>
                    </div>
                </div>
                <div class="col">
                    <a href="#" data-toggle="addUser" class="btn btn-success text-nowrap"><i class="fa-solid fa-user-plus"></i> {$LANG->getModule('user_add')}</a>
                </div>
            </div>
        </form>
    </div>
    <div class="card-body">
        <div class="table-responsive-lg table-card">
            <table class="table table-striped align-middle table-sticky mb-0">
                <thead class="text-muted">
                    <tr>
                        <th class="text-nowrap" style="width: 1%;">
                            <input type="checkbox" name="checkAll[]" data-toggle="checkAll" class="form-check-input m-0 align-middle" aria-label="{$LANG->getGlobal('toggle_checkall')}">
                        </th>
                        <th class="text-nowrap" style="width: 30%;">
                            <a href="{$BASE_URL_ORDER}{if $ARRAY_ORDER.field neq 'first_name' or $ARRAY_ORDER.value neq 'desc'}&amp;of=first_name{if $ARRAY_ORDER.field neq 'first_name' or empty($ARRAY_ORDER.value)}&amp;ov=asc{else}&amp;ov=desc{/if}{/if}" class="d-flex align-items-center justify-content-between">
                                <span class="me-1">{$LANG->getModule('user')}</span>
                                {if $ARRAY_ORDER.field neq 'first_name' or empty($ARRAY_ORDER.value)}<i class="fa-solid fa-sort"></i>{elseif $ARRAY_ORDER.value eq 'asc'}<i class="fa-solid fa-sort-up"></i>{else}<i class="fa-solid fa-sort-down"></i>{/if}
                            </a>
                        </th>
                        <th class="text-nowrap" style="width: 15%;">
                            <a href="{$BASE_URL_ORDER}{if $ARRAY_ORDER.field neq 'add_time' or $ARRAY_ORDER.value neq 'desc'}&amp;of=add_time{if $ARRAY_ORDER.field neq 'add_time' or empty($ARRAY_ORDER.value)}&amp;ov=asc{else}&amp;ov=desc{/if}{/if}" class="d-flex align-items-center justify-content-between">
                                <span class="me-1">{$LANG->getModule('addtime')}</span>
                                {if $ARRAY_ORDER.field neq 'add_time' or empty($ARRAY_ORDER.value)}<i class="fa-solid fa-sort"></i>{elseif $ARRAY_ORDER.value eq 'asc'}<i class="fa-solid fa-sort-up"></i>{else}<i class="fa-solid fa-sort-down"></i>{/if}
                            </a>
                        </th>
                        <th class="text-nowrap" style="width: 15%;">{$LANG->getModule('quota_limit_sort')}</th>
                        <th class="text-nowrap" style="width: 15%;">{$LANG->getModule('quota_current')}</th>
                        <th class="text-nowrap text-center" style="width: 10%;">{$LANG->getModule('status')}</th>
                        <th class="text-nowrap text-center" style="width: 14%;">{$LANG->getModule('function')}</th>
                    </tr>
                </thead>
                <tbody>
                    {foreach from=$DATA key=key item=row}
                    <tr class="user-items">
                        <td>
                            <input type="checkbox" name="checkSingle[]" data-toggle="checkSingle" value="{$row.userid}" class="form-check-input m-0 align-middle" aria-label="{$LANG->getGlobal('toggle_checksingle')}">
                        </td>
                        <td>
                            <div class="d-flex">
                                <div class="me-2">
                                    <div class="rounded-circle overflow-hidden image">
                                        {if not empty($row.photo)}
                                        <img src="{$row.photo}" alt="{$row.full_name}">
                                        {else}
                                        <i class="fa-solid fa-circle-user fa-3x text-muted"></i>
                                        {/if}
                                    </div>
                                </div>
                                <div class="flex-fill">
                                    <div class="fw-medium">{$row.full_name} ({$row.username})</div>
                                    <div><a href="mailto:{$row.email}">{$row.email}</a></div>
                                </div>
                            </div>
                        </td>
                        <td>{$row.add_time}</td>
                        <td>{$row.quota_limit_show}</td>
                        <td>{$row.quota_current_show}</td>
                        <td class="text-center">
                            <div class="form-check form-switch mb-0 d-inline-block">
                                <input class="form-check-input" type="checkbox" role="switch" name="status[{$row.userid}]" data-toggle="statusUser" value="{$row.userid}"{if not empty($row.status)} checked{/if} aria-label="{$LANG->getModule('status')}">
                            </div>
                        </td>
                        <td class="text-nowrap text-center">
                            <a href="#" data-toggle="editUser" data-userid="{$row.userid}" data-quota="{$row.quota_limit_text}" data-username="{$row.username}" class="btn btn-sm btn-secondary"><i class="fa-solid fa-pen"></i> {$LANG->getGlobal('edit')}</a>
                            <a href="#" data-toggle="delUser" data-userid="{$row.userid}" class="btn btn-sm btn-danger"><i class="fa-solid fa-trash"></i> {$LANG->getGlobal('delete')}</a>
                        </td>
                    </tr>
                    {/foreach}
                </tbody>
            </table>
        </div>
    </div>
    <div class="card-footer border-top">
        <div class="d-flex flex-wrap justify-content-between align-items-center">
            <div class="d-flex flex-wrap flex-sm-nowrap align-items-center">
                <div class="me-2">
                    <input type="checkbox" name="checkAll[]" data-toggle="checkAll" class="form-check-input m-0 align-middle" aria-label="{$LANG->getGlobal('toggle_checkall')}">
                </div>
                <div class="input-group me-1 my-1">
                    <select id="element_action" class="form-select fw-150" aria-label="{$LANG->getGlobal('select_actions')}" aria-describedby="element_action_btn">
                        <option value="delete">{$LANG->getGlobal('delete')}</option>
                    </select>
                    <button class="btn btn-primary" type="button" id="element_action_btn" data-toggle="actionUser">{$LANG->getGlobal('submit')}</button>
                </div>
            </div>
            <div class="pagination-wrap">
                {$PAGINATION}
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="mdUserContent" tabindex="-1" aria-labelledby="mdUserContentLabel" aria-hidden="true" data-mess-add="{$LANG->getModule('user_add')}" data-mess-edit="{$LANG->getModule('user_edit')}" data-bs-backdrop="static">
    <form class="modal-dialog ajax-submit" method="post" action="{$smarty.const.NV_BASE_ADMINURL}index.php?{$smarty.const.NV_LANG_VARIABLE}={$smarty.const.NV_LANG_DATA}&amp;{$smarty.const.NV_NAME_VARIABLE}={$MODULE_NAME}" novalidate>
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title text-truncate" id="mdUserContentLabel">{$LANG->getModule('user_add')}</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="{$LANG->getGlobal('close')}"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <label for="element_username" class="col-form-label">{$LANG->getModule('user_pick')} <span class="text-danger">(*)</span>:</label>
                    <div class="input-group">
                        <input type="text" class="form-control" id="element_username" name="username" value="" aria-describedby="element_username_btn" autocomplete="username">
                        <button type="button" class="btn btn-secondary" id="element_username_btn"><i class="fa-solid fa-user"></i> {$LANG->getModule('user_pick1')}</button>
                    </div>
                    <div class="invalid-feedback">{$LANG->getGlobal('required_invalid')}</div>
                </div>
                <div>
                    <label for="element_quota_limit" class="col-form-label">{$LANG->getModule('quota_limit')}:</label>
                    <input type="text" class="form-control" id="element_quota_limit" name="quota_limit" value="">
                    <div class="invalid-feedback">{$LANG->getGlobal('required_invalid')}</div>
                    <div class="form-text">{$LANG->getModule('quota_limit_hint')}</div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-primary"><i class="fa-solid fa-floppy-disk" data-icon="fa-floppy-disk"></i> {$LANG->getGlobal('save')}</button>
                <input type="hidden" name="saveform" value="{$smarty.const.NV_CHECK_SESSION}">
                <input type="hidden" name="userid" value="0">
            </div>
        </div>
    </form>
</div>
