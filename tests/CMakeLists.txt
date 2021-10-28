include(CTest)

add_custom_target(
  ctest
  COMMAND ctest
  WORKING_DIRECTORY ${CMAKE_BINARY_DIR})

if(${PROJECT_NAME}_ENABLE_GTEST)
  add_gtest_target("gtest_group_1" "gtest_example")
endif()

if(${PROJECT_NAME}_ENABLE_CATCH2)
  add_catch2_target("catch2_group_1" "catch2_example")
endif()

# add test below part
