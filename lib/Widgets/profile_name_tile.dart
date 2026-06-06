import 'package:anastagram/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileNameTile extends StatelessWidget {
  const ProfileNameTile({
    super.key,
    required this.profileName,
    required this.onSelect,
    required this.onDelete,
    this.isPrivate,
  });

  final String profileName;
  final VoidCallback onSelect;
  final VoidCallback onDelete;
  final bool? isPrivate;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: const Color(0xFFa0cafd),
      child: ListTile(
        onTap: onSelect,
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
            SizedBox(width: 8),
            IconButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: profileName));
                SnackbarHelper.show(context, 'Kopiert');
              },
              icon: const Icon(Icons.copy, color: Color(0xff194975)),
              tooltip: 'Benutzernamen kopieren',
            ),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline, color: Color(0xff194975)),
              tooltip: 'Profil entfernen',
            ),
          ],
        ),
      ),
    );
  }
}
