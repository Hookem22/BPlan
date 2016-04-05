using Stripe;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod]
    public static string CreateUser(Users user, string restaurantName)
    {
        try
        {
            user.Joined = DateTime.Now;
            user.Save();
            Restaurant restaurant = new Restaurant() { Name = restaurantName, UserId = user.Id };
            restaurant.Save();

            HttpContext.Current.Session["CurrentUser"] = user;

            if (ConfigurationManager.AppSettings["IsProduction"] == "true")
            {
                //string body = "New Sign Up";
                //body += string.Format("<br/>Name: {0}<br/>Email: {1}", user.Name, user.Email);
                ////Email email1 = new Email("RestaurantBPlan@RestaurantBPlan.com", "RestaurantBPlan@gmail.com", "New Sign Up", body);
                ////email1.Send();
                //Email email2 = new Email("RestaurantBPlan@RestaurantBPlan.com", "williamallenparks@gmail.com", "New Sign Up", body);
                //email2.Send();
            }
        }
        catch (Exception ex)
        {
            ////Email email1 = new Email("RestaurantBPlan@RestaurantBPlan.com", "RestaurantBPlan@gmail.com", "Sign Up Error", ex.Message);
            ////email1.Send();
            //Email email2 = new Email("RestaurantBPlan@RestaurantBPlan.com", "williamallenparks@gmail.com", "Sign Up Error", ex.Message);
            //email2.Send();
        }

        return "";
        
        
        
        //string error = BuyPlan(user);
        //if(string.IsNullOrEmpty(error))
        //{
        //    user.Joined = DateTime.Now;
        //    user.Save();
        //    Restaurant restaurant = new Restaurant() { Name = restaurantName, UserId = user.Id };
        //    restaurant.Save();

        //    HttpContext.Current.Session["CurrentUser"] = user;

        //    if (ConfigurationManager.AppSettings["IsProduction"] == "true")
        //    {
        //        string body = user.Annual ? "Purchase: Annual" : "Purchase: Monthly";
        //        body += string.Format("<br/>Name: {0}<br/>Email: {1}", user.Name, user.Email);
        //        //Email email1 = new Email("RestaurantBPlan@RestaurantBPlan.com", "RestaurantBPlan@gmail.com", "New Purchase", body);
        //        //email1.Send();
        //        Email email2 = new Email("RestaurantBPlan@RestaurantBPlan.com", "williamallenparks@gmail.com", "New Purchase", body);
        //        email2.Send();
        //    }
        //    return "";
        //}
        //return error;
    }

    static string BuyPlan(Users user)
    {
        try
        {
            var myCharge = new StripeChargeCreateOptions();

            // always set these properties
            int price = 0;
            int.TryParse(user.CreditCard.Price, out price);
            myCharge.Amount = price * 100;
            myCharge.Currency = "usd";

            // set this if you want to
            myCharge.Description = user.Name + ", " + user.Email;

            // set this property if using a token
            //myCharge.TokenId = *tokenId*;

            // set these properties if passing full card details
            // (do not set these properties if you have set a TokenId)
            myCharge.Card = new StripeCreditCardOptions();
            myCharge.Card.CardNumber = user.CreditCard.CardNumber;
            myCharge.Card.CardExpirationYear = user.CreditCard.CardExpirationYear;
            myCharge.Card.CardExpirationMonth = user.CreditCard.CardExpirationMonth;
            //myCharge.CardAddressCountry = "US";               // optional
            //myCharge.CardAddressLine1 = "24 Beef Flank St";   // optional
            //myCharge.CardAddressLine2 = "Apt 24";             // optional
            //myCharge.CardAddressState = "NC";                 // optional
            //myCharge.CardAddressZip = "27617";                // optional
            myCharge.Card.CardName = user.Name;                    // optional
            myCharge.Card.CardCvc = user.CreditCard.Cvc;       // optional

            // set this property if using a customer
            //myCharge.CustomerId = *customerId*;

            // if using a customer, you may also set this property to charge
            // a card other than the customer's default card
            //myCharge.Card = *cardId*;

            // set this if you have your own application fees (you must have your application configured first within Stripe)
            //myCharge.ApplicationFee = 25;

            // (not required) set this to false if you don't want to capture the charge yet - requires you call capture later
            myCharge.Capture = true;

            var chargeService = new StripeChargeService();

            StripeCharge stripeCharge = chargeService.Create(myCharge);
        }
        catch (Exception ex)
        {
            ////Email email1 = new Email("RestaurantBPlan@RestaurantBPlan.com", "RestaurantBPlan@gmail.com", "Stripe Error", ex.Message);
            ////email1.Send();
            //Email email2 = new Email("RestaurantBPlan@RestaurantBPlan.com", "williamallenparks@gmail.com", "Stripe Error", ex.Message);
            //email2.Send();

            //return "Error: " + ex.Message;
        }

        return "";



        //var myCustomer = new StripeCustomerCreateOptions();

        //// set these properties if it makes you happy
        //myCustomer.Email = user.Email;
        //myCustomer.Description = user.Name;

        //// setting up the card
        //myCustomer.Card = new StripeCreditCardOptions()
        //{
        //    CardNumber = user.CreditCard.CardNumber,
        //    CardExpirationYear = "20" + user.CreditCard.CardExpirationYear,
        //    CardExpirationMonth = user.CreditCard.CardExpirationMonth,
        //    //CardAddressCountry = "US",                // optional
        //    //CardAddressLine1 = "24 Beef Flank St",    // optional
        //    //CardAddressLine2 = "Apt 24",              // optional
        //    //CardAddressCity = "Biggie Smalls",        // optional
        //    //CardAddressState = "NC",                  // optional
        //    //CardAddressZip = "27617",                 // optional
        //    CardName = user.Name,                       // optional
        //    CardCvc = user.CreditCard.Cvc               // optional
        //};

        ////myCustomer.PlanId = planId;                          // only if you have a plan
        ////myCustomer.TaxPercent = 20;                            // only if you are passing a plan, this tax percent will be added to the price.
        ////myCustomer.Coupon = *couponId*;                        // only if you have a coupon
        ////myCustomer.TrialEnd = DateTime.UtcNow.AddMonths(1);    // when the customers trial ends (overrides the plan if applicable)
        ////myCustomer.Quantity = 1;                               // optional, defaults to 1

        //var customerService = new StripeCustomerService();
        //try
        //{
        //    StripeCustomer stripeCustomer = customerService.Create(myCustomer);
        //    var subscriptionService = new StripeSubscriptionService();

        //    string planId = "RestaurantBPlan";
        //    if(user.Annual)
        //    {
        //        int price = 0;
        //        int.TryParse(user.CreditCard.Price, out price);
        //        planId += ((price / 2) * 12).ToString() + "Year";
        //    }
        //    else
        //    {
        //        planId += user.CreditCard.Price + "Month";
        //    }
        //    StripeSubscription stripeSubscription = subscriptionService.Create(stripeCustomer.Id, planId);
        //    user.StripeCustomerId = stripeCustomer.Id;
        //}
        //catch (Exception ex)
        //{
        //    //Email email1 = new Email("RestaurantBPlan@RestaurantBPlan.com", "RestaurantBPlan@gmail.com", "Stripe Error", ex.Message);
        //    //email1.Send();
        //    Email email2 = new Email("RestaurantBPlan@RestaurantBPlan.com", "williamallenparks@gmail.com", "Stripe Error", ex.Message);
        //    email2.Send();

        //    return "Error: " + ex.Message;
        //}

        //return "";
    }

    [WebMethod]
    public static string Login(string email, string password)
    {
        List<Users> users = Users.LoadByPropName("Email", email);
        if (users.Count == 0 || users[0].Id == 0 || users[0].Password != password)
            return "Incorrect email or password";

        if (users[0].Cancelled && users[0].Ended < DateTime.Now)
            return "This subscription has been cancelled";

        HttpContext.Current.Session["CurrentUser"] = users[0];
        return "";
    }

    [WebMethod]
    public static string SendPassword(string email)
    {
        List<Users> users = Users.LoadByPropName("Email", email);
        if (users.Count == 0 || users[0].Id == 0)
            return "We do not have that email on file.";

        string body = string.Format("Your password for RestaurantBPlan.com is: {0}<br/><br/>Thanks, <br/>Restaurant B Plan Team", users[0].Password);
        Email message = new Email("RestaurantBPlan@RestaurantBPlan.com", email, "Restaurant B Plan Password", body);
        message.Send();

        return "";
    }

    [WebMethod]
    public static Prospect CreateProspect()
    {
        //if (ConfigurationManager.AppSettings["IsProduction"] != "true")
        //    return new Prospect();

        Prospect prospect = new Prospect();
        prospect.Save();
        return prospect;
    }

    [WebMethod]
    public static void UpdateProspect(Prospect prospect)
    {
        //if (ConfigurationManager.AppSettings["IsProduction"] != "true")
        //    return;

        prospect.Save();
        HttpContext.Current.Session["CurrentProspect"] = prospect;

        if (!string.IsNullOrEmpty(prospect.Email))
        {
            Subscribe(prospect);
            prospect.EmailSent = 1;
            prospect.LastEmailSent = DateTime.Now;
            prospect.Save();
        }
            
    }

    [WebMethod]
    public static void SendEmail(string subject, string body)
    {
        if (ConfigurationManager.AppSettings["IsProduction"] != "true")
            return;

        body = body.Replace("%20", " ").Replace("%3Cbr%3E", "<br/>").Replace("%3Cbr/%3E", "<br/>");
        body = body.Replace("undefined<br/><br/><br/><br/>", "Request for Sign Up<br/><br/>");
        //Email email1 = new Email("RestaurantBPlan@RestaurantBPlan.com", "RestaurantBPlan@gmail.com", subject, body);
        //email1.Send();
        Email email2 = new Email("RestaurantBPlan@RestaurantBPlan.com", "williamallenparks@gmail.com", subject, body);
        email2.Send();

        //PotentialSummary(body);

    }

    [WebMethod]
    public static void SendNextEmail()
    {
        return;
        
        if (ConfigurationManager.AppSettings["IsProduction"] != "true")
            return;

        List<Prospect> prospects = Prospect.LoadAll().FindAll(delegate(Prospect p)
        {
            return p.EmailSent >= 1;
        });

        foreach (Prospect prospect in prospects)
        {
            if ((prospect.EmailSent == 1 && prospect.LastEmailSent < DateTime.Now.AddMinutes(-30)) || prospect.LastEmailSent < DateTime.Now.AddHours(-23))
            {           
                prospect.EmailSent++;
                prospect.LastEmailSent = DateTime.Now;
                prospect.Save();

                string subject = "";
                string body = "";
                switch(prospect.EmailSent)
                {
                    case 2:
                        {
                            if(!string.IsNullOrEmpty(prospect.Name) && !string.IsNullOrEmpty(prospect.Restaurant))
                            {
                                subject = string.Format("{0}, your business plan for {1}", prospect.Name, prospect.Restaurant);
                                body = sampleEmail.Replace("{Restaurant}", prospect.Restaurant);
                            }
                            else if (!string.IsNullOrEmpty(prospect.Restaurant))
                            {
                                subject = string.Format("Your business plan for {0}", prospect.Restaurant);
                                body = sampleEmail.Replace("{Restaurant}", prospect.Restaurant);
                            }
                            else if (!string.IsNullOrEmpty(prospect.Name))
                            {
                                subject = string.Format("{0}, your business plan from Restaurant BPlan", prospect.Name);
                                body = sampleEmail.Replace("{Restaurant}", "Your Restaurant");
                            }
                            else
                            {
                                subject = "Your business plan from Restaurant BPlan";
                                body = sampleEmail.Replace("{Restaurant}", "Your Restaurant");
                            }
                            break;
                        }
                    case 3:
                        {
                            if(!string.IsNullOrEmpty(prospect.Name))
                            {
                                subject = string.Format("{0}, how much does it cost to open a restaurant?", prospect.Name);
                                body = email3.Replace("{Restaurant}", prospect.Restaurant);
                            }
                            else
                            {
                                subject = "How much does it cost to open a restaurant?";
                                body = email3.Replace("{Restaurant}", "Your Restaurant");
                            }
                            break;
                        }
                    case 4:
                        {
                            if(!string.IsNullOrEmpty(prospect.Name))
                            {
                                subject = string.Format("{0}, don't make these 5 restaurant startup mistakes", prospect.Name);
                                body = email4.Replace("{Restaurant}", prospect.Restaurant);
                            }
                            else
                            {
                                subject = "Don't make these 5 restaurant startup mistakes";
                                body = email4.Replace("{Restaurant}", "Your Restaurant");
                            }
                            break;
                        }
                    case 5:
                        {
                            if (!string.IsNullOrEmpty(prospect.Name))
                            {
                                subject = string.Format("{0}, Get Started on Your Business Plan Today!", prospect.Name);
                                body = email5.Replace("{Restaurant}", prospect.Restaurant).Replace("{Name}", prospect.Name);
                            }
                            else
                            {
                                subject = "Get Started on Your Business Plan Today!";
                                body = email5.Replace("{Restaurant}", "Your Restaurant");
                            }
                            break;
                        }
                    case 6:
                        break;
                }

                if(!string.IsNullOrEmpty(subject))
                {
                    Email email = new Email("RestaurantBPlan@RestaurantBPlan.com", prospect.Email, subject, body);
                    email.Send();
                }
            }
        }

    }

    [WebMethod]
    public static void Subscribe(Prospect prospect)
    {
        if (ConfigurationManager.AppSettings["IsProduction"] != "true")
            return;

        string name = prospect.Name;
        string restaurantName = prospect.Restaurant;
        string email = prospect.Email;
        if (string.IsNullOrEmpty(name) || name.Contains('@'))
            name = "";
        if (!string.IsNullOrEmpty(name) && name.Contains(' '))
            name = name.Substring(0, name.IndexOf(' '));

        string subject = string.IsNullOrEmpty(name) ? "Let's get started" : name + ", Let's get started";
        if (!string.IsNullOrEmpty(restaurantName))
            subject += " with " + restaurantName;
        name = string.IsNullOrEmpty(name) ? "Hey" : "Hey " + name;
        string body = subscribeEmail.Replace("{Name}", name);

        Email subscribe = new Email("RestaurantBPlan@RestaurantBPlan.com", email, subject, body);
        subscribe.Send();
    }

    static void PotentialSummary(string body)
    {
        try
        {
            Users user;
            List<Users> users;
            if (body.Contains("Clicked Yes, I do"))
            {
                Random rand = new Random();
                user = new Users() { Id = rand.Next() };
                HttpContext.Current.Session["PotentialUserId"] = user.Id;
                users = HttpContext.Current.Cache.Get("PotentialUsers") as List<Users>;
                if (users == null)
                    users = new List<Users>();

                users.Add(user);
            }
            else
            {
                int userId = (int)HttpContext.Current.Session["PotentialUserId"];
                users = HttpContext.Current.Cache.Get("PotentialUsers") as List<Users>;
                user = users.Find(delegate(Users u)
                {
                    return u.Id == userId;
                });
                if(user == null)
                {
                    user = new Users() { Id = userId };
                }
            }

            user.Name = string.Format("{0}<br/><br/>{1}", user.Name, body);

            HttpContext.Current.Cache.Remove("PotentialUsers");
            HttpContext.Current.Cache.Insert("PotentialUsers", users);

            if (HttpContext.Current.Cache.Get("LastEmailSent") == null)
            {
                HttpContext.Current.Cache.Insert("LastEmailSent", DateTime.Now);
            }
            else
            {
                DateTime lastEmail = (DateTime)HttpContext.Current.Cache.Get("LastEmailSent");
                if (lastEmail.AddMinutes(30) < DateTime.Now)
                {
                    string summary = "All visitors in the last 30 minutes<br/><br/>";
                    foreach (Users u in users)
                    {
                        if(u.Id != user.Id)
                            summary += u.Name + "<br/><br/><br/><br/>";
                    }
                    //summary = summary.Replace("Price $45<br/><br/>", "").Replace("undefined<br/><br/>", "");

                    //Email email1 = new Email("RestaurantBPlan@RestaurantBPlan.com", "RestaurantBPlan@gmail.com", "Visitor Summary", summary);
                    //email1.Send();
                    Email email2 = new Email("RestaurantBPlan@RestaurantBPlan.com", "williamallenparks@gmail.com", "Visitor Summary", summary);
                    email2.Send();

                    users = users.FindAll(delegate(Users u)
                    {
                        return u.Id == user.Id;
                    });
                    HttpContext.Current.Cache.Remove("PotentialUsers");
                    HttpContext.Current.Cache.Insert("PotentialUsers", users);

                    HttpContext.Current.Cache.Remove("LastEmailSent");
                    HttpContext.Current.Cache.Insert("LastEmailSent", DateTime.Now);

                }
            }
        }
        catch(Exception ex)
        {
            Email error = new Email("RestaurantBPlan@RestaurantBPlan.com", "williamallenparks@gmail.com", "Summary error", ex.Message);
            error.Send();

            HttpContext.Current.Cache.Remove("PotentialUsers");
            HttpContext.Current.Cache.Remove("LastEmailSent");

            HttpContext.Current.Cache.Insert("PotentialUsers", new List<Users>());
            HttpContext.Current.Cache.Insert("LastEmailSent", DateTime.Now);
        }

    }

    //static string subscribeEmail = @"<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'><html xmlns='http://www.w3.org/1999/xhtml\'><head><meta content='text/html; charset=utf-8' http-equiv='Content-Type' /><meta name='viewport' content='width=device-width, initial-scale=1' /><title></title></head><body style='max-width:300px;color:#333'>A well-conceived, professional restaurant business plan is your greatest single asset for turning your restaurant dreams into reality. It's the key to convincing anyone to invest money, make a loan, lease space, essentially do business with you prior to opening.<br/><br/>Your restaurant business plan is also the roadmap for the future of your business. Not only does it provide direction, it requires you to consider all the pitfalls and opportunities of your prospective venture, well before you open the doors. Your business plan is the script of how your restaurant will look and function when it's done. In short, <strong>many restaurateurs say that having a sound business plan was the single most important ingredient in making their new business a reality.</strong><br/><br/>Here are some things to consider when thinking out your restaurant concept:<br/><br/><strong>Local market</strong><br/><ul style='margin:0;'><li>look for opportunities, concept gaps in your market</li><li>observe which restaurants are the busiest, try to determine why</li><li>create a short list of the most promising areas</li></ul><br/><strong>Menu</strong><br/><ul style='margin:0;'><li>look at price points of the most successful restaurants in your area</li><li>begin collecting menu and recipe ideas</li><li>what will make your restaurant unique in terms of menu, service, or ambiance</li></ul><br/><strong>Plan</strong><br/><ul style='margin:0;'><li>why should friends, family, or investors invest in your concept?</li><li>draft a concept statement fully describing your restaurant concept and a business plan to show how you will achieve it</li></ul><br/>In this course, professional restaurant consultants will guide you through the ins and outs of creating a powerful business plan that will attract investors. We will also pass along tips on how to create a concept, design a menu, layout your floor plan, and open your restaurant.<br/><br/>For more in depth help from professionals writing your business plan check out: <a href='http://RestaurantBPlan.com/Plans'>http://RestaurantBPlan.com/Plans</a><br/><br/><br/><br/></body></html>";
    static string subscribeEmail = "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\"><html xmlns=\"http://www.w3.org/1999/xhtml\"><head><meta content=\"text/html; charset=utf-8\" http-equiv=\"Content-Type\" /><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\" /><title></title></head><body style=\"max-width:300px;color:#333\">{Name},<br/><br/>A well-conceived, professional restaurant business plan is your greatest single asset for turning your restaurant dreams into reality. It's the key to convincing anyone to invest money, make a loan, lease space, essentially do business with you prior to opening.<br/><br/>Your restaurant business plan is also the roadmap for the future of your business. Not only does it provide direction, it requires you to consider all the pitfalls and opportunities of your prospective venture, well before you open the doors. Your business plan is the script of how your restaurant will look and function when it's done. In short, <strong>many restaurateurs say that having a sound business plan was the single most important ingredient in making their new business a reality.</strong><br/><br/>So why do so many restaurateurs forsake this critical step, without which many entrepreneurs wouldn't even open a lemonade stand? For one, restaurateurs often want to get the ball rolling quickly. Too many operators put all their planning into simply getting financed. They then want to open the doors as fast as possible to create cash flow.<br/><br/>Unfortunately, some operators don't understand how crucial a well-planned opening is to not only securing the capital to open but also to the success of their concept. Hard work, great food, and the will to succeed are not enough. You need proper training, established operational procedures, and a creative marketing plan, before you open. These may be more important to a successful opening than menu design or table and chair selection.<br/><br/>In this course, we will guide you through the ins and outs of creating a powerful business plan that will attract investors. We will also pass along tips on how to create a concept, design a menu, layout your floor plan, and open your restaurant.<br/><br/>For more in depth help from professionals writing your business plan check out: <a href='http://RestaurantBPlan.com/Plans'>http://RestaurantBPlan.com/Plans</a><br/><br/></body></html>";
    static string sampleEmail = @"<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'><html xmlns='http://www.w3.org/1999/xhtml\'><head><meta content='text/html;charset=utf-8' http-equiv='Content-Type' /><meta name='viewport' content='width=device-width,initial-scale=1' /><title></title></head><body style='color:#333'><div style='width:350px;margin-bottom:1.5em;'>A business plan is your roadmap for the future of your restaurant. Not only does it provide direction, it requires you to consider all the pitfalls and opportunities of your prospective enterprise, well before you open its doors. It is your script of how the business ought to be.<br/><br/>Where to start? At Restaurant BPlan, professional restaurant consultants have developed hundreds of business plans for highly successful restaurants. Here we have put together a sample of how to get started with {Restaurant}. For the rest of the business plan, visit <a href='http://RestaurantBPlan.com/Plans'>http://RestaurantBPlan.com/Plans</a></div><table cellspacing=0 cellpadding=0 style='border: 1px solid #999;padding: 12px 20px 20px;font-family:Helvetica,Arial'><tr><td colspan=3 style='text-align:center;font-size:24px;'>{Restaurant}</td></tr><tr><td colspan=3 style='text-align:center;font-size:18px;font-weight:bold;padding:6px 0 12px;'>Financials Overview</td></tr><tr style='font-weight:bold;'><td>SOURCES OF CASH</td><td></td><td></td></tr><tr><td style='padding: 2px 30px;'>Equity Contributions</td><td style='text-align:right;'>150,000</td><td></td></tr><tr><td style='padding: 2px 30px;'>Loan Financing</td><td style='text-align:right;'>275,366</td><td></td></tr><tr style='font-weight:bold;background:#ABCDEF;'><td>TOTAL SOURCES OF CASH</td><td></td><td style='text-align:right;padding: 2px 8px 2px 38px;'>425,366</td></tr><tr><td>&nbsp;</td><td></td><td></td></tr><tr style='font-weight:bold;'><td>USES OF CASH</td><td></td><td></td></tr><tr><td style='padding: 2px 30px;'>Land and Building</td><td style='text-align:right;'>0</td><td></td></tr><tr><td style='padding: 2px 30px;'>Leasehold Improvements</td><td style='text-align:right;'>150,000</td><td></td></tr><tr><td style='padding: 2px 30px;'>Equipment</td><td style='text-align:right;'>64,166</td><td></td></tr><tr><td style='padding: 2px 30px;'>Professional Services</td><td style='text-align:right;'>12,500</td><td></td></tr><tr><td style='padding: 2px 30px;'>Organizational and Development</td><td style='text-align:right;'>17,500</td><td></td></tr><tr><td style='padding: 2px 30px;'>Interior Finishes and Equipment</td><td style='text-align:right;'>30,500</td><td></td></tr><tr><td style='padding: 2px 30px;'>Exterior Finishes and Equipment</td><td style='text-align:right;'>23,500</td><td></td></tr><tr><td style='padding: 2px 30px;'>Pre-Opening Expenses</td><td style='text-align:right;'>62,200</td><td></td></tr><tr><td style='padding: 2px 30px;'>Working Capital and Contingency</td><td style='text-align:right;'>65,000</td><td></td></tr><tr style='font-weight:bold;background:#ABCDEF;'><td>TOTAL USES OF CASH</td><td></td><td style='text-align:right;padding: 2px 8px 2px 38px;'>425,366</td></tr></table><div style='height:1.5em;'></div><table cellspacing=0 cellpadding=0 style='border: 1px solid #999;padding:12px 20px 20px;text-align:right;font-family:Helvetica,Arial;font-size:12px;'><tr><td colspan=6 style='text-align:center;font-size:24px;'>{Restaurant}</td></tr><tr><td colspan=6 style='text-align:center;font-size:18px;font-weight:bold;padding:6px 0 12px;'>5 Year Projections</td></tr><tr style='background:#2B579A;color:#FFFFFF;text-align:center;font-size:16px;'><td></td><td style='padding:4px;'>Year 1</td><td>Year 2</td><td>Year 3</td><td>Year 4</td><td>Year 5</td></tr><tr><td style='text-align:left;font-weight:bold;padding:4px 4px;'>Sales</td><td></td><td></td><td></td><td></td><td></td></tr><tr><td style='text-align:left;padding:1px 30px 1px 20px;'>Food</td><td style='padding:1px 8px;'>399,818&nbsp;&nbsp;61.5%</td><td style='padding:1px 8px;'>415,810&nbsp;&nbsp;61.5%</td><td  style='padding:1px 8px;'>432,443&nbsp;&nbsp;61.5%</td><td style='padding:1px 8px;'>449,740&nbsp;&nbsp;61.5%</td><td style='padding:1px 8px;'>467,730&nbsp;&nbsp;61.5%</td></tr><tr><td style='text-align:left;padding:1px 30px 1px 20px;'>Beverage</td><td style='padding:1px 8px;border-bottom:2px solid black;'>250,214&nbsp;&nbsp;38.5%</td><td style='padding:1px 8px;border-bottom:2px solid black;'>260,222&nbsp;&nbsp;38.5%</td><td style='padding:1px 8px;border-bottom:2px solid black;'>270,631&nbsp;&nbsp;38.5%</td><td style='padding:1px 8px;border-bottom:2px solid black;'>281,456&nbsp;&nbsp;38.5%</td><td style='padding:1px 8px;border-bottom:2px solid black;'>292,715&nbsp;&nbsp;38.5%</td></tr><tr><td style='text-align:left;padding:1px 30px 1px 4px;'>TOTAL SALES</td><td style='padding:1px 8px;text-align: left;'>650,031&nbsp;&nbsp;100%</td><td style='padding:1px 8px;text-align: left;'>676,032&nbsp;&nbsp;100%</td><td style='padding:1px 8px;text-align: left;'>703,074&nbsp;&nbsp;100%</td><td style='padding:1px 8px;text-align: left;'>731,197&nbsp;&nbsp;100%</td><td style='padding:1px 8px;text-align: left;'>760,445&nbsp;&nbsp;100%</td></tr><tr><td>&nbsp;</td><td></td><td></td><td></td><td></td><td></td></tr><tr><td style='text-align:left;font-weight:bold;padding:4px 4px;'>Cost of Sales</td><td></td><td></td><td></td><td></td><td></td></tr><tr><td style='text-align:left;padding:1px 30px 1px 20px;'>Food</td><td style='padding:1px 8px;'>107,951&nbsp;&nbsp;16.6%</td><td style='padding:1px 8px;'>112,269&nbsp;&nbsp;16.6%</td><td style='padding:1px 8px;'>116,760&nbsp;&nbsp;16.6%</td><td style='padding:1px 8px;'>121,430&nbsp;&nbsp;16.6%</td><td style='padding:1px 8px;'>126,287&nbsp;&nbsp;16.6%</td></tr><tr><td style='text-align:left;padding:1px 30px 1px 20px;'>Beverage</td><td style='padding:1px 8px;border-bottom:2px solid black;'>67,558&nbsp;&nbsp;10.4%</td><td style='padding:1px 8px;border-bottom:2px solid black;'>70,260&nbsp;&nbsp;10.4%</td><td style='padding:1px 8px;border-bottom:2px solid black;'>73,070&nbsp;&nbsp;10.4%</td><td style='padding:1px 8px;border-bottom:2px solid black;'>75,993&nbsp;&nbsp;10.4%</td><td style='padding:1px 8px;border-bottom:2px solid black;'>79,033&nbsp;&nbsp;10.4%</td></tr><tr><td style='text-align:left;padding:1px 30px 1px 4px;'>TOTAL SALES</td><td style='padding:1px 8px;text-align: left;'>175,508&nbsp;&nbsp;27%</td><td style='padding:1px 8px;text-align: left;'>182,529&nbsp;&nbsp;27%</td><td style='padding:1px 8px;text-align: left;'>189,830&nbsp;&nbsp;27%</td><td style='padding:1px 8px;text-align: left;'>197,423&nbsp;&nbsp;27%</td><td style='padding:1px 8px;text-align: left;'>205,320&nbsp;&nbsp;27%</td></tr><tr style='background:#ABCDEF;color:#000;'><td style='text-align:left;padding:2px 0px 2px 4px;font-weight:bold;font-size:14px;'>GROSS PROFIT</td><td style='padding:1px 8px;text-align: left;'>474,523&nbsp;&nbsp;73%</td><td style='padding:1px 8px;text-align: left;'>493,504&nbsp;&nbsp;73%</td><td style='padding:1px 8px;text-align: left;'>513,244&nbsp;&nbsp;73%</td><td style='padding:1px 8px;text-align: left;'>533,774&nbsp;&nbsp;73%</td><td style='padding:1px 8px;text-align: left;'>555,125&nbsp;&nbsp;73%</td></tr><tr><td>&nbsp;</td><td></td><td></td><td></td><td></td><td></td></tr><tr><td style='text-align:left;font-weight:bold;padding:4px 4px;'>Payroll</td><td></td><td></td><td></td><td></td><td></td></tr><tr><td style='text-align:left;padding:1px 30px 1px 20px;'>Salaries</td><td style='padding:1px 8px;'>140,796&nbsp;&nbsp;21.7%</td><td style='padding:1px 8px;'>146,428&nbsp;&nbsp;21.7%</td><td style='padding:1px 8px;'>152,285&nbsp;&nbsp;21.7%</td><td style='padding:1px 8px;'>158,376&nbsp;&nbsp;21.7%</td><td style='padding:1px 8px;'>164,711&nbsp;&nbsp;21.7%</td></tr><tr><td style='text-align:left;padding:1px 30px 1px 20px;'>Benefits</td><td style='padding:1px 8px;border-bottom:2px solid black;'>33,738&nbsp;&nbsp;5.2%</td><td style='padding:1px 8px;border-bottom:2px solid black;'>35,087&nbsp;&nbsp;5.2%</td><td style='padding:1px 8px;border-bottom:2px solid black;'>36,491&nbsp;&nbsp;5.2%</td><td style='padding:1px 8px;border-bottom:2px solid black;'>37,950&nbsp;&nbsp;5.2%</td><td style='padding:1px 8px;border-bottom:2px solid black;'>39,468&nbsp;&nbsp;5.2%</td></tr><tr><td style='text-align:left;padding:1px 0px 1px 4px;'>TOTAL PAYROLL</td><td style='padding:1px 8px;text-align: left;'>174,534&nbsp;&nbsp;26.9%</td><td style='padding:1px 8px;text-align: left;'>181,515&nbsp;&nbsp;26.9%</td><td style='padding:1px 8px;text-align: left;'>188,776&nbsp;&nbsp;26.9%</td><td style='padding:1px 8px;text-align: left;'>196,326&nbsp;&nbsp;26.9%</td><td style='padding:1px 8px;text-align: left;'>204,179&nbsp;&nbsp;26.9%</td></tr><tr style='background:#ABCDEF;color:#000;'><td style='text-align:left;padding:2px 30px 2px 4px;font-weight:bold;font-size:14px;'>PRIME COST</td><td style='padding:1px 8px;text-align: left;'>350,042&nbsp;&nbsp;53.9%</td><td style='padding:1px 8px;text-align: left;'>364,044&nbsp;&nbsp;53.9%</td><td style='padding:1px 8px;text-align: left;'>378,606&nbsp;&nbsp;53.9%</td><td style='padding:1px 8px;text-align: left;'>393,749&nbsp;&nbsp;53.9%</td><td style='padding:1px 8px;text-align: left;'>409,499&nbsp;&nbsp;53.9%</td></tr><tr><td>&nbsp;</td><td></td><td></td><td></td><td></td><td></td></tr><tr><td colspan=6 style='text-align:left;font-weight:bold;padding:4px 4px;'>Other Controllable Expenses</td></tr><tr><td style='text-align:left;padding:1px 30px 1px 20px;'>Operating Expenses</td><td style='padding:1px 8px;'>24,600&nbsp;&nbsp;3.8%</td><td style='padding:1px 8px;'>25,338&nbsp;&nbsp;3.7%</td><td style='padding:1px 8px;'>26,098&nbsp;&nbsp;3.7%</td><td style='padding:1px 8px;'>26,881&nbsp;&nbsp;3.7%</td><td style='padding:1px 8px;'>27,688&nbsp;&nbsp;3.6%</td></tr><tr style='color:#666666;'><td style='text-align:left;padding:1px 30px 1px 20px;'>Music</td><td style='padding:1px 8px;'>1,800&nbsp;&nbsp;0.3%</td><td style='padding:1px 8px;'>1,854&nbsp;&nbsp;0.3%</td><td style='padding:1px 8px;'>1,910&nbsp;&nbsp;0.3%</td><td style='padding:1px 8px;'>1,967&nbsp;&nbsp;0.3%</td><td style='padding:1px 8px;'>2,026&nbsp;&nbsp;0.3%</td></tr><tr style='color:#888888;'><td style='text-align:left;padding:1px 30px 1px 20px;'>Marketing</td><td style='padding:1px 8px;'>18,000&nbsp;&nbsp;2.8%</td><td style='padding:1px 8px;'>18,540&nbsp;&nbsp;2.7%</td><td style='padding:1px 8px;'>19,096&nbsp;&nbsp;2.7%</td><td style='padding:1px 8px;'>19,669&nbsp;&nbsp;2.7%</td><td style='padding:1px 8px;'>20,259&nbsp;&nbsp;2.7%</td></tr><tr style='color:#AAAAAA;'><td style='text-align:left;padding:1px 30px 1px 20px;'>Utilities</td><td style='padding:1px 8px;'>25,800&nbsp;&nbsp;4%</td><td style='padding:1px 8px;'>26,574&nbsp;&nbsp;3.9%</td><td style='padding:1px 8px;'>27,371&nbsp;&nbsp;3.9%</td><td style='padding:1px 8px;'>28,192&nbsp;&nbsp;3.9%</td><td style='padding:1px 8px;'>29,038&nbsp;&nbsp;3.8%</td></tr><tr style='color:#CCCCCC;'><td style='text-align:left;padding:1px 30px 1px 20px;'>General & Administrative</td><td style='padding:1px 8px;'>35,172&nbsp;&nbsp;5.4%</td><td style='padding:1px 8px;'>36,227&nbsp;&nbsp;5.4%</td><td style='padding:1px 8px;'>37,314&nbsp;&nbsp;5.3%</td><td style='padding:1px 8px;'>38,433&nbsp;&nbsp;5.3%</td><td style='padding:1px 8px;'>39,586&nbsp;&nbsp;5.2%</td></tr><tr style='color:#EEEEEE;'><td style='text-align:left;padding:1px 30px 1px 20px;'>Maintenance</td><td style='padding:1px 8px;'>9,600&nbsp;&nbsp;1.5%</td><td style='padding:1px 8px;'>9,888&nbsp;&nbsp;1.5%</td><td style='padding:1px 8px;'>10,185&nbsp;&nbsp;1.4%</td><td style='padding:1px 8px;'>10,490&nbsp;&nbsp;1.4%</td><td style='padding:1px 8px;'>10,805&nbsp;&nbsp;1.4%</td></tr></table><div style='width:380px;margin:1.5em 0;'>No doubt, a business plan takes time and effort. It is well worth it, as the final, polished document will give you, and your investors, confidence that you really can reach your destination: a successful restaurant.<br/><br/>For professional help developing your concept and writing your plan, visit <a href='http://RestaurantBPlan.com/Plans'>http://RestaurantBPlan.com/Plans</a></div></body></html>";
    static string email3 = @"<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'><html xmlns='http://www.w3.org/1999/xhtml\'><head><meta content='text/html; charset=utf-8' http-equiv='Content-Type' /><meta name='viewport' content='width=device-width, initial-scale=1' /><title></title></head><body style='color:#333'><div style='width:380px;'>People are always asking, ""How much does if cost to open a restaurant?""<br/><br/>As part of our ongoing effort to answer this question, we responded by asking restaurant owners to share their unique experiences with regard to their startup costs. We received more than 700 responses from a variety of restaurants. Of course no two restaurants are the same, and the cost per square foot to open a restaurant varies greatly depending upon a litany of factors such as service style, decor, size, and location. Nevertheless, we were able to uncover a number of statistics that can be useful when planning your startup.<br/><br/>The report below shows the collective responses for all respondents. While this information is beneficial, more meaningful comparisons can be made by reviewing the results of only those restaurants that more closely resemble your own concept. Visit <a href='http://RestaurantBPlan.com/Plans'>http://RestaurantBPlan.com/Plans</a> to get data specific to your concept.<br/><br/></div><table cellspacing=0 cellpadding=0 ><tr style='background:#2B579A;color:#FFFFFF;text-align:center;'><td style='padding:4px 14px;'>Sales-Investment Results</td><td style='padding:4px 8px;'>Lower Quartile</td><td style='padding:4px 8px;'>Upper Quartile</td><td style='padding:4px 8px;'>Average</td></tr><tr><td style='padding:2px 14px;'>Annual sales</td><td style='padding:1px 9px;text-align:right;'>$425,000</td><td style='padding:1px 9px;text-align:right;'>$1,375,000</td><td style='padding:1px 9px;text-align:right;'>$1,172,629</td></tr><tr><td style='padding:2px 14px;'>Sales per sq. ft.</td><td style='padding:1px 9px;text-align:right;'>$188</td><td style='padding:1px 9px;text-align:right;'>$442</td><td style='padding:1px 9px;text-align:right;'>$370</td></tr><tr><td style='padding:2px 14px;'>Sales per seat</td><td style='padding:1px 9px;text-align:right;'>$5,556</td><td style='padding:1px 9px;text-align:right;'>$13,571</td><td style='padding:1px 9px;text-align:right;'>$10,263</td></tr><tr><td style='padding:2px 14px;'>Annual profit-$</td><td style='padding:1px 9px;text-align:right;'>$21,250</td><td style='padding:1px 9px;text-align:right;'>$135,000</td><td style='padding:1px 9px;text-align:right;'>$100,684</td></tr><tr><td style='padding:2px 14px;'>Profit-%</td><td style='padding:1px 9px;text-align:right;'>2.5%</td><td style='padding:1px 9px;text-align:right;'>12.0%</td><td style='padding:1px 9px;text-align:right;'>6.6%</td></tr><tr><td style='padding:2px 14px;'>Annual return on total investment</td><td style='padding:1px 9px;text-align:right;'>4.7%</td><td style='padding:1px 9px;text-align:right;'>40.1%</td><td style='padding:1px 9px;text-align:right;'>34.9%</td></tr><tr><td style='padding:2px 14px;'># of months it took to become profitable</td><td style='padding:1px 9px;text-align:right;'>1</td><td style='padding:1px 9px;text-align:right;'>24</td><td style='padding:1px 9px;text-align:right;'>18</td></tr><tr style='background:#2B579A;color:#FFFFFF;text-align:center;'><td style='padding:4px 14px;'>Cost Estimates</td><td style='padding:4px 8px;'>Lower Quartile</td><td style='padding:4px 8px;'>Upper Quartile</td><td style='padding:4px 8px;'>Average</td></tr><tr><td style='padding:1px 14px;'>Total startup cost (no land purchase)</td><td style='padding:1px 9px;text-align:right;'>$125,000</td><td style='padding:1px 9px;text-align:right;'>$650,000</td><td style='padding:1px 9px;text-align:right;'>$551,426</td></tr><tr><td style='padding:1px 14px;'>Total startup cost (with land purchase)</td><td style='padding:1px 9px;text-align:right;'>$225,000</td><td style='padding:1px 9px;text-align:right;'>$1,125,000</td><td style='padding:1px 9px;text-align:right;'>$813,816</td></tr><tr><td style='padding:1px 14px;'>Cost overrun compared to budget</td><td style='padding:1px 9px;text-align:right;'>0%</td><td style='padding:1px 9px;text-align:right;'>46%</td><td style='padding:1px 9px;text-align:right;'>33%</td></tr><tr><td style='padding:1px 14px;'>Construction cost-$</td><td style='padding:1px 9px;text-align:right;'>$50,000</td><td style='padding:1px 9px;text-align:right;'>$400,000</td><td style='padding:1px 9px;text-align:right;'>$320,112</td></tr><tr><td style='padding:1px 14px;'>Land & building cost-$</td><td style='padding:1px 9px;text-align:right;'>$40,000</td><td style='padding:1px 9px;text-align:right;'>$500,000</td><td style='padding:1px 9px;text-align:right;'>$456,129</td></tr></table><br/><br/><br/><br/></body></html>";
    static string email4 = @"<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'><html xmlns='http://www.w3.org/1999/xhtml\'><head><meta content='text/html; charset=utf-8' http-equiv='Content-Type' /><meta name='viewport' content='width=device-width, initial-scale=1' /><title></title></head><body style='color:#333'><div style='width:330px;'>Hey {Name}, if you’ve read through my previous emails you know you need a business plan to get your restaurant funded and off the ground. You also know it’s a lot of work. That’s where Restaurant B Plan comes in: <a href='http://RestaurantBPlan.com/Plans'>RestaurantBPlan.com/Plans</a><br/><br/>We’ve written hundreds of business plans for restaurants, and we’ve made it as easy as possible for you to create a business plan. Based on you answering just a few simple questions, we will write a business plan for you tailored specifically to your type of restaurant.<br/><br/>Because your restaurant is unique and not exactly like any other out there, we’ve created easy-to-use App where you can edit any piece of the plan specifically for your restaurant.<br/><br/>We will explain to you in detail what to include in each section and what each term in the financials documents means so you can have a professional, accurate business plan individual to your new venture.<br/><br/>Professional restaurateurs and accountants have built out this system, so you will end up with a Business Plan, 10 Financial Documents, and be able to explain it to investors.<br/><br/>We will even throw in these Bonuses to help you moving forward:<br/>1. Restaurant Startup Checklist<br/>2. Restaurant 90-Day Preopening Planning Chart<br/>3. A License and Permit Checklist for Startup Restaurants<br/>4. Restaurant Opening Weekly Task Sheet<br/><br/>What are you waiting for? Get started making your restaurant dream a reality today at <a href='http://RestaurantBPlan.com/Plans'>RestaurantBPlan.com/Plans</a></div><br/><br/><br/><br/></body></html>";
    static string email5 = @"<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'><html xmlns='http://www.w3.org/1999/xhtml\'><head><meta content='text/html; charset=utf-8' http-equiv='Content-Type' /><meta name='viewport' content='width=device-width, initial-scale=1' /><title></title></head><body style='color:#333'><div style='width:330px;'>In any new business venture good decision-making is vital. Opening a new restaurant requires so many decisions that it's not hard to make some bloopers along the way.<br/><br/>The key is not totally missing the mark on the really important issues that can make or break your chances for success. Here are some of the more important common missteps new owners make in areas that play a big role in how well a new restaurant is likely to do.<br/><br/><strong>1. Underestimating capital needs.</strong> There are many good new restaurants with excellent prospects for success that simply run out of money. It's common for first time owners in particular, to leave out or inadequately project all the startup costs involved in opening the restaurant. Some of the reasons include construction overruns, change orders, delays, and to be blindsided by additional costs mandated from local inspectors and building authorities.<br/><br/>Also, soft costs like permits, liquor licenses, insurance binders and pre-opening payroll are often missed completely or grossly under-budgeted. Unless you've done it before, it's usually advisable to seek some experienced, professional help in identifying and estimating, in detail, startup capital you'll need. Even then, many pros still add a 10%-15% contingency for the host of things that can (and often do) happen to add more cost to the project than you plan on. <br/><br/><strong>2. Believing you'll start making money on opening day.</strong> The odds are stacked against this happening. Even the best run chain restaurants, who open restaurants for a living, factor into their startup budgets, an allowance for funding operating deficits for up to 2 to 3 months after the restaurant opens. <br/><br/>It usually takes time to build sales volume to an adequate level. Even if your sales are strong from day 1, food and labor costs are usually sky high for the first several weeks as your managers and staff get acclimated, productive and have the time and energy to focus on anything other than just taking care of who's at the table. In time, most things can be fixed. Run out of money and you're done. Not factoring in an adequate reserve for initial operating deficits is another cause of undercapitalization (see #1 above).<br/><br/><strong>3. Lack of a clear vision and purpose.</strong> This may sound somewhat vague and intangible but a successful startup requires the coordinated effort of a dedicated staff pulling together in the same direction, united by a common goal. Getting this accomplished requires some leadership skills. <br/><br/>New operators who either don't have or can't communicate an underlying mission that the staff can rally around will find it difficult to create the kind of climate that supports teamwork, hard work and dedication to excellence that endures through the long hours and sometime chaotic conditions that take place during the startup phase of any new restaurant. <br/><br/><strong>4. Having the grand opening on opening day.</strong> You only have to do this once and you learn to wait a month or 2 to declare your grand opening. There are few things worse than getting slammed with more business that you can possibly handle on day one. With so many restaurants, the public's first impression can easily be their last. <br/><br/>Blow it on opening day and chances are you won't see most of those people again, ever. And they'll tell their friends to stay away too. Soft, quiet openings are the way to go. Get your act together before you tell the world. <br/><br/><strong>5. Trying to appeal to everyone.</strong> You can't and if you try you'll end up with too many items on the menu, an overly complicated kitchen, confused customers and no unique identity in the marketplace. The key to success for today's independents is to identify an unfilled niche in your local market and being laser-beam focused on filling that particular slice of the market. This will give you a much better chance to become really good at whatever it is you do.<br/><br/>A great way to avoid these mistakes is to develop a solid plan before you get started. For professional guidance building out your Business Plan, visit <a href='http://RestaurantBPlan.com/Plans'>RestaurantBPlan.com/Plans</a></div><br/><br/><br/><br/></body></html>";

}