cmake_minimum_required(VERSION 3.14)

project(LottieQml LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)


find_package(QT NAMES Qt5 Qt6 REQUIRED COMPONENTS Core Gui Quick)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Core Gui Quick)

set(LottieQmlPath ${CMAKE_CURRENT_SOURCE_DIR}/Qt${QT_VERSION_MAJOR}Compat)
if (CMAKE_BUILD_TYPE MATCHES "Release")
    set(LottieQmlImport "qrc:/LottieCompat" )
else()
    set(LottieQmlImport "file:///${LottieQmlPath}")
endif()

add_definitions(-DLottieQmlImportPath="${LottieQmlImport}")

if(NOT QML_IMPORT_PATH MATCHES ${LottieQmlPath})
set(QML_IMPORT_PATH 
                    "${QML_IMPORT_PATH}"
                    "${LottieQmlPath}" 
                    CACHE STRING "LottieQml qml import path" FORCE)
set(QML2_IMPORT_PATH 
                    "${QML_IMPORT_PATH}"
                    "${LottieQmlPath}" 
                    CACHE STRING "LottieQml qml2 import path" FORCE)
set(QML_DESIGNER_IMPORT_PATH 
                    "${QML_IMPORT_PATH}"
                    "${LottieQmlPath}" 
                    CACHE STRING "LottieQml qml designer import path" FORCE)
set(CAT_QT_CURRENT_VERSION ${QT_VERSION} CACHE STRING "" FORCE)
endif()

set(QRC_SOURCE_FILES ${CMAKE_CURRENT_SOURCE_DIR}/Qt${QT_VERSION_MAJOR}Compat/LottieCompat/LottieCompat.qrc)
if(${QT_VERSION_MAJOR} GREATER_EQUAL 6)
    qt_add_resources(QML_QRC_RESOURCE ${QRC_SOURCE_FILES})
else(${QT_VERSION_MAJOR} GREATER_EQUAL 6)
    qt5_add_resources(QML_QRC_RESOURCE ${QRC_SOURCE_FILES})
endif(${QT_VERSION_MAJOR} GREATER_EQUAL 6)


add_library(${PROJECT_NAME} STATIC ${QML_QRC_RESOURCE}
                            LottieQmlPlugins.h LottieQmlPlugins.cpp)

target_link_libraries(${PROJECT_NAME}
    PRIVATE
        Qt${QT_VERSION_MAJOR}::Core
        Qt${QT_VERSION_MAJOR}::Gui
        Qt${QT_VERSION_MAJOR}::Quick)

target_include_directories(${PROJECT_NAME} INTERFACE "${CMAKE_CURRENT_SOURCE_DIR}")
