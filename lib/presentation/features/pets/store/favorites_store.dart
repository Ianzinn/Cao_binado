// ignore_for_file: library_private_types_in_public_api
import 'package:mobx/mobx.dart';

part 'favorites_store.g.dart';

class PetItem {
  PetItem({
    required this.id,
    required this.name,
    required this.age,
    required this.breed,
    this.imageUrl,
  });
  final String id;
  final String name;
  final String age;
  final String breed;
  final String? imageUrl;
}

class FavoritesStore = _FavoritesStore with _$FavoritesStore;

abstract class _FavoritesStore with Store {
  @observable
  ObservableList<PetItem> favorites = ObservableList.of([
    PetItem(id: '1', name: 'Lilica', age: '1 ano e 6 meses', breed: 'Welsh corgi pembroke'),
  ]);

  @observable
  String searchQuery = '';

  @computed
  List<PetItem> get filtered => favorites
      .where((p) => p.name.toLowerCase().contains(searchQuery.toLowerCase()))
      .toList();

  @action
  void setSearchQuery(String v) => searchQuery = v;

  @action
  void removeFavorite(String id) => favorites.removeWhere((p) => p.id == id);
}
