#
# Compiler Handling
#

# ---- display compiler info ----
message(STATUS "Compiler Setting")
message(STATUS "	    ID	    \t: ${CMAKE_CXX_COMPILER_ID}")
message(STATUS "	    VERSION	\t: ${CMAKE_CXX_COMPILER_VERSION}")
message(STATUS "	    Path	  \t: ${CMAKE_CXX_COMPILER}")

# ---- compiler support (Clang or GNU) ----
message(STATUS "Compiler Support Check")
if(${CMAKE_CXX_COMPILER_ID} MATCHES Clang OR ${CMAKE_CXX_COMPILER_ID} MATCHES GNU)
else()
    message(FATAL_ERROR "Not Tested Compiler")
endif()
message(STATUS "Compiler Support Check - Success")

# ---- CXX standard support ----
message(STATUS "CXX Standard Support Check")
include(CheckCXXCompilerFlag)
if(${CMAKE_CXX_COMPILER_ID} MATCHES Clang)
    check_cxx_compiler_flag(-std=c++${TARGET_CXX_STANDARD} COMPILER_SUPPORT_TARGET_CXX_STANDARD)
    check_cxx_compiler_flag(-std=c++2a COMPILER_SUPPORT_CXX_LATEST)
    check_cxx_compiler_flag(-std=c++14 COMPILER_SUPPORT_CXX14)
elseif(${CMAKE_CXX_COMPILER_ID} MATCHES GNU)
    check_cxx_compiler_flag(-std=gnu++${TARGET_CXX_STANDARD} COMPILER_SUPPORT_TARGET_CXX_STANDARD)
    check_cxx_compiler_flag(-std=gnu++2a COMPILER_SUPPORT_CXX17)
    check_cxx_compiler_flag(-std=gnu++14 COMPILER_SUPPORT_CXX14)
endif()
message(STATUS "CXX_STANDARD SUPPORT: 14 ~ Latest(2a)")
if(COMPILER_SUPPORT_TARGET_CXX_STANDARD)
    set(CMAKE_CXX_STANDARD ${TARGET_CXX_STANDARD})
    message(STATUS "Selected CXX Standard Version: ${TARGET_CXX_STANDARD}")
    message(STATUS "CXX Standard Support Check - Success")
else()
    message(FATAL_ERROR "Selected CXX Standard ${TARGET_CXX_STANDARD} Not Supported")
endif()

# ---- Compiler Running Test ----
include(CheckCXXSourceRuns)
check_cxx_source_runs("int main() {return 0;}" CompilerRunning)
if(CompilerRunning)
else()
    message(FATAL_ERROR "CheckCXXSourceRuns Failed")
endif()


if(COMPILER_OPTIONS_EXPORT_ALL_SYMBOLS)
    set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)
    set(CMAKE_CXX_VISIBILITY_PRESET hidden)
    set(CMAKE_VISIBILITY_INLINES_HIDDEN 1)
endif()

if(COMPILER_OPTIONS_ENABLE_LTO)
    message(STATUS "IPO support check")
    include(CheckIPOSupported)
    check_ipo_supported(RESULT result OUTPUT output)
    if(result)
        set(CMAKE_INTERPROCEDURAL_OPTIMIZATION TRUE)
        message(STATUS "IPO support check - Success")
    else()
        message(SEND_ERROR "IPO is not supported: ${output}.")
    endif()
endif()

if(COMPILER_OPTIONS_ENABLE_CCACHE) # <- CCache Tool Install need
    message(STATUS "CCache support check")
    find_program(CCACHE_FOUND ccache)
    if(CCACHE_FOUND)
        message(STATUS "	CCache Enabled for speed-up rebuild.")
        set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE ccache)
        set_property(GLOBAL PROPERTY RULE_LAUNCH_LINK ccache)
        message(STATUS "CCache support check - Success")
    else()
        message(SEND_ERROR "CCache program is not found")
    endif()
endif()

# ---- Generate compile_command.json for clang based tools ----
# check build/compile_command.json for compile options setting valid
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)