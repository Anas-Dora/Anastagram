import 'package:anastagram/Widgets/custom_appbar.dart';
import 'package:anastagram/Widgets/media/media_list.dart';
import 'package:anastagram/Widgets/profile_actions.dart';
import 'package:anastagram/Widgets/profile_header.dart';
import 'package:anastagram/Widgets/profile_stats.dart';
import 'package:anastagram/Widgets/story_tray_list.dart';
import 'package:anastagram/Widgets/user_input_dialog.dart';
import 'package:anastagram/app/theme/app_colors.dart';
import 'package:anastagram/core/models/action_feedback.dart';
import 'package:anastagram/data/story_models.dart';
import 'package:anastagram/features/home/view_models/home_view_model.dart';
import 'package:anastagram/shared/widgets/empty_state.dart';
import 'package:anastagram/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'history_page.dart';
import 'story_viewer_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  Future<void> _showUserInputDialog(BuildContext context, WidgetRef ref) async {
    final profileName = await showDialog<String>(
      context: context,
      builder: (_) => const UserInputDialog(),
    );

    if (profileName == null || profileName.trim().isEmpty) {
      return;
    }

    final feedback = await ref
        .read(homeViewModelProvider.notifier)
        .searchProfile(profileName);

    if (context.mounted) {
      _showFeedback(context, feedback);
    }
  }

  Future<void> _openHistory(BuildContext context, WidgetRef ref) async {
    final selectedUsername = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const HistoryPage()),
    );

    if (selectedUsername == null || selectedUsername.trim().isEmpty) {
      return;
    }

    final feedback = await ref
        .read(homeViewModelProvider.notifier)
        .searchProfile(selectedUsername);

    if (context.mounted) {
      _showFeedback(context, feedback);
    }
  }

  Future<void> _toggleSaved(BuildContext context, WidgetRef ref) async {
    final feedback = await ref.read(homeViewModelProvider.notifier).toggleSaved();
    if (context.mounted) {
      _showFeedback(context, feedback);
    }
  }

  Future<void> _openHighlight(
    BuildContext context,
    WidgetRef ref,
    HighlightStory story,
  ) async {
    final items = await ref
        .read(homeViewModelProvider.notifier)
        .loadHighlightItems(story.id);

    if (!context.mounted) {
      return;
    }

    if (items.isEmpty) {
      SnackbarHelper.show(context, 'Keine Highlight-Daten gefunden.');
      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => StoryViewerPage(highlight: story, highlightItems: items),
      ),
    );
  }

  void _showFeedback(BuildContext context, ActionFeedback? feedback) {
    if (feedback == null) {
      return;
    }

    SnackbarHelper.show(
      context,
      feedback.message,
      backgroundColor: feedback.isError
          ? AppColors.error
          : const Color(0xffe1e2e8),
      textColor: feedback.isError ? Colors.white : const Color(0xff2e3135),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeViewModelProvider);
    final profile = state.profile;

    return Scaffold(
      appBar: CustomAppbar(
        profileImageUrl: profile?.profileImageUrl,
        onOpenHistory: () => _openHistory(context, ref),
        onReset: ref.read(homeViewModelProvider.notifier).reset,
        onDownloadProfileImage: ref
            .read(homeViewModelProvider.notifier)
            .downloadProfileImage,
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 100),
        children: [
          const SizedBox(height: 20),
          ProfileHeader(
            profileImageUrl: profile?.profileImageUrl,
            username: state.username,
          ),
          const SizedBox(height: 16),
          if (state.isLoading)
            const Center(child: CircularProgressIndicator())
          else if (profile == null)
            const EmptyState(
              icon: Icons.search,
              title: 'Suche ein Instagram-Profil',
              subtitle:
                  'Tippe unten rechts auf die Suche und gib einen Benutzernamen ein.',
            )
          else ...[
            ProfileStats(
              stories: profile.storiesCount,
              followers: profile.followers,
              following: profile.following,
            ),
            const SizedBox(height: 20),
            Center(
              child: ProfileActions(
                isSaved: state.isSaved,
                onToggleSaved: () => _toggleSaved(context, ref),
              ),
            ),
            const SizedBox(height: 20),
            if (!profile.isPrivate && profile.highlights.isNotEmpty)
              StoryTrayList(
                stories: profile.highlights,
                onOpenStory: (story) => _openHighlight(context, ref, story),
              ),
            const Divider(color: AppColors.divider, thickness: 2),
            const SizedBox(height: 20),
            if (profile.isPrivate)
              const Text(
                'Dieses Profil ist privat.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.error,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              )
            else if (profile.stories.isEmpty)
              const EmptyState(
                icon: Icons.photo_library_outlined,
                title: 'Keine Story-Medien gefunden',
                subtitle: 'Für dieses Profil wurden aktuell keine Stories geladen.',
              )
            else
              MediaList(mediaItems: profile.stories),
          ],
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showUserInputDialog(context, ref),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.search, color: Color(0xffD1E4FF)),
      ),
    );
  }
}
