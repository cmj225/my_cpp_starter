#
# ---- git options setting ----
#

# ---- git hooks ----
if(PROJECT_OPTIONS_ENABLE_GIT_HOOKS)
    # {project_source_dir}/hooks -> hook path setting
    message(STATUS "Git Hook path setting: ${PROJECT_SOURCE_DIR}/hooks")
    execute_process(COMMAND git config core.hooksPath hooks WORKING_DIRECTORY  "${PROJECT_SOURCE_DIR}")
    message(STATUS "Git Hook path setting: ${PROJECT_SOURCE_DIR}/hooks - Success")
endif()

# ---- submodule initialize ----
if(PROJECT_OPTIONS_ENABLE_SUBMODULE_AUTO_INIT_UPDATE)
    message(STATUS "Git Submodule Initialization")
    execute_process(COMMAND git submodule update --init WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}")
    message(STATUS "Git Submodule Initialization - Success")
endif()
