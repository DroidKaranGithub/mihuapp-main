// To parse this JSON data, do
//
//     final myDetailsSignupModel = myDetailsSignupModelFromJson(jsonString);

import 'dart:convert';

MyDetailsSignupModel myDetailsSignupModelFromJson(String str) => MyDetailsSignupModel.fromJson(json.decode(str));

String myDetailsSignupModelToJson(MyDetailsSignupModel data) => json.encode(data.toJson());

class MyDetailsSignupModel {
  bool status;
  String message;
  MyData data;

  MyDetailsSignupModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory MyDetailsSignupModel.fromJson(Map<String, dynamic> json) => MyDetailsSignupModel(
    status: json["status"],
    message: json["message"],
    data: MyData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class MyData {
  MySelf mySelf;
  Business business;

  MyData({
    required this.mySelf,
    required this.business,
  });

  factory MyData.fromJson(Map<String, dynamic> json) => MyData(
    mySelf: MySelf.fromJson(json["my_self"]),
    business: Business.fromJson(json["business"]),
  );

  Map<String, dynamic> toJson() => {
    "my_self": mySelf.toJson(),
    "business": business.toJson(),
  };
}

class Business {
  bool whatsapp;
  bool insta;
  bool twitter;
  bool youtube;
  bool linkedin;
  bool website;
  bool address;

  Business({
    required this.whatsapp,
    required this.insta,
    required this.twitter,
    required this.youtube,
    required this.linkedin,
    required this.website,
    required this.address,
  });

  factory Business.fromJson(Map<String, dynamic> json) => Business(
    whatsapp: json["whatsapp"],
    insta: json["insta"],
    twitter: json["twitter"],
    youtube: json["youtube"],
    linkedin: json["linkedin"],
    website: json["website"],
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "whatsapp": whatsapp,
    "insta": insta,
    "twitter": twitter,
    "youtube": youtube,
    "linkedin": linkedin,
    "website": website,
    "address": address,
  };
}

class MySelf {
  bool whatsapp;
  bool insta;
  bool twitter;
  bool youtube;
  bool about;

  MySelf({
    required this.whatsapp,
    required this.insta,
    required this.twitter,
    required this.youtube,
    required this.about,
  });

  factory MySelf.fromJson(Map<String, dynamic> json) => MySelf(
    whatsapp: json["whatsapp"],
    insta: json["insta"],
    twitter: json["twitter"],
    youtube: json["youtube"],
    about: json["about"],
  );

  Map<String, dynamic> toJson() => {
    "whatsapp": whatsapp,
    "insta": insta,
    "twitter": twitter,
    "youtube": youtube,
    "about": about,
  };
}
