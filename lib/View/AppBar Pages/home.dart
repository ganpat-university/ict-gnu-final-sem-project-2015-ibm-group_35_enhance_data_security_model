import 'package:enhance_security_model/Model/theme_model.dart';
import 'package:enhance_security_model/View%20Model/app_colors.dart';
import 'package:enhance_security_model/View%20Model/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder:
        (BuildContext context, ThemeModel themeNotifier, Widget? child) {
      return Scaffold(
        backgroundColor: AppColors.secondPrimaryColor,
        appBar: AppBar(
          backgroundColor: themeNotifier.isDark
              ? AppColors.darkShadowSecondPrimaryColor
              : AppColors.secondPrimaryColor,
          elevation: 0,
          title: Text(
            AppConstant.home,
            style: TextStyle(color: AppColors.primaryColor),
          ),
        ),
        body: Container(
          color: themeNotifier.isDark
              ? AppColors.darkShadowSecondPrimaryColor
              : AppColors.secondPrimaryColor,
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              children: [
                Text(
                  "Welcome to Secure Cloud Services.",
                  style: TextStyle(
                      fontSize: 32,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Lottie.asset('assets/lottie1.json',
                        repeat: true, animate: true, height: 600),
                    Lottie.asset('assets/lottie2.json',
                        repeat: true, animate: true, height: 600),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
