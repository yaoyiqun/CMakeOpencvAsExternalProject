# 3rdparty_utils.cmake
# 通用函数：配置3rdparty目录下的任意项目

# 通用函数：配置3rdparty目录下的任意项目
function(configure_3rdparty_project PROJECT_NAME THIRDPARTY_NAME)
    # 解析可选参数
    set(oneValueArgs CMAKE_FILE)
    
    # 检查3rdparty目录是否存在
    set(THIRDPARTY_SOURCE_DIR ${CMAKE_SOURCE_DIR}/3rdparty/${THIRDPARTY_NAME})
    if(NOT EXISTS ${THIRDPARTY_SOURCE_DIR})
        message(FATAL_ERROR "3rdparty project '${THIRDPARTY_NAME}' not found in ${THIRDPARTY_SOURCE_DIR}")
    endif()
    
    # 设置项目特定的构建目录
    set(${PROJECT_NAME}_${THIRDPARTY_NAME}_BUILD_DIR ${CMAKE_BINARY_DIR}/${PROJECT_NAME}-${THIRDPARTY_NAME}-build)
    set(${PROJECT_NAME}_${THIRDPARTY_NAME}_INSTALL_DIR ${CMAKE_BINARY_DIR}/${PROJECT_NAME}-${THIRDPARTY_NAME}-install)
    
    # 准备CMAKE_ARGS
    set(CMAKE_ARGS_LIST
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${${PROJECT_NAME}_${THIRDPARTY_NAME}_INSTALL_DIR}
    )
    
    # 添加自定义CMAKE_FILE（如果提供）
    if(CMAKE_FILE)
        set(CMAKE_FILE_PATH ${CMAKE_SOURCE_DIR}/cmake/${CMAKE_FILE})
        if(EXISTS ${CMAKE_FILE_PATH})
            list(APPEND CMAKE_ARGS_LIST -C ${CMAKE_FILE_PATH})
        else()
            message(WARNING "Custom cmake file not found: ${CMAKE_FILE_PATH}")
        endif()
    endif()
    
    # 声明并配置项目
    FetchContent_Declare(
        ${PROJECT_NAME}_${THIRDPARTY_NAME}
        SOURCE_DIR ${THIRDPARTY_SOURCE_DIR}
        BINARY_DIR ${${PROJECT_NAME}_${THIRDPARTY_NAME}_BUILD_DIR}
        INSTALL_DIR ${${PROJECT_NAME}_${THIRDPARTY_NAME}_INSTALL_DIR}
        CMAKE_ARGS ${CMAKE_ARGS_LIST}
    )
    
    # 使项目可用
    FetchContent_MakeAvailable(${PROJECT_NAME}_${THIRDPARTY_NAME})
    
    # 设置项目特定的路径
    set(${PROJECT_NAME}_${THIRDPARTY_NAME}_DIR ${${PROJECT_NAME}_${THIRDPARTY_NAME}_BUILD_DIR} PARENT_SCOPE)
    set(${PROJECT_NAME}_${THIRDPARTY_NAME}_BUILD_DIR ${${PROJECT_NAME}_${THIRDPARTY_NAME}_BUILD_DIR} PARENT_SCOPE)
    set(${PROJECT_NAME}_${THIRDPARTY_NAME}_INSTALL_DIR ${${PROJECT_NAME}_${THIRDPARTY_NAME}_INSTALL_DIR} PARENT_SCOPE)
    
    message(STATUS "Configured ${THIRDPARTY_NAME} for project ${PROJECT_NAME}")
    message(STATUS "  Build dir: ${${PROJECT_NAME}_${THIRDPARTY_NAME}_BUILD_DIR}")
    message(STATUS "  Install dir: ${${PROJECT_NAME}_${THIRDPARTY_NAME}_INSTALL_DIR}")
endfunction()

# 通用函数：配置多个3rdparty项目
function(configure_multiple_3rdparty_projects PROJECT_NAME)
    set(THIRDPARTY_PROJECTS ${ARGN})
    foreach(THIRDPARTY_NAME ${THIRDPARTY_PROJECTS})
        configure_3rdparty_project(${PROJECT_NAME} ${THIRDPARTY_NAME})
    endforeach()
endfunction()

# 通用函数：获取3rdparty项目的配置
function(get_3rdparty_config PROJECT_NAME THIRDPARTY_NAME)
    set(${PROJECT_NAME}_${THIRDPARTY_NAME}_DIR ${${PROJECT_NAME}_${THIRDPARTY_NAME}_DIR} PARENT_SCOPE)
    set(${PROJECT_NAME}_${THIRDPARTY_NAME}_BUILD_DIR ${${PROJECT_NAME}_${THIRDPARTY_NAME}_BUILD_DIR} PARENT_SCOPE)
    set(${PROJECT_NAME}_${THIRDPARTY_NAME}_INSTALL_DIR ${${PROJECT_NAME}_${THIRDPARTY_NAME}_INSTALL_DIR} PARENT_SCOPE)
endfunction()
