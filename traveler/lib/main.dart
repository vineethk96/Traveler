// Import packages
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:traveler/firebase_options.dart';

// Import all the pages
import 'app_state.dart';
import 'not_found.dart';
import 'auth_gate.dart';
// import 'login_select.dart';
import 'feed.dart';
import 'add_place.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  // Ensure that the Flutter engine is initialized before initializing Firebase.

  await Firebase.initializeApp(               // Initialize Firebase and Imports Firebase Keys
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ChangeNotifierProvider(
    create:(context) => ApplicationState(),
    builder: ((context,child) => AppRoot()),
  ));
  //  const AppRoot());
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
      GoRoute(
        path: '/',
        builder: (context, state) => const AuthGate(),
      ),
      GoRoute(
        path: '/feed',
        builder: (context, state) => const FeedPage(),
      ),
      GoRoute(
        path: '/addPlace',
        builder: (context, state) => const AddPlacePage(),
      ),
      
    ],
  );

} // AppRoot