import 'package:flutter/material.dart';

class AddPlacePage extends StatelessWidget {
  const AddPlacePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Add Place'),
      ),
      body: Center(
        child: Text('Welcome to the Add Place Page!'),
      ),
    );
  }
}