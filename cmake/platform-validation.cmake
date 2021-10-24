#
# ---- Plarform Check ----
#

# ---- check platform ----
if (UNIX AND NOT APPLE)
	message(STATUS "Platform: Linux")
elseif (APPLE)
	message(STATUS "Platform: Mac")
elseif (WIN32)
	message(STATUS "Not Supported Platform")
elseif (APPLE)
	message(STATUS "Not Supported Platform")
elseif (ANDROID)
	message(STATUS "Not Supproted Platform")
elseif (IOS)
	message(STATUS "Not Supported Platform")
else ()
	message(FATAL_ERROR "Unknown Platform")
endif()

