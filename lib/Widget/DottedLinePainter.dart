import 'package:flutter/material.dart';

class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.blue.shade800  // Farbe der Linie
      ..strokeWidth = 3       // Dicke der Linie
      ..style = PaintingStyle.stroke;

    double dashWidth = 10.0;  // Länge jedes Strichs
    double dashSpace = 5.0;   // Abstand zwischen den Strichen
    double startX = 0;

    // Erstelle eine Linie mit Strichen
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;  // Berechne die Position für den nächsten Strich
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}