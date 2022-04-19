import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:positioning/utils/document_verification_status.dart';
import 'package:positioning/widgets/app_bar.dart';
import 'package:positioning/widgets/card.dart';

class MyLocationPage extends StatefulWidget {
  static const routeName = '/my_location';

  const MyLocationPage({Key? key}) : super(key: key);

  @override
  _MyLocationPageState createState() => _MyLocationPageState();
}

class _MyLocationPageState extends State<MyLocationPage> {
  late GoogleMapController _mapController;
  List<Marker> _markers = [];
  String? address;
  String? locationVerificationStatus;
  LatLng? currentPosition;

  final LatLng _center = const LatLng(-7.870932572248912, 111.46249872570408);

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _determinePosition();
  }

  void _handleAddMarker(LatLng point) async {
    String addressTranslate = await _getAddressFromLatLong(point);
    setState(() {
      currentPosition = point;
      address = addressTranslate;
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
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 10,
        ),
      ),
    );

    _handleAddMarker(LatLng(position.latitude, position.longitude));

    String translatePosition = await _getAddressFromLatLong(LatLng(position.latitude, position.longitude));

    setState(() {
      address = translatePosition;
    });
  }

  Future<String> _getAddressFromLatLong(LatLng position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    return '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.black,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        child: Scaffold(
              appBar: CustomAppBar(title: 'Lokasi saya'),
              body: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
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
                  Positioned(
                      bottom: 0,
                      left: 0,
                      child: AppCard(
                        width: MediaQuery.of(context).size.width,
                        content: Column(children: [
                          if (locationVerificationStatus != null)
                            Row(
                              children: [
                                if (locationVerificationStatus != 'accepted')
                                  const Icon(
                                      CupertinoIcons.exclamationmark_circle,
                                      size: 20,
                                      color: Colors.yellow)
                                else
                                  const Icon(CupertinoIcons.checkmark_alt,
                                      color: Colors.green),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                    documentVerificationStatus[
                                        locationVerificationStatus!]!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2
                                        ?.copyWith(color: Colors.black45))
                              ],
                            ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            address != null
                                ? address!
                                : "-",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ]),
                      )),
                ],
              ),
            )
        );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}