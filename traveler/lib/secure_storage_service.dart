import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static final _storage = FlutterSecureStorage();

  // Store API Key
  static Future<void> saveApiKey(String apiKey) async {
    await _storage.write(key: "google_maps_api_key", value: apiKey);
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
