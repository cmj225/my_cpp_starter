#include <spdlog/spdlog.h>
#include <starter/starter.h>

#include <iostream>

int main(int argc, char *argv[]) {
  std::cout << starter::STARTER_VERSION << std::endl;

  spdlog::info("project version: {}", starter::STARTER_VERSION);

  return 0;
}