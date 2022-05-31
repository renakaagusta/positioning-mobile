import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:positioning/constant/assets.dart';
import 'package:positioning/constant/colors.dart';
import 'package:positioning/data/model/user.dart';
import 'package:positioning/provider/user/hospital_profile_provider.dart';
import 'package:positioning/utils/result_state.dart';
import 'package:positioning/widgets/app_bar.dart';
import 'package:positioning/widgets/card.dart';
import 'package:positioning/widgets/elevated_button.dart';
import 'package:positioning/widgets/outlined_button.dart';
import 'package:provider/provider.dart';

class HospitalDetailArguments {
  String hospitalId;

  HospitalDetailArguments({required this.hospitalId});
}

class HospitalDetailPage extends StatefulWidget {
  static const routeName = '/hospital_detail';

  const HospitalDetailPage({Key? key}) : super(key: key);

  @override
  _HospitalDetailPageState createState() => _HospitalDetailPageState();
}

class _HospitalDetailPageState extends State<HospitalDetailPage> {
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

  void getHospitalProfile() {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as HospitalDetailArguments;
    Provider.of<HospitalProfileProvider>(context, listen: false)
        .getHospitalProfile(arguments.hospitalId);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) => getHospitalProfile());
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
          body: Consumer<HospitalProfileProvider>(
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
                      Text('Rumah sakit tidak ditemukan'),
                    ],
                  )),
                );
              } else if (state.state == ResultState.HasData) {
                User hospital = state.resultHospitalProfile!;
                LatLng position = LatLng(
                    double.tryParse(hospital.meta['location']['static']
                                ['latitude']) !=
                            null
                        ? double.parse(
                            hospital.meta['location']['static']['latitude'])
                        : 0.0,
                    double.tryParse(hospital.meta['location']['static']
                                ['longitude']) !=
                            null
                        ? double.parse(
                            hospital.meta['location']['static']['longitude'])
                        : 0.0);
                if (_mapController != null && _markers.isEmpty) {
                  _handleAddMarker(position);
                  _mapController!.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: LatLng(position.latitude, position.longitude),
                        zoom: 14,
                      ),
                    ),
                  );
                }
                return Stack(
                  children: [
                    Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(hospital.name!,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
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
                            Text(hospital.email!),
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
                            Text(hospital.meta['phoneNumber']),
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
                            FutureBuilder<String>(
                                future: _getAddressFromLatLong(position),
                                builder: (BuildContext context,
                                    AsyncSnapshot<String> snapshot) {
                                  return Text(snapshot.data ?? '-');
                                }),
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
                                 AppElevatedButton(
                                    backgroundColor: AppColor.primaryColor,
                                    onPressed: ()  {
                                      launch('tel://${hospital.meta['phoneNumber']}');
                                      },
                                    icon: Icon(CupertinoIcons.phone),
                                    text: 'Panggilan',
                                    color: Colors.white),
                              ],
                            ))),
                  ],
                );
              } else {
                return Container(child: Text('Hospital not found'));
              }
            },
          ),
        ));
  }
}
