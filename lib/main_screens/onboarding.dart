import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fuelcard/Data/Local/SharedPreference/shared_preference.dart';
import 'package:fuelcard/main_screens/home.dart';
import 'package:fuelcard/main_screens/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';

// enum Offer {
//   watches,
//   shoes,
//   sale
// }

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  @override
  void initState() {
    // TODO: implement initState
    isLogin();
    super.initState();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    // _animationController.dispose();
    super.dispose();
  }

  Future<void> isLogin() async {
    SharedPref.getId().then((value) async {
      if(value.isNotEmpty) {
        print(">>>>>>>>>>>>>>>>>>>Login");
        _navigateToHome(context);
      }
      else {
        print(">>>>>>>>>>>>>>>>>>>Not-Login");
        _navigateToWelcome(context);
      }
    });
  }

  void _navigateToHome(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (builder) => HomeScreen()),
          (route) => false,
    );
  }

  void _navigateToWelcome(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (builder) => WelcomePage()),
          (route) => false,
    );
  }

  Widget buildAsset() {
    return Image.asset(
      // 'images/onboard/supplieronboard.JPEG',
      'images/inapp/image4.png',
      height: MediaQuery.of(context).size.height * 1,
      width: MediaQuery.of(context).size.width * 1,
      fit: BoxFit.fill,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          buildAsset(),
          Positioned(
            top: 60,
            right: 30,
            child: Container(
              height: 35,
              width: 100,
              decoration: BoxDecoration(
                  color: Colors.grey.shade600.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(25)
              ),
              child: MaterialButton(
                onPressed: (){
                },
                child: const Text(
                    'Skip'
                )
                ),
              ),
            ),
        ],
      ),
    );
  }
}
