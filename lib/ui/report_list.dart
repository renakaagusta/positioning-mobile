import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:positioning/constant/assets.dart';
import 'package:positioning/data/model/point_collection.dart';
import 'package:positioning/data/model/report.dart';
import 'package:positioning/data/model/user.dart';
import 'package:positioning/provider/user/hospital_list_provider.dart';
import 'package:positioning/provider/user/point_collection_list_provider.dart';
import 'package:positioning/provider/user/police_list_provider.dart';
import 'package:positioning/provider/user/report_create_provider.dart';
import 'package:positioning/provider/user/report_list_provider.dart';
import 'package:positioning/provider/user/user_profile_provider.dart';
import 'package:positioning/ui/report_detail.dart';
import 'package:positioning/utils/result_state.dart';
import 'package:positioning/widgets/card.dart';
import 'package:positioning/widgets/elevated_button.dart';
import 'package:provider/provider.dart';

class ReportListPage extends StatefulWidget {
  static const routeName = '/report_list';

  const ReportListPage({Key? key}) : super(key: key);

  @override
  _ReportListPageState createState() => _ReportListPageState();
}

class _ReportListPageState extends State<ReportListPage> {
  PointCollection pointCollection = PointCollection();
  LatLng currentPosition = const LatLng(0, 0);
  User currentUser = User();
  List<User> hospitalList = [];
  List<User> policeList = [];

  double calculateDistance(LatLng point1, LatLng point2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((point2.latitude - point1.latitude) * p) / 2 +
        c(point1.latitude * p) *
            c(point2.latitude * p) *
            (1 - c((point2.longitude - point1.longitude) * p)) /
            2;
    return 12742 * asin(sqrt(a));
  }

  void _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition();

