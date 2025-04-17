class MyPlaceModel {
  final String gmapsId;
  final String info;
  final DateTime createdAt;

  MyPlaceModel({
    required this.gmapsId,
    required this.info,
    required this.createdAt,
  });

  factory MyPlaceModel.fromJson(Map<String, dynamic> json) {
    return MyPlaceModel(
      gmapsId: json['gmaps_id'],
      info: json['info'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
