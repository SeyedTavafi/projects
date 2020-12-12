//
//	Name:		Tavafi, Seyed
//	Project:  	2
//	Due:		Monday October 7, 2019
//	Course:		Cs-1400-f19
//
//	Description:
//			Computer randomly will choose a number between 1-100 and user should guess what
//			the number is. User have  8 chance to guess the Correct number.
//

import java.util.Scanner;
import java.util.Random;
public class GuessingGame
{
	public static void main(String[] args)
	{
		System.out.println("S. Tavafi's Number Guessing Game");
		System.out.println();
		System.out.println("A secret number between 1-100 has been generated...");
		System.out.println();
		Random rand=new Random();
		Scanner keyboard=new Scanner(System.in);
		int randomnumber=rand.nextInt(100)+1;
		int guesscounter=1;
		System.out.print("Enter your guess? ");
		int userguess=keyboard.nextInt();

		while(guesscounter<8 && userguess !=randomnumber && userguess!=0)
		{

			if(userguess>randomnumber)
			{
				System.out.println("Guess is high, try again.");
			}
			else
			{
				System.out.println("Guess is low, try again.");
			}
			System.out.print("Enter your guess? ");
			userguess=keyboard.nextInt();
			guesscounter++;
		}
		if(userguess==randomnumber)
		{
			System.out.println("Correct in "+ guesscounter+ " guesses.");
		}
		else
		{
			System.out.println("The secret number is "+ randomnumber+".");
		}

	}
}
