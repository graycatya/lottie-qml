cmake_minimum_required(VERSION 3.14)

project(LottieQml LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)


message(STATUS ${CMAKE_CURRENT_SOURCE_DIR})

set(STATIC_NAME ${PROJECT_NAME}_static)

find_package(QT NAMES Qt5 Qt6 COMPONENTS Core Gui Quick REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Gui Quick REQUIRED)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}")

include(LottieQml)

find_lottleqml_pack(LottieCompatRes "${CMAKE_CURRENT_SOURCE_DIR}")
if(${QT_VERSION_MAJOR} STREQUAL "5")
    message("Littie res: " ${LottieCompatRes})
    qt5_add_resources(PROJECT_QRC_FILES ${LottieCompatRes})
else()
    message("Littie res: " ${LottieCompatRes})
    qt_add_resources(PROJECT_QRC_FILES ${LottieCompatRes})
endif()


add_library(${STATIC_NAME} STATIC ./src/LottieQml.hpp
                                    ${PROJECT_QRC_FILES})

add_library(${PROJECT_NAME} SHARED ./src/LottieQml.hpp
                                    ${PROJECT_QRC_FILES})

SET_TARGET_PROPERTIES(${STATIC_NAME} PROPERTIES OUTPUT_NAME ${PROJECT_NAME})
SET_TARGET_PROPERTIES(${PROJECT_NAME} PROPERTIES VERSION 1.0.0 SOVERSION 1)
SET_TARGET_PROPERTIES(${STATIC_NAME} PROPERTIES CLEAN_DIRECT_OUTPUT 1)

target_link_libraries(${PROJECT_NAME} PRIVATE Qt${QT_VERSION_MAJOR}::Core)
target_link_libraries(${PROJECT_NAME} PRIVATE Qt${QT_VERSION_MAJOR}::Gui)
target_link_libraries(${PROJECT_NAME} PRIVATE Qt${QT_VERSION_MAJOR}::Quick)


target_link_libraries(${STATIC_NAME} PRIVATE Qt${QT_VERSION_MAJOR}::Core)
target_link_libraries(${STATIC_NAME} PRIVATE Qt${QT_VERSION_MAJOR}::Gui)
target_link_libraries(${STATIC_NAME} PRIVATE Qt${QT_VERSION_MAJOR}::Quick)

target_compile_definitions(${PROJECT_NAME} PRIVATE LOTTIEQML_LIBRARY)
