// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_pets_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MyPetsStore on _MyPetsStore, Store {
  late final _$petsAtom = Atom(name: '_MyPetsStore.pets', context: context);

  @override
  ObservableList<PetModel> get pets {
    _$petsAtom.reportRead();
    return super.pets;
  }

  @override
  set pets(ObservableList<PetModel> value) {
    _$petsAtom.reportWrite(value, super.pets, () {
      super.pets = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_MyPetsStore.isLoading',
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
    name: '_MyPetsStore.errorMessage',
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

  late final _$deletePetAsyncAction = AsyncAction(
    '_MyPetsStore.deletePet',
    context: context,
  );

  @override
  Future<bool> deletePet(String petId) {
    return _$deletePetAsyncAction.run(() => super.deletePet(petId));
  }

  late final _$_MyPetsStoreActionController = ActionController(
    name: '_MyPetsStore',
    context: context,
  );

  @override
  void start() {
    final _$actionInfo = _$_MyPetsStoreActionController.startAction(
      name: '_MyPetsStore.start',
    );
    try {
      return super.start();
    } finally {
      _$_MyPetsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
pets: ${pets},
isLoading: ${isLoading},
errorMessage: ${errorMessage}
    ''';
  }
}
