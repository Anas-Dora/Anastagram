// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'package:anastagram/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileNameTile extends StatefulWidget {
  final profileName;
  final void Function()? deleteProfile;

  const ProfileNameTile({super.key, this.profileName, this.deleteProfile});

  @override
  State<ProfileNameTile> createState() => _ProfileNameTileState();
}

class _ProfileNameTileState extends State<ProfileNameTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              final data = ClipboardData(text: widget.profileName);
              Clipboard.setData(data);
              SnackbarHelper.show(context, 'Kopiert');
            },
            onLongPress: () {
              setState(() {
                widget.deleteProfile!();
              });
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                color: Color(0xFFa0cafd),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 15),
                  (widget.profileName == null)
                      ? const Text("")
                      : Text(
                          "${widget.profileName}",
                          style: const TextStyle(
                            fontSize: 20,
                            color: Color(0xff194975),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
