#include <iostream>
#include "suite.h"

int main() {
    suite obj;
    double x;
    int n;

    // Get user input
    std::cout << "Enter the value of x (for ln(1+x)): ";
    std::cin >> x;
    
    std::cout << "Enter the number of terms in the series: ";
    std::cin >> n;

    double result = obj.calculate(x, n);
    
    std::cout <<  " Result:  " << result << std::endl;

    return 0;
}

