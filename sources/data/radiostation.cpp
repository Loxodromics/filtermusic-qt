//
//  radiostation.cpp
//  Filtermusic
//
//  Created by philipp on 10.10.2017.
//  Copyright (c) 2017 Philipp Engelhard. All rights reserved.
//
#include "radiostation.h"
#include "sources/commons/constants.h"
#include <QJsonObject>

namespace filtermusic {

RadioStation::RadioStation(QObject* parent, QString name, QString longDescription, QUrl streamUrl, QUrl logoUrl, qint32 categoryId, qint32 position, QString uid, bool liked, QDateTime lastPlayed)
	: QObject(parent),
	  m_name(name),
	  m_longDescription(longDescription),
	  m_url(streamUrl),
	  m_logoUrl(logoUrl),
	  m_categoryId(categoryId),
	  m_position(position),
	  m_uid(uid),
	  m_liked(liked),
	  m_lastPlayed(lastPlayed),
	  m_reachable(true),
	  m_reachableQueried()
{

}

RadioStation* RadioStation::fromJson(QJsonObject& json, QObject* parent)
{
	const QString name = json.value(STATION_KEY_NAME).toString();
	const QString longDescription = json.value(STATION_KEY_DESCRIPTION).toString();
	const QUrl url = QUrl(json.value(STATION_KEY_URL).toString());
	const QUrl logoUrl = QUrl(json.value(STATION_KEY_LOGO).toObject().value(STATION_KEY_LOGO_SRC).toString());
	const qint32 categoryId = json.value(STATION_KEY_GENRE).toString().toInt();
	const qint32 position = json.value(STATION_KEY_POSTION).toString().toInt();
	const QString uid = json.value(STATION_KEY_ID).toString();
	const bool liked = false;//((qrand() % 20) >= 19);
	QDateTime lastPlayed;
//	if ((qrand() % 20) >= 19)
//		lastPlayed = QDateTime::currentDateTimeUtc();



	RadioStation* radioStation = new RadioStation( parent,
												   name,
												   longDescription,
												   url,
												   logoUrl,
												   categoryId,
												   position,
												   uid,
												   liked,
												   lastPlayed );

	return radioStation;
}

QString RadioStation::name() const
{
	return this->m_name;
}

QString RadioStation::longDescription() const
{
	return this->m_longDescription;
}

QUrl RadioStation::url() const
{
	return this->m_url;
}

QUrl RadioStation::logoUrl() const
{
	return this->m_logoUrl;
}

QUrl RadioStation::localLogoUrl() const
{
	return this->m_localLogoUrl;
}

qint32 RadioStation::categoryId() const
{
	return this->m_categoryId;
}

qint32 RadioStation::position() const
{
	return this->m_position;
}

QString RadioStation::uid() const
{
	return this->m_uid;
}

void RadioStation::setLocalLogoUrl(const QUrl& value)
{
	this->m_localLogoUrl = value;
}

QString RadioStation::toString()
{
	QString out;
	out.append( "filtermusic::RadioStation(" );
	out.append( QString::number((long)this) );
	out.append( ") name: " );
	out.append( this->name() );
	out.append( " streamUrl: " );
	out.append( this->url().toString() );
	return out;
}

bool RadioStation::reachable() const
{
	return this->m_reachable;
}

void RadioStation::setReachable(bool reachable)
{
	this->m_reachable = reachable;
	this->setReachableQueried( QDateTime::currentDateTimeUtc() );
}

const QDateTime RadioStation::reachableQueried() const
{
	return this->m_reachableQueried;
}

void RadioStation::setReachableQueried(const QDateTime reachableQueried)
{
	this->m_reachableQueried = reachableQueried;
}

bool RadioStation::liked() const
{
	return this->m_liked;
}

void RadioStation::setLiked(bool liked)
{
	this->m_liked = liked;
}

QDateTime RadioStation::lastPlayed() const
{
	return this->m_lastPlayed;
}

void RadioStation::setLastPlayed(const QDateTime& lastPlayed)
{
	this->m_lastPlayed = lastPlayed;
}

} /// namespace filtermusic
