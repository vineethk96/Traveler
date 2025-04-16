import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:traveler/services/location_service.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController _controller;
  LatLng? _initialPosition;

  @override
  void initState(){
    super.initState();
    _initializeMap();
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  Future<void> _initializeMap() async {
    try{
      LatLng currentLatLng = await LocationService.getCurrentPosition();
      setState((){
        _initialPosition = currentLatLng;
      });
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
            ),
    );
  }
}