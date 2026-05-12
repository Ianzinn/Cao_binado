// ignore_for_file: library_private_types_in_public_api
import 'package:mobx/mobx.dart';

part 'adopters_store.g.dart';

class AdopterItem {
  AdopterItem({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.imageUrl,
  });
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? imageUrl;
}

class AdoptersStore = _AdoptersStore with _$AdoptersStore;

abstract class _AdoptersStore with Store {
  @observable
  ObservableList<AdopterItem> adopters = ObservableList.of([
    AdopterItem(id: '1', name: 'Jorge', email: 'J******@gmail.com', phone: '(31) ***-8922'),
    AdopterItem(id: '2', name: 'Jailson Mendes', email: 'J********@gmail.com', phone: '(31) 996345-6996'),
    AdopterItem(id: '3', name: 'Sarah Joe Chamoun', email: 'C******@gmail.com', phone: '(31) ****-6996'),
  ]);

  @observable
  String searchQuery = '';

  @computed
  List<AdopterItem> get filtered => adopters
      .where((a) => a.name.toLowerCase().contains(searchQuery.toLowerCase()))
      .toList();

  @action
  void setSearchQuery(String v) => searchQuery = v;

  @action
  void removeAdopter(String id) => adopters.removeWhere((a) => a.id == id);
}
