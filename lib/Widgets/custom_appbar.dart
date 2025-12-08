import 'dart:typed_data';
import 'package:anastagram/Pages/history_page.dart';
import 'package:anastagram/utils/app_logger.dart';
import 'package:anastagram/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';

class CustomAppbar extends StatefulWidget implements PreferredSizeWidget {
  final String? profileImageUrl;
  final String? username;
  final VoidCallback resetValues;

  const CustomAppbar({
    super.key,
    this.profileImageUrl,
    this.username,
    required this.resetValues,
  });

  @override
  State<CustomAppbar> createState() => _CustomAppbarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _CustomAppbarState extends State<CustomAppbar> {
  bool isDownloading = false;

  Future<void> _downloadImage(String imageUrl) async {
    // 1. Berechtigung anfragen
    var status = await Permission.photos.request();
    if (status.isDenied) {
      status = await Permission.storage.request();
    }

    if (!status.isGranted) {
      if (!mounted) return;
      SnackbarHelper.show(context, "Speicherberechtigung verweigert");
      setState(() => isDownloading = false);
      return;
    }

    try {
      // Bild herunterladen
      var response = await Dio().get(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      // In Galerie speichern
      await ImageGallerySaverPlus.saveImage(
        Uint8List.fromList(response.data),
        quality: 80,
        name: "anastagram_profile_${DateTime.now().millisecondsSinceEpoch}",
      );

      if (!mounted) return;
      SnackbarHelper.show(context, "Bild gespeichert");
    } catch (e) {
      AppLogger.e("Fehler beim Herunterladen des Bildes: ", e);
    }
    setState(() => isDownloading = false);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xff272a2f),
      elevation: 0,
      shadowColor: Colors.transparent,
      centerTitle: true,
      title: Text(
        "Anastagram",
        style: TextStyle(
          color: Color(0xFFe1e2e8),
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => HistoryPage(userName: widget.username),
            ),
          );
        },
        icon: Icon(Icons.history, color: Color(0xFFe1e2e8)),
        tooltip: "Suchverlauf anzeigen",
      ),
      actions: [
        if (widget.profileImageUrl != null)
          Row(
            children: [
              IconButton(
                onPressed: isDownloading
                    ? null
                    : () async {
                        if (widget.profileImageUrl != null) {
                          await _downloadImage(widget.profileImageUrl!);
                        }
                      },
                icon: isDownloading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.download, color: Color(0xFFe1e2e8)),
                tooltip: "Profilbild herunterladen",
              ),
              IconButton(
                onPressed: widget.resetValues,
                icon: const Icon(
                  Icons.cancel_outlined,
                  color: Color(0xFFe1e2e8),
                ),
                tooltip: "Profil zurücksetzen",
              ),
            ],
          ),
      ],
    );
  }
}
