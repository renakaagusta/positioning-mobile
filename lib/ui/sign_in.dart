import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:positioning/constant/assets.dart';
import 'package:positioning/constant/colors.dart';
import 'package:positioning/provider/auth/auth_provider.dart';
import 'package:positioning/ui/dashboard.dart';
import 'package:positioning/ui/sign_up.dart';
import 'package:positioning/utils/result_state.dart';
import 'package:positioning/widgets/elevated_button.dart';
import 'package:positioning/widgets/outlined_button.dart';
import 'package:positioning/widgets/text_button.dart';
import 'package:positioning/widgets/text_field.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  static const routeName = '/sign_in';

  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.black,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        child: Scaffold(
            body: SingleChildScrollView(
                child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                LimitedBox(
                  maxHeight: 150,
                    child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        child: const Icon(CupertinoIcons.chevron_back),
                        onTap: () => Navigator.of(context).pop(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text('Login',
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text('Login into your account',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge),
                  ],
                )),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Username',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    AppTextField(
                      hintText: 'Username',
                      controller: usernameController,
                      sentencesIsCapital: false,
                    ),
                    const SizedBox(height: 30),
                    Text('Password',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    AppTextField(
                      hintText: 'Password',
                      controller: passwordController,
                      obscureText: true,
                    ),
                    const SizedBox(height: 15),
                  ],
                )),
                Expanded(
                    child: Column(
                  children: [
                    Consumer<AuthProvider>(builder: (context, state, _) {
                      if (state.state == ResultState.Loading) {
                        return AppElevatedButton(
                            backgroundColor: Colors.grey,
                            text: 'Masuk',
                            onPressed: () {});
                      } else if (state.state == ResultState.HasData) {
                        if (state.accessToken != null) {
                          Provider.of<AuthProvider>(context, listen: false)
                              .saveToMemory();
                          WidgetsBinding.instance?.addPostFrameCallback((_) =>
                              Navigator.of(context).pushReplacementNamed(
                                  DashboardPage.routeName));
                        } else {
                          EasyLoading.showInfo(state.error ??
                              "Username or password is not valid");
                        }
                      } else if (state.state == ResultState.Error) {
                        EasyLoading.showInfo(state.error ?? "Error");
                        state.disposeValues();
                      }

                      return AppElevatedButton(
                          onPressed: () =>
                              Provider.of<AuthProvider>(context, listen: false)
                                  .signIn({
                                'username': usernameController.text,
                                'password': passwordController.text
                              }),
                          text: 'Masuk');
                    }),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Don\'t have an account? ',
                            style: Theme.of(context).textTheme.bodyText1),
                        GestureDetector(child: Text('Sign Up',
                            style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.bold)),
                       onTap: ()=>Navigator.of(context).pushNamed(SignUpPage.routeName))
                      ],
                    ),
                    const SizedBox(height: 20),
                    Image.asset(
                      AppAsset.loginIllustration,
                      height: 140,
                      width: 240,
                    ),
                  ],
                ))
              ]),
        ))));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    usernameController.dispose();
    passwordController.dispose();
  }
}
