import 'package:hive/hive.dart';
import '../data/userdata.dart';
import '../data/profile.dart';

class ProfileService {
  final Box<UserData> box = Hive.box<UserData>('userData');

  UserData getUserData() => box.get('mainUser') ?? UserData();

  bool profileExists(String name) {
    return getUserData().profiles.any((p) => p.name == name.trim());
  }

  bool saveProfile(String name) {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty || profileExists(trimmedName)) return false;

    final userData = getUserData();
    userData.profiles.add(Profile(name: trimmedName));
    box.put('mainUser', userData);
    return true;
  }

  bool removeProfile(String name) {
    final trimmedName = name.trim();
    final userData = getUserData();
    if (!profileExists(trimmedName)) return false;

    userData.profiles.removeWhere((p) => p.name == trimmedName);
    box.put('mainUser', userData);
    return true;
  }
}
