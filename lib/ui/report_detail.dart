import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:positioning/provider/user/report_create_provider.dart';
import 'package:positioning/widgets/app_bar.dart';
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

  void _handleDetailMarker(LatLng point) async {
    String addressTranslate = await _getDetailressFromLatLong(point);
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

  Future<String> _getDetailressFromLatLong(LatLng position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    return '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
  }

  void getReportProfile() {
    Map<String, dynamic> body = {};
    Provider.of<ReportCreateProvider>(context, listen: false)
        .createReport(body);
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
            title: 'Laporan',
          ),
          body: Container(),
        ));
  }
}
