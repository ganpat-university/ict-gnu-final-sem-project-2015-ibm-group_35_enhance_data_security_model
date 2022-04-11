import 'package:enhance_security_model/Model/theme_model.dart';
import 'package:enhance_security_model/View%20Model/app_colors.dart';
import 'package:enhance_security_model/View%20Model/app_constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Trash extends StatefulWidget {
  const Trash({Key? key, required this.themeNotifier}) : super(key: key);

  final ThemeModel themeNotifier;

  @override
  _TrashState createState() => _TrashState();
}

class _TrashState extends State<Trash> {
  bool gridView = true;

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
          AppConstant.trash,
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
        child: gridView == true
            ? GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                ),
                itemCount: 7,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
                    child: Listener(
                      onPointerDown: _onPointerDown,
                      child: Card(
                        color: widget.themeNotifier.isDark
                            ? AppColors.hintTextColor
                            : AppColors.white,
                        child: Center(child: Text('$index')),
                      ),
                    ),
                  );
                })
            : ListView.builder(
                itemCount: 7,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Listener(
                      onPointerDown: _onPointerDown,
                      child: Card(
                        color: widget.themeNotifier.isDark
                            ? AppColors.hintTextColor
                            : AppColors.white,
                        child: Center(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('$index'),
                        )),
                      ),
                    ),
                  );
                }),
      ),
    );
  }

  Future<void> _onPointerDown(PointerDownEvent event) async {
    if (event.kind == PointerDeviceKind.mouse &&
        event.buttons == kSecondaryMouseButton) {
      final overlay =
          Overlay.of(context)?.context.findRenderObject() as RenderBox;
      final menuItem = await showMenu<int>(
          context: context,
          color: widget.themeNotifier.isDark
              ? AppColors.darkShadowSecondPrimaryColor
              : AppColors.white,
          items: [
            PopupMenuItem(
                onTap: () async {},
                child: Row(
                  children: [
                    Icon(
                      Icons.folder_open,
                      color: widget.themeNotifier.isDark
                          ? AppColors.white
                          : AppColors.black,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Restore',
                      style: TextStyle(
                        color: widget.themeNotifier.isDark
                            ? AppColors.white
                            : AppColors.black,
                      ),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                  ],
                ),
                value: 1),
            PopupMenuItem(
                onTap: () async {},
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_outline,
                      color: widget.themeNotifier.isDark
                          ? AppColors.white
                          : AppColors.black,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Delete Permanently ',
                      style: TextStyle(
                        color: widget.themeNotifier.isDark
                            ? AppColors.white
                            : AppColors.black,
                      ),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                  ],
                ),
                value: 2),
          ],
          position: RelativeRect.fromSize(
              event.position & Size(48.0, 48.0), overlay.size));
      switch (menuItem) {
        case 1:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Restore File'),
              behavior: SnackBarBehavior.floating,
            ),
          );
          break;
        case 2:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Permanently Deleted'),
              behavior: SnackBarBehavior.floating,
            ),
          );
          break;
        default:
      }
    }
  }
}
