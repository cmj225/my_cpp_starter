# CppStarter
C++ Project Starter

# Build
cmake -S . -B build
cmake --build build
cmake --build build --target install

# cmake-format
dependencies: pip, cmakelang, pyyaml
	install pip
	pip install cmakelang
	pip install pyyaml

find . \( -name '*.cmake' -o -name 'CMakeLists.txt' \) -exec cmake-format -i {} \;

cmake --build build --target clang-format

# git hooks
- add hook to ${PROJECT_SOURCE_DIR}/hooks}
- pre-installed hooks
  - pre-commit: clang-format foramtting, cmake-format

# statical-analyzer
## clang-tidy
dependencies: macos -> llvm (설치 후 llvm bin path export)
## cppcheck
dependencies: cppcheck

# doxygen
- dependencies
	- doxygen, graphviz
- cmake --build build --target doxygen
- mv html docs

# Unit-test
## cmake --build build --target ctest

## Google Test
- dependencies
	- googletest
## Catch2
- dependencies
	- catch2


