import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:positioning/constant/colors.dart';
import 'package:positioning/data/model/user.dart';
import 'package:positioning/helpers/provider.dart';
import 'package:positioning/provider/auth/auth_provider.dart';
import 'package:positioning/provider/user/user_profile_provider.dart';
import 'package:positioning/ui/sign_up.dart';
import 'package:positioning/ui/welcome.dart';
import 'package:positioning/utils/result_state.dart';
import 'package:positioning/widgets/elevated_button.dart';
import 'package:positioning/widgets/outlined_button.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  static const routeName = '/profile';

  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(CupertinoIcons.person),
                      const SizedBox(
                        width: 10,
                      ),
                      Text('Profil',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Consumer<UserProfileProvider>(builder: (context, state, _) {
                    if (state.state == ResultState.Loading) {
                    } else if (state.state == ResultState.Loading) {
                    } else if (state.state == ResultState.HasData) {
                      User user = state.resultUserProfile!;
                      return Column(
                        children: [
                          Text('Nama lengkap',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(user.name!),
                          const SizedBox(
                            height: 20,
                          ),
                          Text('Nama pengguna',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(user.username!),
                          const SizedBox(
                            height: 20,
                          ),
                          Text('Email',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(user.email!),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      );
                    }
                    return Container();
                  }),
                  Column(
                    children: [
                      AppElevatedButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(SignUpPage.routeName);
                          },
                          icon: const Icon(CupertinoIcons.pencil),
                          text: 'Sunting profil',
                          color: Colors.white),
                      AppOutlinedButton(
                          onPressed: () async {
                            AppProviders.disposeAllDisposableProviders(context);
                            await Provider.of<AuthProvider>(context,
                                    listen: false)
                                .removeFromMemory();
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                WelcomePage.routeName, (route) => false);
                          },
                          icon: Icon(CupertinoIcons.chevron_back),
                          text: 'Keluar',
                          color: AppColor.primaryColor),
                    ],
                  )
                ],
              )),
        ));
  }
}
