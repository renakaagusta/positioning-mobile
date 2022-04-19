import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:positioning/constant/assets.dart';
import 'package:positioning/data/model/user.dart';
import 'package:positioning/provider/user/hospital_list_provider.dart';
import 'package:positioning/ui/hospital_detail.dart';
import 'package:positioning/utils/result_state.dart';
import 'package:positioning/widgets/card.dart';
import 'package:provider/provider.dart';

class HospitalListPage extends StatefulWidget {
  static const routeName = '/hospital_list';

  const HospitalListPage({Key? key}) : super(key: key);

  @override
  _HospitalListPageState createState() => _HospitalListPageState();
}

class _HospitalListPageState extends State<HospitalListPage> {
  void getHospitalList() async {
    Provider.of<HospitalListProvider>(context, listen: false).getHospitalList();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) => getHospitalList());
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
                      const Icon(CupertinoIcons.heart),
                      const SizedBox(
                        width: 10,
                      ),
                      Text('Rumah Sakit',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Consumer<HospitalListProvider>(
                    builder: (context, state, _) {
                      if (state.state == ResultState.Loading) {
                        return Container(
                          height: MediaQuery.of(context).size.height - 300,
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                AppAsset.welcomeIllustration,
                                height: 200,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text('Loading...'),
                            ],
                          )),
                        );
                      } else if (state.state == ResultState.NoData) {
                        return Container(
                          height: MediaQuery.of(context).size.height - 300,
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(CupertinoIcons.exclamationmark_circle,
                                  size: 60),
                              SizedBox(
                                height: 10,
                              ),
                              Text('Rumah sakit tidak ditemukan'),
                            ],
                          )),
                        );
                      } else if (state.state == ResultState.HasData) {
                        List<User> hospitalList = state.resultHospitalList!
                            .where((user) => user.role == 'hospital')
                            .toList();
                        if (hospitalList.isEmpty) {
                          return Container(
                            height: MediaQuery.of(context).size.height - 300,
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(CupertinoIcons.exclamationmark_circle,
                                    size: 60),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Rumah sakit tidak ditemukan'),
                              ],
                            )),
                          );
                        }
                        return LimitedBox(
                            maxHeight: MediaQuery.of(context).size.height - 200,
                            maxWidth: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                                itemBuilder: (context, index) =>
                                    Column(children: [
                                      GestureDetector(
                                        onTap: () => Navigator.of(context)
                                            .pushNamed(
                                                HospitalDetailPage.routeName,
                                                arguments:
                                                    HospitalDetailArguments(
                                                        hospitalId:
                                                            hospitalList[index]
                                                                .id!)),
                                        child: AppCard(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 20),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            content: Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 300,
                                                      child: Text(
                                                          hospitalList[index]
                                                              .name!,
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .titleMedium
                                                              ?.copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(hospitalList[index]
                                                        .email!),
                                                  ],
                                                )
                                              ],
                                            )),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      )
                                    ]),
                                itemCount: hospitalList.length));
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
