// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';

class AppLine extends StatelessWidget {
  Color? color;

  AppLine({Key? key, this.color = Colors.black26}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 1,
        color: color,
        width: MediaQuery.of(context).size.width);
  } 
}
