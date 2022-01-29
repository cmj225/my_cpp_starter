#include <iostream>
#include <CppStarter/CppStarter.h>
#include <CppStarterInternal.h>

namespace CppStarter {
  std::string version() {
    std::string version_str = CPPSTARTER_VERSION;
    return version_str;
  }

  std::string InternalSayHello() {
    return "hello";
  }
}