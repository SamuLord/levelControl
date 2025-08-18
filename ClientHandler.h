#ifndef CLIENTHANDLER_H
#define CLIENTHANDLER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QTimer>

class ClientHandler : public QObject
{
    Q_OBJECT
public:
    explicit ClientHandler(QObject *parent = nullptr);

    Q_INVOKABLE void getData();

    Q_INVOKABLE void sendData(const QJsonObject &obj);

    Q_INVOKABLE void setAccessIP(const QString &newAccessIP);

    Q_INVOKABLE QString getAccessIP();

    Q_INVOKABLE void setIntervalTimer(const QString interval);

    Q_INVOKABLE void handlerTimerRequest(const bool state);

    Q_INVOKABLE bool getForcedRequest() const;

    Q_INVOKABLE void setForcedRequest(bool newForcedRequest);

signals:
    void requestError(const QString &error);

    void responseData(const QJsonObject &response);

private slots:
    void onFinished(QNetworkReply *reply);

    void onTimeoutRequest();

private:
    QNetworkAccessManager manager;

    QString accessIP = QString();

    bool forcedRequest = false;

    QTimer timerRequest;
};

#endif // CLIENTHANDLER_H
