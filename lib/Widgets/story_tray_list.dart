import 'package:anastagram/Widgets/story_tray.dart';
import 'package:anastagram/data/story_models.dart';
import 'package:flutter/material.dart';

class StoryTrayList extends StatelessWidget {
  final List<HighlightStory> stories;
  final Future<void> Function(HighlightStory story) onOpenStory;

  const StoryTrayList({
    super.key,
    required this.stories,
    required this.onOpenStory,
  });

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
            onTapAsync: () => onOpenStory(s),
          );
        },
      ),
    );
  }
}
