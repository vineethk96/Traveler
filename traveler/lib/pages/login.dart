import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:traveler/auth/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  // Get Auth Service
  final authService = AuthService();

  // User Input Controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Login Submission
  void login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    try{
      await authService.signInEmail(email, password);
    } catch(e){

      if(mounted){
        // Handle error
        print("Error signing in: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $e"),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(

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
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
          ),

          // Password Input
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
          ),

          // Login Button
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: login,
              child: const Text('Login'),
            ),
          ),

          // Sign Up Button
          GestureDetector(
            onTap: () => context.go('/signup'),
            child: const Center(child: Text("Don't have an account? Sign Up")),
          )
        ],
      )
    );
  }
}