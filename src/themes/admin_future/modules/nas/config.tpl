<form method="post" class="ajax-submit" action="{$smarty.const.NV_BASE_ADMINURL}index.php?{$smarty.const.NV_LANG_VARIABLE}={$smarty.const.NV_LANG_DATA}&amp;{$smarty.const.NV_NAME_VARIABLE}={$MODULE_NAME}&amp;{$smarty.const.NV_OP_VARIABLE}={$OP}" novalidate>
    <div class="row g-3">
        <div class="col-xxl-6">
            <div class="card border-primary border-3 border-bottom-0 border-start-0 border-end-0">
                <div class="card-header fs-5 fw-medium py-2">{$LANG->getModule('config_general')}</div>
                <div class="card-body">
                    <div class="row mb-3 g-2">
                        <label for="element_system_quota" class="col-sm-3 col-form-label text-sm-end">{$LANG->getModule('system_quota')}</label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <div class="input-group">
                                <input type="text" class="form-control" id="element_system_quota" name="system_quota" value="{$DATA.system_quota}">
                                <button type="button" class="btn btn-secondary" data-toggle="getSystemQuote"><i class="fa-solid fa-pen-ruler" data-icon="fa-pen-ruler"></i> {$LANG->getModule('system_quota_auto')}</button>
                            </div>
                            <div class="invalid-feedback">{$LANG->getGlobal('required_invalid')}</div>
                            <div class="form-text">{$LANG->getModule('system_quota_hint')}</div>
                        </div>
                    </div>
                    <div class="row g-2">
                        <div class="col-sm-8 offset-sm-3">
                            <input type="hidden" name="checkss" value="{$smarty.const.NV_CHECK_SESSION}">
                            <button type="submit" class="btn btn-primary">{$LANG->getGlobal('submit')}</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xxl-6">
            <div class="card border-primary border-3 border-bottom-0 border-start-0 border-end-0">
                <div class="card-header fs-5 fw-medium py-2">{$LANG->getModule('config_rtc')}</div>
                <div class="card-body">
                    <div class="row mb-3 g-2">
                        <label for="element_websocket_url" class="col-sm-3 col-form-label text-sm-end">{$LANG->getModule('websocket_url')}</label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <input type="text" class="form-control" id="element_websocket_url" name="websocket_url" value="{$DATA.websocket_url}">
                            <div class="invalid-feedback">{$LANG->getGlobal('required_invalid')}</div>
                        </div>
                    </div>
                    <div class="row mb-3 g-2">
                        <div class="col-sm-8 offset-sm-3">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" name="turn_enabled" value="1"{if not empty($DATA.turn_enabled)} checked{/if} role="switch" id="element_turn_enabled">
                                <label class="form-check-label" for="element_turn_enabled">{$LANG->getModule('config_turn_enabled')}</label>
                            </div>
                        </div>
                    </div>
                    <div class="row mb-3 g-2">
                        <label for="element_turn_public" class="col-sm-3 col-form-label text-sm-end">{$LANG->getModule('config_turn_public')}</label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <select class="form-select w-auto mw-100" name="turn_public" id="element_turn_public">
                                <option value="0"{if $DATA.turn_public eq 0} selected{/if}>{$LANG->getModule('config_turn_public0')}</option>
                                <option value="1"{if $DATA.turn_public eq 1} selected{/if}>{$LANG->getModule('config_turn_public1')}</option>
                            </select>
                            <div class="invalid-feedback">{$LANG->getGlobal('required_invalid')}</div>
                        </div>
                    </div>
                    <div class="row mb-3 g-2">
                        <label for="element_turn_type" class="col-sm-3 col-form-label text-sm-end">{$LANG->getModule('config_turn_type')}</label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <select class="form-select w-auto mw-100" name="turn_type" id="element_turn_type">
                                <option value="0"{if $DATA.turn_type eq 0} selected{/if}>{$LANG->getModule('config_turn_type0')}</option>
                                <option value="1"{if $DATA.turn_type eq 1} selected{/if}>{$LANG->getModule('config_turn_type1')}</option>
                            </select>
                            <div class="invalid-feedback">{$LANG->getGlobal('required_invalid')}</div>
                        </div>
                    </div>
                    <div class="row mb-3 g-2">
                        <label for="element_coturn_server" class="col-sm-3 col-form-label text-sm-end">{$LANG->getModule('config_coturn_server')}</label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <input type="text" class="form-control" id="element_coturn_server" name="coturn_server" value="{$DATA.coturn_server}">
                            <div class="invalid-feedback">{$LANG->getGlobal('required_invalid')}</div>
                        </div>
                    </div>
                    <div class="row mb-3 g-2">
                        <label for="element_coturn_auth" class="col-sm-3 col-form-label text-sm-end">{$LANG->getModule('config_coturn_auth')}</label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <select class="form-select w-auto mw-100" name="coturn_auth" id="element_coturn_auth">
                                <option value="0"{if $DATA.coturn_auth eq 0} selected{/if}>{$LANG->getModule('config_coturn_auth0')}</option>
                                <option value="1"{if $DATA.coturn_auth eq 1} selected{/if}>{$LANG->getModule('config_coturn_auth1')}</option>
                            </select>
                            <div class="invalid-feedback">{$LANG->getGlobal('required_invalid')}</div>
                        </div>
                    </div>
                    <div class="row mb-3 g-2">
                        <label for="element_coturn_user" class="col-sm-3 col-form-label text-sm-end">{$LANG->getModule('config_coturn_user')}</label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <input type="text" class="form-control" id="element_coturn_user" name="coturn_user" value="{$DATA.coturn_user}">
                            <div class="invalid-feedback">{$LANG->getGlobal('required_invalid')}</div>
                        </div>
                    </div>
                    <div class="row mb-3 g-2">
                        <label for="element_coturn_pass" class="col-sm-3 col-form-label text-sm-end">{$LANG->getModule('config_coturn_pass')}</label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <input type="text" class="form-control" id="element_coturn_pass" name="coturn_pass" value="{$DATA.coturn_pass}">
                            <div class="invalid-feedback">{$LANG->getGlobal('required_invalid')}</div>
                        </div>
                    </div>
                    <div class="row mb-3 g-2">
                        <label for="element_coturn_secret" class="col-sm-3 col-form-label text-sm-end">{$LANG->getModule('config_coturn_secret')}</label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <input type="text" class="form-control" id="element_coturn_secret" name="coturn_secret" value="{$DATA.coturn_secret}">
                            <div class="invalid-feedback">{$LANG->getGlobal('required_invalid')}</div>
                        </div>
                    </div>
                    <div class="row mb-3 g-2">
                        <label for="element_coturn_live" class="col-sm-3 col-form-label text-sm-end">{$LANG->getModule('config_coturn_live')}</label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <input type="number" min="1" max="999999" class="form-control w-auto mw-100" id="element_coturn_live" name="coturn_live" value="{$DATA.coturn_live}">
                            <div class="invalid-feedback">{$LANG->getGlobal('required_invalid')}</div>
                        </div>
                    </div>
                    <div class="row mb-3 g-2">
                        <div class="col-sm-3 col-form-label text-sm-end">{$LANG->getModule('config_turn_type0')}</div>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <div class="ice-servers items vstack gap-3">
                                {foreach from=$DATA.ice_servers key=key item=value}
                                <div class="item border border-primary rounded-2 p-2">
                                    <div class="text-end">
                                        <button class="btn btn-sm btn-secondary" type="button" data-toggle="addIceServers"><i class="fa-solid fa-plus text-success"></i> {$LANG->getGlobal('add')}</button>
                                        <button class="btn btn-sm btn-secondary" type="button" data-toggle="delIceServers"><i class="fa-solid fa-trash text-danger"></i> {$LANG->getGlobal('delete')}</button>
                                    </div>
                                    <div class="mt-2 grup">
                                        <label for="ice_username_{$key}" class="form-label lbl">Username</label>
                                        <input type="text" class="form-control ipt" id="ice_username_{$key}" name="ice_username[]" value="{$value.username}">
                                    </div>
                                    <div class="mt-2 grup">
                                        <label for="ice_credential_{$key}" class="form-label lbl">Credential</label>
                                        <input type="text" class="form-control ipt" id="ice_credential_{$key}" name="ice_credential[]" value="{$value.credential}">
                                    </div>
                                    <div class="mt-2 grup">
                                        <label for="ice_urls_{$key}" class="form-label lbl">Urls, {$LANG->getModule('config_ice_urls_note')}</label>
                                        <textarea class="form-control ipt" id="ice_urls_{$key}" name="ice_urls[]" rows="3">{if not empty($value.urls)}{$value.urls|join:"\n"}{/if}</textarea>
                                    </div>
                                </div>
                                {/foreach}
                            </div>
                        </div>
                    </div>
                    <div class="row g-2">
                        <div class="col-sm-8 offset-sm-3">
                            <input type="hidden" name="checkss" value="{$smarty.const.NV_CHECK_SESSION}">
                            <button type="submit" class="btn btn-primary">{$LANG->getGlobal('submit')}</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</form>
