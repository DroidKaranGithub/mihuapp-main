// To parse this JSON data, do
//
//     final getCategoryDataModel = getCategoryDataModelFromJson(jsonString);

import 'dart:convert';

GetCategoryDataModel getCategoryDataModelFromJson(String str) => GetCategoryDataModel.fromJson(json.decode(str));

String getCategoryDataModelToJson(GetCategoryDataModel data) => json.encode(data.toJson());

class GetCategoryDataModel {
  bool status;
  String message;
  List<DataCategory> data;

  GetCategoryDataModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GetCategoryDataModel.fromJson(Map<String, dynamic> json) => GetCategoryDataModel(
    status: json["status"],
    message: json["message"],
    data: List<DataCategory>.from(json["data"].map((x) => DataCategory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class DataCategory {
  int id;
  String title;
  String thumbUrl;
  String frameUrl;
  String itemUrl;
  dynamic slug;
  String type;
  dynamic json;
  String language;
  int categoryId;
  int subCategoryId;
  int sectionId;
  String orientation;
  int height;
  int width;
  int views;
  int status;
  int premium;
  DateTime updatedAt;
  DateTime createdAt;
  String userType;
  DateTime fromDate;
  DateTime toDate;

  DataCategory({
    required this.id,
    required this.title,
    required this.thumbUrl,
    required this.frameUrl,
    required this.itemUrl,
    required this.slug,
    required this.type,
    required this.json,
    required this.language,
    required this.categoryId,
    required this.subCategoryId,
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
    required this.fromDate,
    required this.toDate,
  });

  factory DataCategory.fromJson(Map<String, dynamic> json) => DataCategory(
    id: json["id"],
    title: json["title"],
    thumbUrl: json["thumb_url"],
    frameUrl: json["frame_url"],
    itemUrl: json["item_url"],
    slug: json["slug"],
    type: json["type"],
    json: json["json"],
    language: json["language"],
    categoryId: json["category_id"],
    subCategoryId: json["sub_category_id"],
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
    fromDate: DateTime.parse(json["from_date"]),
    toDate: DateTime.parse(json["to_date"]),
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
    "category_id": categoryId,
    "sub_category_id": subCategoryId,
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
    "from_date": "${fromDate.year.toString().padLeft(4, '0')}-${fromDate.month.toString().padLeft(2, '0')}-${fromDate.day.toString().padLeft(2, '0')}",
    "to_date": "${toDate.year.toString().padLeft(4, '0')}-${toDate.month.toString().padLeft(2, '0')}-${toDate.day.toString().padLeft(2, '0')}",
  };
}
