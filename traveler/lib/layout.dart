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

// class _MainLayoutState extends State<MainLayout> {

//   // List of pages to display for each tab
//   final List<Widget> _pages = [
//     const Center(child: Text('Feed Page')),
//     const Center(child: Text('My Places Page')),
//     const Center(child: Text('Map Page')),
//     const Center(child: Text('Friends Page')),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index; // Update the selected index
//     });
//   }

//   @override
//   Widget build(BuildContext context) {

//     // Create a GLobal Key for the Button
//     final GlobalKey buttonKey = GlobalKey();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Traveler'),
//       ),
//       floatingActionButton: FloatingActionButton(
//         key: buttonKey,
//         heroTag: null,  // disables hero animation
//         onPressed: () {

//           // Get the position of the action button
//           final RenderBox renderBox = buttonKey.currentContext!.findRenderObject() as RenderBox;
//           final Offset buttonLocation = renderBox.localToGlobal(Offset.zero);

//           // Navigate to the Add Place Page
//           context.push('/addPlace', extra: buttonLocation);
//         },
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.feed),
//             label: 'Feed',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.place),
//             label: 'My Places',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.map),
//             label: 'Map',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.people),
//             label: 'Friends',
//           ),
//         ],
//         currentIndex: _selectedIndex, // Set the current index
//         unselectedItemColor: Theme.of(context).colorScheme.primary,
//         selectedItemColor: Theme.of(context).colorScheme.secondary,
//         onTap: (index) {
//           _onItemTapped(index);
//           // Navigate to the corresponding page based on the selected index
//           switch (index) {
//             case 0:
//               context.go('/feed');
//               break;
//             case 1:
//               context.go('/places');
//               break;
//             case 2:
//               context.go('/map');
//               break;
//             case 3:
//               context.go('/friends');
//               break;
//           }
//         },
//       ),
//       body: widget.body, // Display the passed body content
//     );
//   }
// }