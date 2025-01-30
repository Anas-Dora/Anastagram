import 'package:flutter/material.dart';

class StoryImages extends StatefulWidget {
  final String image;

  const StoryImages({super.key, required this.image});

  @override
  State<StoryImages> createState() => _StoryImagesState();
}

class _StoryImagesState extends State<StoryImages> {
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
