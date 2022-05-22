import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:positioning/constant/colors.dart';

class AppOutlinedButton extends StatelessWidget {
  String text;
  Icon? icon;
  Color? color = AppColor.primaryColor;
  VoidCallback onPressed;

  AppOutlinedButton(
      {required this.text, this.icon, this.color, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    List<Widget> content = [];
    if (icon != null) {
      content.add(icon!);
      content.add(const SizedBox(
        width: 10,
      ));
    }
    content.add(Text(text,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: color)));
    return OutlinedButton(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: content,
      ),
      style: OutlinedButton.styleFrom(
          primary: AppColor.primaryColor,
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(20.0),
          )),
    );
  }
}
