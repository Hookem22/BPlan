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
                    $(".createRestaurant").animate({ "height": "235px", "top": "120px" }, 1500, function () {

                    });
                });

                var progressWidth = 0;
                var restaurantCreatedTimer = setInterval(function () {
                    progressWidth += 3;
                    $(".creatingPlan .progress-bar").css("width", progressWidth + "%");
                    if (isRestaurantCreated && progressWidth > 96) {
                        window.location.reload();
                    }
                }, 200);

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
                    isRestaurantCreated = true;
                };
                Post("CreateRestaurant", params, restaurantCreated);
            });

            $(".nav.primary div").not(".restaurantName").click(function () {
                if ($(this).hasClass("active"))
                    return;

                SaveAnswer();
                var currentScreen = $(".nav.primary div.active").html();
                $(this).siblings().removeClass("active");
                $(this).addClass("active");
                $(".nav.secondary .subheaderList div.active").css({ "border-color": "#0082c3", "color": "#1a384b" });
                $(".nav.secondary .subheaderList div").removeClass("active");

                $(".businessPlanContent").addClass("last");
                Get(currentScreen);
                /*
                populateSubs = setInterval(function () {
                    if (!$(".businessPlanContent").hasClass("last") && $(".printContent").length == 0) {
                        clearInterval(populateSubs);
                        PopulateSubheaders();
                    }
                }, 100);
                */
                setTimeout(PopulateSubheaders(), 100);
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

                var currentScreen = $(".subheaderList .active").html();
                $(this).siblings().removeClass("active");
                $(this).addClass("active");

                Get(currentScreen);
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
                if(left <= -759)
                    left = leftClick ? -420 : -759;
                else if (left <= -420)
                    left = leftClick ? 25 : -759;
                else if(left <= 25)
                    left = leftClick ? 25 : -420;

                $(".subheaderList").animate({ left: left + "px" }, 350, function () { });

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

            $(".carousel").on("click", "a", function () {
                if ($(this).hasClass("active"))
                    return;

                SaveAnswer();
                var section = $(this).attr("data-original-title");
                for (var i = 0; i < Questions.length; i++) {
                    if (Questions[i].Section == section) {
                        currentQuestion = i;
                        break;
                    }
                }

                var that = this;
                $(".carousel a").each(function (i) {
                    if (this == that) {
                        PrevScreen();
                        return false;
                    }
                    else if ($(this).hasClass("active")) {
                        NextScreen();
                        return false;
                    }
                });
            });

        });

        function Get(currentScreen)
        {
            //if (currentScreen == "My Restaurant")
            //    SaveRestaurant();

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
                else if (header == "B Plan Explained") {

                    var html = $(".explained div").first().html();
                    if (currentScreen == "Get Started")
                        NextScreen(html);
                    else
                        PrevScreen(html);
                }
                else if (header == "Edit B Plan") {
                    currentQuestion = 0;
                    if (currentScreen == "Get Started" || currentScreen == "B Plan Explained")
                        NextScreen();
                    else
                        PrevScreen();
                }
                else if (header == "Print") {
                    PopulatePrint();
                }
            }
            else {
                if (header == "B Plan Explained") {
                    var next = false;
                    $(".subheaderList div").each(function (i) {
                        if ($(this).hasClass("active")) {
                            var html = $(".explained").eq(i).html();
                            if (next)
                                NextScreen(html);
                            else
                                PrevScreen(html);
                        }
                        if ($(this).html() == currentScreen) {
                            next = true;
                        }
                    });


                }
                else if (header == "Edit B Plan") {
                    for (var i = 0; i < Questions.length; i++) {
                        if (Questions[i].QuestionSheet.Name == category) {
                            currentQuestion = i;
                            break;
                        }
                    }
                    NextScreen();
                }
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
                $(".scrollArrow").hide();
                //$(".nav.secondary .subheaderList").css({ left: "50px" });

                $(".scrollArrow").hide();
                $(".nav.secondary .subheaderList").hide();
                $(".backBtn").hide();
                $(".nextBtn").show();
            }
            else if (header == "B Plan Explained")
            {
                //subheaders = ["Management Team", "Market Analysis", "Marketing Strategy", "Staffing", "Company Description", "Daily Operations", "Software and Controls", "Other Control Systems", "Inventory", "Accounting"];
                subheaders = ["Overview", "Sources & Uses of Cash", "Capital Budget", "5 Year Projections", "Income & Cash Flow", "Investment Returns", "Average Check Price", "Typical Week", "Hourly Labor", "Cash Flow Break Even"];
                $(".scrollArrow").show();
                $(".nav.secondary .subheaderList").css({ left: "25px" });

                $(".backBtn").show();
                $(".nextBtn").show();
            }
            else if (header == "Edit B Plan")
            {
                subheaders = ["Basic Info", "Capital Budget", "Sales Projection", "Hourly Labor", "Expenses", "Investment"];
                $(".scrollArrow").hide();
                $(".nav.secondary .subheaderList").css({ left: "50px" }).show();
                $(".backBtn").show();
                $(".nextBtn").show();
            }

            $(".nav.secondary .subheaderList").html("");
            for (var i = 0; i < subheaders.length; i++) {
                if (i == 0)
                    $(".nav.secondary .subheaderList").append($("<div>", { class: "active", style: "margin-left:0;left:0;", text: subheaders[i] }));
                else
                    $(".nav.secondary .subheaderList").append($("<div>", { text: subheaders[i] }));
            }

        }

        function PopulateContent(html)
        {
            $(".carousel").html("");
            if (html) {
                $(".fromDb").html(html);
                return;
            }

            if (!Questions) {
                $(".fromDb").html("");
                return;
            }

            //Summary - End of Questions
            if (Questions.length == currentQuestion) {
                var question = Questions[0];
                var html = "<div class='businessPlanContent'>";
                var header = $(".nav.secondary div.active").html();
                var para = question.Help;
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
            else if (Questions.length < currentQuestion) {
                $(".printHeaderBtn").trigger("click");
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

            UpdateCarousel(currentQuestion);
        }

        function UpdateCarousel(currentQuestion) {
            var pages = [];
            var currentPage = 0;
            for (var i = 0; i < Questions.length; i++) {
                var question = Questions[i];
                if (question.SheetId == Questions[currentQuestion].SheetId && (i == 0 || question.Page != Questions[i - 1].Page)) {
                    pages.push(question.Section);
                }
                if (i == currentQuestion) {
                    currentPage = pages.length;
                }
            }

            currentPage -= 1;
            var html = "";
            for (var i = 1; i < pages.length; i++) {
                if (i == currentPage)
                    html += "<a class='active' data-toggle='tooltip' title='" + pages[i] + "'></a>";
                else
                    html += "<a data-toggle='tooltip' title='" + pages[i] + "'></a>";
            }
            $(".carousel").html(html);
            $(".carousel").css("margin-left", 375 - (12 * (pages.length - 1)) + "px");
            $('[data-toggle="tooltip"]').tooltip();
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
            if ($(".nav.primary .active").html() == "B Plan Explained") {
                for (var i = 0; i < $(".subheaderList div").length; i++) {
                    if ($(".subheaderList div").eq(i + 1).hasClass("active")) {
                        $(".subheaderList div").eq(i).trigger("click");
                        return;
                    }
                }
            }
            else {

                SaveAnswer();
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
        }

        function NextClicked()
        {
            var header = $(".nav.primary .active").html();
            if (header == "Get Started") {
                $(".nav.primary div").each(function () {
                    if ($(this).html() == "B Plan Explained") {
                        $(this).trigger("click");
                    }
                });
            }
            else if (header == "B Plan Explained") {
                var next = false;
                $(".subheaderList div").each(function () {
                    if (next) {
                        $(this).trigger("click");
                        return false;
                    }
                    if ($(this).hasClass("active")) {
                        next = true;
                    }
                });
            }
            else {
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

        function NextScreen(html)
        {
            $(".main").animate({ "margin-left": "0" }, 200, function () {
                $(".main").fadeOut(100, function () {
                    PopulateContent(html);
                    var margin = ($(window).width() - 800) / 2;
                    $(".main").css("margin-left", margin + 100 + "px");
                    $(".main").fadeIn(100, function () {
                        $(".main").css("margin-left", "auto");
                        $("#AnswerControl").focus();
                    });
                });
            });
        }

        function PrevScreen(html) {
            var margin = ($(window).width() - 800) / 2;
            $(".main").animate({ "margin-left": margin + 100 + "px" }, 200, function () {
                $(".main").fadeOut(100, function () {
                    PopulateContent(html);
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
            if ($(".nav.primary .active").html() != "Edit B Plan" ||
                !Questions || !Questions[currentQuestion] || Questions[currentQuestion].Id < 0) {
                return;
            }

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
            }
            else {

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
                <span>Generating Your Business Plan</span>
                <div class="progress" style="margin: 3px 124px 21px 30px;">
                    <div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width:5%">
                    </div>
              </div>
            </div>
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
                <div class="printHeaderBtn">Print</div>
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
                <div class="carousel"></div>
                <div class="nextBtn btn">Next</div>
            </div>
        </div>

       <div class="explained">
         <div class="explainedContent">
           <h2 style="text-align:center;margin-bottom:.5em;">Financials Overview</h2>
           <div class="instructions" style="margin: 2em 1em;">
               <p>For potential investors and lenders, the Financials are often viewed as the heart of the business
                plan and this section will get a lot of attention and even scrutiny from potential lender and
                investors. This is where they have the opportunity to evaluate the financial viability of the venture
                and – all important – gain a sense of the risk and return on investment potential the venture is
                likely to offer.</p><p>
                Some of the main concerns or issues any investor will want to learn from the Financials section
                include:</p><ul>
                    <li>How much startup capital will the venture require and where it will come from.</li>
                    <li>How profitable is the restaurant likely to be.</li>
                    <li>When can the investor(s) expect to get their investment back.</li>
                    <li>What kind of ROI is this investment likely to generate.</li>
                 </ul><br />
                <p>Even though you may have years of hospitality experience and are an expert at operating a
                restaurant, lenders and investors want to know you understand the financial side of the business
                as well. Showing knowledge of the numbers lets them know you see the big picture and are
                capable of not only running a restaurant but you also possess the skills to build a successful
                business as well.</p><p>
                Even though you may not have a financial background, you’ll need to understand the numbers on
                the various schedules and statements that make up the Financial Projections section and be
                prepared to answer questions about the assumptions used to create them. Don’t be concerned or
                intimidated. As you’ll soon see, the Financials are basically just common sense and we’ve
                designed this section to be very straightforward and easy to understand. You, as well as those
                who read your business plan, should quickly gain a clear picture of the financial aspects of your
                venture if you follow this format. </p>
           </div>
       </div>
     </div>
     <div class="explained">
         <div class="explainedContent">
           <h2 style="text-align:center;margin-bottom:.5em;">Projected Sources & Uses of Cash</h2>
           <div class="instructions" style="margin: 2em 1em;">
               <p>The Projected Sources & Uses of Cash shows the total amount of funding required to
                    finance the startup and opening of the restaurant, where the funds are expect to come
                    from and how these funds will be spent.</p>
               <img src="../img/screen1.png" style="margin: 12px 0 0 75px;" />
           </div>
       </div>
     </div>
     <div class="explained">
         <div class="explainedContent">
           <h2 style="text-align:center;margin-bottom:.5em;">Capital Budget</h2>
           <div class="instructions" style="margin: 2em 1em;">
               <p>The Capital Budget is a detailed schedule showing all the various expenditures,
                construction, startup and pre-opening costs required to get the restaurant open for
                business. Adequately identifying and estimating the costs of the project at this stage is
                absolutely crucial. Many restaurant experts claim the number one reason for restaurant
                failure is undercapitalization, i.e. running out of startup capital before operating activities
                have a chance to generate an adequate cash flow to sustain the business. Don’t place your
                restaurant (and future) in jeopardy by not having enough capital to complete your project
                according to plan or start out in a big financial hole.
                Here are the major categories of the Capital Budget:</p>
                <h3>Land & Building</h3>
                <p>If the owner/operating entity is planning on owning the land and building(versus leasing
                a facility), the actual or estimated cost of the land and building should be included here.
                Also include any related acquisition costs such as closing costs, sales commissions,
                finder’s fees, etc.</p>
                <h3>Leasehold Improvements</h3>
                <p>In a leased facility, enter the estimated cost of constructing the leasehold improvements
                less any landlord contributions. Leasehold improvements will include the cost of
                demolition (if any), construction of walls, ceilings, electrical, plumbing, HVAC, fixtures,
                flooring and any other hard costs associated with the interior and exterior structural and
                mechanical components of the building. Also enter any landlord allowance or
                contribution for the construction of the leasehold improvements as this will reduce the
                eventual cost of the leasehold improvements.</p>
                <h3>Bar/Kitchen Equipment</h3>
                <p>Based on your menu, prepare a detailed list of the bar and kitchen equipment you’ll need.
                Obtain actual bids and be sure to consider the cost of delivery, installation and setup. If
                possible, reference a detail of the bar and kitchen equipment and place it in the Appendix
                of our business plan.</p>
                <h3>Bar/Dining Room Furniture</h3>
                <p>If possible, reference a detail of the Bar/Dining Room Furniture and place it in the
                Appendix. Obtain actual bids and be sure to consider the cost of delivery, installation and
                setup.</p>
                <h3>Professional Services</h3>
                <p>This section includes cost such as architectural, engineering, design, legal, accounting
                and other professionals and consultants whose services will be used. Obtain cost
                estimates from these professions based on the scope of services you plan on having them
                perform.</p> 
                <h3>Organizational & Development</h3>
                <p>variety of costs are placed in this category including deposits on utilities, sales tax and
                lease, permits & licenses, menus and other similar costs. Obtain cost estimates from
                suppliers or other authoritative sources.</p>
                <h3>Interior Finishes & Equipment</h3>
                <p>This section includes interior items such as kitchen smallwares, artwork, décor, sound
                system, POS and other similar items. Obtain cost estimates from suppliers or other
                authoritative sources.</p>
                <h3>Exterior Finishes & Equipment</h3>
                <p>Items such as landscaping, exterior sign, parking lot and other similar costs are included
                in this category. Obtain cost estimates from suppliers or other authoritative sources.</p>
                <h3>Pre-Opening Expenses</h3>
                <p>Pre-opening expenses are standard restaurant operating expenses that are incurred prior to
                opening. Included are costs such as food, beverage and supplies inventory needed for
                menu development, training and opening as well as utilities, interest expense, uniforms,
                marketing and payroll costs of management and staff.</p>
                <p>It’s common to hire the chef or other management personnel from 1 to 2 months before
                opening, depending on the need for their involvement in the development and startup
                activities. Hourly staff normally begins training 1 to 2 weeks before opening.</p>
                <h3>Working Capital & Contingency</h3>
                <p>Very few restaurants are profitable during the first few months of operation. Some
                restaurants that are quite successful today took a year or more to reach profitability. Some
                provision should be made in the Capital Budget for working capital to cover possible
                operating deficits after opening. It’s quite rare to open up a new independent restaurant
                and start out making a profit in the first month of operation.</p>
                <p>It is also important to have a contingency built into the Capital Budget for change orders
                and cost overruns. There will always be surprises and unplanned costs when opening a
                restaurant. Cover yourself by having a contingency equal to at least 5% to 10% of the
                total project cost.</p> 
           </div>
       </div>
     </div>
     <div class="explained">
         <div class="explainedContent">
           <h2 style="text-align:center;margin-bottom:.5em;">5 Year Operating Projections</h2>
           <div class="instructions" style="margin: 2em 1em;">
               <p>The 5 Year Operating Projections begins in year one with the numbers from the Income and Cash Flow. 
                Years 2-5 are derived from the projected changes in sales
                and expense levels of the prior year. In the Investment Section of Edit B Plan, 
                enter your assumptions regarding year to year
                changes in each both sales and costs. </p>
               <img src="../img/screen19.png" style="margin: 12px 0 0 75px;" />
           </div>
       </div>
     </div>
     <div class="explained">
         <div class="explainedContent">
           <h2 style="text-align:center;margin-bottom:.5em;">Income & Cash Flow</h2>
           <div class="instructions" style="margin: 2em 1em;">
            <p>The Summary and Detailed Operating Projections are automatically generated from the Sales Projection, Hourly
            Labor Projection and Expenses sections. This statement shows the results of a
            typical month by dividing the annual projection by 12.</p>
            <p>The key ratios on this statement are PRIME COST and CONTROLLABLE PROFIT and of
            course NET INCOME BEFORE TAXES. In a tableservice restaurant, the goal is to have a prime
            cost of 65% or less. Controllable Profit should be at least 15% with a goal of hitting 20% or more.
            The National Restaurant Association has claimed for years that the average independent
            restaurant has a Net Income Before Taxes of around 5% of sales. There are many independent
            restaurants that do much better than what this “average” would suggest. </p>
            <img src="../img/screen13.png" style="margin: 12px 0 16px 75px;" />
            <p>Sales per square foot and per seat are important as they relate to industry averages and point
            toward profit potential. In most instances where Occupancy Costs and other operating
            expenses are in line with industry averages, restaurants that generate over $400 annual sales
            per square foot and $10,000 annual sales per seat have the potential to generate at least
            moderate profitability.</p>
            <p>The sales to investment ratio is an important indicator of potential success or failure. The
            higher the projected level of sales compared to the total startup costs (Capital Budget), the
            greater potential the venture has for success. If the restaurant is leased, many restaurant
            professionals believe the sales to investment ratio should be at least 1.5 to 1.0.</p>
            <img src="../img/screen18.png" style="margin: 0px 0 0 75px;" />
           </div>
       </div>
      </div>
       <div class="explained">
         <div class="explainedContent">
           <h2 style="text-align:center;margin-bottom:.5em;">Projected Investment Returns</h2>
           <div class="instructions" style="margin: 2em 1em;">
                <p>Based on your operating and investment assumptions the app will calculate the
                Payback Period of the investment partner’s initial equity contribution as well as the investment
                partner’s Return on Investment by year. </p>
                <p>The Payback Period is important because is tells a potential investor when they can expect to
                recoup the money they invested in the venture. It is common for investors in startup independent
                restaurants to look for a payback period of 2-3 years. This is why the investment partner(s) often
                receives a disproportionate share of the cash flow until payback is achieved. </p>
                <p>Investment on this statement do not account for the affect of State and Federal Income Taxes.
                Potential investors may wish to have their accountants calculate the impact of such taxes on the
                projected returns. </p>
               <img src="../img/screen17.png" style="margin: 12px 0 0 75px;" />
           </div>
       </div>
      </div>
      <div class="explained">
         <div class="explainedContent">
           <h2 style="text-align:center;margin-bottom:.5em;">Average Check Price</h2>
           <div class="instructions" style="margin: 2em 1em;">
                <p>Projecting a realistic and achievable sales volume is at the heart of every restaurant
                business plan. Nearly all of the restaurant’s expenses, as well as the profit, cash flow and
                return on investment are impacted directly by sales volume.</p>
                <p>To estimate sales volume in a to-be-developed restaurant, both the average check per
                guest and guest counts by meal period should be objectively analyzed and projected. </p>
               <img src="../img/screen3.png" style="margin: 12px 0 16px 75px;" />
                <p>In the above case, for the dinner meal period, the average price of an entrée is assumed to
                be $14.50 and every customer (100%) will order one. The average price of an appetizer is
                $12.00 with 20% of the guests ordering one.</p>
                <p>Average beverage sales per guest are arrived at by estimating the average selling price of
                each beverage type, and assuming what percent of guests will select each type. For example, the average liquor drink is priced at
                $7.50, and 10% of the quests will order a liquor drink.</p>
                <p>In the above example, the average check at dinner for this restaurant is estimated to be
                $23.10, $18.90 in food and $4.20 in beverages. </p>
           </div>
       </div>
     </div>
      <div class="explained">
         <div class="explainedContent">
           <h2 style="text-align:center;margin-bottom:.5em;">Typical Week</h2>
           <div class="instructions" style="margin: 2em 1em;">
                <p>In most restaurants the number of guests served can vary dramatically by meal period and
                day of the week. For example, many restaurants do as much as 50% or more of their
                weekly sales on Friday and Saturday. This makes it important to consider expected guest
                activity for every meal period in a typical week.</p>
                <p>To get a sense of the level of business that can be expected it helps to become very
                familiar with what kind of customer activity existing restaurants are experiencing in your
                immediate market area. Spend some time in these restaurants and through observation
                and casual discussions with employees and even managers, inquire about their busy and
                slow times. Ask about how many table turns they do on different days of the week. Are
                sales trending higher than last year or are they slower than they were last year. If you’re
                tactful and friendly it’s often amazing what information they’ll share.</p>
                <p>Go to the Edit B Plan section. For a typical week, enter the
                expected table turns for each meal period. The app will automatically calculate the
                number of guests and sales per meal period, day and week based on the average check
                assumptions you entered. These numbers become
                the basis for sales volume on the operating statements. </p>
               <img src="../img/screen11.png" style="margin: 12px 0 0px 75px;" />
           </div>
       </div>
     </div>
      <div class="explained">
         <div class="explainedContent">
           <h2 style="text-align:center;margin-bottom:.5em;">Hourly Labor</h2>
           <div class="instructions" style="margin: 2em 1em;">
                <p>Hourly labor cost is one of the largest expenses in any restaurant. Don’t just assume that
                your hourly labor cost will be XX% of sales just because of what other restaurants are
                doing. There are many variables that effect hourly labor and they can be different even in
                what may appear to be very similar restaurant operations. Take the time to project your
                labor cost by position for each meal period in a typical week based on the level of
                business activity you actually expect.</p>
                <p>The Hourly Labor section allows you to list and assign average hourly
                wage rates to each position in the kitchen and dining room. Then, while taking into
                consideration each meal period’s covers (number of meals served) and sales volume,
                estimate the hours and number of employees needed in each position to adequately staff
                the restaurant.</p>
                <p>As a general rule for tableservice restaurants, the goal is to keep hourly labor (gross
                payroll) at or below 18%-20% of sales. Hourly labor cost on busy nights can be as low as
                11%-12% of sales, whereas on slow nights, it can be as high 22%-25%. The goal for the
                week, however, in most cases would be to shoot for an hourly labor cost of 18% or less.</p>
               <img src="../img/screen12.png" style="margin: 12px 0 0px 0px;" />
           </div>
       </div>
     </div>
      <div class="explained">
         <div class="explainedContent">
           <h2 style="text-align:center;margin-bottom:.5em;">Cash Flow Break Even</h2>
           <div class="instructions" style="margin: 2em 1em;">
                <p>You can pretty much count on any potential investor or lender to ask the following question,
                “What level of sales do you need to cover all your expenses?” By doing a break-even analysis you
                can not only give them an answer but show them exactly how the number was arrived at.</p>
                <p>The break-even section uses numbers on the Expenses section to
                separate the various costs into being either a “fixed” or “variable”. While break-even is not an
                exact science, you should get very close to an accurate break-even sales volume by following our
                methodology described below.</p>
                <h3>Fixed Costs</h3>
                <p>Fixed costs or expenses are those that do not change or change very slightly with variations in
                sales volume. Examples of fixed costs include management salaries, equipment rental and base
                rent. Other costs, while not 100% fixed, do not change significantly when sales go up or down.
                These types of fixed costs include utilities, most direct operating expenses and marketing
                expenses. </p>
               <img src="../img/screen14.png" style="margin: 12px 0 16px 59px;" />
               <h3>Variable Costs</h3>
               <p>Variable costs change in direct proportion to sales volume. For example, costs of sales, credit card
               expenses and percentage rent, if applicable, are variable costs. </p>               <img src="../img/screen15.png" style="margin: 12px 0 16px 59px;" />
               <p>The app automatically pulls the individual variable costs out of Employee Benefits (payroll
               taxes on variable portion of Hourly Labor), credit card expenses out of Administrative & General
               and paper supplies out of Direct Operating Expenses. </p>
               <h3>Cash Flow Break-Even</h3>
               <p>Based on the amount of total fixed costs and the variable cost %, the cash flow break-even sales
               volume is automatically calculated and shown an annually, monthly and weekly. </p>
               <img src="../img/screen16.png" style="margin: 12px 0 0px 59px;" />
           </div>
       </div>
     </div>
    </form>
</body>
</html>
