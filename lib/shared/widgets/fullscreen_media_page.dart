import 'package:anastagram/Widgets/media/network_video_player.dart';
import 'package:flutter/material.dart';

class FullscreenMediaPage extends StatelessWidget {
  const FullscreenMediaPage.image({
    super.key,
    required this.url,
  }) : isVideo = false;

  const FullscreenMediaPage.video({
    super.key,
    required this.url,
  }) : isVideo = true;

  final String url;
  final bool isVideo;

  @override
  Widget build(BuildContext context) {
    final body = isVideo
        ? Center(child: NetworkVideoPlayer(url: url))
        : InteractiveViewer(child: Image.network(url, fit: BoxFit.contain));

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Center(child: body),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

