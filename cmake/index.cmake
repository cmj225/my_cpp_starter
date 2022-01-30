#
# cmake library refer: https://github.com/cpp-best-practices/project_options
#
set(ProjectOptions_SRC_DIR ${CMAKE_CURRENT_LIST_DIR}/src)

include("${ProjectOptions_SRC_DIR}/PreventInSourceBuilds.cmake")
set(CMAKE_VERBOSE_MAKEFILE true) # cmake verbose output for better understanding

#
# option parse macro Params:
#
macro(project_options)
  set(options
      WARNINGS_AS_ERRORS # Treat compiler warnings as errors
      ENABLE_CPPCHECK # Enable static analysis with cppcheck
      ENABLE_CLANG_TIDY # Enable static analysis with clang-tidy
      ENABLE_COVERAGE # Enable coverage reporting for gcc/clang
      ENABLE_CACHE # Enable cache if available
      ENABLE_VCPKG # Use Vcpkg for dependency management
      ENABLE_CONAN # Use Conan for dependency management
      ENABLE_DOXYGEN # Enable doxygen doc builds of source
      ENABLE_IPO # Enable Interprocedural Optimization, aka Link Time Optimization
      ENABLE_BUILD_WITH_TIME_TRACE # Enable -ftime-trace to generate time tracing .json files on clang
      ENABLE_UNITY # Enable Unity builds of projects
      ENABLE_SANITIZER_ADDRESS # Enable address sanitizer
      ENABLE_SANITIZER_LEAK # Enable leak sanitizer
      ENABLE_SANITIZER_UNDEFINED_BEHAVIOR # Enable undefined behavior sanitizer
      ENABLE_SANITIZER_THREAD # Enable thread sanitizer
      ENABLE_SANITIZER_MEMORY # Enable memory sanitizer
      ENABLE_UNIT_TEST_GTEST # Enable google test
      ENABLE_UNIT_TEST_GMOCK # Enable google mock
      ENABLE_UNIT_TEST_CATCH2 # Enable catch
  )
  set(oneValueArgs MSVC_WARNINGS CLANG_WARNINGS GCC_WARNINGS) # Override the defaults for the compiler warnings
  set(multiValueArgs CONAN_OPTIONS) # Extra Conan options

  cmake_parse_arguments(
    ProjectOptions # <- <prefix>
    "${options}" # <- <prefix>_{option} : {TRUE | FALSE}
    "${oneValueArgs}" # <- <prefix>_{option} : one value
    "${multiValueArgs}" # <- <prefix>_{option} : multi value
    ${ARGN})

  if(${ProjectOptions_UNPARSED_ARGUMENTS})
    message(FATAL_ERROR "Unparsed Option Requested: ${ProjectOptions_UNPARSED_ARGUMENTS}")
  endif()

  # ---- set warning message level ----
  if(${ProjectOptions_WARNING_AS_ERRORS})
    set(WARNINGS_AS_ERRORS ${ProjectOptions_WARNINGS_AS_ERRORS})
    set(WARNING_MESSAGE SEND_ERROR)
  else()
    set(WARNING_MESSAGE WARNING)
  endif()

  # ---- check build type, cxx standard ----
  include("${ProjectOptions_SRC_DIR}/StandardProjectSetting.cmake")

  # ---- enable IPO ----
  if(${ProjectOptions_ENABLE_IPO})
    include("${ProjectOptions_SRC_DIR}/InterproceduralOptimization.cmake")
    enable_ipo()
  endif()

  # ---- create compile target ----
  # Link this 'library' to set the c++ standard / compile-time options requested
  add_library(project_options INTERFACE)

  # ---- enable build-with-time-trace ----
  if(CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")
    if(ProjectOptions_ENABLE_BUILD_WITH_TIME_TRACE)
      target_compile_options(project_options INTERFACE -ftime-trace)
    endif()
  endif()

  # ---- create warning target ----
  # Link this 'library' to use the warnings specified in CompilerWarnings.cmake
  add_library(project_warnings INTERFACE)

  # ---- enable cache ----
  if(${ProjectOptions_ENABLE_CACHE})
    # enable cache system
    include("${ProjectOptions_SRC_DIR}/Cache.cmake")
    enable_cache()
  endif()

  # ---- standard compiler warnings create & handle warning as errors ----
  include("${ProjectOptions_SRC_DIR}/CompilerWarnings.cmake")
  set_project_warnings(
    project_warnings
    "${WARNINGS_AS_ERRORS}"
    "${ProjectOptions_MSVC_WARNINGS}"
    "${ProjectOptions_CLANG_WARNINGS}"
    "${ProjectOptions_GCC_WARNINGS}")

  # ---- coverage flag add for coverage-test ----
  include("${ProjectOptions_SRC_DIR}/CoverageTests.cmake")
  if(${ProjectOptions_ENABLE_COVERAGE})
    enable_coverage(project_options)
  endif()

  # enable sanitizer
  include("${ProjectOptions_SRC_DIR}/Sanitizers.cmake")
  enable_sanitizers(
    project_options
    ${ProjectOptions_ENABLE_SANITIZER_ADDRESS}
    ${ProjectOptions_ENABLE_SANITIZER_LEAK}
    ${ProjectOptions_ENABLE_SANITIZER_UNDEFINED_BEHAVIOR}
    ${ProjectOptions_ENABLE_SANITIZER_THREAD}
    ${ProjectOptions_ENABLE_SANITIZER_MEMORY})

  # enable doxygen
  if(${ProjectOptions_ENABLE_DOXYGEN})
    # enable doxygen
    include("${ProjectOptions_SRC_DIR}/Doxygen.cmake")
    enable_doxygen()
  endif()

  # allow for static analysis options - cppcheck, clang-tidy
  include("${ProjectOptions_SRC_DIR}/StaticAnalyzers.cmake")
  if(${ProjectOptions_ENABLE_CPPCHECK})
    enable_cppcheck()
  endif()
  if(${ProjectOptions_ENABLE_CLANG_TIDY})
    enable_clang_tidy()
  endif()

  # enable vcpkg
  if(${ProjectOptions_ENABLE_VCPKG})
    include("${ProjectOptions_SRC_DIR}/Vcpkg.cmake")
    run_vcpkg()
    # run_vcpkg( ENABLE_VCPKG_UPDATE VCPKG_DIR ${CMAKE_SOURCE_DIR}/vcpkg
    # VCPKG_URL "http://vcpkg_url" )
  endif()

  # enable conan
  if(${ProjectOptions_ENABLE_CONAN})
    include("${ProjectOptions_SRC_DIR}/Conan.cmake")
    run_conan()
  endif()

  # enable unit-test
  if(${ProjectOptions_ENABLE_UNIT_TEST_GTEST} OR ${ProjectOptions_ENABLE_UNIT_TEST_CATCH2})
    include("${ProjectOptions_SRC_DIR}/UnitTests.cmake")
  endif()

endmacro()
