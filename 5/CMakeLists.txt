cmake_minimum_required(VERSION 3.25)

project(single_channel)
find_package(OpenCV REQUIRED)
include_directories(${OpenCV_INCLUDE_DIRS})

add_executable(single_channel single_channel.cpp)
target_link_libraries(single_channel ${OpenCV_LIBS})