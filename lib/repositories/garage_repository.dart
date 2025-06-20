

import 'package:flutter_application_1/models/garage.dart';
import 'package:flutter_application_1/models/rating_garage.dart';
import 'package:flutter_application_1/repositories/rating_garage_repository.dart';

import '/config/constants.dart';
import '/helper/http_helper.dart';

class GarageRepository {
  static const String _url = baseApiUrl + "api/v1/garages/";

  static Future<List<Garage>> findAll(
      {String? name,
      int? provinceId,
      int? districtId,
      int? wardId,
      double? latitude,
      double? longitude,
      int? distance}) async {
    String url = _url + "?";

    if (name != null) {
      url += "&name=$name";
    }
    if (provinceId != null) {
      url += "&provinceId=$provinceId";
    }
    if (districtId != null) {
      url += "&districtId=$districtId";
    }
    if (wardId != null) {
      url += "&wardId=$wardId";
    }
    if (latitude != null) {
      url += "&latitude=$latitude";
    }
    if (longitude != null) {
      url += "&longitude=$longitude";
    }
    if (distance != null) {
      url += "&distance=$distance";
    }

    var responseBody = await HttpHelper.get(
      url: url,
    );

    /*List<Garage> items = [
      for (var element in responseBody) Garage.fromJson(element)
    ];*/

    return responseBody
        .map<Garage>((element) => Garage.fromJson(element))
        .toList();
  }

  static Future<Garage> findById(int id) async {
    var responseBody = await HttpHelper.get(
      url: _url + id.toString(),
    );

    return Garage.fromJson(responseBody);
  }

  static Future<Garage> create(Garage item) async {
    var responseBody = await HttpHelper.post(
      url: _url,
      body: item.toJson(),
    );

    //return Garage.fromJson(responseBody);
    //load relationship after save - Cần tải lại, vì sau khi lưu sẽ mất các relationship, VD: mất danh sách ảnh
    return GarageRepository.findById(Garage.fromJson(responseBody).id!);
  }

  static Future<Garage> update(Garage item) async {
    var responseBody = await HttpHelper.put(
      url: _url + item.id.toString(),
      body: item.toJson(),
    );

    //return Garage.fromJson(responseBody);
    //load relationship after save - Cần tải lại, vì sau khi lưu sẽ mất các relationship, VD: mất danh sách ảnh
    return GarageRepository.findById(Garage.fromJson(responseBody).id!);
  }

  static Future<dynamic> deleteById(int id) async {
    return await HttpHelper.delete(
      url: _url + id.toString(),
    );
  }

  //#region - Extend -
  static Future<List<Garage>> findAllByFeatured({bool featured = true}) async {
    var responseBody = await HttpHelper.get(
      url: _url + "featured?isFeatured=" + featured.toString(),
    );

    return [...Garage.fromJsonToList(responseBody).reversed];
  }

  static Future<List<Garage>> findAllByPartnerId(
      {required int partnerId}) async {
    var responseBody = await HttpHelper.get(
      url: _url + "byPartner/" + partnerId.toString(),
    );

    return Garage.fromJsonToList(responseBody);
  }

  static Future<RatingGarage> createRatingGarage(
      {required RatingGarage ratingGarage, required int garageId}) async {
    var responseBody = await HttpHelper.post(
      url: _url + garageId.toString() + "/ratingGarage",
      body: ratingGarage.toJson(),
    );

    // Reload item //TODO: Kiểm tra lại xem có cần reload không
    return RatingGarageRepository.findById(RatingGarage.fromJson(responseBody).id!);
    //return RatingGarage.fromJson(responseBody);
  }
//#endregion
}
