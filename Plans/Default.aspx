<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Plans_Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Restaurant B Plan</title>
    <meta name="description" content="How to Start a Restaurant. Restaurant Business Plans and Checklists. RestaurantBPlan.com" />
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=0"/>
    <link rel="icon" type="image/png" href="/img/favicon.png">
    <link href='https://fonts.googleapis.com/css?family=Open+Sans:400,300,700,600' rel='stylesheet' type='text/css'>
    <link href="/Styles/Plan.css?i=3" rel="stylesheet" type="text/css" />

    <script src="/Scripts/jquery-2.0.3.min.js" type="text/javascript"></script>
    <script src="/Scripts/Helpers.js" type="text/javascript"></script>
    <script type="text/javascript">
        
        var priceRnd;
        var prices = [177, 197, 227, 247];
        var completePrices = [49, 79, 119, 149];
        var price;
        var completePrice;
        var signupClick;

        function SignupClick(packageType) {
            var purchasePrice = packageType == "Complete Package" ? " $" + completePrice : " $" + price;

            SendEmail("Sign Up Selected" + purchasePrice, packageType + purchasePrice);

            $(".modal-backdrop").show();
            $(".signup").show().css({ left: "50%" });
            $(".answer input").first().focus();
            signupClick = true;
        }

        function BuyClick(packageType) {
            var purchasePrice = packageType == "Complete Package" ? " $" + completePrice : " $" + price;

            SendEmail("Buy Selected" + purchasePrice, packageType + purchasePrice);

            //$(".content").animate({ left: "-100%" }, 500, function () {
            //    $(".content").hide();
            //});


            $(".modal-backdrop").show();
            $(".signup").show().css({ left: "50%" });
            $(".answer input").first().focus();
            signupClick = false;
        }

        function ContactClick() {
            $(".modal-backdrop").show();
            $(".payment.contact").show().css({ left: "50%" });
            $(".payment.contact .answer input").first().focus();

            SendEmail("Contact Us Clicked", "");
        }

        function SendEmail(subject, body) {
            body += "%3Cbr/%3E%3Cbr/%3E" + new Date();
            Post("SendEmail", { subject: subject, body: body });
        }

        window.onbeforeunload = function () {
            var endTime = new Date();
            var body = (endTime.getTime() - startTime.getTime()) / 1000 + " seconds";
            SendEmail("Time on Plans Page", body);
        }

        $(document).ready(function () {
            startTime = new Date();

            priceRnd = +$("#priceRnd").val();
            price = prices[priceRnd];
            completePrice = completePrices[priceRnd];


            $(".actualPrice.price").html("$" + price);
            $(".completePrice").html("$" + completePrice);
            $(".partialPrice").html("$" + price);
            SendEmail("Visited Plans", "Price: $" + price + ", Complete: $" + completePrice);
            
            $("body").css("overflow-x", "hidden");
            $(".content ").animate({ left: "50%" }, 500, function () {
                $("body").css("overflow-x", "");
            });

            $(".signup .signupBtn").click(function () {

                var error = false;
                $(".signup input").removeClass("error")
                if (!$("#signupName").val()) {
                    $("#signupName").addClass("error");
                    error = true;
                } if (!$("#signupEmail").val()) {
                    $("#signupEmail").addClass("error");
                    error = true;
                }
                if (!$("#signupPassword").val()) {
                    $("#signupPassword").addClass("error");
                    error = true;
                }
                if ($("#signupPassword").val() != $("#signupConfirm").val()) {
                    $("#signupPassword").addClass("error");
                    $("#signupConfirm").addClass("error");
                    error = true;
                }
                if (error)
                    return;

                var user = { Name: $("#signupName").val(), Email: $("#signupEmail").val(), Password: $("#signupPassword").val() };

                var body = user.Name + "<br/><br/>";
                body += user.Email + "<br/><br/>";

                SendEmail("Sign Up", body);

                //if (signupClick) {
                    $(".signup").html("<img src='https://govizzle.com/images/loading-animation.gif' style='height: 60px;margin: 72px 293px;' />");
                    setTimeout(function () {
                        $(".signup").html("<div style='color: #333;font-size: 24px;margin:40px 120px;'>We're sorry, There was an error signing you up. <br/><br/> Please try again later.</div>");
                    }, 2500);
                /*}
                else {
                    $("body").css("overflow-x", "hidden");
                    $(".payment.signup .answer").animate({ left: "-50%" }, 500, function () {
                        $(".payment.signup").hide();
                        $(".payment.signup .answer").css({ left: "50%" })
                    });

                    $(".payment.creditcard .packageType").html("Complete Financial Plan: $" + price)
                    $(".payment.creditcard").show();
                    $(".payment.creditcard .answer").css({ left: "150%", top: "10%" });
                    $(".payment.creditcard .answer").animate({ left: "50%" }, 500, function () {
                        $(".answer input").first().focus();
                        $("body").css("overflow-x", "");
                    });
                }*/
            });

            $(".payment.creditcard .pitchButton").click(function () {

                var body = $("#SignupEmail").val() + "<br/><br/>";
                body += $("#SignupCC").val() ? "CC:" + $("#SignupCC").val() + ", " : "CC:false, ";
                body += $("#SignupMM").val() ? "MM:true, " : "MM:false, ";
                body += $("#SignupYY").val() ? "YY:true, " : "YY:false, ";
                body += $("#SignupCvc").val() ? "Cvc:true, " : "Cvc:false, ";

                SendEmail("Purchase", body);

                $(".payment .answer").html("<img src='https://govizzle.com/images/loading-animation.gif' style='height: 60px;margin: 72px 174px;' />");
                setTimeout(function () {
                    $(".payment .answer").html("<div style='color: #333;font-size: 24px;margin: 20px 0;'>We're sorry, we were unable to process your payment at this time. <br/><br/> Please try again later.</div>");
                }, 2500);
            });

            $(".payment.contact .playButton").click(function () {

                var body = $("#ContactName").val() + "<br/><br/>" + $("#ContactMessage").val();

                SendEmail("Contact Us Sent", body);

                $(".payment .answer").html("<img src='https://govizzle.com/images/loading-animation.gif' style='height: 60px;margin: 72px 174px;' />");
                setTimeout(function () {
                    $(".payment .answer").html("<div style='color: #333;font-size: 24px;margin: 20px 0;'>Thank you for contacting us. <br/><br/>We will get in touch with you shortly.</div>");
                }, 2500);
            });

            $("#playVideoButton").click(function () {
                $("#playVideoHeader").css({ top: "50%", "margin-top": "-48px" });
                $("#playVideo").css({ top: "50%", height: "0" });
                $("#playVideoFooter").css({ top: "50%", "margin-top": "0px", bottom: "inherit", "margin-bottom": "inherit" });

                $("#playVideoHeader, #playVideo, #playVideoFooter").show();
                $(".modal-backdrop").show();

                setTimeout(function () {
                    $("#playVideoHeader").animate({ top: "60px", "margin-top": "0" }, 750, function () {

                    });
                    $("#playVideo").animate({ top: "60px", height: "460px" }, 750, function () {

                    });
                    $("#playVideoFooter").animate({ top: "500px", "margin-bottom": "0" }, 750, function () {

                    });
                }, 250);

                SendEmail("How it works video clicked", "");
            });

            $("#showDetailsButton").click(function () {
                $(".financialDetails.financials").show();
                $(".modal-backdrop").show();

                SendEmail("More Details Clicked", "");
            });

            $("#sampleButton").click(function () {
                $("#samplePlanHeader").css({ top: "50%", "margin-top": "-48px" });
                $("#samplePlan").css({ top: "50%", bottom: "50%" });
                $("#sampleFooter").css({ bottom: "50%", "margin-bottom": "-20px" });

                $("#samplePlanHeader, #samplePlan, #sampleFooter").show();
                $(".modal-backdrop").show();

                setTimeout(function () {
                    $("#samplePlanHeader").animate({ top: "40px", "margin-top": "0" }, 750, function () {

                    });
                    $("#samplePlan").animate({ top: "40px", bottom: "40px" }, 750, function () {

                    });
                    $("#sampleFooter").animate({ bottom: "40px", "margin-bottom": "0" }, 750, function () {

                    });
                }, 250);


                SendEmail("Sample Clicked", "");
            });
        });

    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div class="modal-backdrop"></div>
    <div id="playVideoHeader" class="samplePlanHeader"><span>How It Works</span>
        <a onclick="$('#playVideoHeader, #playVideo, #playVideoFooter, .modal-backdrop').hide();" style="font-size: 16pt;color: #333333;cursor: pointer;font-family: Helvetica,Arial,san-serif;position: absolute;right: 24px;">X</a>
    </div>
    <div id="playVideo" class="samplePlan">
        <div class="sampleContent">
            <iframe src="https://player.vimeo.com/video/158290620" width="600" height="337" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>
        </div>
    </div>
    <div id="playVideoFooter" class="sampleFooter"></div>
    
    <div id="samplePlanHeader" class="samplePlanHeader"><span>Sample Business Plan</span>
        <a onclick="$('#samplePlanHeader, #samplePlan, #sampleFooter, .modal-backdrop').hide();" style="font-size: 16pt;color: #333333;cursor: pointer;font-family: Helvetica,Arial,san-serif;position: absolute;right: 24px;">X</a>
    </div>
    <div id="samplePlan" class="samplePlan">
        <div class="sampleContent">
            <h1 style="text-align:center;font-weight: normal;margin-top:0;">Financials Overview</h1>
            <img src="/img/screen1.png" />
            <h1 style="text-align:center;font-weight: normal;">Capital Budget</h1>
            <img src="/img/screen2.png" />
            <h1 style="text-align:center;font-weight: normal;">Sales Projections - Average Check Price</h1>
            <img src="/img/screen3.png" />
            <h1 style="text-align:center;font-weight: normal;">Sales Projections - Typical Week</h1>
            <img src="/img/screen4.png" />
            <h1 style="text-align:center;font-weight: normal;"></h1>
            <img src="/img/screen5.png" />
            <h1 style="text-align:center;font-weight: normal;">Detailed Income and Cash Flow</h1>
            <img src="/img/screen6.png" />
            <h1 style="text-align:center;font-weight: normal;">Summary Income and Cash Flow</h1>
            <img src="/img/screen7.png" />
            <h1 style="text-align:center;font-weight: normal;">5 Year Operating Projections</h1>
            <img src="/img/screen8.png" />
            <h1 style="text-align:center;font-weight: normal;">Cash Flow Break Even</h1>
            <img src="/img/screen9.png" />
            <h1 style="text-align:center;font-weight: normal;">Projected Investment Returns</h1>
            <img style="margin: 0 0 2em -26px;" src="/img/screen10.png" />
        </div>
    </div>
    <div id="sampleFooter" class="sampleFooter"></div>
    <div class="pitch"></div>
    <input type="hidden" id="priceRnd" runat="server" />
    <header class="mainnav">
         <ul>
