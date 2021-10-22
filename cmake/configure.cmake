#
# CMake Configure
#
string(TOLOWER ${PROJECT_NAME} PROJECT_NAME_LOWERCASE)
string(TOUPPER ${PROJECT_NAME} PROJECT_NAME_UPPERCASE)

if (${PROJECT_NAME}_CMAKE_VERBOSE)
	set(CMAKE_VERBOSE_MAKEFILE true)
else()
	set(CMAKE_VERBOSE_MAKEFILE false)
endif()

# --- make version info to header file
set(${PROJECT_NAME}_VERSION       	${PROJECT_VERSION})
set(${PROJECT_NAME}_VERSION_MAJOR 	${PROJECT_VERSION_MAJOR})
set(${PROJECT_NAME}_VERSION_MINOR 	${PROJECT_VERSION_MINOR})
set(${PROJECT_NAME}_VERSION_PATCH 	${PROJECT_VERSION_PATCH})

set(${PROJECT_NAME}_BUILD_TYPE    	${CMAKE_BUILD_TYPE})
set(${PROJECT_NAME}_TARGET_ARCH   	${CMAKE_SYSTEM_PROCESSOR})
set(${PROJECT_NAME}_TARGET_OS     	${CMAKE_SYSTEM})
set(${PROJECT_NAME}_TARGET_NAME   	${CMAKE_SYSTEM_NAME})
set(${PROJECT_NAME}_TARGET_VERSION	${CMAKE_SYSTEM_VERSION})

