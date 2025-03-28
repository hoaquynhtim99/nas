<!-- BEGIN: add -->
<link type="text/css" href="{ASSETS_STATIC_URL}/js/jquery-ui/jquery-ui.min.css" rel="stylesheet" />
<link rel="stylesheet" href="{NV_BASE_SITEURL}themes/{TEMPLATE}/js/colpick.css">

<script type="text/javascript" src="{ASSETS_STATIC_URL}/js/jquery-ui/jquery-ui.min.js"></script>
<script type="text/javascript" src="{ASSETS_LANG_STATIC_URL}/js/language/jquery.ui.datepicker-{NV_LANG_INTERFACE}.js"></script>
<script src="{NV_BASE_SITEURL}themes/{TEMPLATE}/js/colpick.js"></script>

<div id="pageContent">
    <form id="addCat" method="post" action="{ACTION_URL}">
        <h3 class="myh3">{PTITLE}</h3>
        <!-- BEGIN: basic_infomation -->
        <div class="table-responsive">
            <table class="table table-striped table-bordered table-hover">
                <colgroup>
                    <col class="w300"/>
                    <col />
                </colgroup>
                <tbody>
                    <tr>
                        <td>{LANG.title} <span style="color:red">*</span>:</td>
                        <td><input title="{LANG.title}" class="form-control" type="text" name="title" value="{DATA.title}" maxlength="240" /></td>
                    </tr>
                    <tr>
                        <td>{LANG.alias}:</td>
                        <td>
                            <div class="input-group">
                                <input title="{LANG.alias}" class="form-control" type="text" name="alias" value="{DATA.alias}" maxlength="240" />
                                <span class="input-group-btn"><button class="btn btn-default" type="button" onclick="get_alias();"><em class="fa fa-refresh"></em></button></span>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>{LANG.group_description}:</td>
                        <td><input title="{LANG.group_description}" class="form-control" type="text" name="description" value="{DATA.description}" maxlength="240" /></td>
                    </tr>
                    <tr>
                        <td>{LANG.exp_time}:</td>
                        <td>
                            <div class="input-group w250 pull-left">
                                <input type="text" name="exp_time" class="form-control" value="{DATA.exp_time}" maxlength="10" />
                                <div class="input-group-btn">
                                    <button type="button" class="btn btn-default" data-toggle="opendatepicker"><i class="fa fa-calendar"></i></button>
                                </div>
                            </div>
                            <label class="control-label-inline">{LANG.emptyIsUnlimited}</label>
                        </td>
                    </tr>
                    <tr>
                        <td>{LANG.group_type}:</td>
                        <td>
                            <select class="form-control w250" name="group_type">
                                <!-- BEGIN: group_type --><option value="{GROUP_TYPE.key}"{GROUP_TYPE.selected}>{GROUP_TYPE.title}</option><!-- END: group_type -->
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td>{LANG.group_is_default}:</td>
                        <td><input type="checkbox" name="is_default" value="1"{DATA.is_default}/></td>
                    </tr>
                    <!-- BEGIN: siteus -->
                    <tr>
                        <td>{LANG.siteus}:</td>
                        <td><input title="{LANG.siteus}" type="checkbox" name="siteus" value="1"{DATA.siteus} /></td>
                    </tr>
                    <!-- END: siteus -->
                </tbody>
            </table>
        </div>
        <div class="clearfix">
            {LANG.content}
        </div>
        <div class="clearfix m-bottom">
            {CONTENT}
        </div>
        <!-- END: basic_infomation -->

        <div class="table-responsive">
            <table class="table table-striped table-bordered table-hover">
                <colgroup>
                    <col class="w300"/>
                    <col />
                </colgroup>
                <tbody>
                    <!-- BEGIN: email -->
                    <tr>
                        <td>{LANG.email}:</td>
                        <td><input title="{LANG.email}" class="form-control email required" id="email_iavim" type="email" name="email" value="{DATA.email}" maxlength="240" /></td>
                    </tr>
                    <!-- END: email -->
                    <tr>
                        <td>{LANG.group_color}:</td>
                        <td class="form-inline">
                            <input class="form-control w200" type="text" name="group_color" value="{DATA.group_color}" maxlength="10"/>
                            <input name="group_color_demo" class="form-control w50"<!-- BEGIN: group_color --> style="background-color:{DATA.group_color}"<!-- END: group_color --> readonly="readonly"/>
                        </td>
                    </tr>
                    <tr>
                        <td>{LANG.group_avatar}:</td>
                        <td class="form-inline">
                            <div class="input-group mb-0">
                                <input type="text" class="form-control" id="group_avatar" name="group_avatar" value="{DATA.group_avatar}" maxlength="255">
                                <span class="input-group-btn">
                                    <button type="button" data-toggle="selectfile" data-target="group_avatar" data-path="{AVATAR_PATH}" data-currentpath="{AVATAR_CURENT_PATH}" data-type="image" class="btn btn-info" title="{GLANG.browse_image}"><em class="fa fa-folder-open-o"></em></button>
                                </span>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>{LANG.two_step_verification_require_admin}:</td>
                        <td class="form-inline">
                            <input type="checkbox" name="require_2step_admin" value="1"{DATA.require_2step_admin}<!-- BEGIN: 2step_admin_default --> class="checkdefault"<!-- END: 2step_admin_default -->/>
                            <!-- BEGIN: 2step_admin_default_active --><span>{LANG.two_step_verification_require_admindefault}</span><!-- END: 2step_admin_default_active -->
                        </td>
                    </tr>
                    <tr>
                        <td>{LANG.two_step_verification_require_site}:</td>
                        <td class="form-inline">
                            <input type="checkbox" name="require_2step_site" value="1"{DATA.require_2step_site}<!-- BEGIN: 2step_site_default --> class="checkdefault"<!-- END: 2step_site_default -->/>
                            <!-- BEGIN: 2step_site_default_active --><span>{LANG.two_step_verification_require_sitedefault}</span><!-- END: 2step_site_default_active -->
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <!-- BEGIN: config -->
        <table class="table table-striped table-bordered table-hover">
            <caption><em class="fa fa-file-text-o">&nbsp;</em>{LANG.access_caption_leader} </caption>
            <thead>
                <tr class="text-center">
                    <th class="text-center">{LANG.access_groups_add}</th>
                    <th class="text-center">{LANG.access_groups_del}</th>
                    <th class="text-center">{LANG.access_addus}</th>
                    <th class="text-center">{LANG.access_waiting}</th>
                    <th class="text-center">{LANG.access_editus}</th>
                    <th class="text-center">{LANG.access_delus}</th>
                    <th class="text-center">{LANG.access_passus}</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td class="text-center"><input type="checkbox" {CONFIG.access_groups_add} value="1" name="access_groups_add"></td>
                    <td class="text-center"><input type="checkbox" {CONFIG.access_groups_del} value="1" name="access_groups_del"></td>
                    <td class="text-center"><input type="checkbox" {CONFIG.access_addus} value="1" name="access_addus"></td>
                    <td class="text-center"><input type="checkbox" {CONFIG.access_waiting} value="1" name="access_waiting"></td>
                    <td class="text-center"><input type="checkbox" {CONFIG.access_editus} value="1" name="access_editus"></td>
                    <td class="text-center"><input type="checkbox" {CONFIG.access_delus} value="1" name="access_delus"></td>
                    <td class="text-center"><input type="checkbox" {CONFIG.access_passus} value="1" name="access_passus"></td>
                </tr>
            </tbody>
        </table>
        <!-- END: config -->
        <input type="hidden" name="checkss" value="{DATA.checkss}" />
        <input type="hidden" name="save" value="1" />
        <p class="text-center"><input name="submit" type="submit" value="{LANG.save}" class="btn btn-primary w100" style="margin-top: 10px" /></p>
    </form>
