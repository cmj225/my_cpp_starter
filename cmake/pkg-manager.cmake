#
# Pakage Manager Setting
#

# ---- check selected unit-test option valid ----
if(${PROJECT_NAME}_ENABLE_PKG_MANAGER)
  if(NOT ${PROJECT_NAME}_ENABLE_CONAN AND NOT ${PROJECT_NAME}_ENABLE_VCPKG)
    message(FATAL_ERROR "Pakage manager option enabled BUT no manager is selected ...")
  endif()
endif()

# ---- enable conan ----
if(${PROJECT_NAME}_ENABLE_CONAN)
  set(${PROJECT_NAME}_CONAN_REQUIRES "")
  set(${PROJECT_NAME}_CONAN_OPTIONS "")

  if(NOT EXISTS "${CMAKE_BINARY_DIR}/conan.cmake")
    message(STATUS "Downloading conan.cmake from https://github.com/conan-io/cmake-conan")
    file(
      DOWNLOAD "https://raw.githubusercontent.com/conan-io/cmake-conan/v0.16.1/conan.cmake"
      "${CMAKE_BINARY_DIR}/conan.cmake"
      EXPECTED_HASH SHA256=396e16d0f5eabdc6a14afddbcfff62a54a7ee75c6da23f32f7a31bc85db23484
      TLS_VERIFY ON)
  endif()

  include(${CMAKE_BINARY_DIR}/conan.cmake)

  conan_add_remote(
    NAME
    cci
    URL
    https://center.conan.io
    INDEX
    0)
  conan_add_remote(
    NAME
    bincrafters
    URL
    https://bincrafters.jfrog.io/artifactory/api/conan/public-conan)

  conan_cmake_autodetect(settings)

  conan_cmake_run(
    CONANFILE
    conanfile.txt
    BASIC_SETUP
    CMAKE_TARGETS
    BUILD
    missing)
endif()

# ---- enable vcpkg ----
if(${PROJECT_NAME}_ENABLE_VCPKG)
  if(NOT EXISTS "${CMAKE_BINARY_DIR}/vcpkg.cmake")
    message(STATUS "Downloading vcpkg.cmake from https://github.com/microsoft/vcpkg")
    file(DOWNLOAD "https://github.com/microsoft/vcpkg/raw/master/scripts/buildsystems/vcpkg.cmake"
         "${CMAKE_BINARY_DIR}/vcpkg.cmake")
  endif()

  set(CMAKE_TOOLCHAIN_FILE "${CMAKE_TOOLCHAIN_FILE}" "${CMAKE_BINARY_DIR}/vcpkg.cmake")
endif()
