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
                child: Image.network(widget.image, fit: BoxFit.cover),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
