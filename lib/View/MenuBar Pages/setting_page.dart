import 'package:enhance_security_model/Model/theme_model.dart';
import 'package:enhance_security_model/View%20Model/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

enum LoginType { directLogin, authLogin }

class Setting extends StatefulWidget {
  const Setting(
      {Key? key,
      required this.uid,
      required this.userName,
      required this.name,
      required this.dateOfBirth,
      required this.gender,
      required this.email,
      required this.mobileNo,
      required this.reset})
      : super(key: key);
  final String? uid;
  final String userName;
  final String name;
  final String dateOfBirth;
  final String gender;
  final String email;
  final String mobileNo;
  final bool? reset;

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  LoginType _login = LoginType.directLogin;

  final FirebaseAuth _auth = FirebaseAuth.instance;

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
                        "Username :  ${widget.userName}",
                        style: TextStyle(
                            fontSize: 22, color: AppColors.primaryColor),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text("Name :  ${widget.name}",
                          style: TextStyle(
                              fontSize: 22, color: AppColors.primaryColor)),
                      SizedBox(
                        height: 30,
                      ),
                      Text("Email Id :  ${widget.email}",
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
                      Text("Date Of Birth :  ${widget.dateOfBirth}",
                          style: TextStyle(
                              fontSize: 22, color: AppColors.primaryColor)),
                      SizedBox(
                        height: 30,
                      ),
                      Text("Mobile No. :  ${widget.mobileNo}",
                          style: TextStyle(
                              fontSize: 22, color: AppColors.primaryColor)),
                      SizedBox(
                        height: 30,
                      ),
                      Text("Gender : ${widget.gender}",
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
              widget.reset == true
                  ? Container()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Your Profile Settings:",
                          style: TextStyle(
                              fontSize: 26, color: AppColors.primaryColor),
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
                                    fontSize: 22,
                                    color: AppColors.primaryColor)),
                            SizedBox(
                              width: 20,
                            ),
                            TextButton(
                              onPressed: () {
                                resetPassword(widget.email);
                              },
                              child: Text(
                                "Change Password",
                                style: TextStyle(
                                    fontSize: 22,
                                    color: AppColors.primaryColor),
                              ),
                            ),
                          ],
                        )
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
