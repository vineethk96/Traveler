class MyPlaceModel {
  final String placeId;
  final String title;
  final String info;
  final DateTime createdAt;

  MyPlaceModel({
    required this.placeId,
    required this.title,
    required this.info,
    required this.createdAt,
  });

  factory MyPlaceModel.fromJson(Map<String, dynamic> json) {
    return MyPlaceModel(
      placeId: json['place_id'],
      title: json['title'],
      info: json['info'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
