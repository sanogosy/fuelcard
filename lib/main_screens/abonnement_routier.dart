import 'package:flutter/material.dart';
import 'package:fuelcard/Data/Local/SharedPreference/shared_preference.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../Data/Netword/api/services.dart';

class AbonnementRoutier extends StatefulWidget {
  const AbonnementRoutier({super.key});

  @override
  State<AbonnementRoutier> createState() => _AbonnementRoutierState();
}

class _AbonnementRoutierState extends State<AbonnementRoutier> {

  String nombreJourAbonnement = '';
  late String currentPhone;

  @override
  void initState() {
    // TODO: implement initState
    init();
    super.initState();
  }

  Future<void> init() async {
    await SharedPref.getId().then((value) async {
      print('>>>>>>>>>>>>Phone : ' + value);
      currentPhone = value;
    })
    .whenComplete(() async {
      await getAbonnementRoutier(currentPhone).then((value) async {
        print('>>>>>>>>>>>>Abonnement nombre jour : ' + value.nombreJourRestant.toString());
        if(value.response == 'success') {
          nombreJourAbonnement = value.nombreJourRestant.toString();
        }
        else{
          //log out
        }
      });
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
              Text(
                'Abonnement : ' + nombreJourAbonnement + ' jours restant',
              ),
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
