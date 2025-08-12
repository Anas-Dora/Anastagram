import 'package:flutter/material.dart';

class ProfileActions extends StatelessWidget {
  final bool isSaved;
  final String saveText;
  final VoidCallback onSave;
  final VoidCallback onUnsave;

  const ProfileActions({
    super.key,
    required this.isSaved,
    required this.saveText,
    required this.onSave,
    required this.onUnsave,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: isSaved ? onUnsave : onSave,
      icon: Icon(
        isSaved ? Icons.bookmark : Icons.bookmark_border,
        color: Color(0xff003258),
      ),
      label: Text(saveText, style: TextStyle(color: Color(0xff003258))),
      style: ElevatedButton.styleFrom(backgroundColor: Color(0xffa0cafd)),
    );
  }
}
