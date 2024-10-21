import 'package:flutter/material.dart';

import '/themes/main_theme.dart';

class IconWithBackground extends StatelessWidget {
  const IconWithBackground({
    super.key,
    required this.icon,
    required this.circleColor,
    required this.size,
  });

  final IconData icon;
  final Color circleColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: circleColor,
        borderRadius: BorderRadius.all(
          Radius.circular(size / 2),
        ),
      ),
      alignment: Alignment.center,
      child: Icon(
        icon,
        size: size - 15,
        color: colors(context).altText,
      ),
    );
  }
}
