import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:positioning/constant/assets.dart';
import 'package:positioning/data/model/report.dart';
import 'package:positioning/provider/user/report_list_provider.dart';
import 'package:positioning/ui/report_detail.dart';
import 'package:positioning/utils/result_state.dart';
import 'package:positioning/widgets/card.dart';
import 'package:provider/provider.dart';

class ReportListPage extends StatefulWidget {
  static const routeName = '/report_list';

  const ReportListPage({Key? key}) : super(key: key);

  @override
  _ReportListPageState createState() => _ReportListPageState();
}

class _ReportListPageState extends State<ReportListPage> {
  void getReportList() async {
    Provider.of<ReportListProvider>(context, listen: false).getReportList();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) => getReportList());
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
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(CupertinoIcons.paperclip),
                    const SizedBox(
                      width: 10,
                    ),
                    Text('Laporan',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
                Consumer<ReportListProvider>(
                  builder: (context, state, _) {
                    if (state.state == ResultState.Loading) {
                      return Container(
                          height: MediaQuery.of(context).size.height - 300,
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(AppAsset.welcomeIllustration, height: 200,),
                              const SizedBox(height: 10,),
                              const Text('Loading...'),
                            ],
                          )),
                        );
                    } else if (state.state == ResultState.NoData) {
                      return const Center(child: Text('Report not found'));
                    } else if (state.state == ResultState.HasData) {
                      List<Report> reportList = state.resultReportList!
                          .where((report) => report.rider == 'report')
                          .toList();
                      if (reportList.isEmpty) {
                        return Container(
                          height: MediaQuery.of(context).size.height - 300,
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(CupertinoIcons.exclamationmark_circle, size: 60),
                              SizedBox(height: 10,),
                              Text('Laporan tidak ditemukan'),
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
                                          .pushNamed(ReportDetailPage.routeName,
                                              arguments: ReportDetailArguments(
                                                  reportId:
                                                      reportList[index].id!)),
                                      child: AppCard(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 20),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          content: Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: 300,
                                                    child: Text('-',
                                                        style: Theme.of(context)
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
                                                  Text('-'),
                                                ],
                                              )
                                            ],
                                          )),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    )
                                  ]),
                              itemCount: reportList.length));
                    } else {
                      return Container(child: Text('Report not found'));
                    }
                  },
                )
              ],
            ),
          ),
        ));
  }
}
