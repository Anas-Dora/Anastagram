import 'package:anastagram/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'profile_image.dart';

class ProfileHeader extends StatelessWidget {
  final String? profileImageUrl;
  final String username;

  const ProfileHeader({
    super.key,
    this.profileImageUrl,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    final displayName = username.trim().isEmpty ? '' : username;

    return Column(
      children: [
        Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Color(0xFF194975), width: 5),
          ),
          child: ClipOval(
            child: profileImageUrl == null
                ? Image.asset("images/test.jpg", fit: BoxFit.cover)
                : ProfileImage(profileImage: profileImageUrl!),
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onLongPress: username.trim().isEmpty
              ? null
              : () {
            final data = ClipboardData(text: username);
            Clipboard.setData(data);
            SnackbarHelper.show(context, 'Kopiert');
          },
          child: Text(
            displayName,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: const Color(0xffa0cafd),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
