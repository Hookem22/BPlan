<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="HowItWorks_Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Restaurant B Plan</title>
    <meta name="description" content="How to Start a Restaurant. Restaurant Business Plans and Checklists. RestaurantBPlan.com" />
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=0"/>
    <link rel="icon" type="image/png" href="/img/favicon.png">
    <style>
        @font-face {
            font-family: 'KlinicSlab';
            src: url('../fonts/KlinicSlabMedium.otf') format("opentype");
        }
        @font-face {
            font-family: 'KlinicSlabBold';
            src: url('../fonts/KlinicSlabBold.otf') format("opentype");
        }
        @font-face {
            font-family: 'KlinicSlabBoldIt';
            src: url('../fonts/KlinicSlabBoldIt.otf') format("opentype");
        }
        @font-face {
            font-family: 'KlinicSlabLight';
            src: url('../fonts/KlinicSlabLight.otf') format("opentype");
        }
        body
        {
            font-family: "KlinicSlab","Helvetica Neue",Helvetica,Arial,sans-serif;
            background-color: #EEEEEE;
            margin: 0;
            padding: 0;
        }
        p
        {
            margin: 30px 124px;
            font-size: 20px;
            line-height: 1.4em;
            color: #555;
        }
        .blueBtn 
        {
            font-size: 16px;
            border: 2px solid transparent;
            border-radius: 20px;
            padding: 5px 25px;
            background: #4683ea;
            color: #fff;
            margin: 1em;
        }
        .blueBtn:hover 
        {
            color: #4683ea;
            background: #fff;
            border-color: #4683ea;
            cursor: pointer;
        }
        .mainnav
        {
            background: #F19F00;
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 40px;
            color: white;
        }
        .pitch {
            position: fixed;
            top: 0;
            bottom: 0;
            left: 0;
            right: 0;
            background-image: url(/img/pitch.png);
            background-repeat: no-repeat;
            background-size: 100% 100%;
        }
        .content {
            width: 780px;
            position: absolute;
            left: 50%;
            margin: 60px 0 30px -390px;
            z-index: 999;
            padding: 16px 0px;
            border-radius: 15px;
            border: 4px solid #F19F00;
            color: #333;
            background: #EAE8EA;
        }
        
        .howitworks
        {
            margin: 20px 64px;
            font-size: 18px;
            line-height: 1.4em;
        }
        .howitworks span
        {
            font-weight:bold;
        }
        h2
        {
            text-align:center;
            margin: 1.4em 0 1em;
        }
        .mainnav {
            background: #F19F00;
            position: absolute;
            z-index: 100;
            width: 100%;
            text-align: center;
            top: 0;
        }
        .mainnav ul
        {
            margin: 8px 16px;

        }
        .mainnav ul li
        {
            display: inline;
            margin: 8px 16px;
        }
        .mainnav ul li a
        {
            color: white;
            text-decoration: none;
        }

        .loginBtn
        {
            position: absolute;
            right: 20px;
            top: 0px;
        }
        .loginBtn a:hover
        {
            text-decoration: underline;
            cursor: pointer;
        }

    </style>

</head>
<body>
    <form id="form1" runat="server">
    <div class="pitch"></div>
    <header class="mainnav">
         <ul>
            <li><a href="/">HOME</a></li>
            <li><a href="#">HOW IT WORKS</a></li>
            <li><a href="/Plans">PLANS</a></li>
            <li class="loginBtn"><a onclick="OpenLogin();">LOG IN</a></li>
        </ul>
    </header>
    <div class="content">
        <h2 style="font-size: 32px;margin: 1em 0 .4em;">HOW IT WORKS</h2>
        <div style="margin:0px 92px 20px;">
            <iframe src="https://player.vimeo.com/video/158290620" width="600" height="337" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>
        </div>
  
    </div>
    </form>
    <a title="Web Analytics" href="http://clicky.com/100899850"></a>
    <script src="//static.getclicky.com/js" type="text/javascript"></script>
    <script type="text/javascript">try { clicky.init(100899850); } catch (e) { }</script>
    <noscript><p><img alt="Clicky" width="1" height="1" src="//in.getclicky.com/100899850ns.gif" /></p></noscript>
</body>
</html>

