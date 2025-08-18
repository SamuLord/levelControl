#include "HistoricModel.h"

HistoricModel::HistoricModel(DatabaseHandler *db, QObject *parent)
    : QAbstractListModel(parent), m_db(db)
{
}

int HistoricModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid()) return 0;
    return m_registros.size();
}

QVariant HistoricModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_registros.size()) return {};

    const auto &registro = m_registros.at(index.row());

    switch (role) {
        case IdRole: return registro["id"];
        case NomeEquipamentoRole: return registro["nome_equipamento"];
        case DataHoraRole: return registro["data_hora"];
        case ValorRole: return registro["valor"];
        case PercentualRole: return registro["percentual"];
    }
    return {};
}

QHash<int, QByteArray> HistoricModel::roleNames() const
{
    return {
        { IdRole, "id" },
        { NomeEquipamentoRole, "nome_equipamento" },
        { DataHoraRole, "data_hora" },
        { ValorRole, "valor" },
        { PercentualRole, "percentual" }
    };
}

void HistoricModel::loadData()
{
    beginResetModel();
    m_registros = m_db.getData();
    endResetModel();
}
