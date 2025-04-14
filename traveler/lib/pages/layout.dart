// lib/main_layout.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainLayout extends StatelessWidget {
  final Widget child;      // The body content to display

  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text('Traveler')),

      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: () {
          context.push('/addPlace');
        },
        tooltip: 'Add Place',
        child: const Icon(Icons.add),
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.feed), label: 'Feed'),
          BottomNavigationBarItem(icon: Icon(Icons.place), label: 'My Places'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Friends'),
        ],
        currentIndex: _getSelectedIndex(context),
        onTap: (index) {
          switch(index) {
            case 0: context.go('/feed'); break;
            case 1: context.go('/places'); break;
            case 2: context.go('/map'); break;
            case 3: context.go('/friends'); break;
          }
        },
        unselectedItemColor: Theme.of(context).colorScheme.primary,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
      ),

      body: child,  // Use the child widget from the go_router
    );
  }

  int _getSelectedIndex(BuildContext context){
    final String location = GoRouterState.of(context).uri.toString();
    if(location == '/feed') return 0;
    if(location == '/places') return 1;
    if(location == '/map') return 2;
    if(location == '/friends') return 3;
    return 0;
  }
}