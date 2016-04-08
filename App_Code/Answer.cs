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

            Answer answer = new Answer(question.Id, restaurant.Id, val);
            answer.Save();
        }
        
    }

}