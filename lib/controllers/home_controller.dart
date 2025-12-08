import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../data/userdata.dart';
import '../services/profile_service.dart';
import '../data/instagram_api.dart';
import '../utils/snackbar_helper.dart';

class HomeController {
  final instagramApi = InstagramApi();
  final profileService = ProfileService();

  Future<void> fetchUserDetails(
    String username,
    Function(
      String? picUrl,
      int followers,
      int following,
      int itemsCount,
      List<Map<String, String>> storieItems,
      List<String> highlightsTitles,
      List<String> highlightsAvatar,
      List<String> highlightsId,
      bool isPrivate,
    )
    onDataLoaded,
  ) async {
    await instagramApi.getApi(username);

    onDataLoaded(
      instagramApi.picURL,
      instagramApi.followers ?? 0,
      instagramApi.following ?? 0,
      instagramApi.itemsCount ?? 0,
      instagramApi.storieItems,
      instagramApi.highlightsTitel,
      instagramApi.highlightsAvatarUrl,
      instagramApi.highlightsId,
      instagramApi.isPrivate ?? false,
    );
  }

  void saveProfile(String username, BuildContext context, Function onSaved) {
    if (username.isEmpty) {
      SnackbarHelper.show(context, 'Profilname darf nicht leer sein.');
      return;
    }

    if (profileService.profileExists(username)) {
      SnackbarHelper.show(context, 'Profil existiert bereits.');
      return;
    }

    if (profileService.saveProfile(username)) {
      SnackbarHelper.show(
        context,
        'Profil "$username" erfolgreich gespeichert!',
      );
      onSaved();
    } else {
      SnackbarHelper.show(context, 'Fehler beim Speichern.');
    }
  }

  void unSaveProfile(
    String username,
    BuildContext context,
    Function onRemoved,
  ) {
    if (username.isEmpty) {
      SnackbarHelper.show(context, 'Profilname darf nicht leer sein.');
      return;
    }

    if (!profileService.profileExists(username)) {
      SnackbarHelper.show(context, 'Profil nicht gespeichert.');
      return;
    }

    if (profileService.removeProfile(username)) {
      SnackbarHelper.show(context, 'Profil "$username" entfernt!');
      onRemoved();
    }
  }

  bool isProfileSaved(String username) {
    final box = Hive.box<UserData>('userData');
    UserData? userData = box.get('mainUser') ?? UserData();
    return userData.profiles.any((p) => p.name == username);
  }
}
