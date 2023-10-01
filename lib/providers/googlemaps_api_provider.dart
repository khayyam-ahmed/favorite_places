import 'package:flutter_riverpod/flutter_riverpod.dart';

class GoogleMapsAPINotifier extends StateNotifier<String> {
  /// Initializes the [GoogleMapsAPINotifier] with the API key.
  GoogleMapsAPINotifier() : super('AIzaSyBFJBcNYJbC5E9rxigzJ3tPGkEEivGfE64');
}

final googleMapsAPIProvider =
    StateNotifierProvider<GoogleMapsAPINotifier, String>(
  (ref) => GoogleMapsAPINotifier(),
);
