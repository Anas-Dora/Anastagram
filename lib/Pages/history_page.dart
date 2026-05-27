import 'package:anastagram/Widgets/profile_name_tile.dart';
import 'package:anastagram/app/theme/app_colors.dart';
import 'package:anastagram/features/history/view_models/saved_profiles_view_model.dart';
import 'package:anastagram/shared/widgets/empty_state.dart';
import 'package:anastagram/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profiles = ref.watch(savedProfilesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gespeicherte Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: profiles.isEmpty
          ? const EmptyState(
              icon: Icons.bookmarks_outlined,
              title: 'Keine gespeicherten Profile',
              subtitle:
                  'Speichere ein Profil auf der Startseite, um es hier wiederzufinden.',
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: profiles.length,
              itemBuilder: (context, index) {
                final username = profiles[index];
                return ProfileNameTile(
                  profileName: username,
                  onSelect: () => Navigator.of(context).pop(username),
                  onDelete: () async {
                    final feedback = await ref
                        .read(savedProfilesProvider.notifier)
                        .removeProfile(username);

                    if (!context.mounted) {
                      return;
                    }

                    SnackbarHelper.show(
                      context,
                      feedback.message,
                      backgroundColor: AppColors.textPrimary,
                      textColor: const Color(0xff2e3135),
                    );
                  },
                );
              },
            ),
    );
  }
}
