class BusinessCatModel {
  bool status;
  String message;
  List<DataCat> data;

  BusinessCatModel({
    required this.status,
    required this.message,
    required this.data,
  });

  // Define fromJson method
  factory BusinessCatModel.fromJson(Map<String, dynamic> json) {
    return BusinessCatModel(
      status: json['status'],
      message: json['message'],
      data: (json['data'] as List<dynamic>)
          .map((item) => DataCat.fromJson(item))
          .toList(),
    );
  }
}

class DataCat {
  int id;
  String name;
  List<dynamic> subCategory;

  DataCat({
    required this.id,
    required this.name,
    required this.subCategory,
  });

  // Define fromJson method
  factory DataCat.fromJson(Map<String, dynamic> json) {
    return DataCat(
      id: json['id'],
      name: json['name'],
      subCategory: json['subCategory'] ?? [], // Default to empty list if null
    );
  }
}
