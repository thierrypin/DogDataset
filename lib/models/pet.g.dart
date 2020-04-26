// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$Pet on _PetBase, Store {
  final _$nameAtom = Atom(name: '_PetBase.name');

  @override
  String get name {
    _$nameAtom.context.enforceReadPolicy(_$nameAtom);
    _$nameAtom.reportObserved();
    return super.name;
  }

  @override
  set name(String value) {
    _$nameAtom.context.conditionallyRunInAction(() {
      super.name = value;
      _$nameAtom.reportChanged();
    }, _$nameAtom, name: '${_$nameAtom.name}_set');
  }

  final _$breedAtom = Atom(name: '_PetBase.breed');

  @override
  String get breed {
    _$breedAtom.context.enforceReadPolicy(_$breedAtom);
    _$breedAtom.reportObserved();
    return super.breed;
  }

  @override
  set breed(String value) {
    _$breedAtom.context.conditionallyRunInAction(() {
      super.breed = value;
      _$breedAtom.reportChanged();
    }, _$breedAtom, name: '${_$breedAtom.name}_set');
  }

  final _$petTypeAtom = Atom(name: '_PetBase.petType');

  @override
  PetType get petType {
    _$petTypeAtom.context.enforceReadPolicy(_$petTypeAtom);
    _$petTypeAtom.reportObserved();
    return super.petType;
  }

  @override
  set petType(PetType value) {
    _$petTypeAtom.context.conditionallyRunInAction(() {
      super.petType = value;
      _$petTypeAtom.reportChanged();
    }, _$petTypeAtom, name: '${_$petTypeAtom.name}_set');
  }

  final _$sexAtom = Atom(name: '_PetBase.sex');

  @override
  Sex get sex {
    _$sexAtom.context.enforceReadPolicy(_$sexAtom);
    _$sexAtom.reportObserved();
    return super.sex;
  }

  @override
  set sex(Sex value) {
    _$sexAtom.context.conditionallyRunInAction(() {
      super.sex = value;
      _$sexAtom.reportChanged();
    }, _$sexAtom, name: '${_$sexAtom.name}_set');
  }

  final _$photosAtom = Atom(name: '_PetBase.photos');

  @override
  List<String> get photos {
    _$photosAtom.context.enforceReadPolicy(_$photosAtom);
    _$photosAtom.reportObserved();
    return super.photos;
  }

  @override
  set photos(List<String> value) {
    _$photosAtom.context.conditionallyRunInAction(() {
      super.photos = value;
      _$photosAtom.reportChanged();
    }, _$photosAtom, name: '${_$photosAtom.name}_set');
  }

  final _$thumbnailsAtom = Atom(name: '_PetBase.thumbnails');

  @override
  List<Image> get thumbnails {
    _$thumbnailsAtom.context.enforceReadPolicy(_$thumbnailsAtom);
    _$thumbnailsAtom.reportObserved();
    return super.thumbnails;
  }

  @override
  set thumbnails(List<Image> value) {
    _$thumbnailsAtom.context.conditionallyRunInAction(() {
      super.thumbnails = value;
      _$thumbnailsAtom.reportChanged();
    }, _$thumbnailsAtom, name: '${_$thumbnailsAtom.name}_set');
  }

  final _$_PetBaseActionController = ActionController(name: '_PetBase');

  @override
  void setName(String value) {
    final _$actionInfo = _$_PetBaseActionController.startAction();
    try {
      return super.setName(value);
    } finally {
      _$_PetBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setBreed(String value) {
    final _$actionInfo = _$_PetBaseActionController.startAction();
    try {
      return super.setBreed(value);
    } finally {
      _$_PetBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPetType(PetType value) {
    final _$actionInfo = _$_PetBaseActionController.startAction();
    try {
      return super.setPetType(value);
    } finally {
      _$_PetBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSex(Sex value) {
    final _$actionInfo = _$_PetBaseActionController.startAction();
    try {
      return super.setSex(value);
    } finally {
      _$_PetBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addPhoto(String path) {
    final _$actionInfo = _$_PetBaseActionController.startAction();
    try {
      return super.addPhoto(path);
    } finally {
      _$_PetBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addThumbnail(Image thumbnail) {
    final _$actionInfo = _$_PetBaseActionController.startAction();
    try {
      return super.addThumbnail(thumbnail);
    } finally {
      _$_PetBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    final string =
        'name: ${name.toString()},breed: ${breed.toString()},petType: ${petType.toString()},sex: ${sex.toString()},photos: ${photos.toString()},thumbnails: ${thumbnails.toString()}';
    return '{$string}';
  }
}
