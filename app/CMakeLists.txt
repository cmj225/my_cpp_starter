#
# ---- app ----
#
message(STATUS "App target generating start")

# add app internal header, source for library
file(
    GLOB_RECURSE APP_SOURCES
    CONFIGURE_DEPENDS
    "${CMAKE_CURRENT_LIST_DIR}/*.cpp"
)
message(STATUS "App Sources: ${APP_SOURCES}")
add_executable(${APP_TARGET} ${APP_SOURCES})
add_dependencies(${APP_TARGET} ${LIBRARY_TARGET})

target_compile_options(${APP_TARGET} PRIVATE ${COMPILE_OPTIONS})

target_include_directories(${APP_TARGET}
    PUBLIC ${PROJECT_HEADER_DIR} # <- use library, app header
    PRIVATE ${THIRD_PARTY_HEADER_DIR}
            ${CMAKE_CURRENT_LIST_DIR}/include # <- app internal header
)

# check app dependencies
message(STATUS "App Dependency check")
include(${PROJECT_SOURCE_DIR}/cmake/dependencies/app-deps.cmake)
message(STATUS "App Dependency check - Success")

# link dependencies
target_link_libraries(${APP_TARGET} PRIVATE ${PROJECT_NAME}
    # add app deps libraries
)

# app install
install(
    TARGETS ${APP_TARGET}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)



message(STATUS "App target generating start - Success")