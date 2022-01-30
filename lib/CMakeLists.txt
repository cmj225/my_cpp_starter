# 현재 디렉토리에 있는 모든 파일을 SRC_FILES 변수에 추가한다.
file(
  GLOB_RECURSE
  SRC_FILES
  CONFIGURE_DEPENDS
  ${CMAKE_CURRENT_LIST_DIR}/*.cc)

add_library(${PROJECT_NAME} STATIC ${SRC_FILES})

# 라이브러리 파일은 빌드 디렉토리 안에 lib 폴더에 출력
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${PROJECT_NAME}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${PROJECT_NAME}/lib)

# include path 지정
target_include_directories(
  ${PROJECT_NAME}
  PUBLIC ${PROJECT_SOURCE_DIR}/include
  PRIVATE ${CMAKE_SOURCE_DIR}/libdeps/include)

target_link_libraries(${PROJECT_NAME} PRIVATE project_options project_warnings)
