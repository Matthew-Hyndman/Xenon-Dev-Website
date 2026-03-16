<#ftl output_format="plainText">
<#assign supportEmail = properties.supportEmail>

<#macro supportContactText>
If this was not you, please contact ${supportEmail}.
</#macro>

<#macro supportContactIfNeededText>
Please contact ${supportEmail} if needed.
</#macro>