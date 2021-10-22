#
# out of source build
#

# ---- Include guards ----
if (PROJECT_SOURCE_DIR STREQUAL PROJECT_BINARY_DIR)
	message(
		FATAL_ERROR
			"In-source builds not allowd. Please make a new directory (called a build directory) and run CMake from there."
	)
endif()

