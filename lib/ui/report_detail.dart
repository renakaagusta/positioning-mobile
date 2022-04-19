import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:positioning/constant/assets.dart';
import 'package:positioning/constant/colors.dart';
import 'package:positioning/data/model/report.dart';
import 'package:positioning/provider/user/report_detail_provider.dart';
import 'package:positioning/utils/result_state.dart';
import 'package:positioning/widgets/app_bar.dart';
import 'package:positioning/widgets/card.dart';
import 'package:positioning/widgets/elevated_button.dart';
import 'package:positioning/widgets/outlined_button.dart';
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

  final LatLng _center = const LatLng(-7.870932572248912, 111.46249872570408);

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
    });
  }

  void _handleAddMarker(LatLng point) async {
    String addressTranslate = await _getAddressFromLatLong(point);
    setState(() {
      _markers.clear();
      _markers.add(Marker(
        markerId: MarkerId(point.toString()),
        position: point,
        infoWindow: const InfoWindow(
          title: 'Lokasi',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  Future<String> _getAddressFromLatLong(LatLng position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    return '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
  }

  void getReportProfile() {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as ReportDetailArguments;
    Provider.of<ReportDetailProvider>(context, listen: false)
        .getReportDetail(arguments.reportId);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) => getReportProfile());
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
            title: 'Rumah Sakit',
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
                return const Center(child: Text('Report not found'));
              } else if (state.state == ResultState.HasData) {
                Report report = state.resultReportDetail!;
                if (_mapController != null && _markers.isEmpty) {}
                return Stack(
                  children: [
                    Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            Text('Email',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(
                              height: 5,
                            ),
                            Text("-"),
                            const SizedBox(
                              height: 20,
                            ),
                            Text('Nomor HP',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(
                              height: 5,
                            ),
                            Text("-"),
                            const SizedBox(
                              height: 20,
                            ),
                            Text('Alamat',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(
                              height: 5,
                            ),
                            Text("-"),
                            const SizedBox(
                              height: 20,
                            ),
                            Text('Peta',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              height: 300,
                              width: MediaQuery.of(context).size.width,
                              child: GoogleMap(
                                onMapCreated: _onMapCreated,
                                initialCameraPosition: CameraPosition(
                                  target: _center,
                                  zoom: 12.0,
                                ),
                                markers: Set<Marker>.of(_markers),
                              ),
                            ),
                          ],
                        )),
                    Positioned(
                        bottom: 0,
                        left: 0,
                        child: AppCard(
                            width: MediaQuery.of(context).size.width,
                            content: Column(
                              children: [
                                AppOutlinedButton(
                                    onPressed: () => {},
                                    icon: Icon(CupertinoIcons.phone),
                                    text: 'Panggilan',
                                    color: AppColor.primaryColor),
                                const SizedBox(
                                  height: 5,
                                ),
                                AppElevatedButton(
                                    backgroundColor: AppColor.primaryColor,
                                    icon: Icon(CupertinoIcons.paperclip),
                                    text: 'Buat laporan',
                                    onPressed: () => {})
                              ],
                            ))),
                  ],
                );
              } else {
                return Container(child: Text('Report not found'));
              }
            },
          ),
        ));
  }
}
