import 'package:flutter/material.dart';

Widget buildStatItem(String label, int value) {
  return Column(
    children: [
      Text(
        value.toString(),
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xffa0cafd),
        ),
      ),
      Text(label, style: TextStyle(fontSize: 16, color: Color(0xffa0cafd))),
    ],
  );
}
