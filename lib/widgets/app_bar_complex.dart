import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:positioning/constant/colors.dart';

class CustomAppBarComplex extends StatelessWidget implements PreferredSize {
  String title;
  bool boldTitle;
  Color? backgroundColor = AppColor.primaryColor;
  Color? color = Colors.black;
  Widget? stackChild;
  Widget? toolbarIcon;
  double? parentHeight;
  double? childTop;
  bool? showBackButton;

  CustomAppBarComplex(
      {required this.title,
      this.backgroundColor,
      this.color,
      this.stackChild,
      this.toolbarIcon,
      this.parentHeight = 180,
      this.childTop = 80,
      this.showBackButton = true,
      this.boldTitle = false});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        child: SizedBox(
            height: parentHeight,
            child: Stack(
              children: [
                Container(
                    height: 130,
                    padding: const EdgeInsets.only(
                        top: 50, bottom: 20, left: 20, right: 20),
                    decoration: BoxDecoration(color: backgroundColor),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (showBackButton == null || showBackButton == true)
                              GestureDetector(
                                child: const Icon(CupertinoIcons.chevron_back,
                                    color: Colors.white),
                                onTap: () => Navigator.of(context).pop(),
                              ),
                            Text(title,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    ?.copyWith(color: Colors.white, fontWeight: boldTitle ? FontWeight.bold : FontWeight.normal)),
                            stackChild != null
                                ? Align(
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: toolbarIcon,
                                      ),
                                    )
                                : SizedBox()
                          ],
                        )
                      ],
                    )),
                if (stackChild != null)
                  Positioned.fill(
                      top: childTop,
                      child: Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: stackChild,
                        ),
                      ))
              ],
            )),
        preferredSize: Size(MediaQuery.of(context).size.width, 200));
  }

  @override
  // TODO: implement child
  Widget get child => throw UnimplementedError();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(60);
}
