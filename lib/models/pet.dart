import 'package:mobx/mobx.dart';

part 'pet.g.dart';

enum PetType { none, dog, cat }
enum Sex { none, masc, fem }

class Pet = _PetBase with _$Pet;

abstract class _PetBase with Store {
  // Ids are not shown in
  int id;
  String remoteId;

  @observable
  String name = "";
  @observable
  String breed = "";
  @observable
  PetType petType = PetType.none;
  @observable
  Sex sex = Sex.none;

  @observable
  List<String> photos = List<String>();
  @observable
  List<List<int>> thumbnails = List<List<int>>(); // For displaying purposes


  _PetBase() {
    id = null;
    name = "";
    petType = PetType.none;
    breed = "";
    sex = Sex.none;
    remoteId = null;
  }

  _PetBase.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    remoteId = json['remoteId'];
    name = json['name'];
    breed = json['breed'];
    petType = getPetTypeFromString(json['petType']);
    sex = getSexFromString(json['sex']);
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
  void addPhoto(String path) {
    photos.add(path);
  }

  @action
  void removePhoto(int i) {
    photos.removeAt(i);
  }


  @action
  void addThumbnail(List<int> thumbnail) {
    thumbnails.add(thumbnail);
  }

  @action
  void removeThumbnail(int i) {
    thumbnails.removeAt(i);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'remoteId': remoteId,
      'name': name,
      'petType': getStringFromPetType(petType),
      'sex': getStringFromSex(sex),
    };

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





