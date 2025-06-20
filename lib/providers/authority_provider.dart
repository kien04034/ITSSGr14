import 'package:flutter/foundation.dart';
import '/models/authority.dart';
import '/repositories/authority_repository.dart';
import 'auth_provider.dart';

class AuthorityProvider with ChangeNotifier {
  List<Authority> _items = [];

  final AuthProvider? authProvider;

  AuthorityProvider(this.authProvider, this._items);

  List<Authority> get items {
    return [..._items];
  }

  Future<List<Authority>> fetchAllData() async {
    //https://flutter.dev/docs/cookbook/networking/fetch-data
    try {
      List<Authority> _itemsLoaded = await AuthorityRepository.findAll();
      _items.clear();
      _items.addAll(_itemsLoaded);
      notifyListeners();
      return _items;
    } catch (error) {
      rethrow;
    }
  }

  Authority findById(int id) {
    return _items.firstWhere((item) => item.id == id);
  }

  Future<void> create(Authority item) async {
    Authority itemResponse = await AuthorityRepository.create(item);
    _items.add(itemResponse);
    notifyListeners();
  }

  Future<void> update(Authority item) async {
    Authority itemResponse = await AuthorityRepository.update(item);
    final index = _items.indexWhere((element) => element.id == item.id);
    _items[index] = itemResponse;
    notifyListeners();
  }

  Future<void> deleteById(int id) async {
    await AuthorityRepository.deleteById(id);
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
