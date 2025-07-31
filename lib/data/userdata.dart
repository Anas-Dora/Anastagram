import 'package:hive/hive.dart';
import 'profile.dart';

part 'userdata.g.dart';

@HiveType(typeId: 1)
class UserData {
  @HiveField(0)
  List<Profile> profiles;

  UserData({List<Profile>? profiles}) : profiles = profiles ?? [];
}
