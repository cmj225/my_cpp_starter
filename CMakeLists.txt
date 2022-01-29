#
# project cmake
#
cmake_minimum_required(VERSION 3.21)

# ---- project setting ----
set(PROJECT_NAME CppStarter) # <- change project name
string(TOLOWER ${PROJECT_NAME} PROJECT_NAME_LOWERCASE)
string(TOUPPER ${PROJECT_NAME} PROJECT_NAME_UPPERCASE)

# ---- start project generating ----
project(${PROJECT_NAME} VERSION 0.1.0 LANGUAGES CXX)
message(STATUS "Start CMake ... Generate ${PROJECT_NAME} v${PROJECT_VERSION}")
## create project version header
configure_file(${CMAKE_CURRENT_LIST_DIR}/Version.h.in
    ${CMAKE_CURRENT_LIST_DIR}/include/${PROJECT_NAME}/Version.h
)
## set target cxx standard
set(TARGET_CXX_STANDARD 20) # <- change to wanted standard version [14, 17, 20, Latest)

# cmake-options
include(cmake/cmake-options/cmake-options.cmake)

# project options
include(cmake/project-options/project-options.cmake)

# header path setting
set(PROJECT_HEADER_DIR ${PROJECT_SOURCE_DIR}/include)
set(THIRD_PARTY_HEADER_DIR ${PROJECT_SOURCE_DIR}/ThirdParty/include)

# create libary
#set(LIBRARY_TARGET ${PROJECT_NAME})
#add_subdirectory(lib)   # <- library

# create app
#set(APP_TARGET ${PROJECT_NAME}App)
#add_subdirectory(app)   # <- app

# create unit-test

#####
file(
        GLOB_RECURSE LIBRARY_SOURCES
        CONFIGURE_DEPENDS
        "${CMAKE_CURRENT_LIST_DIR}/lib/*.cpp"
)
message(STATUS "Library Sources: ${LIBRARY_SOURCES}")
add_library(${PROJECT_NAME} SHARED ${LIBRARY_SOURCES})
target_compile_options(${PROJECT_NAME} PRIVATE ${COMPILE_OPTIONS})
set_target_properties(${PROJECT_NAME}
    PROPERTIES ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
    LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
    OUTPUT_NAME ${PROJECT_NAME}.${PROJECT_VERSION}
)
target_include_directories(${PROJECT_NAME}
    PUBLIC ${PROJECT_HEADER_DIR} # <- use library header
    PRIVATE ${THIRD_PARTY_HEADER_DIR}
    ${CMAKE_CURRENT_LIST_DIR}/lib/include # <- library internal header
)

# add app internal header, source for library
file(
        GLOB_RECURSE APP_SOURCES
        CONFIGURE_DEPENDS
        "${CMAKE_CURRENT_LIST_DIR}/app/*.cpp"
)
message(STATUS "App Sources: ${APP_SOURCES}")
add_executable(CppStarterApp ${APP_SOURCES})
add_dependencies(CppStarterApp ${PROJECT_NAME})

target_include_directories(CppStarterApp
    PUBLIC ${PROJECT_HEADER_DIR} # <- use library, app header
    PRIVATE ${THIRD_PARTY_HEADER_DIR}
    ${CMAKE_CURRENT_LIST_DIR}/app/include # <- app internal header
)
target_link_libraries(CppStarterApp PRIVATE ${PROJECT_NAME})