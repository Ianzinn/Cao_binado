// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adopters_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AdoptersStore on _AdoptersStore, Store {
  Computed<List<AdopterItem>>? _$filteredComputed;

  @override
  List<AdopterItem> get filtered =>
      (_$filteredComputed ??= Computed<List<AdopterItem>>(
        () => super.filtered,
        name: '_AdoptersStore.filtered',
      )).value;

  late final _$adoptersAtom = Atom(
    name: '_AdoptersStore.adopters',
    context: context,
  );

  @override
  ObservableList<AdopterItem> get adopters {
    _$adoptersAtom.reportRead();
    return super.adopters;
  }

  @override
  set adopters(ObservableList<AdopterItem> value) {
    _$adoptersAtom.reportWrite(value, super.adopters, () {
      super.adopters = value;
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
  void removeAdopter(String id) {
    final _$actionInfo = _$_AdoptersStoreActionController.startAction(
      name: '_AdoptersStore.removeAdopter',
    );
    try {
      return super.removeAdopter(id);
    } finally {
      _$_AdoptersStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
adopters: ${adopters},
searchQuery: ${searchQuery},
filtered: ${filtered}
    ''';
  }
}
