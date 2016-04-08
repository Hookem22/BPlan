<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="App_Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Restaurant B Plan</title>
    <meta name="description" content="How to Start a Restaurant. Restaurant Business Plans and Checklists. RestaurantBPlan.com" />
    <%--<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=0"/>--%>
    <link rel="icon" type="image/png" href="../img/favicon.png">
    <link href="/Styles/Bootstrap/css/bootstrap.css" rel="stylesheet" />
    <link href="/Styles/Bootstrap/css/bootstrap-theme.css" rel="stylesheet" />
                                                                                    
    <link href="/Styles/Style.css" rel="stylesheet" type="text/css" />
    <link href="/Styles/App.css" rel="stylesheet" type="text/css" />

    <script src="/Scripts/jquery-2.0.3.min.js" type="text/javascript"></script>
    <script src="/Scripts/bootstrap.js"></script>
    <script src="/Scripts/Helpers.js" type="text/javascript"></script>

    <script type="text/javascript">
        var Questions;
        var currentQuestion = 0;
        var currentUserId = 0;
        var currentUser;
        var currentProspect;

        $(document).ready(function () {
            currentUserId = +$("#CurrentUserId").val();
            var prospectId = +$("#ProspectId").val();
            if (prospectId) {
                   
                var prospectSuccess = function (prospect) {
                    currentProspect = prospect;
                    $("#createName").val(prospect.Restaurant);
                    $("#createFood").val(prospect.Food);
                    $("#createCity").val(prospect.City);
                    $("#createOpening").val(prospect.Opening);
                    $(".createRestaurant .shadowBox").each(function () {
                        if ($(this).html() == prospect.RestaurantType)
                            $(this).addClass("active");
                    });

                    $(".modal-backdrop").show();
                    $(".createRestaurant").show();
                };
                Post("GetProspect", { prospectId: prospectId }, prospectSuccess);

            }
            else {
               var success = function (user) {
                    currentUser = user;
                    if (!user.Restaurant) {
                        $(".modal-backdrop").show();
                        $(".createRestaurant").show();
                    }
                    else {
                        $(".myAccount a").html(user.Name);
                        $(".restaurantName").html(user.Restaurant.Name);

                        var questionsSuccess = function (results) {
                            Questions = results;
                        };
                        Post("GetQuestions", { restaurantId: user.Restaurant.Id }, questionsSuccess);
                    }
                };
                Post("GetUser", { userId: currentUserId }, success);


            }

            $(".signupBtn").click(function() {
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

                var success = function (user) {
                    currentUser = user;

                    $(".myAccount a").html(user.Name);
                    $(".restaurantName").html(user.Restaurant.Name);

                    $(".modal-backdrop").hide();
                    $(".signup").hide();
                };

                Post("CreateUser", { user: user, prospectId: prospectId }, success);
            });

            $(".createRestaurantBtn").click(function () {
                $(".createRestaurantBtn").animate({ "opacity": 0.01 }, 500, function () {
                    //$(".createRestaurantBtn").hide();
                    $(".creatingPlan").fadeIn();
                    $(".createRestaurant").animate({ "height": "205px", "top": "120px" }, 1500, function () { });
                });

                var meals = "";
                $(".createRestaurant .meals .blueCheckBox.checked").each(function () {
                    if (meals) {
                        meals += "|"
                    }
                    meals += $(this).attr("val");
                });
                var drinks = "";
                $(".createRestaurant .drinks .blueCheckBox.checked").each(function () {
                    if (drinks) {
                        drinks += "|"
                    }
                    drinks += $(this).attr("val");
                });
                var size = currentProspect == "Intimate" ? 50 : currentProspect == "Average" ? 100 : 150;
                var params = {
                    userId: currentUserId, name: $("#createName").val(), food: $("#createFood").val(), restaurantType: $(".createRestaurant .shadowBox.active").html(),
                    size: size, city: $("#createCity").val(), opening: $("#createOpening").val(), meals: meals, drinks: drinks
                };

                var restaurantCreated = function () {

                };
                Post("CreateRestaurant", params, restaurantCreated);
            });

            $(".nav.primary div").not(".restaurantName").click(function () {
                if ($(this).hasClass("active"))
                    return;

                var currentScreen = $(".nav.primary div.active").html();
                $(this).siblings().removeClass("active");
                $(this).addClass("active");
                $(".nav.secondary .subheaderList div.active").css({ "border-color": "#0082c3", "color": "#1a384b" });
                $(".nav.secondary .subheaderList div").removeClass("active");

                $(".businessPlanContent").addClass("last");
                Get(currentScreen);
                populateSubs = setInterval(function () {
                    if (!$(".businessPlanContent").hasClass("last") && $(".printContent").length == 0) {
                        clearInterval(populateSubs);
                        PopulateSubheaders();
                    }
                }, 100);

            });

            $("body").on("click", ".nav.secondary .subheaderList div", function () {
                if ($(this).hasClass("active"))
                    return;

                if ($(this).text() == "Print")
                {
                    var header = $(".nav.primary .active").html();
                    window.open("/Word?header=" + header);
                    return;
                }

                $(this).siblings().removeClass("active");
                $(this).addClass("active");

                Get();
            });

            $("body").on("click", ".main .backBtn", function () {
                if ($(this).hasClass("clicked"))
                    return;

                $(this).addClass("clicked");
                BackClicked();
                $(this).removeClass("clicked");
            });

            $("body").on("click", ".main .nextBtn", function () {
                if ($(this).hasClass("clicked"))
                    return;

                $(this).addClass("clicked");
                NextClicked();
                $(this).removeClass("clicked");
            });

            $("body").on("click", ".blueCheckBox", function () {
                $(this).toggleClass("checked");
            });

            $(".createRestaurant .shadowBox").click(function () {
                $(".createRestaurant .shadowBox").removeClass("active");
                $(this).addClass("active");
            });

            $(".main").on("click", ".scrollArrow", function () {
                var left = $(".subheaderList").css("left");
                left = +left.substring(0, left.indexOf("px"));
                var leftClick = $(this).hasClass("left");
                if(left <= -770)
                    left = leftClick ? -310 : -770;
                else if (left <= -310)
                    left = leftClick ? 25 : -770;
                else if(left <= 25)
                    left = leftClick ? 25 : -310;

                $(".subheaderList").animate({ left: left + "px" }, 200, function () { });

            });

            $(".main").on("click", ".ExampleBtn", function () {
                if($(this).text() == "Show Examples")
                {
                    $(this).text("Hide Examples");
                    $(".ExampleText").slideDown();
                    $(".scrollExample").css({ opacity: "" });
                }
                else
                {
                    $(this).text("Show Examples");
                    $(".ExampleText").slideUp();
                    $(".scrollExample").css({ opacity: .01 });
                }
            });

            $(".main").on("click", ".scrollExample", function () {
                if (Examples.length < 2)
                    return;

                if ($(this).hasClass("left"))
                {
                    currentExample--;
                    if (currentExample < 1)
                        currentExample = Examples.length - 1;
                }
                else
                {
                    currentExample++;
                    if (currentExample > Examples.length - 1)
                        currentExample = 1;
                }
                $(".ExampleText div").html(RemoveFrontBreaks(Examples[currentExample]));
            });

            $(".main").on("click", ".printContent img", function () {
                var src = $(this).attr("src").indexOf("Unchecked") >= 0 ? "../img/Checked.png" : "../img/Unchecked.png";
                $(this).attr("src", src);
            });

            $(".main").on("click", ".printBtn", function () {
                var header = "";
                var imgs = $(".printContent img");
                for (var i = 0; i < imgs.length; i++)
                {
                    if ($(imgs[i]).attr("src").indexOf("Unchecked") < 0)
                        header += i;
                }
                if (header)
                {
                    window.open("/Word?header=" + header + "&r=" + currentUser.Restaurant.Id);
                }
                else
                {
                    MessageBox("Please check at least one category.");
                }
            });

        });

        function Get(currentScreen)
        {
            if (currentScreen == "My Restaurant")
                SaveRestaurant();

            var header = $(".nav.primary .active").html();
            var category = $(".nav.secondary .active").html() || "";
            if (!category)
            {
                if (header == "Get Started") {
                    var header = "Welcome to Restaurant B Plan";
                    var para = "Here are the instructions.";

                    var html = "<div class='businessPlanContent'>";
                    html += "<h2 style='text-align:center;margin-bottom:.5em;'>" + header + "</h2>";
                    html += "<div class='instructions' style='margin: 2em 1em;'>" + para + "</div>";
                    html += "</div>";

                    PrevScreen(html);
                }
                else if (header == "My Restaurant") {
                    var rst = currentUser.Restaurant;
                    var header = rst.Name;
                    var para = "<div class='multiTextGroup' style='margin: 0 20px 30px 50px'>";
                    para += "<div class='multiText' style='clear:left;'><div style='float:left;max-width:290px;'>Kind of Food</div>";
                    para += "<input id='Food' type='text' value='" + rst.Food + "'></div>";
                    para += "<div class='multiText' ><div style='float:left;max-width:290px;'>Restaurant Style</div>";
                    para += "<select id='RestaurantType'><option value='Fine Dining'>Fine Dining</option><option value='Fast Casual'>Fast Casual</option>";
                    para += "<option value='Casual'>Casual</option><option value='Trailer'>Trailer</option></select></div>";
                    para += "<div class='multiText' style='clear:left;'><div style='float:left;max-width:290px;'>Number of Dining Seats</div>";
                    para += "<input id='Size' type='text' value='" + rst.Size + "'></div>";
                    para += "<div class='multiText' ><div style='float:left;max-width:290px;'>Square Footage</div>";
                    para += "<input id='SquareFootage' type='text' value='" + rst.SquareFootage + "'></div>";
                    para += "<div class='multiText' style='clear:left;'><div style='float:left;max-width:290px;'>City</div>";
                    para += "<input id='City' type='text' value='" + rst.City + "'></div>";
                    para += "<div class='multiText' ><div style='float:left;max-width:290px;'>Projected Opening Date</div>";
                    para += "<input id='Opening' type='text' value='" + rst.Opening + "'></div>";
                    para += "</div>";

                    var html = "<div class='businessPlanContent'>";
                    html += "<h2 style='text-align:center;margin-bottom:.5em;'>" + header + "</h2>";
                    html += para;
                    html += "</div>";

                    var populate = function () {
                        $(".multiTextGroup select").val(rst.RestaurantType);
                    };

                    if (currentScreen == "Get Started")
                        NextScreen(html, populate);
                    else
                        PrevScreen(html, populate);
                }
                else if (header == "Edit B Plan") {
                    currentQuestion = 0;
                    if (currentScreen == "Get Started" || currentScreen == "My Restaurant")
                        NextScreen();
                    else
                        PrevScreen();
                }
                else if (header == "Plan Explained") {
                    var header = "Plan Explained";
                    var para = "Blah blah";

                    var html = "<div class='businessPlanContent'>";
                    html += "<h2 style='text-align:center;margin-bottom:.5em;'>" + header + "</h2>";
                    html += "<div class='instructions' style='margin: 2em 1em;'>" + para + "</div>";
                    html += "</div>";

                    if (currentScreen == "Print")
                        PrevScreen(html);
                    else
                        NextScreen(html);
                }
                else if (header == "Print") {
                    PopulatePrint();
                }
            }
            else {
                for (var i = 0; i < Questions.length; i++) {
                    if (Questions[i].QuestionSheet.Name == category) {
                        currentQuestion = i;
                        break;
                    }
                }

                NextScreen();
            }
        }

        function PopulateSubheaders()
        {
            $(".btnSection").show();
            var subheaders = [];
            var header = $(".nav.primary div.active").html();
            if (header == "Get Started")
            {
                //subheaders = ["Create Your Concept"];
                //$(".scrollArrow").hide();
                //$(".nav.secondary .subheaderList").css({ left: "50px" });

                $(".scrollArrow").hide();
                $(".nav.secondary .subheaderList").hide();
                $(".backBtn").hide();
            }
            else if (header == "My Restaurant")
            {
                //subheaders = ["Management Team", "Market Analysis", "Marketing Strategy", "Staffing", "Company Description", "Daily Operations", "Software and Controls", "Other Control Systems", "Inventory", "Accounting"];
                //$(".scrollArrow").show();
                //$(".nav.secondary .subheaderList").css({ left: "25px" });

                $(".scrollArrow").hide();
                $(".nav.secondary .subheaderList").hide();
                $(".backBtn").hide();
            }
            else if (header == "Edit B Plan")
            {
                subheaders = ["Basic Info", "Capital Budget", "Sales Projection", "Hourly Labor", "Expenses", "Investment"];
                $(".scrollArrow").hide();
                $(".nav.secondary .subheaderList").css({ left: "50px" }).show();
                $(".backBtn").show();
            }

            $(".nav.secondary .subheaderList").html("");
            for (var i = 0; i < subheaders.length; i++) {
                if (i == 0)
                    $(".nav.secondary .subheaderList").append($("<div>", { class: "active", style: "margin-left:0;left:0;", text: subheaders[i] }));
                else
                    $(".nav.secondary .subheaderList").append($("<div>", { text: subheaders[i] }));
            }

        }

        function PopulateContent(html, func)
        {
            if (html) {
                $(".fromDb").html(html);
                if (func) {
                    func();
                }
                return;
            }

            if (!Questions.length) {
                $(".fromDb").html("");
                return;
            }

            //Set subheader
            $(".subheaderList div").each(function () {
                if ($(this).html() == Questions[currentQuestion].QuestionSheet.Name) {
                    $(this).addClass("active");
                } else {
                    $(this).removeClass("active");
                }
            });

            //Overview
            if (Questions[currentQuestion].Id == -1 && Questions[currentQuestion].Title)
            {
                var question = Questions[currentQuestion];
                var html = "<div class='businessPlanContent'>";
                var header = $(".nav.primary div.active").html();
                var para = question.Title;
                if (para.indexOf("{") >= 0 && para.indexOf("}") >= 0) {
                    header = para.substring(para.indexOf("{") + 1);
                    header = header.substring(0, header.indexOf("}"));
                    para = para.substring(para.indexOf("}") + 1);
                    para = RemoveFrontBreaks(para);
                }
                html += "<h2 style='text-align:center;margin-bottom:.5em;'>" + header + "</h2>";
                html += "<div class='instructions' style='margin: 2em 1em;'>" + para + "</div>";
                html += "</div>";

                $(".fromDb").html(html);
                return;
            }
            else if (Questions[currentQuestion].Id == -1)
            {
                currentQuestion++;
            }

            //Summary
            //if (!Questions[currentQuestion] && Questions[currentQuestion - 1] && Questions[0].Help) {
            //    var question = Questions[0];
            //    var html = "<div class='businessPlanContent'>";
            //    var header = $(".nav.secondary div.active").html();
            //    var para = question.Help;
            //    if (para.indexOf("{") >= 0 && para.indexOf("}") >= 0) {
            //        header = para.substring(para.indexOf("{") + 1);
            //        header = header.substring(0, header.indexOf("}"));
            //        para = para.substring(para.indexOf("}") + 1);
            //        para = RemoveFrontBreaks(para);
            //    }
            //    html += "<h2 style='text-align:center;margin-bottom:.5em;'>" + header + "</h2>";
            //    html += "<div class='instructions' style='margin: 2em 1em;'>" + para + "</div>";
            //    html += "</div>";

            //    $(".fromDb").html(html);
            //    return;
            //}

            if (Questions[currentQuestion].QuestionSheet.Header == "Financials") {
                var html = "";
                for (var i = 0; i < Questions.length; i++) {
                    if (!Questions[currentQuestion + i])
                        break;

                    var style = Questions[currentQuestion + i].SkipCondition == "Always" ? "display:none;" : "";
                    if (i == 0) {
                        html += "<div class='multiTextGroup'><h2>" + Questions[currentQuestion].Section + "</h2>";
                    }
                    else if (currentQuestion + i == Questions.length || Questions[currentQuestion + i].Page != Questions[currentQuestion + i - 1].Page) {
                        break;
                    }
                    else if (Questions[currentQuestion + i].Section != Questions[currentQuestion + i - 1].Section) {
                        html += "</div><div class='multiTextGroup divider'>";
                        html += "<h2>" + Questions[currentQuestion + i].Section + "</h2>";
                    }
                    else if (!Questions[currentQuestion + i].Title) {
                        html += "<div style='clear:both;'></div>";
                    }

                    var oddQuestions = ["Management & Chef", "Selling & Promotions", "Electricity", "Dues & Subscriptions", "Printed Materials", "Water", "Host / Hostess Rate", "Hosts / Hostesses Per Day",
                        "Bartender Rate", "Number of Bartenders per Day", "Prep Cook Rate", "Prep Cooks per Day", "Expo Rate", "Expos per Day"];
                    var evenQuestions = ["Advertising", "Research", "Gas", "Trash Removal", "Host / Hostess Average Number of Hours", "Bartender Average Number of Hours", "Prep Cook Average Number of Hours", "Expo Average Number of Hours"];
                    var even = (i % 2 && !(oddQuestions.indexOf(Questions[currentQuestion + i].Title) >= 0)) || evenQuestions.indexOf(Questions[currentQuestion + i].Title) >= 0 ? "even" : "";
                    style += even && !Questions[currentQuestion + i].Options ? "" : "clear:left;";

                    var shiftUp = ["Payroll Taxes & Employee Benefits"];
                    if (shiftUp.indexOf(Questions[currentQuestion + i].Title) >= 0)
                        style += "margin-top:-68px;";

                    var shiftDown = ["Host / Hostess Rate", "Host / Hostess Shifts per Day", "FICA Taxes - as a % of Gross Payroll", "Disability and Life Insurance", "Common Area Maintenance (CAM)"];
                    if (shiftDown.indexOf(Questions[currentQuestion + i].Title) >= 0)
                        style += "margin-top:31px;";

                    var wides = ["Food Cost %", "Liquor Cost %", "Salary % Increase", "Year 1 Percentage"];
                    even += wides.indexOf(Questions[currentQuestion + i].Title) >= 0 ? " wide" : "";
 
                    html += "<div class='multiText' style='" + style + "'><div style='float:left;max-width:290px'>" + Questions[currentQuestion + i].Title + "</div>";
                    if (Questions[currentQuestion + i].Help) {
                        var help = Questions[currentQuestion + i].Help;
                        if (help.indexOf("{") >= 0 && help.indexOf("}") >= 0)
                        {
                            var link = help.substring(help.indexOf("{") + 1);
                            link = link.substring(0, link.indexOf("}"));
                            help = help.substring(0, help.indexOf("{"));
                            var id = Questions[currentQuestion + i].Id;
                            help += "<a onclick='OpenHelp(" + id + ");'>" + link + "</a>";
                        }
                        html += "<div class='questionMarkWrapper'><img class='questionMark' src='../img/blueQuestion.png' /><div class='" + even + "'><div>" + help + "</div></div></div>";
                    }
                    var answer = Questions[currentQuestion + i].Answer.Text || "";
                    html += "<input type='text' value='" + answer + "' /></div>";
                }
                html += "</div>";
                $(".fromDb").html(html);

            }
            else {
                var question = Questions[currentQuestion];
                var html = "<div class='businessPlanContent'>";
                html += "<h2>" + question.Section + "</h2>";
                Examples = question.Title.split("{Example}");
                currentExample = 1;
                var title = Examples.length ? Examples[0] : question.Title;

                html += "<div class='instructions'>" + title + "</div>";
                if (Examples.length > 0) {
                    html += "<div class='ExampleBtn'>Show Examples</div>";

                    html += "<div style='display:none;' class='ExampleText'>"
                    html += "<img class='scrollExample left' src='../img/largeLeftArrow.png' />";
                    html += "<div>" + RemoveFrontBreaks(Examples[currentExample]) + "</div>";
                    html += "<img class='scrollExample right' src='../img/largeRightArrow.png' />";
                    html += "</div>";
                        
                }

                var answer = question.Answer.Text || "";
                html += "<textarea class='AnswerControl'>" + answer + "</textarea>";
                html += "</div>";

                $(".fromDb").html(html);
            }
            
        }

        function PopulatePrint()
        {
            $(".main").animate({ "margin-left": "0" }, 200, function () {
                $(".main").fadeOut(100, function () {
                    
                    $(".nav.secondary .subheaderList").html("");
                    $(".scrollArrow").hide();

                    var question = Questions[0];
                    var html = "<div class='printContent'>";
                    html += "<h2 style='text-align:center;margin-bottom:.5em;'>Print Business Plan</h2>";
                    html += "<div style='margin: 1em 6em 2em 8em;float:left;'>";
                    html += "<div><img src='../img/Checked.png' />Concept</div>";
                    html += "<div><img src='../img/Checked.png' />Business Plan</div>";
                    html += "<div><img src='../img/Checked.png' />Financials</div>";
                    html += "</div>";
                    html += "<div class='printBtn'>Print Now</div>";
                    html += "</div>";
                    html += "<div style='clear:both;'></div>";

                    $(".fromDb").html(html);
                    $(".btnSection").hide();

                    var margin = ($(window).width() - 800) / 2;
                    $(".main").css("margin-left", margin + 100 + "px");
                    $(".main").fadeIn(100, function () {
                        $(".main").css("margin-left", "auto");
                        $("#AnswerControl").focus();
                    });
                });
            });



        }

        function BackClicked()
        {
            currentQuestion--;
            for (var i = currentQuestion; i > 0; i--) {
                if (!CheckSkip(Questions[i].SkipCondition)) {
                    break;
                }
                currentQuestion--;
            }
            while (currentQuestion > 0 && Questions[currentQuestion].Page && Questions[currentQuestion].Page == Questions[currentQuestion - 1].Page) {
                currentQuestion--;
            }

            //Previous Section
            if (currentQuestion < 0 || (currentQuestion == 0 && !Questions[0].Title)) {
                var header = $(".nav.secondary div.active").prev();
                if (header && header.length) {
                    if ($(header).text() == "Staffing")
                        $(".subheaderList").animate({ left: "0px" }, 200, function () { });

                    header.click();
                }
                else {
                    header = $(".nav.primary div.active").prev();
                    header.click();
                }
                return;
            }

            PrevScreen();
        }

        function NextClicked()
        {
            SaveAnswer();
            currentQuestion++;

            for (var i = currentQuestion; i < Questions.length; i++) {
                if (!CheckSkip(Questions[i].SkipCondition)) {
                    break;
                }
                currentQuestion++;
            }
            while (Questions[currentQuestion] && Questions[currentQuestion].Page && Questions[currentQuestion].Page == Questions[currentQuestion - 1].Page) {
                currentQuestion++;
            }

            //Next Section
            if (!Questions[currentQuestion] && (!Questions[currentQuestion - 1] || !Questions[0].Help)) {
                var header = $(".nav.secondary div.active").next();
                if (header && header.length) {
                    if ($(header).text() == "Daily Operations")
                        $(".subheaderList").animate({ left: "-770px" }, 200, function () { });

                    header.click();
                }
                else {
                    header = $(".nav.primary div.active").next();
                    header.click();
                }
                return;
            }

            NextScreen();
        }

        function CheckSkip(skip)
        {
            if (!skip || skip.indexOf("|") < 0 || skip.split("|").length < 2)
                return false;
            
            var title = skip.split("|")[0];
            var answer = skip.split("|")[1];
            for (var i = 0; i < Questions.length; i++) {
                if (Questions[i].Title == title) {
                    return Questions[i].Answer.Text == null || Questions[i].Answer.Text.indexOf(answer) < 0;
                }
            }
        }

        function NextScreen(html, func)
        {
            $(".main").animate({ "margin-left": "0" }, 200, function () {
                $(".main").fadeOut(100, function () {
                    PopulateContent(html, func);
                    var margin = ($(window).width() - 800) / 2;
                    $(".main").css("margin-left", margin + 100 + "px");
                    $(".main").fadeIn(100, function () {
                        $(".main").css("margin-left", "auto");
                        $("#AnswerControl").focus();
                    });
                });
            });
        }

        function PrevScreen(html, func) {
            var margin = ($(window).width() - 800) / 2;
            $(".main").animate({ "margin-left": margin + 100 + "px" }, 200, function () {
                $(".main").fadeOut(100, function () {
                    PopulateContent(html, func);
                    $(".main").css("margin-left", "0");
                    $(".main").fadeIn(100, function () {
                        $(".main").css("margin-left", "auto");
                        $("#AnswerControl").focus();
                    });
                });
            });
        }

        function SaveRestaurant() {
            currentUser.Restaurant.Food = $("#Food").val();
            currentUser.Restaurant.RestaurantType = $("#RestaurantType").val();
            currentUser.Restaurant.Size = $("#Size").val();
            currentUser.Restaurant.SquareFootage = $("#SquareFootage").val();
            currentUser.Restaurant.City = $("#City").val();
            currentUser.Restaurant.Opening = $("#Opening").val();

            Post("SaveRestaurant", { restaurant: currentUser.Restaurant });
        }

        function SaveAnswer()
        {
            if (!Questions[currentQuestion] || Questions[currentQuestion].Id < 0)
                return;

            var answer = "";
            if ($(".multiText input").length > 0) { //Multi
                var answerText = [];
                $(".multiText input").each(function () {
                    answerText.push($(this).val());
                });
                var answerArray = [];
                for (var i = 0, blankQuestions = 0; i < answerText.length; i++) {
                    if (!Questions[currentQuestion + blankQuestions + i].Title) {
                        blankQuestions++;
                    }
                    var question = Questions[currentQuestion + blankQuestions + i];
                    question.Answer.Text = answerText[i];
                    answerArray.push(question.Answer);
                }

                var success = function (answers) {
                    for (var x = 0; x < Questions.length; x++) {
                        for (var y = 0; y < answers.length; y++) {
                            if (Questions[x].Id == answers[y].QuestionId) {
                                Questions[x].Answer.Id = answers[y].Id;
                            }
                        }
                    }
                };
                Post("SaveAnswers", { answers: answerArray }, success);
                return;
            }


            if ($(".added.AnswerControl").length > 0) { //ListControl
                $(".added.AnswerControl").each(function () {
                    answer += $(this).text() + ", ";
                });
                answer = answer.substring(0, answer.length - 2);
            }
            else if ($(".AnswerControl").length > 1) { //Checkboxes
                $(".AnswerControl:checked").each(function () {
                    answer += $(this).val() + ", ";
                });
                answer = answer.substring(0, answer.length - 2);
            }
            else {
                answer = $("input[name='AnswerControl']:checked").val() || $(".AnswerControl").val();
            }

            var question = Questions[currentQuestion];
            question.Answer.Text = answer;

            //Save to DB
            var success = function (answerId) {
                question.Answer.Id = answerId;
            };
            Post("SaveAnswer", { answer: question.Answer }, success);
        }

        function OpenHelp(id)
        {
            for (var i = 0; i < Questions.length; i++) {
                if (Questions[i].Id == id) {
                    var question = Questions[i];
                }
            }
            $(".helpDialog h3").html(question.Title);
            var help = question.Help.substring(question.Help.indexOf("}") + 1);
            help = RemoveFrontBreaks(help);
            $(".helpDialog .dialogContent").html(help);

            $(".helpDialog").show();
            $(".modal-backdrop").show();
        }

        function OpenSettings()
        {
            $("#SettingsName").val(currentUser.Name);
            $("#SettingsRestaurant").val(currentUser.Restaurant.Name);
            $("#SettingsEmail").val(currentUser.Email);
            $(".passwordError, .cancelError").html("");

            $(".settingsDialog").show();
            $(".modal-backdrop").show();
        }

        function SaveSettings()
        {
            currentUser.Name = $("#SettingsName").val();
            currentUser.Email = $("#SettingsEmail").val();
            currentUser.Restaurant.Name = $("#SettingsRestaurant").val();

            Post("SaveUser", { userId: currentUser.Id, name: currentUser.Name, email: currentUser.Email, restaurantName: currentUser.Restaurant.Name });

            $(".myAccount a").html($("#SettingsName").val());
            $(".restaurantName").html($("#SettingsRestaurant").val());

            $(".settingsDialog").fadeOut();
            $(".modal-backdrop").fadeOut();
        }

        function SavePassword()
        {
            var success = function (error) {
                if (error)
                    $(".passwordError").html(error);
                else
                    $(".passwordDialog").fadeOut();
            };
            Post("SavePassword", { id: currentUserId, oldPassword: $("#OldPassword").val(), newPassword: $("#NewPassword").val() }, success);
        }

        function CancelSubscription()
        {
            var success = function (error) {
                if (error)
                    $(".cancelError").html(error);
                else {
                    MessageBox("Thank you for using Restaurant B Plan. Your subscription has been cancelled. You will no longer be charged.", 180, 400);
                    $(".cancelDialog").fadeOut();
                    $(".settingsDialog").fadeOut();
                }
            };
            Post("CancelSubscription", { userId: currentUserId }, success);
        }

        function OpenContact()
        {
            $(".contactError").html("");
            $(".contactDialog textarea").val("");
            $(".contactDialog").show();
            $(".modal-backdrop").show();
        }

        function SendContact()
        {
            SendEmail("Contact", $(".contactDialog textarea").val());

            $(".contactDialog .contactError").html("Thanks, your email has been sent.");
            setTimeout(function () {
                $(".contactDialog").fadeOut();
                $(".modal-backdrop").fadeOut();
            }, 1500);
        }

        function SendEmail(subject, body) {
            body += "%3Cbr/%3E%3Cbr/%3E" + new Date();
            Post("SendEmail", { userId: currentUserId, subject: subject, body: body });
        }

        function SignOut() {
            var success = function () {
                window.location.href = "/";
            };
            Post("SignOut", { }, success);
        }

    </script>
