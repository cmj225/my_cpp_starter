#
# Compiler flag handling
#

# ---- Clang ----
set(CLANG_DEBUG_FLAGS
        -O0
        -g3
        -ggdb
        -fPIC
        -fexceptions
        -pthread
        -fcolor-diagnostics
)

set(CLANG_RELEASE_FLAGS
        -O3
        -DNDEBUG
        -fPIC
        -fexceptions
        -pthread
        -fcolor-diagnostics
)

# ---- Gcc ----
set(GCC_DEBUG_FLAGS
        -O0
        -g3
        -ggdb
        -fPIC
        -fexceptions
        -pthread
        -fdiagnostics-color=always
)

set(GCC_RELEASE_FLAGS
        -O3
        -DNDEBUG
        -fPIC
        -fexceptions
        -pthread
        -fdiagnostics-color=always
)

if(CMAKE_BUILD_TYPE)
    message(STATUS "Build type setting: ${CMAKE_BUILD_TYPE}")
else()
    message(STATUS "Build type not specified.")
    message(STATUS "Build type setting: Default(Debug)")
    set(CMAKE_BUILD_TYPE Debug)
endif()

message(STATUS "Selected Build Type: ${CMAKE_BUILD_TYPE}")
if(${CMAKE_BUILD_TYPE} MATCHES Debug)
    if(${CMAKE_CXX_COMPILER_ID} MATCHES Clang)
        set(COMPILE_OPTIONS ${COMPILE_OPTIONS} ${CLANG_DEBUG_FLAGS})
    elseif(${CMAKE_CXX_COMPILER_ID} MATCHES GNU)
        set(COMPILE_OPTIONS ${COMPILE_OPTIONS} ${GCC_DEBUG_FLAGS})
    else()
        message(FATAL_ERROR "Not Tested Compiler")
    endif()
elseif(${CMAKE_BUILD_TYPE} MATCHES Release)
    if(${CMAKE_CXX_COMPILER_ID} MATCHES Clang)
        set(COMPILE_OPTIONS ${COMPILE_OPTIONS} ${CLANG_RELEASE_FLAGS})
    elseif(${CMAKE_CXX_COMPILER_ID} MATCHES GNU)
        set(COMPILE_OPTIONS ${COMPILE_OPTIONS} ${GCC_RELEASE_FLAGS})
    else()
        message(FATAL_ERROR "Not Tested Compiler")
    endif()
else()
    message(FATAL_ERROR "Not Tested Build Type ${CMAKE_BUILD_TYPE}")
endif()

