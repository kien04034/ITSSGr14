import 'dart:convert';

import '/models/province.dart';
import 'base_model.dart';
import 'district.dart';
import 'garage.dart';

class Ward extends BaseModel {
  //
  int? provinceId;
  int? districtId;

  //
  String? name;
  String? prefix;

  //Relationship
  List<Garage>? garages;
  Province? province;
  District? district;

  Ward({
    this.provinceId,
    this.districtId,
    this.name,
    this.prefix,
    //Relationship
    this.garages,
    this.province,
    this.district,
    //
    int? id,
    DateTime? createdAt,
    String? createdBy,
    DateTime? updatedAt,
    String? updatedBy,
    int? version,
    bool? deleted,
  }) : super(
          id: id,
          createdAt: createdAt,
          createdBy: createdBy,
          updatedAt: updatedAt,
          updatedBy: updatedBy,
          version: version,
          deleted: deleted,
        );

  //
  factory Ward.fromJson(Map<String, dynamic> json) {
    return Ward(
      provinceId: json['provinceId'],
      districtId: json['districtId'],
      name: json['name'],
      prefix: json['prefix'],
      //Relationship
      garages:
          json['garages'] != null ? Garage.fromJsonToList(json['garages']) : [],
      province:
          json['province'] != null ? Province.fromJson(json['province']) : null,
      district:
          json['district'] != null ? District.fromJson(json['district']) : null,
      //
      id: json['id'],
      createdAt: json['createdAt'] != null ? DateTime.fromMillisecondsSinceEpoch(json['createdAt'], isUtc: true) : null,
      createdBy: json['createdBy'],
      updatedAt: json['updatedAt'] != null ? DateTime.fromMillisecondsSinceEpoch(json['updatedAt'], isUtc: true) : null,
      updatedBy: json['updatedBy'],
      version: json['version'],
      deleted: json['deleted'],
    );
  }

  //
  static List<Ward> fromJsonToList(dynamic json) {
    return json.map<Ward>((element) => Ward.fromJson(element)).toList();
  }

  //
  String toJson() {
    return json.encode({
      'provinceId': provinceId,
      'districtId': districtId,
      //
      'name': name,
      'prefix': prefix,
      //Relationship
      'province': province != null ? json.decode(province!.toJson()) : null,
      'district': district != null ? json.decode(district!.toJson()) : null,
      //
      'id': id,
      //'createdAt': createdAt,
      'createdBy': createdBy,
      //'updatedAt': updatedAt, //DateTime.now().millisecondsSinceEpoch | updatedAt.millisecondsSinceEpoch
      'updatedBy': updatedBy,
      'version': version,
      'deleted': deleted,
    });
  }
}
