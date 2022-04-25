import 'dart:js' as js;

import 'package:enhance_security_model/Model/theme_model.dart';
import 'package:enhance_security_model/View%20Model/app_colors.dart';
import 'package:enhance_security_model/View%20Model/app_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({required this.themeNotifier}) : super();

  final ThemeModel themeNotifier;

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool gridView = true;
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<List<Map<String, dynamic>>> _loadImages() async {
    List<Map<String, dynamic>> files = [];
    final _userID = FirebaseAuth.instance.currentUser!.uid;
    print(_userID);

    final ListResult result =
        await storage.ref().child("$_userID/images/").list();
    final List<Reference> allFiles = result.items;

    await Future.forEach<Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();
      final FullMetadata fileMeta = await file.getMetadata();
      files.add({
        "url": fileUrl,
        "name": file.name,
        "path": file.fullPath,
        "type": "image",
      });
      print(files);
    });

    final ListResult result1 =
        await storage.ref().child("$_userID/audio-video/").list();
    final List<Reference> allFiles1 = result1.items;

    await Future.forEach<Reference>(allFiles1, (file) async {
      final String fileUrl = await file.getDownloadURL();
      print(fileUrl);
      final FullMetadata fileMeta = await file.getMetadata();
      print(file.name);
      files.add({
        "url": fileUrl,
        "name": file.name,
        "path": file.fullPath,
        "type": "audio-video",
      });
      print(files);
    });

    final ListResult result2 =
        await storage.ref().child("$_userID/files/").list();
    final List<Reference> allFiles2 = result2.items;

    await Future.forEach<Reference>(allFiles2, (file) async {
      final String fileUrl = await file.getDownloadURL();
      print(fileUrl);
      final FullMetadata fileMeta = await file.getMetadata();
      print(file.name);
      files.add({
        "url": fileUrl,
        "name": file.name,
        "path": file.fullPath,
        "type": "files",
      });
      print(files);
    });

    print(files);

    return files;
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
          AppConstant.dashBoard,
          style: TextStyle(color: AppColors.primaryColor),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 100),
            child: TextButton(
              onPressed: () {
                setState(() {
                  gridView == true ? gridView = false : gridView = true;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Icon(
                      gridView == false ? Icons.grid_on : Icons.list,
                      size: 20,
                      color: AppColors.primaryColor,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      gridView == false
                          ? AppConstant.gridview
                          : AppConstant.listview,
                      style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(50, 20, 50, 20),
        child: Column(
          children: [
            FutureBuilder(
                future: _loadImages(),
                builder: (context,
                    AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                  print("Connection Not Working");
                  if (snapshot.connectionState == ConnectionState.done) {
                    print("Connection Working");
                    print(snapshot.data);
                    return gridView == true
                        ? SizedBox(
                            height: 700,
                            child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                ),
                                itemCount: snapshot.data?.length ?? 0,
                                itemBuilder: (context, index) {
                                  final Map<String, dynamic> image =
                                      snapshot.data![index];
                                  return Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 10, 20, 40),
                                    child: Listener(
                                      // onPointerDown: _onPointerDown,
                                      child: Card(
                                        color: widget.themeNotifier.isDark
                                            ? AppColors.hintTextColor
                                            : AppColors.white,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 1,
                                            ),
                                            Icon(
                                              image['type'] == "image"
                                                  ? Icons.image_outlined
                                                  : image['type'] ==
                                                          "audio-video"
                                                      ? Icons
                                                          .music_video_rounded
                                                      : Icons
                                                          .file_copy_outlined,
                                              color: AppColors.primaryColor,
                                              size: 100,
                                            ),
                                            SizedBox(
                                              height: 1,
                                            ),
                                            Text(
                                              image['name'],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: AppColors.primaryColor,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 1,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                IconButton(
                                                  icon: Icon(
                                                      Icons.download_outlined),
                                                  onPressed: () {
                                                    js.context.callMethod(
                                                        'open', [image['url']]);
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                          content: Text(
                                                              'Download Successfully'),
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating),
                                                    );
                                                  },
                                                ),
                                                IconButton(
                                                  icon: Icon(
                                                      Icons.delete_outline),
                                                  onPressed: () {
                                                    showDialog<String>(
                                                      context: context,
                                                      builder: (BuildContext
                                                              context) =>
                                                          AlertDialog(
                                                        title: Text(
                                                          'Delete',
                                                          style: TextStyle(
                                                              color: AppColors
                                                                  .primaryColor),
                                                        ),
                                                        content: Text(
                                                            'Are you sure you want to delete it?'),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    context,
                                                                    'Cancel'),
                                                            child: Text(
                                                              'Cancel',
                                                              style: TextStyle(
                                                                  color: AppColors
                                                                      .primaryColor),
                                                            ),
                                                          ),
                                                          TextButton(
                                                            onPressed:
                                                                () async {
                                                              final desertRef =
                                                                  storage
                                                                      .ref()
                                                                      .child(image[
                                                                          'path']);
                                                              await desertRef
                                                                  .delete();
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                SnackBar(
                                                                    content: Text(
                                                                        'Delete Successfully'),
                                                                    behavior:
                                                                        SnackBarBehavior
                                                                            .floating),
                                                              );
                                                              Navigator.pop(
                                                                  context,
                                                                  'Delete');
                                                            },
                                                            child: Text(
                                                              'Delete',
                                                              style: TextStyle(
                                                                  color: AppColors
                                                                      .primaryColor),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          )
                        : SizedBox(
                            height: 700,
                            child: ListView.builder(
                                itemCount: snapshot.data?.length ?? 0,
                                itemBuilder: (context, index) {
                                  final Map<String, dynamic> image =
                                      snapshot.data![index];
                                  return Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 10, 20, 10),
                                    child: Listener(
                                      // onPointerDown: _onPointerDown,
                                      child: Card(
                                        color: widget.themeNotifier.isDark
                                            ? AppColors.hintTextColor
                                            : AppColors.white,
                                        child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 10, 0, 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 50),
                                                child: Icon(
                                                  image['type'] == "image"
                                                      ? Icons.image_outlined
                                                      : image['type'] ==
                                                              "audio-video"
                                                          ? Icons
                                                              .music_video_rounded
                                                          : Icons
                                                              .file_copy_outlined,
                                                  color: AppColors.primaryColor,
                                                  size: 40,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 1,
                                              ),
                                              Text(
                                                "${image['name']}",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: AppColors.primaryColor,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 1,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  IconButton(
                                                    icon: Icon(Icons
                                                        .download_outlined),
                                                    onPressed: () {
                                                      js.context.callMethod(
                                                          'open',
                                                          [image['url']]);
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                            content: Text(
                                                                'Download Successfully'),
                                                            behavior:
                                                                SnackBarBehavior
                                                                    .floating),
                                                      );
                                                    },
                                                  ),
                              SizedBox(
                                                    width: 120,
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                        Icons.delete_outline),
                                                    onPressed: () {
                                                      showDialog<String>(
                                                        context: context,
                                                        builder: (BuildContext
                                                        context) =>
                                                            AlertDialog(
                                                              title: Text(
                                                                'Delete',
                                                                style: TextStyle(
                                                                    color: AppColors
                                                                        .primaryColor),
                                                              ),
                                                              content: Text(
                                                                  'Are you sure you want to delete it?'),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          context,
                                                                          'Cancel'),
                                                                  child: Text(
                                                                    'Cancel',
                                                                    style: TextStyle(
                                                                        color: AppColors
                                                                            .primaryColor),
                                                                  ),
                                                                ),
                                                                TextButton(
                                                                  onPressed:
                                                                      () async {
                                                                    final desertRef =
                                                                    storage
                                                                        .ref()
                                                                        .child(image[
                                                                    'path']);
                                                                    await desertRef
                                                                        .delete();
                                                                    ScaffoldMessenger
                                                                        .of(context)
                                                                        .showSnackBar(
                                                                      SnackBar(
                                                                          content: Text(
                                                                              'Delete Successfully'),
                                                                          behavior:
                                                                          SnackBarBehavior
                                                                              .floating),
                                                                    );
                                                                    Navigator.pop(
                                                                        context,
                                                                        'Delete');
                                                                  },
                                                                  child: Text(
                                                                    'Delete',
                                                                    style: TextStyle(
                                                                        color: AppColors
                                                                            .primaryColor),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                      );
                                                    },
                                                  ),
                                                  SizedBox(
                                                    width: 50,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          );
                  }
                  return Center(
                    child: Lottie.asset('assets/lottie.json',
                        repeat: true, animate: true),
                  );
                }),
          ],
        ),
      ),
    );
  }

// Future<void> _onPointerDown(PointerDownEvent event) async {
//   if (event.kind == PointerDeviceKind.mouse &&
//       event.buttons == kSecondaryMouseButton) {
//     final overlay =
//         Overlay.of(context)?.context.findRenderObject() as RenderBox;
//     final menuItem = await showMenu<int>(
//         context: context,
//         color: widget.themeNotifier.isDark
//             ? AppColors.darkShadowSecondPrimaryColor
//             : AppColors.white,
//         items: [
//           PopupMenuItem(
//               onTap: () async {},
//               child: Row(
//                 children: [
//                   Icon(
//                     Icons.folder_open,
//                     color: widget.themeNotifier.isDark
//                         ? AppColors.white
//                         : AppColors.black,
//                   ),
//                   SizedBox(
//                     width: 10,
//                   ),
//                   Text(
//                     'View',
//                     style: TextStyle(
//                       color: widget.themeNotifier.isDark
//                           ? AppColors.white
//                           : AppColors.black,
//                     ),
//                   ),
//                   SizedBox(
//                     width: 50,
//                   ),
//                 ],
//               ),
//               value: 1),
//           PopupMenuItem(
//               onTap: () async {},
//               child: Row(
//                 children: [
//                   Icon(
//                     Icons.cloud_download_outlined,
//                     color: widget.themeNotifier.isDark
//                         ? AppColors.white
//                         : AppColors.black,
//                   ),
//                   SizedBox(
//                     width: 10,
//                   ),
//                   Text(
//                     'Download',
//                     style: TextStyle(
//                       color: widget.themeNotifier.isDark
//                           ? AppColors.white
//                           : AppColors.black,
//                     ),
//                   ),
//                   SizedBox(
//                     width: 50,
//                   ),
//                 ],
//               ),
//               value: 2),
//           PopupMenuItem(
//               onTap: () async {},
//               child: Row(
//                 children: [
//                   Icon(
//                     Icons.delete_outline,
//                     color: widget.themeNotifier.isDark
//                         ? AppColors.white
//                         : AppColors.black,
//                   ),
//                   SizedBox(
//                     width: 10,
//                   ),
//                   Text(
//                     'Delete',
//                     style: TextStyle(
//                       color: widget.themeNotifier.isDark
//                           ? AppColors.white
//                           : AppColors.black,
//                     ),
//                   ),
//                   SizedBox(
//                     width: 50,
//                   ),
//                 ],
//               ),
//               value: 3),
//         ],
//         position: RelativeRect.fromSize(
//             event.position & Size(48.0, 48.0), overlay.size));
//     switch (menuItem) {
//       case 1:
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Clicked on View'),
//             behavior: SnackBarBehavior.floating,
//           ),
//         );
//         break;
//       case 2:
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             content: Text('Clicked on Download'),
//             behavior: SnackBarBehavior.floating));
//         break;
//       case 3:
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             content: Text('Clicked on Delete'),
//             behavior: SnackBarBehavior.floating));
//         break;
//       default:
//     }
//   }
// }
}
