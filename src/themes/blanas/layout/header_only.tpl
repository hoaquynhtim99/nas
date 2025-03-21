<!DOCTYPE html>
    <html lang="{$LANG->getGlobal('Content_Language')}" xmlns="http://www.w3.org/1999/xhtml" prefix="og: http://ogp.me/ns#">
    <head>
        <title>{$THEME_PAGE_TITLE}</title>
        {foreach from=$METATAGS item=meta}
        <meta {$meta.name}="{$meta.value}" content="{$meta.content}">
        {/foreach}
        <link rel="shortcut icon" href="{$SITE_FAVICON}">
        {foreach from=$HTML_LINKS item=links}
        <link{foreach from=$links key=key item=value} {$key}{if not empty($value)}="{$value}"{/if}{/foreach}>
        {/foreach}
        {foreach from=$HTML_JS item=js}
        <script{if not empty($js.ext)} src="{$js.content}"{/if}>{if empty($js.ext)}
            {$js.content}
        {/if}</script>
        {/foreach}
        <meta name="mobile-web-app-capable" content="yes">
        <link rel="manifest" href="{$smarty.const.NV_BASE_SITEURL}manifest.webmanifest">
        <link rel="apple-touch-icon" href="{$smarty.const.NV_BASE_SITEURL}themes/blanas/AppImages/ios/192.png">
    </head>
    <body{if $HOME and not empty($GCONFIG.site_banner)} style="background-image: url('{$smarty.const.NV_BASE_SITEURL}{$GCONFIG.site_banner}');"{/if}>
