#
# documentation
#

message(STATUS "Doxygen Requested")

# ---- doxeygen ----
set(DOXYGEN_CALLER_GRAPH YES)
set(DOXYGEN_CALL_GRAPH YES)
set(DOXYGEN_EXTRACT_ALL YES)
set(DOXYGEN_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/docs)

find_package(Doxygen REQUIRED dot)
doxygen_add_docs(doxygen-docs ${PROJECT_SOURCE_DIR})

message(STATUS "Doxygen has been setup and documentation is now available.")

