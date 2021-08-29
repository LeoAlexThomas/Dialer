import 'package:call_log/call_log.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dailerapp/model/callLog.dart';

class CloudStorage {
  CollectionReference collectionNameRef =
      FirebaseFirestore.instance.collection('CallLogs');
  CallLogger callLogger = CallLogger();
  void writeStorage(Future<Iterable<CallLogEntry>> callLogs) async {
    int callLogId = 0;
    List<Map<String, dynamic>> jsonData = [];
    var callLog = await callLogs;

    callLog.forEach((entry) {
      jsonData.add({
        "Name": callLogger.getName(entry),
        "Duration": callLogger.getTime(entry.duration),
        "Date": callLogger.getFormatedDate(
            new DateTime.fromMillisecondsSinceEpoch(entry.timestamp ?? 0)),
        "CallType": callLogger.getCallType(entry.callType!),
        "SimCard": entry.simDisplayName!,
      });
    });
    jsonData.forEach((element) async {
      callLogId++;
      await collectionNameRef.doc('$callLogId').set(element);
    });
  }
}
