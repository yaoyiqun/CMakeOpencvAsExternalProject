# OpenCV 项目构建示例

这是一个使用CMake构建OpenCV的完整示例项目，展示了如何从源码编译OpenCV并创建依赖它的应用程序。

## 项目结构

```
testopencv/
├── CMakeLists.txt              # 主CMake配置文件（Superbuild模式）
├── src/                        # 主项目源码目录
│   ├── CMakeLists.txt         # 主项目CMake配置
│   └── helloopencv.cpp        # 主程序源码
├── cmake/                      # CMake配置文件
│   └── buildOpenCV.cmake      # OpenCV构建配置
├── 3rdparty/                   # 第三方库源码
│   ├── opencv/                # OpenCV源码
│   └── ade/                   # ADE库源码
├── build/                      # 构建目录（生成）
│   ├── opencv-install/        # OpenCV安装目录
│   └── my_project-prefix/     # 主项目构建目录
└── test.jpg                   # 测试图片
```

## 主要特性

- **从源码编译OpenCV**：使用ExternalProject_Add从源码构建OpenCV
- **Superbuild模式**：主CMakeLists.txt管理整个构建过程
- **智能路径解析**：程序能自动找到图片文件，无论从哪个目录运行
- **跨平台兼容**：支持macOS、Linux等平台
- **模块化配置**：通过配置文件控制OpenCV的构建选项

## 构建流程

### 1. 环境要求

- CMake 3.20+
- C++17 兼容编译器
- macOS: Xcode Command Line Tools
- Linux: build-essential

### 2. 构建步骤

```bash
# 1. 克隆或下载项目
git clone <repository-url>
cd testopencv

# 2. 创建构建目录
mkdir build && cd build

# 3. 配置项目
cmake ..

# 4. 编译（会自动编译OpenCV和主程序）
ninja
# 或者使用 make -j4
```

### 3. 运行程序

```bash
# 在构建目录中运行
cd build/my_project-prefix/src/my_project-build
./my_app

# 或者从任何目录运行（程序会智能查找图片）
/path/to/build/my_project-prefix/src/my_project-build/my_app
```

## 技术细节

### CMake配置

#### 主CMakeLists.txt
- 使用Superbuild模式管理整个项目
- 通过ExternalProject_Add分别构建OpenCV和主项目
- 确保正确的依赖顺序

#### OpenCV配置 (cmake/buildOpenCV.cmake)
```cmake
set(CMAKE_BUILD_TYPE "Release" CACHE STRING "")
set(BUILD_opencv_world ON CACHE BOOL "")
set(BUILD_TESTS OFF CACHE BOOL "")
set(BUILD_PERF_TESTS OFF CACHE BOOL "")
set(WITH_CUDA OFF CACHE BOOL "")
set(WITH_GAPI OFF CACHE BOOL "")
```

#### 主项目配置 (src/CMakeLists.txt)
```cmake
cmake_minimum_required(VERSION 3.20)
project(MyProject CXX)

# 设置C++17标准
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(OpenCV REQUIRED)
add_executable(my_app helloopencv.cpp)
target_link_libraries(my_app PRIVATE ${OpenCV_LIBS})
```

### 程序特性

#### 智能图片路径解析
程序会按以下顺序尝试查找图片文件：
1. 当前目录的 `test.jpg`
2. 当前目录的绝对路径
3. 项目根目录的 `test.jpg`
4. build目录的 `test.jpg`

#### 错误处理
- 详细的路径尝试信息
- 清晰的错误提示
- 当前工作目录显示

## 构建输出

构建完成后，主要文件位于：
- **OpenCV库**: `build/opencv-install/lib/`
- **OpenCV头文件**: `build/opencv-install/include/opencv4/`
- **可执行文件**: `build/my_project-prefix/src/my_project-build/my_app`

## 常见问题

### Q: 为什么程序在Finder中双击运行找不到图片？
A: 这是因为工作目录不同。程序已经实现了智能路径解析，会自动尝试多个可能的图片路径。

### Q: 如何修改OpenCV的构建选项？
A: 编辑 `cmake/buildOpenCV.cmake` 文件，添加或修改相应的CMake变量。

### Q: 如何添加新的源文件？
A: 在 `src/CMakeLists.txt` 中的 `add_executable` 命令中添加新的源文件。

### Q: 构建失败怎么办？
A: 检查以下几点：
1. 确保安装了所有依赖项
2. 检查网络连接（某些依赖需要下载）
3. 查看构建日志中的具体错误信息
4. 尝试清理构建目录重新构建

## 依赖项

- **OpenCV 4.12.0**: 计算机视觉库
- **libjpeg-turbo**: JPEG图像处理
- **libpng**: PNG图像处理
- **libtiff**: TIFF图像处理
- **FFmpeg**: 视频处理（可选）
- **Eigen**: 线性代数库

## 许可证

本项目仅用于学习和演示目的。OpenCV使用Apache 2.0许可证。

## 贡献

欢迎提交Issue和Pull Request来改进这个项目！

---

**注意**: 首次构建可能需要较长时间，因为需要从源码编译OpenCV。后续构建会更快。
