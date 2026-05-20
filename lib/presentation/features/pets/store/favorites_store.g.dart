// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorites_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FavoritesStore on _FavoritesStore, Store {
  Computed<List<PetModel>>? _$filteredComputed;

  @override
  List<PetModel> get filtered =>
      (_$filteredComputed ??= Computed<List<PetModel>>(
        () => super.filtered,
        name: '_FavoritesStore.filtered',
      )).value;

  late final _$favoriteIdsAtom = Atom(
    name: '_FavoritesStore.favoriteIds',
    context: context,
  );

  @override
  ObservableSet<String> get favoriteIds {
    _$favoriteIdsAtom.reportRead();
    return super.favoriteIds;
  }

  @override
  set favoriteIds(ObservableSet<String> value) {
    _$favoriteIdsAtom.reportWrite(value, super.favoriteIds, () {
      super.favoriteIds = value;
    });
  }

  late final _$favoritesAtom = Atom(
    name: '_FavoritesStore.favorites',
    context: context,
  );

  @override
  ObservableList<PetModel> get favorites {
    _$favoritesAtom.reportRead();
    return super.favorites;
  }

  @override
  set favorites(ObservableList<PetModel> value) {
    _$favoritesAtom.reportWrite(value, super.favorites, () {
      super.favorites = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_FavoritesStore.isLoading',
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
    name: '_FavoritesStore.errorMessage',
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

  late final _$toggleFavoriteAsyncAction = AsyncAction(
    '_FavoritesStore.toggleFavorite',
    context: context,
  );

  @override
  Future<void> toggleFavorite(String petId) {
    return _$toggleFavoriteAsyncAction.run(() => super.toggleFavorite(petId));
  }

  late final _$_FavoritesStoreActionController = ActionController(
    name: '_FavoritesStore',
    context: context,
  );

  @override
  void start() {
    final _$actionInfo = _$_FavoritesStoreActionController.startAction(
      name: '_FavoritesStore.start',
    );
    try {
      return super.start();
    } finally {
      _$_FavoritesStoreActionController.endAction(_$actionInfo);
    }
  }

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
  String toString() {
    return '''
favoriteIds: ${favoriteIds},
favorites: ${favorites},
isLoading: ${isLoading},
errorMessage: ${errorMessage},
searchQuery: ${searchQuery},
filtered: ${filtered}
    ''';
  }
}
