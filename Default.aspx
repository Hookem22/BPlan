<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Restaurant B Plan</title>
    <meta name="description" content="How to Start a Restaurant. Restaurant Business Plans and Checklists. RestaurantBPlan.com" />
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=0"/>
    <link rel="icon" type="image/png" href="img/favicon.png">
    <link href="Styles/Style.css?i=4" rel="stylesheet" type="text/css" />
    <link href="Styles/Mobile.css?i=3" rel="stylesheet" type="text/css" />

    <script src="Scripts/jquery-2.0.3.min.js" type="text/javascript"></script>
    <script src="Scripts/Helpers.js" type="text/javascript"></script>
    <script type="text/javascript">
        var currentStep = 0;
        var marginLeft = "-300px";
        //var prices = [9, 19, 29, 39];
        //var price = 59; //prices[Math.floor(Math.random() * 4)];
        var Prospect;

        $(document).ready(function () {
            var mobParam = getParameterByName("id");
            var isMobile = mobilecheck() || tabletCheck() || mobParam == "m";
            if (isMobile)
            {
                $("body").addClass("Mobile");
                marginLeft = "-45%";
            }

            //Auto send emails
            Post("SendNextEmail");

            $('.pitchButton').click(function () {
                var questionId = "question0";
                $(".opening").animate({ left: "-100%" }, 500, function () { });

                $("body").css("overflow-x", "hidden");

                $("#" + questionId).show();

                //var margin = (+$(".questions").css("width").substring(0, $(".questions").css("width").length - 2)) / -2;
                $("#" + questionId).css("margin-left", marginLeft);

                $("#" + questionId).animate({ left: "50%" }, 500, function () {
                    $("body").css("overflow-x", "");
                });

                //var subject = "Yes they do";
                //var body = "Clicked Yes, I do";
                //SendEmail(subject, body);
                var success = function (data) {
                    Prospect = data;
                }
                Post("CreateProspect", {}, success);
            });

            $(".questions").on("click", ".answer .nextBtn", function () {
                NextQuestion();
            });

            $(".questions").on("click", ".answer .shadowBox", function (event) {
                var type = $(this).html();
                type = type.substring(0, type.indexOf("<"));
                NextQuestion(type);
            });

            $(".questions").on("click", ".answer .buyBtn", function (event) {
                Annual = $(this).hasClass("annual");
                NextQuestion();
            });

            $(".questions").on('keyup', 'input[type=text]', function (e) {
                if (e.which == 13)
                    NextQuestion();
            });

            $(".contact .button").click(function () {
                $('.contact h2').show();
                var subject = EscapeString($(".contact #Subject").val());
                var body = EscapeString($(".contact #Body").val());
                SendEmail(subject, body);
            });

            $(".questions").on("click", ".creditCard img", function (event) {
                $(".creditCard img").attr("src", "img/UncheckedRadio.png");
                $(this).attr("src", "img/CheckedRadio.png");
                var pricing = $(this).hasClass("monthly") ? "$" + price + " per month" : "$" + Math.floor(price / 2) * 12 + " per year";
                $(".creditCard .price").html(pricing);

            });

            $(".forgotPassword").click(function () {
                $(".loginDialog").hide();
                $(".forgotDialog").show();
            });

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

        function NextQuestion(message)
        {
            //if(currentStep == 10)
            //{
            //    if (!ValidateSignUp())
            //        return;
            //}

            var lastQuestion = currentStep % 2
            var lastQuestionId = "question" + lastQuestion;
            $("#" + lastQuestionId).animate({ left: "-100%" }, 500, function () {
                $("#" + lastQuestionId).hide();
                $("#" + lastQuestionId).css("left", "120%");
                $("#" + lastQuestionId).html("");
            });

            //var subject = "User Click";
            //var body = message ? message + "<br/><br/>" : $("#" + lastQuestionId + " .question span").html() + "<br/><br/>";
            //if (currentStep == 9)
            //    body = "Opening Sales page";
            //else if (currentStep == 1)
            //    restaurantName = $(".answer input[type='text']").val();

            //$(".answer input[type='text']").each(function () {
            //    body += $(this).val() + "   ";
            //});

            //body = EscapeString(body);
            //SendEmail(subject, body);


            currentStep++;
            var questionId = "question" + currentStep % 2;

            var question = "";
            var template = '<div class="question"><span>{{Question}}</span></div><div class="answer"><input type="text" style="font-size:20px;width: 240px;" /><a class="button nextBtn" >Next</a></div>';
            switch(currentStep)
            {
                case 1:
                    question = "Good place to start.<br /> What do you want to call it?";
                    template = template.replace("{{Question}}", question);
                    template = template.replace("<input", "<input placeholder='Restaurant Name' ");
                    Prospect.RestaurantType = message;
                    break;
                case 2:
                    restaurantName = $(".answer input").val();
                    question = "Cool! What kind of food are you making?";
                    template = template.replace("{{Question}}", question);
                    template = template.replace("<input", "<input placeholder='Italian, Tex Mex, BBQ, etc.' ");
                    Prospect.Restaurant = $(".answer input[type='text']").val();
                    break;
                case 3:
                    template = '<div class="question"><div class="question"><span>How big will it be?</span></div><div class="answer howbig"><a class="shadowBox">Intimate<div>(Less than 50 seats)</div></a><a class="shadowBox">Average<div>(50 - 150 seats)</div></a><a class="shadowBox">Large<div>(More than 150 seats)</div></a></div></div>';
                    Prospect.Food = $(".answer input[type='text']").val();
                    break;
                case 4:
                    question = "That sounds good,<br/> what city will you be in?";
                    template = template.replace("{{Question}}", question);
                    template = template.replace("<input", "<input placeholder='City, State' ");
                    Prospect.Size = message;
                    break;
                case 5:
                    question = "This is sounding awesome.<br/>Hypothetically, when should we open?";
                    template = template.replace("{{Question}}", question);
                    template = template.replace("<input", "<input placeholder='Month/Year' ");
                    Prospect.City = $(".answer input[type='text']").val();
                    break;
                //case 6:
                //    question = "Here's how it works:";
                //    template = '<div class="question"><span>{{Question}}</span></div><div class="answer" style="padding:30px;"><img src="img/lightbulbMoney.png" style="height:60px;margin: 4px 20px 0 0;" /><h2 style="padding-right: 20px;font-weight: normal;font-size: 22px;margin-bottom: 32px;">You’ve got a great idea for a restaurant but you don’t know how to get started.</h2><a class="button nextBtn" style="margin-left:300px;" >Next</a></div>';
                //    template = template.replace("{{Question}}", question);
                //    break;
                //case 7:
                //    question = "Here's how it works:";
                //    template = '<div class="question"><span>{{Question}}</span></div><div class="answer" style="padding:30px;"><img src="img/businessplan.png" style="height: 110px;margin: 4px 18px 0 0;" /><h2 style="padding-right: 20px;font-weight: normal;font-size: 22px;margin-bottom: 32px;">The first thing you need to do is put together a business plan that you can take to investors or use to open your restaurant.</h2><a class="button nextBtn" style="margin-left:300px;" >Next</a></div>';
                //    template = template.replace("{{Question}}", question);
                //    break;
                //case 8:
                //    question = "Here's how it works:";
                //    template = '<div class="question"><span>{{Question}}</span></div><div class="answer" style="padding:30px;"><img src="img/logoBlue.png" style="height:60px;margin: 4px 12px 40px 0;" /><h2 style="padding-right: 20px;font-weight: normal;font-size: 22px;margin-bottom: 32px;">Restaurant B Plan will write you a full business plan that you can use to turn your dream into a reality.<br/><br/> This plan will be fully customized to your restaurant, and completely editable any time you choose.</h2><a class="button nextBtn" style="margin-left:300px;" >Next</a></div>';
                //    template = template.replace("{{Question}}", question);
                //    break;
                case 6:
                    template = '<div class="tagline"><span>Ready to Get Started?</span></div><a class="pitchButton" onclick="NextQuestion()">Yes, I am</a></div>';
                    Prospect.Opening = $(".answer input[type='text']").val();
                    break;
                case 7:
                    var template = '<div class="question"><span>{{Question}}</span></div><div class="answer">{{Answer}}</div>';
                    question = "Making your restaurant dream<br /> a reality is less than a minute away.";
                    template = template.replace("{{Question}}", question);
                    var answer = "<h2 style='margin: 1em 40px;line-height: 1.1em;'>Join the Newsletter and Get Instant Access to the Famous \"Restaurant Startup Secrets\" Email Mini-Course!</h2>";
                    answer += "<input id='subscribeName' type='text' placeholder='Your Name' style='margin: 5px 40px;width:280px;' />";
                    answer += "<input id='subscribeEmail' type='text' placeholder='Your Email' style='margin: 5px 40px;width:280px;' />";
                    answer += "<div onclick='Subscribe();' class='pitchButton' style='position: relative;width: 262px;margin-left: 26px;left: 0;'>GET MY FREE COURSE</div>";
                    answer += "<div style='color: #444;font-size: 14px;'><img style='height: 18px;margin: 0 8px 0 15px;' src='https://cdn2.iconfinder.com/data/icons/windows-8-metro-style/128/lock.png' />Your email address is never shared with anyone</div>";
                    template = template.replace("{{Answer}}", answer);
                    break;
                case 8:
                    //$(".logoDiv").animate({ "margin-left": "-100%" }, 500, function () { });

                    //$("body").css("overflow-x", "hidden");

                    //$(".forsale .answer").show().animate({ left: "50%" }, 500, function () {
                    //    $("body").css("overflow-x", "");
                    //});

                    //return;

                    break;
                case 11:

                    return;

                default:
                    window.href.location = "/App";

            }

            Prospect.Created = new Date();
            Post("UpdateProspect", { prospect: Prospect });

            $("body").css("overflow-x", "hidden");

            $("#" + questionId).html(template).show().css("margin-left", marginLeft);

            $("#" + questionId).animate({ left: "50%" }, 500, function () {
                $("body").css("overflow-x", "");
                $(".answer input").first().focus();
            });
        }

        function Subscribe() {
            var body = $("#subscribeName").val() + ", " + $("#subscribeEmail").val();
            SendEmail("New Subscriber", EscapeString(body));

            Prospect.Name = $("#subscribeName").val();
            Prospect.Email = $("#subscribeEmail").val();
            Prospect.Created = new Date();
            Post("UpdateProspect", { prospect: Prospect });

            //Post("Subscribe", { name: EscapeString($("#subscribeName").val()), email: EscapeString($("#subscribeEmail").val()), restaurantName: restaurantName });

            $("#question1 .answer").html("<div style='height: 254px;'><img src='https://govizzle.com/images/loading-animation.gif' style='height: 60px;margin: 72px 168px 110px;' /></div>");
            setTimeout(function () {
                $("#question1 .answer").html("<div style='color: #333;font-size: 24px;margin: 20px 0;'>Thank you for signing up for the Restaurant B Plan course. <br/><br/>You will receive your Free Email course shortly.</div>");
            }, 2500);
        }

        function BuyClick(planType) {
            SendEmail("Plan Selected", planType);

            $(".payment .packageType").html(planType);
            $("body").css("overflow-x", "hidden");

            $(".forsale .answer").animate({ left: "-100%" }, 500, function () {
                $(".forsale .answer").hide();
            });

            $(".payment .question").show().animate({ left: "0" }, 500, function () { });

            $(".payment .answer").show().animate({ left: "50%" }, 500, function () {
                $("body").css("overflow-x", "");
            });
        }

        function GoToApp() {
            $(".pitchButton").fadeOut();
            $(".questions img").fadeIn(1000);
            window.location.href = "/App";
        }

        function ValidateSignUp()
        {
            $(".signUp input").removeClass("error");
            var valid = true;
            if (!$("#Name").val()) {
                $("#Name").addClass("error");
                valid = false;
            }
            if (!$("#Email").val()) {
                $("#Email").addClass("error");
                valid = false;
            }
            if (!$("#Password").val()) {
                $("#Password").addClass("error");
                valid = false;
            }
            if (!$("#ConfirmPassword").val()) {
                $("#ConfirmPassword").addClass("error");
                valid = false;
            }
            if ($("#Password").val() != $("#ConfirmPassword").val()) {
                $("#Password").addClass("error");
                $("#ConfirmPassword").addClass("error");
                valid = false;
            }
            if (!valid)
                return false;
            else
                User = { Name: $("#Name").val(), Email: $("#Email").val(), Password: $("#Password").val() };

            $(".signUp img").show();
            $(".button").hide();

            var success = function (error) {
                if (error) {
                    $(".error").html(error);
                    $(".signUp img").hide();
                    $(".button").show();
                }
                else {
                    window.location.href = "/App";
                }
            };

            Post("CreateUser", { user: User, restaurantName: restaurantName }, success);
        }

        function ValidateCC()
        {
            if ($(".disabled").length)
                return;

            $(".error").html("");
            $(".signUp input").removeClass("error");
            var valid = true;
            if (!$("#CardNumber").val()) {
                $("#CardNumber").addClass("error");
                valid = false;
            }
            if (!$("#Month").val()) {
                $("#Month").addClass("error");
                valid = false;
            }
            if (!$("#Year").val()) {
                $("#Year").addClass("error");
                valid = false;
            }
            if (!$("#CVC").val()) {
                $("#CVC").addClass("error");
                valid = false;
            }
            if (!valid)
                return;

            User.Annual = $("img.annual").attr("src") == "img/CheckedRadio.png";

            var creditCard = { CardNumber: $("#CardNumber").val(), CardExpirationMonth: $("#Month").val(), CardExpirationYear: $("#Year").val(), Cvc: $("#CVC").val(), Price: price };
            User.CreditCard = creditCard;

            var success = function (error) {
                if (error) {
                    $(".error").html(error);
                    $(".loading").hide();
                    $(".button").removeClass("disabled");
                }
                else
                {
                    window.location.href = "/App";
                }
            };

            $(".loading").show();
            $(".button").addClass("disabled");

            Post("CreateUser", { user: User, restaurantName: restaurantName }, success);
        }

        function SendEmail(subject, body) {
            //body += "%3Cbr/%3E%3Cbr/%3EPrice $" + price;
            body += "%3Cbr/%3E%3Cbr/%3E" + new Date();

            Post("SendEmail", { subject: subject, body: body });
        }
        
        function OpenLogin()
        {
            $(".modal-backdrop").show();
            $(".loginDialog").show();
        }

        function Login()
        {
            var success = function (error) {
                if (error) {
                    $(".loginDialog .error").html(error);
                }
                else {
                    window.location.href = "/App";
                }
            };
            Post("Login", { email: $("#LoginEmail").val(), password: $("#LoginPassword").val() }, success);
        }

        function SendPassword()
        {
            var success = function (error) {
                if (error) {
                    $(".forgotDialog .error").html(error);
                }
                else {
                    $(".forgotDialog .error").html("Your password has been sent.");
                    $(".forgotDialog .error").removeClass("error");
                }
            };
            Post("SendPassword", { email: $("#ForgotPasswordEmail").val() }, success);
        }

    </script>
</head>
<body>
<form id="form1" runat="server">
    <div class="modal-backdrop" style="height:150%"></div>
    <div class="loginDialog">
        <div class="dialogClose" onclick="$('.loginDialog').hide();$('.modal-backdrop').hide();">X</div>
        <h3>Log In</h3>
        <div>Email</div><input type="text" id="LoginEmail" />
        <div>Password</div><input type="password" id="LoginPassword" />
        <div class="forgotPassword">Forgot your password?</div>
        <div class="error" style="margin: -12px 0 12px;"></div>
        <a class="button" onclick="Login();">Log In</a>
    </div>  
    <div class="forgotDialog">
        <div class="dialogClose" onclick="$('.forgotDialog').hide();$('.modal-backdrop').hide();">X</div>
        <h3>Forgot Password</h3>
        <div>Enter your email to recover your password.</div><input type="text" id="ForgotPasswordEmail" />
        <div class="error" style="margin: 6px 0 -6px;"></div>
        <br />
        <a class="button" onclick="SendPassword();">Send Email</a>
    </div>   
    <header class="mainnav">
         <ul>
            <li><a href="#">HOME</a></li>
            <li><a href="#howitworks">ABOUT</a></li>
            <li><a href="#contact">CONTACT</a></li>
            <li class="loginBtn"><a onclick="OpenLogin();">LOG IN</a></li>
        </ul>
    </header>
    <div class="pitch">
        <div class="logoDiv" >
            <img src="img/logo.png" />
        </div>
        <div class="opening" style="position:relative;">
            <div class="tagline">
                <span>Want to Start a Restaurant?</span>
            </div>
            <a class="pitchButton">
                Yes, I do
            </a>
        </div>
        <div id="question0" class="questions" >
            <div class="question">
                <span>Awesome, let's get started.<br/> So what kind of restaurant is this?</span>
            </div>
            <div class="answer whatType">
                <a class="shadowBox">Fine Dining<img style="margin-left: 56px;" src="img/finedining.png" /></a>
                <a class="shadowBox">Casual<img style="margin-left: 58px;" src="img/casual.png" /></a>
                <a class="shadowBox">Fast Casual<img style="margin-left: 55px;" src="img/fastcasual.png" /></a>
                <a class="shadowBox">Trailer<img style="margin-left: 43px;" src="img/trailer.png" /></a>
            </div>
        </div>     
        <div id="question1" class="questions" >
            <div class="question">
                <span>Awesome, let's get started.<br /> What do you want to call it?</span>
            </div>
            <div class="answer">
                <input type="text" style="font-size:20px;width: 240px;" />
                <a class="button">Next</a>
            </div>
        </div> 
        <div class="subscribe">
            <div class="question">
                <span>Making your restaurant dream<br /> a reality is less than a minute away.</span>
            </div>
            <div class="answer">

            </div>
        </div>
        <div class="forsale">
            <div class="answer">
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
                            <div>A 12 section fully customizable plan in Microsoft Word format</div>
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
                            <div>11 interlinked financial documents with explanations of what every field means. </div>
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
                            <div style="font-weight:bold;">Includes all the templates you need: Business Plan AND Financial Plan</div>
                            <div>Everything you need to create a top-notch plan to raise money and start your restaurant</div>
                        </div>
                    </div>
                </div>
                <div class="priceExplanation">All documents come fully written and customized to your restaurant.</div>
                <div class="priceExplanation">Through Restaurant B Plan you can edit everything with instructions and explanations from professional restauranteurs.</div>
                <div class="priceExplanation" style="width: 348px;">If you are disappointed with your plan, we provide 100% money back guarantee.</div>
                <img src="img/guarantee.png" style="height: 106px;position: absolute;left: 410px;margin-top: -90px;" />
            </div>
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
                <img src="img/guarantee.png" style="height: 106px;margin: 101px 0 0 152px;" />
            </div>
        </div>
    </div>
    <div id="howitworks" class="arrow-up"></div>
    <div class="howitworks">
        <h2 style="margin-bottom:2em;"><span style="color:#F19F00;"><i>Restaurant B Plan</i></span>&nbsp;&nbsp;Plan a restaurant today!</h2>
        <div class="step">
            <img src="img/lightbulbMoney.png" />
            <div class="horizontal"></div>
            <div>A well-conceived, professional restaurant business plan is your greatest single asset for turning your restaurant dreams into reality. It's the key to convincing anyone to invest money, make a loan, lease space, essentially do business with you prior to opening.
                <br /><br />
                Zach Wolff<br />
                Restaurant Consultant</div>
        </div>
        <div class="step">
            <img src="img/graph.png" />
            <div class="horizontal"></div>
            <div>Having a sound business plan was the single most important ingredient in making my new business a reality.
            <br /><br />
            Kellie Reed<br />
            The Topaz <br />
            Santa Rosa, CA
            </div>
        </div>
        <div class="step">
            <img src="img/logoBlue.png" />
            <div class="horizontal"></div>
            <div>The business plan is the most important thing I look at when considering a small business loan. Without a well thought-out business plan, I have a difficult time granting the loan.
                <br /><br />
                Joe Herman<br />
                Small Business Lender</div>
        </div>
    </div>
    <div class="quote">
        "Restaurant B Plan saved us a lot of time and money and was incredibly helpful for getting our restaurant off the ground."
    </div>
    <br />
    <div id="contact" class="contact">
        <h2>Contact Us</h2>
        <div class="horizontal" style="margin: -4px 15% 4px;"></div>
        <input id="Subject" type="text" placeholder="Subject" />
        <textarea id="Body" placeholder="Give us your feedback!" rows="4" ></textarea>
        <br />
        <br />
        <div class="button" style="margin:0 auto;" >SUBMIT</div><h2 style="float:left;display: none;width:100%;text-align:center;"><span style="color:#F19F00;"><i>Thanks for contacting us. Your email has been sent.</i></span></h2>
        <div class="footer">
            <span></span>
        </div>
    </div>
    </form>

<%--<a title="Web Statistics" href="http://clicky.com/100820445"><img alt="Web Statistics" src="//static.getclicky.com/media/links/badge.gif" border="0" /></a>--%>
<script type="text/javascript">
    var clicky_site_ids = clicky_site_ids || [];
    clicky_site_ids.push(100820445);
    (function () {
        var s = document.createElement('script');
        s.type = 'text/javascript';
        s.async = true;
        s.src = '//static.getclicky.com/js';
        (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(s);
    })();
</script>
<noscript><p><img alt="Clicky" width="1" height="1" src="//in.getclicky.com/100820445ns.gif" /></p></noscript>
</body>
</html>
