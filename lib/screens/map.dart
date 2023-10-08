import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:favorite_places/models/place.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation? location;
  final bool isSelecting;
  const MapScreen.selectLocation({super.key})
      : location = null,
        isSelecting = true;

  const MapScreen.seeLocation({super.key, required this.location})
      : isSelecting = false;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isSelecting ? 'Select Location' : 'Place Location'),
        actions: [
          if (widget.isSelecting)
            IconButton(
              onPressed: () {
                Navigator.of(context).pop(_pickedLocation);
              },
              icon: const Icon(Icons.check),
            ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.location?.latitude ?? 37.422,
            widget.location?.longitude ?? -122.084,
          ),
          zoom: 16,
        ),
        onTap: widget.isSelecting
            ? (latlng) => setState(() {
                  _pickedLocation = latlng;
                })
            : null,
        markers: widget.isSelecting
            ? _pickedLocation == null
                ? {}
                : {
                    Marker(
                      markerId: const MarkerId('m1'),
                      position: _pickedLocation!,
                    ),
                  }
            : {
                Marker(
                  markerId: const MarkerId('m1'),
                  position: LatLng(
                    widget.location?.latitude ?? 37.422,
                    widget.location?.longitude ?? -122.084,
                  ),
                ),
              },
      ),
    );
  }
}
