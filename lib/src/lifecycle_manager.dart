import 'package:flutter/material.dart';
import 'package:flutter_module_umbrella/src/background_fetch_service.dart';
import 'package:flutter_module_umbrella/src/locator.dart';
import 'package:flutter_module_umbrella/src/stoppable_service.dart';

class LifeCycleManager extends StatefulWidget {
  const LifeCycleManager({
    super.key,
    required this.child,
  });
  final Widget child;
  @override
  State<LifeCycleManager> createState() => _LifeCycleManagerState();
}

class _LifeCycleManagerState extends State<LifeCycleManager>
    with WidgetsBindingObserver {
  final List<StoppableService> servces = [
    locator<BackgroundFetchService>(),
  ];

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
    debugPrint('App lifecycle state = $state');
    super.didChangeAppLifecycleState(state);
    for (var element in servces) {
      if (state == AppLifecycleState.resumed) {
        element.start();
      } else {
        element.stop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.child,
    );
  }
}
