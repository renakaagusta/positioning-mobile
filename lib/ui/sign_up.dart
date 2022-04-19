import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:positioning/provider/user/sign_up_provider.dart';
import 'package:positioning/ui/sign_up_success.dart';
import 'package:positioning/utils/result_state.dart';
import 'package:positioning/widgets/app_bar.dart';
import 'package:positioning/widgets/card.dart';
import 'package:positioning/widgets/elevated_button.dart';
import 'package:positioning/widgets/text_field.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  static const routeName = '/sign_up';

  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late TextEditingController usernameController;
  late TextEditingController fullnameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController passwordConfirmationController;

  @override
  void initState() {
    super.initState();

    usernameController = TextEditingController();
    fullnameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    passwordConfirmationController = TextEditingController();
  }

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
            appBar: CustomAppBar(title: 'Registrasi'),
            body: Stack(
              children: [
                Container(
                    height: MediaQuery.of(context).size.height,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          Text('Formulir Pendaftaran',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 30),
                          Text('Nama Pengguna',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(
                            height: 10,
                          ),
                          AppTextField(
                            hintText: 'Nama Pengguna',
                            controller: usernameController,
                            width: MediaQuery.of(context).size.width - 42,
                          ),
                          const SizedBox(height: 30),
                          Text('Nama Lengkap',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(
                            height: 10,
                          ),
                          AppTextField(
                            hintText: 'Nama Lengkap',
                            controller: fullnameController,
                            width: MediaQuery.of(context).size.width - 42,
                          ),
                          const SizedBox(height: 30),
                          Text('Email',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(
                            height: 10,
                          ),
                          AppTextField(
                            hintText: 'Email',
                            controller: emailController,
                            width: MediaQuery.of(context).size.width - 42,
                          ),
                          const SizedBox(height: 30),
                          Text('Password',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(
                            height: 10,
                          ),
                          AppTextField(
                            hintText: 'Password',
                            controller: passwordController,
                            obscureText: true,
                            width: MediaQuery.of(context).size.width - 42,
                          ),
                          const SizedBox(height: 30),
                          Text('Konfirmasi Password',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(
                            height: 10,
                          ),
                          AppTextField(
                            hintText: 'Konfirmasi Password',
                            controller: passwordConfirmationController,
                            obscureText: true,
                            width: MediaQuery.of(context).size.width - 42,
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    )),
                Positioned(
                    bottom: 0,
                    left: 0,
                    child: AppCard(
                        width: MediaQuery.of(context).size.width,
                        content: ChangeNotifierProvider<SignUpProvider>(
                            create: (_) => SignUpProvider(),
                            child: Consumer<SignUpProvider>(
                                builder: (context, state, _) {
                              if (state.state == ResultState.Loading) {
                                return AppElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushNamed(SignUpPage.routeName);
                                    },
                                    text: 'Registrasi');
                              } else if (state.state == ResultState.HasData) {
                                if (state.userId != null) {
                                  Provider.of<SignUpProvider>(context,
                                          listen: false)
                                      .disposeValues();
                                  WidgetsBinding.instance?.addPostFrameCallback(
                                      (_) => Navigator.of(context)
                                          .pushReplacementNamed(
                                              SignUpSuccessPage.routeName));
                                } else {
                                  EasyLoading.showInfo(
                                      'Gagal melakukan registrasi');
                                }
                              } else if (state.state == ResultState.Error) {
                                EasyLoading.showInfo(state.error ?? '');
                              }

                              return Consumer(
                                builder: (context, state, _) {
                                  return AppElevatedButton(
                                      onPressed: () {
                                        if (usernameController.text.isEmpty) {
                                          EasyLoading.showInfo(
                                              "Nama pengguna belum diisi");
                                          return;
                                        }

                                        if (fullnameController.text.isEmpty) {
                                          EasyLoading.showInfo(
                                              "Nama lengkap belum diisi");
                                          return;
                                        }

                                        if (emailController.text.isEmpty) {
                                          EasyLoading.showInfo(
                                              "Email belum diisi");
                                          return;
                                        }

                                        if (passwordController.text.isEmpty) {
                                          EasyLoading.showInfo(
                                              "Password belum diisi");
                                          return;
                                        }

                                        if (passwordController.text !=
                                            passwordConfirmationController
                                                .text) {
                                          EasyLoading.showInfo(
                                              "Konfirmasi password berbeda");
                                          return;
                                        }

                                        Provider.of<SignUpProvider>(context,
                                                listen: false)
                                            .signUp({
                                          'username': fullnameController.text,
                                          'name': fullnameController.text,
                                          'email': emailController.text,
                                          'password': passwordController.text,
                                          'role': 'rider'
                                        });
                                      },
                                      text: 'Registrasi');
                                },
                              );
                            })))),
              ],
            )));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}
