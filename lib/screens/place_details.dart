import 'package:favorite_places/models/place.dart';
import 'package:flutter/material.dart';

class PlaceDetailsScreen extends StatelessWidget {
  const PlaceDetailsScreen({super.key, required this.place});
  final Place place;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.name),
      ),
      body: Center(
        child: Text(
          place.name,
          style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
        ),
      ),
    );
  }
}
