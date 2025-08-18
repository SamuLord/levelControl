#include "AlarmPlayer.h"

AlarmPlayer::AlarmPlayer(QObject *parent)
    : QObject{parent}
{
    audioOutput = new QAudioOutput(this);
    player = new QMediaPlayer(this);

    player->setAudioOutput(audioOutput);
    player->setSource(QUrl::fromLocalFile("D:/Faculdade/uProcessadores/levelControl_Server/Sons/alarm.mp3"));
    player->setLoops(5);
    audioOutput->setVolume(1.0);
}

void AlarmPlayer::startAlarm()
{
    if (player->playbackState() != QMediaPlayer::PlayingState)
        player->play();
}

void AlarmPlayer::stopAlarm()
{
    if (player->playbackState() == QMediaPlayer::PlayingState)
        player->stop();
}
