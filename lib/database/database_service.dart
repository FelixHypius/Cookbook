import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

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

  // Method to create new data
  Future<void> create(String path, Map<String, dynamic> data) async {
    try {
      await _dbRef.child(path).set(data);
      print('Data created successfully at $path');
    } catch (error) {
      print('Error creating data: $error');
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
  Future<String?> uploadImg(File file) async {
    Reference ref = FirebaseStorage.instanceFor(bucket: 'gs://felix-s-cookbook.firebasestorage.app').ref().child('recipes/${await idRecipe}.jpg');
    UploadTask uploadTask = ref.putFile(file);
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
    // Add new recipe
    Map<String, dynamic> recipe = {
      'id' : recipeID,
      'section' : sectionID,
      'imageUrl' : img,
      'title' : title,
      'ingredients' : ing,
      'description' : description
    };
    create('recipes/$recipeID', recipe);
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
    create('sections/$sectionID', section);
    // Increase id counter
    set('latestSection', sectionID!+1);
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