</div>
<script type="text/javascript">
function get_alias() {
    var title = strip_tags(trim($("#addCat [name=title]").val()));
    if (title != '') {
        $.post(script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=groups&nocache=' + new Date().getTime(), 'getAlias=1&id={DATA.id}&title=' + encodeURIComponent(title), function(res) {
            $("#addCat [name=alias]").val(res)
        })
    }
    return false;
}
    //<![CDATA[
    $(document).ready(function() {
        $("#addCat [name=title]").change(function() {
            var alias = strip_tags(trim($("#addCat [name=alias]").val()));
            if (alias == '') {
                get_alias()
            }
        });
        $('[name="exp_time"]').datepicker({
            showOn : "both",
            dateFormat : nv_jsdate_post.replace('yyyy', 'yy'),
            changeMonth : true,
            changeYear : true,
            showOtherMonths : true,
            buttonImage : null,
            buttonImageOnly : true,
            buttonText: null
        });
        $('[name="group_color"]').colpick({
            layout:'hex',
            submit:0,
            colorScheme:'dark',
            onChange:function(hsb,hex,rgb,el,bySetColor) {
                $('[name="group_color_demo"]').css('background-color','#'+hex);
                if(!bySetColor) $(el).val('#' + hex);
            }
        }).keyup(function(){
            $(this).colpickSetColor(this.value);
        });
    });
    $("form#addCat").submit(function() {
        var a = $("input[name=title]").val(), a = trim(a);
        $("input[name=title]").val(a);
        if (a == "") {
            return alert("{LANG.title_empty}"), $("input[name=title]").select(), false
        }
        if ( typeof (CKEDITOR) !== 'undefined') {
            for (let instance in CKEDITOR.instances) {
                CKEDITOR.instances[instance].updateElement();
            }
        }
        var a = $(this).serialize(), b = $(this).attr("action");
        $("input[name=submit]").attr("disabled", "disabled");
        $.ajax({
            type : "POST",
            url : b,
            data : a,
            success : function(a) {
                a == "OK" ? window.location.href = "{MODULE_URL}={OP}" : (alert(a), $("input[name=submit]").removeAttr("disabled"))
            }
        });
        return false
    });
    //]]>
