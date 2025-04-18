

import 'dart:developer';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:traveler/models/userId_model.dart';
import 'package:traveler/services/supabase_api_service.dart';

class BackgroundService {
  static final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> initBackgroundService() async {
    await _initNotifications();

    await BackgroundFetch.configure(
      BackgroundFetchConfig(
        minimumFetchInterval: 15,
        stopOnTerminate: false,
        enableHeadless: true,
        startOnBoot: true,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresStorageNotLow: false,
        requiresDeviceIdle: false,
        requiredNetworkType: NetworkType.ANY,
      ),
      _onBackgroundFetch,
    );

    // Register for headless mode
    BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
  }

  static Future<void> _initNotifications() async {
    const androidSettings = AndroidInitializationSettings('logo');
    // const iOSSettings = IOSInitializationSettings(); // TODO: Implement iOS notifications

    const settings = InitializationSettings(android: androidSettings);

    await _notifications.initialize(settings);

    log('Notifications initialized');
  }

  static Future<void> _showNotification(String title, String body) async {

    const androidDetails = AndroidNotificationDetails(
      'nearby_channel',
      'Nearby Places',
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    // Show the notification
    await _notifications.show(0, title, body, notificationDetails);

    log('Notification shown: $title');
    log('Notification body: $body');
  }

  static bool _isWithinTenMinutesWalk(double userLat, double userLong, double locLat, double locLong){
    const walkingThreshold = 800; // 800 meters
    final distance = Geolocator.distanceBetween(userLat, userLong, locLat, locLong);

    log('Distance between : $distance meters');
    return distance <= walkingThreshold;
  }

  static Future<void> _onBackgroundFetch(String taskId) async {

    log('Background fetch triggered: $taskId');

    // Get the users current location
    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
        distanceFilter: 0, // only update when moving more than 10 meters
      ),
    );

    // Check if the user is logged in
    if(Supabase.instance.client.auth.currentSession == null){
      BackgroundFetch.finish(taskId);
      return;
    }
    // Get the user's ID
    String supabaseUserid = Supabase.instance.client.auth.currentUser?.id ?? '';
    // Check if the user ID is empty
    if(supabaseUserid.isEmpty){
      BackgroundFetch.finish(taskId);
      return;
    }

    // Fetch the locations from the database
    final userModel = UserIdModel(
      userId: supabaseUserid
    );
    final locations = await SupabaseApiService().fetchLocationsForBackgroundService(userModel);

    log('This many Fetched locations: ${locations.length}');

    // Iterate through the locations
    for(final location in locations){
      final double lat = location.latLng.latitude;
      final double long = location.latLng.longitude;
      final String name = location.title;

      // Check if the user is within 10 minutes walk of the location
      if(_isWithinTenMinutesWalk(position.latitude, position.longitude, lat, long)){
        await _showNotification('You\'re near $name!', 'Tap to learn more.');
        break;
      }
    }

    BackgroundFetch.finish(taskId);
  }

  static void backgroundFetchHeadlessTask(HeadlessTask task) async {
    
    if(task.timeout){
      BackgroundFetch.finish(task.taskId);
      return;
    }

    await _onBackgroundFetch(task.taskId);
  }
}