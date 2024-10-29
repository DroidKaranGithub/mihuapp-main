// To parse this JSON data, do
//
//     final logo = logoFromJson(jsonString);

import 'dart:convert';

Logo logoFromJson(String str) => Logo.fromJson(json.decode(str));

String logoToJson(Logo data) => json.encode(data.toJson());

class Logo {
  bool status;
  String message;
  String data;

  Logo({
    required this.status,
    required this.message,
    required this.data,
  });

  factory Logo.fromJson(Map<String, dynamic> json) => Logo(
    status: json["status"],
    message: json["message"],
    data: json["data"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data,
  };
}
