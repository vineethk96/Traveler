import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../auth/auth_service.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  // Get Auth Service
  final authService = AuthService();

  // User Input Controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Sign Up Submission
  Future<bool> signUp() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Passwords do not match"),
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }

    try{
      await authService.signUpEmail(email, password);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Sign Up Successful"),
          duration: Duration(seconds: 2),
        ),
      );

      return true;

    } catch(e){
      if(mounted){
        // Handle error
        print("Error signing up: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $e"),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: ListView(
        children: [
          // Logo
          Container(
            padding: const EdgeInsets.all(20),
            child: Image.asset('assets/images/logo.png'),
          ),

          // Email Input
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
          ),

          // Password Input
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
          ),

          // Confirm Password Input
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
            ),
          ),

          // Sign Up Button
          ElevatedButton(
            onPressed: signUp ? () async {
              final success = await signUp();
              if (success) {
                context.go('/feed'); // Redirect to feed page on success
              }
            } : null,
            child: const Text('Sign Up'),
          ),
        ],
      ),
    );
  }
}