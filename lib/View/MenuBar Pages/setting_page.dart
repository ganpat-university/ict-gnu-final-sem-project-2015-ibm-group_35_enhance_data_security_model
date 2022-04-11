import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enhance_security_model/Model/User.dart';
import 'package:enhance_security_model/Model/theme_model.dart';
import 'package:enhance_security_model/View%20Model/app_colors.dart';
import 'package:enhance_security_model/View%20Model/app_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

enum LoginType { directLogin, authLogin }

class Setting extends StatefulWidget {
  const Setting({Key? key, this.uid}) : super(key: key);
  final String? uid;

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  LoginType _login = LoginType.directLogin;

  String userName = "";
  String name = "";
  String dateOfBirth = "";
  String gender = "";
  String email = "";
  String mobileNo = "";

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final firebaseInstance = FirebaseFirestore.instance;

  Future<void> getUserData() async {
    try {
      var response = await firebaseInstance
          .collection("users")
          .where("uid", isEqualTo: widget.uid)
          .get();
      if (response.docs.length > 0) {
        setState(() {
          userName = response.docs[0]["userName"];
          name = response.docs[0]["name"];
          dateOfBirth = response.docs[0]["dateOfBirth"];
          gender = response.docs[0]["gender"];
          email = response.docs[0]["email"];
          mobileNo = response.docs[0]["mobileNo"];
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder:
        (BuildContext context, ThemeModel themeNotifier, Widget? child) {
      return Scaffold(
        backgroundColor: themeNotifier.isDark
            ? AppColors.darkShadowSecondPrimaryColor
            : AppColors.secondPrimaryColor,
        appBar: AppBar(
          backgroundColor: themeNotifier.isDark
              ? AppColors.darkShadowSecondPrimaryColor
              : AppColors.secondPrimaryColor,
          elevation: 0,
          title: Text(
            "Your Profile",
            style: TextStyle(color: AppColors.primaryColor),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
          child: ListView(
            children: [
              Text(
                "Your Profile Data:",
                style: TextStyle(fontSize: 26, color: AppColors.primaryColor),
              ),
              Divider(
                color: AppColors.primaryColor,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 50,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Username :  $userName",
                        style: TextStyle(
                            fontSize: 22, color: AppColors.primaryColor),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text("Name :  $name",
                          style: TextStyle(
                              fontSize: 22, color: AppColors.primaryColor)),
                      SizedBox(
                        height: 30,
                      ),
                      Text("Email Id :  $email",
                          style: TextStyle(
                              fontSize: 22, color: AppColors.primaryColor)),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 150,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Text("Date Of Birth :  $dateOfBirth",
                          style: TextStyle(
                              fontSize: 22, color: AppColors.primaryColor)),
                      SizedBox(
                        height: 30,
                      ),
                      Text("Mobile No. :  $mobileNo",
                          style: TextStyle(
                              fontSize: 22, color: AppColors.primaryColor)),
                      SizedBox(
                        height: 30,
                      ),
                      Text("Gender : $gender",
                          style: TextStyle(
                              fontSize: 22, color: AppColors.primaryColor)),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Your Profile Settings:",
                style: TextStyle(fontSize: 26, color: AppColors.primaryColor),
              ),
              Divider(
                color: AppColors.primaryColor,
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 50,
                  ),
                  Text("Password :  ",
                      style: TextStyle(
                          fontSize: 22, color: AppColors.primaryColor)),
                  SizedBox(
                    width: 20,
                  ),
                  TextButton(
                    onPressed: () {
                      resetPassword(email);
                    },
                    child: Text(
                      "Change Password",
                      style: TextStyle(
                          fontSize: 22, color: AppColors.primaryColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Future<void> resetPassword(String email) async {
    if (email == "") {
      Fluttertoast.showToast(
        msg: 'Please Enter Email',
        textColor: AppColors.white,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppColors.white,
      );
    } else {
      Fluttertoast.showToast(
        msg: 'Check Email To Reset Your Password',
        textColor: AppColors.white,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppColors.white,
      );
      await _auth.sendPasswordResetEmail(email: email);
    }
  }
}
