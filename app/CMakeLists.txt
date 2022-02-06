# 현재 디렉토리에 있는 모든 파일을 SRC_FILES 변수에 추가한다.
file(
  GLOB_RECURSE
  SRC_FILES
  CONFIGURE_DEPENDS
  ${CMAKE_CURRENT_LIST_DIR}/*.cc)

# target 추가
set(APP_NAME "${PROJECT_NAME}_app") # starter_app
add_executable(${APP_NAME} ${SRC_FILES})

# include path 지정
target_include_directories(${APP_NAME} PUBLIC ${CMAKE_SOURCE_DIR}/include)

# dependency 설정
add_dependencies(${APP_NAME} ${PROJECT_NAME}) # depends on starter
set(${APP_NAME}_DEPENDENCIES ${PROJECT_NAME})
message(STATUS "${APP_NAME} dependencies -> ${${APP_NAME}_DEPENDENCIES}")
target_link_libraries(${APP_NAME} PUBLIC project_options project_warnings ${${APP_NAME}_DEPENDENCIES})

# 실행 파일은 빌드 디렉토리 안에 bin 폴더에 출력
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

# app install
install(TARGETS ${APP_NAME})
