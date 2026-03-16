<#assign supportEmail = properties.supportEmail>

<#macro supportEmailLink>
<a href="mailto:${supportEmail}" style="color: #ffffff;">${supportEmail}</a>
</#macro>

<#macro supportContactHtml>
<p>If this was not you, please contact <@supportEmailLink />.</p>
</#macro>

<#macro supportContactIfNeededHtml>
<p>Please contact <@supportEmailLink /> if needed.</p>
</#macro>

<#macro emailLayout>
<html lang="${locale.language}" dir="${(ltr)?then('ltr','rtl')}">
<head>
    <meta charset="UTF-8">
    <style>

        body{
            background: #003789;
            background: linear-gradient(180deg, rgba(0, 55, 137, 1) 0%, rgba(9, 9, 121, 1) 70%, rgb(6, 97, 117) 100%);
        }

        h1,
        h2,
        h3,
        h4,
        h5,
        h6 {
        color: #ffffff;
        font-weight: 700;
        margin: 0;
        line-height: 1.2;
        text-align: center;
        }

        h1 {
        font-size: 36px
        }

        h2 {
        font-size: 30px
        }

        h3 {
        font-size: 24px
        }

        h4 {
        font-size: 18px
        }

        h5 {
        font-size: 15px
        }

        h6 {
        font-size: 13px
        }

        .center-container {
            display: flex; 
            justify-content: center; 
        }

        img {
            border-bottom: 1px solid #ffffff;
        }

        p {
        color: #fff;
        font-size: 120%;
        margin: 10px;
        padding-right: 20%;
        padding-left: 20%;
        justify-content: center;
        }


    </style>
</head>
<body style="    
    background: #003789; 
    background: linear-gradient(180deg, rgba(0, 55, 137, 1) 0%, rgba(9, 9, 121, 1) 70%, rgb(6, 97, 117) 100%);

    color: #fff;
    font-size: 120%;
    margin: 10px;
    padding-right: 20%;
    padding-left: 20%;
    justify-content: center;
    text-align: center;
    ">
    <#nested>
    <div style="border-top: 1px solid #ffffff; margin: 24px 20% 0 20%;"></div>
    <div style="font-size: 12px; text-align: left; margin: 0 20%;">
    <p style="color: #ffffff; font-size: 12px; margin: 10px 0; padding: 0;">This email was sent to you by an AWS SMTP.</p>
    <p style="color: #ffffff; font-size: 12px; margin: 10px 0; padding: 0;">If you have any questions, please contact <@supportEmailLink/>.</p>
    <p style="color: #ffffff; font-size: 12px; margin: 10px 0; padding: 0;">Sincerely, <br>Xenon Dev Team (A.K.A. Matthew Hyndman)</p>
    </div>
</body>
</html>
</#macro>
