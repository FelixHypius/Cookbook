import 'package:cookbook/pages/recipe_list.dart';
import '../pages/add_recipe.dart';
import 'package:flutter/material.dart';
import '../pages/edit_recipe.dart';
import '../pages/edit_section.dart';
import '../pages/recipe.dart';
import '../pages/section_list.dart';
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

  // Do not open the same page twice or more times. (except for refreshing the homepage by pressing the home button)
  if (newIndex == currentIndex) {
    if (newIndex == 1) {
      Navigator.of(context).pushReplacement(CustomPageRoute(page: const Homepage(), direction: 'none'));
    }
    return;
  }

  switch (newIndex) {
    case 0:
      scaffoldState?.openDrawer();
      break;
    case 1:
    // Navigate to Home Page
      scaffoldState?.closeDrawer();
      Navigator.of(context).pushReplacement(CustomPageRoute(page: const Homepage(), direction: direction??'none'));
      break;
    case 2:
    // Navigate to shopping list page
      scaffoldState?.closeDrawer();
      /// Functionality disabled.
      //Navigator.of(context).pushReplacement(CustomPageRoute(page: RecipeList(), direction: direction??'none'));
      break;
    case 3:
    // Navigate to Add recipe page
      scaffoldState?.closeDrawer();
      Navigator.of(context).pushReplacement(CustomPageRoute(page: const AddRecipePage(), direction: direction??'horizontalL'));
      break;
    case 4:
    // Navigate to Section page
      scaffoldState?.closeDrawer();
      Navigator.of(context).push(CustomPageRoute(page: SectionPage(sectionId: sectionId!,), direction: direction??'horizontalR'));
      break;
    case 5:
    // Navigate to recipe page
      scaffoldState?.closeDrawer();
      Navigator.of(context).push(CustomPageRoute(page: RecipePage(recipeId: recipeId!,), direction: direction??'horizontalR'));
      break;
    case 6:
    // Navigate to Add section page
      scaffoldState?.closeDrawer();
      Navigator.of(context).pushReplacement(CustomPageRoute(page: const AddSectionPage(), direction: direction??'horizontalL'));
      break;
    case 7:
    // Navigate to edit recipe page
      scaffoldState?.closeDrawer();
      Navigator.of(context).pushReplacement(CustomPageRoute(page: EditRecipePage(recipeId: recipeId!,), direction: direction??'horizontalR'));
      break;
    case 8:
    // Navigate to section list page
      scaffoldState?.closeDrawer();
      Navigator.of(context).pushReplacement(CustomPageRoute(page: SectionList(), direction: direction??'horizontalL'));
      break;
    case 9:
    // Navigate to edit section page
      scaffoldState?.closeDrawer();
      Navigator.of(context).pushReplacement(CustomPageRoute(page: EditSectionPage(sectionId: sectionId!,), direction: direction??'verticalB'));
      break;
    case 10:
    // Navigate to Settings Page

  }
}