</head>
<body>
    <form id="form1" runat="server">
        <input type="hidden" runat="server" id="CurrentUserId" />
        <input type="hidden" runat="server" id="ProspectId" />
        <div class="modal-backdrop"></div>
        <div class="signup">
            <div class="signupHeader">
                Restaurant B Plan: Create Account
            </div>
            <input id="signupName" placeholder="Full Name" type="text" style="margin-top: 20px;" />
            <input id="signupEmail" placeholder="Email Address" type="text" />
            <input id="signupPassword" placeholder="Password" type="password" />
            <input id="signupConfirm" placeholder="Confirm Password" type="password" style="margin-bottom: 20px;" />
            <div class="signupBtn">Sign up</div>
        </div>
        <div class="createRestaurant">
            <div class="createRestaurantHeader">
                Welcome to Restaurant B Plan. Let's do this!
            </div>
            <div style="float:left;">
                <div style="font-size: 20px;margin: 26px 0 8px 50px;color: #676767;">Restaurant Name</div>
                <input id="createName" type="text" />
            </div>
            <div style="float:left;">
                <div style="font-size: 20px;margin: 26px 0 8px 50px;color: #676767;">What kind of food?</div>
                <input id="createFood" type="text" />
            </div>
            <div style="float:left;font-size: 20px;margin:26px 310px 10px;color: #676767;">Type of Restaurant</div>
            <div>
                <div class="shadowBox" style="margin-left:45px;">Fine Dining</div>
                <div class="shadowBox">Casual</div>
                <div class="shadowBox">Fast Casual</div>
                <div class="shadowBox">Trailer</div>
            </div>
