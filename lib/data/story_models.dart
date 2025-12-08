import 'package:story_view/story_view.dart';

class StoryBundle {
  StoryBundle({
    required this.title,
    required this.avatarUrl,
    required this.storieId,
  });

  final String title;
  final String avatarUrl;
  final String storieId;
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
