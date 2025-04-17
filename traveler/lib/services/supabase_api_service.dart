import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:traveler/auth/auth_service.dart';
import 'dart:convert';

import 'package:traveler/auth/secure_storage_service.dart';
import 'package:traveler/auth/user_provider.dart';
import 'package:traveler/models/add_place_model.dart';
import 'package:traveler/models/saved_place_model.dart';
import 'package:traveler/models/userId_model.dart';

class SupabaseApiService {

  // Singleton instance
  static final SupabaseApiService _instance = SupabaseApiService._internal();

  // Private constructor
  SupabaseApiService._internal();

  // Factory constructor to return the singleton instance
  factory SupabaseApiService() {
    return _instance;
  }

  // Pull info from Secure Storage
  static late final String supabaseUrl;
  static late final String supabaseKey;
  
  static final Map<String, String> defaultHeaders = {
    'Authorization': 'Bearer $supabaseKey',
    'Content-Type': 'application/json',
  };

  Future<void> initApi() async {
    // Pull in the URL and Key from Secure Storage
    supabaseKey = await SecureStorageService.getSupabaseKey() ?? '';
    supabaseUrl = await SecureStorageService.getSupabaseURL() ?? '';
  }

  // POST Req: Add Location
  Future<http.Response> addLocation(AddPlaceModel place) async {

    final url = Uri.parse('$supabaseUrl/functions/v1/add-location');

    final http.Response response;

    log('body: ${place.toJson()}');

    try{
      // Send the POST request
      response = await http.post(
        url,
        headers: defaultHeaders,
        body: jsonEncode(place.toJson()),
      );

      // Check the response status code
      if (response.statusCode == 200) {
        log('Location added successfully');
      } else {
        log('Failed to add location: ${response.statusCode}');
      }

      log('Response: ${response.body}');
        
    }catch(e){
      log('Error: $e');

      // Handle the error
      return http.Response(
        'Error: $e',
        500,
      );
    }

    return response;
  }

  // POST Req: Get Locations
  Future<List<SavedLocationModel>> fetchSavedLocations(UserIdModel userId) async{
    
    final url = Uri.parse('$supabaseUrl/functions/v1/get-user-locations');
    log("url: $url");

    final http.Response response;

    log('response was made');

    try{
      log('Sending request to fetch saved locations');
      response = await http.post(
        url,
        headers: defaultHeaders,
        body: jsonEncode(userId.toJson()),
      );

      log('Response: ${response.body}');
      
      // Check the response status code
      if(response.statusCode == 200){
        log('Fetched Saved Locations');

        final List<dynamic> placeList = jsonDecode(response.body);
        return placeList
        .map((json) => SavedLocationModel.fromJson(json as Map<String, dynamic>))
        .toList();

      }
      else{
        log('Failed to fetch locations: ${response.statusCode}');
      }
    }
    catch(e){
      log('Error: $e');
    }

    // Return a Null value because an error has occured
    return Future.value([]);
  }
}