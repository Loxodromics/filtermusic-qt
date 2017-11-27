//
//  radiostationmanager.h
//  Filtermusic
//
//  Created by philipp on 16.10.2017.
//  Copyright (c) 2017 Philipp Engelhard. All rights reserved.
//
#ifndef FILTERMUSIC_RADIOSTATIONMANAGER_H
#define FILTERMUSIC_RADIOSTATIONMANAGER_H

#include <QObject>
#include <QMap>
#include "radiostation.h"
#include "radiogenre.h"
#include "thirdparty/LFDMobileAudioPlayer/src/lfdaudiomedia.h"

class QJsonArray;

namespace filtermusic {

class RadioStationManager : public QObject
{
	Q_OBJECT
public:

	static RadioStationManager& getInstance()
	{
		static RadioStationManager instance;
		return instance;
	}

	Q_PROPERTY(QString stationName READ stationName NOTIFY stationNameChanged)
	Q_PROPERTY(QString streamUrl READ streamUrl NOTIFY streamUrlChanged)
	Q_PROPERTY(QString logoUrl READ logoUrl NOTIFY logoUrlChanged)
	Q_PROPERTY(QString longDescription READ longDescription NOTIFY longDescriptionChanged)
	Q_PROPERTY(QString title READ title NOTIFY titleChanged)
	Q_PROPERTY(bool liked READ liked NOTIFY likedChanged)

	void parseRadioStationsJson(QJsonArray& jsonArray);
	void parseRadioGenresJson(QJsonArray& jsonArray);
	void insertRadioStation(RadioStation* radioStation);
	void updateRadioStation(RadioStation* radioStation);
	void insertRadioGenre(RadioGenre* radioGenre);

	void printStations() const;
	QList<RadioStation*> allRadioStations();
	QList<RadioGenre*> allRadioGenres();
	qint32 numberOfGenres();
	qint32 numberOfStationsInCategory(qint32 categoryId);
	RadioGenre* radioGenreAtPosition(qint32 position);
	RadioStation* radioStationAtPosition(qint32 position, qint32 categoryId);
	QList<RadioStation*> favoriteRadioStations();
	RadioStation* favoriteRadioStationAtPosition(qint32 position);
	qint32 numberOfFavoriteStations();

	QList<RadioStation*> recentRadioStations();
	RadioStation* recentRadioStationAtPosition(qint32 position);
	qint32 numberOfRecentStations();

	Q_INVOKABLE qint32 currentCategory() const;
	Q_INVOKABLE void setCurrentCategory(const qint32& currentCategory);
	Q_INVOKABLE void setStation(const QString uid);
	Q_INVOKABLE void toggleLiked();

	QString stationName() const;
	QString streamUrl() const;
	QString logoUrl() const;
	QString longDescription() const;
	QString title() const;
	LFD::AudioMedia* currentAudioMedia();
	bool liked() const;

	RadioStation* getCurrentRadioStation() const;
	void setCurrentRadioStation(RadioStation* currentRadioStation);
	void setLastPlayedStation();

public slots:
	void setStationName(QString stationName);
	void setStreamUrl(QString streamUrl);
	void setLogoUrl(QString logoUrl);
	void setLongDescription(QString longDescription);
	void setCurrentAudioMedia(QString uid);
	void setTitle(QString title);
	void startedPlayingStation();
	void stoppedPlayingStation();
	void nextStation();
	void previousStation();
	void setLiked(bool liked);

signals:
	void stationNameChanged(QString stationName);
	void streamUrlChanged(QString streamUrl);
	void logoUrlChanged(QString logoUrl);
	void longDescriptionChanged(QString longDescription);
	void currentAudioMediaChanged(LFD::AudioMedia* audioMedia);
	void titleChanged(QString title);
	void likedChanged(bool liked);

protected:
	QMap<QString, RadioStation*> m_radioStations;
	QMap<qint32, RadioGenre*> m_radioGenres;
	qint32 m_currentCategory;
	RadioStation* m_currentRadioStation;
	QString m_stationName;
	QString m_streamUrl;
	QString m_logoUrl;
	QString m_longDescription;
	LFD::AudioMedia* m_currentAudioMedia;
	QString m_title;
	bool m_liked;

private:
	RadioStationManager(QObject* parent = 0);
	RadioStationManager(RadioStationManager const&);
	void operator =(RadioStationManager const&);
};

} /// namespace filtermusic

#endif /// FILTERMUSIC_RADIOSTATIONMANAGER_H
