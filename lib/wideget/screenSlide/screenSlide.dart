import 'package:flutter/material.dart';

Route _slideRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (_, __, ___) => page,
    transitionDuration: const Duration(
      milliseconds: 700,
    ), // Custom animation duration
    reverseTransitionDuration: const Duration(
      milliseconds: 700,
    ), // Reverse animation duration
    transitionsBuilder: (_, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0); // Slide in from the right
      const end = Offset.zero; // End at the normal position
      const curve = Curves.easeInOut; // Smooth easing curve

      // Slide animation
      final slideTween = Tween(
        begin: begin,
        end: end,
      ).chain(CurveTween(curve: curve));
      final slideAnimation = animation.drive(slideTween);

      // Fade animation
      final fadeTween = Tween<double>(begin: 0.0, end: 1.0);
      final fadeAnimation = animation.drive(fadeTween);

      return SlideTransition(
        position: slideAnimation,
        child: FadeTransition(
          opacity: fadeAnimation, // Combine fade with slide
          child: child,
        ),
      );
    },
  );
}

Route slideRoute(Widget page) => _slideRoute(page);
