//
//  radiogenremodel.cpp
//  Filtermusic
//
//  Created by philipp on 21.10.2017.
//  Copyright (c) 2017 Philipp Engelhard. All rights reserved.
//
#include "radiogenremodel.h"
#include "sources/data/radiostationmanager.h"
#include <QDebug>

namespace filtermusic {

RadioGenreModel::RadioGenreModel(QObject* parent)
	: QAbstractListModel(parent)
{

}

QVariant RadioGenreModel::headerData(int section, Qt::Orientation orientation, int role) const
{
	/// we have no header
	Q_UNUSED(section);
	Q_UNUSED(orientation);
	Q_UNUSED(role);

	return QVariant();
}

int RadioGenreModel::rowCount(const QModelIndex& parent) const
{
//	qDebug() << "RadioGenreModel::rowCount" << RadioStationManager::getInstance().numberOfGenres();
	// For list models only the root node (an invalid parent) should return the list's size. For all
	// other (valid) parents, rowCount() should return 0 so that it does not become a tree model.
	if (parent.isValid())
		return 0;

	return RadioStationManager::getInstance().numberOfGenres();
}

QVariant RadioGenreModel::data(const QModelIndex& index, int role) const
{
	if ( !index.isValid() ||
		 index.row() < 0 ||
		 index.row() >= this->rowCount() )
	{
		return QVariant();
	}
//	qDebug() << "role:" << role << "row:" << index.row();

	switch (role)
	{
	case NameRole:
//		qDebug() << "RadioStationManager::getInstance().radioGenreAtPosition(index.row())" << RadioStationManager::getInstance().radioGenreAtPosition(index.row())->toString();
		return QVariant::fromValue(RadioStationManager::getInstance().radioGenreAtPosition(index.row())->name());
	case PositionRole:
		return QVariant::fromValue(RadioStationManager::getInstance().radioGenreAtPosition(index.row())->position());
	case CategoryRole:
		return QVariant::fromValue(RadioStationManager::getInstance().radioGenreAtPosition(index.row())->categoryId());
	case NumberOfStationsRole:
		return QVariant::fromValue(RadioStationManager::getInstance().numberOfStationsInCategory(
									   RadioStationManager::getInstance().radioGenreAtPosition(index.row())->categoryId()));
	}

	return QVariant();
}

QHash<int, QByteArray> RadioGenreModel::roleNames() const
{
	QHash<int, QByteArray> roles;
	roles[NameRole] = "name";
	roles[PositionRole] = "position";
	roles[CategoryRole] = "category";
	roles[NumberOfStationsRole] = "numberOfStations";
	return roles;
}

void RadioGenreModel::update()
{
	beginResetModel();
	endResetModel();
	emit dataChanged( index(0, 0), index(this->rowCount(), 0) );
}

} /// namespace filtermusic
