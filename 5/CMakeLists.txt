cmake_minimum_required(VERSION 3.25)

project(single_channel)
find_package(OpenCV REQUIRED)
include_directories(${OpenCV_INCLUDE_DIRS})

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O0 -ggdb -DC_IMG")

enable_language(ASM_NASM)
set(CMAKE_ASM_NASM_FLAGS_DEBUG "-g")

add_executable(single_channel.out single_channel.cpp single_channel.asm)

target_link_libraries(single_channel.out ${OpenCV_LIBS})