import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:traveler/auth/auth_service.dart';
import 'dart:convert';

import 'package:traveler/auth/secure_storage_service.dart';
import 'package:traveler/auth/user_provider.dart';

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
  Future<http.Response> addLocation(String userId, String gmapsId, String info) async {

    final url = Uri.parse('$supabaseUrl/functions/v1/add-location');

    final Map<String, String> data = {
      'user_id': userId,
      'gmaps_id': gmapsId,
      'info': info,
    };

    final http.Response response;

    try{
      // Send the POST request
      response = await http.post(
        url,
        headers: defaultHeaders,
        body: jsonEncode(data),
      );

      // Check the response status code
      if (response.statusCode == 200) {
        log('Location added successfully');
      } else {
        log('Failed to add location: ${response.statusCode}');
      }

      // log('Response: ${response.body}');
        
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
}