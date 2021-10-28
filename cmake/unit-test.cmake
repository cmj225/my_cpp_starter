#
# Unit Test Setting
#

# ---- check selected unit-test option valid ----
if(${PROJECT_NAME}_ENABLE_UNIT_TESTS)
  if(NOT ${PROJECT_NAME}_ENABLE_GTEST AND NOT ${PROJECT_NAME}_ENABLE_CATCH2)
    message(FATAL_ERROR "Unit test option enabled BUT no unit test library is selected ...")
  endif()
endif()

# ---- enable google-test ----
if(${PROJECT_NAME}_ENABLE_GTEST)
  find_package(GTest REQUIRED)
  set(GOOGLE_TEST_LIBRARIES GTest::GTest GTest::Main)
  if(${PROJECT_NAME}_ENABLE_GMOCK)
    set(GOOGLE_TEST_LIBRARIES ${GOOGLE_TEST_LIBRARIES} GTest::gmock GTest::gmock_main)
  endif()

  function(add_gtest_target test_group_name target_name)
    file(
      GLOB_RECURSE
      test_sources
      CONFIGURE_DEPENDS
      "${CMAKE_CURRENT_LIST_DIR}/${target_name}/*.cpp")
    add_executable(${target_name} ${test_sources})
    add_dependencies(${target_name} ${PROJECT_NAME})
    target_include_directories(${target_name} PRIVATE ${PROJECT_HEADER_DIR} ${CMAKE_CURRENT_LIST_DIR}/${target_name})
    target_link_libraries(${target_name} PRIVATE ${PROJECT_NAME} ${GOOGLE_TEST_LIBRARIES})
    add_test(${test_group_name} ${target_name})
  endfunction()
endif()

# ---- enable Catch2 ----
if(${PROJECT_NAME}_ENABLE_CATCH2)
  message(STATUS "Catch2 required")
  find_package(Catch2 REQUIRED)
  set(CATCH2_TEST_LIBRARIES Catch2::Catch2)

  function(add_catch2_target test_group_name target_name)
    file(
      GLOB_RECURSE
      test_sources
      CONFIGURE_DEPENDS
      "${CMAKE_CURRENT_LIST_DIR}/${target_name}/*.cpp")
    add_executable(${target_name} ${test_sources})
    add_dependencies(${target_name} ${PROJECT_NAME})
    target_include_directories(${target_name} PRIVATE ${PROJECT_HEADER_DIR} ${CMAKE_CURRENT_LIST_DIR}/${target_name})
    target_link_libraries(${target_name} PRIVATE ${PROJECT_NAME} ${CATCH2_TEST_LIBRARIES})
    add_test(${test_group_name} ${target_name})
  endfunction()
endif()
