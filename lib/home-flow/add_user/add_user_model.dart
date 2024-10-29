// To parse this JSON data, do
//
//     final addUserResponseModel = addUserResponseModelFromJson(jsonString);

import 'dart:convert';

AddUserResponseModel addUserResponseModelFromJson(String str) => AddUserResponseModel.fromJson(json.decode(str));

String addUserResponseModelToJson(AddUserResponseModel data) => json.encode(data.toJson());

class AddUserResponseModel {
  bool status;
  String message;
  List<DatumAddUser> data;

  AddUserResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AddUserResponseModel.fromJson(Map<String, dynamic> json) => AddUserResponseModel(
    status: json["status"],
    message: json["message"],
    data: List<DatumAddUser>.from(json["data"].map((x) => DatumAddUser.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class DatumAddUser {
  int profileId;
  int datumDefault;
  String? userType;
  String name;
  String email;
  String about;
  String phone;
  String profileImage;
  String? whatsapp;
  String? instagram;
  String? twitter;
  String? youtube;
  String? website;
  String? address;

  DatumAddUser({
    required this.profileId,
    required this.datumDefault,
    required this.userType,
    required this.name,
    required this.email,
    required this.about,
    required this.phone,
    required this.profileImage,
    this.whatsapp,
    this.instagram,
    this.twitter,
    this.youtube,
    this.website,
    this.address,
  });

  factory DatumAddUser.fromJson(Map<String, dynamic> json) => DatumAddUser(
    profileId: json["profile_id"],
    datumDefault: json["default"],
    userType: json["user_type"],
    name: json["name"],
    about: json["about"] ?? "",
    email: json["email"],
    phone: json["phone"],
    profileImage: json["profile_image"],
    whatsapp: json["whatsapp"],
    instagram: json["instagram"],
    twitter: json["twitter"],
    youtube: json["youtube"],
    // about: json["about"],
    website: json["website"],
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "profile_id": profileId,
    "default": datumDefault,
    "user_type": userType,
    "name": name,
    "about": about,
    "email": email,
    "phone": phone,
    "profile_image": profileImage,
    "whatsapp": whatsapp,
    "instagram": instagram,
    "twitter": twitter,
    "youtube": youtube,
    "website": website,
    "address": address,
  };
}
