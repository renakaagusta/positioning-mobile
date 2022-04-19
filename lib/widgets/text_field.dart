import 'package:flutter/material.dart';
import 'package:positioning/constant/colors.dart';

// ignore: must_be_immutable
class AppTextField extends StatefulWidget {
  String hintText;
  FocusNode? focusNode;
  double? width;
  TextEditingController? controller;
  Icon? prefixIcon;
  bool? autoFocus;
  bool? obscureText;
  bool? sentencesIsCapital;

  AppTextField({Key? key, required this.hintText, this.focusNode, this.controller, this.prefixIcon, this.autoFocus, this.obscureText = false, this.width, this.sentencesIsCapital = true}) : super(key: key);

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  @override
  Widget build(BuildContext context) {
    return Align(alignment: Alignment.center,child: Container(
        height: 50,
        width: widget.width ?? MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 1, color: Colors.white70),
            borderRadius: BorderRadius.circular(5),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, 0),
                  spreadRadius: 1,
                  blurRadius: 2)
            ]),
        child: TextField(
          autofocus: widget.autoFocus != null?  widget.autoFocus! : false,
          textCapitalization: widget.obscureText == true || widget.sentencesIsCapital == false ? TextCapitalization.none : TextCapitalization.sentences,
          cursorColor: AppColor.primaryColor,
          controller: widget.controller,
          focusNode: widget.focusNode,
          decoration: InputDecoration(
              hintText: widget.hintText,
              prefixIcon:
              widget.prefixIcon,
              border: InputBorder.none),
          textAlign: TextAlign.left,
          obscureText: widget.obscureText!,
        )));
  }
}
