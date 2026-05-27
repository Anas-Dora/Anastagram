import 'package:anastagram/data/story_models.dart';
import 'package:anastagram/utils/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/utils.dart';
import 'package:story_view/widgets/story_view.dart';

class StoryViewerPage extends StatefulWidget {
  const StoryViewerPage({
    super.key,
    required this.highlight,
    required this.highlightItems,
  });

  final HighlightStory highlight;
  final List<MediaItem> highlightItems;

  @override
  State<StoryViewerPage> createState() => _StoryViewerPageState();
}

class _StoryViewerPageState extends State<StoryViewerPage> {
  final StoryController _controller = StoryController();
  ValueNotifier<int> currentIndex = ValueNotifier(0);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.highlightItems.toList(growable: false);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            StoryView(
              storyItems: items.map((item) {
                final url = item.url;

                if (item.isVideo) {
                  return StoryItem.pageVideo(
                    url,
                    controller: _controller,
                    duration: const Duration(seconds: 10),
                  );
                } else {
                  return StoryItem.pageImage(
                    url: url,
                    controller: _controller,
                    duration: const Duration(seconds: 5),
                  );
                }
              }).toList(),
              controller: _controller,
              onStoryShow: (storyItem, index) {
                currentIndex.value = index;
              },
              onComplete: () => Navigator.of(context).maybePop(),
              onVerticalSwipeComplete: (direction) {
                if (direction == Direction.down) {
                  Navigator.of(context).maybePop();
                }
              },
            ),
            Positioned(
              left: 12,
              right: 12,
              top: 10,
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.highlight.avatarUrl),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.highlight.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        ValueListenableBuilder<int>(
                          valueListenable: currentIndex,
                          builder: (_, index, __) {
                            return Text(
                              items.isNotEmpty
                                  ? DateFormatter.extractDate(
                                      items[index].takenAt,
                                    )
                                  : '',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
