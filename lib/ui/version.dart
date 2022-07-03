import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:positioning/constant/assets.dart';
import 'package:positioning/constant/strings.dart';

class VersionPage extends StatefulWidget {
  static const routeName = '/profile/version';

  @override
  _VersionPageState createState() => _VersionPageState();
}

class _VersionPageState extends State<VersionPage> {
  
  @override
  void initState() {
    super.initState();
    
  }
  
  
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        primary: true,
        backgroundColor: Colors.white,
        body: FlutterEasyLoading(
          child: _buildRightSide(),
        ));
  }

  Widget _buildRightSide() {
    Size size = MediaQuery.of(context).size;
    return Container(
        height: size.height,
        width: size.width,
        padding: const EdgeInsets.only(top: 50),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Stack(children: [
                    Align(
                      alignment: Alignment.center,
                      child:
                          Image.asset(AppAsset.appIcon, height: 100),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                          margin: const EdgeInsets.only(top: 130),
                          child: const Text(
                            AppString.appName,
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          )),
                    )
                  ]),
                  Container(
                    padding: const EdgeInsets.only(top: 40, left: 30.0, right: 30.0),
                    child: Column(
                      children: [
                        const Text(
                          'Versi Aplikasi',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        const Text(
                          '1.00',
                          style: const TextStyle(fontSize: 20, color: Colors.black45),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        const Text(
                          'Change log',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          '-',
                          style: const TextStyle(fontSize: 20, color: Colors.black45),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
