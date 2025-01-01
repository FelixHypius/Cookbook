import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDatabaseService {

  // Check timestamp of local data.
  Future<String?> getTimeStamp () async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getString('latestUpdate');
    return timestamp;
  }

  // Get data from local save.
  Future<List<dynamic>> getSectionsData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('sectionsData');
    return jsonDecode(data!) as List<dynamic>;
  }

  // Get data from local save.
  Future<List<dynamic>?> getRecipesDataBySection(int secId) async {
    final prefs = await SharedPreferences.getInstance();
    final sections = prefs.getString('sectionsData');
    final recipes = prefs.getString('recipesData');
    final sectionJson = jsonDecode(sections!) as List<dynamic>;
    final recipesJson = jsonDecode(recipes!) as List<dynamic>;

    // Find the recipe Ids corresponding to the section.
    final recipesToFind = sectionJson[secId]['recipes'];

    List<dynamic> recipesFound = [];
    if (recipesToFind != null) {
      for (var r in recipesToFind) {
        recipesFound.add(recipesJson[r]);
      }
    } else {
      return null;
    }

    if (recipesFound != []){
      return recipesFound;
    }
    return null;
  }

  // Get data from local save.
  Future<List<dynamic>?> getRecipesDataById(List<int> recIds) async {
    final prefs = await SharedPreferences.getInstance();
    final recipes = prefs.getString('recipesData');
    final recipesJson = jsonDecode(recipes!) as List<dynamic>;
    final List<dynamic> recipeList = recipesJson.where((recipe) => recIds.contains(recipe['id'])).toList();
    return recipeList;
  }

  // Save data from selection.
  Future<void> setRecipesData(DataSnapshot snapshot, String latestOnline) async {
    final prefs = await SharedPreferences.getInstance();
    final recipes = snapshot.value as List<dynamic>;
    prefs.setString('recipesData', jsonEncode(recipes));
    prefs.setString('latestUpdate', latestOnline);
  }

  // Save data from selection.
  Future<void> setSectionsData(DataSnapshot snapshot, String latestOnline) async {
    final prefs = await SharedPreferences.getInstance();
    final sections = snapshot.value as List<dynamic>;
    prefs.setString('sectionsData', jsonEncode(sections));
    prefs.setString('latestUpdate', latestOnline);
  }

  // Save selection for selection list.
  Future<void> addRecipeToSelectionList(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final snap = prefs.getString('selectionList');
    if (snap != null && snap.isNotEmpty) {
      List<dynamic> selectionList = jsonDecode(snap);
      for (var selection in selectionList){
        if (selection['id'] == id) {
          selection['qty']++;
          prefs.setString('selectionList', jsonEncode(selectionList));
          return;
        }
      }
      selectionList.add({'id': id, 'qty': 1});
      prefs.setString('selectionList', jsonEncode(selectionList));
    } else {
      prefs.setString('selectionList', jsonEncode([{'id': id, 'qty': 1}]));
    }
  }

  // Get saved selections for selection list.
  Future<List<dynamic>?> get selectionList async {
    final prefs = await SharedPreferences.getInstance();
    final selectionList = prefs.getString('selectionList');
    if (selectionList != null && selectionList.isNotEmpty) {
      return jsonDecode(selectionList);
    } else {
      return null;
    }
  }

  // Get all recipes.
  Future<List<dynamic>?> get recipeList async {
    final prefs = await SharedPreferences.getInstance();
    final recipes = prefs.getString('recipesData');
    final recipesJson = jsonDecode(recipes!) as List<dynamic>;
    return recipesJson;
  }
  
  // Remove or reduce the number of a selection in the selection list.
  Future<void> removeOrReduceSelection (int id) async {
    final prefs = await SharedPreferences.getInstance();
    List<dynamic>? selectionL = await selectionList;

    if (selectionL != null && selectionL.isNotEmpty) {
      for (var selection in selectionL) {
        if (selection['id'] == id) {
          if (selection['qty'] == 1) {
            selectionL.remove(selection);
            prefs.setString('selectionList', jsonEncode(selectionL));
            return;
          } else {
            selection['qty']--;
            prefs.setString('selectionList', jsonEncode(selectionL));
            return;
          }
        }
      }
      print('Error changing quantity: No such id.');
    }
  }
}