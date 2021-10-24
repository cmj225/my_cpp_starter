#
#	Add a target for formating the project using `clang-format` (i.e: cmake --build --target clang-format
#

function(add_clang_format_target)
	if(NOT ${PROJECT_NAME}_CLANG_FORMAT_BINARY)
		find_program(${PROJECT_NAME}_CLANG_FORMAT_BINARY clang-format)
	endif()

	if(${PROJECT_NAME}_CLANG_FORMAT_BINARY)
		add_custom_target(clang-format
			COMMAND ${${PROJECT_NAME}_CLANG_FORMAT_BINARY}
			-i ${CLANG_FORMAT_INPUT}
			WORKING_DIRECTORY ${CMAKE_PROEJCT_SOURCE_DIR})
	else()
		message(STATUS "clang-format requested ... but NOT FOUND")
	endif()
endfunction()

