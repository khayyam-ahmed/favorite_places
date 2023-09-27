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
      body: Stack(
        children: [
          Image.file(
            place.img,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 250,
          ),
          // Text(
          //   place.name,
          //   style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
          // ),
        ],
      ),
    );
  }
}
