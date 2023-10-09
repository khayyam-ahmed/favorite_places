import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

import 'package:favorite_places/models/place.dart';

Future<Database> getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'places.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)',
      );
    },
    version: 1,
  );
  return db;
}

class FavoritePlacesNotifier extends StateNotifier<List<Place>> {
  FavoritePlacesNotifier() : super([]);

  Future<void> loadPlaces() async {
    final db = await getDatabase();
    final data = await db.query('user_places');
    final places = data.map(
      (row) => Place(
        name: row['title'] as String,
        img: File(row['image'] as String),
        location: PlaceLocation(
          latitude: row['lat'] as double,
          longitude: row['lng'] as double,
          address: row['address'] as String,
        ),
        id: row['id'] as String,
      ),
    );

    state = places.toList();
  }

  void addFavoritePlace(String name, File img, PlaceLocation location) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final filename = path.basename(img.path);
    final copiedImage = await img.copy('${appDir.path}/$filename');

    // final newPlace
    final place = Place(
      name: name,
      img: copiedImage,
      location: location,
    );

    final db = await getDatabase();
    db.insert('user_places', {
      'id': place.id,
      'title': place.name,
      'image': place.img.path,
      'lat': place.location.latitude,
      'lng': place.location.longitude,
      'address': place.location.address,
    });
    state = [...state, place];
  }

  void removeFavoritePlace(Place place) {
    state = state.where((element) => element != place).toList();
  }
}

final favoritePlacesProvider =
    StateNotifierProvider<FavoritePlacesNotifier, List<Place>>(
  (ref) => FavoritePlacesNotifier(),
);
