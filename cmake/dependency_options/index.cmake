#
# ---- dependency target handling ----
#
set({DependencyOptions_SRC_DIR ${CMAKE_CURRENT_LIST_DIR}/src)

# add libdeps pkgconfig path to pkg-config search path
#set(ENV{PKG_CONFIG_PATH}
#  "${CMAKE_INSTALL_PREFIX}/lib/pkgconfig:$ENV{PKG_CONFIG_PATH}:${PROJECT_SOURCE_DIR}/libdeps/lib/pkgconfig")

# load pkg-config module
find_package(PkgConfig REQUIRED)

#
# option parse macro Params:
#
macro(dependency_options)
  set(options
      BOOST
      FMT
      SPDLOG
      FFMPEG)
  set(oneValueArgs)
  set(multiValueArgs)

  cmake_parse_arguments(
    DependencyOptions # <- <prefix>
    "${options}" # <- <prefix>_{option} : {TRUE | FALSE}
    "${oneValueArgs}" # <- <prefix>_{option} : one value
    "${multiValueArgs}" # <- <prefix>_{option} : multi value
    ${ARGN})

  if(${DependencyOptions_UNPARSED_ARGUMENTS})
    message(FATAL_ERROR "Unparsed Option Requested: ${DependencyOptions_UNPARSED_ARGUMENTS}")
  endif()

  if(${DependencyOptions_BOOST})
    enable_boost()
  endif()

  if(${DependencyOptions_FMT})
    enable_fmt()
  endif()

  if(${DependencyOptions_SPDLOG})
    enable_spdlog()
  endif()

  if(${DependencyOptions_FFMPEG})
    enable_ffmpeg()
  endif()
endmacro()

#
# check dependencies
#

# boost
# @todo: flag에 따라 component variable 만들어 로딩
macro(enable_boost)
  message(STATUS "Find boost package")
  find_package(
    Boost REQUIRED CONFIG
    COMPONENTS program_options
               coroutine
               PATHS
               ${PROJECT_SOURCE_DIR}/libdeps/lib/cmake/Boost-1.78.0)
  #message(STATUS "!! ${Boost_LIBRARIES}")
  # link target -> ${Boost_LIBRARIES}
  message(STATUS "Find boost package - Success")
endmacro()

# fmt
macro(enable_fmt)
  message(STATUS "Find fmt package")
  find_package(
    fmt
    REQUIRED
    CONFIG
    PATHS
    ${PROJECT_SOURCE_DIR}/libdeps/lib/cmake/fmt)
  #message(STATUS "!! ${fmt_LIBRARIES}")
  # link target -> ${fmt_LIBRARIES}
  message(STATUS "Find fmt package - Success")
endmacro()

# spdlog
macro(enable_spdlog)
  message(STATUS "Find spdlog package")
  find_package(
    spdlog
    REQUIRED
    CONFIG
    PATHS
    ${PROJECT_SOURCE_DIR}/libdeps/lib/cmake/spdlog)
  # link target -> spdlog::spdlog, spdlog::spdlog_header_only
endmacro()

# ffmpeg
macro(enable_ffmpeg)
  message(STATUS "Find ffmpeg package")
  pkg_check_modules(
    ffmpeg
    REQUIRED
    IMPORTED_TARGET
    GLOBAL
    libavdevice
    libavfilter
    libavformat
    libavcodec
    libswresample
    libswscale
    libavutil)
  # link target -> PkgConfig::ffmpeg
  message(STATUS "Find ffmpeg package - Success")
endmacro()
