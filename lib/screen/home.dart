// Build-in packages
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:connectivity/connectivity.dart';
import 'package:call_log/call_log.dart';

import 'package:permission_handler/permission_handler.dart';
// Model classes Import
import 'package:dailerapp/model/callDetail.dart';
import 'package:dailerapp/model/callLog.dart';
// Storage import
import 'package:dailerapp/storage/cloudStorage.dart';
import 'package:dailerapp/storage/localstorage.dart';
// Widgets import
import 'package:dailerapp/widget/callType.dart';
import 'package:dailerapp/widget/circleavatar.dart';
import 'package:dailerapp/widget/dialpad.dart';
import 'package:dailerapp/widget/refreshwidget.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  var scrHeight;
  var scrWidth;
  var fontHeight;

  // Call Log entry
  late Future<Iterable<CallLogEntry>> entries;
  // Connectivity State subscription
  late StreamSubscription subscription;

  // Objects for classes
  CallLogger callLog = new CallLogger();
  final store = LocalStorage();
  final cloudStore = CloudStorage();
  final connectivity = Connectivity();

  // Text Controller for mobile number entry
  final phonenumberCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    entries = callLog.getCallLogs();

    // detecting network connection avaliable if connection state changes to
    // mobile network or wifi call log will uploaded to cloud
    subscription = connectivity.onConnectivityChanged
        .listen((ConnectivityResult connectivityResult) {
      if (connectivityResult != ConnectivityResult.none) {
        var data = callLog.getCallLogs();
        if (data != null) {
          print('upload started');
          cloudStore.writeStorage(data);
          print('upload done');
        }
      } else {
        print('connection disconnected');
      }
    });
    // Writing locally after call log is updated
    writeLocal();
  }

  // Store call log locally
  writeLocal() {
    entries.then((value) {
      store.writeCallLog(value);
    });
  }

  // getting Call Log
  Future getData() async {
    if (await Permission.phone.request().isGranted)
      entries = callLog.getCallLogs();
    else {
      getData();
    }
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getData();
    writeLocal();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    getData();
    writeLocal();
  }

  @override
  Widget build(BuildContext context) {
    scrHeight = MediaQuery.of(context).size.height / 100;
    scrWidth = MediaQuery.of(context).size.width / 100;
    fontHeight = MediaQuery.of(context).size.height * 0.01;
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: scrHeight * 95,
          // ignore: unnecessary_null_comparison
          child: entries == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : FutureBuilder(
                  future: entries,
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
                          onRefresh: getData,
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
