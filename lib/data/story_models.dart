import 'package:story_view/story_view.dart';

class StoryBundle {
  StoryBundle({
    required this.title,
    required this.avatarUrl,
    required this.items,
  });

  final String title;
  final String avatarUrl;
  final List<StoryItemData> items;
}

sealed class StoryItemData {
  StoryItem toStoryItem(StoryController controller);
}

class StoryImage extends StoryItemData {
  StoryImage({required this.url});
  final String url;

  @override
  StoryItem toStoryItem(StoryController controller) {
    return StoryItem.pageImage(
      url: url,
      controller: controller,
      duration: const Duration(seconds: 5),
    );
  }
}

class StoryVideo extends StoryItemData {
  StoryVideo({required this.url});
  final String url;

  @override
  StoryItem toStoryItem(StoryController controller) {
    return StoryItem.pageVideo(url, controller: controller);
  }
}
