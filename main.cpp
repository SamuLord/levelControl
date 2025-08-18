#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtQuickControls2/QQuickStyle>
#include <QDir>
#include <QDebug>

#include "ClientHandler.h"
#include "HistoricModel.h"
#include "AlarmPlayer.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    ClientHandler *clientHandler = new ClientHandler();
    engine.rootContext()->setContextProperty("ClientHandler", clientHandler);

    DatabaseHandler db;
    db.initDatabase("D:/Faculdade/uProcessadores/database/levelControl_data.db");
    engine.rootContext()->setContextProperty("dbHandler", &db);

    HistoricModel model(&db);
    engine.rootContext()->setContextProperty("historicModel", &model);

    AlarmPlayer ap;
    engine.rootContext()->setContextProperty("alarmPlayer", &ap);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
