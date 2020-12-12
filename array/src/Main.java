//Seyed Tavafi
/* You are given an array of integers( both positive and negative values)
   find the contiguous sequence with largest sum.
 */
import java.util.Scanner;
import java.util.Arrays;
import java.util.stream.IntStream;


class Main {

    static void findMaxSubArraySum(int array[], int length) {
        int max_so_far = Integer.MIN_VALUE, max_ending_here = 0, start = 0, end = 0, s = 0;

        for (int i = 0; i < length; i++) {
            max_ending_here += array[i];

            if (max_so_far < max_ending_here) {
                max_so_far = max_ending_here;
                start = s;
                end = i;
            }

            if (max_ending_here < 0) {
                max_ending_here = 0;
                s = i + 1;
            }
        }
        System.out.println("Maximum contiguous sum is " + max_so_far);
        System.out.println("Starting index " + start);
        System.out.println("Ending index " + end);
        System.out.print('[');
        for (int i = start; i <= end; i++) {
            System.out.print(array[i]);
            if (i != end) {
                System.out.print(" , ");
            }
        }
        System.out.println(']');
    }

    public static void main(String[] args) {
        Scanner scan = new Scanner(System.in);
        System.out.println("please enter array length");
        int length = scan.nextInt();
        int[] array = new int[length];
        System.out.println("please enter array element");
        for (int i = 0; i < length; i++) {
            array[i] = scan.nextInt();
        }
        findMaxSubArraySum(array, length);
    }
}