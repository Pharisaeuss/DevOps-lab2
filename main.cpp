#include <iostream>
#include "suite.h"

int main() {
    suite obj;
    double x;
    int n;

    // Get user input
    std::cout << "Enter the value of x (for ln(1+x)): ";
    std::cin >> x;
    

    double result = obj.calculate(x, 3);
    
    std::cout <<  " Result:  " << result << std::endl;

    return 0;
}

