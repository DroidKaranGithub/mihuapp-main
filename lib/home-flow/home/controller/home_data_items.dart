
class HomeDataItems {
  final int id;
  final String? value;
  final String? field;
  HomeDataItems({required this.id , required this.value , required this.field});
  factory HomeDataItems.fromJson ( Map<String, dynamic> json) {
    return HomeDataItems(id: json['id'], value: json['value']as String , field: json['field'] as String);
  }
}