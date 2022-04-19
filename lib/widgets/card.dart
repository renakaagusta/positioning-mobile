// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  Widget content;
  Color backgroundColor;
  Color borderColor;
  bool useShadow;
  double? height;
  double? width;
  EdgeInsets? padding;

  AppCard(
      {Key? key,
      required this.content,
      this.backgroundColor = Colors.white,
      this.borderColor = Colors.black12,
      this.useShadow = true,
      this.height = null,
      this.width = null,
      this.padding = null})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        width: width ?? MediaQuery.of(context).size.width - 40,
        padding: padding ?? const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor, width: 1),
            borderRadius: BorderRadius.circular(5),
            boxShadow: useShadow
                ? [
                    const BoxShadow(
                        color: Colors.black12,
                        offset: Offset(
                          2,
                          2,
                        ),
                        blurRadius: 2)
                  ]
                : []),
        child: content);
  }
}
