// Import packages
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:traveler/auth/auth_gate.dart';
import 'package:traveler/auth/user_provider.dart';
import 'package:traveler/pages/layout.dart';
import 'package:traveler/pages/login.dart';
import 'package:traveler/pages/map.dart';
import 'package:traveler/auth/secure_storage_service.dart';
import 'package:traveler/pages/places.dart';
import 'package:traveler/pages/signup.dart';
import 'package:traveler/services/background_service.dart';
import 'package:traveler/services/supabase_api_service.dart';

// Import all the pages
import 'animations/transitions.dart';
import 'pages/not_found.dart';
import 'pages/feed.dart';
import 'pages/add_place.dart';

void main() async {
  // Ensure that the Flutter engine is initialized before initializing.
  WidgetsFlutterBinding.ensureInitialized();

  // Save the API Key in Secure Storage
  await SecureStorageService.loadSecrets();
  log("Key has been saved?");
  String? key = await SecureStorageService.getMapsKey();
  log(key!);

  // Pull in the URL and Key from Secure Storage
  String supabaseKey = await SecureStorageService.getSupabaseKey() ?? '';
  String supbaseUrl = await SecureStorageService.getSupabaseURL() ?? '';

  // Initialize SupaBase
  await Supabase.initialize(
    anonKey: supabaseKey,
    url: supbaseUrl,
  );

  // Initialize the API Service
  await SupabaseApiService().initApi();

  runApp(
    ChangeNotifierProvider(
      create: (_) => UserProvider(), // Create a new instance of UserProvider
      child: AppRoot(),
    )
  );
  BackgroundService.initBackgroundService();
}

class AppRoot extends StatelessWidget {
  AppRoot({super.key}); // compare old and new widgets when rebuilding, which helps with performance.

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Traveler',
      themeMode: ThemeMode.system,
      // Define Global Theme
      theme: ThemeData(
        // Use `fromSeed` to generate a color scheme from a single color
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0x003AE894)
        ),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }

  // Define the GoRouter
  final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: [
      // Auth Route
      GoRoute(
        path: '/',
        builder: (context, state) => const AuthGate(),
      ),
      // Add Place FAB Route
      GoRoute(
        path: '/addPlace',
        pageBuilder: (context, state){
          final buttonPosition = state.extra as Offset? ?? Offset.zero; // Get the button position from the extra data, and default to 0 if it doesn't exsist
          return addNewPlaceTransition(
            AddPlacePage(), 
            buttonPosition
          );
        },
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignUp(),
      ),
      // Bottom Nav Bar Routes
      ShellRoute(
        builder: (context, state, child){
          return MainLayout(child: child);  // Persist Scaffold, swap Body
        },
        routes: [
          GoRoute(
            path: '/feed',
            builder: (context, state) => const Center(child: FeedPage()),
          ),
          GoRoute(
            path: '/places',
            builder: (context, state) => const Center(child: PlacesPage()),
          ),
          GoRoute(
            path: '/map',
            builder: (context, state) => const Center(child: MapPage()),
          ),
          GoRoute(
            path: '/friends',
            builder: (context, state) => const Center(child: Text('Friends Page')),
          ),
        ]
      )
    ],
  );

} // AppRoot