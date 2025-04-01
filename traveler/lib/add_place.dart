import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_places_flutter/model/prediction.dart';
// import 'package:traveler/locations.dart';
import 'package:traveler/secure_storage_service.dart';

class AddPlacePage extends StatefulWidget {
  @override
  _AddPlacePageState createState() => _AddPlacePageState();
}

class _AddPlacePageState extends State<AddPlacePage>{
  GoogleMapController? _mapController;
  LatLng? selectedLocation;                 // Store the selected location
  String? GMPKey;                           // Google Maps API Key
  
  final TextEditingController searchController = TextEditingController();

  /// Fetch API Key
  Future<String?> _fetchAPIKey() async {
    return await SecureStorageService.getApiKey();
  }

  /// Get Users Current Location
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if Location Services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled){
      print("Error: Location Services Disabled");  // TODO: Add a default value that still allows users to add places without GPS
      return;
    }

    // Check Location permissions
    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied){  // TODO: do we need to check twice? This seems silly?
        print("Error: Location Permissions were denied twice?");
        return;
      }
    }

    if(permission == LocationPermission.deniedForever){
      print("Error: Permissions were denied forever?");
      return;
    }

    // Set Location Settings
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    // Get Current Position
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );

    setState(() {
      selectedLocation = LatLng(position.latitude, position.longitude);
    });

    // Move the camera to the selected location
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(selectedLocation!, 15),
      );
    }
  }

  /// Update map location when a new place is selected
  void _updateMapLocation(double lat, double lng) {
    setState(() {
      selectedLocation = LatLng(lat, lng);
    });

    // Move the camera to the selected location
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(selectedLocation!, 15),
      );
    }
  }

  @override
  void initState(){
    super.initState();
    // Fetch API Key when Widget Initializes
    _fetchAPIKey();
    // Fetch User Location when Page Loads
    _getCurrentLocation();
  }

  /// Build Widget
  @override
  Widget build(BuildContext context) {

    // Check for GMP Key
    if(GMPKey == null){
      return Scaffold(
        appBar: AppBar(title: Text("Add New Place")),
        body: Center(child: CircularProgressIndicator()), // Stick to loading when no API key has been loaded
      );
    }

    // If we have the GMP Key, we can populate the page
    return Scaffold(
      appBar: AppBar(title: Text("Add New Place")),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.all(10),
            child: GooglePlaceAutoCompleteTextField(
              textEditingController: searchController,
              googleAPIKey: GMPKey!,
              inputDecoration: InputDecoration(
                hintText: "Search for a place",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              debounceTime: 500,  // Debounce time in milliseconds
              isLatLngRequired: true,
              getPlaceDetailWithLatLng: (Prediction prediction) {
                // Handle the place details, including latitude and longitude
                print("Selected place: ${prediction.description}");
                print("Latitude: ${prediction.lat}, Longitude: ${prediction.lng}");

                _updateMapLocation(prediction.lat! as double, prediction.lng! as double);
              },
              itemClick: (Prediction prediction){
                searchController.text = prediction.description ?? "";
                searchController.selection = TextSelection.fromPosition(
                  TextPosition(
                    offset: prediction.description?.length ?? 0
                  ),
                );
              },
            )
          ),

          // Mini Map
          Expanded(
            child: selectedLocation == null
              ? Center(child: Text("Fetching current location..."))
              : GoogleMap(
                initialCameraPosition: CameraPosition(
                    target: selectedLocation!,
                    zoom: 15
                  ),
              onMapCreated: (GoogleMapController controller){
                setState((){
                  _mapController = controller;
                });

                if (selectedLocation != null) {
                  _mapController!.animateCamera(
                    CameraUpdate.newLatLngZoom(selectedLocation!, 15),
                  );
                }
              },
              markers: {
                Marker(markerId: MarkerId("selected"), position: selectedLocation!)
              },
            )
          )
        ]
      )
    );
  }
}