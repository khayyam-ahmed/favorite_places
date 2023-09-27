import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:favorite_places/providers/places_provider.dart';

class AddPlaceScreen extends ConsumerWidget {
  const AddPlaceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var _name;
    final _formKey = GlobalKey<FormState>();

    void _submitForm() {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        ref.read(favoritePlacesProvider.notifier).addFavoritePlace(_name);
        Navigator.of(context).pop();
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
              key: _formKey,
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
                      _name = value;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton.icon(
                    onPressed: () {
                      _submitForm();
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
