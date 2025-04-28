import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:traveler/models/map_places_model.dart';
import 'package:traveler/models/my_place_model.dart';
import 'package:traveler/models/userId_model.dart';
import 'package:traveler/services/location_service.dart';
import 'package:traveler/services/supabase_api_service.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late List<MapPlacesModel> _locations;
  late GoogleMapController _controller;
  LatLng? _initialPosition;
  Set<Marker> _markers = {};

  @override
  void initState(){
    super.initState();
    _initializeMap();
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  Future<void> _initializeMap() async {

    late LatLng currentLatLng;

    final userId = UserIdModel(
      userId: Supabase.instance.client.auth.currentUser?.id ?? ''
    );

    // Fetching the saved locations
    try{
      _locations = await SupabaseApiService().fetchMapLocations(userId);

      log("Fetched saved locations");
    }catch(e){
      // Handle error
      log('Error initializing map: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error Finding Saved Places: $e"),
          duration: const Duration(seconds: 2),
        ),
      );
    }

    // Adding markers to the map
    Set<Marker> newMarkers = _locations.map((place) {
      return Marker(
        markerId: MarkerId(place.placeId),
        position: place.latLng,
        infoWindow: InfoWindow(
          title: place.title,
        )
      );
    }).toSet();

    // Fetching the current location
    try{
      currentLatLng = await LocationService.getCurrentPosition();
    }catch(e){
      // Handle error
      log('Error initializing map: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Location Services are disabled"),
          duration: const Duration(seconds: 2),
        ),
      );
    }

    setState((){
      _markers = newMarkers;
      _initialPosition = currentLatLng;

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _initialPosition == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _initialPosition!,
                zoom: 12.0,
              ),
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              markers: _markers,
              onTap: (LatLng latLng) {
                // Handle map tap
                log('Tapped at: $latLng');
              },
            ),
    );
  }
}