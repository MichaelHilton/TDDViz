
public class Untitled {
    
    public static int answer() {
        for (int i=1; i<=100; i++) {
            if(0 == i % 15) System.out.println("FizzBuzz");
            else if (0 == i % 3) System.out.println("Fizz");
            else if (0 == i % 5) System.out.println("Buzz");
            else System.out.println(i);
        }

        return 1;
    }
}
