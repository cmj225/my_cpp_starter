/**
 * @brief GoogleTest test file
 */

#include <gtest/gtest.h>
#include <CppStarter/CppStarter.h>
#include <iostream>

int main(int argc, char* argv[]) {
  // check argv and initialize
  // if args has google test flag, it will be removed
  ::testing::InitGoogleTest(&argc, argv);

  return RUN_ALL_TESTS();
}

TEST(GTestOperatingTest, Greeter) {
  bool b1{true};
  bool b2{true};
  ASSERT_EQ(b1, b2);
  std::cout << cppstarter::CPPSTARTER_VERSION << std::endl;
};