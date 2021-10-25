#
# Compiler Flag Handling
#

# ---- debug build flag ----
		set(CLANG_DEBUG_FLAGS
    -O0
    -g3
    -ggdb
    -fPIC
    -fexceptions
    -pthread
    -fcolor-diagnostics)

set(GCC_DEBUG_FLAGS
    -O0
    -g3
    -ggdb
    -fPIC
    -fexceptions
    -pthread
    -fdiagnostics-color=always)

set(MSVC_DEBUG_FLAGS)

# ---- release build flag ----
set(CLANG_RELEASE_FLAGS
    -O3
    -DNDEBUG
    -fPIC
    -fexceptions
    -pthread
    -fcolor-diagnostics)

set(GCC_RELEASE_FLAGS
    -O3
    -DNDEBUG
    -fPIC
    -fexceptions
    -pthread
    -fdiagnostics-color=always)

set(MSVC_RELEASE_FLAGS)
