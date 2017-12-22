//
//  persistancemanager.h
//  Filtermusic
//
//  Created by philipp on 18.10.2017.
//  Copyright (c) 2017 Philipp Engelhard. All rights reserved.
//
#ifndef FILTERMUSIC_PERSISTANCEMANAGER_H
#define FILTERMUSIC_PERSISTANCEMANAGER_H

#include <QObject>
#include <QtSql>

namespace filtermusic {

class RadioStation;
class RadioGenre;

class PersistanceManager : public QObject
{
	Q_OBJECT
public:

	static PersistanceManager& getInstance()
	{
		static PersistanceManager instance;
		return instance;
	}

	QSqlError initFromLocalDb();
	QSqlError writeVersionNumber();
	void checkDbVersion();
	void setResourcePath( const QString resourcePath );
	void signalStationsChanged();
	void signalCategoriesChanged();
	void loadLocalSettings();
	const QString getSetting(const QString key, const QString defaultValue = QStringLiteral(""));
	Q_INVOKABLE const QString getString(const QString key, const QString viewName, const QString defaultValue);

signals:
	void radioStationsChanged();
	void categoriesChanged();
	void favoritesChanged();
	void rectentChanged();

public slots:
	void saveToLocalDb();

protected:
	/// save
	void saveRadioStations();
	void saveRadioGenres();
	void putRadioStationToDb(QSqlQuery& sqlQuery, RadioStation* radioStation);
	void putRadioGenreToDb(QSqlQuery& sqlQuery, RadioGenre* radioGenre);

	/// load
	QSqlError loadLocalRadioStations();
	void parseRadioStationsQuery(QSqlQuery& query);
	QSqlError loadLocalRadioGenres();
	void parseRadioGenresQuery(QSqlQuery& query);

	void copyInitialDb(QString path, QDir appDataLocation);

	QString m_resourcePath;

private:
//	PersistanceManager() {}
	PersistanceManager(QObject* parent = 0);

	PersistanceManager(PersistanceManager const&);
	void operator =(PersistanceManager const&);

};

} /// namespace filtermusic

#endif /// FILTERMUSIC_PERSISTANCEMANAGER_H
