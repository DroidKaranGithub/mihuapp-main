// To parse this JSON data, do
//
//     final greetingCatResponseModel = greetingCatResponseModelFromJson(jsonString);

import 'dart:convert';

GreetingCatResponseModel greetingCatResponseModelFromJson(String str) => GreetingCatResponseModel.fromJson(json.decode(str));

String greetingCatResponseModelToJson(GreetingCatResponseModel data) => json.encode(data.toJson());

class GreetingCatResponseModel {
  bool? status;
  String? message;
  List<GreetingsCatList>? data;

  GreetingCatResponseModel({
     this.status,
     this.message,
     this.data,
  });

  factory GreetingCatResponseModel.fromJson(Map<String, dynamic> json) => GreetingCatResponseModel(
    status: json["status"],
    message: json["message"],
    data: List<GreetingsCatList>.from(json["data"].map((x) => GreetingsCatList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class GreetingsCatList {
  int id;
  String name;

  GreetingsCatList({
    required this.id,
    required this.name,
  });

  factory GreetingsCatList.fromJson(Map<String, dynamic> json) => GreetingsCatList(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
