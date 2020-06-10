import 'package:mobx/mobx.dart';

part 'pet.g.dart';

enum PetType { none, dog, cat }
enum Sex { none, masc, fem }


class Photo {
  static final String suffix = ".thumbnail.png";
  bool uploaded = false; // If true, object must be
  String path;

  Photo({this.uploaded=false, this.path});

  String getThumbnail() {
    return path + suffix;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> out = {
      "path": path,
      "uploaded": uploaded,
    };

    return out;
  }

  Photo.fromJson(Map<String, dynamic> json) {
    uploaded = json['edited'];
    path = json['path'];
  }
}

class Pet = _PetBase with _$Pet;

abstract class _PetBase with Store {
  // Ids are not shown in
  int id;
  int localId;

  @observable
  String name = "";
  @observable
  String breed = "";
  @observable
  PetType petType = PetType.none;
  @observable
  Sex sex = Sex.none;
  @observable
  bool edited = false;

  @observable
  List<Photo> photos = List<Photo>();


  _PetBase() {
    id = null;
    name = "";
    petType = PetType.none;
    breed = "";
    sex = Sex.none;
    localId = null;
    edited = false;
    photos = List<Photo>();
  }

  _PetBase.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    breed = json['breed'];
    petType = getPetTypeFromString(json['petType']);
    sex = getSexFromString(json['sex']);

    // Set photos
    photos = json['photos'].map((Map<String, dynamic> e) {
      return Photo.fromJson(e);
    });

    if (json.containsKey('localId'))
      localId = json['localId'];

    if (json.containsKey('edited'))
      edited = json['edited'];
    else
      edited = false;
  }

  Map<String, dynamic> toJson({bool local=true}) {
    var photosJson = photos.map((Photo p) => p.toJson()).toList();

    Map<String, dynamic> out = {
      'id': id,
      'name': name,
      'breed': breed,
      'petType': getStringFromPetType(petType),
      'sex': getStringFromSex(sex),
      'photos': photosJson,
    };

    if (local) {
      out['localId'] = localId;
      out['edited'] = edited;
    }

    return out;
  }

  @action
  void setName(String value) {
    name = value;
  }

  @action
  void setBreed(String value) {
    breed = value;
  }

  @action
  void setPetType(PetType value) {
    petType = value;
  }

  @action
  void setSex(Sex value) {
    sex = value;
  }

  @action
  void addPhoto(Photo photo) {
    photos.add(photo);
  }

  @action
  void removePhoto(int i) {
    photos.removeAt(i);
  }
}


// For json serialization
// PetType
PetType getPetTypeFromString(String petTypeAsString) {
  for (PetType element in PetType.values) {
    if (element.toString().split('.')[1] == petTypeAsString) {
      return element;
    }
  }
  return null;
}

String getStringFromPetType(PetType type) {
  return type.toString().split('.')[1];
}

// Sex
Sex getSexFromString(String sexAsString) {
  for (Sex element in Sex.values) {
    if (element.toString().split('.')[1] == sexAsString) {
      return element;
    }
  }
  return null;
}

String getStringFromSex(Sex sex) {
  return sex.toString().split('.')[1];
}





