cmake_minimum_required(VERSION 3.15)

# ---- Project ----
project(
  Greeter
  VERSION 0.1.0
  LANGUAGES CXX)
message(STATUS "Started CMake for ${PROJECT_NAME} v${PROJECT_VERSION}...\n")

# ---- check default ----
include(cmake/out-of-source-build.cmake)
include(cmake/platform-validation.cmake)

# ---- Set proejct options ----
# CMake
option(${PROJECT_NAME}_VERBOSE_OUTPUT
       "Enable CMake Verbose Outputm allowing for a better understanding of each step taken." ON)

# Compiler
option(${PROJECT_NAME}_DEBUG_BUILD "Set Project build type Debug." ON) # for develop -> further default = OFF
option(${PROJECT_NAME}_WARNINGS_AS_ERRORS "Treat compiler warnings as errors." ON)

# Clang-format
option(${PROJECT_NAME}_ENABLE_CLANG_FORMAT "Enable clang-format for check convention" ON)

# git
option(${PROJECT_NAME}_ENABLE_GIT_HOOKS "Enable git hooks ${PROJECT_SOURCE_DIR}/hooks" ON)
# @NOTE: if this option Enabled, submodule updated when project generating ...
option(${PROJECT_NAME}_ENABLE_GIT_SUBMODULES "Enable submodules init & update automatically" ON)

# Statical Analyzers @TODO: module setup and testing need ...
option(${PROJECT_NAME}_ENABLE_STATIC_ANALYZER "Enable Static Analysis." ON)
option(${PROJECT_NAME}_ENABLE_CLANG_TIDY "Enable Static Analysis with Clang-Tidy." ON)
option(${PROJECT_NAME}_ENABLE_CPPCHECK "Enable Static Analysis with Cppcheck." ON)

# Documentation
option(${PROJECT_NAME}_ENABLE_DOXYGEN "Enable Doxygen documentation." ON)

# Unit Testing @TODO: module setup and testing need ...
option(${PROJECT_NAME}_ENABLE_UNIT_TEST "Enable Unit Tests for the project (from the `test` subforler)." ON)
option(${PROJECT_NAME}_ENABLE_GTEST "Use the GoogleTest for creating unit tests." ON)
option(${PROJECT_NAME}_ENABLE_GMOCK "Use the GoogleMock for extending the unit tests." ON)
option(${PROJECT_NAME}_ENABLE_CATCH2 "Use the Catch2 for creating unit tests." ON)

# Package Manager
option(${PROJECT_NAME}_ENABLE_PKG_MANAGER "Enable C++ Package Manager." OFF)
option(${PROJECT_NAME}_ENABLE_CONAN "Use the Conan for package manager." OFF)
option(${PROJECT_NAME}_ENABLE_VCPKG "Use the Vcpkg for package manager." OFF)

include(cmake/configure.cmake)

# ---- Find project dependencies ----
# Identify and link with the specific "packages" the project uses find_package(package_name package_version REQUIRED
# package_type [other_options])
include(cmake/dependencies.cmake)

# ---- Create library ----
# Add version header
configure_file(${PROJECT_SOURCE_DIR}/cmake/Version.h.in ${PROJECT_SOURCE_DIR}/include/${PROJECT_NAME}/Version.h)

# Add source files Note: globbing sources is considered bad practice as CMake's generators may not detect new files
# automatically. Keep that in mind when changing files, or explicitly mention them here.
set(PROJECT_HEADER_DIR ${PROJECT_SOURCE_DIR}/include)
file(
  GLOB_RECURSE
  sources
  CONFIGURE_DEPENDS
  "${PROJECT_SOURCE_DIR}/src/*.cpp")
add_library(${PROJECT_NAME} SHARED ${sources})
target_compile_options(${PROJECT_NAME} PRIVATE ${${PROJECT_NAME}_COMPILE_OPTIONS})
set_target_properties(
  ${PROJECT_NAME}
  PROPERTIES ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
             LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
             RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
             OUTPUT_NAME ${PROJECT_NAME}.${PROJECT_VERSION})
target_include_directories(
  ${PROJECT_NAME}
  PUBLIC ${PROJECT_HEADER_DIR}
  PRIVATE ${PROJECT_SOURCE_DIR}/src)
target_link_libraries(
  ${PROJECT_NAME}
  PUBLIC
  PRIVATE)
install(
  TARGETS ${PROJECT_NAME}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
install(DIRECTORY ${PROJECT_HEADER_DIR}/${PROJECT_NAME} DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# ---- Unit Test ----
if(${PROJECT_NAME}_ENABLE_UNIT_TEST)
  enable_testing()
  add_subdirectory(tests)
endif()

# ---- handling custom targets ----
# clang-format custom target @NOTE: adjust proper path
if(${PROJECT_NAME}_ENABLE_CLANG_FORMAT)
  file(
    GLOB_RECURSE
    clang-format-cxx-files
    CONFIGURE_DEPENDS
    "${CMAKE_CURRENT_LIST_DIR}/include/*.h"
    "${CMAKE_CURRENT_LIST_DIR}/src/*.cpp"
    "${CMAKE_CURRENT_LIST_DIR}/test/*.h"
    "${CMAKE_CURRENT_LIST_DIR}/test/*.cpp")
  set(CLANG_FORMAT_INPUT ${clang-format-cxx-files})
  add_clang_format_target()
endif()
