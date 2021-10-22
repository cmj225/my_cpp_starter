cmake_minimum_required(VERSION 3.15)

# ---- Project ----
project(
	Greeter
	VERSION 0.1.0
  LANGUAGES CXX
)
message(STATUS "Started CMake for ${PROJECT_NAME} v${PROJECT_VERSION}...\n")

# ---- check default ----
include(cmake/out-of-source-build.cmake)
include(cmake/platform.cmake)

# ---- Set proejct options ----
## CMake
option(${PROJECT_NAME}_VERBOSE_OUTPUT			 "Enable CMake Verbose Outputm allowing for a better understanding of each step taken." ON)
include(cmake/configure.cmake)

## Compiler
option(${PROJECT_NAME}_DEBUG_BUILD 	  		 "Set Project build type Debug." ON) # for develop -> further default = OFF
option(${PROJECT_NAME}_WARNINGS_AS_ERRORS  "Treat compiler warnings as errors." ON)
include(cmake/compiler.cmake)

## Package Managers
## Currently supporting: Conan, Vcpkg.
option(${PROJECT_NAME}_ENABLE_PKG_MANAGER  "Enable Package Manager for this project." OFF)
option(${PROJECT_NAME}_ENABLE_CONAN 			 "Enable the Conan for this project." OFF)
option(${PROJECT_NAME}_ENABLE_VCPKG 			 "Enable the Vcpkg for this project." OFF)
if(${PROJECT_NAME}_ENABLE_PKG_MANAGER)
	include(cmake/pkg-manager.cmake)
endif()

## Unit Testing
## Currently supporting: GoogleTest, Catch2
option(${PROJECT_NAME}_ENABLE_UNIT_TESTING "Enable Unit Tests for the project (from the `test` subforler)." OFF)
option(${PROJECT_NAME}_USE_GTEST 					 "Use the GoogleTest for creating unit tests." OFF)
option(${PROJECT_NAME}_USE_GOOGLE_MOCK 		 "Use the GoogleMock for extending the unit tests." OFF)
option(${PROJECT_NAME}_USE_CATCH2 				 "Use the Catch2 for creating unit tests." OFF) 
if (${PROJECT_NAME}_ENABLE_UNIT_TESTING)
	include(cmake/unit-test.cmake)
endif()

## Statical Analyzers
## Currently supporting: Clang-Tidy, Cppcheck
option(${PROJECT_NAME}_ENABLE_STATICAL_ANALYZER	"Enable Static Analysis." OFF)
option(${PROJECT_NAME}_ENABLE_CLANG_TIDY   			"Enable Static Analysis with Clang-Tidy." OFF)
option(${PROJECT_NAME}_ENABLE_CPPCHECK     			"Enable Static Analysis with Cppcheck." OFF)
if (${PROJECT_NAME}_ENABLE_STATICAL_ANALYZER)
	include(cmake/static-analyzers.cmake)
endif()

## Code Coverage
## Currently supporting: ...? 
option(${PROJECT_NAME}_ENABLE_CODE_COVERAGE "Enable Code Coverage through GCC." OFF)
if (${PROJECT_NAME}_ENABLE_CODE_COVERAGE)
	include(cmake/code-coverage.cmake)
endif()

## Documentation
## Currently supporting: Doxygen
option(${PROJECT_NAME}_ENABLE_DOXYGEN "Enable Doxygen documentation." OFF)
if (${PROJECT_NAME}_ENABLE_DOXYGEN)
	include(cmake/documentation.cmake)
endif()

# ---- Find project dependencies ----
## Identify and link with the specific "packages" the project uses
## find_package(package_name package_version REQUIRED package_type [other_options])

# ---- Create library ----
## configure project
configure_file(
	${CMAKE_CURRENT_LIST_DIR}/cmake/Version.h.in
	${CMAKE_CURRENT_LIST_DIR}/include/${PROJECT_NAME}/Version.h
)

## Add source files
## Note: globbing sources is considered bad practice as CMake's generators may not detect new files
## automatically. Keep that in mind when changing files, or explicitly mention them here.
file(GLOB_RECURSE headers CONFIGURE_DEPENDS "${CMAKE_CURRENT_LIST_DIR}/include/*.h")
file(GLOB_RECURSE sources CONFIGURE_DEPENDS "${CMAKE_CURRENT_LIST_DIR}/src/*.cpp")

## Create Target
add_library(${PROJECT_NAME} SHARED ${headers} ${sources})

## Set Target Options and Properties
target_compile_options(${PROJECT_NAME} PRIVATE ${${PROJECT_NAME}_COMPILE_OPTIONS})
set_target_properties(${PROJECT_NAME} PROPERTIES
	ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/${CMAKE_BUILD_TYPE}/lib"
	LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/${CMAKE_BUILD_TYPE}/lib"
	RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/${CMAKE_BUILD_TYPE}/bin"
	OUTPUT_NAME ${PROJECT_NAME}
)
target_include_directories(
	${PROJECT_NAME}
	PUBLIC
		$<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}/include/${PROJECT_NAME}>
		$<INSTALL_INTERFACE:${CMAKE_CURRENT_LIST_DIR}/include/${PROJECT_NAME}>
	PRIVATE
		$<CMAKE_CURRENT_LIST_DIR}/src
)
target_link_libraries(${PROJECT_NAME}
	PUBLIC
	PRIVATE
)
## @TODO: install or packaging cmake need.
## install OR CPack
## @BUG: include directory not installed ... need to check
include(GNUInstallDirs) # Why Need?
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
## @NOTE: check depedencies !!!
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

