//
//  radiogenre.cpp
//  Filtermusic
//
//  Created by philipp on 16.10.2017.
//  Copyright (c) 2017 Philipp Engelhard. All rights reserved.
//
#include "radiogenre.h"
#include "sources/commons/constants.h"
#include <QJsonObject>

namespace filtermusic {

RadioGenre::RadioGenre(QObject *parent, QString name, qint32 order, qint32 categoryId)
	: QObject(parent),
	  m_name(name),
	  m_position(order),
	  m_categoryId(categoryId)
{

}

RadioGenre* RadioGenre::fromJson(QJsonObject& json, QObject* parent)
{
	const QString name = json.value(GENRE_KEY_NAME).toString();
	const qint32 order = json.value(GENRE_KEY_POSITION).toString().toInt();
	qint32 categoryId = json.value(GENRE_KEY_ID).toString().toInt();

	RadioGenre* radioGenre = new RadioGenre(parent, name, order, categoryId);

	return radioGenre;
}

const QString RadioGenre::name() const
{
	return this->m_name;
}

qint32 RadioGenre::position() const
{
	return this->m_position;
}

qint32 RadioGenre::categoryId() const
{
	return this->m_categoryId;
}

QString RadioGenre::toString() const
{
	QString out;
	out.append("filtermusic::RadioGenre(");
	out.append(QString::number((long)this));
	out.append(") name: ");
	out.append(this->name());
	out.append(" category: ");
	out.append(this->categoryId());
	out.append(" stations: ");
//	for (RadioStation* radioStation : this->m_radioStations)
//	{
//		out.append(radioStation->toString());
//		out.append("\n");
//	}

	return out;
}

} /// namespace filtermusic
