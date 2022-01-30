#
# unit-tests
#
include(CTest)

add_custom_target(
  ctest
  COMMAND ctest
  WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/tests)

# add gtest unit-test example
add_gtest_target("gtest_group_1" "gtest_example")

# add catch2 unit-test example
add_catch2_target("catch2_group_1" "catch2_example")

# Note
# - Create test folder
# - add test target
