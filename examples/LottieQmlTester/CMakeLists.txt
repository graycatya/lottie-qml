cmake_minimum_required(VERSION 3.10)

project(LottieQmlTester LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(QT_QMAKE_EXECUTABLE ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(QT NAMES Qt5 Qt6 COMPONENTS Core Gui Quick REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Gui Quick REQUIRED)


if(${QT_VERSION_MAJOR} STREQUAL "5")
    file(GLOB SRC_QRC_LIST "${CMAKE_CURRENT_SOURCE_DIR}/QmlSrc/Qt5Compat/QmlSrc.qrc")
    qt5_add_resources(PROJECT_QRC_FILES ${SRC_QRC_LIST})
else()
    file(GLOB SRC_QRC_LIST "${CMAKE_CURRENT_SOURCE_DIR}/QmlSrc/Qt6Compat/QmlSrc.qrc")
    qt_add_resources(PROJECT_QRC_FILES ${SRC_QRC_LIST})
endif()

set(PROJECT_SOURCES
  main.cpp
  ${PROJECT_QRC_FILES}
)

if(${QT_VERSION_MAJOR} GREATER_EQUAL 6)
    qt_add_executable(${PROJECT_NAME}
        MANUAL_FINALIZATION
        ${PROJECT_SOURCES}
    )
# Define target properties for Android with Qt 6 as:
#    set_property(TARGET ${PROJECT_NAME} APPEND PROPERTY QT_ANDROID_PACKAGE_SOURCE_DIR
#                 ${CMAKE_CURRENT_SOURCE_DIR}/android)
# For more information, see https://doc.qt.io/qt-6/qt-add-executable.html#target-creation
else()
    if(ANDROID)
        add_library(${PROJECT_NAME} SHARED
            ${PROJECT_SOURCES}
        )
# Define properties for Android with Qt 5 after find_package() calls as:
#    set(ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android")
    else()
        add_executable(${PROJECT_NAME}
          ${PROJECT_SOURCES}
        )
    endif()
endif()


target_link_libraries(${PROJECT_NAME} PRIVATE
    Qt${QT_VERSION_MAJOR}::Core
    Qt${QT_VERSION_MAJOR}::Gui
    Qt${QT_VERSION_MAJOR}::Quick
    LottieQml)

