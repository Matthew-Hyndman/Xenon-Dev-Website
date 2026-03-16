<#ftl output_format="plainText">
<#import "template.ftl" as layout>
${msg("eventUpdatePasswordBody",event.date, event.ipAddress)}
<#if locale.language == "en">

<@layout.supportContactText />
</#if>