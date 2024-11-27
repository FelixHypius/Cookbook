import 'package:cookbook/test.dart';
import 'package:flutter/material.dart';
import '../util/colors.dart';

class SpecShade extends LayoutBuilder {
  double fade;
  double size;
  Color? colour;
  double rise;

  SpecShade({
    super.key,
    required this.fade,
    required this.size,
    required this.rise,
    this.colour,
  }) : super (
    builder: (context, constrains) {
      double sizeC = size > 1 ? 1 : size;
      double riseC = rise > 1 ? 1 : rise;
      double width = constrains.maxWidth;
      double height = constrains.maxHeight;
      double cornerSize = width*0.5*sizeC;
      double riseSize = height*0.5*riseC;

      return ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Stack(
          children: [
            Positioned(
              height: height-cornerSize-riseSize,
              width: cornerSize,
              top: cornerSize,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        (colour??MyColors.myGrey).withOpacity(fade), // This will create the fade effect
                      ], // Control where the gradient starts and ends
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight
                  ),
                ),
              ),
            ),
            Positioned(
              height: height-cornerSize-riseSize,
              width: cornerSize,
              top: cornerSize,
              left: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        (colour??MyColors.myGrey).withOpacity(fade), // This will create the fade effect
                      ], // Control where the gradient starts and ends
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft
                  ),
                ),
              ),
            ),
            Positioned(
              height: cornerSize,
              width: width-(2*cornerSize),
              top: 0,
              left: cornerSize,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        (colour??MyColors.myGrey).withOpacity(fade), // This will create the fade effect
                      ], // Control where the gradient starts and ends
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter
                  ),
                ),
              ),
            ),
            Positioned(
              height: cornerSize,
              width: width-(2*cornerSize),
              bottom: (riseSize-cornerSize).clamp(0, height),
              left: cornerSize,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        (colour??MyColors.myGrey).withOpacity(fade), // This will create the fade effect
                      ], // Control where the gradient starts and ends
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter
                  ),
                ),
              ),
            ),
            Positioned(
              height: cornerSize,
              width: cornerSize,
              top: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                      colors: [
                        Colors.transparent,
                        (colour??MyColors.myGrey).withOpacity(fade), // This will create the fade effect
                      ],
                      radius: 1,
                      center: Alignment.bottomLeft
                  ),
                ),
              ),
            ),
            Positioned(
              height: cornerSize,
              width: cornerSize,
              bottom: (riseSize-cornerSize).clamp(0, height),
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                      colors: [
                        Colors.transparent,
                        (colour??MyColors.myGrey).withOpacity(fade), // This will create the fade effect
                      ],
                      radius: 1,
                      center: Alignment.topLeft
                  ),
                ),
              ),
            ),
            Positioned(
              height: cornerSize,
              width: cornerSize,
              bottom: (riseSize-cornerSize).clamp(0, height),
              left: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                      colors: [
                        Colors.transparent,
                        (colour??MyColors.myGrey).withOpacity(fade), // This will create the fade effect
                      ],
                      radius: 1,
                      center: Alignment.topRight
                  ),
                ),
              ),
            ),
            Positioned(
              height: cornerSize,
              width: cornerSize,
              top: 0,
              left: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                      colors: [
                        Colors.transparent,
                        (colour??MyColors.myGrey).withOpacity(fade), // This will create the fade effect
                      ],
                      radius: 1,
                      center: Alignment.bottomRight
                  ),
                ),
              ),
            ),
            Positioned(
              height: riseSize-cornerSize,
              width: width,
              bottom: 0,
              left: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      (colour??MyColors.myGrey).withOpacity(fade),
                      (colour??MyColors.myGrey).withOpacity((fade+1).clamp(0, 1)),
                    ],
                    stops: [0.2, 1.0],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  );
}