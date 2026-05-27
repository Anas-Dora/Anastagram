enum MediaType { image, video }

class HighlightStory {
  const HighlightStory({
    required this.title,
    required this.avatarUrl,
    required this.id,
  });

  final String title;
  final String avatarUrl;
  final String id;
}

class MediaItem {
  const MediaItem({
    required this.type,
    required this.url,
    this.takenAt,
  });

  final MediaType type;
  final String url;
  final DateTime? takenAt;

  bool get isVideo => type == MediaType.video;
  bool get isImage => type == MediaType.image;
}
