import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enhance_security_model/Model/theme_model.dart';
import 'package:enhance_security_model/View%20Model/app_assets.dart';
import 'package:enhance_security_model/View%20Model/app_colors.dart';
import 'package:enhance_security_model/View%20Model/app_constants.dart';
import 'package:enhance_security_model/View%20Model/my_encryption_decryption.dart';
import 'package:enhance_security_model/View/AppBar%20Pages/about_us.dart';
import 'package:enhance_security_model/View/AppBar%20Pages/contact_us.dart';
import 'package:enhance_security_model/View/AppBar%20Pages/home.dart';
import 'package:enhance_security_model/View/MenuBar%20Pages/customer_support_page.dart';
import 'package:enhance_security_model/View/MenuBar%20Pages/dashboard_page.dart';
import 'package:enhance_security_model/View/MenuBar%20Pages/setting_page.dart';
import 'package:enhance_security_model/View/MenuBar%20Pages/upload_page.dart';
import 'package:enhance_security_model/View/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:switcher_button/switcher_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.themeNotifier, required this.uid})
      : super(key: key);

  final ThemeModel themeNotifier;
  final String? uid;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool home = true;
  bool contactUs = false;
  bool aboutUs = false;
  bool dashboard = false;
  bool setting = false;
  bool upload = false;
  bool customerSupport = false;

  bool isColorThemeDark = false;

  SharedPreferences? theme;

  String userName = "";
  String name = "";
  String dateOfBirth = "";
  String gender = "";
  String email = "";
  String mobileNo = "";
  bool? reset = false;

  getResetData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    reset = prefs.getBool('resetPassword');
  }

  final firebaseInstance = FirebaseFirestore.instance;

  Future<void> getUserData() async {
    try {
      var response = await firebaseInstance
          .collection("users")
          .where("uid", isEqualTo: widget.uid)
          .get();
      if (response.docs.length > 0) {
        String decryptUserName =
            MyEncryptionDecryption.decryptAES(response.docs[0]["userName"]);
        String decryptName =
            MyEncryptionDecryption.decryptAES(response.docs[0]["name"]);
        String decryptDateOfBirth =
            MyEncryptionDecryption.decryptAES(response.docs[0]["dateOfBirth"]);
        String decryptGender =
            MyEncryptionDecryption.decryptAES(response.docs[0]["gender"]);
        String decryptEmail =
            MyEncryptionDecryption.decryptAES(response.docs[0]["email"]);
        String decryptMobileNo =
            MyEncryptionDecryption.decryptAES(response.docs[0]["mobileNo"]);

        setState(() {
          userName = decryptUserName;
          name = decryptName;
          dateOfBirth = decryptDateOfBirth;
          gender = decryptGender;
          email = decryptEmail;
          mobileNo = decryptMobileNo;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  final _firebaseStorage = FirebaseStorage.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    document.onContextMenu.listen((event) => event.preventDefault());
    getUserData();
    getResetData();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? uid;
  String? userEmail;

  Future<String> signOut() async {
    await _auth.signOut();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('auth', false);
    prefs.clear();

    uid = null;
    userEmail = null;

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) =>
                MainScreen(themeNotifier: widget.themeNotifier)),
        (route) => false);

    print("Sign Out");
    return 'User signed out';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder:
        (BuildContext context, ThemeModel themeNotifier, Widget? child) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: themeNotifier.isDark
            ? AppColors.darkPrimaryColor
            : AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: widget.themeNotifier.isDark
              ? AppColors.darkPrimaryColor
              : AppColors.backgroundColor,
          title: Row(
            children: [
              SizedBox(
                width: 20,
              ),
              Text(
                AppConstant.appName,
                style: TextStyle(
                  fontSize: 25,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    home = true;
                    contactUs = false;
                    aboutUs = false;
                    dashboard = false;
                    upload = false;
                    setting = false;
                    customerSupport = false;
                  });
                },
                child: Text(
                  AppConstant.home,
                  style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    home = false;
                    contactUs = false;
                    aboutUs = true;
                    dashboard = false;
                    upload = false;
                    setting = false;
                    customerSupport = false;
                  });
                },
                child: Text(
                  AppConstant.aboutUs,
                  style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    home = false;
                    contactUs = true;
                    aboutUs = false;
                    dashboard = false;
                    upload = false;
                    setting = false;
                    customerSupport = false;
                  });
                },
                child: Text(
                  AppConstant.contactUs,
                  style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 1,
                color: AppColors.primaryColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: FlatButton(
                child: Text(
                  AppConstant.signOut,
                ),
                color: AppColors.primaryColor,
                textColor: Colors.white,
                onPressed: () {
                  signOut();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: Center(
                child: Text(
                  userName,
                  style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        body: Listener(
          // onPointerDown: _onPointerDown,
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Image.asset(
                      AppAssets.logo,
                      scale: 5,
                    ),
                    SizedBox(
                      width: 250,
                      height: 50,
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          home = false;
                          contactUs = false;
                          aboutUs = false;
                          dashboard = true;
                          upload = false;
                          setting = false;
                          customerSupport = false;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 15),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.dashboard,
                              color: AppColors.primaryColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              AppConstant.dashBoard,
                              style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          home = false;
                          contactUs = false;
                          aboutUs = false;
                          dashboard = false;
                          upload = true;
                          setting = false;
                          customerSupport = false;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 15),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.cloud_upload,
                              color: AppColors.primaryColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              AppConstant.uploadFiles,
                              style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Divider(
                        height: 1,
                        color: AppColors.secondShadowPrimaryColor,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          home = false;
                          contactUs = false;
                          aboutUs = false;
                          dashboard = false;
                          upload = false;
                          setting = true;
                          customerSupport = false;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 15),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.account_circle_outlined,
                              color: AppColors.primaryColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Your Profile",
                              style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Divider(
                        height: 1,
                        color: AppColors.secondShadowPrimaryColor,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          home = false;
                          contactUs = false;
                          aboutUs = false;
                          dashboard = false;
                          upload = false;
                          setting = false;
                          customerSupport = true;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 15),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.support_agent,
                              color: AppColors.primaryColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              AppConstant.customerSupport,
                              style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          AppConstant.theme,
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                          width: 40,
                          child: SwitcherButton(
                            onColor: AppColors.primaryColor,
                            offColor: AppColors.secondPrimaryColor,
                            value: themeNotifier.isDark ? false : true,
                            onChange: (value) {
                              if (value == true) {
                                themeNotifier.isDark = false;
                              } else {
                                themeNotifier.isDark = true;
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 6,
                child: Container(
                  color: AppColors.secondPrimaryColor,
                  child: home == true
                      ? Home()
                      : aboutUs == true
                          ? AboutUs()
                          : contactUs == true
                              ? ContactUs()
                              : dashboard == true
                                  ? Dashboard(
                                      themeNotifier: widget.themeNotifier)
                                  : upload == true
                                      ? Upload(
                                          themeNotifier: widget.themeNotifier,
                                          uid: widget.uid)
                                      : setting == true
                                          ? Setting(
                                              uid: widget.uid,
                                              reset: reset,
                                              email: email,
                                              dateOfBirth: dateOfBirth,
                                              userName: userName,
                                              mobileNo: mobileNo,
                                              gender: gender,
                                              name: name,
                                            )
                                          : customerSupport == true
                                              ? CustomerSupport(uid: widget.uid)
                                              : null,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
