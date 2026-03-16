<#import "template.ftl" as layout>
<@layout.emailLayout>
${kcSanitize(msg("eventUserDisabledByPermanentLockoutHtml", event.date))?no_esc}
<#if locale.language == "en">
<@layout.supportContactHtml />
</#if>
</@layout.emailLayout>
