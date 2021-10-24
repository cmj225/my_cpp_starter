cmake_minimum_required(VERSION 3.15)

# ---- Project ----
project(
	Greeter
	VERSION 0.1.0
  LANGUAGES CXX
)
configure_file(
	${PROJECT_SOURCE_DIR}/cmake/Version.h.in
	${PROJECT_SOURCE_DIR}/include/${PROJECT_NAME}/Version.h
)
message(STATUS "Started CMake for ${PROJECT_NAME} v${PROJECT_VERSION}...\n")


# ---- check default ----
include(cmake/out-of-source-build.cmake)
include(cmake/platform-validation.cmake)

# ---- Set proejct options ----
## CMake
option(${PROJECT_NAME}_VERBOSE_OUTPUT           "Enable CMake Verbose Outputm allowing for a better understanding of each step taken." ON)

## Compiler
option(${PROJECT_NAME}_DEBUG_BUILD              "Set Project build type Debug." ON) # for develop -> further default = OFF
option(${PROJECT_NAME}_WARNINGS_AS_ERRORS       "Treat compiler warnings as errors." ON)

## git
option(${PROJECT_NAME}_ENABLE_GIT_HOOKS        "Enable git hooks ${PROJECT_SOURCE_DIR}/hooks" ON)
option(${PROJECT_NAME}_ENABLE_SUBMODULES       "Enable submodules init & update automatically" OFF)

## Clang-format
option(${PROJECT_NAME}_ENABLE_CLANG_FORMAT      "Enable clang-format for check convention" ON)

## Statical Analyzers
option(${PROJECT_NAME}_ENABLE_STATICAL_ANALYZER	"Enable Static Analysis." OFF)
option(${PROJECT_NAME}_ENABLE_CLANG_TIDY        "Enable Static Analysis with Clang-Tidy." OFF)
option(${PROJECT_NAME}_ENABLE_CPPCHECK          "Enable Static Analysis with Cppcheck." OFF)

## Documentation
option(${PROJECT_NAME}_ENABLE_DOXYGEN           "Enable Doxygen documentation." OFF)

## Unit Testing
option(${PROJECT_NAME}_ENABLE_UNIT_TEST         "Enable Unit Tests for the project (from the `test` subforler)." OFF)
option(${PROJECT_NAME}_USE_GTEST 				        "Use the GoogleTest for creating unit tests." OFF)
option(${PROJECT_NAME}_USE_GOOGLE_MOCK 	        "Use the GoogleMock for extending the unit tests." OFF)
option(${PROJECT_NAME}_USE_CATCH2 			        "Use the Catch2 for creating unit tests." OFF) 

include(cmake/configure.cmake)
message(STATUS "configuring project ended")
# ---- Find project dependencies ----
## Identify and link with the specific "packages" the project uses
## find_package(package_name package_version REQUIRED package_type [other_options])

# ---- Create library ----
## configure project

## Add source files
## Note: globbing sources is considered bad practice as CMake's generators may not detect new files
## automatically. Keep that in mind when changing files, or explicitly mention them here.
file(GLOB_RECURSE headers CONFIGURE_DEPENDS "${CMAKE_CURRENT_LIST_DIR}/include/*.h")
file(GLOB_RECURSE sources CONFIGURE_DEPENDS "${CMAKE_CURRENT_LIST_DIR}/src/*.cpp")

add_library(${PROJECT_NAME} SHARED ${headers} ${sources})
target_compile_options(${PROJECT_NAME} PRIVATE ${${PROJECT_NAME}_COMPILE_OPTIONS})
set_target_properties(${PROJECT_NAME} PROPERTIES
	ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/${CMAKE_BUILD_TYPE}/lib"
	LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/${CMAKE_BUILD_TYPE}/lib"
	RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/${CMAKE_BUILD_TYPE}/bin"
	OUTPUT_NAME ${PROJECT_NAME}-${PROJECT_VERSION}
)
target_include_directories(
	${PROJECT_NAME}
	PUBLIC
		${CMAKE_CURRENT_LIST_DIR}/include
	PRIVATE
		${CMAKE_CURRENT_LIST_DIR}/src
)
target_link_libraries(${PROJECT_NAME}
	PUBLIC
	PRIVATE
)
install(
	TARGETS ${PROJECT_NAME}
	EXPORT ${PROJECT_NAME}Targets
	ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
	LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
	RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
	INCLUDES DESTINATION include
	PUBLIC_HEADER DESTINATION include
)

# ---- hanlding sub components ----
if (${PROJECT_NAME}_ENABLE_CLANG_FORMAT)
	file(GLOB_RECURSE clang-format-h   CONFIGURE_DEPENDS "${CMAKE_CURRENT_LIST_DIR}/*.h")
	file(GLOB_RECURSE clang-format-hpp CONFIGURE_DEPENDS "${CMAKE_CURRENT_LIST_DIR}/*.hpp")
	file(GLOB_RECURSE clang-format-cc  CONFIGURE_DEPENDS "${CMAKE_CURRENT_LIST_DIR}/*.cc")
	file(GLOB_RECURSE clang-format-cpp CONFIGURE_DEPENDS "${CMAKE_CURRENT_LIST_DIR}/*.cpp")
	file(GLOB_RECURSE clang-format-tpp CONFIGURE_DEPENDS "${CMAKE_CURRENT_LIST_DIR}/*.tpp")
	set(CLANG_FORMAT_INPUT
		${clang-format-h} ${clang-format-hpp}
		${clang-format-cc} ${clang-format-cpp} ${clang-format-tpp}
	)
	add_clang_format_target()
endif()

if (${PROJECT_NAME}_ENABLE_UNIT_TESTING)
	enable_testing()
	message("Building Tests. :)")
	add_subdirectory(tests)
endif()

## @TODO: install documentation to ${PROJECT_LIST_DIR}/doc/pages for GitHub page deploy
if (${PROJECT_NAME}_ENABLE_DOXYGEN)
	message("Building Documents. :)")
	add_subdirectory(doc)
endif()

