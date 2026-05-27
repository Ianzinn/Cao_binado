// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_animal_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$EditAnimalStore on _EditAnimalStore, Store {
  Computed<bool>? _$isFormValidComputed;

  @override
  bool get isFormValid => (_$isFormValidComputed ??= Computed<bool>(
    () => super.isFormValid,
    name: '_EditAnimalStore.isFormValid',
  )).value;

  late final _$nameAtom = Atom(name: '_EditAnimalStore.name', context: context);

  @override
  String get name {
    _$nameAtom.reportRead();
    return super.name;
  }

  @override
  set name(String value) {
    _$nameAtom.reportWrite(value, super.name, () {
      super.name = value;
    });
  }

  late final _$ageAtom = Atom(name: '_EditAnimalStore.age', context: context);

  @override
  String get age {
    _$ageAtom.reportRead();
    return super.age;
  }

  @override
  set age(String value) {
    _$ageAtom.reportWrite(value, super.age, () {
      super.age = value;
    });
  }

  late final _$animalClassAtom = Atom(
    name: '_EditAnimalStore.animalClass',
    context: context,
  );

  @override
  String get animalClass {
    _$animalClassAtom.reportRead();
    return super.animalClass;
  }

  @override
  set animalClass(String value) {
    _$animalClassAtom.reportWrite(value, super.animalClass, () {
      super.animalClass = value;
    });
  }

  late final _$sizeAtom = Atom(name: '_EditAnimalStore.size', context: context);

  @override
  String get size {
    _$sizeAtom.reportRead();
    return super.size;
  }

  @override
  set size(String value) {
    _$sizeAtom.reportWrite(value, super.size, () {
      super.size = value;
    });
  }

  late final _$breedAtom = Atom(
    name: '_EditAnimalStore.breed',
    context: context,
  );

  @override
  String get breed {
    _$breedAtom.reportRead();
    return super.breed;
  }

  @override
  set breed(String value) {
    _$breedAtom.reportWrite(value, super.breed, () {
      super.breed = value;
    });
  }

  late final _$descriptionAtom = Atom(
    name: '_EditAnimalStore.description',
    context: context,
  );

  @override
  String get description {
    _$descriptionAtom.reportRead();
    return super.description;
  }

  @override
  set description(String value) {
    _$descriptionAtom.reportWrite(value, super.description, () {
      super.description = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_EditAnimalStore.isLoading',
    context: context,
  );

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: '_EditAnimalStore.errorMessage',
    context: context,
  );

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$saveAsyncAction = AsyncAction(
    '_EditAnimalStore.save',
    context: context,
  );

  @override
  Future<bool> save() {
    return _$saveAsyncAction.run(() => super.save());
  }

  late final _$_EditAnimalStoreActionController = ActionController(
    name: '_EditAnimalStore',
    context: context,
  );

  @override
  void setName(String v) {
    final _$actionInfo = _$_EditAnimalStoreActionController.startAction(
      name: '_EditAnimalStore.setName',
    );
    try {
      return super.setName(v);
    } finally {
      _$_EditAnimalStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAge(String v) {
    final _$actionInfo = _$_EditAnimalStoreActionController.startAction(
      name: '_EditAnimalStore.setAge',
    );
    try {
      return super.setAge(v);
    } finally {
      _$_EditAnimalStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAnimalClass(String v) {
    final _$actionInfo = _$_EditAnimalStoreActionController.startAction(
      name: '_EditAnimalStore.setAnimalClass',
    );
    try {
      return super.setAnimalClass(v);
    } finally {
      _$_EditAnimalStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSize(String v) {
    final _$actionInfo = _$_EditAnimalStoreActionController.startAction(
      name: '_EditAnimalStore.setSize',
    );
    try {
      return super.setSize(v);
    } finally {
      _$_EditAnimalStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setBreed(String v) {
    final _$actionInfo = _$_EditAnimalStoreActionController.startAction(
      name: '_EditAnimalStore.setBreed',
    );
    try {
      return super.setBreed(v);
    } finally {
      _$_EditAnimalStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDescription(String v) {
    final _$actionInfo = _$_EditAnimalStoreActionController.startAction(
      name: '_EditAnimalStore.setDescription',
    );
    try {
      return super.setDescription(v);
    } finally {
      _$_EditAnimalStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
name: ${name},
age: ${age},
animalClass: ${animalClass},
size: ${size},
breed: ${breed},
description: ${description},
isLoading: ${isLoading},
errorMessage: ${errorMessage},
isFormValid: ${isFormValid}
    ''';
  }
}
