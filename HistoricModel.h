#ifndef HistoricModel_H
#define HistoricModel_H

#include <QAbstractListModel>
#include "DatabaseHandler.h"

class HistoricModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum Roles {
        IdRole = Qt::UserRole + 1,
        NomeEquipamentoRole,
        DataHoraRole,
        ValorRole,
        PercentualRole
    };

    explicit HistoricModel(DatabaseHandler *db, QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void loadData();

private:
    QList<QVariantMap> m_registros;
    DatabaseHandler m_db;
};

#endif // HistoricModel_H
