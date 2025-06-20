import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/helper/location_helper.dart';
import 'package:flutter_application_1/models/issue.dart';
import 'package:flutter_application_1/models/rating_issue.dart';
import 'package:flutter_application_1/repositories/issue_repository.dart';

import 'auth_provider.dart';

class IssueProvider with ChangeNotifier {
  List<Issue> _items = [];

  final AuthProvider? authProvider;

  IssueProvider(this.authProvider, this._items);

  List<Issue> get items {
    return [..._items.reversed];
  }

  Future<List<Issue>> fetchAllData() async {
    //https://flutter.dev/docs/cookbook/networking/fetch-data
    try {
      List<Issue> _itemsLoaded = await IssueRepository.findAll();
      _items.clear();
      _items.addAll(_itemsLoaded);
      notifyListeners();
      return _items;
    } catch (error) {
      rethrow;
    }
  }

  Issue findById(int id) {
    return _items.firstWhere((item) => item.id == id);
  }

  Future<void> create(Issue item) async {
    Issue itemResponse = await IssueRepository.create(item);
    _items.add(itemResponse);
    notifyListeners();
  }

  Future<void> update(Issue item) async {
    Issue itemResponse = await IssueRepository.update(item);
    final index = _items.indexWhere((element) => element.id == item.id);
    _items[index] = itemResponse;
    notifyListeners();
  }

  Future<void> deleteById(int id) async {
    await IssueRepository.deleteById(id);
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  //#region - Extend -
  Future<List<Issue>> fetchAllDataByStatusSent() async {
    try {
      double? latitude; // Test: 21.007688
      double? longitude; // Test: 105.841373
      int? distance = 30 * 1000; // Mặc định: 30Km

      var currentLocation = await LocationHelper.getCurrentLocationCache();
      latitude = currentLocation.latitude;
      longitude = currentLocation.longitude;

      List<Issue> _itemsLoaded = await IssueRepository.findAllByStatusSent(
        latitude: latitude,
        longitude: longitude,
        distance: distance,
      );
      _items.clear();
      _items.addAll(_itemsLoaded);
      notifyListeners();
      return _items;
    } catch (error) {
      rethrow;
    }
  }

  Future<List<Issue>> fetchAllDataByUserMember() async {
    if (!authProvider!.authData.isAuth) {
      throw Exception(
          "Chưa đăng nhập, hoặc hết thời gian đăng nhập. Vui lòng đăng xuất & đăng nhập lại");
    }

    try {
      List<Issue> _itemsLoaded = await IssueRepository.findAllByByUserMember(
          authProvider!.authData.userId!);
      _items.clear();
      _items.addAll(_itemsLoaded);
      notifyListeners();
      return _items;
    } catch (error) {
      rethrow;
    }
  }

  Future<List<Issue>> fetchAllDataByUserPartner() async {
    if (!authProvider!.authData.isAuth) {
      throw Exception(
          "Chưa đăng nhập, hoặc hết thời gian đăng nhập. Vui lòng đăng xuất & đăng nhập lại");
    }

    try {
      List<Issue> _itemsLoaded = await IssueRepository.findAllByByUserPartner(
          authProvider!.authData.userId!);
      _items.clear();
      _items.addAll(_itemsLoaded);
      notifyListeners();
      return _items;
    } catch (error) {
      rethrow;
    }
  }

  Future<String> partnerConfirmMember(Issue item) async {
    String message = await IssueRepository.partnerConfirmMember(
        item.id!, authProvider!.authData.currentUser!.id!);

    Issue itemReload = findById(item.id!);
    final index = _items.indexWhere((element) => element.id == item.id);
    _items[index] = itemReload;
    notifyListeners();

    return message;
  }

  Future<String> memberConfirmPartner(Issue item) async {
    String message = await IssueRepository.memberConfirmPartner(item.id!);

    Issue itemReload = findById(item.id!);
    final index = _items.indexWhere((element) => element.id == item.id);
    _items[index] = itemReload;
    notifyListeners();

    return message;
  }

  Future<String> setStatusSuccess(Issue item) async {
    String message = await IssueRepository.setStatusSuccess(item.id!);

    Issue itemReload = findById(item.id!);
    final index = _items.indexWhere((element) => element.id == item.id);
    _items[index] = itemReload;
    notifyListeners();

    return message;
  }

  Future<String> canceledByMember(Issue item) async {
    String message = await IssueRepository.canceledByMember(item.id!);

    Issue itemReload = findById(item.id!);
    final index = _items.indexWhere((element) => element.id == item.id);
    _items[index] = itemReload;
    notifyListeners();

    return message;
  }

  Future<String> canceledByPartner(Issue item) async {
    String message = await IssueRepository.canceledByPartner(item.id!);

    Issue itemReload = findById(item.id!);
    final index = _items.indexWhere((element) => element.id == item.id);
    _items[index] = itemReload;
    notifyListeners();

    return message;
  }

  Future<Issue> send(Issue item) async {
    if (!authProvider!.authData.isAuth) {
      throw Exception(
          "Chưa đăng nhập, hoặc hết thời gian đăng nhập. Vui lòng đăng xuất & đăng nhập lại");
    }

    item.userMember = authProvider!.authData.currentUser;

    Issue itemResponse = await IssueRepository.send(item);
    _items.add(itemResponse);
    notifyListeners();
    return itemResponse;
  }

  Future<void> createRatingIssue(RatingIssue item) async {
    if (!authProvider!.authData.isAuth) {
      throw Exception(
          "Chưa đăng nhập, hoặc hết thời gian đăng nhập. Vui lòng đăng xuất & đăng nhập lại");
    }

    item.userMember = authProvider!.authData.currentUser;

    RatingIssue itemResponse = await IssueRepository.createRatingIssue(item);
    final index = _items.indexWhere((element) => element.id == item.issue!.id);
    _items[index] =
        await IssueRepository.findById(itemResponse.issue!.id!); //Reload item
    notifyListeners();
  }
//#endregion
}
