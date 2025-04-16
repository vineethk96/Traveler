///
/// Checks for Auth State Changes
/// and redirects to the login page if not authenticated
/// 


import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:traveler/auth/user_provider.dart';
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

        WidgetsBinding.instance.addPostFrameCallback((_) {
          // Check if session is null
          if(session == null){
            context.go('/login');  // Redirect to login page
          } else {

            // Set user ID in UserProvider
            Provider.of<UserProvider>(context, listen: false).setUserId(session.user.id);

            String userId = session.user.id;
            log("User ID: $userId");
            
            context.go('/feed');  // Redirect to feed page
          }
        });

        return const SizedBox.shrink();  // Placeholder widget while redirecting
      },
    );
  }
}