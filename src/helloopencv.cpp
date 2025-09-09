#include <opencv2/opencv.hpp>
#include <iostream>
#include <filesystem>

int main()
{
    std::cout << "Hello, OpenCV!" << std::endl;
     // 添加内存错误测试
    int arr[10];
    arr[15] = 42;  // 缓冲区溢出 - AddressSanitizer 会检测到
    // 尝试多个可能的图片路径
    std::vector<std::filesystem::path> possible_paths = {
        "test.jpg",  // 当前目录
        std::filesystem::current_path() / "test.jpg",  // 当前目录的绝对路径
        "/Users/leoyao/ws/test/testopencv/test.jpg",  // 项目根目录
        "/Users/leoyao/ws/test/testopencv/build/test.jpg"  // build目录
    };
    
    cv::Mat img;
    std::string found_path;
    
    for (const auto& path : possible_paths) {
        std::cout << "Trying to load image from: " << path << std::endl;
        img = cv::imread(path.string());
        if (!img.empty()) {
            found_path = path.string();
            break;
        }
    }
    
    if (img.empty())
    {
        std::cout << "Could not read the image from any of the tried paths." << std::endl;
        std::cout << "Current working directory: " << std::filesystem::current_path() << std::endl;
        std::cout << "Please make sure test.jpg exists in one of these locations:" << std::endl;
        for (const auto& path : possible_paths) {
            std::cout << "  - " << path << std::endl;
        }
        return -1;
    }
    
    std::cout << "Successfully loaded image from: " << found_path << std::endl;
    cv::imshow("Image", img);
    cv::waitKey(0);
    return 0;
}