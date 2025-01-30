import 'package:anastagram/Models/NetworkVideoPlayer.dart';
import 'package:flutter/material.dart';

class StoryVideos extends StatefulWidget {
  final String? video;

  const StoryVideos({super.key, required this.video});

  @override
  State<StoryVideos> createState() => _StoryVideosState();
}

class _StoryVideosState extends State<StoryVideos> {
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
