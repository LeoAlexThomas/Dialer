import 'dart:io';

import 'package:call_log/call_log.dart';
import 'package:dailerapp/model/callLog.dart';
import 'package:path_provider/path_provider.dart';

CallLogger callLogger = CallLogger();

class LocalStorage {
  Future<String> _localPath() async {
    var dir = await getExternalStorageDirectory();
    return dir!.path;
  }

  Future<File> _localFile() async {
    var path = await _localPath();
    return File('$path/callLog.xls');
  }

  void writeCallLog(Iterable<CallLogEntry> callLog) async {
    String content = '';
    callLog.forEach((entry) {
      if (content.isEmpty) {
        content += 'Name' +
            '\t' +
            'Duration' +
            '\t' +
            'Date' +
            '\t' +
            'CallType' +
            '\t' +
            'SimCard' +
            '\n';
      }
      content += callLogger.getName(entry) +
          '\t' +
          callLogger.getTime(entry.duration) +
          '\t' +
          callLogger.getFormatedDate(
              new DateTime.fromMillisecondsSinceEpoch(entry.timestamp ?? 0)) +
          '\t' +
          callLogger.getCallType(entry.callType!) +
          '\t' +
          entry.simDisplayName! +
          '\n';
    });

    File file = await _localFile();
    file.writeAsString(content);
  }
}
