#pragma once

#include <QObject>

class QQmlApplicationEngine;

class LottieQmlPlugins : public QObject
{
    Q_OBJECT
public:
    explicit LottieQmlPlugins(QObject *parent = nullptr);

    void InitLottieQmlPlugins(QQmlApplicationEngine * engine);
signals:
};