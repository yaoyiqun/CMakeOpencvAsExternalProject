cmake_minimum_required(VERSION 3.20)  # FetchContent 需要 3.11+，但 3.20+ 更稳定
project(MyProject CXX)

include(FetchContent)
include(${CMAKE_SOURCE_DIR}/cmake/3rdparty_utils.cmake)

# 配置多个3rdparty项目
configure_3rdparty_project(MyProject ade)
# 设置ADE路径
message(STATUS "ADE_DIR: ${MyProject_ade_DIR}")
set(ADE_DIR ${MyProject_ade_DIR})

# 配置OpenCV，使用自定义cmake文件
configure_3rdparty_project(MyProject opencv CMAKE_FILE buildOpenCV.cmake)
# 设置OpenCV路径
set(OpenCV_DIR ${MyProject_opencv_DIR})
find_package(OpenCV REQUIRED)
# 设置C++17标准
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
# 定义选项
option(ENABLE_SANITIZERS "Enable sanitizers" OFF)

if(ENABLE_SANITIZERS)
    # 添加编译器标志
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fsanitize=address -fsanitize=undefined")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fsanitize=address -fsanitize=undefined")
    set(CMAKE_LINKER_FLAGS "${CMAKE_LINKER_FLAGS} -fsanitize=address -fsanitize=undefined")
endif()

# 主目标
add_executable(my_app src/helloopencv.cpp)
target_include_directories(my_app PRIVATE ${OpenCV_DIR}/include)
target_link_libraries(my_app PRIVATE  ${OpenCV_LIBS})