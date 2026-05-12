// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorites_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FavoritesStore on _FavoritesStore, Store {
  Computed<List<PetItem>>? _$filteredComputed;

  @override
  List<PetItem> get filtered => (_$filteredComputed ??= Computed<List<PetItem>>(
    () => super.filtered,
    name: '_FavoritesStore.filtered',
  )).value;

  late final _$favoritesAtom = Atom(
    name: '_FavoritesStore.favorites',
    context: context,
  );

  @override
  ObservableList<PetItem> get favorites {
    _$favoritesAtom.reportRead();
    return super.favorites;
  }

  @override
  set favorites(ObservableList<PetItem> value) {
    _$favoritesAtom.reportWrite(value, super.favorites, () {
      super.favorites = value;
    });
  }

  late final _$searchQueryAtom = Atom(
    name: '_FavoritesStore.searchQuery',
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

  late final _$_FavoritesStoreActionController = ActionController(
    name: '_FavoritesStore',
    context: context,
  );

  @override
  void setSearchQuery(String v) {
    final _$actionInfo = _$_FavoritesStoreActionController.startAction(
      name: '_FavoritesStore.setSearchQuery',
    );
    try {
      return super.setSearchQuery(v);
    } finally {
      _$_FavoritesStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeFavorite(String id) {
    final _$actionInfo = _$_FavoritesStoreActionController.startAction(
      name: '_FavoritesStore.removeFavorite',
    );
    try {
      return super.removeFavorite(id);
    } finally {
      _$_FavoritesStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
favorites: ${favorites},
searchQuery: ${searchQuery},
filtered: ${filtered}
    ''';
  }
}
