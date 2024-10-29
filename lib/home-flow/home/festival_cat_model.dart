// To parse this JSON data, do
//
//     final fastivalCatModel = fastivalCatModelFromJson(jsonString);

import 'dart:convert';

FastivalCatModel fastivalCatModelFromJson(String str) => FastivalCatModel.fromJson(json.decode(str));

String fastivalCatModelToJson(FastivalCatModel data) => json.encode(data.toJson());

class FastivalCatModel {
  bool status;
  String message;
  List<Datum> data;

  FastivalCatModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory FastivalCatModel.fromJson(Map<String, dynamic> json) => FastivalCatModel(
    status: json["status"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  int id;
  String name;
  String image;
  dynamic about;
  DateTime? eventDate;

  Datum({
    required this.id,
    required this.name,
    required this.image,
    required this.about,
    required this.eventDate,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    about: json["about"],
    eventDate: json["event_date"] == null ? null : DateTime.parse(json["event_date"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "about": about,
    "event_date": "${eventDate!.year.toString().padLeft(4, '0')}-${eventDate!.month.toString().padLeft(2, '0')}-${eventDate!.day.toString().padLeft(2, '0')}",
  };
}
