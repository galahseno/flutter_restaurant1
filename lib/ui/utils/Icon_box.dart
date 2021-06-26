import 'package:flutter/material.dart';

class IconBox extends StatelessWidget {
  final Widget child;
  final double width, height;
  const IconBox({
    Key? key,
    required this.child, required this.width, required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.green.withAlpha(200), blurRadius: 7)
        ],
      ),
      padding: EdgeInsets.all(10),
      child: Center(
        child: child,
      ),
    );
  }
}