<%--            <div style="float:left;font-size: 20px;margin:26px 310px 10px;color: #676767;">Size</div>
            <div style="float:left;font-size: 20px;margin:26px 0px 10px;">
                <div class="shadowBox active" style="margin-left:45px;">Intimate (less than 50 seats)</div>
                <div class="shadowBox">Average (50 - 150 seats)</div>
                <div class="shadowBox">Large (over 150 seats)</div>
            </div>--%>
            <div class="meals" style="float:left;width:385px;">
                <div style="font-size: 20px;margin: 30px 0 8px 50px;color: #676767;">What meals will you serve?</div>
                <div class="blueCheckBox" style="float: left;margin: 0 4px 0 51px;" val="Breakfast"></div><div style="float: left;">Breakfast</div>
                <div class="blueCheckBox checked" style="float: left;margin: 0 4px 0 24px;" val="Lunch"></div><div style="float: left;">Lunch</div>
                <div class="blueCheckBox checked" style="float: left;margin: 0 4px 0 24px;" val="Dinner"></div><div style="float: left;">Dinner</div>
            </div>
            <div class="drinks" style="float:left;">
                <div style="font-size: 20px;margin: 30px 0 8px 50px;color: #676767;">What about drinks?</div>
                <div class="blueCheckBox checked" style="float: left;margin: 0 4px 0 51px;" val="Liquor"></div><div style="float: left;">Liquor</div>
                <div class="blueCheckBox checked" style="float: left;margin: 0 4px 0 24px;" val="Beer"></div><div style="float: left;">Beer</div>
                <div class="blueCheckBox checked" style="float: left;margin: 0 4px 0 24px;" val="Wine"></div><div style="float: left;">Wine</div>

            </div>
            <div style="float:left;clear:left;">
                <div style="font-size: 20px;margin: 30px 0 8px 50px;color: #676767;">City</div>
                <input id="createCity" type="text" />
            </div>
            <div style="float:left;">
                <div style="font-size: 20px;margin: 30px 0 8px 50px;color: #676767;">Projected Opening Date</div>
                <input id="createOpening" type="text" />
            </div>

            <div class="createRestaurantBtn">Create Business Plan</div>
            <div class="creatingPlan" ><img src="../img/gear.gif" style="height: 120px;margin-right: -30px;" />
                <span>Generating Your Business Plan</span></div>
        </div>
        <div class="helpDialog modal-dialog">
            <div class="dialogClose">X</div>
            <h3></h3>
            <div class="dialogContent">
                You’re now one step closer to opening your first restaurant. This journey is hard, but we’ve made it as easy as possible.
                <br /><br />
                The purpose of Restaurant B Plan is to help you answer all the questions that are necessary to get funding and open your restaurant.  When you’re done answering the questions, you’ll have a complete business plan that you can take to investors to secure funding.
                <br /><br />
                Let’s start with your concept.
            </div>
            <div class="dialogFooter"></div>
        </div>
        <div class="settingsDialog modal-dialog" style="width: 420px;margin-left: -210px;">
            <div class="dialogClose">X</div>
            <h3>Account Settings</h3>
            <div class="dialogContent" style="overflow-y: auto;">
                <div class="dialogTitle">Name:</div><input type="text" id="SettingsName" />
                <div class="dialogTitle">Restaurant:</div><input type="text" id="SettingsRestaurant" />
                <div class="dialogTitle">Email:</div><input type="text" id="SettingsEmail" />
                <div class="dialogTitle">Password:</div><div class="btn" onclick="$('.passwordDialog').show();">Change Password</div>
