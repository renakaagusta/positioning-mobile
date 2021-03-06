import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:positioning/constant/colors.dart';
import 'package:positioning/constant/strings.dart';
import 'package:positioning/constant/styles.dart';
import 'package:positioning/helpers/shared_preferences.dart';
import 'package:positioning/provider/auth/auth_provider.dart';
import 'package:positioning/provider/user/hospital_list_provider.dart';
import 'package:positioning/provider/user/hospital_profile_provider.dart';
import 'package:positioning/provider/user/point_collection_list_provider.dart';
import 'package:positioning/provider/user/police_list_provider.dart';
import 'package:positioning/provider/user/police_profile_provider.dart';
import 'package:positioning/provider/user/report_create_provider.dart';
import 'package:positioning/provider/user/report_detail_provider.dart';
import 'package:positioning/provider/user/report_list_provider.dart';
import 'package:positioning/provider/user/report_list_notification_provider.dart';
import 'package:positioning/provider/user/report_update_provider.dart';
import 'package:positioning/provider/user/route_collection_list_provider.dart';
import 'package:positioning/provider/user/user_list_provider.dart';
import 'package:positioning/provider/user/user_profile_provider.dart';
import 'package:positioning/provider/user/user_update_data_provider.dart';
import 'package:positioning/provider/user/user_update_photo_provider.dart';
import 'package:positioning/ui/dashboard.dart';
import 'package:positioning/ui/hospital_detail.dart';
import 'package:positioning/ui/my_location.dart';
import 'package:positioning/ui/police_detail.dart';
import 'package:positioning/ui/privacy.dart';
import 'package:positioning/ui/profile_edit.dart';
import 'package:positioning/ui/report_detail.dart';
import 'package:positioning/ui/sign_in.dart';
import 'package:positioning/ui/sign_up.dart';
import 'package:positioning/ui/sign_up_success.dart';
import 'package:positioning/ui/version.dart';
import 'package:positioning/ui/welcome.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs.init();
  await dotenv.load(fileName: ".env");

  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Container(
      height: 0,
      width: 0,
    );
  };
  await initializeDateFormatting('id_ID', null).then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
          ChangeNotifierProvider<UserProfileProvider>(
              create: (_) => UserProfileProvider()),
          ChangeNotifierProvider<UpdateUserPhotoProvider>(
              create: (_) => UpdateUserPhotoProvider()),
          ChangeNotifierProvider<UpdateUserDataProvider>(
              create: (_) => UpdateUserDataProvider()),
          ChangeNotifierProvider<UserListProvider>(
              create: (_) => UserListProvider()),
          ChangeNotifierProvider<HospitalProfileProvider>(
              create: (_) => HospitalProfileProvider()),
          ChangeNotifierProvider<HospitalListProvider>(
              create: (_) => HospitalListProvider()),
          ChangeNotifierProvider<PoliceProfileProvider>(
              create: (_) => PoliceProfileProvider()),
          ChangeNotifierProvider<PoliceListProvider>(
              create: (_) => PoliceListProvider()),
          ChangeNotifierProvider<ReportDetailProvider>(
              create: (_) => ReportDetailProvider()),
          ChangeNotifierProvider<ReportListProvider>(
              create: (_) => ReportListProvider()),
          ChangeNotifierProvider<ReportListNotificationProvider>(
              create: (_) => ReportListNotificationProvider()),
          ChangeNotifierProvider<ReportCreateProvider>(
              create: (_) => ReportCreateProvider()),
          ChangeNotifierProvider<ReportUpdateProvider>(
              create: (_) => ReportUpdateProvider()),
          ChangeNotifierProvider<PointCollectionListProvider>(
              create: (_) => PointCollectionListProvider()),
          ChangeNotifierProvider<RouteCollectionListProvider>(
              create: (_) => RouteCollectionListProvider()),
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: AppString.appName,
            theme: ThemeData(
              textTheme: textTheme,
              colorScheme: ThemeData().colorScheme.copyWith(
                    primary: AppColor.primaryColor,
                    secondary: AppColor.primaryColor,
                  ),
            ),
            initialRoute: WelcomePage.routeName,
            builder: EasyLoading.init(),
            routes: {
              WelcomePage.routeName: (context) => const WelcomePage(),
              SignInPage.routeName: (context) => const SignInPage(),
              SignUpPage.routeName: (context) => const SignUpPage(),
              SignUpSuccessPage.routeName: (context) =>
                  const SignUpSuccessPage(),
              DashboardPage.routeName: (context) => const DashboardPage(),
              PoliceDetailPage.routeName: (context) => const PoliceDetailPage(),
              ReportDetailPage.routeName: (context) => const ReportDetailPage(),
              HospitalDetailPage.routeName: (context) =>
                  const HospitalDetailPage(),
              ProfileEditPage.routeName: (context) => const ProfileEditPage(),
              PrivacyPage.routeName: (context) => PrivacyPage(),
              VersionPage.routeName: (context) => VersionPage(),
              ProfileEditPage.routeName: (context) => const ProfileEditPage(),
              MyLocationPage.routeName: (context) => const MyLocationPage(),
              ProfileEditPage.routeName: (context) => const ProfileEditPage()
            }));
  }
}
