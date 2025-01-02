import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'local_database_service.dart';
import 'database_service.dart';

class DataSyncService {
  final LocalDatabaseService localDatabaseService = LocalDatabaseService();
  final DatabaseService databaseService = DatabaseService();
  final DateFormat format = DateFormat('dd.MM.yyyy HH:mm:ss');
  final StreamController<List<dynamic>?> _controller = StreamController<List<dynamic>?>();
  late int secId;

  DataSyncService();

  Stream<List<dynamic>?> get stream => _controller.stream;

  void setSecId(int id) {
    secId = id;
  }

  DateTime parseDateTime(String? dateString) {
    try {
      if (dateString != null && dateString.isNotEmpty) {
        return format.parse(dateString);
      } else {
        throw Exception('Date string is null or empty.');
      }
    } catch (e) {
      throw Exception('Error parsing DateTime: $e');
    }
  }

  Future<void> fetchAndListenSections() async {
    // Check if there is local data available.
    final DatabaseReference ref = FirebaseDatabase.instance.ref();
    ref.root.child('latestUpdate').onValue.listen((event) async {
      final latestOnline = event.snapshot.value.toString();
      final latestLocal = await localDatabaseService.getTimeStamp();
      bool needSync = false;

      if (latestLocal != null) {
        final DateTime local = format.parse(latestLocal);
        final DateTime online = parseDateTime(latestOnline);
        // Check if database timestamp is younger than local timestamp.
        if (online.isAfter(local)) {
          needSync = true; // Sync required
        } else {
          _controller.add(await localDatabaseService.getSectionsData());
        }
      } else {
        needSync = true; // Sync required if no local data
      }

      if (needSync) {
        try {
          // Fetch data
          final sectionSnap = await databaseService.sectionList;
          final recipeSnap = await databaseService.recipeList;
          // Save data
          if (sectionSnap != null) {
            await localDatabaseService.setSectionsData(sectionSnap, latestOnline);
          }
          if (recipeSnap != null) {
            await localDatabaseService.setRecipesData(recipeSnap, latestOnline);
          }
          // Stream data
          List<dynamic>? data = sectionSnap != null ? sectionSnap.value as List<dynamic> : null;
          _controller.add(data);
        } catch (e) {
          _controller.addError(e);
        }
      }
    });

  }

  Future<void> fetchAndListenRecipes() async {
    final DatabaseReference ref = FirebaseDatabase.instance.ref();
    ref.root.child('latestUpdate').onValue.listen((event) async {
      final latestOnline = event.snapshot.value.toString();
      // Check if there is local data available.
      final latestLocal = await localDatabaseService.getTimeStamp();
      bool needSync = false;

      if (latestLocal != null) {
        final DateTime local = format.parse(latestLocal);
        final DateTime online = parseDateTime(latestOnline);
        // Check if database timestamp is younger than local timestamp.
        if (online.isAfter(local)) {
          needSync = true; // Sync required
        } else {
          _controller.add(await localDatabaseService.getRecipesDataBySection(secId));
        }
      } else {
        needSync = true; // Sync required if no local data
      }

      if (needSync) {
        try {
          // Fetch data
          final sectionSnap = await databaseService.sectionList;
          final recipeSnap = await databaseService.recipeList;
          // Save data
          if (sectionSnap != null) {
            await localDatabaseService.setSectionsData(sectionSnap, latestOnline);
          }
          if (recipeSnap != null) {
            await localDatabaseService.setRecipesData(recipeSnap, latestOnline);
          }
          // Stream data
          List<dynamic>? data;
          if (recipeSnap != null) {
            data = recipeSnap.value as List<dynamic>;
            data = data.where((recipe) => recipe['section'] == secId).toList();
          }
          _controller.add(data);
        } catch (e) {
          _controller.addError(e);
        }
      }
    });
  }

  Future<void> fetchAndListenRecipeList() async {
    // Check if there is local data available.
    final latestLocal = await localDatabaseService.getTimeStamp();
    final latestOnline = await databaseService.latestUpdateTime;
    bool needSync = false;

    if (latestLocal != null) {
      final DateTime local = format.parse(latestLocal);
      final DateTime online = parseDateTime(latestOnline);
      // Check if database timestamp is younger than local timestamp.
      if (online.isAfter(local)) {
        needSync = true; // Sync required
      } else {
        List<dynamic>? localData;
        List<dynamic>? selectionL = await localDatabaseService.selectionList;
        if (selectionL != null && selectionL.isNotEmpty) {
          // Filter and add 'qty' attribute to recipes
          localData = await localDatabaseService.recipeList;
          if (localData != null) {
            for (var recipe in localData) {
              for (var selection in selectionL) {
                if (recipe['id'] == selection['id']) {
                  recipe['qty'] = selection['qty'];
                }
              }
            }
            // Remove recipes that are not in the list.
            localData.removeWhere((recipe) => !recipe.containsKey('qty'));
          } else {
            localData = null;
          }
        } else {
          localData = null;
        }
        _controller.add(localData);
      }
    } else {
      needSync = true; // Sync required if no local data
    }

    if (needSync) {
      try {
        // Fetch data
        final sectionSnap = await databaseService.sectionList;
        final recipeSnap = await databaseService.recipeList;
        // Save data
        if (sectionSnap != null) {
          await localDatabaseService.setSectionsData(sectionSnap, latestOnline ?? DateTime.now().toString());
        }
        if (recipeSnap != null) {
          await localDatabaseService.setRecipesData(recipeSnap, latestOnline ?? DateTime.now().toString());
        }
        // Stream data
        List<dynamic>? data;
        if (recipeSnap != null) {
          data = recipeSnap.value as List<dynamic>;
          List<dynamic>? selectionL = await localDatabaseService.selectionList;
          if (selectionL != null && selectionL.isNotEmpty) {
            // Filter and add 'qty' attribute to recipes
            for (var recipe in data) {
              for (var selection in selectionL) {
                if (recipe['id'] == selection['id']) {
                  recipe['qty'] = selection['qty'];
                }
              }
            }
            // Remove recipes that are not in the list.
            data.removeWhere((recipe) => !recipe.containsKey('qty'));
          } else {
            data = null;
          }
        }
        _controller.add(data);
      } catch (e) {
        _controller.addError(e);
      }
    }
  }

  void dispose() {
    _controller.close();
  }
}
