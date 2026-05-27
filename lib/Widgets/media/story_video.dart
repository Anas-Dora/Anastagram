import 'package:anastagram/shared/widgets/fullscreen_media_page.dart';
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
    return FullscreenMediaPage.video(url: '${widget.video}');
  }
}
