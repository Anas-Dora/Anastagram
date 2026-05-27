import 'package:anastagram/data/story_models.dart';

class ProfileOverview {
  const ProfileOverview({
    required this.username,
    required this.profileImageUrl,
    required this.followers,
    required this.following,
    required this.isPrivate,
    required this.stories,
    required this.highlights,
  });

  final String username;
  final String? profileImageUrl;
  final int followers;
  final int following;
  final bool isPrivate;
  final List<MediaItem> stories;
  final List<HighlightStory> highlights;

  int get storiesCount => stories.length;
}

