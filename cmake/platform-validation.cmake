#
# ---- Plarform Check ----
#

# ---- check platform ----
if(UNIX AND NOT APPLE)
  message(STATUS "Platform: Linux")
  include(GNUInstallDirs)
elseif(APPLE)
  message(STATUS "Platform: Mac")
  include(GNUInstallDirs)
elseif(WIN32)
  message(STATUS "Not Supported Platform")
  message(STATUS "Not Supported Platform")
elseif(ANDROID)
  message(STATUS "Not Supproted Platform")
elseif(IOS)
  message(STATUS "Not Supported Platform")
else()
  message(FATAL_ERROR "Unknown Platform")
endif()
