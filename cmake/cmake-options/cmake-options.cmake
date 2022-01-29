#
# ---- cmake options ----
#
option(CMAKE_OPTIONS_OUT_OF_SOURCE_BUILD "Prevent In-Source Build." ON)
option(CMAKE_OPTIONS_VERBOSE_OUTPUT "Enable CMake verbose output for better understanding of each step taken." ON)

option(COMPILER_OPTIONS_EXPORT_ALL_SYMBOLS "Export all symbols when building a shared library." ON)
option(COMPILER_OPTIONS_ENABLE_LTO "Enable Inter-procedural Optimization, aka Link Time Optimization (LTO)." OFF)
option(COMPILER_OPTIONS_ENABLE_CCACHE "Enable the usage of CCache, in order to speed up rebuild times." OFF)

option(COMPILER_OPTIONS_WARNING_AS_ERROR "Treat compiler warnings as errors." ON)

# ---- handle cmake options ----
if(CMAKE_OPTIONS_OUT_OF_SOURCE_BUILD)
    include(${CMAKE_CURRENT_LIST_DIR}/out-of-source-build.cmake)
endif()

if(CMAKE_OPTIONS_VERBOSE_OUTPUT)
    include(${CMAKE_CURRENT_LIST_DIR}/verbose-output.cmake)
endif()

# ---- handle compiler options ----
include(${CMAKE_CURRENT_LIST_DIR}/compiler.cmake) # <- default compiler handling

include(${CMAKE_CURRENT_LIST_DIR}/compile-flag.cmake) # <- build type and flag handling

include(${CMAKE_CURRENT_LIST_DIR}/warning-as-error.cmake) # <- warning and error handling
message(STATUS "Selected Compile Flags: ${COMPILE_OPTIONS}")
## @note target_compile_options({target} PRIVATE ${COMPILE_OPTIONS}) -> target 에 컴파일 옵션 주입

