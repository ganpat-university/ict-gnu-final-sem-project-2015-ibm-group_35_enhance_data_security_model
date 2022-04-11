import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:enhance_security_model/Model/theme_model.dart';
import 'package:enhance_security_model/View%20Model/app_assets.dart';
import 'package:enhance_security_model/View%20Model/app_colors.dart';
import 'package:enhance_security_model/View%20Model/app_constants.dart';
import 'package:enhance_security_model/View%20Model/firebase_global.dart';
import 'package:enhance_security_model/View/MainPage%20AppBar/about_us_page.dart';
import 'package:enhance_security_model/View/MainPage%20AppBar/contact_us_page.dart';
import 'package:enhance_security_model/View/home_page.dart';
import 'package:enhance_security_model/View/mobile_verificationPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LoginType { directLogin, authLogin }

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key, required this.themeNotifier}) : super(key: key);

  final ThemeModel themeNotifier;

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? uid;
  String? userEmail;

  Database database = Database();

  // Controller of SignIn
  TextEditingController emailAddController = TextEditingController();
  TextEditingController passWordController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController otpToSignIn = TextEditingController();

  // Controller for SignUp
  //1
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();

  //2
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  String _errorMessage = 'Please Enter Email';
  String dateOfBirth = "";

  LoginType _login = LoginType.directLogin;

  int currentStep = 0;

  bool signup = false;
  bool visibilityPassword = true;
  bool isCompleted = false;

  var temp;

  // Initial Selected Value
  String dropdownValue = AppConstant.selectGender;

  // List of items in our dropdown menu
  var items = [
    AppConstant.selectGender,
    AppConstant.male,
    AppConstant.female,
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    visibilityPassword;
    signup;
  }

  Future<User?> registerWithEmailPassword(String email, String password) async {
    // Initialize Firebase
    await Firebase.initializeApp();
    User? user;

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      user = userCredential.user;

      if (user != null) {
        setState(() {
          uid = user?.uid;
          userEmail = user?.email;
        });
        await user.sendEmailVerification();
        database.storeUserData(
            uid: uid,
            name: fullNameController.text,
            userName: userNameController.text,
            mobileNo: mobileNoController.text,
            gender: dropdownValue,
            email: emailController.text,
            dateOfBirth: dateOfBirth);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('An account already exists for that email.');
        Fluttertoast.showToast(
          msg: 'An account already exists for that email.',
          textColor: AppColors.white,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: AppColors.white,
        );
      }
    } catch (e) {
      print(e);
    }

    return user;
  }

  Future<User?> signInWithEmailPassword(String email, String password) async {
    await Firebase.initializeApp();
    User? user;

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
      if (user != null) {
        setState(() {
          uid = user?.uid;
          userEmail = user?.email;
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('auth', true);
        await prefs.setString('uid', uid!);
        if (user.emailVerified) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(
                  themeNotifier: widget.themeNotifier,
                  uid: uid,
                ),
              ),
              (route) => false);
        } else {
          Fluttertoast.showToast(
            msg: 'Verify The Email',
            textColor: AppColors.white,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: AppColors.white,
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(
          msg: 'No user found for this email.',
          textColor: AppColors.white,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: AppColors.white,
        );
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(
          msg: 'Provide Correct Password',
          textColor: AppColors.white,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: AppColors.white,
        );
      }
    }

    return user;
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

  bool canShow = false;
  var temp1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.themeNotifier.isDark
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
            Image.asset(
              AppAssets.logo,
              scale: 7,
            ),
            SizedBox(
              width: 15,
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AboutUsPage(),
                  ),
                );
              },
              child: Text(
                AppConstant.aboutUs,
                style: TextStyle(
                    color: AppColors.primaryColor, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContactUsPage(),
                  ),
                );
              },
              child: Text(
                AppConstant.contactUs,
                style: TextStyle(
                    color: AppColors.primaryColor, fontWeight: FontWeight.bold),
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
            padding: const EdgeInsets.fromLTRB(10, 10, 40, 10),
            child: FlatButton(
              child: Text(
                signup == false ? AppConstant.signUp : AppConstant.signIn,
              ),
              color: AppColors.primaryColor,
              textColor: Colors.white,
              onPressed: () {
                setState(() {
                  signup == false ? signup = true : signup = false;
                });
              },
            ),
          ),
        ],
      ),
      body: Row(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(26.0),
                  child: Text(
                    AppConstant.sloganHome,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 28),
                  ),
                ),
                CarouselSlider(
                  options: CarouselOptions(
                    autoPlay: true,
                    aspectRatio: 2.0,
                    enlargeCenterPage: true,
                  ),
                  items: imageSliders,
                ),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(120, 60, 120, 60),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: widget.themeNotifier.isDark
                          ? AppColors.hintTextColor
                          : AppColors.secondShadowPrimaryColor,
                      blurRadius: 3.0,
                    ),
                  ],
                  border: Border.all(
                    color: widget.themeNotifier.isDark
                        ? AppColors.hintTextColor
                        : AppColors.secondShadowPrimaryColor,
                  ),
                  color: widget.themeNotifier.isDark
                      ? AppColors.darkShadowSecondPrimaryColor
                      : AppColors.secondPrimaryColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  child: signup == false
                      ? ListView(
                          children: <Widget>[
                            Image.asset(
                              AppAssets.signin,
                              scale: 4,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: widget.themeNotifier.isDark
                                      ? AppColors.hintTextColor
                                      : AppColors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 10, top: 3, bottom: 3),
                                  child: TextFormField(
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: widget.themeNotifier.isDark
                                          ? AppColors.white
                                          : AppColors.hintTextColor,
                                    ),
                                    controller: emailAddController,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      hintText: AppConstant.emailAdd,
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                        fontSize: 20,
                                        color: widget.themeNotifier.isDark
                                            ? AppColors.white
                                            : AppColors.hintTextColor,
                                      ),
                                    ),
                                    onChanged: (val) {
                                      validateEmail(val);
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: widget.themeNotifier.isDark
                                      ? AppColors.hintTextColor
                                      : AppColors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 10, top: 3, bottom: 3),
                                  child: TextField(
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: widget.themeNotifier.isDark
                                          ? AppColors.white
                                          : AppColors.hintTextColor,
                                    ),
                                    controller: passWordController,
                                    obscureText: visibilityPassword,
                                    cursorColor: AppColors.primaryColor,
                                    decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          visibilityPassword == true
                                              ? setState(() {
                                                  visibilityPassword = false;
                                                })
                                              : setState(() {
                                                  visibilityPassword = true;
                                                });
                                        },
                                        icon: Icon(
                                          visibilityPassword == true
                                              ? Icons.remove_red_eye
                                              : Icons.remove_red_eye_outlined,
                                          color: visibilityPassword == true
                                              ? AppColors.primaryColor
                                              : AppColors.primaryColor,
                                        ),
                                      ),
                                      border: InputBorder.none,
                                      hintText: AppConstant.password,
                                      hintStyle: TextStyle(
                                        fontSize: 20,
                                        color: widget.themeNotifier.isDark
                                            ? AppColors.white
                                            : AppColors.hintTextColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 20, top: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      resetPassword(emailAddController.text);
                                    },
                                    child: Text(
                                      AppConstant.forgetPassword,
                                      style: TextStyle(
                                          color: AppColors.primaryColor),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 20, left: 100, right: 100),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  primary: AppColors.primaryColor,
                                  textStyle: TextStyle(
                                    fontSize: 20,
                                    color: AppColors.white,
                                  ),
                                ),
                                onPressed: () {
                                  if (_errorMessage == "Valid Email" &&
                                      passWordController.text.length >= 8) {
                                    signInWithEmailPassword(
                                        emailAddController.text,
                                        passWordController.text);
                                  } else {
                                    if (_errorMessage == "Valid Email") {
                                      Fluttertoast.showToast(
                                        msg: AppConstant.enterValidPassword,
                                        textColor: AppColors.white,
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: AppColors.white,
                                      );
                                    } else {
                                      if (passWordController.text.length >= 8) {
                                        Fluttertoast.showToast(
                                          msg: _errorMessage,
                                          textColor: AppColors.white,
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          backgroundColor: AppColors.white,
                                        );
                                      } else {
                                        if (_errorMessage ==
                                            "Invalid Email Address") {
                                          Fluttertoast.showToast(
                                            msg: _errorMessage,
                                            textColor: AppColors.white,
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            backgroundColor: AppColors.white,
                                          );
                                        } else {
                                          Fluttertoast.showToast(
                                            msg: AppConstant
                                                .bothPhaseAreRequired,
                                            textColor: AppColors.white,
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            backgroundColor: AppColors.white,
                                          );
                                        }
                                      }
                                    }
                                  }
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(90, 13, 90, 13),
                                  child: Text(
                                    AppConstant.signIn,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  height: 1,
                                  width: 200,
                                  color: AppColors.primaryColor,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: Text(
                                    "OR",
                                    style: TextStyle(
                                        color: AppColors.primaryColor),
                                  ),
                                ),
                                Container(
                                  height: 1,
                                  width: 200,
                                  color: AppColors.primaryColor,
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 20, 0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: widget.themeNotifier.isDark
                                          ? AppColors.hintTextColor
                                          : AppColors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0,
                                          right: 10,
                                          top: 3,
                                          bottom: 3),
                                      child: TextField(
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: widget.themeNotifier.isDark
                                              ? AppColors.white
                                              : AppColors.hintTextColor,
                                        ),
                                        controller: mobileController,
                                        keyboardType: TextInputType.number,
                                        cursorColor: AppColors.primaryColor,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: AppConstant.mobileNo,
                                          hintStyle: TextStyle(
                                            fontSize: 20,
                                            color: widget.themeNotifier.isDark
                                                ? AppColors.white
                                                : AppColors.hintTextColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                canShow
                                    ? Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 10, 20, 0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: widget.themeNotifier.isDark
                                                ? AppColors.hintTextColor
                                                : AppColors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0,
                                                right: 10,
                                                top: 3,
                                                bottom: 3),
                                            child: TextField(
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: widget
                                                        .themeNotifier.isDark
                                                    ? AppColors.white
                                                    : AppColors.hintTextColor,
                                              ),
                                              controller: otpToSignIn,
                                              keyboardType:
                                                  TextInputType.number,
                                              cursorColor:
                                                  AppColors.primaryColor,
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: "Enter OTP",
                                                hintStyle: TextStyle(
                                                  fontSize: 20,
                                                  color: widget
                                                          .themeNotifier.isDark
                                                      ? AppColors.white
                                                      : AppColors.hintTextColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                                !canShow
                                    ? buildSendOTPBtn("Send OTP")
                                    : buildSubmitBtn(context, "Submit"),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 30),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    AppConstant.dontHaveAccount,
                                    style: TextStyle(
                                        color: widget.themeNotifier.isDark
                                            ? AppColors.white
                                            : AppColors.black),
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        signup = true;
                                      });
                                    },
                                    child: Text(
                                      AppConstant.signUp,
                                      style: TextStyle(
                                          color: AppColors.primaryColor),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Image.asset(
                              AppAssets.signup,
                              scale: 4,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Flexible(
                              flex: 1,
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                      primary: AppColors.primaryColor),
                                  backgroundColor: widget.themeNotifier.isDark
                                      ? AppColors.darkPrimaryColor
                                      : AppColors.backgroundColor,
                                ),
                                child: Stepper(
                                    type: StepperType.horizontal,
                                    steps: getSteps(),
                                    currentStep: currentStep,
                                    onStepContinue: () async {
                                      final isLastStep =
                                          currentStep == getSteps().length - 1;
                                      if (isLastStep) {
                                        if (fullNameController.text == "" ||
                                            emailController.text == "" ||
                                            mobileNoController.text == "" ||
                                            dateOfBirth == "" ||
                                            dropdownValue ==
                                                AppConstant.selectGender ||
                                            userNameController.text == "") {
                                          Fluttertoast.showToast(
                                            msg:
                                                "Complete All Details of Previous Pages",
                                            textColor: AppColors.white,
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            backgroundColor: AppColors.white,
                                          );
                                        } else {
                                          setState(() {
                                            isCompleted = true;
                                          });
                                          print('Completed');
                                          if (_login == LoginType.directLogin) {
                                            setState(() {
                                              signup == false
                                                  ? signup = true
                                                  : signup = false;
                                            });
                                            registerWithEmailPassword(
                                                emailController.text,
                                                passwordController.text);

                                            Fluttertoast.showToast(
                                              msg: "Verify Email For Sign In",
                                              textColor: AppColors.white,
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              backgroundColor: AppColors.white,
                                            );
                                          } else {
                                            if (otpController.text == "") {
                                              Fluttertoast.showToast(
                                                msg: "Enter OTP",
                                                textColor: AppColors.white,
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                backgroundColor:
                                                    AppColors.white,
                                              );
                                            } else {
                                              FirebaseAuthentication()
                                                  .authenticateMe(
                                                      widget,
                                                      context,
                                                      temp,
                                                      otpController.text);
                                              database.storeUserData(
                                                  uid: uid,
                                                  name: fullNameController.text,
                                                  userName:
                                                      userNameController.text,
                                                  mobileNo:
                                                      mobileNoController.text,
                                                  gender: dropdownValue,
                                                  email: emailController.text,
                                                  dateOfBirth: dateOfBirth);
                                            }
                                          }
                                        }
                                      } else {
                                        if (currentStep == 0) {
                                          setState(() {
                                            currentStep += 1;
                                          });
                                        } else {
                                          if (currentStep == 1) {
                                            if (fullNameController.text == "" ||
                                                emailController.text == "" ||
                                                mobileNoController.text == "" ||
                                                dateOfBirth == "" ||
                                                userNameController.text == "" ||
                                                dropdownValue ==
                                                    AppConstant.selectGender) {
                                              Fluttertoast.showToast(
                                                msg: "Complete All Field",
                                                textColor: AppColors.white,
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                backgroundColor:
                                                    AppColors.white,
                                              );
                                            } else {
                                              if (_login ==
                                                  LoginType.directLogin) {
                                                if (passwordController.text !=
                                                    rePasswordController.text) {
                                                  Fluttertoast.showToast(
                                                    msg:
                                                        "Password Doesn\'t Match",
                                                    textColor: AppColors.white,
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    backgroundColor:
                                                        AppColors.white,
                                                  );
                                                } else {
                                                  setState(() {
                                                    currentStep += 1;
                                                  });
                                                }
                                              } else {
                                                setState(() {
                                                  currentStep += 1;
                                                });
                                                temp =
                                                    await FirebaseAuthentication()
                                                        .sendOTP(
                                                            mobileNoController
                                                                .text);
                                              }
                                            }
                                          } else {
                                            setState(() {
                                              currentStep += 1;
                                            });
                                          }
                                        }
                                      }
                                    },
                                    onStepTapped: (Step) {
                                      setState(() {
                                        currentStep = Step;
                                      });
                                    },
                                    onStepCancel: currentStep == 0
                                        ? null
                                        : () {
                                            setState(() {
                                              currentStep -= 1;
                                            });
                                          },
                                    controlsBuilder: (BuildContext context,
                                        ControlsDetails controls) {
                                      final isLastStep =
                                          currentStep == getSteps().length - 1;
                                      return SizedBox(
                                        height: 50,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            if (currentStep != 0)
                                              Expanded(
                                                child: ElevatedButton(
                                                  child: Text('Back'),
                                                  onPressed:
                                                      controls.onStepCancel,
                                                ),
                                              ),
                                            currentStep != 0
                                                ? SizedBox(
                                                    width: 20,
                                                  )
                                                : SizedBox(
                                                    width: 0,
                                                  ),
                                            currentStep != 0
                                                ? Expanded(
                                                    child: ElevatedButton(
                                                      child: Text(isLastStep
                                                          ? 'Confirm'
                                                          : 'Next'),
                                                      onPressed: controls
                                                          .onStepContinue,
                                                    ),
                                                  )
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 20,
                                                            right: 20),
                                                    child: Expanded(
                                                      child: ElevatedButton(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 80,
                                                                  right: 80),
                                                          child: Text(isLastStep
                                                              ? 'Confirm'
                                                              : 'Next'),
                                                        ),
                                                        onPressed: controls
                                                            .onStepContinue,
                                                      ),
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      );
                                    }),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void validateEmail(String val) {
    if (val.isEmpty) {
      setState(() {
        _errorMessage = "Please Enter Email";
      });
    } else if (!EmailValidator.validate(val, true)) {
      setState(() {
        _errorMessage = "Invalid Email Address";
      });
    } else {
      setState(() {
        _errorMessage = "Valid Email";
      });
    }
  }

  List<Step> getSteps() => [
        Step(
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 0,
          title: Text('Account Type'),
          content: page1(),
        ),
        Step(
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 1,
          title: Text('Personal Details'),
          content: page2(),
        ),
        Step(
          state: currentStep > 2 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 2,
          title: Text('User Details'),
          content: page3(),
        ),
      ];

  Widget page1() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppConstant.typeHead,
            style: TextStyle(
                fontSize: 20,
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold)),
        SizedBox(
          height: 15,
        ),
        ListTile(
          title: Text(
            AppConstant.directLogin,
            style: TextStyle(
              color: widget.themeNotifier.isDark
                  ? AppColors.white
                  : AppColors.black,
            ),
          ),
          leading: Radio(
            activeColor: AppColors.primaryColor,
            value: LoginType.directLogin,
            groupValue: _login,
            onChanged: (LoginType? value) {
              setState(() {
                _login = value!;
              });
            },
          ),
        ),
        ListTile(
          title: Text(
            AppConstant.authLogin,
            style: TextStyle(
              color: widget.themeNotifier.isDark
                  ? AppColors.white
                  : AppColors.black,
            ),
          ),
          leading: Radio(
            activeColor: AppColors.primaryColor,
            value: LoginType.authLogin,
            groupValue: _login,
            onChanged: (LoginType? value) {
              setState(() {
                _login = value!;
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 70, bottom: 30),
          child: Text(
            AppConstant.disclaimer,
            style: TextStyle(
              fontSize: 14,
              color: widget.themeNotifier.isDark
                  ? AppColors.white
                  : AppColors.hintTextColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget page2() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Container(
            decoration: BoxDecoration(
              color: widget.themeNotifier.isDark
                  ? AppColors.hintTextColor
                  : AppColors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10, top: 3, bottom: 3),
              child: TextField(
                style: TextStyle(
                  fontSize: 20,
                  color: widget.themeNotifier.isDark
                      ? AppColors.white
                      : AppColors.hintTextColor,
                ),
                controller: fullNameController,
                cursorColor: AppColors.primaryColor,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: AppConstant.fullName,
                  hintStyle: TextStyle(
                    fontSize: 20,
                    color: widget.themeNotifier.isDark
                        ? AppColors.white
                        : AppColors.hintTextColor,
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Container(
            decoration: BoxDecoration(
              color: widget.themeNotifier.isDark
                  ? AppColors.hintTextColor
                  : AppColors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10, top: 3, bottom: 3),
              child: TextField(
                style: TextStyle(
                  fontSize: 20,
                  color: widget.themeNotifier.isDark
                      ? AppColors.white
                      : AppColors.hintTextColor,
                ),
                controller: userNameController,
                cursorColor: AppColors.primaryColor,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: AppConstant.userName,
                  hintStyle: TextStyle(
                    fontSize: 20,
                    color: widget.themeNotifier.isDark
                        ? AppColors.white
                        : AppColors.hintTextColor,
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: GestureDetector(
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1950),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null) {
                String formattedDate =
                    DateFormat('dd/MM/yyyy').format(pickedDate);
                setState(() {
                  dateOfBirth = formattedDate;
                });
              } else {
                print("Date is not selected");
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: widget.themeNotifier.isDark
                    ? AppColors.hintTextColor
                    : AppColors.white,
                border: Border.all(
                  color: AppColors.white,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    dateOfBirth == ""
                        ? Text(
                            AppConstant.calender,
                            style: TextStyle(
                              fontSize: 19,
                              color: widget.themeNotifier.isDark
                                  ? AppColors.white
                                  : AppColors.hintTextColor,
                            ),
                          )
                        : Text(
                            dateOfBirth,
                            style: TextStyle(
                              fontSize: 19,
                              color: widget.themeNotifier.isDark
                                  ? AppColors.white
                                  : AppColors.hintTextColor,
                            ),
                          ),
                    Container(
                      height: 30,
                    ),
                    Icon(
                      Icons.date_range_rounded,
                      color: AppColors.primaryColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Container(
            decoration: BoxDecoration(
              color: widget.themeNotifier.isDark
                  ? AppColors.hintTextColor
                  : AppColors.white,
              border: Border.all(
                color: AppColors.white,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                DropdownButton(
                  value: dropdownValue,
                  icon: Icon(Icons.keyboard_arrow_down),
                  items: items.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(
                        items,
                        style: TextStyle(
                          color: widget.themeNotifier.isDark
                              ? AppColors.white
                              : AppColors.hintTextColor,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Container(
            decoration: BoxDecoration(
              color: widget.themeNotifier.isDark
                  ? AppColors.hintTextColor
                  : AppColors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10, top: 3, bottom: 3),
              child: TextField(
                style: TextStyle(
                  fontSize: 20,
                  color: widget.themeNotifier.isDark
                      ? AppColors.white
                      : AppColors.hintTextColor,
                ),
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                cursorColor: AppColors.primaryColor,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: AppConstant.emailId,
                  hintStyle: TextStyle(
                    fontSize: 20,
                    color: widget.themeNotifier.isDark
                        ? AppColors.white
                        : AppColors.hintTextColor,
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Container(
            decoration: BoxDecoration(
              color: widget.themeNotifier.isDark
                  ? AppColors.hintTextColor
                  : AppColors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10, top: 3, bottom: 3),
              child: TextField(
                style: TextStyle(
                  fontSize: 20,
                  color: widget.themeNotifier.isDark
                      ? AppColors.white
                      : AppColors.hintTextColor,
                ),
                controller: mobileNoController,
                keyboardType: TextInputType.number,
                cursorColor: AppColors.primaryColor,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: AppConstant.mobileNo,
                  hintStyle: TextStyle(
                    fontSize: 20,
                    color: widget.themeNotifier.isDark
                        ? AppColors.white
                        : AppColors.hintTextColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget page3() {
    return _login == LoginType.directLogin
        ? Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.themeNotifier.isDark
                        ? AppColors.hintTextColor
                        : AppColors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 10, top: 3, bottom: 3),
                    child: TextField(
                      style: TextStyle(
                        fontSize: 20,
                        color: widget.themeNotifier.isDark
                            ? AppColors.white
                            : AppColors.hintTextColor,
                      ),
                      controller: passwordController,
                      cursorColor: AppColors.primaryColor,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: AppConstant.password,
                        hintStyle: TextStyle(
                          fontSize: 20,
                          color: widget.themeNotifier.isDark
                              ? AppColors.white
                              : AppColors.hintTextColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                child: FlutterPwValidator(
                  successColor: AppColors.primaryColor,
                  failureColor: AppColors.hintTextColor,
                  controller: passwordController,
                  minLength: 8,
                  uppercaseCharCount: 1,
                  specialCharCount: 1,
                  width: 400,
                  height: 82,
                  onSuccess: () {
                    setState(() {
                      // checkPassword = true;
                    });
                    print("Matched");
                  },
                  onFail: () {
                    setState(() {
                      // checkPassword = false;
                    });
                    print("NOT MATCHED");
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.themeNotifier.isDark
                        ? AppColors.hintTextColor
                        : AppColors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 10, top: 3, bottom: 3),
                    child: TextField(
                      style: TextStyle(
                        fontSize: 20,
                        color: widget.themeNotifier.isDark
                            ? AppColors.white
                            : AppColors.hintTextColor,
                      ),
                      controller: rePasswordController,
                      cursorColor: AppColors.primaryColor,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: AppConstant.confirmPassword,
                        hintStyle: TextStyle(
                          fontSize: 20,
                          color: widget.themeNotifier.isDark
                              ? AppColors.white
                              : AppColors.hintTextColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        : Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.themeNotifier.isDark
                        ? AppColors.hintTextColor
                        : AppColors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 10, top: 3, bottom: 3),
                    child: TextField(
                      style: TextStyle(
                        fontSize: 20,
                        color: widget.themeNotifier.isDark
                            ? AppColors.white
                            : AppColors.hintTextColor,
                      ),
                      controller: otpController,
                      cursorColor: AppColors.primaryColor,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter OTP",
                        hintStyle: TextStyle(
                          fontSize: 20,
                          color: widget.themeNotifier.isDark
                              ? AppColors.white
                              : AppColors.hintTextColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
  }

  Widget buildSendOTPBtn(String text) => Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            primary: AppColors.primaryColor,
            textStyle: TextStyle(
              fontSize: 20,
              color: AppColors.white,
            ),
          ),
          onPressed: () async {
            setState(() {
              canShow = !canShow;
            });
            temp =
                await FirebaseAuthentication().sendOTP(mobileController.text);
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 50, right: 50),
            child: Text(text),
          ),
        ),
      );

  Widget buildSubmitBtn(BuildContext context, String text) => Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            primary: AppColors.primaryColor,
            textStyle: TextStyle(
              fontSize: 20,
              color: AppColors.white,
            ),
          ),
          onPressed: () {
            FirebaseAuthentication()
                .authenticateMe(widget, context, temp, otpToSignIn.text);
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 50, right: 50),
            child: Text(text),
          ),
        ),
      );
}

final List<Widget> imageSliders = imgList
    .map(
      (item) => Container(
        margin: EdgeInsets.all(5.0),
        child: ClipRRect(
          child: Stack(
            children: <Widget>[
              Image.network(item, fit: BoxFit.cover, width: 1000.0),
            ],
          ),
        ),
      ),
    )
    .toList();

final List<String> imgList = [
  AppAssets.docs,
  AppAssets.photo,
  AppAssets.music,
];
