import 'dart:math' show cos, sqrt, asin;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:positioning/constant/assets.dart';
import 'package:positioning/data/model/user.dart';
import 'package:positioning/provider/user/point_collection_list_provider.dart';
import 'package:positioning/provider/user/report_detail_provider.dart';
import 'package:positioning/provider/user/user_list_provider.dart';
import 'package:positioning/provider/user/user_profile_provider.dart';
import 'package:positioning/utils/result_state.dart';
import 'package:positioning/widgets/app_bar.dart';
import 'package:positioning/widgets/card.dart';
import 'package:provider/provider.dart';

class ReportDetailArguments {
  String reportId;

  ReportDetailArguments({required this.reportId});
}

class ReportDetailPage extends StatefulWidget {
  static const routeName = '/report_detail';

  const ReportDetailPage({Key? key}) : super(key: key);

  @override
  _ReportDetailPageState createState() => _ReportDetailPageState();
}

class _ReportDetailPageState extends State<ReportDetailPage> {
  GoogleMapController? _mapController;
  List<Marker> _markers = [];

  final List<Polyline> polyline = [];
  List<LatLng> routeCoords = [];

  final LatLng _center = const LatLng(-7.2419431033902075, 112.73640583197016);

  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = dotenv.env['API_URL'] ?? '';

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
    });
  }

  void _handleAddMarker(LatLng point) async {
    List<Marker> newMarkers = _markers;
    newMarkers.add(Marker(
      markerId: MarkerId(point.toString()),
      position: point,
      infoWindow: const InfoWindow(
        title: 'Lokasi',
      ),
      icon: BitmapDescriptor.defaultMarker,
    ));
    setState(() {
      _markers = newMarkers;
    });
  }

  Future<String> _getAddressFromLatLong(LatLng position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    return '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
  }

  void getReportData() {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as ReportDetailArguments;
    Provider.of<ReportDetailProvider>(context, listen: false)
        .getReportDetail(arguments.reportId);
  }

  void getUserList() {
    Provider.of<UserListProvider>(context, listen: false).getUserList();
  }

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

  void showRegistrationModal() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        builder: (context) {
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
                              const Icon(CupertinoIcons.chevron_back, size: 30),
                        ),
                        Text('Pilih jenjang',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(
                          width: 20,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ));
          }));
        });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      getReportData();
      getUserList();
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
          appBar: CustomAppBar(
            title: 'Laporan',
          ),
          body: Consumer<ReportDetailProvider>(
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
                      Icon(CupertinoIcons.exclamationmark_circle, size: 60),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Laporan tidak ditemukan'),
                    ],
                  )),
                );
              } else if (state.state == ResultState.HasData) {
                final report = state.resultReportDetail;
                final pointCollectionList =
                    Provider.of<PointCollectionListProvider>(context,
                            listen: false)
                        .resultPointCollectionList;
                final pointCollection = pointCollectionList![0];
                final startingPoint = pointCollection.data!.firstWhere(
                    (point) => point.properties!.text == report!.startingPoint);
                final endPoint = pointCollection.data!.firstWhere(
                    (point) => point.properties!.text == report!.endPoint);
                final startingPointPosition = LatLng(
                    startingPoint.geometry!.coordinates![1],
                    startingPoint.geometry!.coordinates![0]);
                final endPointPosition = LatLng(
                    endPoint.geometry!.coordinates![1],
                    endPoint.geometry!.coordinates![0]);
                final distance =
                    calculateDistance(startingPointPosition, endPointPosition);

                WidgetsBinding.instance!.addPostFrameCallback((_) {
                  if (polylineCoordinates.isEmpty) {
                    List<LatLng> pointList = [];
                    report!.routes!.forEach((point) {
                      pointList.add(LatLng(point.lat!, point.lng!));
                    });
                    setState(() {
                      polylineCoordinates = pointList;
                    });
                    PolylineId id = PolylineId("poly");
                    Polyline polyline = Polyline(
                        polylineId: id,
                        color: Colors.blue,
                        points: polylineCoordinates);
                    polylines[id] = polyline;

                    _handleAddMarker(LatLng(
                        startingPoint.geometry!.coordinates![0],
                        startingPoint.geometry!.coordinates![1]));
                    _handleAddMarker(LatLng(endPoint.geometry!.coordinates![0],
                        endPoint.geometry!.coordinates![1]));

                    setState(() {});
                  }
                });

                return Consumer<UserListProvider>(builder: (context, state, _) {
                  User currentUser =
                      Provider.of<UserProfileProvider>(context, listen: false)
                          .resultUserProfile!;
                  User instance = User();
                  User rider = User();

                  if (state.state == ResultState.HasData) {
                    state.resultUserList!.forEach((user) {
                      if (user.id == report!.handler) {
                        instance = user;
                      }
                      if (user.id == report!.rider) {
                        rider = user;
                      }
                    });
                  }

                  return Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: GoogleMap(
                          onMapCreated: _onMapCreated,
                          initialCameraPosition: CameraPosition(
                            target: _center,
                            zoom: 17.0,
                          ),
                          markers: Set<Marker>.of(_markers),
                          polylines: Set<Polyline>.of(polylines.values),
                        ),
                      ),
                      Positioned(
                          bottom: 0,
                          left: 0,
                          child: AppCard(
                              width: MediaQuery.of(context).size.width,
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      currentUser.role == 'rider'
                                          ? 'Instansi'
                                          : 'Pengendara',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold)),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(currentUser.role == 'rider'
                                      ? (instance.id != null
                                          ? instance.name!
                                          : '-')
                                      : rider.id != null
                                          ? rider.name!
                                          : '-'),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text('Jarak',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold)),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(distance.toStringAsFixed(2) + " KM"),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text('Status',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold)),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(report!.status == 'Created'
                                      ? "Diminta"
                                      : (report.status == 'Confirmed'
                                          ? 'Dikonfirmasi'
                                          : 'Ditolak')),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  /*AppOutlinedButton(
                                      color: AppColor.primaryColor,
                                      text: 'Batalkan laporan',
                                      onPressed: () => {})*/
                                ],
                              ))),
                    ],
                  );
                });
              } else {
                return Container(child: Text('Hospital not found'));
              }
            },
          ),
        ));
  }
}
