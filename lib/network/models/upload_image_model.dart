import 'dart:convert';

class UploadImgResponseModel {
  final bool status;
  final String? message;
  final dynamic data; // Adjust type based on your response

  UploadImgResponseModel({required this.status, this.message, this.data});

  factory UploadImgResponseModel.fromJson(Map<String, dynamic> json) {
    return UploadImgResponseModel(
      status: json['status'],
      message: json['message'],
      data: json['data'], // Adjust based on your response structure
    );
  }
}
class UploadImgResponseModel2 {
  final bool status;
  final String message;
  final List<dynamic> data; // Use List here if it's indeed a list

  UploadImgResponseModel2({
    required this.status,
    required this.message,
    required this.data,
  });

  factory UploadImgResponseModel2.fromJson(Map<String, dynamic> json) {
    return UploadImgResponseModel2(
      status: json['status'],
      message: json['message'],
      data: json['data'] ?? [], // Ensure it's a List<dynamic>
    );
  }
}

// To parse this JSON data, do
//
//     final greetingUploadResponseModel = greetingUploadResponseModelFromJson(jsonString);


GreetingUploadResponseModel greetingUploadResponseModelFromJson(String str) => GreetingUploadResponseModel.fromJson(json.decode(str));

String greetingUploadResponseModelToJson(GreetingUploadResponseModel data) => json.encode(data.toJson());

class GreetingUploadResponseModel {
  bool status;
  String message;
  Data data;

  GreetingUploadResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GreetingUploadResponseModel.fromJson(Map<String, dynamic> json) => GreetingUploadResponseModel(
    status: json["status"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  String message;
  String greetingSectionId;
  String date;
  int userId;
  DateTime updatedAt;
  DateTime createdAt;
  int id;
  String photo;

  Data({
    required this.message,
    required this.greetingSectionId,
    required this.date,
    required this.userId,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
    required this.photo,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    message: json["message"],
    greetingSectionId: json["greeting_section_id"],
    date: json["date"],
    userId: json["user_id"],
    updatedAt: DateTime.parse(json["updated_at"]),
    createdAt: DateTime.parse(json["created_at"]),
    id: json["id"],
    photo: json["photo"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "greeting_section_id": greetingSectionId,
    "date": date,
    "user_id": userId,
    "updated_at": updatedAt.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
    "id": id,
    "photo": photo,
  };
}

