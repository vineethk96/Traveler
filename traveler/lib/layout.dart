// lib/main_layout.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainLayout extends StatefulWidget {
  final Widget body;      // The body content to display
  final int initialIndex; // The initial index to display

  const MainLayout({super.key, required this.body, this.initialIndex = 0});

  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  late int _selectedIndex = 0; // Track the selected index

  void initState(){
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  // List of pages to display for each tab
  final List<Widget> _pages = [
    const Center(child: Text('Feed Page')),
    const Center(child: Text('My Places Page')),
    const Center(child: Text('Map Page')),
    const Center(child: Text('Friends Page')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });
  }

  @override
  Widget build(BuildContext context) {

    // Create a GLobal Key for the Button
    final GlobalKey buttonKey = GlobalKey();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Traveler'),
      ),
      body: widget.body, // Display the passed body content
      floatingActionButton: FloatingActionButton(
        key: buttonKey,
        onPressed: () {

          // Get the position of the action button
          final RenderBox renderBox = buttonKey.currentContext!.findRenderObject() as RenderBox;
          final Offset buttonLocation = renderBox.localToGlobal(Offset.zero);

          // Navigate to the Add Place Page
          context.push('/addPlace', extra: buttonLocation);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.feed),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.place),
            label: 'My Places',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Friends',
          ),
        ],
        currentIndex: _selectedIndex, // Set the current index
        unselectedItemColor: Theme.of(context).colorScheme.primary,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        onTap: (index) {
          _onItemTapped(index);
          // Navigate to the corresponding page based on the selected index
          switch (index) {
            case 0:
              context.go('/feed');
              break;
            case 1:
              context.go('/places');
              break;
            case 2:
              context.go('/map');
              break;
            case 3:
              context.go('/friends');
              break;
          }
        },
      ),
    );
  }
}