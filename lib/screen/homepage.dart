import 'dart:async';

import 'package:call_log/call_log.dart';
import 'package:connectivity/connectivity.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:dailerapp/model/callLog.dart';
import 'package:dailerapp/model/callSearch.dart';
import 'package:dailerapp/screen/contacts.dart';
import 'package:dailerapp/screen/recentcall.dart';
import 'package:dailerapp/storage/cloudStorage.dart';
import 'package:dailerapp/storage/localstorage.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class Homepage extends StatefulWidget {
  Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with WidgetsBindingObserver {
  // Call Log entry
  late Future<Iterable<CallLogEntry>> entries;

  //BottomNav Bar Index
  int btIdx = 0;

// Contacts
  Iterable<Contact> contacts = [];

  List<CallDetail> callDetails = [];
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
    getContact();
    // detecting network connection avaliable if connection state changes to
    // mobile network or wifi call log will uploaded to cloud
    subscription = connectivity.onConnectivityChanged
        .listen((ConnectivityResult connectivityResult) {
      if (connectivityResult != ConnectivityResult.none) {
        var data = callLog.getCallLogs();
        if (data != null) {
          cloudStore.writeStorage(data);
        }
      } else {
        print('connection disconnected');
      }
    });
    // Writing locally after call log is updated
    writeLocal();
    setState(() {});
  }

  // Store call log locally
  writeLocal() {
    entries.then((value) {
      store.writeCallLog(value);
    });
  }

  getContact() async {
    if (await Permission.contacts.request().isGranted) {
      contacts = await ContactsService.getContacts(withThumbnails: false);
    }
    // contacts = callDetails;
    setState(() {});
  }

  // getting Call Log
  Future getData() async {
    if (await Permission.phone.request().isGranted) {
      entries = callLog.getCallLogs();
    } else {
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Dialer'),
          // actions: [
          //   IconButton(
          //     onPressed: () => showSearch(
          //         context: context,
          //         delegate: SearchPage(
          //           failure: Center(
          //             child: Text('No Contacts :('),
          //           ),
          //           builder: (CallDetail callDetails) => ListTile(
          //             title: Text(callDetails.name),
          //             subtitle: Text(callDetails.number),
          //           ),
          //           filter: (CallDetail callDetails) =>
          //               [callDetails.name, callDetails.number],
          //           items: callDetails,
          //         )),
          //     icon: Icon(Icons.search),
          //   ),
          // ],
        ),
        body: btIdx == 0
            ? RecentCalls(entries: entries, updateCalLog: () => getData())
            : ContactTab(contacts: contacts),
        extendBody: true,
        bottomNavigationBar: FloatingNavbar(
          backgroundColor: Colors.blueAccent,
          items: <FloatingNavbarItem>[
            FloatingNavbarItem(icon: Icons.timer),
            FloatingNavbarItem(icon: Icons.contact_phone),
          ],
          currentIndex: btIdx,
          onTap: (int val) => setState(() {
            btIdx = val;
          }),
        ),
      ),
    );
  }
}
