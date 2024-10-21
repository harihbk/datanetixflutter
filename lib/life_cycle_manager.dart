import 'package:flutter/widgets.dart';
import '/services/main_service.dart';

import 'app/app.locator.dart';

class LifeCycleManager extends StatefulWidget {
  final Widget child;
  const LifeCycleManager({Key? key, required this.child}) : super(key: key);

  @override
  _LifeCycleManagerState createState() => _LifeCycleManagerState();
}

class _LifeCycleManagerState extends State<LifeCycleManager>
    with WidgetsBindingObserver {
  final _mainService = locator<MainService>();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // print('STATE = $state');
    if (state != AppLifecycleState.resumed) {
      // TODO: online
    } else {
      // TODO: offline
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.child,
    );
  }
}
