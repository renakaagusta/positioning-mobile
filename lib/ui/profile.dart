import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:positioning/constant/colors.dart';
import 'package:positioning/data/model/user.dart';
import 'package:positioning/helpers/provider.dart';
import 'package:positioning/provider/auth/auth_provider.dart';
import 'package:positioning/provider/user/user_profile_provider.dart';
import 'package:positioning/ui/privacy.dart';
import 'package:positioning/ui/profile_edit.dart';
import 'package:positioning/ui/sign_in.dart';
import 'package:positioning/ui/version.dart';
import 'package:positioning/ui/welcome.dart';
import 'package:positioning/utils/result_state.dart';
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
            body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              Consumer<UserProfileProvider>(builder: (context, state, _) {
                if (state.state == ResultState.Loading) {
                  return Container();
                } else if (state.state == ResultState.Loading) {
                  return Container();
                } else if (state.state == ResultState.HasData) {
                  User user = state.resultUserProfile!;
                  final size = MediaQuery.of(context).size;
                  return Stack(
                    children: [
                      SingleChildScrollView(
                        child: Container(
                          child: Column(children: [
                            if (user != null)
                              Container(
                                padding: const EdgeInsets.only(
                                    top: 60, bottom: 40, left: 20, right: 20),
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    AppColor.primaryColor,
                                    AppColor.secondaryColor
                                  ]),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 80,
                                          width: 80,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                            child: user.meta['photo'] != null
                                                ? CachedNetworkImage(
                                                    imageUrl:
                                                        user.meta['photo'],
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        Container(
                                                      decoration: BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover,
                                                      )),
                                                    ),
                                                  )
                                                : CachedNetworkImage(
                                                    imageUrl:
                                                        'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png',
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        Container(
                                                      decoration: BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover,
                                                      )),
                                                    ),
                                                  ),
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              user.username != null
                                                  ? user.username!
                                                  : '',
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                                user.email != null
                                                    ? user.email!
                                                    : '',
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      child: const Icon(CupertinoIcons.pencil,
                                          color: Colors.white, size: 30),
                                      onTap: () async {
                                        await Navigator.of(context).pushNamed(
                                            ProfileEditPage.routeName);
                                        String? userId =
                                            Provider.of<AuthProvider>(context,
                                                    listen: false)
                                                .userId;
                                        if (userId != null) {
                                          Provider.of<UserProfileProvider>(
                                                  context,
                                                  listen: false)
                                              .getUserProfile(userId);
                                        }
                                      },
                                    )
                                  ],
                                ),
                              ),
                            Container(
                                decoration:
                                    const BoxDecoration(color: Colors.white),
                                padding: const EdgeInsets.only(
                                    left: 25, right: 25, top: 10.0, bottom: 20),
                                child: user != null
                                    ? user.username != null
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 20.0),
                                                  color: Colors.white,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        'Aplikasi',
                                                        style: TextStyle(
                                                            fontSize: 20.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      const SizedBox(
                                                          height: 20.0),
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .pushNamed(
                                                                  PrivacyPage
                                                                      .routeName);
                                                        },
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              child: const Icon(
                                                                  CupertinoIcons
                                                                      .shield,
                                                                  size: 30),
                                                            ),
                                                            const SizedBox(
                                                              width: 20.0,
                                                            ),
                                                            const Text(
                                                                'Kebijakan dan Privasi',
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        18.0))
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 20.0),
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .pushNamed(
                                                                  VersionPage
                                                                      .routeName);
                                                        },
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              child: const Icon(
                                                                  CupertinoIcons
                                                                      .info_circle,
                                                                  size: 30),
                                                            ),
                                                            const SizedBox(
                                                              width: 20.0,
                                                            ),
                                                            const Text('Versi',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18.0))
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 30.0),
                                                      const Text(
                                                        'Navigasi',
                                                        style: const TextStyle(
                                                            fontSize: 20.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      const SizedBox(
                                                          height: 20.0),
                                                      Row(
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () async {
                                                              AppProviders
                                                                  .disposeAllDisposableProviders(
                                                                      context);
                                                              await Provider.of<
                                                                          AuthProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .removeFromMemory();
                                                              Navigator.of(
                                                                      context)
                                                                  .pushNamedAndRemoveUntil(
                                                                      WelcomePage
                                                                          .routeName,
                                                                      (route) =>
                                                                          false);
                                                            },
                                                            child: Container(
                                                              child: const Icon(
                                                                  CupertinoIcons
                                                                      .arrow_left),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 20.0,
                                                          ),
                                                          const Text('Sign out',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      18.0))
                                                        ],
                                                      ),
                                                    ],
                                                  )),
                                            ],
                                          )
                                        : Container()
                                    : const Center(
                                        child: CircularProgressIndicator(
                                          color: AppColor.primaryColor,
                                        ),
                                      )),
                          ]),
                        ),
                      ),
                    ],
                  );
                }
                return Container();
              }),
            ])));
  }
}
