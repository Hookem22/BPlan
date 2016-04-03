using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class HowItWorks_Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (ConfigurationManager.AppSettings["IsProduction"] != "true")
            return;

        Email email = new Email("RestaurantBPlan@RestaurantBPlan.com", "williamallenparks@gmail.com", "Visited How it Works Page", "");
        email.Send();
    }
}