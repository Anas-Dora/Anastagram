import 'package:anastagram/shared/widgets/fullscreen_media_page.dart';
import 'package:flutter/material.dart';

class ProfileImageViewer extends StatefulWidget {
  final String picture;

  const ProfileImageViewer({super.key, required this.picture});

  @override
  State<ProfileImageViewer> createState() => _ProfileImageViewerState();
}

class _ProfileImageViewerState extends State<ProfileImageViewer> {
  @override
  Widget build(BuildContext context) {
    return FullscreenMediaPage.image(url: widget.picture);
  }
}
