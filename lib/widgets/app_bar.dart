import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:positioning/constant/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSize {
  String title;
  Color? backgroundColor;
  Color? color;
  List<Widget>? actions;

  CustomAppBar({required this.title, this.backgroundColor = Colors.white, this.color = Colors.black, this.actions = null});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
            iconTheme: const IconThemeData(color: Colors.black),
            centerTitle: true,
            title: Text(title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: color, fontWeight: FontWeight.bold)),
            backgroundColor: backgroundColor,
            actions: actions ?? [],));
  }

  @override
  // TODO: implement child
  Widget get child => throw UnimplementedError();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(60);
}
