// To parse this JSON data, do
//
//     final greetingResponseModel = greetingResponseModelFromJson(jsonString);

import 'dart:convert';

GreetingResponseModel greetingResponseModelFromJson(String str) => GreetingResponseModel.fromJson(json.decode(str));

String greetingResponseModelToJson(GreetingResponseModel data) => json.encode(data.toJson());

class GreetingResponseModel {
  bool status;
  String message;
  List<GreetingFuturePost> data;

  GreetingResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GreetingResponseModel.fromJson(Map<String, dynamic> json) => GreetingResponseModel(
    status: json["status"],
    message: json["message"],
    data: List<GreetingFuturePost>.from(json["data"].map((x) => GreetingFuturePost.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class GreetingFuturePost {
  int id;
  int userId;
  int greetingSectionId;
  String photo;
  String message;
  String date;
  DateTime createdAt;
  DateTime updatedAt;

  GreetingFuturePost({
    required this.id,
    required this.userId,
    required this.greetingSectionId,
    required this.photo,
    required this.message,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GreetingFuturePost.fromJson(Map<String, dynamic> json) => GreetingFuturePost(
    id: json["id"],
    userId: json["user_id"],
    greetingSectionId: json["greeting_section_id"],
    photo: json["photo"],
    message: json["message"],
    date: json["date"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "greeting_section_id": greetingSectionId,
    "photo": photo,
    "message": message,
    "date": date,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
