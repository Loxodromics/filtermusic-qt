//
//  radiogenremodel.h
//  Filtermusic
//
//  Created by philipp on 21.10.2017.
//  Copyright (c) 2017 Philipp Engelhard. All rights reserved.
//
#ifndef FILTERMUSIC_RADIOGENREMODEL_H
#define FILTERMUSIC_RADIOGENREMODEL_H

#include <QAbstractListModel>


namespace filtermusic {

class RadioGenreModel : public QAbstractListModel
{
	Q_OBJECT
public:
	enum RadioGenrelRoles {
		NameRole = Qt::UserRole + 1,
		PositionRole,
		CategoryRole,
		NumberOfStationsRole
	};

	RadioGenreModel(QObject *parent = 0);

	// Header:
	QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const override;

	// Basic functionality:
	int rowCount(const QModelIndex& parent = QModelIndex()) const override;
	QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;

protected:
	QHash<int, QByteArray> roleNames() const override;

protected slots:
	void update();
};

} /// namespace filtermusic

#endif /// FILTERMUSIC_RADIOGENREMODEL_H
