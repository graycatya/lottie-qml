function(find_lottleqml_pack variable)

find_package(QT NAMES Qt6 Qt5 COMPONENTS Core)

if(${QT_VERSION_MAJOR} STREQUAL "5")
    set(LottieCompatImportPath ${ARGV1}/src/Qt5Compat)
    set(LottieCompatRes ${LottieCompatImportPath}/LottieCompat/LottieCompat.qrc)
else()
    set(LottieCompatImportPath ${ARGV1}/src/Qt6Compat)
    set(LottieCompatRes ${LottieCompatImportPath}/LottieCompat/LottieCompat.qrc)
endif()

if (CMAKE_BUILD_TYPE MATCHES "Release")
    set(LottieCompatImport "qrc:///" )
else()
    set(LottieCompatImport "file:///${LottieCompatImportPath}")
endif()
add_compile_definitions(LottieCompatRes="${LottieCompatRes}")
add_compile_definitions(LottieCompatImport="${LottieCompatImport}")

add_compile_definitions(LottieCompatImportPath="${LottieCompatImport}")

add_compile_definitions(QML_IMPORT_PATH="${LottieCompatImportPath}")
add_compile_definitions(QML2_IMPORT_PATH="${LottieCompatImportPath}")
add_compile_definitions(QML_DESIGNER_IMPORT_PATH="${LottieCompatImportPath}")

set(${variable} ${LottieCompatRes} PARENT_SCOPE)
endfunction(find_lottleqml_pack)
