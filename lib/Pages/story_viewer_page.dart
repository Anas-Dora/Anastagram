import 'package:anastagram/data/story_models.dart';
import 'package:anastagram/utils/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/utils.dart';
import 'package:story_view/widgets/story_view.dart';

class StoryViewerPage extends StatefulWidget {
  const StoryViewerPage({
    super.key,
    required this.bundle,
    required this.highlightItems,
  });
  final StoryBundle bundle;
  final List<Map<String, String>> highlightItems;

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
    final highlightsTime = widget.highlightItems
        .map((item) => item['time'] ?? '')
        .toList(growable: false);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            StoryView(
              storyItems: items.map((item) {
                final type = item['type'];
                final url = item['url'] ?? '';

                if (type == 'video') {
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
                    backgroundImage: NetworkImage(widget.bundle.avatarUrl),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.bundle.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        ValueListenableBuilder<int>(
                          valueListenable: currentIndex,
                          builder: (_, index, __) {
                            return Text(
                              highlightsTime.isNotEmpty
                                  ? DateFormatter.extractDate(
                                      highlightsTime[index],
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