</script>
<!-- END: add -->

<!-- BEGIN: main -->
<!-- BEGIN: addnew -->
<div class="form-group">
    <a href="{MODULE_URL}={OP}&amp;add" class="btn btn-success"><i class="fa fa-plus-circle" aria-hidden="true"></i> {LANG.nv_admin_add}</a>
</div>
<!-- END: addnew -->
<div class="table-responsive" id="pageContent">
    <table class="table table-striped table-bordered table-hover">
        <thead>
            <tr>
                <th class="text-nowrap min-w100" style="width: 10%;"> {LANG.weight} </th>
                <th class="text-nowrap" style="width: 20%;"> {LANG.title} </th>
                <th class="text-nowrap" style="width: 15%;"> {LANG.add_time} </th>
                <th class="text-nowrap" style="width: 15%;"> {LANG.exp_time} </th>
                <th class="text-nowrap" style="width: 10%;"> {LANG.users} </th>
                <th class="text-nowrap text-center" style="width: 10%;"> {GLANG.active} </th>
                <th class="text-nowrap text-center" style="width: 20%;"> {GLANG.actions} </th>
            </tr>
        </thead>
        <tbody>
            <!-- BEGIN: loop -->
            <tr>
                <td>
                    <!-- BEGIN: weight_text -->{WEIGHT_TEXT}<!-- END: weight_text -->
                    <!-- BEGIN: weight -->
                    <button id="group_weight_{LOOP.group_id}" data-toggle="changegroupweight" data-mod="weight" data-min="{START_WEIGHT}" data-num="{MAX_WEIGHT}" data-id="{LOOP.group_id}" data-current="{STT}" data-tokend="{TOKEND}" data-msgerror="{LANG.errorChangeWeight}" type="button" class="btn btn-default btn-xs btn-block btn-dropdown-tool"><span class="caret"></span><span class="text">{STT}</span></button>
                    <!-- END: weight -->
                </td>
                <td class="text-left"><a title="{LANG.users}" href="{LOOP.link_userlist}">{LOOP.title}</a></td>
                <td>{LOOP.add_time}</td>
                <td>{LOOP.exp_time}</td>
                <td><strong class="text-danger">{LOOP.number}</strong></td>
                <td class="text-center"><input data-id="{LOOP.group_id}" data-tokend="{TOKEND}" type="checkbox" class="actGroup" value="1"{LOOP.act}{LOOP.disabled}></td>
                <td class="text-center">
                    <!-- BEGIN: action -->
                    <a href="{MODULE_URL}={OP}&edit&id={LOOP.group_id}" class="btn btn-default btn-xs"><i class="fa fa-edit"></i> {GLANG.edit}</a>
                    <!-- BEGIN: delete --><a class="delGroup btn btn-danger btn-xs" href="#" data-id="{LOOP.group_id}" data-tokend="{TOKEND}"><i class="fa fa-trash-o"></i> {GLANG.delete}</a><!-- END: delete -->
                    <!-- END: action -->
                </td>
            </tr>
            <!-- END: loop -->
        </tbody>
    </table>
