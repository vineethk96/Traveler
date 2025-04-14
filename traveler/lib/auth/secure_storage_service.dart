import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SecureStorageService {
  static final _storage = FlutterSecureStorage();

  // Store API Key
  static Future<void> loadSecrets() async {
    // Pull Value from .env File
    await dotenv.load(fileName: ".env");

    // Save Value in Secure Storage
    await _storage.write(key: "google_maps_api_key", value: dotenv.env['MAPS_API_KEY']);

    // Save Maps ID
    await _storage.write(key: "android_maps_id", value: dotenv.env['ANDROID_MAPID']); 

    // Save Supabase URL
    await _storage.write(key: "supabase_url", value: dotenv.env['SUPABASE_URL']);

    // Save Supabase Key
    await _storage.write(key: "supabase_key", value: dotenv.env['SUPABASE_KEY']);
  }

  // Retrieve API Key
  static Future<String?> getMapsKey() async {
    return await _storage.read(key: "google_maps_api_key");
  }

  // Delete API Key
  static Future<void> deleteMapsKey() async {
    await _storage.delete(key: "google_maps_api_key");
  }

  // Retrieve Maps ID
  static Future<String?> getMapsID() async {
    return await _storage.read(key: "android_maps_id");
  }

  // Delete Maps ID
  static Future<void> deleteMapsID() async {
    await _storage.delete(key: "android_maps_id");
  }

  // Retrieve Supabase URL
  static Future<String?> getSupabaseURL() async {
    return await _storage.read(key: "supabase_url");
  }

  // Delete Supabase URL
  static Future<void> deleteSupabaseURL() async {
    await _storage.delete(key: "supabase_url");
  }

  // Retrieve Supabase Key
  static Future<String?> getSupabaseKey() async {
    return await _storage.read(key: "supabase_key");
  }

  // Delete Supabase Key
  static Future<void> deleteSupabaseKey() async {
    await _storage.delete(key: "supabase_key");
  }
}