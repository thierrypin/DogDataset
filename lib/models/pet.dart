import 'package:json_annotation/json_annotation.dart';
import 'package:image/image.dart';
import 'package:mobx/mobx.dart';

part 'pet.g.dart';

enum PetType { none, dog, cat }
enum Sex { none, masc, fem }

@JsonSerializable()
class Pet {
  int id;
  @JsonKey(required: true)
  String name = "";
  @JsonKey(required: true)
  PetType petType = PetType.none;
  @JsonKey(required: true)
  String breed = "";
  @JsonKey(required: true)
  Sex sex = Sex.none;
  @JsonKey(ignore: true)
  String remoteId;
  @JsonKey(ignore: true)
  List<String> photos = List<String>();
  @JsonKey(ignore: true)
  List<Image> thumbnails = List<Image>(); // For displaying purposes

  Pet() {
    id = null;
    name = "";
    petType = PetType.none;
    breed = "";
    sex = Sex.none;
    remoteId = null;
  }

  factory Pet.fromJson(Map<String, dynamic> json) => _$PetFromJson(json);
  Map<String, dynamic> toJson() => _$PetToJson(this);
}


class ObservablePet = ObservablePetBase with _$ObservablePet;

abstract class ObservablePetBase with Store {
  @observable
  Pet _pet;

  Pet get() {return _pet;}

  ObservablePetBase(Pet p) {
    this._pet = p;
  }

  @action
  void addPhoto(String path) {
    _pet.photos.add(path);
  }

  @action
  void addThumbnail(Image thumbnail) {
    _pet.thumbnails.add(thumbnail);
  }

  // Actions
//  @action
//  void setList(List<Pet> value) { _list = value; }
//
//  @action
//  void removeAt(int i) { _list.removeAt(i); }
//
//  @action
//  void add(Pet value) { _list.add(value); }
}

class PetList = PetListBase with _$PetList;

abstract class PetListBase with Store {
  @observable
  List<Pet> _list = List<Pet>();

  // Access operators
  operator [](int i) => _list[i]; // get
//  operator []=(int i, Pet value) => _list[i] = value; // set is not used here

  // State retrievers
  bool isEmpty() => _list.isEmpty;
  int length() => _list.length;

  // Actions
  @action
  void setList(List<Pet> value) { _list = value; }

  @action
  void removeAt(int i) { _list.removeAt(i); }

  @action
  void add(Pet value) { _list.add(value); }
}

