import 'dart:convert';

import 'package:favorite_places/providers/googlemaps_api_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

import 'package:favorite_places/models/place.dart';

// final apiKey = Provider((ref) {
//   // use ref to obtain other providers
//   final api = ref.read(googleMapsAPIProvider);

//   return api;
// });

class LocationInput extends ConsumerStatefulWidget {
  const LocationInput({super.key, required this.onAddLocation});

  final void Function(PlaceLocation placeLocation) onAddLocation;

  @override
  ConsumerState<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends ConsumerState<LocationInput> {
  PlaceLocation? _pickedLocation;
  bool isGettingLocation = false;

  String locationImage({required String kApiKey}) {
    if (_pickedLocation == null) return '';
    final lat = _pickedLocation!.latitude;
    final lng = _pickedLocation!.longitude;
    return "https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=13&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lng&key=$kApiKey";
  }

  void getCurrentLocation(String kApiKey) async {
    // Called on a button press, this method will get the current location of the device.
    //
    /// The following snippet is from the location package documentation (https://pub.dev/packages/location).
    /// It's:
    /// 1. Checking if location services are enabled
    /// 2. Requesting location services if they are not enabled
    /// 3. Checking if the app has permission to access location data
    /// 4. Requesting permission if it does not have permission
    /// 5. Getting the location data

    setState(() {
      isGettingLocation = true;
    });

    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();

    /// The following snippet is:
    /// 1. Getting the latitude and longitude from the location data
    /// 2. Making a request to the Google Maps Geocoding API (using the data from Step 2) to get the address
    /// 3. Getting a formatted address from the response
    /// 4. Setting the state with the formatted address

    final lat = locationData.latitude;
    final lng = locationData.longitude;
    if (lat == null || lng == null) return;

    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$kApiKey');

    final response = await http.get(url);
    final resData = json.decode(response.body);
    final formattedAddress = resData['results'][0]['formatted_address'];

    setState(() {
      _pickedLocation = PlaceLocation(
        latitude: lat,
        longitude: lng,
        address: formattedAddress,
      );
      widget.onAddLocation(_pickedLocation!);
      isGettingLocation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    String kApiKey = ref.read(googleMapsAPIProvider);
    Widget previewContent = Text(
      'No location chosen',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
    );

    if (_pickedLocation != null) {
      previewContent = Image.network(
        locationImage(kApiKey: kApiKey),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    if (isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    }

    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),
          ),
          child: previewContent,
        ),
        Row(
          children: [
            TextButton.icon(
              icon: const Icon(Icons.location_on),
              label: const Text('Get Current Location'),
              onPressed: () => getCurrentLocation(kApiKey),
            ),
            TextButton.icon(
              icon: const Icon(Icons.map),
              label: const Text('Select on Map'),
              onPressed: () {},
            ),
          ],
        )
      ],
    );
  }
}
