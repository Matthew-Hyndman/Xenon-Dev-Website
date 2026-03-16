<#ftl output_format="plainText">
<#import "template.ftl" as layout>
${msg("eventUpdateCredentialBody", event.getDetail("credential_type")!"unknown", event.date, event.ipAddress)}
<#if locale.language == "en">

<@layout.supportContactText />
</#if>
