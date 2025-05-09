// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import '../Pages/history.dart';

class CustomizedAppbar extends StatefulWidget implements PreferredSizeWidget {
  final String? profileImageUrl;
  final String? username;
  VoidCallback resetValues;

  CustomizedAppbar({
    super.key,
    this.profileImageUrl,
    this.username,
    required this.resetValues,
  });

  @override
  State<CustomizedAppbar> createState() => _CustomizedAppbarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _CustomizedAppbarState extends State<CustomizedAppbar> {
  bool isDownloading = false;
  String downloadProgress = "";

  /*
   _downloadImage(String imageUrl) async {
    var response = await Dio().get(
        imageUrl,
        options: Options(responseType: ResponseType.bytes));
    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 60,
        name: "hello");
    print(result);
  }
*/
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
              builder:
                  (context) => SearchHistory(
                    pPicture: widget.profileImageUrl,
                    userName: widget.username,
                  ),
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
                onPressed: () async {
                  //_downloadImage(widget.profileImageUrl!);
                },
                icon: const Icon(Icons.download, color: Color(0xFFe1e2e8)),
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
