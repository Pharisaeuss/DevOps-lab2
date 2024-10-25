#include "suite.h"
#include <cmath> 

double suite::calculate(double x, int n) {
    double result = 0.0;

    for (int i = 1; i <= n; ++i) {
        result += pow(-1, i - 1) * pow(x, i) / i;
    }

    return result;  
}

