import 'package:flutter/material.dart';

class CustomPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final String direction;

  CustomPageRoute({required this.page, required this.direction})
      : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      if (direction == 'none') {
        return child;
      } else {

        const curve = Curves.easeInOut;

        // Define the appropriate tween based on the `homepage` parameter.
        var tween = Tween<Offset>(
          begin: (direction == 'horizontalL')
              ? const Offset(-1.0, 0.0)
              : (direction == 'horizontalR')
              ? const Offset(1.0, 0.0)
              : (direction == 'verticalT')
              ? const Offset(0.0, -1.0)
              : const Offset(0.0, 1.0),
          end: const Offset(0.0, 0.0),
        ).chain(CurveTween(curve: curve));

        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      }
    },
    transitionDuration: direction == 'none' ? Duration.zero : const Duration(milliseconds: 500),
  );
}
