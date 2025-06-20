#!/usr/bin/env python3
"""
Test file for trying out nvim-dap debugger.
Try setting breakpoints and stepping through the code!
"""

def calculate_factorial(n):
    """Calculate factorial of n recursively."""
    if n <= 1:
        return 1
    else:
        result = n * calculate_factorial(n - 1)
        return result

def main():
    # Try setting a breakpoint on this line
    numbers = [5, 3, 7, 4]
    
    print("Calculating factorials:")
    for num in numbers:
        # Another good place for a breakpoint
        fact = calculate_factorial(num)
        print(f"{num}! = {fact}")
    
    # Test with a larger number
    large_num = 10
    large_fact = calculate_factorial(large_num)
    print(f"\n{large_num}! = {large_fact}")
    
    # Test list comprehension debugging
    squares = [x**2 for x in range(1, 6)]
    print(f"\nSquares: {squares}")

if __name__ == "__main__":
    main()
