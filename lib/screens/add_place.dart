import 'dart:io';
import 'package:favorite_places/widgets/image_input.dart';
import 'package:favorite_places/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:favorite_places/providers/places_provider.dart';

class AddPlaceScreen extends ConsumerWidget {
  const AddPlaceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var name;
    late final File? img;

    final formKey = GlobalKey<FormState>();

    void onAddImage(File image) {
      img = image;
    }

    void submitForm() {
      if (formKey.currentState!.validate() || img != null) {
        formKey.currentState!.save();
        ref.read(favoritePlacesProvider.notifier).addFavoritePlace(name, img!);
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a place and add an image'),
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a favorite place'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground),
                    decoration: InputDecoration(
                      hintText: 'Enter a place',
                      hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a place';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      name = value;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  ImageInput(onAddImage: onAddImage),
                  const SizedBox(height: 16.0),
                  const LocationInput(),
                  const SizedBox(height: 16.0),
                  ElevatedButton.icon(
                    onPressed: () {
                      submitForm();
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Submit'),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
