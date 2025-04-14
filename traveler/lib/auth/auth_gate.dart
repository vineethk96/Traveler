///
/// Checks for Auth State Changes
/// and redirects to the login page if not authenticated
/// 


import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:traveler/pages/feed.dart';
import 'package:traveler/pages/login.dart';

class AuthGate extends StatelessWidget{
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context){

    return StreamBuilder(
      // Listen to auth state changes
      stream: Supabase.instance.client.auth.onAuthStateChange,

      // Route to page based on auth state
      builder: (context, snapshot){

        // Loading
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Check for valid session
        final session = snapshot.hasData ? snapshot.data!.session : null;

        if(session != null){
          // User is logged in
          return const FeedPage();  // Is this the right way to move to the feed?
        } else {
          // User is not logged in
          return const LoginPage();
        }


      },
    );
  }
}