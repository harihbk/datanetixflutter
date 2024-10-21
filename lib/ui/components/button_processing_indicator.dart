import 'package:flutter/material.dart';

import '../../themes/main_theme.dart';
import 'spinner.dart';

class ButtonProcessingIndicator extends StatelessWidget {
  const ButtonProcessingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpinnerWidget(
      height: 40,
      width: 40,
      color: colors(context).button!,
    );
  }
}
