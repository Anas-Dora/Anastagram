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
            title: const Text("Benutzername eingeben"),
            backgroundColor: Colors.white,
            content: TextField(
              onChanged: onUsernameChanged,
              onSubmitted: (_) => submit(),
              controller: usernameController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: "Nutzername",
                labelStyle: TextStyle(color: Colors.blue[800]),
                suffixIcon:
                    usernameController.text.trim().isEmpty
                        ? const SizedBox(width: 0, height: 0)
                        : IconButton(
                          icon: const Icon(Icons.clear),
                          color: const Color(0xFF1565C0),
                          onPressed: () {
                            usernameController.clear();
                          },
                        ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF1565C0)),
                ),
              ),
            ),
            actions: [
              TextButton(
                style: ButtonStyle(
                  overlayColor: WidgetStateProperty.all(Colors.blue.shade100),
                ),
                onPressed: submit,
                child: const Text("OK", style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
    );
  }
}
