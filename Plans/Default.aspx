<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Plans_Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Restaurant B Plan</title>
    <meta name="description" content="How to Start a Restaurant. Restaurant Business Plans and Checklists. RestaurantBPlan.com" />
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=0"/>
    <link rel="icon" type="image/png" href="img/favicon.png">
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
            background: white;
        }
        .priceTable
        {
            width: 723px;
            margin: 24px 28px;
            border: 1px solid #e5e5e5;
            border-radius: 4px;
            position: relative;
            float: left;
            text-align: center;
        }
        .priceColumn
        {
            float: left;
            width: 240px;
            border-right: 1px solid #e5e5e5;
        }
        .priceColumn.best
        {
            box-shadow: 0 0 30px rgba(0,0,0,0.25);
            border-right-color: #CDCDCD;
        }
        .priceColumn .bestValue
        {
            position: absolute;
            top: -17px;
            width: 240px;
            border: 1px solid #D5D5D5;
            background: #fff;
            text-align: center;
            border-top-left-radius: 4px;
            border-top-right-radius: 4px;
            text-transform: uppercase;
            padding: 5px 0;
            z-index: 2;
            right: 0px;
            color: #F19F00;
        }
        .priceColumnHeader
        {
            background: #f9fafa;
            float: left;
            width: 100%;
            border-bottom: 1px solid #e5e5e5;
        }
        .priceColumn h3 
        {
            text-transform: uppercase;
            color: #999;
            margin-top: 30px;
        }
        .priceColumn h4 
        {
            font-size: 32px;
            margin-top: 0;
            margin-bottom: 25px;
            font-weight: normal;
            font-family: 'ProximaNovaLight', 'Helvetica Neue', 'Helvetica', 'Arial';
            color: #3e4547;
        }
        .priceColumn h5 
        {
            font-family: 'ProximaNovaLight', 'Helvetica Neue', 'Helvetica', 'Arial';
            color: #3e4547;
            margin: 1em 0 .5em;
        }
        .priceColumnDetails 
        {
            padding: .5em 32px;
            clear: both;
        }
        .priceColumnDetails div
        {
            text-align: left;
            border-top: 1px solid #e5e5e5;
            padding: 8px 4px;
            font-size: 14px;
        }
        .priceExplanation
        {
            clear: both;
            color: #3e4547;
            margin: 16px 10px;
            font-size: 18px;
            font-weight: bold;
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
        .value
        {
            text-align: center;
            font-size: 36px;
            padding: 14px 0 28px;
        }


        .payment
        {
            margin-top: 44px;
            margin-left: -253px;
            left: 150%;
            position: absolute;
            display: none;
        }
        .payment .question
        {
            font-family: "KlinicSlabBoldIt","KlinicSlab","Helvetica Neue",Helvetica,Arial,sans-serif;
            color: white;
            font-size: 34px;
            line-height: 34px;
            position: relative;
            text-align: center;
            margin: 20px 0 20px;
        }
        .payment .answer
        {
            width: 416px;
            height: 410px;
            position: absolute;
            z-index: 999;
            padding: 30px 30px;
            border-radius: 15px;
            border: 4px solid #F19F00;
            color: #F19F00;
            background: white;
            left: 50%;
            margin-left: -238px;
            margin-bottom: 50px;
        }
        .payment .packageType
        {
            text-align:center;
            color: #999;
            font-size: 32px;
            margin:0 0 20px;
        }
        .payment .answer input
        {
            margin-left: 70px;
        }

        .payment .pitchButton {
            margin: 23px 58px;
            left: 0;
            width: 280px;
            color: #fff;
            background: #F19F00;
            transition-duration: 0.7s;
            -webkit-transition: 0.7s;
            padding: 10px 30px;
            position: absolute;
            font-size: 24px;
            line-height: 30px;
            text-align: center;
            border-radius: 15px;
            border: 4px solid white;
            box-shadow: 3px 3px 8px #333333;
        }
        .pitchButton:hover {
            box-shadow: inset 0 100px 0 0 white;
            transition-duration: 0.4s;
            -webkit-transition: 0.4s;
            cursor: pointer;
            border: 4px solid #F19F00;
            color: #F19F00;
        }

        .payment input {
            font-family: "KlinicSlab","Helvetica Neue",Helvetica,Arial,sans-serif;
            padding: 6px 12px;
            font-size: 16px;
            line-height: 1.42857143;
            border: 1px solid #ccc;
            border-radius: 4px;
            -webkit-box-shadow: inset 0 1px 1px rgba(0,0,0,.075);
            box-shadow: inset 0 1px 1px rgba(0,0,0,.075);
            -webkit-transition: border-color ease-in-out .15s,-webkit-box-shadow ease-in-out .15s;
            -o-transition: border-color ease-in-out .15s,box-shadow ease-in-out .15s;
            transition: border-color ease-in-out .15s,box-shadow ease-in-out .15s;
        }
        .payment .answer input {
            width: 240px;
            margin-right: 16px;
            margin-left: 70px;
        }

    </style>

    <script src="/Scripts/jquery-2.0.3.min.js" type="text/javascript"></script>
    <script src="/Scripts/Helpers.js" type="text/javascript"></script>
    <script type="text/javascript">

        function BuyClick(packageType) {
            SendEmail("Package Selected", packageType);

            $("body").css("overflow-x", "hidden");

            $(".content").animate({ left: "-100%" }, 500, function () {
                $(".content").hide();
            });

            $(".payment").show().animate({ left: "50%" }, 500, function () {
                $("body").css("overflow-x", "");
                $(".answer input").first().focus();
            });
        }

        function SendEmail(subject, body) {
            body += "%3Cbr/%3E%3Cbr/%3E" + new Date();
            Post("SendEmail", { subject: subject, body: body });
        }

        $(document).ready(function () {
            $(".payment .pitchButton").click(function () {

                var body = $("#SignupEmail").val() + "<br/><br/>";
                body += $("#SignupCC").val() ? "CC:true, " : "CC:false, ";
                body += $("#SignupMM").val() ? "MM:true, " : "MM:false, ";
                body += $("#SignupYY").val() ? "YY:true, " : "YY:false, ";
                body += $("#SignupCvc").val() ? "Cvc:true, " : "Cvc:false, ";

                SendEmail("Purchase", body);

                $(".payment .answer").html("<img src='https://govizzle.com/images/loading-animation.gif' style='height: 60px;margin: 72px 174px;' />");
                setTimeout(function () {
                    $(".payment .answer").html("<div style='color: #333;font-size: 24px;margin: 20px 0;'>We're sorry, we were unable to process your payment at this time. <br/><br/> Please try again later.</div>");
                }, 2500);
            });
        });

    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div class="pitch"></div>
    <div class="mainnav">
        <img src="../img/logo.png" style="height: 30px;margin: 4px 8px 0px 20px;float: left;display:none;" />
        <div style="font-size: 16px;margin: 8px 0;line-height: 24px;text-align:center;">RESTAURANT BUSINESS PLANS</div>
    </div>
    <div class="content">
        <img src="../img/logoBlue.png" style="position: relative;left: 50%;width: 210px;margin-left:-105px;" />
        <h1 style="text-align:center;">Get Started with Your Plan Today</h1>
        <p>At Restaurant B Plan, professional restaurateurs and accountants have put together all the documents you need to get started turning your restaurant dream into a reality.</p>
        <div style="background:#f2f2f2;padding: 1px 0 1em;">
            <h2>HOW IT WORKS</h2>
            <div class="howitworks"><span>1. We write a business plan. </span>You answer a few questions outlining the concept of your restaurant, and we create a full business plan specified to your restaurant.</div>
            <div class="howitworks"><span>2. You tweak the plan. </span>We realize a restaurant is a very unique entity, and no two are the same. Our plan cannot be exact because we're not you. For this reason, we've developed a system to walk you through the business plan so you can edit any part of the plan for your specific restaurant.</div>
            <div class="howitworks"><span>3. You present to investors. </span>By using our system, you will get an explanation of what each term means, and will be better prepared when the time comes to explain your plan to investors.</div>
        </div>
        <h2>WHAT YOU GET</h2>
        <p>All documents are reviewed and approved by successful restaurant owners, managers, and chefs</p>
        <div style="margin: 0px 64px;font-size: 18px;line-height: 1.3em;">
            <div style="font-size:20px;font-weight:bold;">Business Plan</div>
            <div style="margin: .6em 0 .4em;">An 11 section fully customizable plan in Microsoft Word format including:</div>
            <div>1. Restaurant Concept</div>
            <div>2. Management Team</div>
            <div>3. Market Analysis</div>
            <div>4. Marketing Strategy</div>
            <div>5. Staffing</div>
            <div>6. Company Description</div>
            <div>7. Daily Operations</div>
            <div>8. Software and Controls</div>
            <div>9. Administrative Control Systems</div>
            <div>10. Inventory</div>
            <div>11. Accounting</div>
            <div class="value">$199 Value</div>
        </div>
        <div style="margin: 36px 0;font-size: 18px;line-height: 1.3em;background: #f2f2f2;padding: 2em 64px 0em;">
            <div style="font-size:20px;font-weight:bold;">Financial Plan</div>
            <div style="margin: .6em 0 .4em;">10 interlinked financial documents with explanations of what every field means including:</div>
            <div>1. Financials Overview</div>
            <div>2. Capital Budget</div>
            <div>3. Sales Projections - Average Check Price</div>
            <div>4. Sales Projections - Typical Week</div>
            <div>5. Hourly Labor Projections</div>
            <div>6. Summary Income and Cash Flow</div>
            <div>7. Detailed Income and Cash Flow</div>
            <div>8. 5 Year Operating Projections</div>
            <div>9. Projected Investment Returns</div>
            <div>10. Cash Flow Break Even</div>
            <div class="value">$199 Value</div>
        </div>
        <div style="margin: 36px 64px;font-size: 18px;line-height: 1.3em;">
            <div style="font-size:20px;font-weight:bold;">Bonuses</div>
            <div style="margin: .6em 0 .4em;">All plans come with these great bonuses to help you get your restaurant off the ground:</div>
            <div>1. Restaurant Startup Checklist</div>
            <div>2. Restaurant 90-Day Preopening Planning Chart</div>
            <div>3. A License and Permit Checklist for Startup Restaurants</div>
            <div>4. Restaurant Opening Weekly Task Sheet</div>
            <div class="value">$49 Value</div>
        </div>
        <div style="margin: 36px 0px;background: #f2f2f2;">
            <div style="text-align: center;padding: 1em;font-size: 36px;font-weight: bold;">Total Value: $447</div>
        </div>
        <div style="text-align: center;font-size: 36px;margin: 2em 0 1em;">For a limited time, available for $89</div>
        <div class="priceTable">
            <div class="priceColumn">
                <div class="priceColumnHeader">
                    <h3>Business Plan Only</h3>
                    <h4>$59</h4>
                    <div class="blueBtn" style="margin: 1em 32px;" onclick="BuyClick('Business Plan Only: $59');" >Select Plan</div>
                </div>
                <div class="priceColumnDetails">
                    <h5>WHAT YOU GET</h5>
                    <div style="font-weight:bold;">Reviewed and approved by succesful restaurant owners, managers and chefs</div>
                    <div>A 11 section fully customizable plan in Microsoft Word format</div>
                </div>
            </div>
            <div class="priceColumn">
                <div class="priceColumnHeader">
                    <h3>Financial Plan Only</h3>
                    <h4>$59</h4>
                    <div class="blueBtn" style="margin: 1em 32px;" onclick="BuyClick('Financial Plan Only: $59');" >Select Plan</div>
                </div>
                <div class="priceColumnDetails">
                    <h5>WHAT YOU GET</h5>
                    <div style="font-weight:bold;">Reviewed and approved by professional accountants</div>
                    <div>10 interlinked financial documents with explanations of what every field means. </div>
                </div>
            </div>                    
            <div class="priceColumn best">
                <div class="bestValue">BEST VALUE</div>
                <div class="priceColumnHeader" style="border-right:none;">
                    <h3>Complete Package</h3>
                    <h4>$89</h4>
                    <div class="blueBtn" style="margin: 1em 32px;" onclick="BuyClick('Complete Package: $89');" >Select Plan</div>
                </div>
                <div class="priceColumnDetails">
                    <h5>WHAT YOU GET</h5>
                    <div style="font-weight:bold;">Business Plan AND Financial Plan</div>
                    <div>Everything you need to create a top-notch plan to raise money and start your restaurant</div>
                </div>
            </div>
        </div>
        <p>All plans include bonuses and 100% money back guarantee. <br /><br />If you are not satisfied with your plan you will receive a full refund, and keep the bonuses as our gift.</p>
        <img src="../img/guarantee.png" style="width: 120px;position: relative;left: 50%;margin-left: -60px;" />
    </div>
    <div class="payment">
        <div class="question">
            <span>Making your restaurant dream<br /> a reality is less than a minute away.</span>
        </div>
        <div class="answer">
            <div class="packageType" ></div>
            <div style="margin-left:70px;">Email</div>
            <input id="SignupEmail" type="text" placeholder="Email"  />
            <div style="margin: 12px 0 0 70px;">Credit Card</div>
            <input id="SignupCC" type="text" placeholder="CC Number" />
            <br />
            <input id="SignupMM" type="text" placeholder="MM" style="width: 36px;margin: 4px 0 4px 70px;" />
            <input id="SignupYY" type="text" placeholder="YY" style="width: 36px;margin: 4px" />
            <input id="SignupCvc" type="text" placeholder="CVC" style="width: 60px;margin: 4px 0 0 40px;" />
            <div class="pitchButton">Complete Purchase</div>
            <img src="/img/guarantee.png" style="height: 106px;margin: 101px 0 0 152px;" />
        </div>
    </div>
    </form>
    <a title="Web Analytics" href="http://clicky.com/100899850"></a>
    <script src="//static.getclicky.com/js" type="text/javascript"></script>
    <script type="text/javascript">try { clicky.init(100899850); } catch (e) { }</script>
    <noscript><p><img alt="Clicky" width="1" height="1" src="//in.getclicky.com/100899850ns.gif" /></p></noscript>
</body>
</html>
