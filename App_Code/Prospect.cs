using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for Prospect
/// </summary>
public class Prospect : BaseClass<Prospect>
{
	public Prospect()
	{
        Created = DateTime.Now;
	}

    #region Properties

    public string Name { get; set; }

    public string Email { get; set; }

    public string Restaurant { get; set; }

    public string Food { get; set; }

    public string RestaurantType { get; set; }

    public string Size { get; set; }

    public string City { get; set; }

    public string Opening { get; set; }

    public DateTime Created { get; set; }

    public int? EmailSent { get; set; }

    public DateTime? LastEmailSent { get; set; }

    #endregion
}