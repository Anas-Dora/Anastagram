import 'package:anastagram/data/profile.dart';
import 'package:anastagram/data/userdata.dart';
import 'package:hive/hive.dart';

class SavedProfilesRepository {
  SavedProfilesRepository(this._box);

  static const _mainUserKey = 'mainUser';

  final Box<UserData> _box;

  UserData _readUserData() =>
      _box.get(_mainUserKey) ?? UserData(profiles: <Profile>[]);

  List<String> getSavedUsernames() {
    final unique = <String>{
      for (final profile in _readUserData().profiles)
        if ((profile.name ?? '').trim().isNotEmpty) (profile.name ?? '').trim(),
    };

    final usernames = unique.toList()..sort();
    return usernames;
  }

  bool exists(String username) {
    final normalized = username.trim();
    if (normalized.isEmpty) {
      return false;
    }
    return _readUserData().profiles.any((profile) => profile.name == normalized);
  }

  Future<void> saveProfile(String username) async {
    final normalized = username.trim();
    if (normalized.isEmpty) {
      throw StateError('Profilname darf nicht leer sein.');
    }
    if (exists(normalized)) {
      throw StateError('Profil existiert bereits.');
    }

    final userData = _readUserData();
    userData.profiles.add(Profile(name: normalized));
    await _box.put(_mainUserKey, userData);
  }

  Future<void> removeProfile(String username) async {
    final normalized = username.trim();
    if (normalized.isEmpty) {
      throw StateError('Profilname darf nicht leer sein.');
    }

    final userData = _readUserData();
    userData.profiles.removeWhere((profile) => profile.name == normalized);
    await _box.put(_mainUserKey, userData);
  }
}

