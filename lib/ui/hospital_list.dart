import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:positioning/data/model/user.dart';
import 'package:positioning/provider/user/user_list_provider.dart';
import 'package:positioning/ui/sign_up.dart';
import 'package:positioning/utils/result_state.dart';
import 'package:provider/provider.dart';
import 'package:positioning/constant/assets.dart';
import 'package:positioning/constant/colors.dart';
import 'package:positioning/data/model/auth.dart';
import 'package:positioning/provider/auth/auth_provider.dart';
import 'package:positioning/ui/dashboard.dart';
import 'package:positioning/ui/sign_in.dart';
import 'package:positioning/widgets/elevated_button.dart';
import 'package:positioning/widgets/outlined_button.dart';

class HospitalListPage extends StatefulWidget {
  static const routeName = '/hospital_list';

  const HospitalListPage({Key? key}) : super(key: key);

  @override
  _HospitalListPageState createState() => _HospitalListPageState();
}

class _HospitalListPageState extends State<HospitalListPage> {
  void getUserList() async {
    Provider.of<UserListProvider>(context, listen: false).getUserList();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) => getUserList());
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
                  Text('Rumah Sakit',
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  Consumer<UserListProvider>(
                    builder: (context, state, _) {
                      if (state.state == ResultState.Loading) {
                        return Container(child: Text('Loading'));
                      } else if (state.state == ResultState.NoData) {
                        return Container(child: Text('Hospital not found'));
                      } else if (state.state == ResultState.HasData) {
                        List<User> hospitalList = state.resultUserList!
                            .where((user) => user.role == 'hospital')
                            .toList();
                        return ListView.builder(
                            itemBuilder: (context, index) => Container(),
                            itemCount: hospitalList.length);
                      } else {
                        return Container(child: Text('Hospital not found'));
                      }
                    },
                  )
                ],
              )),
        ));
  }
}