<%--                <div class="dialogTitle">Subscription:</div><div class="btn" onclick="$('.cancelDialog').show();">Cancel Subscription</div>--%>
            </div>
            <div class="btn dialogBtn" onclick="SaveSettings();">Save</div>
        </div>
        <div class="passwordDialog">
            <div class="dialogClose" onclick="$('.passwordDialog').hide();">X</div>
            <h3>Change Password</h3>
            <div>Old Password:</div><input type="password" id="OldPassword" />
            <div>New Password:</div><input type="password" id="NewPassword" />
            <div class="passwordError error"></div>
            <div class="btn dialogBtn" style="margin: 12px 0px;" onclick="SavePassword();">Save</div>
        </div>
        <div class="cancelDialog">
            <div class="dialogClose" onclick="$('.cancelDialog').hide();">X</div>
            <div style="padding: 2em 1em 1em;">Are you sure you'd like to cancel your subscription to Restaurant B Plan?</div>
            <div class="cancelError error"></div>
            <div class="btn dialogBtn" style="margin: 0 0 0 12px;float: left;" onclick="CancelSubscription();">Yes</div>
            <div class="btn dialogBtn" style="margin: 0 12px 1.5em 0;" onclick="$('.cancelDialog').hide();">No</div>
        </div>
        <div class="contactDialog modal-dialog" style="  width: 420px;margin-left: -210px;">
            <div class="dialogClose" onclick="$('.contactDialog').hide();">X</div>
            <h3>How can we help?</h3>
            <textarea style="margin: 16px 46px;height: 135px;width: 331px;"></textarea>
            <div class="contactError" style="margin-left: 42px;float: left;"></div>
            <div class="btn dialogBtn" style="margin:0 42px 16px 0;" onclick="SendContact();">Send</div>
        </div>
        <div class="header">
            <div style="width:1000px;margin:0 auto;">
                <img src="../img/logoshadow.png" class="logo" />
                <div class="restaurantBPlan">Restaurant B Plan</div>
                <div class="myAccount"><a></a><img src="../img/downArrow.png" style="height:18px;" /><div><div class="arrowUp"></div><div><div onclick="OpenSettings();">Account Settings</div><div onclick="OpenContact();">Contact Us</div><div onclick="SignOut();">Sign Out</div></div></div></div>
            </div>
        </div>
        <div class="subheader">
            <div class="nav primary">
                <div class="active" style="margin-left:40px;">Get Started</div>
                <div>B Plan Explained</div>
                <div>Edit B Plan</div>
                <div>Extras</div>
                <div>Print</div>
                <div class="restaurantName"></div>
            </div>
        </div>
        <div class="main">
           <img class="scrollArrow left" style="float:left;" src="../img/leftArrow.png" />
           <div class="nav secondary">
               <div class="subheaderList">
                    <div class="active" style="margin-left:0;left:50px;"></div>
               </div>
            </div>
            <img class="scrollArrow right" style="float:right;" src="../img/rightArrow.png" />
            <div class="fromDb" style="margin:5%;">
                <div class="businessPlanContent">
                    <h2 style="text-align:center;margin-bottom:.5em;">Welcome to Restaurant B Plan</h2>
                    <div class="instructions" style="margin: 2em 1em;">
                        Instructions on how this we
                    </div>
                </div>
            </div>
            <div class="btnSection">
                <div class="backBtn btn" style="display:none;">Back</div>
                <div class="nextBtn btn">Next</div>
            </div>
        </div>
    </form>
</body>
</html>
