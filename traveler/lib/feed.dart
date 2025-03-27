import 'package:flutter/material.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('My Feed'),
      ),
      body: Center(
        child: Text('Welcome to the Feed Page!'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

          // Get the position of the action button
          final RenderBox renderBox = context.findRenderObject() as RenderBox;
          final buttonPosition = renderBox.localToGlobal(Offset.zero);

          // Navigate to the Add Place Page
          //Navigator.pushNamed(context, '/add_place');
          Navigator.of(context).pushNamed('/add_place', arguments: buttonPosition);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

/**
 * Custom Page Route that animates from the action button to the center of the screen
 * 
 * Arguments:
 * - buttonLocation: Offset - The location of the action button
 */
class ActionButtonPageRoute extends PageRouteBuilder {
  final Offset buttonLocation;

  ActionButtonPageRoute({required WidgetBuilder builder, required this.buttonLocation}) : super (
    pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    transitionsBuilder: (context, animation, secondaryAnimation, child){
      const begin = Offset(0.0, 0.0);
      const end = Offset(0.0, 0.0);
      const curve = Curves.easeInOut;

      // Figure out action button position
      final buttonOffset = Offset(
        buttonLocation.dx / MediaQuery.of(context).size.width,
        buttonLocation.dy / MediaQuery.of(context).size.height,
      );

      // Create an animation that moves from the button to the center
      final tween = Tween<Offset>(begin: buttonOffset, end: end).chain(CurveTween(curve: curve));
      final offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}