// Import packages
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:traveler/firebase_options.dart';
import 'package:traveler/layout.dart';
import 'package:traveler/map.dart';
import 'package:traveler/secure_storage_service.dart';

// Import all the pages
import 'transitions.dart';
import 'app_state.dart';
import 'not_found.dart';
import 'auth_gate.dart';
import 'feed.dart';
import 'add_place.dart';

void main() async {
  // Ensure that the Flutter engine is initialized before initializing Firebase.
  WidgetsFlutterBinding.ensureInitialized();

  // Save the API Key in Secure Storage
  await SecureStorageService.saveApiKey();
  print("Key has been saved?");
  String? key = await SecureStorageService.getApiKey();
  print(key);

  // Initialize Firebase and Imports Firebase Keys
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ChangeNotifierProvider(
    create:(context) => ApplicationState(),
    builder: ((context,child) => AppRoot()),
  ));
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
            builder: (context, state) => const Center(child: Text('Places Page')),
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