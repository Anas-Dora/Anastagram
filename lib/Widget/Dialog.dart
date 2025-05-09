// ignore_for_file: file_names

import 'package:flutter/material.dart';

class DialogHelper {
  static Future<String?> openDialog({
    required BuildContext context,
    required TextEditingController usernameController,
    required VoidCallback submit,
    required ValueChanged<String> onUsernameChanged,
  }) {
    return showDialog<String>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text(
              "Benutzername eingeben",
              style: TextStyle(color: Color(0xffe1e2e8)),
            ),
            backgroundColor: Color(0xff272a2f),
            content: TextField(
              style: TextStyle(color: Color(0xffe1e2e8)),
              cursorColor: Color(0xffa0cafd),
              onChanged: onUsernameChanged,
              onSubmitted: (_) => submit(),
              controller: usernameController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: "Nutzername",
                labelStyle: TextStyle(color: Color(0xffa0cafd)),
                suffixIcon:
                    usernameController.text.trim().isEmpty
                        ? const SizedBox(width: 0, height: 0)
                        : IconButton(
                          icon: const Icon(Icons.clear),
                          color: const Color(0xffa0cafd),
                          onPressed: () {
                            usernameController.clear();
                          },
                        ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffa0cafd)),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Abbrechen",
                  style: TextStyle(color: Color(0xffa0cafd)),
                ),
              ),
              FilledButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith((states) {
                    // If the button is pressed, return green, otherwise blue
                    if (states.contains(WidgetState.pressed)) {
                      return Color(0xffa0cafd);
                    }
                    return Color(0xffa0cafd);
                  }),
                ),
                onPressed: submit,
                child: const Text(
                  "Okey",
                  style: TextStyle(color: Color(0xff003258)),
                ),
              ),
            ],
          ),
    );
  }
}
