defineTest(minQtVersion) {
    maj = $$1
    min = $$2
    patch = $$3
    isEqual(QT_MAJOR_VERSION, $$maj) {
        isEqual(QT_MINOR_VERSION, $$min) {
            isEqual(QT_PATCH_VERSION, $$patch) {
                return(true)
            }
            greaterThan(QT_PATCH_VERSION, $$patch) {
                return(true)
            }
        }
        greaterThan(QT_MINOR_VERSION, $$min) {
            return(true)
        }
    }
    greaterThan(QT_MAJOR_VERSION, $$maj) {
        return(true)
    }
    return(false)
}

!minQtVersion(5, 12, 0) {
    error("minimum supported Qt5 version is 5.12.0")
}

QT += qml quick


#INCLUDEPATH += $$PWD/Src
#判断Qt版本
lessThan(QT_MAJOR_VERSION, 6) {
    include($$PWD/src/Qt5Compat/imports.pri)
} else {
    include($$PWD/src/Qt6Compat/imports.pri)
}

HEADERS += \
    $$PWD/src/LottieQml.hpp

INCLUDEPATH += $$PWD/src
