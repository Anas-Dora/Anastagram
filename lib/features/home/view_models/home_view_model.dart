import 'package:anastagram/core/di/providers.dart';
import 'package:anastagram/core/exceptions/app_exceptions.dart';
import 'package:anastagram/core/models/action_feedback.dart';
import 'package:anastagram/data/story_models.dart';
import 'package:anastagram/features/history/view_models/saved_profiles_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'home_ui_state.dart';

final homeViewModelProvider =
    NotifierProvider<HomeViewModel, HomeUiState>(HomeViewModel.new);

class HomeViewModel extends Notifier<HomeUiState> {
  @override
  HomeUiState build() => HomeUiState.initial();

  Future<ActionFeedback?> searchProfile(String rawUsername) async {
    final username = rawUsername.trim();
    if (username.isEmpty) {
      return const ActionFeedback(
        'Profilname darf nicht leer sein.',
        isError: true,
      );
    }

    state = state.copyWith(
      username: username,
      isLoading: true,
      isSaved: false,
      clearProfile: true,
    );

    try {
      final profile = await ref.read(instagramApiProvider).fetchProfile(username);
      final isSaved = ref.read(savedProfilesRepositoryProvider).exists(username);

      state = state.copyWith(
        username: username,
        profile: profile,
        isLoading: false,
        isSaved: isSaved,
      );
      return null;
    } on AppException catch (error) {
      state = state.copyWith(
        username: username,
        isLoading: false,
        isSaved: false,
        clearProfile: true,
      );
      return ActionFeedback(error.message, isError: true);
    } catch (error) {
      state = state.copyWith(
        username: username,
        isLoading: false,
        isSaved: false,
        clearProfile: true,
      );
      return ActionFeedback('Unerwarteter Fehler: $error', isError: true);
    }
  }

  Future<ActionFeedback> toggleSaved() async {
    final username = state.username.trim();
    if (username.isEmpty) {
      return const ActionFeedback(
        'Es ist noch kein Profil geladen.',
        isError: true,
      );
    }

    final repository = ref.read(savedProfilesRepositoryProvider);

    try {
      if (state.isSaved) {
        await repository.removeProfile(username);
        state = state.copyWith(isSaved: false);
        ref.read(savedProfilesProvider.notifier).refresh();
        return ActionFeedback('Profil "$username" entfernt.');
      }

      await repository.saveProfile(username);
      state = state.copyWith(isSaved: true);
      ref.read(savedProfilesProvider.notifier).refresh();
      return ActionFeedback('Profil "$username" gespeichert.');
    } on AppException catch (error) {
      return ActionFeedback(error.message, isError: true);
    } catch (error) {
      return ActionFeedback('Fehler beim Speichern: $error', isError: true);
    }
  }

  Future<ActionFeedback> downloadProfileImage() async {
    final imageUrl = state.profile?.profileImageUrl;
    if (imageUrl == null || imageUrl.isEmpty) {
      return const ActionFeedback(
        'Kein Profilbild verfügbar.',
        isError: true,
      );
    }

    try {
      return await ref.read(mediaDownloadServiceProvider).saveImageFromUrl(imageUrl);
    } on AppException catch (error) {
      return ActionFeedback(error.message, isError: true);
    }
  }

  Future<List<MediaItem>> loadHighlightItems(String highlightId) {
    return ref.read(instagramApiProvider).fetchHighlightItems(highlightId);
  }

  void reset() {
    state = HomeUiState.initial();
  }
}
