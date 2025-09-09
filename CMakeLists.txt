cmake_minimum_required(VERSION 3.20)
project(MyProjectSuperbuild)

include(ExternalProject)
include(ProcessorCount)
ProcessorCount(N) # 获取处理器核心数并存储在变量 N 中
message(STATUS "Number of processors: ${N}")
set(OpenCV_INSTALL_DIR ${CMAKE_BINARY_DIR}/opencv-install)

ExternalProject_Add(opencv
    SOURCE_DIR ${CMAKE_SOURCE_DIR}/3rdparty/opencv
    CMAKE_ARGS
        -DCMAKE_INSTALL_PREFIX=${OpenCV_INSTALL_DIR}
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -C ${CMAKE_SOURCE_DIR}/cmake/buildOpenCV.cmake
        -DCMAKE_EXPORT_COMPILE_COMMANDS=${CMAKE_EXPORT_COMPILE_COMMANDS}
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --target install -- -j${N}
    # LOG_BUILD ON
    # LOG_CONFIGURE ON
    # LOG_INSTALL ON
    INSTALL_COMMAND ""  # 已包含在BUILD_COMMAND
)

# 添加主项目作为外部项目，依赖OpenCV
ExternalProject_Add(my_project
    SOURCE_DIR ${CMAKE_SOURCE_DIR}/src
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DOpenCV_DIR=${OpenCV_INSTALL_DIR}/lib/cmake/opencv4  # 传递路径
        -DENABLE_SANITIZERS=${ENABLE_SANITIZERS}  #是否启用优化器
        -DCMAKE_EXPORT_COMPILE_COMMANDS=${CMAKE_EXPORT_COMPILE_COMMANDS}
    DEPENDS opencv  # 确保先构建OpenCV
    INSTALL_COMMAND ""  # 禁用install步骤，因为我们只需要构建
)