import 'package:anastagram/Widgets/media/network_video_player.dart';
import 'package:flutter/material.dart';

class StoryVideo extends StatefulWidget {
  final String? video;

  const StoryVideo({super.key, required this.video});

  @override
  State<StoryVideo> createState() => _StoryVideoState();
}

class _StoryVideoState extends State<StoryVideo> {
  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: NetworkVideoPlayer(url: '${widget.video}'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
