using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for Answer
/// </summary>
public class Answer : BaseClass<Answer>
{
	public Answer()
	{
    }

    public Answer(int questionId, int restaurantId, string text)
    {
        QuestionId = questionId;
        RestaurantId = restaurantId;
        Text = text;
    }

    #region Properties

    public int QuestionId { get; set; }

    public int RestaurantId { get; set; }

    public string Text { get; set; }

    #endregion

    public static void CreateAnswersFromTemplate(Restaurant restaurant, string meals, string drinks) {
        List<Question> questions = Question.LoadAll();
        foreach (Question question in questions)
        {
            string val = "";
            switch (restaurant.RestaurantType) {
                case "Fine Dining":
                    val = question.DefaultValue0;
                    break;
                case "Casual":
                    val = question.DefaultValue1;
                    break;
                case "Fast Casual":
                    val = question.DefaultValue2;
                    break;
                case "Trailer":
                    val = question.DefaultValue3;
                    break;
            }


            if (!meals.Contains("Breakfast") && question.SkipCondition.Contains("Breakfast"))
            {
                val = "0";
            }
            if (!meals.Contains("Lunch") && question.SkipCondition.Contains("Lunch"))
            {
                val = "0";
            }
            if (!meals.Contains("Dinner") && question.SkipCondition.Contains("Dinner"))
            {
                val = "0";
            }
            if (!drinks.Contains("Liquor"))
            {
                if (question.Title == "Liquor License" || question.Title == "Liquor Average Price" || question.Title == "Liquor % Ordered" ||
                    question.Title == "Liquor Cost %" || question.Title == "Liquor Liability Insurance")
                {
                    val = "0";
                }
                if (question.Title == "Liquor & Wine")
                {
                    val = drinks.Contains("Wine") ? "5000" : "0";
                }
            }
            if (!drinks.Contains("Beer"))
            {
                if (question.Title == "Beer" || question.Title == "Beer Average Price" || question.Title == "Beer % Ordered" ||
                    question.Title == "Beer Cost %")
                {
                    val = "0";
                }
            }
            if (!drinks.Contains("Wine"))
            {
                if (question.Title == "Wine Average Price" || question.Title == "Wine % Ordered" ||
                    question.Title == "Wine Cost %")
                {
                    val = "0";
                }
            }

            Answer answer = new Answer(question.Id, restaurant.Id, val);
            answer.Save();
        }
        
    }

}