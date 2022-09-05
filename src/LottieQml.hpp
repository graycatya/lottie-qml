#include <QQmlApplicationEngine>
#include <QQmlContext>

namespace LottieQml {

void InitCompat(QQmlApplicationEngine &engine) {
    engine.addImportPath(LottieCompatImportPath);
#ifdef QT_NO_DEBUG
    engine.rootContext()->setContextProperty("lottieQmlDebug", QVariant(false));
#else
    engine.rootContext()->setContextProperty("lottieQmlDebug", QVariant(true));
#endif
}

}


