import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Page addNewPlaceTransition(Widget child, Offset buttonLocation) {
  return CustomTransitionPage(
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final begin = buttonLocation; // Start from the right
      const end = Offset.zero; // End at the center
      const curve = Curves.easeInOut;

      // Create the animation
      var tween = Tween(
        begin: begin, 
        end: end
      ).chain(CurveTween(curve: curve));

      var curvedAnimation = CurvedAnimation(
        parent: animation, 
        curve: curve
      );

      var offsetAnimation = tween.animate(curvedAnimation);

      // Return a SlideTransition with the animation
      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}