<%--            <li><a href="/">HOME</a></li>
            <li><a href="/HowItWorks">HOW IT WORKS</a></li>
            <li><a href="#">PLANS</a></li>--%>
            <li class="loginBtn"><a onclick="OpenLogin();">LOG IN</a></li>
        </ul>
    </header>
    <div class="content">
        <img src="../img/RestaurantBPlanLogo.png" style="position: relative;left: 50%;width: 210px;margin-left:-105px;" />
        <h1 style="text-align:center;">Get Started with Your Plan Today</h1>
        <p>At Restaurant B Plan, professional restaurateurs and accountants have put together all the documents you need to get started turning your restaurant dream into a reality.</p>
        <div id="playVideoButton" class="playButton" style="float: left;margin: 0 37%;"><img style="float: left;height: 24px;margin: -2px 2px;" src="/img/Play.png" />VIDEO TOUR</div>
        <div style="font-size: 24px;line-height: 1.4em;background: #f2f2f2;position:relative;padding: 1px 80px 100px;margin: 121px 0 50px;">
            <h2>How It Works</h2>
            <div style="clear:both;margin-bottom:8px;"><div style="font-weight:bold;float: left;margin: 0px 8px 0 0;">1) </div><div>We ask you questions to understand your restaurant</div></div>
            <div style="clear:both;margin-bottom:8px;"><div style="font-weight:bold;float: left;margin: 0px 8px 0 0;height: 50px;">2) </div><div>We build a business plan of 10 financial documents based on your restaurant concept</div></div>
            <div style="clear:both;margin-bottom:8px;"><div style="font-weight:bold;float: left;margin: 0px 8px 0 0;height: 80px;">3) </div><div>Use our app to customize your business plan exactly to your restaurant specifications with step by step explanations</div></div>
            <div id="showDetailsButton" class="playButton" style="float: left;margin: 20px 0 0 85px;padding: 6px 20px;">MORE DETAILS</div>
            <div id="sampleButton" class="playButton" style="float: left;margin: 20px 0 0 34px;padding: 6px 20px;">SAMPLE BUSINESS PLAN</div>
        </div>
