CONFIG(debug,debug|release){
    # debug mode use local file
    win32 {
        path=$$system("cd")
        path ~=s,\\\\,/,g
    } else {
        path=$$system("pwd")
    }
    RESOURCES += $$PWD/LottieCompat/LottieCompat.qrc
    LottieCompatImport=\"file:///$$path\"
    #LottleCompatImage=\"file:///$$path/GrayCatQtQuick/Images/\"
    DEFINES += LottieCompatImportPath=\\\"file:///$${path}\\\"
    #DEFINES += LottieCompatImagePath=\\\"file:///$${path}/GrayCatQtQuick/Images/\\\"
} else {
    # release mode use qrc file
    RESOURCES += $$PWD/LottieCompat/LottieCompat.qrc
    # release mode set importPath with 'qrc:///'
    LottieCompatImport=\"qrc:/\"
    #LottleCompatImage=\"qrc:/GrayCatQtQuick/Images/\"
    DEFINES += LottieCompatImportPath=\\\"qrc:///\\\"
    #DEFINES += LottieCompatImagePath=\\\"qrc:/GrayCatQtQuick/Images/\\\"
}

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH	+= $$PWD
QML2_IMPORT_PATH += $$PWD

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH += $$PWD
