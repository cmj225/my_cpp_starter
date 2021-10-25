#
# Compiler Handling
#

# ---- display compiler info ----
message(STATUS "Compiler Setting")
message(STATUS "	ID	    \t: ${CMAKE_CXX_COMPILER_ID}")
message(STATUS "	VERSION	\t: ${CMAKE_CXX_COMPILER_VERSION}")
message(STATUS "	Path	  \t: ${CMAKE_CXX_COMPILER}")

# ---- some options ----
option(${PROJECT_NAME}_EXPORT_ALL_SYMBOLS "Export all symbols when building a shared library" ON)
option(${PROJECT_NAME}_ENABLE_LTO "Enable Interprocedural Optimization, aka Link Time Optimization (LTO)." ON)
option(${PROJECT_NAME}_ENABLE_CCACHE "Enable the usage of CCache, in order to speed up rebuild times." ON)

# ---- compiler support check ----
if(${CMAKE_CXX_COMPILER_ID} MATCHES Clang OR ${CMAKE_CXX_COMPILER_ID} MATCHES GNU)

else()
  message(FATAL_ERROR "No Tested Comipler")
endif()

# ---- check compiler support CXX standard & set standard version ----
include(CheckCXXCompilerFlag)
if(${CMAKE_CXX_COMPILER_ID} MATCHES Clang)
  check_cxx_compiler_flag(-std=c++2a COMPILER_SUPPORT_CXX_LATEST)
  check_cxx_compiler_flag(-std=c++17 COMPILER_SUPPORT_CXX17)
elseif(${CMAKE_CXX_COMPILER_ID} MATCHES GNU)
  check_cxx_compiler_flag(-std=gnu++2a COMPILER_SUPPORT_CXX_LATEST)
  check_cxx_compiler_flag(-std=gnu++17 COMPILER_SUPPORT_CXX17)
endif()

if(COMPILER_SUPPORT_CXX_LATEST)
  set(CMAKE_CXX_STANDARD 20)
  message(STATUS "Selected CXX Standard Version: 20")
else()
  set(CMAKE_CXX_STANDARD 17)
  message(STATUS "Selected CXX Standard Version: 17")
endif()
set(CMAKE_CXX_STANDARD_REQUIRED on)

# ---- Compiler Test ----
include(CheckCXXSourceRuns)
check_cxx_source_runs("int main() {return 0;}" build_test)
if(build_test)

else()
  message(FATAL_ERROR "CheckCXXSourceRuns Failed")
endif()

# ---- compiler warning include ----
include(cmake/compiler-warnings.cmake)
if(${PROJECT_NAME}_WARNNINGS_AS_ERRORS)
  set(CLANG_WARNINGS ${CLANG_WARNINGS} -Werror)
  set(GCC_WARNINGS ${GCC_WARNINGS} -Werror)
  set(MSVC_WARNINGS ${MSVC_WARNINGS} /WX)
endif()

# ---- compiler flag include ----
include(cmake/compiler-flag.cmake)

# ---- compiler option handling ----
if(${PROJECT_NAME}_DEBUG_BUILD)
  set(CMAKE_BUILD_TYPE Debug)
  if(${CMAKE_CXX_COMPILER_ID} MATCHES Clang)
    set(${PROJECT_NAME}_COMPILE_OPTIONS ${CLANG_DEBUG_FLAGS} ${CLANG_WARNINGS})
  elseif(${CMAKE_CXX_COMPILER_ID} MATCHES GNU)
    set(${PROJECT_NAME}_COMPILE_OPTIONS ${GCC_DEBUG_FLAGS} ${GCC_WARNINGS})
  elseif(${CMAKE_CXX_COMPILER_ID} MATCHES MSVC)
    set(${PROJECT_NAME}_COMPILE_OPTIONS ${MSVC_DEBUG_FLAGS} ${MSVC_WARNINGS})
  endif()
else()
  set(CMAKE_BUILD_TYPE Release)
  if(${CMAKE_CXX_COMPILER_ID} MATCHES Clang)
    set(${PROJECT_NAME}_COMPILE_OPTIONS ${CLANG_RELEASE_FLAGS} ${CLANG_WARNINGS})
  elseif(${CMAKE_CXX_COMPILER_ID} MATCHES GNU)
    set(${PROJECT_NAME}_COMPILE_OPTIONS ${GCC_RELEASE_FLAGS} ${GCC_WARNINGS})
  elseif(${CMAKE_CXX_COMPILER_ID} MATCHES MSVC)
    set(${PROJECT_NAME}_COMPILE_OPTIONS ${MSVC_RELEASE_FLAGS} ${MSVC_WARNINGS})
  endif()
endif()

# ---- Export all symbols when building a shared libary ----
if(${PROJECT_NAME}_EXPORT_ALL_SYMBOLS)
  set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)
  set(CMAKE_CXX_VISIBILITY_PRESET hidden)
  set(CMAKE_VISIBILITY_INLINES_HIDDEN 1)
endif()

# ---- Enable LTO ----
if(${PROJECT_NAME}_ENABLE_LTO)
  include(CheckIPOSupported)
  check_ipo_supported(RESULT result OUTPUT output)
  if(result)
    set(CMAKE_INTERPROCEDURAL_OPTIMIZATION TRUE)
    message(STATUS "	IPO is supported.")
  else()
    message(SEND_ERROR "IPO is not supported: ${output}.")
  endif()
endif()

# ---- Enable CCache ----
if(${PROJECT_NAME}_ENABLE_CCACHE)
  find_program(CCACHE_FOUND ccache)
  if(CCACHE_FOUND)
    message(STATUS "	CCache Enabledfind for speed  up rebuild.")
    set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE ccache)
    set_property(GLOBAL PROPERTY RULE_LAUNCH_LINK ccache)
  else()
    message(SEND_ERROR "CCache program is not found")
  endif()
endif()

# ---- Generate compile_command.json for clang based tools ----
# check build/compile_command.json for compile options setting valid
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
