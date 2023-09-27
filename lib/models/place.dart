import 'package:uuid/uuid.dart';
import 'dart:io';

class Place {
  Place({required this.name, required this.img}) : id = const Uuid().v4() {
    // print(this.id);
  }
  final String id;
  final String name;
  final File img;
}
