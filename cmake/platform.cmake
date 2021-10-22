#
# ---- Plarform Check ----
#

# ---- check platform ----
if (UNIX)
	message(STATUS "Platform: Linux")
elseif (WIN32 OR APPLE OR ANDROID OR IOS)
	# 지원하지 않음
	message(STATUS "No implementation for the platform")
else ()
	message(FATAL_ERROR "Unknown Platform")
endif()