    if (mounted) {
      setState(() {
        currentPosition = LatLng(position.latitude, position.longitude);
      });
    }
  }

  void _getReportList() async {
    Provider.of<ReportListProvider>(context, listen: false).getReportList();
  }

  void _getPointCollectionList() async {
    Provider.of<PointCollectionListProvider>(context, listen: false)
        .getPointCollectionList();
  }

  void _getHospitalList() async {
    Provider.of<HospitalListProvider>(context, listen: false).getHospitalList();
  }

  void _getPoliceList() async {
    Provider.of<PoliceListProvider>(context, listen: false).getPoliceList();
  }

  Future<User> _getNearestInstance(List<User> instanceList) async {
    User nearestInstance = instanceList[0];
    final initialNearestInstancePosition = LatLng(
        double.parse(nearestInstance.meta['location']['static']['latitude']),
        double.parse(nearestInstance.meta['location']['static']['longitude']));
    double nearestDistance =
        calculateDistance(currentPosition, initialNearestInstancePosition);

    instanceList.forEachIndexed((index, instance) {
      final instancePosition = LatLng(
          double.parse(instance.meta['location']['static']['latitude']),
          double.parse(instance.meta['location']['static']['longitude']));
      final distance = calculateDistance(currentPosition, instancePosition);
      if (distance < nearestDistance) {
        nearestDistance = distance;
        nearestInstance = instance;
      }
    });

    return nearestInstance;
  }

  Future<Data> _getPointRepresentation(LatLng position) async {
    Data representationPoint = pointCollection.data![0];
    final initialRepresentationPointPosition = LatLng(
        representationPoint.geometry!.coordinates![1],
        representationPoint.geometry!.coordinates![0]);
    double representationDistance =
        calculateDistance(position, initialRepresentationPointPosition);

    pointCollection.data!.forEachIndexed((index, point) {
      final instancePosition = LatLng(
          point.geometry!.coordinates![1], point.geometry!.coordinates![0]);
      final distance = calculateDistance(position, instancePosition);
      if (distance < representationDistance) {
        representationDistance = distance;
        representationPoint = point;
      }
    });

    return representationPoint;
  }

  void _showSelectReportTypeModal() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        builder: (context) {
          String reportType = 'Traffic Jam';
          return StatefulBuilder(builder: ((context, setState) {
            return Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 20, bottom: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child:
                              const Icon(CupertinoIcons.chevron_back, size: 20),
                        ),
                        Text('Pilih jenis laporan',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontWeight: FontWeight.bold)),
                        SizedBox(width: 0)
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Jenis laporan',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    DropdownButton<String>(
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(
                          value: 'Traffic Jam',
                          child: Text('Kemacetan'),
                        ),
                        DropdownMenuItem(
                          value: 'Accident',
                          child: Text('Kecelakaan'),
                        )
                      ],
                      value: reportType,
                      onChanged: (val) {
                        setState(() {
                          reportType = val ?? 'Traffic Jam';
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    AppElevatedButton(
                        text: 'Buat',
                        onPressed: () async {
                          User nearestInstance = User();
                          Data userRepresentationPoint = Data();
                          Data instanceRepresentationPoint = Data();

                          if (reportType == 'Accident') {
                            nearestInstance =
                                await _getNearestInstance(hospitalList);
                          } else {
                            nearestInstance =
                                await _getNearestInstance(policeList);
                          }

                          userRepresentationPoint =
                              await _getPointRepresentation(currentPosition);
                          instanceRepresentationPoint =
                              await _getPointRepresentation(LatLng(
                                  double.parse(nearestInstance.meta['location']
                                      ['static']['latitude']),
                                  double.parse(nearestInstance.meta['location']
                                      ['static']['longitude'])));

                          print('USER REPRESENTATION POINT: ');
                          print(userRepresentationPoint.properties!.text);

                          print('INSTANCE REPRESENTATION POINT: ');
                          print(instanceRepresentationPoint.properties!.text);

                          if (int.parse(
                                  userRepresentationPoint.properties!.text!) >=
                              int.parse(instanceRepresentationPoint
                                  .properties!.text!)) {
                            userRepresentationPoint = pointCollection!.data!
                                .firstWhere(
                                    (point) => point.properties!.text == '0');
                          }

                          final currentUser = Provider.of<UserProfileProvider>(
                                  context,
                                  listen: false)
                              .resultUserProfile;
                          DateTime now = DateTime.now();
                          String formattedDate =
                              DateFormat("EEEE, d MMMM yyyy", "id_ID")
                                  .format(now);
                          final title = 'Laporan ' +
                              (reportType == 'Traffic Jam'
                                  ? 'Kemacetan'
                                  : 'Kecelakaan');
                          final description = formattedDate;
                          final category = reportType;
                          final rider = currentUser!.id;
                          final handler = nearestInstance.id;
                          final type = 'Real';
                          final startingPoint =
                              userRepresentationPoint.properties!.text;
                          final endPoint =
                              instanceRepresentationPoint.properties!.text;
                          final createdAt = DateTime.now();

                          Map<String, String> body = {
                            'title': title,
                            'description': description,
                            'category': category,
                            'rider': rider!,
                            'handler': handler!,
                            'type': type,
                            'startingPoint': startingPoint!,
                            'endPoint': endPoint!,
                            'createdAt': createdAt.toUtc().toString(),
                          };

                          await Provider.of<ReportCreateProvider>(context,
                                  listen: false)
                              .createReport(body);

                          final reportId = Provider.of<ReportCreateProvider>(
                                  context,
                                  listen: false)
                              .reportId;

                          Navigator.of(context).pushNamed(
                              ReportDetailPage.routeName,
                              arguments:
                                  ReportDetailArguments(reportId: reportId!));
                        })
                  ],
                ));
          }));
        });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        currentUser = Provider.of<UserProfileProvider>(context, listen: false)
            .resultUserProfile!;
      });
      Timer.periodic(new Duration(seconds: 1), (timer) {
        _determinePosition();
      });
      _getPointCollectionList();
      _getReportList();
      _getHospitalList();
      _getPoliceList();
    });
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
          floatingActionButton: Container(
              width: 60,
              height: 60,
              child: currentUser.role == "rider"
                  ? AppElevatedButton(
                      icon: const Icon(CupertinoIcons.add, size: 16),
                      onPressed: () => _showSelectReportTypeModal())
                  : Container()),
          body: Consumer<PointCollectionListProvider>(
              builder: (context, state, _) {
            WidgetsBinding.instance!.addPostFrameCallback((_) {
              if (state.resultPointCollectionList != null) {
                setState(() {
                  pointCollection = state.resultPointCollectionList![0];
                });
              }
            });

            return Consumer<HospitalListProvider>(builder: (context, state, _) {
              WidgetsBinding.instance!.addPostFrameCallback((_) {
                if (state.resultHospitalList != null) {
                  setState(() {
                    hospitalList = state.resultHospitalList!;
                  });
                }
              });

              return Consumer<PoliceListProvider>(builder: (context, state, _) {
                WidgetsBinding.instance!.addPostFrameCallback((_) {
                  if (state.resultPoliceList != null) {
                    setState(() {
                      policeList = state.resultPoliceList!;
                    });
                  }
                });

                if (hospitalList.isNotEmpty &&
                    policeList.isNotEmpty &&
                    currentPosition != null) {
                  _getNearestInstance(hospitalList);
                }

                return Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
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
                            return const Center(
                                child: Text('Report not found'));
                          } else if (state.state == ResultState.HasData) {
                            User currentUser = Provider.of<UserProfileProvider>(
                                    context,
                                    listen: false)
                                .resultUserProfile!;
                            List<Report> reportList =
                                currentUser.role == 'rider'
                                    ? state.resultReportList!
                                        .where((report) =>
                                            report.rider == currentUser.id)
                                        .toList()
                                    : state.resultReportList!
                                        .where((report) =>
                                            report.handler == currentUser.id)
                                        .toList();
                            if (reportList.isEmpty) {
                              return Container(
                                height:
                                    MediaQuery.of(context).size.height - 300,
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                        CupertinoIcons.exclamationmark_circle,
                                        size: 60),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const Text('Laporan tidak ditemukan'),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    if (currentUser.role == "rider")
                                      SizedBox(
                                          width: 160,
                                          child: AppElevatedButton(
                                              icon: const Icon(
                                                  CupertinoIcons.add,
                                                  size: 16),
                                              text: 'Buat laporan',
                                              onPressed: () =>
                                                  _showSelectReportTypeModal()))
                                  ],
                                )),
                              );
                            }
                            return LimitedBox(
                                maxHeight:
                                    MediaQuery.of(context).size.height - 200,
                                maxWidth: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                    itemBuilder: (context, index) =>
                                        Column(children: [
                                          GestureDetector(
                                            onTap: () => Navigator.of(context)
                                                .pushNamed(
                                                    ReportDetailPage.routeName,
                                                    arguments:
                                                        ReportDetailArguments(
                                                            reportId:
                                                                reportList[
                                                                        index]
                                                                    .id!)),
                                            child: AppCard(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 20),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                content: Row(
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          width: 300,
                                                          child: Text(
                                                              reportList[index]
                                                                  .title!,
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
                                                        Text(reportList[index]
                                                            .description!),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text(reportList[index]
                                                            .createdAt
                                                            .toString()),
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
                );
              });
            });
          }),
        ));
  }
}
