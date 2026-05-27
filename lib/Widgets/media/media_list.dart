import 'package:anastagram/data/story_models.dart';
import 'package:anastagram/shared/widgets/fullscreen_media_page.dart';
import 'package:anastagram/utils/date_formatter.dart';
import 'package:flutter/material.dart';
import 'network_video_player.dart';
import '../../utils/dotted_line_painter.dart';

class MediaList extends StatelessWidget {
  const MediaList({super.key, required this.mediaItems});

  final List<MediaItem> mediaItems;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: mediaItems.length,
      itemBuilder: (context, index) {
        final item = mediaItems[index];
        final formattedTime = DateFormatter.formatRelativeDateTime(item.takenAt);

        return Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => item.isVideo
                          ? FullscreenMediaPage.video(url: item.url)
                          : FullscreenMediaPage.image(url: item.url),
                    ),
                  );
                },
                child: item.isVideo
                    ? NetworkVideoPlayer(url: item.url)
                    : Image.network(item.url),
              ),
              if (formattedTime.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Zeit: $formattedTime',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xffa0cafd),
                    ),
                  ),
                ),
              const SizedBox(height: 10),
              CustomPaint(
                size: const Size(double.infinity, 1),
                painter: DottedLinePainter(),
              ),
            ],
          ),
        );
      },
    );
  }
}
