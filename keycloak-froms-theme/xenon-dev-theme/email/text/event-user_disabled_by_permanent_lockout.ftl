<#ftl output_format="plainText">
<#import "template.ftl" as layout>
${msg("eventUserDisabledByPermanentLockoutBody", event.date)}
<#if locale.language == "en">

<@layout.supportContactText />
</#if>
