import 'dart:convert';

import '/models/user.dart';
import 'base_model.dart';

class Authority extends BaseModel {
  //
  String? username;

  //
  String? authority;

  //Relationship
  User? user;

  Authority({
    this.username,
    this.authority,
    //Relationship
    this.user,
    //
    super.id,
    super.createdAt,
    super.createdBy,
    super.updatedAt,
    super.updatedBy,
    super.version,
    super.deleted,
  });

  //
  factory Authority.fromJson(Map<String, dynamic> json) {
    return Authority(
      username: json['username'],
      authority: json['authority'],
      //Relationship
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      //TODO: Thử thay thế cái này xem đc ko: json.decode(json['user'])
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
  static List<Authority> fromJsonToList(dynamic json) {
    return json
        .map<Authority>((element) => Authority.fromJson(element))
        .toList();
  }

  //
  String toJson() {
    return json.encode({
      'username': username,
      'authority': authority,
      //Relationship
      'user': user != null ? json.decode(user!.toJson()) : null,
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
