import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(      // StreamBuilder is a widget that listens to a stream and rebuilds when the stream emits a new value, in this case a user.
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(  // Widget from FlutterFire UI Package
            providers: [
              EmailAuthProvider(),
            ],
            headerBuilder: (context, constraints, shrinkOffset){
              return Padding(
                padding: const EdgeInsets.all(20),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset('assets/images/splash.png'),
                ),
              );
            },
            subtitleBuilder: (context, action){
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: action == AuthAction.signIn
                  ? const Text('Welcome back Traveller, sign in to continue!')
                  : const Text('Welcome Traveller, sign up to continue!'),
              );
            },
          );
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.go('/feed');
        });

        return const SizedBox();
        // return MainLayout(body:const FeedPage());
      },
    );
  }
}