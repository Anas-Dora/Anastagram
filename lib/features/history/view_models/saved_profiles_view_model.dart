import 'package:anastagram/core/di/providers.dart';
import 'package:anastagram/core/models/action_feedback.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final savedProfilesProvider =
    NotifierProvider<SavedProfilesViewModel, List<String>>(
      SavedProfilesViewModel.new,
    );

class SavedProfilesViewModel extends Notifier<List<String>> {
  @override
  List<String> build() {
    return ref.read(savedProfilesRepositoryProvider).getSavedUsernames();
  }

  Future<ActionFeedback> removeProfile(String username) async {
    await ref.read(savedProfilesRepositoryProvider).removeProfile(username);
    state = ref.read(savedProfilesRepositoryProvider).getSavedUsernames();
    return ActionFeedback('Profil "$username" entfernt.');
  }

  void refresh() {
    state = ref.read(savedProfilesRepositoryProvider).getSavedUsernames();
  }
}

