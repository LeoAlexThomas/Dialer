// Build-in packages
import 'package:dailerapp/model/callLog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:call_log/call_log.dart';

// Model classes Import
import 'package:dailerapp/model/callDetail.dart';
// Widgets import
import 'package:dailerapp/widget/callType.dart';
import 'package:dailerapp/widget/circleavatar.dart';
import 'package:dailerapp/widget/dialpad.dart';
import 'package:dailerapp/widget/refreshwidget.dart';

class RecentCalls extends StatefulWidget {
  final Future Function() updateCalLog;
  final Future<Iterable<CallLogEntry>> entries;

  RecentCalls({Key? key, required this.entries, required this.updateCalLog})
      : super(key: key);

  @override
  _RecentCallsState createState() => _RecentCallsState();
}

class _RecentCallsState extends State<RecentCalls> {
  var scrHeight;
  var scrWidth;
  var fontHeight;

  CallLogger callLog = new CallLogger();

  @override
  Widget build(BuildContext context) {
    scrHeight = MediaQuery.of(context).size.height / 100;
    scrWidth = MediaQuery.of(context).size.width / 100;
    fontHeight = MediaQuery.of(context).size.height * 0.01;
    return SafeArea(
      child: Scaffold(
        body: Container(
          // height: scrHeight * 95,
          // ignore: unnecessary_null_comparison
          child: widget.entries == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : FutureBuilder(
                  future: widget.entries,
                  initialData: Center(
                    child: CircularProgressIndicator(),
                  ),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if ((snapshot.connectionState == ConnectionState.done) &&
                        (snapshot.hasData)) {
                      Iterable<CallLogEntry> log = snapshot.data;
                      if (log.length == 0) {
                        return Center(
                          child: Text('No data Found'),
                        );
                      } else {
                        return RefreshWidget(
                          onRefresh: widget.updateCalLog,
                          child: ListView.builder(
                            itemCount: log.length,
                            itemBuilder: (BuildContext context, int index) {
                              Map<String, dynamic> logDetail = {};

                              logDetail['name'] =
                                  callLog.getName(log.elementAt(index));
                              logDetail['date'] = callLog.getFormatedDate(
                                  new DateTime.fromMillisecondsSinceEpoch(
                                      log.elementAt(index).timestamp ?? 0));
                              logDetail['duration'] = callLog
                                  .getTime(log.elementAt(index).duration);
                              logDetail['sim'] =
                                  log.elementAt(index).simDisplayName!;
                              logDetail['calltype'] =
                                  log.elementAt(index).callType!;
                              return Card(
                                child: ListTile(
                                  leading:
                                      CustomAvatar(name: logDetail['name'][0]),
                                  title: Row(
                                    children: [
                                      Text(
                                        logDetail['name'],
                                        style: TextStyle(
                                            fontSize: fontHeight * 2.25),
                                      ),
                                      SizedBox(width: scrWidth * 2),
                                      CallTypeWidget(
                                          callType: logDetail['calltype']),
                                    ],
                                  ),
                                  isThreeLine: true,
                                  subtitle: Text(
                                    logDetail['date'] +
                                        '\n' +
                                        logDetail['duration'] +
                                        ' ' +
                                        logDetail['sim'],
                                    style:
                                        TextStyle(fontSize: fontHeight * 1.8),
                                  ),
                                  trailing: IconButton(
                                      onPressed: () => callLog
                                          .call(log.elementAt(index).number),
                                      icon: Icon(
                                        Icons.call,
                                        color: Colors.green,
                                        size: fontHeight * 3.5,
                                      )),
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CallDetails(
                                            entry: log.elementAt(index)),
                                      )),
                                ),
                              );
                            },
                          ),
                        );
                      }
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return DialPad(
                  onCall: (String number) => callLog.call(number),
                );
              },
            );
            print('object');
          },
          child: Icon(Icons.dialpad_rounded),
        ),
      ),
    );
  }
}
