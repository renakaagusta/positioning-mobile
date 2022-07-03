import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:positioning/constant/colors.dart';


class PrivacyPage extends StatefulWidget {
  static const routeName = '/profile/privacy';

  @override
  _PrivacyPageState createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        primary: true,
        backgroundColor: Colors.white,
        body: FlutterEasyLoading(
          child: Container(
        height: size.height,
        width: size.width,
        padding: const EdgeInsets.only(top: 50),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      const Align(
                        alignment: Alignment.center,
                        child: const ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(70.0)),
                            child: Icon(Icons.shield_outlined,
                                color: AppColor.primaryColor, size: 200)),
                      ),
                      Align(
                          alignment: Alignment.center,
                          child: Container(
                              padding: const EdgeInsets.only(top: 50),
                              child: const Icon(CupertinoIcons.check_mark,
                                  color: Colors.black, size: 100))),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 20, left: 30.0, right: 30.0),
                    child: Column(
                      children: [
                        const Text(
                          'Kebijakan Privasi',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        const Text(
                            "Kebijakan Privasi berikut ini menjelaskan bagaimana kami, MyTect mengumpulkan, menyimpan, menggunakan, mengolah, menguasai, mentransfer, mengungkapkan dan melindungi Informasi Pribadi Anda. Kebijakan Privasi ini berlaku bagi seluruh pengguna aplikasi-aplikasi, situs web (www.my-tect.com), layanan, atau produk (“Aplikasi”) kami, kecuali diatur pada kebijakan privasi yang terpisah. Mohon baca Kebijakan Privasi ini dengan saksama untuk memastikan bahwa Anda memahami bagaimana proses pengolahan data kami. Kecuali didefinisikan lain, semua istilah dengan huruf kapital yang digunakan dalam Kebijakan Privasi ini memiliki arti yang sama dengan yang tercantum dalam Ketentuan Penggunaan.",
                            textAlign: TextAlign.justify,
                            style:
                                TextStyle(color: Colors.black54, fontSize: 16)),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        )),
        ));
  }
  
}
