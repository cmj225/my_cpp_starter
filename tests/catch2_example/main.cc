/**
 * @brief Catch2 test file
 */

#define CATCH_CONFIG_MAIN

#include <catch2/catch.hpp>
#include <iostream>
#include <starter/starter.h>

int add(int a, int b) { return a + b; }

int factorial(int n) { return n <= 1 ? 1 : factorial(n - 1) * n; }

TEST_CASE("add function", "[add]") { REQUIRE(add(1, 1) == 2); }

TEST_CASE("factorial function", "[factorial]") {
  REQUIRE(factorial(1) == 1);
  REQUIRE(factorial(2) == 2);
  REQUIRE(factorial(3) == 6);
  REQUIRE(factorial(10) == 3628800);
  std::cout << starter::STARTER_VERSION << std::endl;
}