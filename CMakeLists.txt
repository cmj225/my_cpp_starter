#
# cmake project
#
cmake_minimum_required(VERSION 3.21)
project(
  starter
  VERSION 0.0.0
  DESCRIPTION "${PROJECT_NAME} Project"
  LANGUAGES CXX)
string(TOLOWER ${PROJECT_NAME} PROJECT_NAME_LOWERCASE)
string(TOUPPER ${PROJECT_NAME} PROJECT_NAME_UPPERCASE)
configure_file(${PROJECT_SOURCE_DIR}/version.h.in ${PROJECT_SOURCE_DIR}/include/${PROJECT_NAME}/version.h)
message(STATUS "Start CMake ... Generate ${PROJECT_NAME} v${PROJECT_VERSION}")

# set target cxx standard
set(CMAKE_CXX_STANDARD 17) # <- change to wanted standard version [14, 17, 20, Latest)

# include program_options
include(${PROJECT_SOURCE_DIR}/cmake/program_options/index.cmake)
project_options(
  WARNINGS_AS_ERRORS # Treat compiler warnings as errors
  # ENABLE_CPPCHECK # Enable static analysis with cppcheck
  # ENABLE_CLANG_TIDY # Enable static analysis with clang-tidy
  # ENABLE_COVERAGE # Enable coverage reporting for gcc/clang
  # ENABLE_CACHE # Enable cache if available
  # ENABLE_VCPKG # Use Vcpkg for dependency management
  # ENABLE_CONAN # Use Conan for dependency management
  ENABLE_DOXYGEN # Enable doxygen doc builds of source
  # ENABLE_IPO # Enable Interprocedural Optimization, aka Link Time Optimization
  # ENABLE_BUILD_WITH_TIME_TRACE # Enable -ftime-trace to generate time tracing .json files on clang
  # ENABLE_UNITY # Enable Unity builds of projects
  # ENABLE_SANITIZER_ADDRESS # Enable address sanitizer
  # ENABLE_SANITIZER_LEAK # Enable leak sanitizer
  # ENABLE_SANITIZER_UNDEFINED_BEHAVIOR # Enable undefined behavior sanitizer
  # ENABLE_SANITIZER_THREAD # Enable thread sanitizer
  # ENABLE_SANITIZER_MEMORY # Enable memory sanitizer
  # MSVC_WARNINGS # Override the defaults for the MSVC warnings -> one-value
  # CLANG_WARNINGS # Override the defaults for the CLANG warnings -> one-value
  # GCC_WARNINGS # Override the defaults for the GCC warnings -> one-value
  ENABLE_UNIT_TEST_GTEST # Enable Google Test
  ENABLE_UNIT_TEST_GMOCK # Enable Google Mock
  ENABLE_UNIT_TEST_CATCH2 # Enable Catch2
  # CONAN_OPTIONS ## Extra Conan Options Add -> multi-value
)

# include dependency_options
include(${PROJECT_SOURCE_DIR}/cmake/dependency_options/index.cmake)
dependency_options(
  SPDLOG
)

# create libary
add_subdirectory(lib)

# create app
add_subdirectory(app)

# create test
add_subdirectory(tests)
