import 'package:flutter/material.dart';

typedef FutureCallBack = Function(); //Future<void>

class AppRefresh extends StatefulWidget {
  final Widget child;
  final FutureCallBack refreshFunction;

  const AppRefresh(
      {super.key, required this.child, required this.refreshFunction});

  @override
  State<AppRefresh> createState() => _AppRefreshState();
}

class _AppRefreshState extends State<AppRefresh> {
  Widget get child => widget.child;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      displacement: 250,
      backgroundColor: Colors.blue,
      color: Colors.white,
      strokeWidth: 3,
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      onRefresh: () async {
        await Future.delayed(const Duration(milliseconds: 1500));
        // setState(() {
        //   itemCount = itemCount + 1;
        // });
        // controller.drawerClosedCallback();
        widget.refreshFunction();
      },
      child: child,
    );
  }
}