<%--        <div id="startDiv">
            <div class="startTitle"><div style="float:left;">Full Financial Business Plan</div><div class="startPrice"></div></div>
            <div class="startButton" onclick="BuyClick('Financial Plan Only');">START PLANNING TODAY</div>
        </div>--%>
        <%--<div style="margin: 0px 64px;font-size: 18px;line-height: 1.3em;position:relative;width:200px;">
            <div style="font-size:24px;font-weight:bold;text-decoration:underline;">Business Plan</div>
            <div style="margin: .6em 0 .4em;">An 11 section fully customizable plan in Microsoft Word format including:</div>
            <div><span style="font-weight:bold;">1) </span>Restaurant Concept</div>
            <div><span style="font-weight:bold;">2) </span>Management Team</div>
            <div><span style="font-weight:bold;">3) </span>Market Analysis</div>
            <div><span style="font-weight:bold;">4) </span>Marketing Strategy</div>
            <div><span style="font-weight:bold;">5) </span>Staffing</div>
            <div><span style="font-weight:bold;">6) </span>Company Description</div>
            <div><span style="font-weight:bold;">7) </span>Daily Operations</div>
            <div><span style="font-weight:bold;">8) </span>Software and Controls</div>
            <div><span style="font-weight:bold;">9) </span>Administrative Control Systems</div>
            <div><span style="font-weight:bold;">10) </span>Inventory</div>
            <div><span style="font-weight:bold;">11) </span>Accounting</div>
            <img style="position: absolute;top: 19px;left: 265px;border-radius: 10px;" src="../img/BusinessPlan.png" />
        </div>
        <div class="value">$199 Value</div>
        <div style="margin: 36px 0;font-size: 18px;line-height: 1.3em;background: #f2f2f2;padding: 2em 46px 5em 463px;position: relative;width: 267px;">
            <div style="font-size:24px;font-weight:bold;text-decoration:underline;">Financial Plan</div>
            <div style="margin: .6em 0 .4em;">10 interlinked financial documents with explanations of what every field means including:</div>
            <div><span style="font-weight:bold;">1) </span>Financials Overview</div>
            <div><span style="font-weight:bold;">2) </span>Capital Budget</div>
            <div><span style="font-weight:bold;">3) </span>Sales Projections - Average Check Price</div>
            <div><span style="font-weight:bold;">4) </span>Sales Projections - Typical Week</div>
            <div><span style="font-weight:bold;">5) </span>Hourly Labor Projections</div>
            <div><span style="font-weight:bold;">6) </span>Summary Income and Cash Flow</div>
            <div><span style="font-weight:bold;">7) </span>Detailed Income and Cash Flow</div>
            <div><span style="font-weight:bold;">8) </span>5 Year Operating Projections</div>
            <div><span style="font-weight:bold;">9) </span>Projected Investment Returns</div>
            <div><span style="font-weight:bold;">10) </span>Cash Flow Break Even</div>
            <img style="position: absolute;top: 55px;left: 27px;border-radius: 5px;width: 394px;" src="../img/Financials.png" />
        </div>
        <div class="value" style="position: relative;text-align: center;width: 100%;margin-top: -137px;">$199 Value</div>
        <div style="margin: 36px 64px;font-size: 18px;line-height: 1.3em;">
            <div style="font-size:20px;font-weight:bold;text-decoration:underline;">Bonuses</div>
            <div style="margin: .6em 0 .4em;">All plans come with these great bonuses to help you get your restaurant off the ground:</div>
            <div>1. Restaurant Startup Checklist</div>
            <div>2. Restaurant 90-Day Preopening Planning Chart</div>
            <div>3. A License and Permit Checklist for Startup Restaurants</div>
            <div>4. Restaurant Opening Weekly Task Sheet</div>
            <div class="value">$49 Value</div>
        </div>
        <div style="margin: 36px 0px;background: #f2f2f2;">
            <div style="text-align: center;padding: 1em;font-size: 38px;font-weight: bold;">Total Value: $447</div>
        </div>
        <div style="display:none;text-align: center;font-size: 36px;margin: 2em 0 1em;">For a limited time, available for <span class="completePrice">$89</span></div>
        --%>
       <%-- <div class="priceTable">
            <div class="priceColumn">
                <div class="priceColumnHeader">
                    <h3>Business Plan Only</h3>
                    <h4><span class="partialPrice">$59</span></h4>
                    <div class="blueBtn" style="margin: 1em 32px;" onclick="BuyClick('Business Plan Only');" >Select Plan</div>
                </div>
                <div class="priceColumnDetails">
                    <h5>WHAT YOU GET</h5>
                    <div style="font-weight:bold;">Reviewed and approved by succesful restaurant owners, managers and chefs</div>
                    <div>A 11 section fully customizable plan in Microsoft Word format</div>
                    <div class="moreDetails" style="text-align:center;font-size: 18px;" onclick="$('.financialDetails.business').show();$('.modal-backdrop').show();">MORE DETAILS</div>
                </div>
            </div>
            <div class="priceColumn">
                <div class="priceColumnHeader">
                    <h3>Financial Plan Only</h3>
                    <h4><span class="partialPrice">$59</span></h4>
                    <div class="blueBtn" style="margin: 1em 32px;" onclick="BuyClick('Financial Plan Only');" >Select Plan</div>
                </div>
                <div class="priceColumnDetails">
                    <h5>WHAT YOU GET</h5>
                    <div style="font-weight:bold;">Reviewed and approved by professional accountants</div>
                    <div>10 interlinked financial documents with explanations of what every field means. </div>
                    <div class="moreDetails" style="text-align:center;font-size: 18px;" onclick="$('.financialDetails.financials').show();$('.modal-backdrop').show();">MORE DETAILS</div>
                </div>
            </div>                    
            <div class="priceColumn best">
                <div class="bestValue">BEST VALUE</div>
                <div class="priceColumnHeader" style="border-right:none;">
                    <h3>Complete Package</h3>
                    <h4><span class="completePrice">$89</span></h4>
                    <div class="blueBtn" style="margin: 1em 32px;" onclick="BuyClick('Complete Package');" >Select Plan</div>
                </div>
                <div class="priceColumnDetails">
                    <h5>WHAT YOU GET</h5>
                    <div style="font-weight:bold;font-size: 18px;">Business Plan AND Financial Plan</div>
                    <div style="height: 81px;font-size: 16px;padding: 16px 0;">Everything you need to create a top-notch plan to raise money and start your restaurant</div>
                </div>
            </div>
        </div>
        <p style="display:none;margin: 30px 100px 20px;">If you are not satisfied with your plan you will receive a full refund.</p>
        <img src="../img/guarantee.png" style="display:none;width: 120px;position: relative;left: 50%;margin-left: -60px;" />--%>

        <div class="priceTable">
            <div class="priceColumn" style="margin-left:4%;">
                <div class="oldPrice strike">$97</div>
                <div class="actualPrice" style="margin-left: -12px;">$0</div>
                <div class="priceTitle">Free Trial</div>
                <div class="priceItem">Step by step app for building a professional business plan</div>
                <div class="priceItem">Explanations from restaurateurs for each field to help develop of your final plan</div>
                <div class="priceItem strike">10 seperate financial documents ready to take to investors</div>
