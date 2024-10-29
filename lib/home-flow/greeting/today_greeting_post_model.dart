// To parse this JSON data, do
//
//     final todayGreetingsPostResponse = todayGreetingsPostResponseFromJson(jsonString);

import 'dart:convert';

TodayGreetingsPostResponse todayGreetingsPostResponseFromJson(String str) => TodayGreetingsPostResponse.fromJson(json.decode(str));

String todayGreetingsPostResponseToJson(TodayGreetingsPostResponse data) => json.encode(data.toJson());

class TodayGreetingsPostResponse {
  bool status;
  String message;
  List<TodayPostGreeting> data;

  TodayGreetingsPostResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory TodayGreetingsPostResponse.fromJson(Map<String, dynamic> json) => TodayGreetingsPostResponse(
    status: json["status"],
    message: json["message"],
    data: List<TodayPostGreeting>.from(json["data"].map((x) => TodayPostGreeting.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class TodayPostGreeting {
  int id;
  int userId;
  int greetingSectionId;
  String photo;
  String message;
  String date;
  DateTime createdAt;
  DateTime updatedAt;

  TodayPostGreeting({
    required this.id,
    required this.userId,
    required this.greetingSectionId,
    required this.photo,
    required this.message,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TodayPostGreeting.fromJson(Map<String, dynamic> json) => TodayPostGreeting(
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
