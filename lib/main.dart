import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screen/home.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dialer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AppState(),
    );
  }
}

class AppState extends StatefulWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  _AppStateState createState() => _AppStateState();
}

class _AppStateState extends State<AppState> {
  final Future<FirebaseApp> _futureApp = Firebase.initializeApp();
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _futureApp,
        builder: (context, AsyncSnapshot<FirebaseApp> snapshot) {
          if (snapshot.hasError) {
            // Return this widget if error occur
            return Scaffold(
              body: Center(
                child: Text("Something Went wrong"),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            // Return this widget if connection successfull
            return MyHomePage();
          }
          // Return this widget if connection status is waiting
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
