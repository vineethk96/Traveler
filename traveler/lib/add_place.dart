import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:traveler/secure_storage_service.dart';

class AddPlacePage extends StatefulWidget {
  const AddPlacePage({super.key});

  @override
  State<AddPlacePage> createState() => _AddPlacePage();
}

class _AddPlacePage extends State<AddPlacePage>{

  late GoogleMapController _mapController;
  final TextEditingController _textController = TextEditingController();
  late LatLng newLocation = LatLng(45.521563, -122.677433); // Default Location
  late final GMPKey;

  // Pull the API Key
  Future<String?> fetchAPIKey() async {
    return await SecureStorageService.getApiKey();
  }

  // Save the Controller once the Map has been Created
  void _onMapCreated(GoogleMapController mapController){
    _mapController = mapController;
  }

  // Update the Map Location upon every search
  void updateMapLocation(double? lat, double? lng){

    if (lat == null || lng == null) {
      print("Error: Received null latitude/longitude");
      return; // Prevents errors from null values
    }

    setState(() {
      newLocation = LatLng(lat, lng);
    });

    // Ensure mapController is initialized before calling animateCamera
    if (_mapController != null) {
      _mapController.animateCamera(CameraUpdate.newLatLng(newLocation));
    } else {
      print("Error: MapController is not initialized yet.");
    }
  }

  @override
  Widget build(BuildContext context){

    return FutureBuilder<String?>(
      future: fetchAPIKey(),
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          // Have a loading screen while we wait for the API key
          return Scaffold(
            appBar: AppBar(title: Text("Add Place...")),
            body: Center(child: CircularProgressIndicator()),
          );
        }
        
        // Error occured when trying to read the data
        if(snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty){
          return Scaffold(
            appBar: AppBar(title: Text("Add Place: Error")),
            body: Center(child: Text("Failed to Fetch API Key.")),
          );
        }

        return Scaffold(

          appBar: AppBar(title: const Text('Add Place')),

          body: Padding(

            padding: EdgeInsets.all(16.0),  // Adds Space Around the child object

            child: SingleChildScrollView(

              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,  // Centers all the children

                children: [
                  // Autocomplete Search Box
                  GooglePlaceAutoCompleteTextField(
                    textEditingController: _textController,
                    googleAPIKey: snapshot.data!,           // The key value from the future function
                    inputDecoration: InputDecoration(
                      hintText: "Search for a place",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                    debounceTime: 500,
                    isLatLngRequired: true,
                    getPlaceDetailWithLatLng: (Prediction prediction){
                      print("Selected place: ${prediction.description}");
                      print("Latitude: ${prediction.lat}, Longitude: ${prediction.lng}");

                      // updateMapLocation(prediction.lat as double, prediction.lng as double);
                      if (prediction.lat != null && prediction.lng != null) {
                        updateMapLocation(prediction.lat as double?, prediction.lng as double?);
                      } else {
                        print("Error with lat long");
                      }
                    },
                    itemClick: (Prediction prediction){
                      _textController.text = prediction.description ?? "";
                      _textController.selection = TextSelection.fromPosition(
                        TextPosition(
                          offset: prediction.description?.length ?? 0,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 16),

                  // Mini Google Map
                  SizedBox(
                    height: 300,
                    child: GoogleMap(
                        onMapCreated: _onMapCreated,
                        zoomControlsEnabled: false,
                        // Maybe define a marker for the new location?
                        initialCameraPosition: CameraPosition(
                          target: newLocation,
                          zoom: 15
                        ),
                        markers: {
                          Marker(markerId: MarkerId("selected"), position: newLocation!)
                        },
                      ),
                  ),
                  SizedBox(height: 16),

                  // Description Textbox
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Description",
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              )
            ),
          )
        );
      }
    );
  }
}