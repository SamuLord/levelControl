#ifndef ALARMPLAYER_H
#define ALARMPLAYER_H

#include <QObject>
#include <QMediaPlayer>
#include <QAudioOutput>

class AlarmPlayer : public QObject
{
    Q_OBJECT
public:
    explicit AlarmPlayer(QObject *parent = nullptr);

    Q_INVOKABLE void startAlarm();

    Q_INVOKABLE void stopAlarm();

private:
    QMediaPlayer *player;
    QAudioOutput *audioOutput;

signals:
};

#endif // ALARMPLAYER_H
