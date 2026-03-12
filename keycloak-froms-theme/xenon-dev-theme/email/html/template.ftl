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
    <hr>
    <div style="font-size: 12px; text-align: left;">
    <p>This email was sent to you by an AWS STMP.</p>
    <p>If you have any questions, please contact <a href="mailto:matthew@xenon-dev.com" style="color: #ffffff;">matthew@xenon-dev.com</a>.</p>
    <p>Sincerely, <br>Xenon Dev Team (A.K.A. Matthew Hyndman)</p>
    </div>
</body>
</html>
</#macro>
