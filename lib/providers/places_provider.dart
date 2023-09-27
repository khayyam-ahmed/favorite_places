import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:favorite_places/models/place.dart';

class FavoritePlacesNotifier extends StateNotifier<List<Place>> {
  FavoritePlacesNotifier() : super([]);

  void addFavoritePlace(String name) {
    final place = Place(name: name);
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
