#include <QQmlApplicationEngine>
#include <QDebug>
#include <QQmlContext>
#include <QQmlEngine>
#include <QQuickView>
#include <QtQuickControls2/qquickstyle.h>
#include <QGuiApplication>

int main(int argc, char *argv[])
{
    //QGuiApplication
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    QCoreApplication::setOrganizationName("CatGrayYa");
    QQmlApplicationEngine engine;
    engine.addImportPath(LottieCompatImportPath);
    const QUrl mainQmlUrl(QStringLiteral("qrc:///tester.qml"));
    const QMetaObject::Connection connection = QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [&mainQmlUrl, &connection](QObject *object, const QUrl &url) {
            if (url != mainQmlUrl) {
                return;
            }
            if (!object) {
                QGuiApplication::exit(-1);
            } else {
                QObject::disconnect(connection);
            }
        },
        Qt::QueuedConnection);

    engine.load(mainQmlUrl);



    return app.exec();
}
