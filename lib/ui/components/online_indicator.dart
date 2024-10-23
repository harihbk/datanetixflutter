import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';

class OnlineIndicator extends StatelessWidget {
  const OnlineIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 10.0,
      width: 10.0,
      child: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          final bool connected = connectivity != ConnectivityResult.none;
          return connected
              ? child
              : Container(
                  decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ));
        },
        child: Container(
            decoration: const BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
        )),
      ),
    );
  }
}
