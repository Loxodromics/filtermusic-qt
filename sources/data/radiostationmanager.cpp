//
//  radiostationmanager.cpp
//  Filtermusic
//
//  Created by philipp on 16.10.2017.
//  Copyright (c) 2017 Philipp Engelhard. All rights reserved.
//
#include "radiostationmanager.h"
#include "sources/network/networkaccessmanager.h"
#include "sources/commons/constants.h"
#include <QJsonArray>
#include <QJsonObject>
#include <QTimer>
#include <limits.h>
#include <QDebug>

namespace filtermusic {

RadioStationManager::RadioStationManager(QObject* parent)
	: QObject(parent),
	  m_radioStations(),
	  m_radioGenres(),
	  m_currentCategory(-1),
	  m_currentRadioStation(nullptr),
	  m_stationName("Select Station"),
	  m_streamUrl(""),
	  m_logoUrl("qrc:/resources/icons/no_station.png"),
	  m_longDescription(""),
	  m_currentAudioMedia(),
	  m_liked(false)
{
	connect( &NetworkAccessManager::getInstance(), SIGNAL(urlReached(QString,bool)),
			 this, SLOT(stationReachable(QString,bool)));
}

void RadioStationManager::parseRadioStationsJson(QJsonArray& jsonArray)
{
	RadioStation* radioStation = nullptr;

	QJsonArray::iterator it;

	for ( it = jsonArray.begin(); it != jsonArray.end(); it++ )
	{
		if ( (*it).isObject() )
		{
			QJsonObject json = (*it).toObject();
			radioStation = RadioStation::fromJson(json, this);

			if ( this->m_radioStations.contains(radioStation->uid()) )
			{
				this->updateRadioStation(radioStation);
			}
			else
			{
				this->insertRadioStation(radioStation);
			}
		}
	}
}

void RadioStationManager::parseRadioGenresJson(QJsonArray& jsonArray)
{
	this->m_radioGenres.clear();
	RadioGenre* radioGenre = nullptr;

	QJsonArray::iterator it;

	for ( it = jsonArray.begin(); it != jsonArray.end(); it++ )
	{
		if ( (*it).isObject() )
		{
			QJsonObject json = (*it).toObject();
			radioGenre = RadioGenre::fromJson(json, this);

			this->insertRadioGenre(radioGenre);
//			qDebug() << "radioGenre: " << radioGenre->name() << radioGenre->position();
		}
	}
}

void RadioStationManager::printStations() const
{
	for (RadioGenre* radioGenre : this->m_radioGenres)
	{
		qDebug() << radioGenre->toString();
	}
}

QList<RadioStation*> RadioStationManager::allRadioStations()
{
	return this->m_radioStations.values();
}

QList<RadioGenre*> RadioStationManager::allRadioGenres()
{
	return this->m_radioGenres.values();
}

qint32 RadioStationManager::numberOfGenres()
{
	return this->m_radioGenres.size();
}

qint32 RadioStationManager::numberOfStationsInCategory(qint32 categoryId)
{
	if ( categoryId == -1 )
		return 0;

	qint32 stationCount = 0;
	QMap<qint32, RadioStation*> categoryStations;
	for ( RadioStation* station : this->m_radioStations )
	{
		if ( station->categoryId() == categoryId )
		{
			stationCount++;
			categoryStations.insert(station->position(), station);
		}
	}
//	qDebug() << "RadioStationManager::numberOfStationsInCategory" << stationCount << categoryStations.size() << categoryId;
	return categoryStations.size();
}

RadioGenre* RadioStationManager::radioGenreAtPosition(qint32 position)
{
//	qDebug() << "RadioStationManager::radioGenreAtPosition" << position;
	if (position < this->allRadioGenres().size())
	{
		return this->allRadioGenres().at(position);
	}
	return nullptr;
}

RadioStation* RadioStationManager::radioStationAtPosition(qint32 position, qint32 categoryId)
{
	/// this queries the stations every time newly to handle updates in either categories map or
	/// radio stations map
//	qDebug() << "RadioStationManager::radioStationAtPosition" << position << categoryId;
	QMap<qint32, RadioStation*> categoryStations;

	for ( RadioStation* station : this->m_radioStations )
	{
		if ( station->categoryId() == categoryId)
		{
//			if (categoryStations.contains(station->position()))
//				qDebug() << "vvvvvstation->position()" << station->position();
			categoryStations.insert(station->position(), station);
		}
	}

	if ( position < categoryStations.size() )
	{
		return categoryStations.values().at(position);
	}

	return nullptr;
}

QList<RadioStation*> RadioStationManager::favoriteRadioStations()
{
	QList<RadioStation*> stations;
	for ( RadioStation* station : this->m_radioStations )
	{
		if ( station->liked() )
		{
			stations.append(station);
		}
	}

	return stations;
}

RadioStation* RadioStationManager::favoriteRadioStationAtPosition(qint32 position)
{
	return this->favoriteRadioStations().at(position);
}

qint32 RadioStationManager::numberOfFavoriteStations()
{
	return this->favoriteRadioStations().size();
}

QList<RadioStation*> RadioStationManager::recentRadioStations()
{
	QMap<qint64, RadioStation*> stations;

	for ( RadioStation* station : this->m_radioStations )
	{
		if ( station->lastPlayed().isValid() )
		{
			/// max - current time, to have them later ordered in reverse order (pe)
			stations.insert(std::numeric_limits<qint64>::max() - station->lastPlayed().toMSecsSinceEpoch(), station);
		}
	}

	return stations.values();
}

RadioStation* RadioStationManager::recentRadioStationAtPosition(qint32 position)
{
	return this->recentRadioStations().at(position);
}

qint32 RadioStationManager::numberOfRecentStations()
{
	return this->recentRadioStations().size();
}

qint32 RadioStationManager::currentCategory() const
{
	return this->m_currentCategory;
}

void RadioStationManager::setCurrentCategory(const qint32& currentCategory)
{
	qDebug() << "RadioStationManager::setCurrentCategory:" << currentCategory;
	this->m_currentCategory = currentCategory;
	emit radioStationsChanged();
//	QTimer::singleShot(100, this, SLOT(querryReachability()));
	this->querryReachability();
}

void RadioStationManager::setStation(const QString uid)
{
	qDebug() << "RadioStationManager::setStation" << uid;
	if ( this->m_radioStations.contains(uid) )
	{
		this->setCurrentRadioStation( this->m_radioStations[uid] );
		this->setStationName( this->getCurrentRadioStation()->name() );
		this->setStreamUrl( this->getCurrentRadioStation()->url().toString() );
		this->setLogoUrl( this->getCurrentRadioStation()->logoUrl().toString() );
		this->setLongDescription( this->getCurrentRadioStation()->longDescription() );
		this->setLiked( this->getCurrentRadioStation()->liked() );
		this->setCurrentAudioMedia( uid );
	}
}

void RadioStationManager::toggleLiked()
{
	if ( this->getCurrentRadioStation() != nullptr )
	{
		this->getCurrentRadioStation()->setLiked( !this->getCurrentRadioStation()->liked() );
		this->setLiked( this->getCurrentRadioStation()->liked() );
	}
}

QString RadioStationManager::stationName() const
{
	return this->m_stationName;
}

QString RadioStationManager::streamUrl() const
{
	return this->m_streamUrl;
}

QString RadioStationManager::logoUrl() const
{
	return this->m_logoUrl;
}

QString RadioStationManager::longDescription() const
{
	return this->m_longDescription;
}

LFD::AudioMedia* RadioStationManager::currentAudioMedia()
{
	return this->m_currentAudioMedia;
}

QString RadioStationManager::title() const
{
	return this->m_title;
}

void RadioStationManager::setStationName(QString stationName)
{
	if (this->m_stationName == stationName)
		return;

	this->m_stationName = stationName;
	emit stationNameChanged(this->m_stationName);
}

void RadioStationManager::setStreamUrl(QString streamUrl)
{
	if (this->m_streamUrl == streamUrl)
		return;

	this->m_streamUrl = streamUrl;
	emit streamUrlChanged(this->m_streamUrl);
}

void RadioStationManager::setLogoUrl(QString logoUrl)
{
	if (this->m_logoUrl == logoUrl)
		return;

	this->m_logoUrl = logoUrl;
	emit logoUrlChanged(this->m_logoUrl);
}

void RadioStationManager::setLongDescription(QString longDescription)
{
	if (this->m_longDescription == longDescription)
		return;

	this->m_longDescription = longDescription;
	emit longDescriptionChanged(this->m_longDescription);
}

void RadioStationManager::setCurrentAudioMedia(QString uid)
{
	LFD::AudioMedia* audioMedia = new LFD::AudioMedia( this,
													   true,
													   true,
													   true,
													   false /*TODO*/,
													   true,
													   false,
													   uid,
													   QStringLiteral("title"),
													   this->m_radioStations[uid]->name(),
													   QStringLiteral("filtermusic"),
													   "",
													   this->m_radioStations[uid]->url().toString() );
	this->m_currentAudioMedia->deleteLater();
	this->m_currentAudioMedia = audioMedia;
	emit currentAudioMediaChanged( this->m_currentAudioMedia );
}

void RadioStationManager::setTitle(QString title)
{
	if (m_title == title)
		return;

	m_title = title;
	emit titleChanged(m_title);
}

void RadioStationManager::startedPlayingStation()
{
	if ( this->getCurrentRadioStation() != nullptr )
		this->getCurrentRadioStation()->setLastPlayed( QDateTime::currentDateTimeUtc() );
}

void RadioStationManager::stoppedPlayingStation()
{
	if ( this->getCurrentRadioStation() != nullptr )
		this->getCurrentRadioStation()->setLastPlayed( QDateTime::currentDateTimeUtc() );
}

void RadioStationManager::nextStation()
{
	/// next and previous are potential probelmatic, since they work with different numbering
	/// RadioStation::position is not equal to radioStationAtPosition
	/// sofar it has always been the case that RadioStation::position is just radioStationAtPosition + 1
	if ( this->getCurrentRadioStation() != nullptr )
	{
		int nextStationPosition = (this->getCurrentRadioStation()->position() )
				% this->numberOfStationsInCategory(this->getCurrentRadioStation()->categoryId());
		qDebug() << "nextStationPosition:" << nextStationPosition;

		this->setStation( this->radioStationAtPosition(nextStationPosition, this->getCurrentRadioStation()->categoryId())->uid() );
	}
}

void RadioStationManager::previousStation()
{
	if ( this->getCurrentRadioStation() != nullptr )
	{
		/// radioStationAtPosition + 1 thats why -2 (pe)
		int nextStationPosition = (this->getCurrentRadioStation()->position() - 2);
		if ( nextStationPosition < 0 )
			nextStationPosition = this->numberOfStationsInCategory(this->getCurrentRadioStation()->categoryId()) - 1;
		qDebug() << "nextStationPosition:" << nextStationPosition;

		this->setStation( this->radioStationAtPosition(nextStationPosition, this->getCurrentRadioStation()->categoryId())->uid() );
	}
}

void RadioStationManager::setLiked(bool liked)
{
	if (this->m_liked == liked)
		return;

	this->m_liked = liked;
	emit likedChanged(this->m_liked);
}

void RadioStationManager::stationReachable(QString urlString, bool reachable)
{
	for ( RadioStation* station : this->m_radioStations )
	{
		if (station->url().toString() == urlString) {
			station->setReachable( reachable );
			return;
		}
	}
}

void RadioStationManager::querryReachability()
{
//	qDebug() << "RadioStationManager::querryReachability";
	for ( RadioStation* station : this->m_radioStations )
	{
//		qDebug() << "RadioStationManager::querryReachability pling";
		if ( station->categoryId() == this->currentCategory() )
		{
			if ( !station->reachableQueried().isValid() ||
				  station->reachableQueried().secsTo( QDateTime::currentDateTimeUtc() ) > QUERY_TIME_REACHABILITY)
			{
				qDebug() << "RadioStationManager::pingUrl";
				NetworkAccessManager::getInstance().pingUrl(station->url().toString());
			}
		}
	}
	qDebug() << "RadioStationManager::querryReachability done";
}

void RadioStationManager::updateRadioStation(RadioStation* radioStation)
{
//	qDebug() << "RadioStationManager::updateRadioStation" << radioStation->uid();

	if ( this->m_radioStations.contains(radioStation->uid()) )
	{
		RadioStation* existingStation = this->m_radioStations[radioStation->uid()];
		this->m_radioStations.remove(radioStation->uid());
		radioStation->setLastPlayed(existingStation->lastPlayed());
		radioStation->setLiked(existingStation->liked());

		if ( this->getCurrentRadioStation() == existingStation )
		{
			this->setCurrentRadioStation(radioStation);
		}
		existingStation->deleteLater();
	}
	this->insertRadioStation(radioStation);
}

RadioStation* RadioStationManager::getCurrentRadioStation() const
{
	return this->m_currentRadioStation;
}

void RadioStationManager::setCurrentRadioStation(RadioStation* currentRadioStation)
{
	this->m_currentRadioStation = currentRadioStation;
}

void RadioStationManager::setLastPlayedStation()
{
	if ( this->recentRadioStations().size() > 0 )
	{
		this->setStation( this->recentRadioStations().at(0)->uid() );
	}
}

bool RadioStationManager::liked() const
{
	return this->m_liked;
}

void RadioStationManager::insertRadioStation(RadioStation* radioStation)
{
//	qDebug() << "RadioStationManager::insertRadioStation" << radioStation->name() << radioStation->lastPlayed().toString(Qt::TextDate);
	this->m_radioStations.insert(radioStation->uid(), radioStation);
//	qDebug() << radioStation->toString();
}

void RadioStationManager::insertRadioGenre(RadioGenre* radioGenre)
{
//	qDebug() << "RadioStationManager::insertRadioGenre" << radioGenre->name();
	this->m_radioGenres.insert(radioGenre->categoryId(), radioGenre);
}

} /// namespace filtermusic
