cmake_minimum_required(VERSION 3.10)

project(tester LANGUAGES CXX)

MESSAGE(STATUS "operation system is ${CMAKE_SYSTEM}")

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(QT_QMAKE_EXECUTABLE ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/../../src/)

find_package(QT NAMES Qt5 Qt6 COMPONENTS Core Gui Quick REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Gui Quick REQUIRED)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../..")

include(LottieQml)

find_lottleqml_pack(LottieCompatRes "${CMAKE_CURRENT_SOURCE_DIR}/../..")

add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/../../ LottieQml.out)

if(${QT_VERSION_MAJOR} STREQUAL "5")
    file(GLOB SRC_QRC_LIST "${CMAKE_CURRENT_SOURCE_DIR}/QmlSrc/Qt5Compat/QmlSrc.qrc")
    qt5_add_resources(PROJECT_QRC_FILES ${SRC_QRC_LIST}
                                        ${LottieCompatRes})
else()
    file(GLOB SRC_QRC_LIST "${CMAKE_CURRENT_SOURCE_DIR}/QmlSrc/Qt6Compat/QmlSrc.qrc")
    qt_add_resources(PROJECT_QRC_FILES ${SRC_QRC_LIST}
                                        ${LottieCompatRes})
endif()



add_executable(${PROJECT_NAME}
  ./main.cpp
  ${PROJECT_QRC_FILES}
)

target_link_libraries(${PROJECT_NAME} PRIVATE Qt${QT_VERSION_MAJOR}::Core)
target_link_libraries(${PROJECT_NAME} PRIVATE Qt${QT_VERSION_MAJOR}::Gui)
target_link_libraries(${PROJECT_NAME} PRIVATE Qt${QT_VERSION_MAJOR}::Quick)
target_link_libraries(${PROJECT_NAME} PRIVATE LottieQml)
