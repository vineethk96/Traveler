import 'package:flutter/material.dart';

class LoginSelectPage extends StatelessWidget {
  const LoginSelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            // TODO: Swap these out with Firebase Auth

            ElevatedButton(
              onPressed: () {
                // Simulate successful login and navigate to feed
                Navigator.pushReplacementNamed(context, '/feed');
              },
              child: const Text('Login'),
            ),
            ElevatedButton(
              onPressed: () {
                // Simulate successful login and navigate to home
                Navigator.pushReplacementNamed(context, '/feed');
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}