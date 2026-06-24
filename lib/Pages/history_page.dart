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
    final statusState = ref.watch(savedProfilesStatusProvider);

    Future<void> deleteProfile(String username) async {
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
    }

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
            )
          : statusState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 12),
                itemCount: profiles.length,
                itemBuilder: (context, index) {
                  final username = profiles[index];
                  return Dismissible(
                    key: ValueKey('history-$username'),
                    direction: DismissDirection.horizontal,
                    background: _deleteBackground(alignment: Alignment.centerLeft),
                    secondaryBackground: _deleteBackground(
                      alignment: Alignment.centerRight,
                    ),
                    onDismissed: (_) {
                      deleteProfile(username);
                    },
                    child: ProfileNameTile(
                      profileName: username,
                      profileImageUrl: null,
                      isPrivate: null,
                      onSelect: () => Navigator.of(context).pop(username),
                    ),
                  );
                },
              ),
              data: (statusMap) => ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 12),
                itemCount: profiles.length,
                itemBuilder: (context, index) {
                  final username = profiles[index];
                  final status = statusMap[username];
                  return Dismissible(
                    key: ValueKey('history-$username'),
                    direction: DismissDirection.horizontal,
                    background: _deleteBackground(alignment: Alignment.centerLeft),
                    secondaryBackground: _deleteBackground(
                      alignment: Alignment.centerRight,
                    ),
                    onDismissed: (_) {
                      deleteProfile(username);
                    },
                    child: ProfileNameTile(
                      profileName: username,
                      profileImageUrl: status?.profileImageUrl,
                      isPrivate: status?.isPrivate,
                      storiesCount: status?.storiesCount,
                      onSelect: () => Navigator.of(context).pop(username),
                    ),
                  );
                },
              ),
            ),
    );
  }
}

Widget _deleteBackground({required Alignment alignment}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    padding: const EdgeInsets.symmetric(horizontal: 20),
    alignment: alignment,
    decoration: BoxDecoration(
      color: Colors.red.shade300,
      borderRadius: BorderRadius.circular(12),
    ),
    child: const Icon(Icons.delete, color: Colors.white),
  );
}