</div>
<!-- BEGIN: action_js -->
<div class="form-group">
    <a class="btn btn-danger" href="#" data-toggle="delInactiveGroup" data-tokend="{TOKEND}" data-msgconfirm="{LANG.delConfirm} ?"><i class="fa fa-trash-o" aria-hidden="true"></i> {LANG.group_del_inactive}</a>
</div>
<script type="text/javascript">
$(document).ready(function() {
    $("a.delGroup").click(function(e) {
        e.preventDefault();
        confirm("{LANG.delConfirm} ?") && $.ajax({
            type : "POST",
            url : "{MODULE_URL}={OP}",
            data : "del=" + $(this).data('id') + '&tokend=' + $(this).data('tokend'),
            success : function(a) {
                a == "OK" ? location.reload() : alert(a);
            }
        });
    });
    $("input.actGroup").change(function() {
        var $this = $(this);
        $this.prop("disabled", true);
        $.ajax({
            type : "POST",
            url : "{MODULE_URL}={OP}",
            data : "act=" + $this.data('id') + '&tokend=' + $this.data('tokend') + "&rand=" + nv_randomPassword(10),
            success : function(a) {
                a = a.split("|");
                $this.prop("disabled", false);
                a[0] == "ERROR" && (a[1] == "1" ? $this.prop("checked", true) : $this.prop("checked", false));
            }
        });
    });
});
</script>
<!-- END: action_js -->
<!-- END: main -->

<!-- BEGIN: listUsers -->
<!-- BEGIN: pending -->
<div id="id_pending">
    <h3 class="myh3">{PTITLE}</h3>
    <div class="table-responsive">
        <table class="table table-striped table-bordered table-hover">
            <col class="w50"/>
            <col span="3" />
            <col class="w250"/>
            <thead>
                <tr>
                    <th class="text-center"> {LANG.userid} </th>
                    <th> {GLANG.username} </th>
                    <th> {LANG.nametitle} </th>
                    <th> {LANG.email} </th>
                    <th class="text-center"> {GLANG.actions} </th>
                </tr>
            </thead>
            <tbody>
                <!-- BEGIN: loop -->
                <tr>
                    <td class="text-center"> {LOOP.userid} </td>
                    <td><a title="{LANG.detail}" href="{MODULE_URL}=edit&userid={LOOP.userid}">{LOOP.username}</a></td>
                    <td>{LOOP.full_name}</td>
                    <td><a href="mailto:{LOOP.email}">{LOOP.email}</a></td>
                    <td class="text-center">
                    <!-- BEGIN: tools -->
                    <i class="fa fa-check fa-lg"></i> <a class="approved" href="javascript:void(0);" data-id="{LOOP.userid}">{LANG.approved}</a>
                    <i class="fa fa-times fa-lg"></i> <a class="denied" href="javascript:void(0);" data-id="{LOOP.userid}">{LANG.denied}</a>
                    <!-- END: tools -->
                    </td>
                </tr>
                <!-- END: loop -->
            </tbody>
        </table>
    </div>
    <!-- BEGIN: page -->
    <div class="text-center">{PAGE}</div>
    <!-- END: page -->
