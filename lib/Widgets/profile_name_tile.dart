import 'package:anastagram/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileNameTile extends StatelessWidget {
  const ProfileNameTile({
    super.key,
    required this.profileName,
    required this.onSelect,
    this.profileImageUrl,
    this.isPrivate,
    this.storiesCount,
  });

  final String profileName;
  final VoidCallback onSelect;
  final String? profileImageUrl;
  final bool? isPrivate;
  final int? storiesCount;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: const Color(0xFFa0cafd),
      child: ListTile(
        onTap: onSelect,
        onLongPress: () {
          Clipboard.setData(ClipboardData(text: profileName));
          SnackbarHelper.show(context, 'Kopiert');
        },
        leading: _Avatar(profileImageUrl: profileImageUrl),
        title: Text(
          profileName,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xff194975),
          ),
        ),
        trailing: Row(
          spacing: 4,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isPrivate == false && (storiesCount ?? 0) > 0)
              Text(
                '${storiesCount ?? 0}',
                style: const TextStyle(
                  color: Color(0xff194975),
                  fontWeight: FontWeight.w600,
                  fontSize: 26,
                ),
              ),
            const SizedBox(width: 12),
            // Lock icon showing privacy status
            if (isPrivate != null)
              Tooltip(
                message: isPrivate! ? 'Privates Konto' : 'Öffentliches Konto',
                child: Center(
                  child: Icon(
                    isPrivate! ? Icons.lock : Icons.lock_open,
                    color: const Color(0xff194975),
                    size: 24,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.profileImageUrl});

  final String? profileImageUrl;

  @override
  Widget build(BuildContext context) {
    final imageUrl = profileImageUrl;

    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xff194975), width: 1.2),
      ),
      child: ClipOval(
        child: imageUrl == null || imageUrl.isEmpty
            ? const Icon(Icons.person, color: Color(0xff194975), size: 24)
            : Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.person,
                  color: Color(0xff194975),
                  size: 24,
                ),
              ),
      ),
    );
  }
}
