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
                child: Image.network(widget.picture, fit: BoxFit.cover),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
