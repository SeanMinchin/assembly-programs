# gcd_algorithm
ARM assembly recursive program to find the greatest common divisor of two integers

Write a **recursive** program that takes two integers as input and outputs the greatest common divisor.

Use the following algorithm:
// for two integers *m* and *n*

if (m < n)

  gcd(m,n) = gcd(n,m)
  
if n is a divisor of m

  gcd(m,n) = n
  
else

  gcd(m,n) = gcd(n,m modulo n)
  
***Your program must be recursive.***  You **must** create a function that calls itself, and saves variables to the stack, and creates a stack frame. Your program should restore the stack as it returns from recursive calls.

Your program should have the following prompt:
"Enter Two Integers: "
Your program should then output the greatest common divisor then terminate.

## Sample Test Cases
Enter Two Integers: 0 37

37

Enter Two Integers: 0 -37

37

Enter Two Integers: 1 37

1

Enter Two Integers: -1 37

1

Enter Two Integers: 5 75

5

Enter Two Integers: -10 -100

10

Enter Two Integers: -10 100

10

Enter Two Integers: 5 7

1

*Note: gcd(0,0) will **not** be tested
