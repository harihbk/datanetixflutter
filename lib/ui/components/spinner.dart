import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '/globals/settings.dart';

class SpinnerWidget extends StatelessWidget {
  const SpinnerWidget({
    Key? key,
    required this.height,
    required this.width,
    required this.color,
  }) : super(key: key);

  final int height;
  final int width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: height.toDouble(),
        width: width.toDouble(),
        child: LoadingIndicator(
          indicatorType: Settings.spinnerType,
          colors: [color],
        ),
      ),
    );
  }
}
