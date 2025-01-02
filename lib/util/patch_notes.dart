class PatchNotes {
  final String _version = 'v1.1.4';
  final String _patchNotes = 'In patch 1.1.4 we updated the UI and usability by assigning a standardized color theme for all features. In addition, navigation bugs were eliminated and the quality of animations increased. Furthermore, we reworked the database connection, allowing for listening to changes, but not maintaining a constant open connection. All changes to the database will be reflected in the app in a timely fashion - refreshes can be forced by pressing the home button. In addition, we updated the navigation logic in the drawer and added a soon-to-be-released feature: The grocery list. More on that on the next patch. ;) \n\nFelix';

  String get version => _version;
  String get patchNotes => _patchNotes;
}