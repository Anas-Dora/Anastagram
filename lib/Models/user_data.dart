import 'package:flutter/material.dart';

import 'profile.dart';

class UserData extends ChangeNotifier {
  List<Profile> profiles = [];

  void deleteProfile(Profile profile) {
    profiles.remove(profile);
    notifyListeners();
  }
}