</div>
<script type="text/javascript">
//<![CDATA[
$("a.approved").click(function() {
    confirm(nv_is_add_user_confirm[0]) && $.ajax({
        type : "POST",
        url : "{MODULE_URL}={OP}",
        data : "gid={GID}&approved=" + $(this).data("id"),
        success : function(a) {
            a == "OK" ? $("div#pageContent").load("{MODULE_URL}={OP}&listUsers={GID}&random=" + nv_randomPassword(10)) : alert(a);
        }
    });
    return !1;
});
$("a.denied").click(function() {
    confirm(nv_is_exclude_user_confirm[0]) && $.ajax({
        type : "POST",
        url : "{MODULE_URL}={OP}",
        data : "gid={GID}&denied=" + $(this).data("id"),
        success : function(a) {
            a == "OK" ? $("div#pageContent").load("{MODULE_URL}={OP}&listUsers={GID}&random=" + nv_randomPassword(10)) : alert(a);
        }
    });
    return !1;
});
//]]>
</script>
<!-- END: pending -->

<!-- BEGIN: leaders -->
<div id="id_leaders">
    <h3 class="myh3">{PTITLE}</h3>
    <div class="table-responsive">
        <table class="table table-striped table-bordered table-hover">
            <col class="w50"/>
            <col span="3" />
            <col class="w250"/>
            <thead>
                <tr>
                    <th class="text-center"> {LANG.userid} </th>
                    <th> {GLANG.username} </th>
                    <th> {LANG.nametitle} </th>
                    <th> {LANG.email} </th>
                    <th class="text-center"> {GLANG.actions} </th>
                </tr>
            </thead>
            <tbody>
                <!-- BEGIN: loop -->
                <tr>
                    <td class="text-center"> {LOOP.userid} </td>
                    <td><a title="{LANG.detail}" href="{MODULE_URL}=edit&userid={LOOP.userid}">{LOOP.username}</a></td>
                    <td>{LOOP.full_name}</td>
                    <td><a href="mailto:{LOOP.email}">{LOOP.email}</a></td>
                    <td class="text-center">
                    <!-- BEGIN: tools -->
                    <i class="fa fa-star-half-o fa-lg"></i> <a class="demote" href="javascript:void(0);" data-id="{LOOP.userid}">{LANG.demote}</a>
                    <em class="fa fa-trash-o fa-lg">&nbsp;</em> <a class="deleteleader" href="javascript:void(0);" title="{LOOP.userid}">{LANG.exclude_user2}</a>
                    <!-- END: tools -->
                    </td>
                </tr>
                <!-- END: loop -->
            </tbody>
        </table>
    </div>
    <!-- BEGIN: page -->
    <div class="text-center">{PAGE}</div>
    <!-- END: page -->
</div>
<script type="text/javascript">
//<![CDATA[
$("a.deleteleader").click(function() {
    confirm("{LANG.delConfirm} ?") && $.ajax({
        type : "POST",
        url : "{MODULE_URL}={OP}",
        data : "gid={GID}&exclude=" + $(this).attr("title"),
        success : function(a) {
            a == "OK" ? $("div#pageContent").load("{MODULE_URL}={OP}&listUsers={GID}&random=" + nv_randomPassword(10)) : alert(a);
        }
    });
    return !1;
});
$("a.demote").click(function() {
    $.ajax({
        type : "POST",
        url : "{MODULE_URL}={OP}",
        data : "gid={GID}&demote=" + $(this).data("id"),
        success : function(a) {
            a == "OK" ? $("div#pageContent").load("{MODULE_URL}={OP}&listUsers={GID}&random=" + nv_randomPassword(10)) : alert(a);
        }
    });
    return !1;
});
//]]>
</script>
<!-- END: leaders -->

