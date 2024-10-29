// To parse this JSON data, do
//
//     final todayGreetingsCatResponse = todayGreetingsCatResponseFromJson(jsonString);

import 'dart:convert';

TodayGreetingsCatResponse todayGreetingsCatResponseFromJson(String str) => TodayGreetingsCatResponse.fromJson(json.decode(str));

String todayGreetingsCatResponseToJson(TodayGreetingsCatResponse data) => json.encode(data.toJson());

class TodayGreetingsCatResponse {
  bool status;
  String message;
  List<TodayGreetingsCat> data;

  TodayGreetingsCatResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory TodayGreetingsCatResponse.fromJson(Map<String, dynamic> json) => TodayGreetingsCatResponse(
    status: json["status"],
    message: json["message"],
    data: List<TodayGreetingsCat>.from(json["data"].map((x) => TodayGreetingsCat.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class TodayGreetingsCat {
  int greetingSectionId;
  String name;

  TodayGreetingsCat({
    required this.greetingSectionId,
    required this.name,
  });

  factory TodayGreetingsCat.fromJson(Map<String, dynamic> json) => TodayGreetingsCat(
    greetingSectionId: json["greeting_section_id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "greeting_section_id": greetingSectionId,
    "name": name,
  };
}
