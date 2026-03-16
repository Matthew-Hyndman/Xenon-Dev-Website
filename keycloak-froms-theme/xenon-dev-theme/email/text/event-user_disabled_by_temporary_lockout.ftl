<#ftl output_format="plainText">
<#import "template.ftl" as layout>
${msg("eventUserDisabledByTemporaryLockoutBody", event.date)}
<#if locale.language == "en">

<@layout.supportContactIfNeededText />
</#if>
