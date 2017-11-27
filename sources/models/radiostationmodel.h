//
//  radiostationmodel.h
//  Filtermusic
//
//  Created by philipp on 21.10.2017.
//  Copyright (c) 2017 Philipp Engelhard. All rights reserved.
//
#ifndef FILTERMUSIC_RADIOSTATIONMODEL_H
#define FILTERMUSIC_RADIOSTATIONMODEL_H

#include <QAbstractListModel>


namespace filtermusic {

class RadioStation;

class RadioStationModel : public QAbstractListModel
{
	Q_OBJECT

public:
	enum RadioStationRoles {
		NameRole = Qt::UserRole + 1,
		LongDescriptionRole,
		StreamUrlRole,
		LogoUrlRole,
		CategoryIdRole,
		PositionRole,
		UidRole,
		LikedRole,
		LastPlayedRole
	};

	enum RadioStationModelType {
		CategoryType,
		FavoritesType,
		RecentType
	};

	RadioStationModel(QObject *parent = 0);

	// Header:
	QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const override;

	// Basic functionality:
	int rowCount(const QModelIndex& parent = QModelIndex()) const override;
	QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;

	RadioStationModelType getType() const;
	void setType(const RadioStationModelType& value);

	Q_PROPERTY(int size READ size NOTIFY sizeChanged)

	int size() const;

public slots:
	void setSize(int size);

signals:
	void sizeChanged(int size);

protected:
	QHash<int, QByteArray> roleNames() const override;
	RadioStation* getStationAt(int row) const;

	RadioStationModelType type;
	int m_size;


protected slots:
	void update();
};

} /// namespace filtermusic

#endif /// FILTERMUSIC_RADIOSTATIONMODEL_H
