// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pet _$PetFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['name', 'petType', 'breed', 'sex']);
  return Pet()
    ..id = json['id'] as int
    ..name = json['name'] as String
    ..petType = _$enumDecodeNullable(_$PetTypeEnumMap, json['petType'])
    ..breed = json['breed'] as String
    ..sex = _$enumDecodeNullable(_$SexEnumMap, json['sex']);
}

Map<String, dynamic> _$PetToJson(Pet instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'petType': _$PetTypeEnumMap[instance.petType],
      'breed': instance.breed,
      'sex': _$SexEnumMap[instance.sex],
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$PetTypeEnumMap = {
  PetType.none: 'none',
  PetType.dog: 'dog',
  PetType.cat: 'cat',
};

const _$SexEnumMap = {
  Sex.none: 'none',
  Sex.masc: 'masc',
  Sex.fem: 'fem',
};

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ObservablePet on ObservablePetBase, Store {
  final _$_petAtom = Atom(name: 'ObservablePetBase._pet');

  @override
  Pet get _pet {
    _$_petAtom.context.enforceReadPolicy(_$_petAtom);
    _$_petAtom.reportObserved();
    return super._pet;
  }

  @override
  set _pet(Pet value) {
    _$_petAtom.context.conditionallyRunInAction(() {
      super._pet = value;
      _$_petAtom.reportChanged();
    }, _$_petAtom, name: '${_$_petAtom.name}_set');
  }

  final _$ObservablePetBaseActionController =
      ActionController(name: 'ObservablePetBase');

  @override
  void addPhoto(String path) {
    final _$actionInfo = _$ObservablePetBaseActionController.startAction();
    try {
      return super.addPhoto(path);
    } finally {
      _$ObservablePetBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addThumbnail(Image thumbnail) {
    final _$actionInfo = _$ObservablePetBaseActionController.startAction();
    try {
      return super.addThumbnail(thumbnail);
    } finally {
      _$ObservablePetBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    final string = '';
    return '{$string}';
  }
}

mixin _$PetList on PetListBase, Store {
  final _$_listAtom = Atom(name: 'PetListBase._list');

  @override
  List<Pet> get _list {
    _$_listAtom.context.enforceReadPolicy(_$_listAtom);
    _$_listAtom.reportObserved();
    return super._list;
  }

  @override
  set _list(List<Pet> value) {
    _$_listAtom.context.conditionallyRunInAction(() {
      super._list = value;
      _$_listAtom.reportChanged();
    }, _$_listAtom, name: '${_$_listAtom.name}_set');
  }

  final _$PetListBaseActionController = ActionController(name: 'PetListBase');

  @override
  void setList(List<Pet> value) {
    final _$actionInfo = _$PetListBaseActionController.startAction();
    try {
      return super.setList(value);
    } finally {
      _$PetListBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeAt(int i) {
    final _$actionInfo = _$PetListBaseActionController.startAction();
    try {
      return super.removeAt(i);
    } finally {
      _$PetListBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void add(Pet value) {
    final _$actionInfo = _$PetListBaseActionController.startAction();
    try {
      return super.add(value);
    } finally {
      _$PetListBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    final string = '';
    return '{$string}';
  }
}
