import '../pages/add_recipe.dart';
import 'package:flutter/material.dart';
import '../pages/recipe.dart';
import 'custom_page_route.dart';
import '../pages/home.dart';
import '../pages/section.dart';
import '../pages/add_section.dart';

void navigateToPage(
    BuildContext context,
    int newIndex,
    int currentIndex,
    {ScaffoldState? scaffoldState,
      int? sectionId,
      String? direction,
      int? recipeId
    })
{
  if (newIndex == currentIndex) return;

  switch (newIndex) {
    case 0:
      scaffoldState?.openDrawer();
      break;
    case 1:
    // Navigate to Home Page
      scaffoldState?.closeDrawer();
      Navigator.of(context).push(CustomPageRoute(page: const Homepage(), direction: direction??'verticalB'));
      break;
    case 2:
    // Navigate to Settings Page

      break;
    case 3:
    // Navigate to Add recipe page
      scaffoldState?.closeDrawer();
      Navigator.of(context).push(CustomPageRoute(page: const AddRecipePage(), direction: direction??'horizontalL'));
      break;
    case 4:
    // Navigate to Section page
      scaffoldState?.closeDrawer();
      Navigator.of(context).push(CustomPageRoute(page: SectionPage(sectionId: sectionId!,), direction: direction??'verticalB'));
    case 5:
    // Navigate to recipe page
      scaffoldState?.closeDrawer();
      Navigator.of(context).push(CustomPageRoute(page: RecipePage(recipeId: recipeId!,), direction: direction??'horizontalR'));
    case 6:
    // Navigate to Add section page
      scaffoldState?.closeDrawer();
      Navigator.of(context).push(CustomPageRoute(page: const AddSectionPage(), direction: direction??'horizontalL'));
  }
}