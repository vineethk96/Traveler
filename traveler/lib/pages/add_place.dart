import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:traveler/auth/secure_storage_service.dart';

/// Create a Stateful Widget for the Add Place Page
class AddPlacePage extends StatefulWidget {
  const AddPlacePage({super.key});

  @override
  State<AddPlacePage> createState() => _AddPlacePage();
}


class _AddPlacePage extends State<AddPlacePage>{

  late GoogleMapController _mapController;                                      // The controller for the map
  late String mapID;                                                            // Links to the Custom Map in GMaps
  late String apiKey;                                                           // The API Key for Google Maps
  final TextEditingController _searchController = TextEditingController();      // The text controller for the search box
  final TextEditingController _descriptionController = TextEditingController(); // The text controller for the description box
  LatLng searchedLocation = LatLng(45.521563, -122.677433);                     // Default Location on the map
  Set<Marker> _visibleMarkers = {};                                             // The markers that are visible on the map


  // Save the Controller once the Map has been Created
  void _onMapCreated(GoogleMapController mapController){
    _mapController = mapController;

    // Delay before moving the camera, this is supposedly to help with making sure the map is loaded correctly
    Future.delayed(Duration(milliseconds: 500));
  }


  // Pull the API Key
  Future<String?> fetchAPIKey() async {
    mapID = (await SecureStorageService.getMapsID())!;
    apiKey = (await SecureStorageService.getMapsKey())!;
    log("API Key: $apiKey");
    return apiKey;
  }


  // Update the Map Location upon every search
  void updateMapLocation() async{

    log("updating map logic");

    await _mapController.animateCamera(
      CameraUpdate.newLatLngZoom(
        searchedLocation,
        16
      ),
    );

    final newMarker = Marker(
      markerId: MarkerId('searchLocation'),
      position: searchedLocation,
      infoWindow: InfoWindow(
        title: 'Search Location',
        snippet: '${searchedLocation.latitude}, ${searchedLocation.longitude}',
      ),
    );

    setState((){
      _visibleMarkers = {newMarker};
    });
    
  }


  @override
  Widget build(BuildContext context){

    return FutureBuilder<String?>(

      future: fetchAPIKey(),
      builder: (context, snapshot){

        // While we wait for the API Key
        if(snapshot.connectionState == ConnectionState.waiting){
          // Have a loading screen while we wait for the API key
          return Scaffold(
            appBar: AppBar(title: Text("Add Place: Loading")),
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

        apiKey = snapshot.data!;  // Update the API Key

        return Scaffold(

          appBar: AppBar(title: const Text('Add Place')),
          body: SingleChildScrollView(

            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(

              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GooglePlaceAutoCompleteTextField(

                    textEditingController: _searchController,
                    googleAPIKey: apiKey,
                    inputDecoration: InputDecoration(
                      hintText: "Search for a place",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                    debounceTime: 500,
                    isLatLngRequired: true,
                    getPlaceDetailWithLatLng: (Prediction prediction){
                      log("Selected place: ${prediction.description}");
                      log("Latitude: ${prediction.lat}, Longitude: ${prediction.lng}");
                      double lat = double.parse(prediction.lat ?? "0");
                      double lng = double.parse(prediction.lng ?? "0");
                      searchedLocation = LatLng(lat, lng);

                      updateMapLocation();
                    },
                    itemClick: (Prediction prediction){
                      _searchController.text = prediction.description ?? "";
                      _searchController.selection = TextSelection.fromPosition(
                        TextPosition(
                          offset: prediction.description?.length ?? 0,
                        ),
                      );
                    },
                  ),
                ),


                SizedBox(
                  height: 300,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: searchedLocation,
                      zoom: 15
                    ),
                    onMapCreated: _onMapCreated,
                    zoomControlsEnabled: false,
                    // Maybe define a marker for the new location?
                    markers: _visibleMarkers,
                    // mapId: MapID(mapID),
                    // key: UniqueKey(),
                  ),
                ),



                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(hintText: "Description"),
                  )
                ),


                ElevatedButton(
                  onPressed: (){
                    // Send API POST Request to save the place
                  },
                  child: Text('Save Place'),
                ),


              ],
            )
          )
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          // Padding(

          //   padding: EdgeInsets.all(16.0),  // Adds Space Around the child object
          //   child: SingleChildScrollView(

          //     keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          //     child: Column(

          //       mainAxisAlignment: MainAxisAlignment.center,  // Centers all the children
          //       children: [

          //         // Autocomplete Search Box
          //         GooglePlaceAutoCompleteTextField(

          //           textEditingController: _searchController,
          //           googleAPIKey: snapshot.data!,           // The key value from the future function
          //           inputDecoration: InputDecoration(
          //             hintText: "Search for a place",
          //             border: OutlineInputBorder(),
          //             prefixIcon: Icon(Icons.search),
          //           ),
          //           debounceTime: 500,
          //           isLatLngRequired: true,
          //           getPlaceDetailWithLatLng: (Prediction prediction){
          //             log("Selected place: ${prediction.description}");
          //             log("Latitude: ${prediction.lat}, Longitude: ${prediction.lng}");
          //             double lat = double.parse(prediction.lat ?? "0");
          //             double lng = double.parse(prediction.lng ?? "0");
          //             searchedLocation = LatLng(lat, lng);
          //             //updateMapLocation();
          //           },
          //           itemClick: (Prediction prediction){
          //             _searchController.text = prediction.description ?? "";
          //             _searchController.selection = TextSelection.fromPosition(
          //               TextPosition(
          //                 offset: prediction.description?.length ?? 0,
          //               ),
          //             );

          //            updateMapLocation();
          //           },
          //         ),
          //         SizedBox(height: 16),

          //         /*
          //           TODO: When returning to this problem, take a look at this stackoverflow page.
          //           https://stackoverflow.com/questions/48844804/flutter-setstate-not-updating-inner-stateful-widget

          //           Currently, the issue is when the user tries to search for a new location, the map is changing, 
          //           however, the tiles do not update.
          //         */




          //         // Mini Google Map
          //         //SizedBox(
          //         Expanded(
          //           //height: 300,
          //           child: GoogleMap(
          //             // mapId: MapID(mapID),
          //             // key: UniqueKey(),
          //             onMapCreated: _onMapCreated,
          //             zoomControlsEnabled: false,
          //             // Maybe define a marker for the new location?
          //             initialCameraPosition: CameraPosition(
          //               target: searchedLocation,
          //               zoom: 15
          //             ),
          //             markers: _visibleMarkers,
          //           ),
          //         ),
          //         SizedBox(height: 16),

          //         // Description Textbox
          //         TextField(
          //           decoration: InputDecoration(
          //             border: OutlineInputBorder(),
          //             hintText: "Description",
          //           ),
          //         ),
          //         SizedBox(height: 16),
          //       ],
          //     )
          //   ),
          // )
        );
      }
    );
  }
}