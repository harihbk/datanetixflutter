import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../globals/settings.dart';
import '/themes/main_theme.dart';
import 'online_indicator.dart';

class StatusBarDate extends StatelessWidget {
  const StatusBarDate({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Settings.headerHeight,
      width: double.infinity,
      color: colors(context).button,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  DateFormat('EEEE, MMMM d, y').format(DateTime.now()),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(width: 10.0),
                const OnlineIndicator(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
