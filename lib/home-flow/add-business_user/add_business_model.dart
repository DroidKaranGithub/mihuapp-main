// To parse this JSON data, do
//
//     final addBusinessDataModel = addBusinessDataModelFromJson(jsonString);

import 'dart:convert';

AddBusinessDataModel addBusinessDataModelFromJson(String str) => AddBusinessDataModel.fromJson(json.decode(str));

String addBusinessDataModelToJson(AddBusinessDataModel data) => json.encode(data.toJson());

class AddBusinessDataModel {
  bool status;
  String message;
  List<BusinessDatum> data;

  AddBusinessDataModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AddBusinessDataModel.fromJson(Map<String, dynamic> json) => AddBusinessDataModel(
    status: json["status"],
    message: json["message"],
    data: List<BusinessDatum>.from(json["data"].map((x) => BusinessDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class BusinessDatum {
  int id;
  int datumDefault;
  String name;
  String? email;
  String logo;
  String number;
  dynamic address;
  dynamic facebook;
  dynamic youtube;
  dynamic insta;

  BusinessDatum({
    required this.id,
    required this.datumDefault,
    required this.name,
    required this.email,
    required this.logo,
    required this.number,
    required this.address,
    required this.facebook,
    required this.youtube,
    required this.insta,
  });

  factory BusinessDatum.fromJson(Map<String, dynamic> json) => BusinessDatum(
    id: json["id"],
    datumDefault: json["default"],
    name: json["name"],
    email: json["email"],
    logo: json["logo"],
    number: json["number"],
    address: json["address"],
    facebook: json["facebook"],
    youtube: json["youtube"],
    insta: json["insta"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "default": datumDefault,
    "name": name,
    "email": email,
    "logo": logo,
    "number": number,
    "address": address,
    "facebook": facebook,
    "youtube": youtube,
    "insta": insta,
  };
}
