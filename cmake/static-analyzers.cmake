#
# Statical Analyer Setting
#

# ---- check selected linter option valid ----
if (${PROJECT_NAME}_ENABLE_STATICAL_ANALYZER)
	if (${PROJECT_NAME}_ENABLE_CLANG_TIDY AND ${PROJECT_NAME}_ENABLE_CPPCHECK)
		message(FATAL_ERROR "Linter must be selected one!, Too Many Linter is selected ...")
  elseif(NOT ${PROJECT_NAME}_ENABLE_CLANG_TIDY OR NOT ${PROJECT_NAME}_ENABLE_CPPCHECK)
		message(FATAL_ERROR "Linter must be selected one!, Zero Linter is selected ...")
  endif()
endif()

# ---- enable clang-tidy ----
if (${PROJECT_NAME}_ENABLE_CLANG_TIDY)
#	find_program(CLANGTIDY clang-tidy)
#	if (CLANGTIDY)
#		set(CMAKE_CXX_CLANG_TIDY ${CLANGTIDY} -extra-arg=-Wno-unknown-warning-option)
#		message("Clang-Tidy finished setting up.")
#	else()
#		message(SEND_ERROR "Clang-Tidy requested but executable not found.")
#	endif()
endif()

# ---- enable cppcheck ----
if (${PROJECT_NAME}_ENABLE_CPPCHECK)
#	find_program(CPPCHECK cppcheck)
#	if (CPPCHECK)
#		set(CMAKE_CXX_CPPCHECK ${CPPCHECK} --suppress=missingInclude --enable=all
#												   --inline-suppr --inconclusive -i ${CMAKE_SOURCE_DIR}/imgui/lib)
#		message("Cppcheck finished setting up.")
#	else()
#		message(SEND_ERROR "Cppcheck requested but executable not found.")
#	endif()
endif()
