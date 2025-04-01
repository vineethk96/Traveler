import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:traveler/secure_storage_service.dart';

class AddPlacePage extends StatefulWidget {
  @override
  _AddPlacePageState createState() => _AddPlacePageState();
}

class _AddPlacePageState extends State<AddPlacePage>{
  late GoogleMapController _mapController;
  LatLng? selectedLocation;                 // Store the selected location
  String? GMPKey;                           // Google Maps API Key
  
  final TextEditingController searchController = TextEditingController();

  /// Fetch API Key
  Future<String?> _fetchAPIKey() async {
    return await SecureStorageService.getApiKey();
  }

  /// Update Map Location
  void _updateMapLocation(String place) async {

    try{
      List<Location> locations = await locationFromAddress(place);
      if(locations.isNotEmpty){
        setState(() {
          selectedLocation = LatLng(locations.first.latitude, locations.first.longitude);
        });
        _mapController.animateCamera(CameraUpdate.newLatLng(selectedLocation!));
      }
    } catch(e){
      print("Error finding location: $e");  // TODO: Handle error differently
    }
  }

  /// Build Widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add New Place")),
      body: FutureBuilder<String?>(
        future: _fetchAPIKey(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());  // Loading Data
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Error fetching API key"));
          }

          final GMPKey = snapshot.data!; // Use fetched API key

          return Column(
            children: [
              // Search Bar
              Padding(
                padding: EdgeInsets.all(10),
                child: GooglePlaceAutoCompleteTextField(
                  textEditingController: searchController,
                  googleAPIKey: GMPKey,
                  inputDecoration: InputDecoration(
                    hintText: "Search for a place",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                  debounceTime: 500,  // Debounce time in milliseconds
                  isLatLngRequired: false,
                  getPlaceDetailWithLatLng: (place) {
                    _updateMapLocation(place.description!);
                  },
                )
              ),

              // Mini Map
              Expanded(
                child: selectedLocation == null ? Center(child: Text("No location selected")) : GoogleMap(
                  initialCameraPosition: CameraPosition(
                      target: selectedLocation!,
                      zoom: 15
                    ),
                  onMapCreated: (controller) => _mapController = controller,
                  markers: {
                    Marker(markerId: MarkerId("selected"), position: selectedLocation!)
                  },
                )
              )
            ]
          );
        }
      )
    );
  }
}