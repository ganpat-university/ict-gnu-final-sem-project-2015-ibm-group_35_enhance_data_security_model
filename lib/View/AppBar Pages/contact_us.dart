import 'package:enhance_security_model/Model/theme_model.dart';
import 'package:enhance_security_model/View%20Model/app_assets.dart';
import 'package:enhance_security_model/View%20Model/app_colors.dart';
import 'package:enhance_security_model/View%20Model/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
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
            AppConstant.contactUs,
            style: TextStyle(color: AppColors.primaryColor),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AppAssets.contact),
                opacity: 0.4,
                alignment: Alignment.bottomCenter),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Text(
                  AppConstant.contactDes,
                  style: TextStyle(
                    fontSize: 24,
                    color: themeNotifier.isDark
                        ? AppColors.white
                        : Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
