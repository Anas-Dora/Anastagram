import 'package:anastagram/core/di/providers.dart';
import 'package:anastagram/core/models/action_feedback.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final savedProfilesProvider =
    NotifierProvider<SavedProfilesViewModel, List<String>>(
      SavedProfilesViewModel.new,
    );

class SavedProfileStatus {
  const SavedProfileStatus({required this.isPrivate, required this.storiesCount});

  final bool? isPrivate;
  final int? storiesCount;
}

final savedProfilesStatusProvider =
    FutureProvider<Map<String, SavedProfileStatus>>((ref) async {
  final usernames = ref.watch(savedProfilesProvider);
  final instagramApi = ref.watch(instagramApiProvider);

  final entries = await Future.wait(
    usernames.map((username) async {
      try {
        final profileOverview = await instagramApi.fetchProfile(username);
        return MapEntry<String, SavedProfileStatus>(
          username,
          SavedProfileStatus(
            isPrivate: profileOverview.isPrivate,
            storiesCount: profileOverview.storiesCount,
          ),
        );
      } catch (_) {
        return MapEntry<String, SavedProfileStatus>(
          username,
          const SavedProfileStatus(isPrivate: null, storiesCount: null),
        );
      }
    }),
  );

  return Map<String, SavedProfileStatus>.fromEntries(entries);
});

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

