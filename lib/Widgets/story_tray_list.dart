import 'package:anastagram/Pages/story_viewer_page.dart';
import 'package:anastagram/Widgets/story_tray.dart';
import 'package:anastagram/data/story_models.dart';
import 'package:flutter/material.dart';

class StoryTrayList extends StatelessWidget {
  final List<StoryBundle> stories;

  const StoryTrayList({super.key, required this.stories});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        scrollDirection: Axis.horizontal,
        itemCount: stories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final s = stories[index];
          return StoryTray(
            avatarUrl: s.avatarUrl,
            label: s.title,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => StoryViewerPage(bundle: s)),
              );
            },
          );
        },
      ),
    );
  }
}
