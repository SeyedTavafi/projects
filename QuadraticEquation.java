//
//	
//	Project:	#1
//	Due:		Friday September 20, 2018
//	Course:		cs-1400-03-f19
//
//	Description: Write a program QuadraticEquation that prompts the user for coefficients a, b, and c of a quadratic equation and prints out the solutions.
//


import java.util.Scanner;
public class QuadraticEquation
{
	public static void main(String[] args)
	{
		System.out.println("S. Tavafi's Quadratic Equation Solver");
		System.out.println();

		Scanner input=new Scanner(System.in);
		System.out.print("Enter values  for a b c? ");
		double a=input.nextDouble();
		double b=input.nextDouble();
 		double c=input.nextDouble();
		System.out.println();
		double discriminant;
		double x1; //first root
		double x2; //second root

	if (a==0)
	{
		System.out.println("Not a quadratic equation.");


	}

	if(a!=0)
	{
		discriminant=(b*b-4*a*c);

	if (discriminant<0)
	{

	System.out.println("Roots are imaginary.");

	}

	if (discriminant>=0)
	{
		x1=(-b+Math.sqrt(discriminant))/(2*a);
		x2=(-b-Math.sqrt(discriminant))/(2*a);

		System.out.println("x1 = "+ x1);
		System.out.println("x2 = "+ x2);
	}

	}
	}
}

