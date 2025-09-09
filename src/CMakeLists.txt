cmake_minimum_required(VERSION 3.20)
project(MyProject CXX)

# 设置C++17标准
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(OpenCV REQUIRED)  # 现在路径已存在
add_executable(my_app helloopencv.cpp)
target_link_libraries(my_app PRIVATE ${OpenCV_LIBS})