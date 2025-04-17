import 'package:google_maps_flutter/google_maps_flutter.dart';

class BackgroundServiceModel {
  final String title;
  final LatLng latLng;
  final String placeId;

  BackgroundServiceModel({
    required this.title,
    required this.latLng,
    required this.placeId,
  });

  factory BackgroundServiceModel.fromJson(Map<String, dynamic> json) {
    return BackgroundServiceModel(
      title: json['title'],
      latLng: LatLng(
        json['latLng'][0],
        json['latLng'][1],
      ),
      placeId: json['place_id'],
    );
  }
}