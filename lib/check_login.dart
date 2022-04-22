import 'package:enhance_security_model/Model/theme_model.dart';
import 'package:enhance_security_model/View/home_page.dart';
import 'package:enhance_security_model/View/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckLogIn extends StatefulWidget {
  const CheckLogIn({Key? key, required this.themeNotifier}) : super(key: key);

  final ThemeModel themeNotifier;

  @override
  _CheckLogInState createState() => _CheckLogInState();
}

class _CheckLogInState extends State<CheckLogIn> with TickerProviderStateMixin {
  late SharedPreferences logInData;
  bool? login;
  String? uid;
  late AnimationController _controller;

  @override
  void initState() {
    initial();
    _controller = AnimationController(
      duration: Duration(seconds: (3)),
      vsync: this,
    );
    super.initState();
  }

  initial() async {
    logInData = await SharedPreferences.getInstance();
    setState(() {
      login = logInData.getBool('auth');
      uid = logInData.getString('uid');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Lottie.asset(
              'assets/lottie.json',
              controller: _controller,
              height: MediaQuery.of(context).size.height * 1,
              animate: true,
              onLoaded: (composition) {
                _controller
                  ..duration = composition.duration
                  ..forward().whenComplete(
                    () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => login == true
                              ? HomePage(
                                  themeNotifier: widget.themeNotifier, uid: uid)
                              : MainScreen(themeNotifier: widget.themeNotifier),
                        ),
                      );
                    },
                  );
              },
            ),
          ),
        ),
      ),
    );
  }
}
