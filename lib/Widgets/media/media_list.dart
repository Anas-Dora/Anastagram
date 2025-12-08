import 'package:anastagram/Widgets/media/story_images.dart';
import 'package:anastagram/utils/date_formatter.dart';
import 'package:flutter/material.dart';
import 'story_video.dart';
import 'network_video_player.dart';
import '../../utils/dotted_line_painter.dart';

Widget buildMediaList(
  List<Map<String, dynamic>> mediaItems,
  BuildContext context,
) {
  return ListView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemCount: mediaItems.length,
    itemBuilder: (context, index) {
      final item = mediaItems[index];
      final time = item["time"];

      String formattedTime = DateFormatter.formatRelativeDateTime(
        item["time"] ?? '',
      );

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item["type"] == "image")
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StoryImage(image: item["url"]!),
                    ),
                  );
                },
                child: Image.network(item["url"]!),
              ),
            if (item["type"] == "video")
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StoryVideo(video: item["url"]),
                    ),
                  );
                },
                child: NetworkVideoPlayer(url: item["url"]!),
              ),
            if (time != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Zeit: $formattedTime',
                  style: TextStyle(fontSize: 14, color: Color(0xffa0cafd)),
                ),
              ),
            SizedBox(height: 10),
            CustomPaint(
              size: Size(double.infinity, 1),
              painter: DottedLinePainter(),
            ),
          ],
        ),
      );
    },
  );
}
