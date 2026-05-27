import 'package:anastagram/shared/widgets/fullscreen_media_page.dart';
import 'package:flutter/material.dart';

class StoryImage extends StatefulWidget {
  final String image;

  const StoryImage({super.key, required this.image});

  @override
  State<StoryImage> createState() => _StoryImageState();
}

class _StoryImageState extends State<StoryImage> {
  @override
  Widget build(BuildContext context) {
    return FullscreenMediaPage.image(url: widget.image);
  }
}
