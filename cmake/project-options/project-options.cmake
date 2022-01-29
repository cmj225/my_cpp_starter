#
# ---- project options ----
#
option(PROJECT_OPTIONS_PLATFORM_VALIDATION "Check Platform Validation" ON)
option(PROJECT_OPTIONS_ENABLE_GIT_HOOKS "Enable Git hooks." ON)
option(PROJECT_OPTIONS_ENABLE_SUBMODULE_AUTO_INIT_UPDATE "git submodule auto initialization." ON)

option(PROJECT_OPTIONS_ENABLE_CLANG_FORMAT "Activate clang-format." ON)

# ---- handle project options ----

## project platform support validation
if (PROJECT_OPTIONS_PLATFORM_VALIDATION)
    include(${CMAKE_CURRENT_LIST_DIR}/platform-validation.cmake)
endif()

## ---- git options ----
include(${CMAKE_CURRENT_LIST_DIR}/git-options.cmake)

## code formatter - clang-format
if(PROJECT_OPTIONS_ENABLE_CLANG_FORMAT)
    include(${CMAKE_CURRENT_LIST_DIR}/clang-format.cmake)
endif()
## unit-test option - google-test, catch2

## coverage-test option

## profile-test option

## memory-test option -

## documentation - doxygen
