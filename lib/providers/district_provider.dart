import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/models/district.dart';
import 'package:flutter_application_1/repositories/district_repository.dart';


import 'auth_provider.dart';

class DistrictProvider with ChangeNotifier {
  List<District> _items = [];

  final AuthProvider? authProvider;

  DistrictProvider(this.authProvider, this._items);

  List<District> get items {
    return [..._items];
  }

  Future<List<District>> fetchAllData() async {
    //https://flutter.dev/docs/cookbook/networking/fetch-data
    try {
      List<District> _itemsLoaded = await DistrictRepository.findAll();
      _items.clear();
      _items.addAll(_itemsLoaded);
      notifyListeners();
      return _items;
    } catch (error) {
      rethrow;
    }
  }

  District findById(int id) {
    return _items.firstWhere((item) => item.id == id);
  }

  Future<void> create(District item) async {
    District itemResponse = await DistrictRepository.create(item);
    _items.add(itemResponse);
    notifyListeners();
  }

  Future<void> update(District item) async {
    District itemResponse = await DistrictRepository.update(item);
    final index = _items.indexWhere((element) => element.id == item.id);
    _items[index] = itemResponse;
    notifyListeners();
  }

  Future<void> deleteById(int id) async {
    await DistrictRepository.deleteById(id);
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
