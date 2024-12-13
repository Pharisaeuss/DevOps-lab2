#include <cassert>
#include <chrono>
#include <cstdlib> 
#include <iostream>

void testComputeEndpointTiming() {
    auto start = std::chrono::high_resolution_clock::now();
    int result = system("curl -i -X GET 172.17.0.2:8081/compute > /dev/null");
    auto end = std::chrono::high_resolution_clock::now();

    assert(result == 0);

    auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count();
    std::cout << "Response time: " << duration << " ms" << std::endl;

    // Check if the response time is within the range 5 to 20 seconds
    assert(duration >= 5000 && duration <= 20000);
}

int main() {
    testComputeEndpointTiming();
    std::cout << "Success" << std::endl;
    return 0;
}
