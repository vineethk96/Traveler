import 'dart:developer';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPlacesModel {
  final String title;
  final LatLng latLng;
  final String placeId;

  MapPlacesModel({
    required this.title,
    required this.latLng,
    required this.placeId,
  });

  factory MapPlacesModel.fromJson(Map<String, dynamic> json) {


    double lat;
    double lng;
    String titleStr;

    log('title: ${json['title']}');
    log('Lat: ${json['latLng'][0]}');
    log('Lng: ${json['latLng'][1]}');

    if(json['title'] == null || json['title'] == ''){
      log('Title is null or empty');
      titleStr = 'No Title';
    }
    else{
      titleStr = json['title'];
    }

    if(json['latLng'][0] == null || json['latLng'][0] == 0){
      log('Lat is null or empty');
      lat = 0.0;
    }
    else{
      lat = json['latLng'][0];
    }

    if(json['latLng'][1] == null || json['latLng'][1] == 0){
      log('Lng is null or empty');
      lng = 0.0;
    }
    else{
      lng = json['latLng'][1];
    }
    
    return MapPlacesModel(
      title: json['title'],
      latLng: LatLng(lat, lng),
      placeId: json['place_id'],
    );
  }
}
