import 'package:flutter/material.dart';
import 'not_found.dart';
import 'login_select.dart';
import 'feed.dart';
import 'add_place.dart';

void main() {
  runApp(const AppRoot());
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key}); // compare old and new widgets when rebuilding, which helps with performance.

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      initialRoute: '/', // App Starts Here
      onGenerateRoute: (settings) {

        // Simulate User Authentication
        bool isLoggedIn = true;  // TODO: Swap with Firebase User Auth

        // TODO: Do we need the /feed and /login routes here?

        switch (settings.name) {  // Define all the routing in a single place
          case '/': // Dynamically switch between Feed and Login
            return MaterialPageRoute(
              builder: (context) => isLoggedIn ? const FeedPage() : const LoginSelectPage(),
            );
          case '/feed': // Go to Feed Page
            return MaterialPageRoute(
              builder: (context) => const FeedPage(),
            );
          case '/login': // Go to Login Page
            return MaterialPageRoute(
              builder: (context) => const LoginSelectPage(),
            );
          case '/add_place': // Go to Add Place Page
            return MaterialPageRoute(
              builder: (context) => const AddPlacePage(),
            );
          default:
            return MaterialPageRoute(builder: (context) => const NotFoundPage());
        }
      },
    );
  }
}