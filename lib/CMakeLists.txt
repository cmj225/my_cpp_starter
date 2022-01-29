#
# ---- lib ----
#
message(STATUS "Library target generating start")

# add libray internal header, source for library
file(
    GLOB_RECURSE LIBRARY_SOURCES
    CONFIGURE_DEPENDS
    "${CMAKE_CURRENT_LIST_DIR}/*.cpp"
)
message(STATUS "Library Sources: ${LIBRARY_SOURCES}")
add_library(${LIBRARY_TARGET} SHARED ${LIBRARY_SOURCES})

target_compile_options(${LIBRARY_TARGET} PRIVATE ${COMPILE_OPTIONS})
set_target_properties(${LIBRARY_TARGET}
    PROPERTIES ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
    LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
    OUTPUT_NAME ${PROJECT_NAME}.${PROJECT_VERSION}
)

target_include_directories(${LIBRARY_TARGET}
    PUBLIC ${PROJECT_HEADER_DIR} # <- use library header
    PRIVATE ${THIRD_PARTY_HEADER_DIR}
            ${CMAKE_CURRENT_LIST_DIR}/include # <- library internal header
)

# check library dependencies
message(STATUS "Library Dependency check")
include(${PROJECT_SOURCE_DIR}/cmake/dependencies/library-deps.cmake)
message(STATUS "Library Dependency check - Success")

# link dependencies
target_link_libraries(${LIBRARY_TARGET}
    # add libary deps libraries
)

# library install
install(
    TARGETS ${LIBRARY_TARGET}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
)

# library header install
install(
    DIRECTORY ${PROJECT_HEADER_DIR}/${LIBRARY_TARGET}
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)

message(STATUS "Library target generating start - Success")


