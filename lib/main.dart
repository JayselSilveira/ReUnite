//shared firebase account
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:missing_child/screens/addmissingchild.dart';
// import 'package:missing_child/screens/apicall.dart';
import 'package:missing_child/screens/faceaging.dart';
import 'package:missing_child/screens/editmissingchild.dart';
import 'package:missing_child/screens/faceaging.dart';
import 'package:missing_child/screens/findmissingchild.dart';
import 'package:missing_child/screens/homepg.dart';
import 'package:missing_child/screens/login.dart';
import 'package:missing_child/screens/signup.dart';
import 'package:missing_child/screens/splashscreen.dart';
import 'package:missing_child/screens/startpg.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  static final String oneSignalAppId = "67c9a17a-98b8-45eb-8d4b-59ce215d12c1"; //for notification
  Future<void> initPlatformState() async {
    OneSignal.shared.setAppId(oneSignalAppId);
    OneSignal.shared
        .promptUserForPushNotificationPermission()
        .then((accepted) {});
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        //primaryColor: Colors.orange,
      ),
      home: const
      // StartPage(),
       // LoginPage(),
       SplashScreen(),//TODO: (add splash screen)
      //HomePage(),
      routes: <String, WidgetBuilder> { //contains all the screen routes
        // '/splash' : (BuildContext context) => SplashScreen(),
        '/login' : (BuildContext context) => LoginPage(),
        '/signup' : (BuildContext context) => SignupPage(),
        '/homepg' : (BuildContext context) => HomePage(),
        '/startpg' : (BuildContext context) => StartPage(),
        '/findmissingchild' : (BuildContext context) => FindMissingChildPage(),
        '/addmissingchild' : (BuildContext context) => AddMissingChildPage(),
        '/editmissingchild' : (BuildContext context) => EditMissingChildPage(),
        '/splashscreen' : (BuildContext context) => SplashScreen(),
        '/faceaging' : (BuildContext context) => FaceAging(),
        // '/apicall' : (BuildContext context) => ApiPage(),

      },
    );
  }
}



