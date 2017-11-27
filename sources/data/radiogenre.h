//
//  radiogenre.h
//  Filtermusic
//
//  Created by philipp on 16.10.2017.
//  Copyright (c) 2017 Philipp Engelhard. All rights reserved.
//
#ifndef FILTERMUSIC_RADIOGENRE_H
#define FILTERMUSIC_RADIOGENRE_H

#include <QObject>
#include <QMap>
#include "radiostation.h"

class QJsonObject;

namespace filtermusic {

class RadioGenre : public QObject
{
	Q_OBJECT
public:
	explicit RadioGenre( QObject* parent,
						 QString name,
						 qint32 position,
						 qint32 categoryId );

	static RadioGenre* fromJson(QJsonObject& json, QObject* parent);

	const QString name() const;
	qint32 position() const;
	qint32 categoryId() const;

	void insertRadioStation(RadioStation* radioStation);
	QString toString() const;
	qint32 numberOfStations();

protected:
	const QString m_name;
	const qint32 m_position;
	const qint32 m_categoryId;
};

} /// namespace filtermusic

#endif /// FILTERMUSIC_RADIOGENRE_H
