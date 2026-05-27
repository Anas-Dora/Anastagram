import 'package:flutter/material.dart';

class UserInputDialog extends StatefulWidget {
  const UserInputDialog({super.key});

  @override
  State<UserInputDialog> createState() => _UserInputDialogState();
}

class _UserInputDialogState extends State<UserInputDialog> {
  final _usernameController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Benutzername eingeben",
        style: TextStyle(color: Color(0xffe1e2e8)),
      ),
      backgroundColor: Color(0xff272a2f),
      content: TextField(
        style: TextStyle(color: Color(0xffe1e2e8)),
        cursorColor: Color(0xffa0cafd),
        controller: _usernameController,
        onChanged: (_) => setState(() {}),
        onSubmitted: (_) {
          final username = _usernameController.text.trim();
          Navigator.pop(context, username.isEmpty ? null : username);
        },
        autofocus: true,
        decoration: InputDecoration(
          labelText: "Nutzername",
          labelStyle: TextStyle(color: Color(0xffa0cafd)),
          suffixIcon: _usernameController.text.trim().isEmpty
              ? const SizedBox(width: 0, height: 0)
              : IconButton(
                  icon: const Icon(Icons.clear),
                  color: const Color(0xffa0cafd),
                  onPressed: () {
                    _usernameController.clear();
                    setState(() {});
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
          child: Text("Abbrechen", style: TextStyle(color: Color(0xffa0cafd))),
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
          onPressed: () {
            final username = _usernameController.text.trim();
            Navigator.pop(context, username.isEmpty ? null : username);
          },
          child: const Text("Okey", style: TextStyle(color: Color(0xff003258))),
        ),
      ],
    );
  }
}
