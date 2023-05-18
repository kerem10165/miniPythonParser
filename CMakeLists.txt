cmake_minimum_required(VERSION 3.14)

project(miniPythonParser CXX)

set(CMAKE_CXX_FLAGS "-O3")
set (CMAKE_CXX_STANDARD 17)

add_subdirectory(src)


add_executable(${PROJECT_NAME} main.cpp)


target_link_libraries(${PROJECT_NAME} parse)


file(COPY test DESTINATION ${PROJECT_BINARY_DIR})