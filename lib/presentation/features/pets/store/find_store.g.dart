// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'find_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FindStore on _FindStore, Store {
  Computed<bool>? _$isLoadingComputed;

  @override
  bool get isLoading => (_$isLoadingComputed ??= Computed<bool>(
    () => super.isLoading,
    name: '_FindStore.isLoading',
  )).value;
  Computed<String?>? _$errorMessageComputed;

  @override
  String? get errorMessage => (_$errorMessageComputed ??= Computed<String?>(
    () => super.errorMessage,
    name: '_FindStore.errorMessage',
  )).value;

  late final _$isAdoptingAtom = Atom(
    name: '_FindStore.isAdopting',
    context: context,
  );

  @override
  bool get isAdopting {
    _$isAdoptingAtom.reportRead();
    return super.isAdopting;
  }

  @override
  set isAdopting(bool value) {
    _$isAdoptingAtom.reportWrite(value, super.isAdopting, () {
      super.isAdopting = value;
    });
  }

  late final _$adoptErrorMessageAtom = Atom(
    name: '_FindStore.adoptErrorMessage',
    context: context,
  );

  @override
  String? get adoptErrorMessage {
    _$adoptErrorMessageAtom.reportRead();
    return super.adoptErrorMessage;
  }

  @override
  set adoptErrorMessage(String? value) {
    _$adoptErrorMessageAtom.reportWrite(value, super.adoptErrorMessage, () {
      super.adoptErrorMessage = value;
    });
  }

  late final _$requestAdoptionAsyncAction = AsyncAction(
    '_FindStore.requestAdoption',
    context: context,
  );

  @override
  Future<RequestAdoptionResult> requestAdoption(PetModel pet) {
    return _$requestAdoptionAsyncAction.run(() => super.requestAdoption(pet));
  }

  late final _$_FindStoreActionController = ActionController(
    name: '_FindStore',
    context: context,
  );

  @override
  Future<void> loadPets() {
    final _$actionInfo = _$_FindStoreActionController.startAction(
      name: '_FindStore.loadPets',
    );
    try {
      return super.loadPets();
    } finally {
      _$_FindStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setEspecieFilter(String? v) {
    final _$actionInfo = _$_FindStoreActionController.startAction(
      name: '_FindStore.setEspecieFilter',
    );
    try {
      return super.setEspecieFilter(v);
    } finally {
      _$_FindStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPorteFilter(String? v) {
    final _$actionInfo = _$_FindStoreActionController.startAction(
      name: '_FindStore.setPorteFilter',
    );
    try {
      return super.setPorteFilter(v);
    } finally {
      _$_FindStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isAdopting: ${isAdopting},
adoptErrorMessage: ${adoptErrorMessage},
isLoading: ${isLoading},
errorMessage: ${errorMessage}
    ''';
  }
}
