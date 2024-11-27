import 'package:flutter/material.dart';

class CustomShapeClipper extends CustomClipper<Path> {
  final double mod1;
  final double mod2;

  CustomShapeClipper(this.mod1, this.mod2);

  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height); // Start from the bottom left corner
    path.lineTo(size.width - mod1, size.height); // Bottom right corner
    path.lineTo(size.width - mod1, mod2); // Move to the middle
    path.quadraticBezierTo(
        size.width / 2, size.height * 0.5, 0, mod2); // Inverted curve
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}