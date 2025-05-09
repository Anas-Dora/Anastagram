// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class ProfilePicture extends StatefulWidget {
  final profilePicture;

  const ProfilePicture({super.key, required this.profilePicture});

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
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
                child: Image.network(
                  "${widget.profilePicture}",
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
