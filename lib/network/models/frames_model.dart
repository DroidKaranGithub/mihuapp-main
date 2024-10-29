// To parse this JSON data, do
//
//     final framesResponseModel = framesResponseModelFromJson(jsonString);

import 'dart:convert';

FramesResponseModel framesResponseModelFromJson(String str) => FramesResponseModel.fromJson(json.decode(str));

String framesResponseModelToJson(FramesResponseModel data) => json.encode(data.toJson());

class FramesResponseModel {
  bool? status;
  String? message;
  List<Datum>? data;

  FramesResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory FramesResponseModel.fromJson(Map<String, dynamic> json) => FramesResponseModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  int? id;
  String? title;
  String? thumbnail;
  String? json;
  String? ratio;
  int? premium;
  int? featured;
  String? category;
  int? status;
  String? type;
  String? userType;
  String? jsonFile;

  Datum({
    this.id,
    this.title,
    this.thumbnail,
    this.json,
    this.ratio,
    this.premium,
    this.featured,
    this.category,
    this.status,
    this.type,
    this.userType,
    this.jsonFile,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    title: json["title"],
    thumbnail: json["thumbnail"],
    json: json["json"],
    ratio: json["ratio"],
    premium: json["premium"],
    featured: json["featured"],
    category: json["category"],
    status: json["status"],
    type: json["type"],
    userType: json["user_type"],
    jsonFile: json["json_file"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "thumbnail": thumbnail,
    "json": json,
    "ratio": ratio,
    "premium": premium,
    "featured": featured,
    "category": category,
    "status": status,
    "type": type,
    "user_type": userType,
    "json_file": jsonFile,
  };
}
