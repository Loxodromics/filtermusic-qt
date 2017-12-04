//
//  radiostationmodel.cpp
//  Filtermusic
//
//  Created by philipp on 21.10.2017.
//  Copyright (c) 2017 Philipp Engelhard. All rights reserved.
//
#include "radiostationmodel.h"
#include "sources/data/radiostationmanager.h"
#include <QDebug>

namespace filtermusic {

RadioStationModel::RadioStationModel(QObject* parent)
	: QAbstractListModel(parent),
	  m_size(0),
	  m_deferredUpdateTimer()
{
	this->m_deferredUpdateTimer.setInterval(300);
	this->m_deferredUpdateTimer.setSingleShot(true);
	QObject::connect( &this->m_deferredUpdateTimer, SIGNAL(timeout()),
					  this, SLOT(update()) );
}

QVariant RadioStationModel::headerData(int section, Qt::Orientation orientation, int role) const
{
	/// we have no header
	Q_UNUSED(section);
	Q_UNUSED(orientation);
	Q_UNUSED(role);

	return QVariant();
}

int RadioStationModel::rowCount(const QModelIndex& parent) const
{
//	qDebug() << "RadioStationModel::rowCount" << RadioStationManager::getInstance().numberOfStationsInCategory(RadioStationManager::getInstance().currentCategory());
	// For list models only the root node (an invalid parent) should return the list's size. For all
	// other (valid) parents, rowCount() should return 0 so that it does not become a tree model.
	if (parent.isValid())
		return 0;

	switch (type) {
	case CategoryType:
		return RadioStationManager::getInstance().numberOfStationsInCategory(RadioStationManager::getInstance().currentCategory());
		break;
	case FavoritesType:
		return RadioStationManager::getInstance().numberOfFavoriteStations();
		break;
	case RecentType:
//		qDebug() << "RadioStationManager::getInstance().numberOfRecentStations(): " << RadioStationManager::getInstance().numberOfRecentStations();
		return RadioStationManager::getInstance().numberOfRecentStations();
		break;
	default:
		return 0;
		break;
	}

}

QVariant RadioStationModel::data(const QModelIndex& index, int role) const
{
	if ( !index.isValid() ||
		 index.row() < 0 ||
		 index.row() >= this->rowCount() )
	{
		return QVariant();
	}
//	qDebug() << "role:" << role;

	RadioStation* station = this->getStationAt( index.row() );
	if (station == nullptr)
	{
		return QVariant();
	}

	switch (role)
	{
	case NameRole:
//		qDebug() << "RadioStationManager::getInstance().radioStationsAtPosition(index.row())" << RadioStationManager::getInstance().radioStationsAtPosition(index.row())->toString();
		return QVariant::fromValue( station->name() );
	case LongDescriptionRole:
		return QVariant::fromValue( station->longDescription() );
	case StreamUrlRole:
		return QVariant::fromValue( station->url() );
	case LogoUrlRole:
		return QVariant::fromValue( station->logoUrl() );
	case CategoryIdRole:
		return QVariant::fromValue( station->categoryId() );
	case PositionRole:
		return QVariant::fromValue( station->position() );
	case UidRole:
		return QVariant::fromValue( station->uid() );
	case LikedRole:
		return QVariant::fromValue( station->liked() );
	case LastPlayedRole:
		return QVariant::fromValue( station->lastPlayed() );
	case ReachableRole:
		return QVariant::fromValue( station->reachable() );
	}
	return QVariant();
}

QHash<int, QByteArray> RadioStationModel::roleNames() const
{
	QHash<int, QByteArray> roles;
	roles[NameRole] = "name";
	roles[LongDescriptionRole] = "longDescription";
	roles[StreamUrlRole] = "streamUrl";
	roles[LogoUrlRole] = "logoUrl";
	roles[CategoryIdRole] = "category";
	roles[PositionRole] = "position";
	roles[UidRole] = "uid";
	roles[LikedRole] = "liked";
	roles[LastPlayedRole] = "lastPlayed";
	roles[ReachableRole] = "reachable";
	return roles;
}

RadioStationModel::RadioStationModelType RadioStationModel::getType() const
{
	return this->type;
}

void RadioStationModel::setType(const RadioStationModelType& value)
{
	this->type = value;
}

int RadioStationModel::size() const
{
	return this->m_size;
}

void RadioStationModel::setSize(int size)
{
	if (this->m_size == size)
		return;

	this->m_size = size;
	emit sizeChanged(this->m_size);
}

void RadioStationModel::deferredUpdate()
{
//	qDebug() << "RadioStationModel::deferredUpdate";
	this->m_deferredUpdateTimer.start();
}

void RadioStationModel::update()
{
	qDebug() << "RadioStationModel::update()";
	beginResetModel();
	endResetModel();
	int count = this->rowCount();
	emit setSize(count);
	emit dataChanged( index(0, 0), index(count, 0) );
}

void RadioStationModel::update(int updateIndex)
{
	qDebug() << "RadioStationModel::update(" << updateIndex << ")";
	beginResetModel();
	endResetModel();
	int count = this->rowCount();
	emit setSize(count);
	emit dataChanged( index(updateIndex, 0), index(updateIndex, 0) );
}

RadioStation* RadioStationModel::getStationAt( int row ) const
{
	switch (type) {
	case CategoryType:
		return 	RadioStationManager::getInstance().radioStationAtPosition(
					row,
					RadioStationManager::getInstance().currentCategory() );
		break;
	case FavoritesType:
		return RadioStationManager::getInstance().favoriteRadioStationAtPosition( row );
		break;
	case RecentType:
		return RadioStationManager::getInstance().recentRadioStationAtPosition( row );
		break;
	default:
		return nullptr;
		break;
	}
}


} /// namespace filtermusic
