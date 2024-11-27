import 'package:cookbook/base_widgets/base_shade.dart';
import 'package:cookbook/util/custom_text_style.dart';
import 'package:flutter/material.dart';
import '../util/colors.dart';
import '../util/navigation.dart';

class BaseListChild extends GestureDetector{
  final String text;
  final int id;
  final String imageUrl;
  final BuildContext contxt;
  final String parent;

  BaseListChild({
    super.key,
    required this.text,
    required this.id,
    required this.imageUrl,
    required this.contxt,
    required this.parent,
  }) : super (
    onTap: () {
      if (parent == 'sections') {
        navigateToPage(contxt, 4, 1, sectionId: id, direction: 'horizontalR');
      } else if (parent == 'recipes') {
        navigateToPage(contxt, 5, 4, recipeId: id);
      }
    },
    child: Container(
        decoration: BoxDecoration(
          color: MyColors.myRed,
          border: Border.all(
              color: MyColors.myWhite,
              width: 2
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            Positioned.fill(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        MyColors.myGrey.withOpacity(0.1),
                        BlendMode.saturation,
                      ),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: MyColors.myRed,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                          return Center(child: Text('Failed to load image'));
                        },
                      ),
                    )
                )
            ),
            SpecShade(
              fade: 0.75,
              rise: 0.7,
              size: 0.5,
              colour: MyColors.myBlack,
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                double width = constraints.maxWidth;
                double height = constraints.maxHeight;
                return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Divider(
                        color: MyColors.myWhite,
                        thickness: 2,
                        height: height*0.035,
                        indent: width*0.06,
                        endIndent: width*0.06,
                      ),
                      Text(
                        textAlign: TextAlign.center,
                        text,
                        style: CustomTextStyle(size: 15, colour: MyColors.myWhite),
                      ),
                      SizedBox(
                        height: height*0.035,
                      )
                    ]
                );
              },
            )
          ],
      )
    )
  );
}