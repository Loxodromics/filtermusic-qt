//
//  persistancemanager.cpp
//  Filtermusic
//
//  Created by philipp on 18.10.2017.
//  Copyright (c) 2017 Philipp Engelhard. All rights reserved.
//
#include <QFileInfo>
#include "persistancemanager.h"
#include "sources/data/radiostation.h"
#include "sources/data/radiogenre.h"
#include "sources/data/radiostationmanager.h"
#include "sources/commons/constants.h"

namespace filtermusic {

PersistanceManager::PersistanceManager(QObject *parent)
	: QObject(parent),
	  m_resourcePath()
{

}

QSqlError PersistanceManager::initFromLocalDb()
{
	QSqlDatabase::addDatabase("QSQLITE");
	QString path = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
	QDir appDataLocation(path);


	QString filepath = path + "/" + DATABASE_FILENAME;
	QFileInfo dbFileInfo(filepath);
	if (!dbFileInfo.exists())
		this->copyInitialDb(path, appDataLocation);

	qDebug() << "Database path: " << path;
	QSqlDatabase::database().setDatabaseName(filepath);

	if ( !QSqlDatabase::database().open() )
	{
		qDebug() << "Error: connection with database failed";
		return QSqlDatabase::database().lastError();
	}
	qDebug() << "Database opend";


	this->checkDbVersion();
	this->loadLocalRadioGenres();
	this->loadLocalRadioStations();
//	RadioStationManager::getInstance().printStations();
	RadioStationManager::getInstance().setLastPlayedStation();

	return QSqlError();
}

QSqlError PersistanceManager::writeVersionNumber()
{
	QStringList tables = QSqlDatabase::database().tables();

	if ( tables.contains("version_number", Qt::CaseInsensitive) )
	{
		QSqlQuery sqlQuery(QSqlDatabase::database());
		sqlQuery.exec(QLatin1String("DROP TABLE version_number"));
	}

	QSqlQuery sqlQuery;

	if (!sqlQuery.exec(QLatin1String("create table version_number(id integer primary key, version_number int)")) )
	{
		return sqlQuery.lastError();
	}

	if (!sqlQuery.prepare(QLatin1String("insert into version_number(version_number) values(?)")) )
	{
		return sqlQuery.lastError();
	}

	sqlQuery.addBindValue( (int)LOCAL_DB_VERSION_NUMBER);

	if (sqlQuery.exec() )
	{
		return sqlQuery.lastError();
	}

	return QSqlError();
}

void PersistanceManager::checkDbVersion()
{
	QStringList tables = QSqlDatabase::database().tables();

	if (tables.contains("version_number", Qt::CaseInsensitive) )
	{
		QSqlQuery sqlQuery(QSqlDatabase::database());
		sqlQuery.setForwardOnly(true);
		sqlQuery.exec(QLatin1String("SELECT * from version_number") );

		while ( sqlQuery.next() )
		{
			unsigned int versionNumber =
					sqlQuery.record().field( QLatin1String("version_number") ).value().toInt();

			if (versionNumber < LOCAL_DB_VERSION_NUMBER)
			{
				QSqlDatabase::database().close();
//				this->upgradeLocalDb(versionNumber);
			}
		}
	}
}

void PersistanceManager::saveToLocalDb()
{
	qDebug() << "Saving to local DB...";
	QSqlError error = this->writeVersionNumber();
	this->saveRadioStations();
	this->saveRadioGenres();
	emit categoriesChanged();
	emit radioStationsChanged();
}

void PersistanceManager::setResourcePath(const QString resourcePath)
{
	this->m_resourcePath = resourcePath;
}

void PersistanceManager::signalStationsChanged()
{
	emit radioStationsChanged();
}

void PersistanceManager::signalCategoriesChanged()
{
	emit categoriesChanged();
}

void PersistanceManager::saveRadioStations()
{
	QStringList tables = QSqlDatabase::database().tables();

	if ( tables.contains("radio_stations", Qt::CaseInsensitive) )
	{
		QSqlQuery sqlQuery( QSqlDatabase::database() );
		sqlQuery.exec( QLatin1String("DROP TABLE radio_stations") );
	}

	/// this will speed up adding to the database
	if ( !QSqlDatabase::database().transaction() )
	{
		qDebug() << "Start transaction did not work";
	}

	QSqlQuery sqlQuery;

	if ( !sqlQuery.exec( QLatin1String("create table radio_stations(id integer primary key, name string, long_description string, stream_url string, logo_url string, category_id string, position integer, uid string, liked bool, last_played date )") ) )
	{
//		return sqlQuery.lastError();
	}

	if ( !sqlQuery.prepare( QLatin1String("insert into radio_stations(name, long_description, stream_url, logo_url, category_id, position, uid, liked, last_played) values(?, ?, ?, ?, ?, ?, ?, ?, ?)") ) )
	{
//		return sqlQuery.lastError();
	}

	QList<RadioStation*> radioStations = RadioStationManager::getInstance().allRadioStations();

	for ( RadioStation* radioStation : radioStations )
	{
		this->putRadioStationToDb( sqlQuery, radioStation );
	}

	/// this will speed up adding to the database
	if ( sqlQuery.lastError().isValid() )
	{
		qDebug() << sqlQuery.lastError().text();
		QSqlDatabase::database().rollback();
	}
	else
	{
		QSqlDatabase::database().commit();
	}
}

void PersistanceManager::saveRadioGenres()
{
	QStringList tables = QSqlDatabase::database().tables();

	if ( tables.contains("radio_genres", Qt::CaseInsensitive) )
	{
		QSqlQuery sqlQuery( QSqlDatabase::database() );
		sqlQuery.exec( QLatin1String("DROP TABLE radio_genres") );
	}

	/// this will speed up adding to the database
	if ( !QSqlDatabase::database().transaction() )
	{
		qDebug() << "Start transaction did not work";
	}

	QSqlQuery sqlQuery;

	if ( !sqlQuery.exec( QLatin1String("create table radio_genres(id integer primary key, name string, position integer, category_id string )") ) )
	{
//		return sqlQuery.lastError();
	}

	if ( !sqlQuery.prepare( QLatin1String("insert into radio_genres(name, position, category_id) values(?, ?, ?)") ) )
	{
//		return sqlQuery.lastError();
	}

	QList<RadioGenre*> radioGenres = RadioStationManager::getInstance().allRadioGenres();

	for ( RadioGenre* radioGenre : radioGenres )
	{
		this->putRadioGenreToDb( sqlQuery, radioGenre );
	}

	/// this will speed up adding to the database
	if ( sqlQuery.lastError().isValid() )
	{
		qDebug() << sqlQuery.lastError().text();
		QSqlDatabase::database().rollback();
	}
	else
	{
		QSqlDatabase::database().commit();
	}
}

void PersistanceManager::putRadioStationToDb(QSqlQuery& sqlQuery, RadioStation* radioStation)
{
	if (radioStation != nullptr)
	{
		sqlQuery.addBindValue( radioStation->name() );
		sqlQuery.addBindValue( radioStation->longDescription() );
		sqlQuery.addBindValue( radioStation->url() );
		sqlQuery.addBindValue( radioStation->logoUrl() );
		sqlQuery.addBindValue( radioStation->categoryId() );
		sqlQuery.addBindValue( radioStation->position() );
		sqlQuery.addBindValue( radioStation->uid() );
		sqlQuery.addBindValue( radioStation->liked() );
		if (radioStation->lastPlayed().isValid() )
			sqlQuery.addBindValue( radioStation->lastPlayed() );
		else
			sqlQuery.addBindValue( QVariant() );

		sqlQuery.exec();
	}
}

void PersistanceManager::putRadioGenreToDb(QSqlQuery& sqlQuery, RadioGenre* radioGenre)
{
	if (radioGenre != nullptr)
	{
		sqlQuery.addBindValue( radioGenre->name() );
		sqlQuery.addBindValue( radioGenre->position() );
		sqlQuery.addBindValue( radioGenre->categoryId() );

		sqlQuery.exec();
	}
}

QSqlError PersistanceManager::loadLocalRadioStations()
{
	QStringList tables = QSqlDatabase::database().tables();

	if ( tables.contains("radio_stations", Qt::CaseInsensitive) )
	{
		QSqlQuery sqlQuery(QSqlDatabase::database());
		sqlQuery.setForwardOnly(true);
		sqlQuery.exec( QLatin1String("SELECT * from radio_stations") );
		this->parseRadioStationsQuery(sqlQuery);
		emit radioStationsChanged();
		return sqlQuery.lastError();
	}
	else
	{
		qDebug() << "no local radio_stations";
	}

	return QSqlError();
}

QSqlError PersistanceManager::loadLocalRadioGenres()
{
	QStringList tables = QSqlDatabase::database().tables();

	if ( tables.contains("radio_genres", Qt::CaseInsensitive) )
	{
		QSqlQuery sqlQuery(QSqlDatabase::database());
		sqlQuery.setForwardOnly(true);
		sqlQuery.exec( QLatin1String("SELECT * from radio_genres") );
		this->parseRadioGenresQuery(sqlQuery);
		emit categoriesChanged();
		return sqlQuery.lastError();
	}
	else
	{
		qDebug() << "no local radio_genres";
	}

	return QSqlError();
}

void PersistanceManager::parseRadioStationsQuery(QSqlQuery& query)
{
	while ( query.next() )
	{
		RadioStation* radioStation = new RadioStation( &RadioStationManager::getInstance(),
													   query.record().field(QLatin1String("name") ).value().toString(),
													   query.record().field(QLatin1String("long_description") ).value().toString(),
													   QUrl(query.record().field(QLatin1String("stream_url") ).value().toString()),
													   QUrl(query.record().field(QLatin1String("logo_url") ).value().toString()),
													   query.record().field(QLatin1String("category_id") ).value().toInt(),
													   query.record().field(QLatin1String("position") ).value().toInt(),
													   query.record().field(QLatin1String("uid") ).value().toString(),
													   query.record().field(QLatin1String("liked") ).value().toBool(),
													   query.record().field(QLatin1String("last_played") ).value().toDateTime()
													   );

		RadioStationManager::getInstance().updateRadioStation(radioStation);
	}
}

void PersistanceManager::parseRadioGenresQuery(QSqlQuery& query)
{
	while ( query.next() )
	{
		RadioGenre* radioGenre = new RadioGenre( &RadioStationManager::getInstance(),
												 query.record().field(QLatin1String("name") ).value().toString(),
												 query.record().field(QLatin1String("position") ).value().toInt(),
												 query.record().field(QLatin1String("category_id") ).value().toInt()
												 );

		RadioStationManager::getInstance().insertRadioGenre(radioGenre);
	}
}

void PersistanceManager::copyInitialDb(QString path, QDir appDataLocation)
{
	appDataLocation.mkpath(path);
	QFile::copy(this->m_resourcePath + DATABASE_FILENAME, path + "/" + DATABASE_FILENAME);

	/// make it writable
	QFile file(path + "/" + DATABASE_FILENAME);
	file.setPermissions(file.permissions()|QFile::WriteOwner|QFile::WriteUser|QFileDevice::WriteGroup);
}

} /// namespace filtermusic
