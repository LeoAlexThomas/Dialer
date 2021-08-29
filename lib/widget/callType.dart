import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';

class CallTypeWidget extends StatelessWidget {
  final CallType callType;
  CallTypeWidget({Key? key, required this.callType}) : super(key: key);
  var fontHeight;

  @override
  Widget build(BuildContext context) {
    fontHeight = MediaQuery.of(context).size.height * 0.01;
    Widget callData;
    switch (callType) {
      case CallType.incoming:
        callData = Icon(
          Icons.call_received,
          color: Colors.green,
          size: iconSize(),
        );
        break;
      case CallType.outgoing:
        callData = Icon(
          Icons.call_made,
          color: Colors.blue,
          size: iconSize(),
        );
        break;
      case CallType.missed:
        callData = Icon(
          Icons.call_missed,
          color: Colors.red,
          size: iconSize(),
        );
        break;
      case CallType.blocked:
        callData = Icon(
          Icons.block,
          color: Colors.grey,
          size: iconSize(),
        );
        break;
      case CallType.rejected:
        callData = Icon(
          Icons.call_received,
          color: Colors.red,
          size: iconSize(),
        );
        break;
      default:
        callData = Icon(
          Icons.phone_paused,
          size: iconSize(),
        );
    }
    return callData;
  }

  iconSize() => fontHeight * 3.25;
}
