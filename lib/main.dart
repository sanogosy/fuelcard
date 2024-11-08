import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fuelcard/auth/login.dart';
import 'package:fuelcard/auth/otp.dart';
import 'package:fuelcard/auth/sign_up.dart';
import 'package:fuelcard/main_screens/historique.dart';
import 'package:fuelcard/main_screens/home.dart';
import 'package:fuelcard/main_screens/onboarding.dart';
import 'package:fuelcard/main_screens/profile.dart';
import 'package:fuelcard/main_screens/setting.dart';
import 'package:fuelcard/main_screens/transfert.dart';
import 'package:fuelcard/main_screens/welcome.dart';
import 'package:fuelcard/services/notifications_services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Stripe.urlScheme = "flutterstripe";
  // await Stripe.instance.applySettings();
  // SQLHelper.getDatabase;

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  NotificationsServices.createNotificationChannelAndInitialize();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // final SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(
      const MyApp()
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // return MaterialApp
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: CustomerHomeScreen(),
      // initialRoute: '/welcome_screen',
      initialRoute: '/onboarding_screen',
      routes: {
        '/onboarding_screen': (context) => const OnboardingScreen(),
        '/welcome_screen': (context) => const WelcomePage(),
        '/home': (context) => HomeScreen(),
        '/login': (context) => Login(),
        '/signup': (context) => SignUp(),
        '/otp': (context) => Otp(),
        '/parametre': (context) => Parametre(),
        '/transfert': (context) => Transfert(),
        '/profile': (context) => ProfileScreen(),
        '/historique': (context) => Historique(),
      },
    );
  }
}