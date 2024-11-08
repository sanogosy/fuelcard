import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:fuelcard/main_screens/home.dart';
import 'package:fuelcard/main_screens/profile.dart';
import 'package:fuelcard/services/notifications_services.dart';
import 'package:provider/provider.dart';

class CustomerHomeScreen extends StatefulWidget {

  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {

  int _selectedIndex = 0;
  final List<Widget> _tabs =  [
    HomeScreen(),
    ProfileScreen(
      // documentId: FirebaseAuth.instance.currentUser!.uid,
    ),
  ];

  displayForegroundNotifications() {
    // FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        NotificationsServices.displayNotification(message);
      }
    });
  }

  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'followers') {
      // Navigator.push(context, MaterialPageRoute(builder: (context) => VisitStore(suppId: message.data['sid'])));
      // Navigator.pushNamed(context, '/chat',
        // arguments: ChatArguments(message),
      // );
    }
  }

  @override
  void initState() {
    // if(widget.phone != null){
    //   print(">>>>>>>>>>>>>>>>>CustomerHome code : " + widget.phone!.code.toString());
    // }

    FirebaseMessaging.instance.getToken().then((value) {
      //
    });
    // context.read<Cart>().loadCartItemsProvider();
    displayForegroundNotifications();
    setupInteractedMessage();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w600
        ),
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.red,
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Category'),
          BottomNavigationBarItem(icon: Icon(Icons.shop), label: 'Stores'),
          BottomNavigationBarItem(icon: Icon(Icons.shop), label: 'Stores'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index){
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
