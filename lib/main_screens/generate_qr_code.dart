import 'package:flutter/material.dart';
import 'package:fuelcard/Data/Local/SharedPreference/shared_preference.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GenerateQrCodeScreen extends StatefulWidget {
  const GenerateQrCodeScreen({super.key});

  @override
  State<GenerateQrCodeScreen> createState() => _GenerateQrCodeScreenState();
}

class _GenerateQrCodeScreenState extends State<GenerateQrCodeScreen> {

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String balance = '';
  late String currentPhone;

  @override
  void initState() {
    // TODO: implement initState
    init();
    super.initState();
  }

  Future<void> init() async {
    await SharedPref.getId().then((value) async {
      print('>>>>>>>>>>>>Phone generate qr code : ' + value);
      currentPhone = value;
    });

    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30,),
              QrImageView(
                data: currentPhone,
                version: QrVersions.auto,
                size: 200.0,
                embeddedImage: const AssetImage('assets/icon.png'),
                embeddedImageStyle: QrEmbeddedImageStyle(
                  size: const Size(50, 50)
                ),
                eyeStyle: const QrEyeStyle(
                  eyeShape: QrEyeShape.circle,
                  color: Colors.black
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
