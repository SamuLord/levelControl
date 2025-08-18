#include "DatabaseHandler.h"

DatabaseHandler::DatabaseHandler(QObject *parent)
    : QObject{parent}
{}

bool DatabaseHandler::initDatabase(QString dbPath)
{
    database = QSqlDatabase::addDatabase("QSQLITE");
    database.setDatabaseName(dbPath);

    if (!database.open()) {
        qDebug() << "Erro ao abrir banco:" << database.lastError().text();
        return false;
    }

    QSqlQuery query;
    QString sql = R"(
        CREATE TABLE IF NOT EXISTS registros (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome_equipamento TEXT NOT NULL,
            data_hora TEXT NOT NULL,
            valor REAL,
            percentual REAL
        )
    )";

    if (!query.exec(sql)) {
        qDebug() << "Erro ao criar tabela:" << query.lastError().text();
        return false;
    }

    return true;
}

bool DatabaseHandler::insertData(QString equipamento, QString datahora, double valor, double percentual)
{
    QSqlQuery query;
    query.prepare(R"(
        INSERT INTO registros (nome_equipamento, data_hora, valor, percentual)
        VALUES (:equipamento, :dataHora, :valor, :percentual)
    )");
    query.bindValue(":equipamento", equipamento);
    query.bindValue(":dataHora", datahora);
    query.bindValue(":valor", valor);
    query.bindValue(":percentual", percentual);

    if (!query.exec()) {
        qDebug() << "Erro ao inserir registro:" << query.lastError().text();
        return false;
    }
    return true;
}

QList<QVariantMap> DatabaseHandler::getData()
{
    QList<QVariantMap> list;
    QSqlQuery query("SELECT id, nome_equipamento, data_hora, valor, percentual FROM registros ORDER BY id DESC");

    while (query.next()) {
        QVariantMap row;
        row["id"] = query.value(0);
        row["nome_equipamento"] = query.value(1);
        row["data_hora"] = query.value(2);
        row["valor"] = query.value(3);
        row["percentual"] = query.value(4);
        list.append(row);
    }
    return list;
}
