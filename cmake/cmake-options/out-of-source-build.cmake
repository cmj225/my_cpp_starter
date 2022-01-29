#
# out of source build
#
message(STATUS "Out-of-source-build check")
if(PROJECT_SOURCE_DIR STREQUAL PROJECT_BINARY_DIR)
    message(FATAL_ERROR "In-Source Build not allowed")
endif()
message(STATUS "Out-of-source-build check - Success")