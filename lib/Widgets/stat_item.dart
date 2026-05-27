import 'package:flutter/material.dart';

class StatItem extends StatelessWidget {
  const StatItem({super.key, required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xffa0cafd),
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: Color(0xffa0cafd)),
        ),
      ],
    );
  }
}
