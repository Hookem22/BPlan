using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Plans_Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string price = "";
        if (Session["SessionVariableName"] != null)
        {
            price = Session["SessionVariableName"].ToString();
        }
        else
        {
            Random random = new Random();
            price = random.Next(0, 4).ToString();
            Session["SessionVariableName"] = price;
        }
        priceRnd.Value = price;
    }

    [WebMethod]
    public static void SendEmail(string subject, string body)
    {
        if (ConfigurationManager.AppSettings["IsProduction"] != "true")
            return;

        body = body.Replace("%20", " ").Replace("%3Cbr%3E", "<br/>").Replace("%3Cbr/%3E", "<br/>");

        Email email = new Email("RestaurantBPlan@RestaurantBPlan.com", "williamallenparks@gmail.com", subject, body);
        email.Send();
    }
}