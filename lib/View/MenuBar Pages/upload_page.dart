import 'dart:typed_data';

import 'package:enhance_security_model/Model/theme_model.dart';
import 'package:enhance_security_model/View%20Model/app_colors.dart';
import 'package:enhance_security_model/View%20Model/app_constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class Upload extends StatefulWidget {
  const Upload({required this.themeNotifier, this.uid}) : super();
  final ThemeModel themeNotifier;
  final String? uid;

  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  double progress = 0.0;
  bool visible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    visible;
    progress;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.themeNotifier.isDark
          ? AppColors.darkShadowSecondPrimaryColor
          : AppColors.secondPrimaryColor,
      appBar: AppBar(
        backgroundColor: widget.themeNotifier.isDark
            ? AppColors.darkShadowSecondPrimaryColor
            : AppColors.secondPrimaryColor,
        elevation: 0,
        title: Text(
          AppConstant.uploadFiles,
          style: TextStyle(color: AppColors.primaryColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['jpg', 'jpeg', 'png'],
                    );
                    print(result?.files.single.size);
                    if (result != null) {
                      if (result.files.single.size <= 10485760) {
                        Uint8List? file = result.files.first.bytes;
                        String fileName = result.files.first.name;
                        setState(() {
                          visible = true;
                        });
                        UploadTask task = FirebaseStorage.instance
                            .ref()
                            .child("${widget.uid}/images/$fileName")
                            .putData(file!);
                        task.snapshotEvents.listen((event) {
                          setState(() {
                            progress = ((event.bytesTransferred.toDouble() /
                                        event.totalBytes.toDouble()) *
                                    100)
                                .roundToDouble();
                          });
                        });
                      } else {
                        Fluttertoast.showToast(
                          msg: 'File size is greater then 10MB',
                          textColor: AppColors.white,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: AppColors.white,
                        );
                      }
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 20, bottom: 20, left: 100, right: 100),
                    child: Text(
                      "Upload Image",
                      style: TextStyle(
                          color: widget.themeNotifier.isDark
                              ? AppColors.primaryColor
                              : AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['mp3', 'mp4', 'mkv', 'gif'],
                    );
                    print(result?.files.single.size);
                    if (result != null) {
                      if (result.files.single.size <= 10485760) {
                        Uint8List? file = result.files.first.bytes;
                        String fileName = result.files.first.name;
                        setState(() {
                          visible = true;
                        });
                        UploadTask task = FirebaseStorage.instance
                            .ref()
                            .child("${widget.uid}/audio-video/$fileName")
                            .putData(file!);
                        task.snapshotEvents.listen((event) {
                          setState(() {
                            progress = ((event.bytesTransferred.toDouble() /
                                        event.totalBytes.toDouble()) *
                                    100)
                                .roundToDouble();

                            print(progress);
                          });
                        });
                      } else {
                        Fluttertoast.showToast(
                          msg: 'File size is greater then 10MB',
                          textColor: AppColors.white,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: AppColors.white,
                        );
                      }
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 20, bottom: 20, left: 100, right: 100),
                    child: Text(
                      "Upload Audio/Video",
                      style: TextStyle(
                          color: widget.themeNotifier.isDark
                              ? AppColors.primaryColor
                              : AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: [
                        'pdf',
                        'word',
                        'excel',
                        'pptx',
                        'io',
                        'jar',
                        'zip',
                        'rar'
                      ],
                    );
                    if (result != null) {
                      if (result.files.single.size <= 10485760) {
                        Uint8List? file = result.files.first.bytes;
                        String fileName = result.files.first.name;
                        setState(() {
                          visible = true;
                        });

                        UploadTask task = FirebaseStorage.instance
                            .ref()
                            .child("${widget.uid}/files/$fileName")
                            .putData(file!);
                        task.snapshotEvents.listen((event) {
                          setState(() {
                            progress = ((event.bytesTransferred.toDouble() /
                                        event.totalBytes.toDouble()) *
                                    100)
                                .roundToDouble();

                            print(progress);
                          });
                        });
                      } else {
                        Fluttertoast.showToast(
                          msg: 'File size is greater then 10MB',
                          textColor: AppColors.white,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: AppColors.white,
                        );
                      }
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 20, bottom: 20, left: 100, right: 100),
                    child: Text(
                      "Upload Document",
                      style: TextStyle(
                          color: widget.themeNotifier.isDark
                              ? AppColors.primaryColor
                              : AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 100,
            ),
            Visibility(
              visible: visible,
              child: SizedBox(
                height: 200.0,
                width: 200.0,
                child: LiquidCircularProgressIndicator(
                  value: progress / 100,
                  valueColor: AlwaysStoppedAnimation(AppColors.primaryColor),
                  backgroundColor: widget.themeNotifier.isDark
                      ? AppColors.darkPrimaryColor
                      : Colors.white,
                  direction: Axis.vertical,
                  center: Text(
                    progress == 100 ? "Uploaded Successfully" : "$progress%",
                    style: TextStyle(
                      fontSize: 16,
                      color: progress == 100
                          ? AppColors.white
                          : AppColors.secondShadowPrimaryColor,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 1,
            ),
          ],
        ),
      ),
    );
  }
}
