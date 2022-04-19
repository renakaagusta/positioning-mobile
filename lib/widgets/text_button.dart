import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:positioning/constant/colors.dart';

class AppTextButton extends StatelessWidget {
  String text;
  Color? color = AppColor.primaryColor;
  VoidCallback onPressed;

  AppTextButton({required this.text, this.color, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: onPressed, child: Text(text, style: TextStyle(color: color)));
  }
}