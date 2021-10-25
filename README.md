# CppStarter
C++ Project Starter

# Build
cmake -S . -B build
cmake --build build
cmake --build build --target install

# cmake-format
install pip
pip install cmakelang
pip install pyyaml
find . \( -name '*.cmake' -o -name 'CMakeLists.txt' \) -exec cmake-format -i {} \;

# clang-format custom target
cmake --build build --target clang-format

# git hooks
- add hook to ${PROJECT_SOURCE_DIR}/hooks}
- some hooks pre-installed.
  - pre-commit: clang-format foramtting

# doxygen
- dependencies
	- doxygen, graphviz
- cmake --build build --target doxygen
- mv html docs

