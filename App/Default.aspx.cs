using OfficeOpenXml;
using Stripe;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class App_Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Users user = HttpContext.Current.Session["CurrentUser"] as Users;
        if (user == null || user.Id == 0)
        {
            Prospect prospect = HttpContext.Current.Session["CurrentProspect"] as Prospect;
            if (prospect != null)
                ProspectId.Value = prospect.Id.ToString();
            else if (ConfigurationManager.AppSettings["IsProduction"] == "true")
                Response.Redirect("http://RestaurantBPlan.com");
            else
                CurrentUserId.Value = "2";
        }
        else
        {
            CurrentUserId.Value = user.Id.ToString();
        }
        //ProspectId.Value = "1017";
        CurrentUserId.Value = "3060";

        //UserName.Value = user.Name;
        //TimeSpan span = DateTime.Now - user.Joined;
        //if (span.Days <= 0)
        //    NewUser.Value = "true";

        //List<Restaurant> restaurants = Restaurant.LoadByPropName("UserId", user.Id.ToString());
        //if (restaurants.Count > 0)
        //    RestaurantName.Value = restaurants[0].Name;

        //List<Question> questions = Question.Get("Concept", "Create Your Concept", 1);
        //if(questions.Count > 0)
        //{
        //    ConceptOverview.Value = questions[0].Title;
        //}
    }

    [WebMethod]
    public static Prospect GetProspect(string prospectId)
    {
        int id;
        if (int.TryParse(prospectId, out id))
        {
            return Prospect.LoadById(id);
        }
        return new Prospect();
    }

    [WebMethod]
    public static Users GetUser(string userId)
    {
        int id;
        if(int.TryParse(userId, out id))
        {
            Users user = Users.LoadById(id);
            user.Restaurant = Restaurant.LoadByUserId(user.Id);
            return user;
        }
        return new Users();
    }

    [WebMethod]
    public static List<Question> GetQuestions(string restaurantId)
    {
        int id;
        if (int.TryParse(restaurantId, out id))
        {
            return Question.GetFinancials(id);
        }
        return new List<Question>();
    }

    [WebMethod]
    public static Users CreateUser(Users user, int prospectId)
    {
        user.Joined = DateTime.Now;
        user.Save();

        Prospect prospect = Prospect.LoadById(prospectId);

        Restaurant restaurant = new Restaurant();
        restaurant.UserId = user.Id;
        restaurant.Name = prospect.Restaurant;
        restaurant.Food = prospect.Food;
        restaurant.RestaurantType = prospect.RestaurantType;
        switch (prospect.Size)
        {
            case "Intimate":
                restaurant.Size = 50;
                break;
            case "Average":
                restaurant.Size = 100;
                break;
            case "Large":
                restaurant.Size = 150;
                break;
        }
        restaurant.SquareFootage = restaurant.Size * 15;
        restaurant.City = prospect.City;
        restaurant.Opening = prospect.Opening;
        restaurant.Save();

        user.Restaurant = restaurant;

        string body = string.Format("UserId: {0}<br>Name: {1}<br>Email: {2}<br><br>{3}", user.Id, user.Name, user.Email, restaurant.Name);
        Email email = new Email("RestaurantBPlan@RestaurantBPlan.com", "williamallenparks@gmail.com", "New Sign Up", body);
        email.Send();

        HttpContext.Current.Session["CurrentUser"] = user;
        HttpContext.Current.Session["CurrentProspect"] = null;

        return user;
    }

    [WebMethod]
    public static void SaveUser(string userId, string name, string email, string restaurantName)
    {
        int id;
        if (int.TryParse(userId, out id))
        {
            Users user = Users.LoadById(id);
            user.Name = name;
            user.Email = email;
            user.Save();

            Restaurant restaurant = Restaurant.LoadByUserId(user.Id);
            restaurant.Name = restaurantName;
            restaurant.Save();
        }
    }

    [WebMethod]
    public static Restaurant CreateRestaurant(int userId, string name, string food, string restaurantType, int size, string city, string opening, string meals, string drinks)
    {
        Restaurant restaurant = new Restaurant();
        restaurant.UserId = userId;
        restaurant.Name = name;
        restaurant.Food = food;
        restaurant.RestaurantType = restaurantType;
        restaurant.Size = size;
        restaurant.SquareFootage = size * 15;
        restaurant.City = city;
        restaurant.Opening = opening;
        restaurant.Save();

        Answer.CreateAnswersFromTemplate(restaurant, meals, drinks);

        Users user = Users.LoadById(restaurant.UserId);

        if (ConfigurationManager.AppSettings["IsProduction"] == "true")
        {
            string body = string.Format("UserId: {0}<br>Name: {1}<br>Email: {2}<br><br>{3}", user.Id, user.Name, user.Email, restaurant.Name);
            Email email = new Email("RestaurantBPlan@RestaurantBPlan.com", "williamallenparks@gmail.com", "New Sign Up", body);
            email.Send();
        }
        HttpContext.Current.Session["CurrentUser"] = user;
        HttpContext.Current.Session["CurrentProspect"] = null;

        return restaurant;
    }


    [WebMethod]
    public static void SaveRestaurant(Restaurant restaurant)
    {
        restaurant.Save();
    }


    [WebMethod]
    public static string SavePassword(string id, string oldPassword, string newPassword)
    {
        int userId;
        if (int.TryParse(id, out userId))
        {
            Users user = Users.LoadById(userId);
            if (user.Password != oldPassword)
                return "Your old password is not correct";

            user.Password = newPassword;
            user.Save();
        }
        return "";
    }

    [WebMethod]
    public static int SaveAnswer(Answer answer)
    {
        answer.Save();
        return answer.Id;
    }

    [WebMethod]
    public static List<Answer> SaveAnswers(List<Answer> answers)
    {
        foreach(Answer answer in answers)
            answer.Save();

        return answers;
    }

    [WebMethod]
    public static string CancelSubscription(int userId)
    {
        Users user = Users.LoadById(userId);
        try
        {
            var subscriptionService = new StripeSubscriptionService();
            foreach (StripeSubscription subscription in subscriptionService.List(user.StripeCustomerId))
            {
                user.Ended = subscription.PeriodEnd;
                user.Cancelled = true;
                user.Save();

                subscriptionService.Cancel(user.StripeCustomerId, subscription.Id);
            }
        }
        catch(Exception ex)
        {
            return "Error: " + ex.Message;
        }
        return "";
    }

    [WebMethod]
    public static void SendEmail(int userId, string subject, string body)
    {
        if (userId > 0)
        {
            Users user = Users.LoadById(userId);
            body = string.Format("UserId: {0}<br>Name: {1}<br>Email: {2}<br><br>{3}", user.Id, user.Name, user.Email, body);
        }
        //body = body.Replace("%20", " ").Replace("%3Cbr%3E", "<br/>").Replace("%3Cbr/%3E", "<br/>");
        //Email email1 = new Email("RestaurantBPlan@RestaurantBPlan.com", "myownerbox@gmail.com", "App Contact", body);
        //email1.Send();
        Email email2 = new Email("RestaurantBPlan@RestaurantBPlan.com", "williamallenparks@gmail.com", subject, body);
        email2.Send();
    }

    [WebMethod]
    public static void SignOut()
    {
        HttpContext.Current.Session["CurrentUser"] = null;
    }


}