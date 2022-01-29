#
# ---- platform validation
#
message(STATUS "Platform Support Check")
if(UNIX AND NOT APPLE)
    set(CURRENT_PLATFORM LINUX)
    include(GNUInstallDirs)
elseif(APPLE)
    set(CURRENT_PLATFORM MAC)
    include(GNUInstallDirs)
else()
    message(FATAL_ERROR "NOT TARGETED PLATFORM")
endif()
message(STATUS "Platform: ${CURRENT_PLATFORM}")
message(STATUS "Platform Support Check - Success")