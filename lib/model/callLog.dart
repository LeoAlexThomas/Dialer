import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class CallLogger {
  void call(String? number) async {
    await FlutterPhoneDirectCaller.directCall(number!);
  }

  bool isNumeric(String str) {
    try {
      double.parse(str);
      return true;
    } on FormatException {
      if (str.contains('+')) {
        return true;
      }
      return false;
    }
  }

  String getCallType(CallType callType) {
    String type = callType.toString();
    int index = type.indexOf('.');
    type = type.substring(index + 1);

    return type + ' ' + 'call';
  }

  callTypes(CallType? callType) {
    Widget callData;
    switch (callType) {
      case CallType.incoming:
        callData = Icon(
          Icons.call_received,
          color: Colors.green,
        );
        break;
      case CallType.outgoing:
        callData = Icon(
          Icons.call_made,
          color: Colors.blue,
        );
        break;
      case CallType.missed:
        callData = Icon(
          Icons.call_missed,
          color: Colors.red,
        );
        break;
      case CallType.blocked:
        callData = Icon(
          Icons.block,
          color: Colors.grey,
        );
        break;
      case CallType.rejected:
        callData = Icon(
          Icons.call_received,
          color: Colors.red,
        );
        break;
      default:
        callData = Icon(Icons.phone_paused);
    }
    return callData;
  }

  getCallLogs() {
    return CallLog.get();
  }

  String getName(CallLogEntry entry) {
    String name = '';
    if (entry.name == null)
      name = entry.number!;
    else if (entry.name!.isEmpty)
      name = entry.number!;
    else
      name = entry.name!;

    return name;
  }

  String getTime(int? duration) {
    if (duration != null) {
      Duration date = Duration(seconds: duration);
      String alteredTIme = '';
      if (date.inHours > 0) alteredTIme += date.inHours.toString() + 'h';
      if (date.inMinutes > 0) alteredTIme += date.inMinutes.toString() + 'm';
      if (date.inSeconds > 0) alteredTIme += convert(date.inSeconds) + 's';
      return alteredTIme;
    } else {
      return '0s';
    }
  }

  String convert(int data) {
    return (data / 60).truncate().toString().padLeft(2, '0');
  }

  String getFormatedDate(DateTime date) {
    return DateFormat('dd-MM-yy HH:mm:ss').format(date);
  }
}
