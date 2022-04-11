import 'dart:js';

import 'package:enhance_security_model/Model/theme_model.dart';
import 'package:enhance_security_model/View/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseAuthentication {
  String phoneNumber = "";

  sendOTP(String phoneNumber) async {
    this.phoneNumber = phoneNumber;
    FirebaseAuth auth = FirebaseAuth.instance;
    ConfirmationResult confirmationResult = await auth.signInWithPhoneNumber(
      '+91 $phoneNumber',
    );
    printMessage("OTP Sent to +91 $phoneNumber");
    return confirmationResult;
  }

  authenticateMe(widget, BuildContext context,
      ConfirmationResult confirmationResult, String otp) async {
    UserCredential userCredential = await confirmationResult.confirm(otp);
    User? user;
    user = userCredential.user;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('auth', true);
    await prefs.setString('uid', user!.uid);
    userCredential.additionalUserInfo!.isNewUser
        ? Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(
                themeNotifier: widget.themeNotifier,
                uid: user?.uid,
              ),
            ),
            (route) => false)
        : Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(
                themeNotifier: widget.themeNotifier,
                uid: user?.uid,
              ),
            ),
            (route) => false);
    return user;
  }

  printMessage(String msg) {
    debugPrint(msg);
  }
}
