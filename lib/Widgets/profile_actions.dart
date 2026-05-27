import 'package:flutter/material.dart';

class ProfileActions extends StatelessWidget {
  final bool isSaved;
  final VoidCallback onToggleSaved;

  const ProfileActions({
    super.key,
    required this.isSaved,
    required this.onToggleSaved,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onToggleSaved,
      icon: Icon(
        isSaved ? Icons.bookmark : Icons.bookmark_border,
        color: const Color(0xff003258),
      ),
      label: Text(
        isSaved ? 'Gespeichert' : 'Speichern',
        style: const TextStyle(color: Color(0xff003258)),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xffa0cafd),
      ),
    );
  }
}
