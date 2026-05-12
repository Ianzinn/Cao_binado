// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PetStore on _PetStore, Store {
  Computed<List<PetModel>>? _$filteredPetsComputed;

  @override
  List<PetModel> get filteredPets =>
      (_$filteredPetsComputed ??= Computed<List<PetModel>>(
        () => super.filteredPets,
        name: '_PetStore.filteredPets',
      )).value;

  late final _$petsAtom = Atom(name: '_PetStore.pets', context: context);

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

  late final _$selectedImagesAtom = Atom(
    name: '_PetStore.selectedImages',
    context: context,
  );

  @override
  ObservableList<File> get selectedImages {
    _$selectedImagesAtom.reportRead();
    return super.selectedImages;
  }

  @override
  set selectedImages(ObservableList<File> value) {
    _$selectedImagesAtom.reportWrite(value, super.selectedImages, () {
      super.selectedImages = value;
    });
  }

  late final _$especieFilterAtom = Atom(
    name: '_PetStore.especieFilter',
    context: context,
  );

  @override
  String? get especieFilter {
    _$especieFilterAtom.reportRead();
    return super.especieFilter;
  }

  @override
  set especieFilter(String? value) {
    _$especieFilterAtom.reportWrite(value, super.especieFilter, () {
      super.especieFilter = value;
    });
  }

  late final _$porteFilterAtom = Atom(
    name: '_PetStore.porteFilter',
    context: context,
  );

  @override
  String? get porteFilter {
    _$porteFilterAtom.reportRead();
    return super.porteFilter;
  }

  @override
  set porteFilter(String? value) {
    _$porteFilterAtom.reportWrite(value, super.porteFilter, () {
      super.porteFilter = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_PetStore.isLoading',
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
    name: '_PetStore.errorMessage',
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

  late final _$loadPetsAsyncAction = AsyncAction(
    '_PetStore.loadPets',
    context: context,
  );

  @override
  Future<void> loadPets() {
    return _$loadPetsAsyncAction.run(() => super.loadPets());
  }

  late final _$pickImageAsyncAction = AsyncAction(
    '_PetStore.pickImage',
    context: context,
  );

  @override
  Future<void> pickImage() {
    return _$pickImageAsyncAction.run(() => super.pickImage());
  }

  late final _$savePetAsyncAction = AsyncAction(
    '_PetStore.savePet',
    context: context,
  );

  @override
  Future<bool> savePet(PetModel pet) {
    return _$savePetAsyncAction.run(() => super.savePet(pet));
  }

  late final _$_PetStoreActionController = ActionController(
    name: '_PetStore',
    context: context,
  );

  @override
  void setEspecieFilter(String? v) {
    final _$actionInfo = _$_PetStoreActionController.startAction(
      name: '_PetStore.setEspecieFilter',
    );
    try {
      return super.setEspecieFilter(v);
    } finally {
      _$_PetStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPorteFilter(String? v) {
    final _$actionInfo = _$_PetStoreActionController.startAction(
      name: '_PetStore.setPorteFilter',
    );
    try {
      return super.setPorteFilter(v);
    } finally {
      _$_PetStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeImage(int index) {
    final _$actionInfo = _$_PetStoreActionController.startAction(
      name: '_PetStore.removeImage',
    );
    try {
      return super.removeImage(index);
    } finally {
      _$_PetStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
pets: ${pets},
selectedImages: ${selectedImages},
especieFilter: ${especieFilter},
porteFilter: ${porteFilter},
isLoading: ${isLoading},
errorMessage: ${errorMessage},
filteredPets: ${filteredPets}
    ''';
  }
}
