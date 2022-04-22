import 'package:enhance_security_model/View%20Model/app_assets.dart';
import 'package:enhance_security_model/View%20Model/app_colors.dart';
import 'package:enhance_security_model/View%20Model/app_constants.dart';
import 'package:flutter/material.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondPrimaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        title: Text(
          AppConstant.aboutUs,
          style: TextStyle(color: AppColors.white),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(AppAssets.about),
              opacity: 0.4,
              alignment: Alignment.bottomCenter),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: Text(
                AppConstant.aboutDes,
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
