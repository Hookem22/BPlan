using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for Restaurant
/// </summary>
public class Restaurant : BaseClass<Restaurant>
{
	public Restaurant()
	{
	}

    public string Name { get; set; }

    public string Food { get; set; }

    public string RestaurantType { get; set; }

    public int Size { get; set; }

    public int SquareFootage { get; set; }

    public string City { get; set; }

    public string Opening { get; set; }

    public int UserId { get; set; }

    public static Restaurant LoadByUserId(int userId)
    {
        List<Restaurant> restaurants = Restaurant.LoadByPropName("UserId", userId.ToString());
        if (restaurants.Count > 0)
            return restaurants[0];

        return new Restaurant();
    }
}
