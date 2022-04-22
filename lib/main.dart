import 'package:enhance_security_model/Model/theme_model.dart';
import 'package:enhance_security_model/View%20Model/app_constants.dart';
import 'package:enhance_security_model/check_login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final Future<FirebaseApp> _initialization = Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyCA5HUXlkl1LbrqoCAbnEDmClowe5S3uUc",
        authDomain: "enhance-data-security.firebaseapp.com",
        projectId: "enhance-data-security",
        storageBucket: "enhance-data-security.appspot.com",
        messagingSenderId: "267811397718",
        appId: "1:267811397718:web:e647498cb110cab5535bf7",
        measurementId: "G-12JB5L6MNB"),
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print("Error");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return ChangeNotifierProvider(
            create: (_) => ThemeModel(),
            child: Consumer(
              builder: (BuildContext context, ThemeModel themeNotifier,
                  Widget? child) {
                return MaterialApp(
                  title: AppConstant.appName,
                  debugShowCheckedModeBanner: false,
                  home: CheckLogIn(themeNotifier: themeNotifier),
                );
              },
            ),
          );
        }
        return Center(
          child: SizedBox(
            height: 50,
            width: 50,
            child: Lottie.asset(
              'assets/lottie.json',
              animate: true,
              repeat: true,
            ),
          ),
        );
      },
    );
  }
}
