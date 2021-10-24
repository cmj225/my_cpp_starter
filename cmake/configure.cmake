#
# CMake Configure
#
string(TOLOWER ${PROJECT_NAME} PROJECT_NAME_LOWERCASE)
string(TOUPPER ${PROJECT_NAME} PROJECT_NAME_UPPERCASE)

if (${PROJECT_NAME}_CMAKE_VERBOSE)
	set(CMAKE_VERBOSE_MAKEFILE true)
else()
	set(CMAKE_VERBOSE_MAKEFILE false)
endif()

include(cmake/compiler.cmake) # option: build type, warnings as errers, compile flags

if (${PROJECT_NAME}_ENABLE_GIT_HOOKS)
	execute_process(COMMAND git config core.hooksPath hooks
									WORKING_DIRECTORY "${PROEJCT_SOURCE_DIR}"
	)
endif()

if (${PROJECT_NAME}_ENABLE_GIT_SUBMODULES)
	execute_process(COMMAND git submodule init
									COMMAND git submodule update
									WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
	)
endif()

if (${PROJECT_NAME}_ENABLE_CLANG_FORMAT)
	include(cmake/clang-format.cmake)
endif()

if (${PROJECT_NAME}_ENABLE_STATIC_ANALYZER)
	include(cmake/static-analyzer.cmake)
endif()

if (${PROJECT_NAME}_ENABLE_DOXEYGEN)
	include(cmake/documentation.cmake)
endif()

if (${PROJECT_NAME}_ENABLE_UNIT_TEST)
	include(cmake/unit-test.cmake)
endif()

