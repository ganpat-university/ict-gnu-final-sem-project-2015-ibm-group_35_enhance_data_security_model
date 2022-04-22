import 'package:enhance_security_model/View%20Model/app_colors.dart';
import 'package:enhance_security_model/View%20Model/app_constants.dart';
import 'package:enhance_security_model/View%20Model/firebase_global.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Model/theme_model.dart';

class CustomerSupport extends StatefulWidget {
  const CustomerSupport({Key? key, required this.uid}) : super(key: key);
  final String? uid;

  @override
  _CustomerSupportState createState() => _CustomerSupportState();
}

class _CustomerSupportState extends State<CustomerSupport> {
  Database database = Database();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController messageController = TextEditingController();

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
            AppConstant.customerSupport,
            style: TextStyle(color: AppColors.primaryColor),
          ),
        ),
        body: Column(
          children: <Widget>[
            Row(
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: themeNotifier.isDark
                            ? AppColors.hintTextColor
                            : AppColors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, right: 10, top: 0, bottom: 0),
                        child: TextField(
                          style: TextStyle(
                            fontSize: 20,
                            color: themeNotifier.isDark
                                ? AppColors.white
                                : AppColors.hintTextColor,
                          ),
                          controller: nameController,
                          cursorColor: AppColors.primaryColor,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: AppConstant.name,
                            hintStyle: TextStyle(
                              fontSize: 20,
                              color: themeNotifier.isDark
                                  ? AppColors.white
                                  : AppColors.hintTextColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: themeNotifier.isDark
                            ? AppColors.hintTextColor
                            : AppColors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, right: 10, top: 0, bottom: 0),
                        child: TextField(
                          style: TextStyle(
                            fontSize: 20,
                            color: themeNotifier.isDark
                                ? AppColors.white
                                : AppColors.hintTextColor,
                          ),
                          controller: emailController,
                          cursorColor: AppColors.primaryColor,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: AppConstant.emailId,
                            hintStyle: TextStyle(
                              fontSize: 20,
                              color: themeNotifier.isDark
                                  ? AppColors.white
                                  : AppColors.hintTextColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Container(
                decoration: BoxDecoration(
                  color: themeNotifier.isDark
                      ? AppColors.hintTextColor
                      : AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 10, top: 0, bottom: 0),
                  child: TextField(
                    maxLines: 7,
                    style: TextStyle(
                      fontSize: 20,
                      color: themeNotifier.isDark
                          ? AppColors.white
                          : AppColors.hintTextColor,
                    ),
                    controller: messageController,
                    cursorColor: AppColors.primaryColor,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: AppConstant.message,
                      hintStyle: TextStyle(
                        fontSize: 20,
                        color: themeNotifier.isDark
                            ? AppColors.white
                            : AppColors.hintTextColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40),
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
                  database.storeCustomerSupportData(
                    uid: widget.uid,
                    name: nameController.text,
                    email: emailController.text,
                    message: messageController.text,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(70, 10, 70, 10),
                  child: Text(
                    AppConstant.submit,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
