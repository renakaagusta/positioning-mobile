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

class WelcomePage extends StatefulWidget {
  static const routeName = '/welcome';

  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  void checkAuth() async {
    try {
      final Authentication auth =
          await Provider.of<AuthProvider>(context, listen: false)
              .readFromMemory();
      if (auth.accessToken != null) {
        Navigator.of(context).pushReplacementNamed(DashboardPage.routeName);
      }
    } catch (e) {
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) => checkAuth());
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
                  Text('Welcome',
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
