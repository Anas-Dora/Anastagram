import 'package:anastagram/Widgets/profile_image_viewer.dart';
import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  final String profileImage;

  const ProfileImage({super.key, required this.profileImage});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: ((context) => ProfileImageViewer(picture: profileImage)),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(150),
        child: Image.network(profileImage, width: 300),
      ),
    );
  }
}
