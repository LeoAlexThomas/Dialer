import 'package:flutter/material.dart';

class RefreshWidget extends StatefulWidget {
  final GlobalKey<RefreshIndicatorState> keyRefresh =
      GlobalKey<RefreshIndicatorState>();
  final Widget child;
  final Future Function() onRefresh;

  RefreshWidget({Key? key, required this.child, required this.onRefresh})
      : super(key: key);

  @override
  _RefreshWidgetState createState() => _RefreshWidgetState();
}

class _RefreshWidgetState extends State<RefreshWidget> {
  @override
  Widget build(BuildContext context) => RefreshIndicator(
        key: widget.keyRefresh,
        child: widget.child,
        onRefresh: widget.onRefresh,
      );
}
