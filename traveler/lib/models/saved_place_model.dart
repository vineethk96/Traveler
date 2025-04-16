class SavedLocationModel {
  final String gmapsId;
  final String info;
  final DateTime createdAt;

  SavedLocationModel({
    required this.gmapsId,
    required this.info,
    required this.createdAt,
  });

  factory SavedLocationModel.fromJson(Map<String, dynamic> json) {
    return SavedLocationModel(
      gmapsId: json['gmaps_id'],
      info: json['info'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
