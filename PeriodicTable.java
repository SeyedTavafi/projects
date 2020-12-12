//
//	Name:		Tavafi, Seyed
//	Project:	3
//	Due:		10/23/2019
//	Course:		cs1400-03-sp19
//
//	Description:
//		     Creat a program PeriodicTable that will read information about elements in the periodic
//		     and print out the periodic table sorted by atomic number or name.
//

import java.util.Scanner;
import java.io.*;
public class PeriodicTable
{
	public static void main(String[] args) throws IOException
	{
        	File pt=new File("/user/tvnguyen7/data/periodictable.dat");
            	Scanner inputFile= new Scanner(pt);
            	int countelements=0;
            	final int MAX_ELEMENTS=130;
            	int[] atomicNumber= new int[MAX_ELEMENTS];
            	String[] symbol=new String[MAX_ELEMENTS];
            	float[] atomicMass=new float[MAX_ELEMENTS];
            	String[] name= new String[MAX_ELEMENTS];
            	double sumofatomicMass=0;
            	double average;
		while(inputFile.hasNextInt())
            	{
                	atomicNumber[countelements]=inputFile.nextInt();
                	symbol[countelements]=inputFile.next();
                	atomicMass[countelements]=inputFile.nextFloat();
                	sumofatomicMass+=atomicMass[countelements];
                	name[countelements]=inputFile.next();
                	inputFile.nextLine();
                	countelements++;
            	}
            	average=sumofatomicMass/countelements;
            	int startScan, index, minIndex, minValue, atomicNumberValue;
            	float atomicMassValue;
            	String nameValue, symbolValue, minvalue;
            	if ((args.length == 3) && args[0].equals("print") && (args[1].equals("atomic") || args[1].equals("name")))
            	{
                	PrintWriter outputFile = new PrintWriter(args[2]);
                	outputFile.println("Periodic  Table (" + countelements + ")");
                	outputFile.println();
                	outputFile.println("ANo. Name                 Abr    Mass");
                	outputFile.println("---- -------------------- --- -------");

                	if (args[1].equals("atomic"))
                	{
                    		for (startScan = 0; startScan < countelements - 1; startScan++)
                    		{
                    			minIndex = startScan;
                    			minValue = atomicNumber[startScan];
                    			atomicMassValue = atomicMass[startScan];
                    			nameValue = name[startScan];
                    			symbolValue = symbol[startScan];
                        		for (index = startScan + 1; index < countelements; index++)
                        		{
                            			if (atomicNumber[index] < minValue)
                            			{
                                			minValue = atomicNumber[index];
                                			atomicMassValue = atomicMass[index];
                                			nameValue = name[index];
                                			symbolValue = symbol[index];
                                			minIndex = index;
                            			}
                        		}
                    			atomicNumber[minIndex] = atomicNumber[startScan];
                    			atomicNumber[startScan] = minValue;
                    			atomicMass[minIndex] = atomicMass[startScan];
                    			atomicMass[startScan] = atomicMassValue;
                    			name[minIndex] = name[startScan];
                    			name[startScan] = nameValue;
                    			symbol[minIndex] = symbol[startScan];
                    			symbol[startScan] = symbolValue;
                    		}
                    		for (int i = 0; i < countelements; i++)
                    		{
                        		if (name[i] != null)
                        		{
                            			outputFile.printf("%4d %-20s %-3s %7.2f\n", atomicNumber[i], name[i], symbol[i], atomicMass[i]);
                        		}
                    		}
                	}

			else
                	{
                    		for (startScan = 0; startScan < countelements - 1; startScan++)
                    		{
                        		minIndex = startScan;
                        		minValue = atomicNumber[startScan];
                        		atomicMassValue = atomicMass[startScan];
                        		nameValue = name[startScan];
                        		symbolValue = symbol[startScan];

                        		for (index = startScan + 1; index < countelements; index++)
                        		{
                            			if (name[index].compareTo(nameValue) < 0)
                            			{
                            				minValue = atomicNumber[index];
                            				atomicMassValue = atomicMass[index];
                            				nameValue = name[index];
                            				symbolValue = symbol[index];
                           				minIndex = index;
                            			}
                        		}
                    			atomicNumber[minIndex] = atomicNumber[startScan];
                    			atomicNumber[startScan] = minValue;
                    			atomicMass[minIndex] = atomicMass[startScan];
                    			atomicMass[startScan] = atomicMassValue;
                   			name[minIndex] = name[startScan];
                    			name[startScan] = nameValue;
                    			symbol[minIndex] = symbol[startScan];
                    			symbol[startScan] = symbolValue;
                    			}
                    			for (int j = 0; j < countelements; j++)
                    			{
                    				outputFile.printf("%4d %-20s %-3s %7.2f\n", atomicNumber[j], name[j], symbol[j], atomicMass[j]);
                    			}
                		}
                		System.out.println("Output file printed.");
                		outputFile.println();
                		outputFile.printf("The average mass:%19.2f \n", average);
                		outputFile.close();
            		}

			 else if (args.length == 0)
                	{
				System.out.println("Periodic Table by S. Tavafi");
                    		System.out.println();
				System.out.println(countelements+" elements");
				System.out.println();
                	}
            	else
            	{
                	System.out.println("Unknown action.");
            	}
        	inputFile.close();
    }


}
