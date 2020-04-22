
import 'dart:io';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import '../models/pet.dart';

void savePet(Pet pet) async {
  // Make pet directory
  Directory basepath = await getApplicationDocumentsDirectory();
  Directory directory = Directory(join(basepath.path, pet.id.toString().padLeft(6, '0')));
  await directory.create();
  print(directory.path);

  // Populate json
  File f = File(directory.path + '/' + "info.json");
  // TODO
  f.writeAsString(json.encode(pet.toJson()));

  var prefs = await SharedPreferences.getInstance();

  prefs.setInt("id_counter", pet.id + 1);
}

void deletePet(Pet pet) async {
  Directory basepath = await getApplicationDocumentsDirectory();
  Directory directory = Directory(join(basepath.path, pet.id.toString().padLeft(6, '0')));
  await directory.delete(recursive: true);
}

String getPetEmoji(PetType petType) {
  if (petType == PetType.cat) {
    return "🐱";
  } else if (petType == PetType.dog) {
    return "🐕";
  } else {
    return "👽";
  }
}

String getPetTypeStr(PetType type) {
  if (type == PetType.dog)
    return "Cachorro";
  else if (type == PetType.cat)
    return "Gato";
  else
    return "Alien";
}

Future<List<Pet>> loadPets() async {
  Directory directory = await getApplicationDocumentsDirectory();
  List<Directory> petDirs = List<Directory>();

  for (FileSystemEntity e in directory.listSync()) {
    if (e is Directory) {
      petDirs.add(e);
    }
  }

  List<Pet> pets = List<Pet>();
  // A Valid pet is a folder having a info.json file
  for (Directory dir in petDirs) {
    File f = File(dir.path + '/' + "info.json");
    bool exists = await f.exists();
    if (exists) {
      String contents = await f.readAsString();
      Pet pet = Pet.fromJson(json.decode(contents));
      pet.photos = List<String>();

      // Load images
      for (FileSystemEntity e in dir.listSync()) {
        if (e is File && e.path.endsWith(".png")) {
          pet.photos.add(e.path);
        }
      }

      pets.add(pet);
    }
  }

  return pets;
}

Future<String> getPetPath(Pet pet) async {
  Directory directory = await getApplicationDocumentsDirectory();

  return join(directory.path, pet.id.toString().padLeft(6, '0'));
}
