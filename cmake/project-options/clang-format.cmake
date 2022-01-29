#
# ---- clang-format setting ----
#
# Add a target for formatting the project using `clang-format` (i.e: cmake --build --target clang-format
#

# ---- find clang-format binary ----
message(STATUS "clang-format support check")
find_program(CLANG_FORMAT_FOUND clang-format)
if(CLANG_FORMAT_FOUND)
    message(STATUS "clang-format support check - Success")
else()
    message(FATAL_ERROR "clang-format binary Not Found")
endif()

# ---- search target files ----
message(STATUS "Create clang-format target")
# @note clang-format target files ...
file(
    GLOB_RECURSE clang-format-cxx-files
    CONFIGURE_DEPENDS
        "${PROJECT_SOURCE_DIR}/include/*.h/include/*.h" # <- project external header
        "${PROJECT_SOURCE_DIR}/src/*.h"     # <- executable internal header
        "${PROJECT_SOURCE_DIR}/src/*.cpp"   # <- executable source
        "${PROJECT_SOURCE_DIR}/lib/*.h"     # <- library internal header
        "${PROJECT_SOURCE_DIR}/lib/*.cpp"   # <- library source
        "${PROJECT_SOURCE_DIR}/test/*.h"     # <- unit-test internal header
        "${PROJECT_SOURCE_DIR}/test/*.cpp"   # <- unit-test source
)
set(CLANG_FORMAT_TARGET_FILES ${clang-format-cxx-files})
message(STATUS "    clang-format target files: ${CLANG_FORMAT_TARGET_FILES}")
message(STATUS "clang-format support check - Success")

function(add_clang_format_target)
    # {CLANG_FORMAT_INPUT} 으로 명시된 파일에 대해 formatter 실행
    add_custom_target(
            clang-format
            COMMAND clang-format -i ${CLANG_FORMAT_TARGET_FILES}
            WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
    )
endfunction()
add_clang_format_target()

message(STATUS "Create clang-format target - Success")
# @note cmake --build build --target clang-format