<%--                <div class="priceItem strike">Web document for quick access between partners and investors</div>--%>
                <div class="playButton" onclick="SignupClick('Financial Plan Only');">START FOR FREE</div>
            </div>
            <div class="priceColumn">
                <div class="oldPrice strike">$497</div>
                <div class="actualPrice price" style="margin-left: -6px;">$49</div>
                <div class="priceTitle">Business Plan</div>
                <div class="priceItem">Step by step app for building a professional business plan</div>
                <div class="priceItem">Explanations from restaurateurs for each field to help develop of your final plan</div>
                <div class="priceItem">10 seperate financial documents ready to take to investors</div>
<%--                <div class="priceItem">Web document for quick access between partners and investors</div>--%>
                <div class="playButton" onclick="BuyClick('Financial Plan Only');">BUY NOW</div>
            </div>
            <div class="priceColumn">
                <div class="oldPrice strike">$3,997</div>
                <div class="actualPrice" style="font-size: 28px;margin: 21px 0 33px;">Contact Us</div>
                <div class="priceTitle">Custom Plan</div>
                <div class="priceItem">Work directly with professional writers to create a custom plan around your restaurant concept</div>
                <div class="playButton" onclick="ContactClick();" style="margin-top: 170px;">CONTACT US</div>
            </div>
        </div>

    </div>
    <div class="payment creditcard">
        <div class="question">
            <span>Making your restaurant dream<br /> a reality is less than a minute away.</span>
        </div>
        <div class="answer" style="height:368px;">
            <div class="dialogClose" onclick="$('.payment').hide();$('.modal-backdrop').hide();">X</div>
            <div class="packageType" style="margin-bottom: 30px;" ></div>
            <div style="margin: 12px 0 0 88px;">Credit Card</div>
            <input id="SignupCC" type="text" placeholder="CC Number" />
            <br />
            <input id="SignupMM" type="text" placeholder="MM" style="width: 36px;margin: 4px 0 4px 88px;" />
            <input id="SignupYY" type="text" placeholder="YY" style="width: 36px;margin: 4px" />
            <input id="SignupCvc" type="text" placeholder="CVC" style="width: 60px;margin: 4px 0 0 40px;" />
            <div class="pitchButton">Complete Purchase</div>
            <img src="/img/guarantee.png" style="height: 106px;margin: 101px 0 0 170px;" />
        </div>
    </div>
