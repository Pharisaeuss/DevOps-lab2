#include "suite.h"
#include <cassert>
#include <cmath>

void unit_test() {
    suite suiteInstance;

    // Test 1: x = 0, n = 1
    assert(suiteInstance.calculate(0, 1) == 0.0);

    // Test 2: x = 1, n = 1
    assert(std::abs(suiteInstance.calculate(1, 1) - 1.0) < 1e-9);

    // Test 3: x = 1, n = 2
    assert(std::abs(suiteInstance.calculate(1, 2) - (1.0 - 1.0 / 2.0)) < 1e-9);

}

int main() {
    unit_test();
    return 0;
}
