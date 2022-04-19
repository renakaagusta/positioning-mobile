import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:positioning/ui/sign_up.dart';
import 'package:provider/provider.dart';
import 'package:positioning/constant/assets.dart';
import 'package:positioning/constant/colors.dart';
import 'package:positioning/data/model/auth.dart';
import 'package:positioning/provider/auth/auth_provider.dart';
import 'package:positioning/ui/dashboard.dart';
import 'package:positioning/ui/sign_in.dart';
import 'package:positioning/widgets/elevated_button.dart';
import 'package:positioning/widgets/outlined_button.dart';

class ReportListPage extends StatefulWidget {
  static const routeName = '/report_list';

  const ReportListPage({Key? key}) : super(key: key);

  @override
  _ReportListPageState createState() => _ReportListPageState();
}

class _ReportListPageState extends State<ReportListPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.black,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(
          body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('ReportList',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold)),
                  Hero(
                    tag: AppAsset.welcomeIllustration,
                    child: Image.asset(
                      AppAsset.welcomeIllustration,
                      height: 250,
                      width: 250,
                    ),
                  ),
                  Column(
                    children: [
                      AppOutlinedButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(SignInPage.routeName);
                          },
                          text: 'Sign In',
                          color: AppColor.primaryColor),
                      AppElevatedButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(SignUpPage.routeName);
                          },
                          text: 'Sign Up',
                          color: Colors.white),
                    ],
                  )
                ],
              )),
        ));
  }
}
