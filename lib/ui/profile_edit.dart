import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:positioning/constant/colors.dart';
import 'package:positioning/data/model/user.dart';
import 'package:positioning/provider/auth/auth_provider.dart';
import 'package:positioning/provider/user/user_profile_provider.dart';
import 'package:positioning/provider/user/user_update_data_provider.dart';
import 'package:positioning/provider/user/user_update_photo_provider.dart';
import 'package:positioning/utils/result_state.dart';
import 'package:provider/provider.dart';

class ProfileEditPage extends StatefulWidget {
  static const routeName = '/profile/edit';

  const ProfileEditPage({Key? key}) : super(key: key);

  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  TextEditingController captionController = TextEditingController();
  dynamic user;
  dynamic userResult;

  final picker = ImagePicker();

  TextEditingController fullnameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void changeImageProfile(File file) async {
    EasyLoading.show();
    Map<String, String> body = {'photo': file.path};
    String userId = Provider.of<AuthProvider>(context, listen: false).userId!;

    await Provider.of<UpdateUserPhotoProvider>(context, listen: false)
        .updateUserPhoto(userId, body);
    await Provider.of<UserProfileProvider>(context, listen: false)
        .getUserProfile(userId);

    EasyLoading.dismiss();
  }

  Future getImagefromGallery() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 20);
    setState(() {
      if (pickedFile != null) {
        changeImageProfile(File(pickedFile.path));
      } else {
        print('No image selected.');
      }
    });
  }

  void saveProfile() async {
    EasyLoading.show();
    String userId = await Provider.of<AuthProvider>(context, listen: false).userId!;
    await Provider.of<UserProfileProvider>(context, listen: false)
        .getUserProfile(userId);
    User user = Provider.of<UserProfileProvider>(context, listen: false)
        .resultUserProfile!;
    await Provider.of<UpdateUserDataProvider>(context, listen: false)
        .updateUserData(userId, {
      'username': usernameController.text,
      'name': fullnameController.text,
      'email': emailController.text,
      'password': passwordController.text.isEmpty
          ? user.password!
          : passwordController.text,
      'photo': user.meta['photo'],
      'role': user.role!
    });
    EasyLoading.dismiss();
    Navigator.of(context).pop();
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

                  usernameController.text = user.username!;
                  fullnameController.text = user.name!;
                  emailController.text = user.email!;

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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          height: 120,
                                          width: 120,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(60),
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
                                        Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: GestureDetector(
                                              onTap: () =>
                                                  getImagefromGallery(),
                                              child: Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40)),
                                                  child: const Icon(
                                                      CupertinoIcons.camera)),
                                            ))
                                      ],
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
                                    ? user.name != null
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
                                                      const Text('Username'),
                                                      TextFormField(
                                                        controller:
                                                            usernameController,
                                                      ),
                                                      const SizedBox(
                                                        height: 40,
                                                      ),
                                                      const Text('Fullname'),
                                                      TextFormField(
                                                        controller:
                                                        fullnameController,
                                                      ),
                                                      const SizedBox(
                                                        height: 40,
                                                      ),
                                                      const Text('Email'),
                                                      TextFormField(
                                                        controller:
                                                            emailController,
                                                      ),
                                                      const SizedBox(
                                                        height: 40,
                                                      ),
                                                      const Text('Password'),
                                                      TextFormField(
                                                        controller:
                                                            passwordController,
                                                      ),
                                                      const SizedBox(
                                                        height: 40,
                                                      ),
                                                      GestureDetector(
                                                        onTap: () =>
                                                            saveProfile(),
                                                        child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      20.0,
                                                                  vertical:
                                                                      10.0),
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              40,
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 20),
                                                          decoration:
                                                              const BoxDecoration(
                                                                  gradient:
                                                                      LinearGradient(
                                                                          colors: [
                                                                        AppColor
                                                                            .primaryColor,
                                                                        AppColor
                                                                            .primaryColor,
                                                                      ]),
                                                                  borderRadius:
                                                                      const BorderRadius
                                                                              .all(
                                                                          Radius.circular(
                                                                              5))),
                                                          child: const Text(
                                                            'Save',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 16.0),
                                                          ),
                                                        ),
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
