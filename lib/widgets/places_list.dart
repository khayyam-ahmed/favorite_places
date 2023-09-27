import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/screens/place_details.dart';
import 'package:flutter/material.dart';

class PlacesList extends StatelessWidget {
  const PlacesList({super.key, required List<Place> places}) : _places = places;
  final List<Place> _places;
  @override
  Widget build(BuildContext context) {
    bool empty = true;
    if (_places.isNotEmpty) {
      empty = false;
    }

    return empty
        ? Center(
            child: Text('No item found.',
                style: Theme.of(context).textTheme.titleMedium),
          )
        : ListView.builder(
            itemCount: _places.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_places[index].name),
                leading: CircleAvatar(
                  backgroundImage: FileImage(_places[index].img),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          PlaceDetailsScreen(place: _places[index]),
                    ),
                  );
                },
              );
            });
  }
}
