// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adopters_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AdoptersStore on _AdoptersStore, Store {
  Computed<List<AdoptersGroup>>? _$groupedAdoptersComputed;

  @override
  List<AdoptersGroup> get groupedAdopters =>
      (_$groupedAdoptersComputed ??= Computed<List<AdoptersGroup>>(
        () => super.groupedAdopters,
        name: '_AdoptersStore.groupedAdopters',
      )).value;

  late final _$_adoptionsAtom = Atom(
    name: '_AdoptersStore._adoptions',
    context: context,
  );

  @override
  ObservableList<AdoptionModel> get _adoptions {
    _$_adoptionsAtom.reportRead();
    return super._adoptions;
  }

  @override
  set _adoptions(ObservableList<AdoptionModel> value) {
    _$_adoptionsAtom.reportWrite(value, super._adoptions, () {
      super._adoptions = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_AdoptersStore.isLoading',
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
    name: '_AdoptersStore.errorMessage',
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

  late final _$searchQueryAtom = Atom(
    name: '_AdoptersStore.searchQuery',
    context: context,
  );

  @override
  String get searchQuery {
    _$searchQueryAtom.reportRead();
    return super.searchQuery;
  }

  @override
  set searchQuery(String value) {
    _$searchQueryAtom.reportWrite(value, super.searchQuery, () {
      super.searchQuery = value;
    });
  }

  late final _$_AdoptersStoreActionController = ActionController(
    name: '_AdoptersStore',
    context: context,
  );

  @override
  void setSearchQuery(String v) {
    final _$actionInfo = _$_AdoptersStoreActionController.startAction(
      name: '_AdoptersStore.setSearchQuery',
    );
    try {
      return super.setSearchQuery(v);
    } finally {
      _$_AdoptersStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void start() {
    final _$actionInfo = _$_AdoptersStoreActionController.startAction(
      name: '_AdoptersStore.start',
    );
    try {
      return super.start();
    } finally {
      _$_AdoptersStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
errorMessage: ${errorMessage},
searchQuery: ${searchQuery},
groupedAdopters: ${groupedAdopters}
    ''';
  }
}
