//
//  radiostation.h
//  Filtermusic
//
//  Created by philipp on 10.10.2017.
//  Copyright (c) 2017 Philipp Engelhard. All rights reserved.
//
#ifndef FILTERMUSIC_RADIOSTATION_H
#define FILTERMUSIC_RADIOSTATION_H

#include <QObject>
#include <QUrl>
#include <QDateTime>

class QJsonObject;

namespace filtermusic {

class RadioStation : public QObject
{
	Q_OBJECT
public:
	/// constructors
	explicit RadioStation( QObject* parent,
						   QString name,
						   QString longDescription,
						   QUrl streamUrl,
						   QUrl logoUrl,
						   qint32 categoryId,
						   qint32 position,
						   QString uid,
						   bool liked,
						   QDateTime lastPlayed);

	static RadioStation* fromJson(QJsonObject& json, QObject* parent);

	/// Getters
	QString name() const;
	QString longDescription() const;
	QUrl url() const;
	QUrl logoUrl() const;
	QUrl localLogoUrl() const;
	qint32 categoryId() const;
	qint32 position() const;
	QString uid() const;
	bool liked() const;
	QDateTime lastPlayed() const;

	/// Setters
	void setLocalLogoUrl(const QUrl& value);
	void setLiked(bool liked);
	void setLastPlayed(const QDateTime& lastPlayed);

	///
	QString toString();

	bool reachable() const;
	void setReachable(bool reachable);

	const QDateTime reachableQueried() const;
	void setReachableQueried(const QDateTime reachableQueried);

	bool markedForDeletion() const;
	void setMarkedForDeletion(bool markedForDeletion);

protected:
	const QString m_name;
	const QString m_longDescription;
	const QUrl m_url;
	const QUrl m_logoUrl;
	QUrl m_localLogoUrl;
	const qint32 m_categoryId;
	const qint32 m_position;
	const QString m_uid;
	bool m_liked;
	QDateTime m_lastPlayed;
	bool m_reachable;
	QDateTime m_reachableQueried;
	bool m_markedForDeletion;
};

} /// namespace filtermusic

#endif /// FILTERMUSIC_RADIOSTATION_H
