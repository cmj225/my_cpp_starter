# CppStarter
C++ Project Starter

# Build
cmake -S . -B build
cmake --build build
cmake --build build --target install

# clang-format custom target
cmake --build build --target clang-format

# git hooks
- add hook to ${PROJECT_SOURCE_DIR}/hooks}
- some hooks pre-installed.
--pre-commit: clang-format foramtting

