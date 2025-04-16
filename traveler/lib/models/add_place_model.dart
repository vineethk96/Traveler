class AddPlaceModel{
  final String userId;
  final String gmapsId;
  final String info;

  AddPlaceModel({
    required this.userId,
    required this.gmapsId,
    required this.info,
  });

  // Convert the object into a JSON-compatible map
  Map<String, String> toJson() {
    return {
      'user_id': userId,
      'gmaps_id': gmapsId,
      'info': info,
    };
  }
}