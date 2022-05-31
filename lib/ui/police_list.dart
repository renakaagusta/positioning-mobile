import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:positioning/constant/assets.dart';
import 'package:positioning/data/model/user.dart';
import 'package:positioning/provider/user/police_list_provider.dart';
import 'package:positioning/provider/user/user_list_provider.dart';
import 'package:positioning/ui/police_detail.dart';
import 'package:positioning/utils/result_state.dart';
import 'package:positioning/widgets/card.dart';
import 'package:provider/provider.dart';

class PoliceListPage extends StatefulWidget {
  static const routeName = '/police_list';

  const PoliceListPage({Key? key}) : super(key: key);

  @override
  _PoliceListPageState createState() => _PoliceListPageState();
}

class _PoliceListPageState extends State<PoliceListPage> {
  void getPoliceList() async {
    Provider.of<PoliceListProvider>(context, listen: false).getPoliceList();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) => getPoliceList());
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
                      const Icon(CupertinoIcons.shield),
                      const SizedBox(
                        width: 10,
                      ),
                      Text('Kantor Polisi',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Consumer<PoliceListProvider>(
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
                              Text('Kantor polisi tidak ditemukan'),
                            ],
                          )),
                        );
                      } else if (state.state == ResultState.HasData) {
                        List<User> policeList = state.resultPoliceList!
                            .where((user) => user.role == 'police')
                            .toList();
                        if (policeList.isEmpty) {
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
                                Text('Kantor polisi tidak ditemukan'),
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
                                                PoliceDetailPage.routeName,
                                                arguments:
                                                    PoliceDetailArguments(
                                                        policeId:
                                                            policeList[index]
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
                                                          policeList[index]
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
                                                    Text(policeList[index]
                                                        .email!),
                                                  ],
                                                )
                                              ],
                                            )),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      )
                                    ]),
                                itemCount: policeList.length));
                      } else {
                        return Container(child: Text('Police not found'));
                      }
                    },
                  )
                ],
              )),
        ));
  }
}
