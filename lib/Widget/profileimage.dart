// ignore_for_file: public_member_api_docs, sort_constructors_first, use_key_in_widget_constructors, must_be_immutable
import 'package:anastagram/Widget/pp.dart';
import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  String profileImage;

  ProfileImage({super.key, required this.profileImage});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder:
                    ((context) => ProfilePicture(profilePicture: profileImage)),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(150),
            child: Image.network(profileImage, width: 300),
          ),
        ),
      ],
    );
  }
}
