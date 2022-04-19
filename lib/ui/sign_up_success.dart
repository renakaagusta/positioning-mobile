import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:positioning/constant/assets.dart';
import 'package:positioning/constant/colors.dart';
import 'package:positioning/constant/strings.dart';
import 'package:positioning/ui/sign_in.dart';
import 'package:positioning/widgets/elevated_button.dart';

class SignUpSuccessPage extends StatefulWidget {
  static const routeName = '/sign_up_success';

  const SignUpSuccessPage({Key? key}) : super(key: key);

  @override
  _SignUpSuccessPageState createState() => _SignUpSuccessPageState();
}

class _SignUpSuccessPageState extends State<SignUpSuccessPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.black,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        child: Scaffold(
          backgroundColor: AppColor.primaryColor,
          body: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(),
                  Column(
                    children: [
                      SizedBox(height: 20),
                      Image.asset(
                        AppAsset.checkmarkIcon,
                        height: 100,
                        width: 100,
                      ),
                      const SizedBox(height: 20),
                      RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(color: Colors.white),
                            children: const <TextSpan>[
                              TextSpan(
                                  text:
                                      'Akun anda berhasil teregistrasi di aplikasi '),
                              TextSpan(
                                  text: AppString.appName,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold)),
                            ],
                          ))
                    ],
                  ),
                  AppElevatedButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(SignInPage.routeName);
                    },
                    text: 'Masuk',
                    color: AppColor.primaryColor,
                    backgroundColor: Colors.white,
                  )
                ],
              )),
        ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}