<%--    <div class="signup">
        <div class="dialogClose" onclick="$('.signup').hide();$('.modal-backdrop').hide();">X</div>
        <div class="packageType" style="font-size: 28px;margin: 0 0 16px;line-height: 1.2em;" >Making your restaurant dream a reality is less than a minute away.</div>
        <div style="margin: 12px 0 4px 88px;font-size: 20px;">Name</div>
        <input id="SignupName" type="text" placeholder="Your Full Name" />
        <div style="margin: 12px 0 4px 88px;font-size: 20px;">Email</div>
        <input id="SignupEmail" type="text" placeholder="Your Email"  />
        <div style="margin: 12px 0 4px 88px;font-size: 20px;">Password</div>
        <input id="SignupPassword" type="password" placeholder="Minimum 7 Characters" />
        <div class="pitchButton">Sign Up</div>
    </div>--%>
    <div class="signup">
        <div class="dialogClose" onclick="$('.signup').hide();$('.modal-backdrop').hide();">X</div>
        <div class="signupHeader">
            Making your restaurant dream a<br />reality is less than a minute away.
        </div>
        <input id="signupName" placeholder="Full Name" type="text" style="margin-top: 20px;" />
        <input id="signupEmail" placeholder="Email Address" type="text" />
        <input id="signupPassword" placeholder="Password" type="password" />
        <input id="signupConfirm" placeholder="Confirm Password" type="password" style="margin-bottom: 20px;" />
        <div class="signupBtn">Sign up</div>
    </div>

    <div class="payment contact">
        <div class="question">
            <span>Making your restaurant dream<br /> a reality is less than a minute away.</span>
        </div>
        <div class="answer">
            <div class="dialogClose" onclick="$('.payment').hide();$('.modal-backdrop').hide();">X</div>
            <div class="packageType" style="font-size: 28px;margin: 0 0 16px;line-height: 1.2em;" >How can we help you?</div>
            <div style="margin: 12px 0 4px 55px;font-size: 20px;">Name</div>
            <input id="ContactName" type="text" placeholder="Your Name" style="margin-left:55px;" />
            <div style="margin: 12px 0 4px 55px;font-size: 20px;">Message</div>
            <textarea id="ContactMessage" rows="8" style='margin: 0px 0 0 55px;width: 338px;font-size: 20px;font-family: "KlinicSlab","Helvetica Neue",Helvetica,Arial,sans-serif;padding: 8px;border-radius: 5px;'></textarea>
            <div class="playButton" style="text-align: center;width: 110px;padding: 4px;margin: 12px auto;">Send</div>
        </div>
    </div>
    <div class="financialDetails business" >
        <div class="dialogClose" onclick="$('.financialDetails').hide();$('.modal-backdrop').hide();">X</div>
        <div style="font-size:32px;font-weight:bold;text-decoration:underline;text-align:center;margin-bottom: 24px;">Business Plan</div>
        <div style="margin: .6em 0 .4em;text-align:center;">An 11 section fully customizable plan in Microsoft Word format including:</div>
        <div><span style="font-weight:bold;">1) </span>Restaurant Concept</div>
        <div><span style="font-weight:bold;">2) </span>Management Team</div>
        <div><span style="font-weight:bold;">3) </span>Market Analysis</div>
        <div><span style="font-weight:bold;">4) </span>Marketing Strategy</div>
        <div><span style="font-weight:bold;">5) </span>Staffing</div>
        <div><span style="font-weight:bold;">6) </span>Company Description</div>
        <div><span style="font-weight:bold;">7) </span>Daily Operations</div>
        <div><span style="font-weight:bold;">8) </span>Software and Controls</div>
        <div><span style="font-weight:bold;">9) </span>Administrative Control Systems</div>
        <div><span style="font-weight:bold;">10) </span>Inventory</div>
        <div><span style="font-weight:bold;">11) </span>Accounting</div>
        <img style="position: absolute;top: 124px;right:34px;border-radius: 10px;" src="../img/BusinessPlan.png" />
    </div>
    <div class="financialDetails financials" >
        <div class="dialogClose" onclick="$('.financialDetails').hide();$('.modal-backdrop').hide();">X</div>
        <div style="font-size:32px;font-weight:bold;text-decoration:underline;text-align:center;margin-bottom: 24px;">Financial Plan</div>
        <div style="margin: .6em 0 .4em;text-align:center;">10 interlinked financial documents with explanations every field:</div>
        <div style="float:right;clear:both;width:350px;"><span style="font-weight:bold;">1) </span>Financials Overview</div>
        <div style="float:right;clear:both;width:350px;"><span style="font-weight:bold;">2) </span>Capital Budget</div>
        <div style="float:right;clear:both;width:350px;"><span style="font-weight:bold;">3) </span>Sales Projections - Average Check Price</div>
        <div style="float:right;clear:both;width:350px;"><span style="font-weight:bold;">4) </span>Sales Projections - Typical Week</div>
        <div style="float:right;clear:both;width:350px;"><span style="font-weight:bold;">5) </span>Hourly Labor Projections</div>
        <div style="float:right;clear:both;width:350px;"><span style="font-weight:bold;">6) </span>Summary Income and Cash Flow</div>
        <div style="float:right;clear:both;width:350px;"><span style="font-weight:bold;">7) </span>Detailed Income and Cash Flow</div>
        <div style="float:right;clear:both;width:350px;"><span style="font-weight:bold;">8) </span>5 Year Operating Projections</div>
        <div style="float:right;clear:both;width:350px;"><span style="font-weight:bold;">9) </span>Projected Investment Returns</div>
        <div style="float:right;clear:both;width:350px;"><span style="font-weight:bold;">10) </span>Cash Flow Break Even</div>
        <img style="position: absolute;top: 130px;left: 50px;border-radius: 5px;" src="../img/Financials.png" />
    </div>
    </form>
    <a title="Web Analytics" href="http://clicky.com/100899850"></a>
    <script src="//static.getclicky.com/js" type="text/javascript"></script>
    <script type="text/javascript">try { clicky.init(100899850); } catch (e) { }</script>
    <noscript><p><img alt="Clicky" width="1" height="1" src="//in.getclicky.com/100899850ns.gif" /></p></noscript>
</body>
</html>
