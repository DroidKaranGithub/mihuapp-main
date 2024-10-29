// To parse this JSON data, do
//
//     final makeBusinessDefaultDataModel = makeBusinessDefaultDataModelFromJson(jsonString);

import 'dart:convert';

MakeBusinessDefaultDataModel makeBusinessDefaultDataModelFromJson(String str) => MakeBusinessDefaultDataModel.fromJson(json.decode(str));

String makeBusinessDefaultDataModelToJson(MakeBusinessDefaultDataModel data) => json.encode(data.toJson());

class MakeBusinessDefaultDataModel {
  bool status;
  String message;
  List<dynamic> data;

  MakeBusinessDefaultDataModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory MakeBusinessDefaultDataModel.fromJson(Map<String, dynamic> json) => MakeBusinessDefaultDataModel(
    status: json["status"],
    message: json["message"],
    data: List<dynamic>.from(json["data"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x)),
  };
}
