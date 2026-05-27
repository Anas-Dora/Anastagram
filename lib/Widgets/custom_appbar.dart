import 'package:anastagram/app/theme/app_colors.dart';
import 'package:anastagram/core/models/action_feedback.dart';
import 'package:flutter/material.dart';

class CustomAppbar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppbar({
    super.key,
    this.profileImageUrl,
    required this.onOpenHistory,
    required this.onReset,
    required this.onDownloadProfileImage,
  });

  final String? profileImageUrl;
  final Future<void> Function() onOpenHistory;
  final VoidCallback onReset;
  final Future<ActionFeedback> Function() onDownloadProfileImage;

  @override
  State<CustomAppbar> createState() => _CustomAppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppbarState extends State<CustomAppbar> {
  bool _isDownloading = false;

  Future<void> _downloadProfileImage() async {
    setState(() => _isDownloading = true);
    final feedback = await widget.onDownloadProfileImage();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(feedback.message),
        backgroundColor:
            feedback.isError ? AppColors.error : AppColors.textPrimary,
      ),
    );

    setState(() => _isDownloading = false);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      shadowColor: Colors.transparent,
      centerTitle: true,
      title: const Text(
        'Anastagram',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
      ),
      leading: IconButton(
        onPressed: widget.onOpenHistory,
        icon: const Icon(Icons.history),
        tooltip: 'Gespeicherte Profile anzeigen',
      ),
      actions: [
        if (widget.profileImageUrl != null) ...[
          IconButton(
            onPressed: _isDownloading ? null : _downloadProfileImage,
            icon: _isDownloading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.download),
            tooltip: 'Profilbild herunterladen',
          ),
          IconButton(
            onPressed: widget.onReset,
            icon: const Icon(Icons.cancel_outlined),
            tooltip: 'Profil zurücksetzen',
          ),
        ],
      ],
    );
  }
}
