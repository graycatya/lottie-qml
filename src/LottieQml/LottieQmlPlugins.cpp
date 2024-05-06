#include "LottieQmlPlugins.h"
#include <QQmlApplicationEngine>
#include <QQmlContext>


LottieQmlPlugins::LottieQmlPlugins(QObject *parent)
    : QObject{parent}
{
    Q_INIT_RESOURCE(LottieCompat);
}

void LottieQmlPlugins::InitLottieQmlPlugins(QQmlApplicationEngine * engine)
{
    engine->addImportPath(LottieQmlImportPath);
#ifdef QT_NO_DEBUG
    engine->rootContext()->setContextProperty("lottieQmlDebug", QVariant(false));
#else
    engine->rootContext()->setContextProperty("lottieQmlDebug", QVariant(true));
#endif
}