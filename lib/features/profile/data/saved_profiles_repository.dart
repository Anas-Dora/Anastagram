import 'package:anastagram/core/exceptions/app_exceptions.dart';
import 'package:anastagram/data/profile.dart';
import 'package:anastagram/data/userdata.dart';
import 'package:hive/hive.dart';

class SavedProfilesRepository {
  SavedProfilesRepository(this._box);

  static const _mainUserKey = 'mainUser';

  final Box<UserData> _box;

  UserData _readUserData() {
    try {
      return _box.get(_mainUserKey) ?? UserData(profiles: <Profile>[]);
    } catch (e) {
      throw StorageException('Konnte Profile nicht laden: $e');
    }
  }

  List<String> getSavedUsernames() {
    try {
      final unique = <String>{
        for (final profile in _readUserData().profiles)
          if ((profile.name ?? '').trim().isNotEmpty) (profile.name ?? '').trim(),
      };

      final usernames = unique.toList()..sort();
      return usernames;
    } catch (e) {
      throw StorageException('Konnte gespeicherte Benutzernamen nicht abrufen: $e');
    }
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
      throw ValidationException('Benutzername darf nicht leer sein.');
    }
    if (exists(normalized)) {
      throw ValidationException('Profil existiert bereits.');
    }

    try {
      final userData = _readUserData();
      userData.profiles.add(Profile(name: normalized));
      await _box.put(_mainUserKey, userData);
    } catch (e) {
      throw StorageException('Konnte Profil nicht speichern: $e');
    }
  }

  Future<void> removeProfile(String username) async {
    final normalized = username.trim();
    if (normalized.isEmpty) {
      throw ValidationException('Benutzername darf nicht leer sein.');
    }

    try {
      final userData = _readUserData();
      userData.profiles.removeWhere((profile) => profile.name == normalized);
      await _box.put(_mainUserKey, userData);
    } catch (e) {
      throw StorageException('Konnte Profil nicht entfernen: $e');
    }
  }
}
