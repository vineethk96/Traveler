import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';

class SecureStorageService {
  static final _storage = FlutterSecureStorage();

  // Store API Key
  static Future<void> saveApiKey() async {
    // Pull Value from .env File
    await dotenv.load(fileName: ".env");

    // Save Value in Secure Storage
    await _storage.write(key: "google_maps_api_key", value: dotenv.env['MAPS_API_KEY']);
  }

  // Retrieve API Key
  static Future<String?> getApiKey() async {
    return await _storage.read(key: "google_maps_api_key");
  }

  // Delete API Key
  static Future<void> deleteApiKey() async {
    await _storage.delete(key: "google_maps_api_key");
  }
}