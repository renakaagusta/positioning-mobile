import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:positioning/constant/colors.dart';

class AppElevatedButton extends StatelessWidget {
  String text;
  Icon? icon;
  Color? color;
  Color? backgroundColor;
  VoidCallback onPressed;
  bool? loading;

  AppElevatedButton(
      {required this.text,
      this.icon,
      this.color = Colors.white,
      this.backgroundColor = AppColor.primaryColor,
      required this.onPressed,
      this.loading = false});

  @override
  Widget build(BuildContext context) {
    List<Widget> content = [];
    if (loading == true) {
      content.add(CircularProgressIndicator(
        valueColor: const AlwaysStoppedAnimation(Colors.white),
        backgroundColor: backgroundColor,
        strokeWidth: 3,
      ));
    }

    if (icon != null) {
      content.add(icon!);
      content.add(const SizedBox(
        width: 10,
      ));
    }

    content.add(Text(text,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: color)));

    return ElevatedButton(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: content,
      ),
      style: ElevatedButton.styleFrom(
        primary: backgroundColor,
      ),
    );
  }
}