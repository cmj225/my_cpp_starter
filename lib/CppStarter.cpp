#include <iostream>
#include <CppStarter/CppStarter.h>
#include <CppStarterInternal.h>

namespace cppstarter {
  std::string version() {
    std::string version_str = cppstarter::CPPSTARTER_VERSION;
    return version_str;
  }

  std::string InternalSayHello() {
    return "hello";
  }
}