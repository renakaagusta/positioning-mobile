import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:positioning/constant/colors.dart';
import 'package:positioning/provider/auth/auth_provider.dart';
import 'package:positioning/provider/user/user_profile_provider.dart';
import 'package:positioning/ui/home.dart';
import 'package:positioning/ui/hospital_list.dart';
import 'package:positioning/ui/police_list.dart';
import 'package:positioning/ui/profile.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  static const routeName = '/dashboard';

  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int currentPage = 0;
  List<Widget> pageList = [
    const HomePage(),
    const HospitalListPage(),
    const PoliceListPage(),
    const ProfilePage()
  ];

  void getUserProfile() async {
    String? userId = Provider.of<AuthProvider>(context, listen:false).userId;
    print("--");
    print(Provider.of<AuthProvider>(context, listen:false).accessToken);
    print(Provider.of<AuthProvider>(context, listen:false).userId);
    print("...");
    if(userId != null) {
      Provider.of<UserProfileProvider>(context, listen:false).getUserProfile(userId);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) => getUserProfile());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
          child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        currentPage = 0;
                      });
                    },
                    child: Container(
                        padding: EdgeInsets.only(top: 5.0),
                        height: 50.0,
                        child: Column(children: [
                          Icon(CupertinoIcons.home,
                              color: (currentPage == 0)
                                  ? AppColor.primaryColor
                                  : Colors.black54),
                          Text('Home',
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color: (currentPage == 0)
                                      ? AppColor.primaryColor
                                      : Colors.black54))
                        ])))),
            Expanded(
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        currentPage = 1;
                      });
                    },
                    child: Container(
                        padding: EdgeInsets.only(top: 5.0),
                        height: 50.0,
                        child: Column(children: [
                          Icon(CupertinoIcons.heart,
                              color: (currentPage == 1)
                                  ? AppColor.primaryColor
                                  : Colors.black54),
                          Text('Rumah Sakit',
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color: (currentPage == 1)
                                      ? AppColor.primaryColor
                                      : Colors.black54))
                        ])))),
            Expanded(
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        currentPage = 2;
                      });
                    },
                    child: Container(
                        padding: EdgeInsets.only(top: 5.0),
                        height: 50.0,
                        child: Column(children: [
                          Icon(CupertinoIcons.shield,
                              color: (currentPage == 2)
                                  ? AppColor.primaryColor
                                  : Colors.black54),
                          Text('Polisi',
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color: (currentPage == 2)
                                      ? AppColor.primaryColor
                                      : Colors.black54))
                        ])))),
            Expanded(
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        currentPage = 3;
                      });
                    },
                    child: Container(
                        padding: EdgeInsets.only(top: 5.0),
                        height: 50.0,
                        child: Column(children: [
                          Icon(CupertinoIcons.paperclip,
                              color: (currentPage == 3)
                                  ? AppColor.primaryColor
                                  : Colors.black54),
                          Text('Laporan',
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color: (currentPage == 3)
                                      ? AppColor.primaryColor
                                      : Colors.black54))
                        ])))),
            Expanded(
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        currentPage = 4;
                      });
                    },
                    child: Container(
                        padding: EdgeInsets.only(top: 5.0),
                        height: 50.0,
                        child: Column(children: [
                          Icon(CupertinoIcons.person,
                              color: (currentPage == 4)
                                  ? AppColor.primaryColor
                                  : Colors.black54),
                          Text('Profil',
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color: (currentPage == 4)
                                      ? AppColor.primaryColor
                                      : Colors.black54))
                        ])))),
          ],
        ),
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemStatusBarContrastEnforced: true,
        ),
        child: Container(
            height: double.infinity,
            width: double.infinity,
            child: pageList[currentPage]),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}

class Menu {
  String? title;
  String? icon;
  String? route;

  Menu({this.title, this.icon, this.route});

  Menu.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    icon = json['icon'];
    route = json['route'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['icon'] = this.icon;
    data['route'] = this.route;
    return data;
  }
}
