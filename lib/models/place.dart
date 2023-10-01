import 'package:uuid/uuid.dart';
import 'dart:io';

class PlaceLocation {
  PlaceLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
  });
  final double latitude;
  final double longitude;
  final String address;
}

class Place {
  Place({required this.name, required this.img, required this.location})
      : id = const Uuid().v4() {
    // print(this.id);
  }
  final String id;
  final String name;
  final File img;
  final PlaceLocation location;
}
