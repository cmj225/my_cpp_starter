# 현재 디렉토리에 있는 모든 파일을 SRC_FILES 변수에 추가한다.
file(
  GLOB_RECURSE
  SRC_FILES
  CONFIGURE_DEPENDS
  ${CMAKE_CURRENT_LIST_DIR}/*.cc)

# target 추가
add_library(${PROJECT_NAME} SHARED ${SRC_FILES})

# include path 지정
file(
  GLOB_RECURSE
  ${PROJECT_NAME}_PUBLIC_HEADERS
  CONFIGURE_DEPENDS
  ${PROJECT_SOURCE_DIR}/include/*.h)
target_include_directories(${PROJECT_NAME} PUBLIC ${PROJECT_SOURCE_DIR}/include)
set_target_properties(${PROJECT_NAME} PROPERTIES PUBLIC_HEADER "${${PROJECT_NAME}_PUBLIC_HEADERS}")

# dependency 설정
set(LIBRARY_DEPENDENCIES spdlog::spdlog)
message(STATUS "${PROJECT_NAME} dependencies -> ${LIBRARY_DEPENDENCIES}")
target_link_libraries(
  ${PROJECT_NAME}
  PRIVATE project_options project_warnings
  PUBLIC ${LIBRARY_DEPENDENCIES})

# 라이브러리 파일은 lib 폴더에 출력
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${PROJECT_NAME}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${PROJECT_NAME}/lib)

# library, public header install
install(TARGETS ${PROJECT_NAME} PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_PREFIX}/include/${PROJECT_NAME})
