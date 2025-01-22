import 'package:flutter/cupertino.dart';

class TCustomCurvedEdges extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);

    final firstCurve = Offset(0, size.height - 20);
    final finalCurve = Offset(30, size.height - 20);
    path.quadraticBezierTo(
        firstCurve.dx, firstCurve.dy, finalCurve.dx, finalCurve.dy);

    final secodFirstCurve = Offset(0, size.height - 20);
    final secondLastCurve = Offset(size.width-30, size.height - 20);
    path.quadraticBezierTo(
        secodFirstCurve.dx, secodFirstCurve.dy, secondLastCurve.dx, secondLastCurve.dy);

    final thirdFirstCurve = Offset(size.width, size.height - 20);
    final thridLastCurve = Offset(size.width, size.height);
    path.quadraticBezierTo(
        thirdFirstCurve.dx, thirdFirstCurve.dy, thridLastCurve.dx, thridLastCurve.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
