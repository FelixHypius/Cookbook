import 'package:cookbook/util/custom_text_style.dart';
import 'package:flutter/material.dart';

class BaseTable extends LayoutBuilder {
  final List<dynamic> entries;
  // Array: [Col1, Col2, ...], [Col1, Col2, ...]
  //        Row1               Row2
  final List<double> colSize;
  final double spaceAfter;
  final double? spaceBefore;
  final double? textSize;

  BaseTable({
    super.key,
    required this.entries,
    required this.colSize,
    required this.spaceAfter,
    this.spaceBefore,
    this.textSize,
  }) : super (
    builder: (context, constraints) {
      List<double> colSizeR = _normalizeSizes(colSize);
      return Column(
        children: [
          SizedBox(
            height: spaceBefore??0,
          ),
          for(var row in entries) ... [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                for(var i = 0; i < row.length; i++) ... [
                  SizedBox(
                    width: colSizeR[i]*constraints.maxWidth,
                    child: Text(
                      row[i].toString(),
                      style: CustomTextStyle(size: textSize??15),
                    ),
                  )
                ]
              ],
            ),
            SizedBox(
              height: spaceAfter,
            )
          ]
        ],
      );
    }
  );

  static List<double> _normalizeSizes(List<double> sizes) {
    double sum = sizes.fold(0, (prev, element) => prev + element);
    if (sum == 0) return sizes;
    return sizes.map((size) => size / sum).toList();
  }
}