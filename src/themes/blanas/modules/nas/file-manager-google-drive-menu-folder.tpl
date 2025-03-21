<div class="mb-3 fs-5 fw-medium">
    {if empty($FOLDER_ID)}
    {$LANG->getModule('syncgdrive_root_folder')}
    {else}
    {$FOLDER_NAME}
    {/if}
</div>
<ul class="list-group mb-3">
    {foreach from=$FILES item=file}
    <li class="list-group-item">
        <div class="hstack gap-2">
            <input type="radio" class="form-check-input" name="drive_id" value="{$file->getId()}">
            <div class="me-auto">
                {$file->getName()}
            </div>
            <div class="hstack gap-1">
                {if not empty($FOLDER_ID)}
                <button class="btn btn-sm btn-secondary" type="button" data-toggle="loadGoogleDriveFolder" data-mode="back" data-parent-name="{$FOLDER_NAME}" data-parent-id="{$FOLDER_ID}" data-name="{$file->getName()}" data-id="{$file->getId()}"><i class="fa-solid fa-angle-left" data-icon="fa-angle-left"></i></button>
                {/if}
                <button class="btn btn-sm btn-secondary" type="button" data-toggle="loadGoogleDriveFolder" data-mode="next" data-parent-name="{$FOLDER_NAME}" data-parent-id="{$FOLDER_ID}" data-name="{$file->getName()}" data-id="{$file->getId()}"><i class="fa-solid fa-angle-right" data-icon="fa-angle-right"></i></button>
            </div>
        </div>
    </li>
    {/foreach}
</ul>
