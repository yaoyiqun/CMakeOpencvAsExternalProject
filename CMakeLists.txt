cmake_minimum_required(VERSION 3.20)  # FetchContent 需要 3.11+，但 3.20+ 更稳定
project(MyProject CXX)

include(FetchContent)
#声明ADE(指向本地submodule)
FetchContent_Declare(
    ade
    SOURCE_DIR ${CMAKE_SOURCE_DIR}/3rdparty/ade
)
FetchContent_MakeAvailable(ade)
set(ADE_DIR ${CMAKE_BINARY_DIR}/_deps/ade-build)
#声明OpenCV(指向本地submodule)
include(${CMAKE_SOURCE_DIR}/cmake/buildOpenCV.cmake)
# 声明 OpenCV（指向本地 submodule）
FetchContent_Declare(
    opencv
    SOURCE_DIR ${CMAKE_SOURCE_DIR}/3rdparty/opencv  # 直接用本地路径，无需 GIT_REPOSITORY
    #GIT_SUBMODULES ""  # 可选：空表示不递归更新子模块；或指定特定子模块
    # 如果需要更新 submodule，可添加 GIT_REPOSITORY 但优先本地
)

# Populate 并使可用（这会 add_subdirectory(${opencv_SOURCE_DIR} ${opencv_BINARY_DIR})）
FetchContent_MakeAvailable(opencv)

# 现在 OpenCV 已集成，直接 find_package 或链接目标
set(OpenCV_DIR ${CMAKE_BINARY_DIR}/_deps/opencv-build)
find_package(OpenCV REQUIRED)  # OpenCV 会生成自己的 config 文件
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

target_link_libraries(my_app PRIVATE  ${OpenCV_LIBS})