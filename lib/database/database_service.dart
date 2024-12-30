import 'dart:typed_data';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

class DatabaseService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  // Method to get data from the database
  Future<Object?> get(String path) async {
    final snapshot = await _dbRef.child(path).get();
    if (snapshot.exists) {
      return snapshot.value;
    }
    return null;
  }

  // Method to update existing tree-data
  Future<void> setBulk(String path, Map<String, dynamic> data) async {
    try {
      await _dbRef.child(path).set(data);
      print('Data updated successfully at $path');
    } catch (error) {
      print('Error updating data: $error');
    }
  }

  // Method to update existing data
  Future<void> set(String path, Object? data) async {
    try {
      await _dbRef.child(path).set(data);
      print('Data updated successfully at $path');
    } catch (error) {
      print('Error updating data: $error');
    }
  }

  // Method to delete data
  Future<void> delete(String path) async {
    try {
      await _dbRef.child(path).remove();
      print('Data deleted successfully from $path');
    } catch (error) {
      print('Error deleting data: $error');
    }
  }

  // Specific method to get latestRecipeID
  Future<int?> get idRecipe async {
    final idSnap = await _dbRef.root.child('latestID').get();
    if (idSnap.exists) {
      return idSnap.value as int;
    }
    return null;
  }

  // Specific method to get latestSectionID
  Future<int?> get idSection async {
    final idSnap = await _dbRef.root.child('latestSection').get();
    if (idSnap.exists) {
      return idSnap.value as int;
    }
    return null;
  }

  // Specific method to get matching id for section name
  Future<int?> getSectionId(String title) async {
    final sectionsSnap = await _dbRef.root.child('sections').get();
    if (sectionsSnap.exists) {
      final List<dynamic> sectionsList = sectionsSnap.value as List<dynamic>;
      final List<dynamic> filteredSectionsList = sectionsList.where((element) => element != null).toList();
      for (var section in filteredSectionsList) {
        if (section != null && section['title'] == title) {
          return section['id'];
        }
      }
    }
    return null;
  }

  // Specific method to get matching title for section id
  Future<String?> getSectionTitle(String id) async {
    final sectionsSnap = await _dbRef.root.child('sections').get();
    if (sectionsSnap.exists) {
      final List<dynamic> sectionsList = sectionsSnap.value as List<dynamic>;
      final List<dynamic> filteredSectionsList = sectionsList.where((element) => element != null).toList();
      for (var section in filteredSectionsList) {
        if (section != null && section['id'].toString() == id) {
          return section['title'];
        }
      }
    }
    return null;
  }

  // Specific method to get sectionId from recipe by id
  Future<int?> getSectionFromRecipe(int id) async {
    final recipeSnap = await _dbRef.root.child('recipes').get();
    if (recipeSnap.exists) {
      final List<dynamic> recipeList = recipeSnap.value as List<dynamic>;
      final List<dynamic> filteredRecipeList = recipeList.where((element) => element != null).toList();
      for (var recipe in filteredRecipeList) {
        if (recipe != null && recipe['id'] == id) {
          return recipe['section'];
        }
      }
    }
    return null;
  }

  // Specific method to get all recipes from one sectionId
  Future<List<Map<String, dynamic>>?> getRecipeList(int sectionId) async {
    try {
      final List<dynamic> idList = await get('sections/$sectionId/recipes') as List<dynamic>;
      final List<dynamic> allRecipeList = await get('recipes') as List<dynamic>;
      final List<Map<String, dynamic>> recipeList = allRecipeList
          .where((recipe) => idList.contains(recipe['id'])) // Check if recipe ID is in idList
          .map((recipe) => Map<String, dynamic>.from(recipe as Map<Object?, dynamic>))
          .toList();
      return recipeList;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Specific method for uploading image
  Future<String?> uploadImg(Uint8List image, {required String category}) async {
    // category is recipes or sections
    Reference ref = FirebaseStorage.instanceFor(bucket: 'gs://felix-s-cookbook.firebasestorage.app').ref().child('$category/${await idRecipe}');
    UploadTask uploadTask = ref.putData(image);
    TaskSnapshot snapshot = await uploadTask;

    if (snapshot.state == TaskState.success) {
      return await ref.getDownloadURL();
    } else {
      print('Upload failed with state: ${snapshot.state}');
      return null;
    }
  }

  // Specific method for uploading a new recipe.
  Future<void> uploadRecipe({
    required String title,
    required String sec,
    required List<Map<String,String>> ing,
    required String img,
    required String description
  }) async {
    final recipeID = await idRecipe;
    final sectionID = await getSectionId(sec);
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('dd.MM.yyyy HH:mm:ss');
    String timestamp = formatter.format(now);
    // Add new recipe
    Map<String, dynamic> recipe = {
      'id' : recipeID,
      'section' : sectionID,
      'imageUrl' : img,
      'title' : title,
      'ingredients' : ing,
      'description' : description,
      'uploaded' : timestamp
    };
    setBulk('recipes/$recipeID', recipe);
    // Increase id counter
    set('latestID', recipeID!+1);
    // Update section
    final Object? value = await get('sections/$sectionID/recipes');
    List<int> currentIdList = [];
    if (value != null) {
      currentIdList = List<int>.from(value as List<dynamic>);
    }
    currentIdList.add(recipeID);
    set('sections/$sectionID/recipes', currentIdList);
  }

  // Specific method for uploading a new section.
  Future<void> uploadSection({required String title, required String img}) async {
    final sectionID = await idSection;
    // Add new recipe
    Map<String, dynamic> section = {
      'id' : sectionID,
      'imageUrl' : img,
      'title' : title,
    };
    setBulk('sections/$sectionID', section);
    // Increase id counter
    set('latestSection', sectionID!+1);
  }

  // Specific method for editing an old recipe.
  Future<void> editRecipe({
    required String title,
    required String sec,
    required List<Map<String,String>> ing,
    required String img,
    required String description,
    required int recipeID
  }) async {
    final sectionIdFromRecipe = await getSectionFromRecipe(recipeID);
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('dd.MM.yyyy HH:mm:ss');
    String timestamp = formatter.format(now);
    // Edit old recipe
    Map<String, dynamic> recipe = {
      'id' : recipeID,
      'section' : sectionIdFromRecipe,
      'imageUrl' : img,
      'title' : title,
      'ingredients' : ing,
      'description' : description,
      'uploaded' : timestamp
    };
    setBulk('recipes/$recipeID', recipe);
    // Update section if section was changed!
    final sectionIdFromTitle = await getSectionId(sec);
    if (sectionIdFromTitle.toString() != sectionIdFromRecipe.toString()) {
      // Add recipe to new section
      final Object? recipeIdListNew = await get('sections/$sectionIdFromTitle/recipes');
      List<int> currentIdList = [];
      if (recipeIdListNew != null) {
        currentIdList = List<int>.from(recipeIdListNew as List<dynamic>);
      }
      currentIdList.add(recipeID);
      set('sections/$sectionIdFromTitle/recipes', currentIdList);

      // Remove recipe from old section
      final Object? recipeIdListOld = await get('sections/$sectionIdFromRecipe/recipes');
      List<int> oldIdList = [];
      if (recipeIdListOld != null) {
        oldIdList = List<int>.from(recipeIdListNew as List<dynamic>);
      }
      oldIdList.add(recipeID);
      set('sections/$sectionIdFromRecipe/recipes', oldIdList);
    }
  }

  // Specific method to get all the section keys
  Future<List<String>> fetchSections() async {
    List<String> sections = ['recipe category'];
    List<dynamic>? sectionsList = await get('sections') as List<dynamic>;
    if (sectionsList.isEmpty) return sections;
    sectionsList = sectionsList.where((section) => section != null).toList();
    for (var section in sectionsList) {
      sections.add(section['title']);
    }
    return sections;
  }
}
