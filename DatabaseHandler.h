#ifndef DATABASEHANDLER_H
#define DATABASEHANDLER_H

#include <QObject>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QVariant>
#include <QDebug>

class DatabaseHandler : public QObject
{
    Q_OBJECT
public:
    explicit DatabaseHandler(QObject *parent = nullptr);
    bool initDatabase(QString dbPath);
    Q_INVOKABLE bool insertData(QString equipamento, QString datahora, double valor, double percentual);
    QList<QVariantMap> getData();

private:
    QSqlDatabase database;

signals:
};

#endif // DATABASEHANDLER_H
