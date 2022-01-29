#include <iostream>
#include <CppStarter/CppStarter.h>
#include <CppStarterInternal.h>

std::string CppStarter::version() {
  std::string version_str = CPPSTARTER_VERSION;
  CppStarter::InternalSayHello();
  return version_str;
}

void CppStarter::InternalSayHello() {
  std::cout << "hello" << std::endl;
}