import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:cookbook/util/patch_notes.dart';

class DatabaseService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  final PatchNotes pn = PatchNotes();

  // Method to check if user as newest app version.
  Future<bool> check() async {
    final v = pn.version;
    if (v == await get('version')) {
      return true;
    }
    return false;
  }

  // Method to get data from the database
  Future<Object?> get(String path) async {
    final snapshot = await _dbRef.child(path).get();
    if (snapshot.exists) {
      return snapshot.value;
    }
    return null;
  }

  // Method to update existing tree-data
  Future<String> setBulk(String path, Map<String, dynamic> data) async {
    if (!await check()) {
      return 'Your app does not have the newest version.';
    }
    try {
      await _dbRef.child(path).set(data);
      return 'success';
    } catch (error) {
      return 'Error updating data: $error';
    }
  }

  // Method to update existing data
  Future<String> set(String path, Object? data) async {
    if (!await check()) {
      return 'Your app does not have the newest version.';
    }
    try {
      await _dbRef.child(path).set(data);
      return 'success';
    } catch (error) {
      return 'Error updating data: $error';
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
    final idSnap = await _dbRef.root.child('latestRecipeId').get();
    if (idSnap.exists) {
      return idSnap.value as int;
    }
    return null;
  }

  // Specific method to get latestSectionID
  Future<int?> get idSection async {
    final idSnap = await _dbRef.root.child('latestSectionId').get();
    if (idSnap.exists) {
      return idSnap.value as int;
    }
    return null;
  }

  // Specific method to get latest update timestamp.
  Future<String?> get latestUpdateTime async {
    final snap = await _dbRef.root.child('latestUpdate').get();
    if (snap.exists) {
      return snap.value.toString();
    }
    return null;
  }

  // Specific method to get owner of recipe
  Future<String?> getRecipeOwner (int id) async {
    final snap = await _dbRef.root.child('recipes/$id/owner').get();
    if (snap.exists) {
      return snap.value.toString();
    }
    return null;
  }

  // Specific method to get owner of recipe
  Future<String?> getSectionsOwner (int id) async {
    final snap = await _dbRef.root.child('sections/$id/owner').get();
    if (snap.exists) {
      return snap.value.toString();
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

  // Specific method to get all sections
  Future<DataSnapshot?> get sectionList async{
    final snapshot = await _dbRef.root.child('sections').get();
    if (snapshot.exists) {
      return snapshot; // Initial fetch
    }
    return null;
  }

  // Specific method to get all recipes
  Future<DataSnapshot?> get recipeList async{
    final snapshot = await _dbRef.root.child('recipes').get();
    if (snapshot.exists) {
      return snapshot; // Initial fetch
    }
    return null;
  }

  // Specific method for uploading image
  Future<String> uploadImg(Uint8List image, {required String category, int? id}) async {
    if (!await check()) {
      return 'Your app does not have the newest version.';
    }
    int? idC = id ?? (category == 'recipes' ? await idRecipe : await idSection);
    if (idC != null) {
      Reference ref = FirebaseStorage.instanceFor(bucket: 'gs://felix-s-cookbook.firebasestorage.app').ref().child('$category/$idC}');
      UploadTask uploadTask = ref.putData(image);
      TaskSnapshot snapshot = await uploadTask;
      if (snapshot.state == TaskState.success) {
        return await ref.getDownloadURL();
      } else {
        return 'Upload failed with state: ${snapshot.state}';
      }
    } else {
      return 'Error fetching recipe/section id while trying to upload image.';
    }
  }

  // Specific method for uploading a new recipe.
  Future<String> uploadRecipe({
    required String title,
    required String sec,
    required List<Map<String,String>> ing,
    required String img,
    required String description
  }) async {
    if (!await check()) {
      return 'Your app does not have the newest version.';
    }
    final recipeID = await idRecipe;
    final sectionID = await getSectionId(sec);
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('dd.MM.yyyy HH:mm:ss');
    String timestamp = formatter.format(now);
    User? user = FirebaseAuth.instance.currentUser;
    String userId = user?.uid ?? 'noUserId';
    // Add new recipe
    Map<String, dynamic> recipe = {
      'id' : recipeID,
      'section' : sectionID,
      'imageUrl' : img,
      'title' : title,
      'ingredients' : ing,
      'description' : description,
      'uploaded' : timestamp,
      'owner' : userId
    };
    final results = await Future.wait([
      setBulk('recipes/$recipeID', recipe),
      set('latestRecipeId', recipeID!+1),
    ]);
    // Update section
    final Object? value = await get('sections/$sectionID/recipes');
    List<int> currentIdList = [];
    if (value != null) {
      currentIdList = List<int>.from(value as List<dynamic>);
    }
    currentIdList.add(recipeID);
    results.addAll([
      await set('sections/$sectionID/recipes', currentIdList),
      await set('latestUpdate', timestamp)
    ]);
    // Return for debugging.
    return results.firstWhere((result) => result != 'success', orElse: () => 'success');
  }

  // Specific method for uploading a new section.
  Future<String> uploadSection({required String title, required String img}) async {
    if (!await check()) {
      return 'Your app does not have the newest version.';
    }
    final sectionId = await idSection;
    User? user = FirebaseAuth.instance.currentUser;
    String userId = user?.uid ?? 'noUserId';
    // Add new recipe
    Map<String, dynamic> section = {
      'id' : sectionId,
      'imageUrl' : img,
      'title' : title,
      'owner' : userId,
    };
    // Change update timestamp
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('dd.MM.yyyy HH:mm:ss');
    String timestamp = formatter.format(now);
    // Upload
    final results = await Future.wait([
      setBulk('sections/$sectionId', section),
      set('latestSectionId', sectionId!+1),
      set('latestUpdate', timestamp)
    ]);
    // Return for debugging.
    return results.firstWhere((result) => result != 'success', orElse: () => 'success');
  }

  // Specific method for editing an old recipe.
  Future<String> editRecipe({
    required String title,
    required String sec,
    required List<Map<String,String>> ing,
    required String img,
    required String description,
    required int recipeID
  }) async {
    if (!await check()) {
      return 'Your app does not have the newest version.';
    }
    final sectionIdFromRecipe = await getSectionFromRecipe(recipeID);
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('dd.MM.yyyy HH:mm:ss');
    String timestamp = formatter.format(now);
    User? user = FirebaseAuth.instance.currentUser;
    String userId = user?.uid ?? 'noUserId';
    // Edit old recipe
    Map<String, dynamic> recipe = {
      'id' : recipeID,
      'section' : sectionIdFromRecipe,
      'imageUrl' : img,
      'title' : title,
      'ingredients' : ing,
      'description' : description,
      'uploaded' : timestamp,
      'owner' : userId
    };
    final List<String> results = [];
    results.add(await setBulk('recipes/$recipeID', recipe));
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
      results.add(await set('sections/$sectionIdFromTitle/recipes', currentIdList));

      // Remove recipe from old section
      final Object? recipeIdListOld = await get('sections/$sectionIdFromRecipe/recipes');
      List<int> oldIdList = [];
      if (recipeIdListOld != null) {
        oldIdList = List<int>.from(recipeIdListNew as List<dynamic>);
      }
      oldIdList.add(recipeID);
      results.add(await set('sections/$sectionIdFromRecipe/recipes', oldIdList));
    }
    // Change upload timestamp.
    results.add(await set('latestUpdate', timestamp));
    // Return for debugging.
    return results.firstWhere((result) => result != 'success', orElse: () => 'success');
  }

  // Specific method for editing an old section.
  Future<String> editSection({
    required String title,
    required String img,
    required int sectionId
  }) async {
    if (!await check()) {
      return 'Your app does not have the newest version.';
    }
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('dd.MM.yyyy HH:mm:ss');
    String timestamp = formatter.format(now);
    User? user = FirebaseAuth.instance.currentUser;
    String userId = user?.uid ?? 'noUserId';
    // Edit old section
    final results = await Future.wait([
      set('sections/$sectionId/title', title),
      set('sections/$sectionId/imageUrl', img),
      set('sections/$sectionId/owner', userId),
      set('sections/$sectionId/uploaded', timestamp),
      // Change update timestamp.
      set('latestUpdate', timestamp)
    ]);
    return results.firstWhere((result) => result != 'success', orElse: () => 'success');
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
