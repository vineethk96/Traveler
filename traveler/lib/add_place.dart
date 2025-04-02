import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
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
  late String mapID;

  // Pull the API Key
  Future<String?> fetchAPIKey() async {
    mapID = (await SecureStorageService.getMapsID())!;
    return await SecureStorageService.getApiKey();
  }

  // Update the Map Location upon every search
  void updateMapLocation(LatLng coordinates){

    print("updating map logic");

    setState(() {
      newLocation = coordinates;
    });

    if(_mapController != null){
      print("animating camera");
      _mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: newLocation,
            zoom: 16,
          ),
        ),
      );
    }
    else{
      print("MAP CONTROLLER IS NOT READY");
    }
    
    
  }

  // Save the Controller once the Map has been Created
  void _onMapCreated(GoogleMapController mapController){
    _mapController = mapController;
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
                      double lat = double.parse(prediction.lat ?? "0");
                      double lng = double.parse(prediction.lng ?? "0");
                      LatLng coordinates = LatLng(lat, lng);
                      updateMapLocation(coordinates);
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
                      // mapId: MapID(mapID),
                      key: UniqueKey(),
                      onMapCreated: _onMapCreated,
                      zoomControlsEnabled: false,
                      // Maybe define a marker for the new location?
                      initialCameraPosition: CameraPosition(
                        target: newLocation,
                        zoom: 15
                      ),
                      markers: {
                        Marker(markerId: MarkerId("selected"), position: newLocation)
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