
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddPlaceModel{
  final String userId;
  final String gmapsId;
  final String info;
  final LatLng latLng;
  final String title;

  AddPlaceModel({
    required this.userId,
    required this.gmapsId,
    required this.info,
    required this.latLng,
    required this.title,
  });

  // Convert the object into a JSON-compatible map
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'gmaps_id': gmapsId,
      'info': info,
      'latLng': [latLng.latitude, latLng.longitude],
      'title': title,
    };
  }
}