<!-- BEGIN: members -->
<div id="id_members">
    <h3 class="myh3">{PTITLE}</h3>
    <div class="table-responsive">
        <table class="table table-striped table-bordered table-hover">
            <col class="w50"/>
            <col span="3" />
            <col class="w250"/>
            <thead>
                <tr>
                    <th class="text-center"> {LANG.userid} </th>
                    <th> {GLANG.username} </th>
                    <th> {LANG.nametitle} </th>
                    <th> {LANG.email} </th>
                    <th class="text-center"> {GLANG.actions} </th>
                </tr>
            </thead>
            <tbody>
                <!-- BEGIN: loop -->
                <tr>
                    <td class="text-center"> {LOOP.userid} </td>
                    <td><a title="{LANG.detail}" href="{MODULE_URL}=edit&userid={LOOP.userid}">{LOOP.username}</a></td>
                    <td>{LOOP.full_name}</td>
                    <td><a href="mailto:{LOOP.email}">{LOOP.email}</a></td>
                    <td class="text-center">
                    <!-- BEGIN: tools -->
                    <i class="fa fa-star fa-lg"></i> <a class="promote" href="javascript:void(0);" data-id="{LOOP.userid}">{LANG.promote}</a> -
                    <i class="fa fa-trash-o fa-lg"></i> <a class="deletemember" href="javascript:void(0);" title="{LOOP.userid}">{LANG.exclude_user2}</a>
                    <!-- END: tools -->
                    </td>
                </tr>
                <!-- END: loop -->
            </tbody>
        </table>
    </div>
    <!-- BEGIN: page -->
    <div class="text-center">{PAGE}</div>
    <!-- END: page -->
</div>
<script type="text/javascript">
//<![CDATA[
$("a.deletemember").click(function() {
    confirm("{LANG.delConfirm} ?") && $.ajax({
        type : "POST",
        url : "{MODULE_URL}={OP}",
        data : "gid={GID}&exclude=" + $(this).attr("title"),
        success : function(a) {
            a == "OK" ? $("div#pageContent").load("{MODULE_URL}={OP}&listUsers={GID}&random=" + nv_randomPassword(10)) : alert(a);
        }
    });
    return !1;
});
$("a.promote").click(function() {
    $.ajax({
        type : "POST",
        url : "{MODULE_URL}={OP}",
        data : "gid={GID}&promote=" + $(this).data("id"),
        success : function(a) {
            a == "OK" ? $("div#pageContent").load("{MODULE_URL}={OP}&listUsers={GID}&random=" + nv_randomPassword(10)) : alert(a);
        }
    });
    return !1;
});
//]]>
</script>
<!-- END: members -->
<!-- END: listUsers -->

<!-- BEGIN: userlist -->
<!-- BEGIN: adduser -->
<div id="ablist" class="form-inline">
    {LANG.search_id}: <input title="{LANG.search_id}" class="form-control txt" type="text" name="uid" id="uid" value="" maxlength="11" style="width:50px" />
    <input class="btn btn-primary" name="addUser" type="button" value="{LANG.addMemberToGroup}" />
    <input class="btn btn-success" name="searchUser" type="button" value="{GLANG.search}" />
</div>
<!-- END: adduser -->
<div id="pageContent">&nbsp;</div>
<script type="text/javascript">
    //<![CDATA[
    $(function() {
        $("div#pageContent").load("{MODULE_URL}={OP}&listUsers={GID}&random=" + nv_randomPassword(10));
    });
    $("input[name=searchUser]").click(function() {
        nv_open_browse("{MODULE_URL}=getuserid&area=uid&filtersql={FILTERSQL}", "NVImg", 850, 420, "resizable=no,scrollbars=no,toolbar=no,location=no,status=no");
        return false;
    });
    $("input[name=addUser]").click(function() {
        var a = $("#ablist input[name=uid]").val(), a = intval(a);
        a == 0 && ( a = "");
        $("#ablist input[name=uid]").val(a);
        if (a == "") {
            return alert("{LANG.admin_choiceUserID}"), $("#ablist input[name=uid]").select(), false;
        }
        $("#pageContent input, #pageContent select").attr("disabled", "disabled");
        $.ajax({
            type : "POST",
            url : "{MODULE_URL}={OP}",
            data : "gid={GID}&uid=" + a + "&rand=" + nv_randomPassword(10),
            success : function(a) {
                a == "OK" ? ($("#ablist input[name=uid]").val(""), $("div#pageContent").load("{MODULE_URL}={OP}&listUsers={GID}&random=" + nv_randomPassword(10))) : alert(a);
            }
        });
        return !1;
    });
    //]]>
</script>
<!-- END: userlist -->
