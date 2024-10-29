// To parse this JSON data, do
//
//     final businessPostModel = businessPostModelFromJson(jsonString);

import 'dart:convert';

BusinessPostModel businessPostModelFromJson(String str) => BusinessPostModel.fromJson(json.decode(str));

String businessPostModelToJson(BusinessPostModel data) => json.encode(data.toJson());

class BusinessPostModel {
  bool status;
  String message;
  List<DataBusiness> data;

  BusinessPostModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory BusinessPostModel.fromJson(Map<String, dynamic> json) => BusinessPostModel(
    status: json["status"],
    message: json["message"],
    data: List<DataBusiness>.from(json["data"].map((x) => DataBusiness.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class DataBusiness {
  int id;
  String title;
  String thumbUrl;
  String frameUrl;
  String itemUrl;
  dynamic slug;
  String type;
  dynamic json;
  String language;
  String category;
  String subCategory;
  int sectionId;
  String? orientation;
  int height;
  int width;
  int views;
  int status;
  int premium;
  DateTime updatedAt;
  DateTime createdAt;
  String userType;

  DataBusiness({
    required this.id,
    required this.title,
    required this.thumbUrl,
    required this.frameUrl,
    required this.itemUrl,
    required this.slug,
    required this.type,
    required this.json,
    required this.language,
    required this.category,
    required this.subCategory,
    required this.sectionId,
    required this.orientation,
    required this.height,
    required this.width,
    required this.views,
    required this.status,
    required this.premium,
    required this.updatedAt,
    required this.createdAt,
    required this.userType,
  });

  factory DataBusiness.fromJson(Map<String, dynamic> json) => DataBusiness(
    id: json["id"],
    title: json["title"],
    thumbUrl: json["thumb_url"],
    frameUrl: json["frame_url"],
    itemUrl: json["item_url"],
    slug: json["slug"],
    type: json["type"],
    json: json["json"],
    language: json["language"],
    category: json["category"],
    subCategory: json["sub_category"],
    sectionId: json["section_id"],
    orientation: json["orientation"],
    height: json["height"],
    width: json["width"],
    views: json["views"],
    status: json["status"],
    premium: json["premium"],
    updatedAt: DateTime.parse(json["updated_at"]),
    createdAt: DateTime.parse(json["created_at"]),
    userType: json["user_type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "thumb_url": thumbUrl,
    "frame_url": frameUrl,
    "item_url": itemUrl,
    "slug": slug,
    "type": type,
    "json": json,
    "language": language,
    "category": category,
    "sub_category": subCategory,
    "section_id": sectionId,
    "orientation": orientation,
    "height": height,
    "width": width,
    "views": views,
    "status": status,
    "premium": premium,
    "updated_at": updatedAt.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
    "user_type": userType,
  };
}
