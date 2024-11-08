import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fuelcard/Data/Local/SharedPreference/shared_preference.dart';
import 'package:fuelcard/Data/Netword/api/services.dart';
import 'package:fuelcard/constants/allconstant.dart';
import 'package:fuelcard/main_screens/demande_achat_carburant.dart';
import 'package:fuelcard/main_screens/generate_qr_code.dart';
import 'package:fuelcard/main_screens/historique.dart';
import 'package:fuelcard/main_screens/profile.dart';
import 'package:fuelcard/main_screens/read_qr_code.dart';
import 'package:fuelcard/main_screens/setting.dart';
import 'package:fuelcard/main_screens/transfert.dart';
import 'package:fuelcard/widgets/alert_dialog.dart';
import 'package:fuelcard/widgets/appbar_widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'abonnement_routier.dart';

List<String> label = [
  'Profile',
  'Transfert',
  'Qr Code',
  'Scan Qr Code',
  'Historique',
  'Abonnement',
  'balance',
  'statics'
];

List<IconData> icons = [
  Icons.account_box,
  Icons.send_to_mobile,
  Icons.qr_code_sharp,
  Icons.qr_code_scanner,
  Icons.history,
  Icons.subscriptions_outlined,
  Icons.attach_money,
  Icons.show_chart
];

List<Widget> pages = [
  ProfileScreen(),
  Transfert(),
  GenerateQrCodeScreen(),
  ReadQrCodeScreen(),
  Historique(),
  AbonnementRoutier()
];

class HomeScreen extends StatefulWidget {

  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String balance = '';
  late String currentPhone;

  @override
  void initState() {
    // TODO: implement initState
    // init();
    super.initState();
  }

  Future<void> init() async {
    await SharedPref.getId().then((value) async {
      print('>>>>>>>>>>>>Phone : ' + value);
      currentPhone = value;
    })
    .whenComplete(() async {
      await getCurrentBalance(currentPhone).then((value) async {
        print('>>>>>>>>>>>>Balance : ' + value.currentBalance.toString());
        if(value.response == 'success') {
          balance = value.currentBalance.toString();
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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: AppBarTitle(
          title: 'Dashboard',
        ),
        actions: [
          IconButton(
              onPressed: (){
                // Navigator.pushReplacementNamed(context, '/welcome_screen');
                MyAlertDialog.showMyDialog(
                    context: context,
                    title: 'Log Out !',
                    content: 'Are you sure want to logout?',
                    tabNo: () {
                      // Handle the 'Cancel' action by dismissing the dialog
                      // finish(context);
                      Navigator.pop(context);
                    },
                    tabYes: () async {
                      // Handle the 'Logout' action by dismissing the dialog
                      await FirebaseAuth.instance.signOut();
                      // await AuthRepo.logOut();
                      final SharedPreferences pref = await _prefs;
                      pref.setString(customerId, '');
                      await Future.delayed(const Duration(microseconds: 5)).whenComplete(() {
                        Navigator.pop(context);
                        Navigator.pushReplacementNamed(
                            context, '/login');
                      });
                    }
                );
              },
              icon: Icon(
                  Icons.logout, color: Colors.black
              )
          )
        ],
      ),
      body: Center(
        child: FutureBuilder(
          future: init(),
          builder: (BuildContext context, AsyncSnapshot snapshot){

            if (!snapshot.hasData) defaultDashboard(context, '0.00', '');

            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    child: Container(
                      // padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Card(
                        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        elevation: 20,
                        shadowColor: Colors.purpleAccent.shade200,
                        color: Colors.blueGrey.withOpacity(0.7),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(
                                Icons.monetization_on,
                                size: 50,
                                color: Colors.yellowAccent,
                              ),
                              Text(
                                balance.isNotEmpty ? balance : '0.00',
                                style: TextStyle(
                                    fontSize: 40,
                                    color: Colors.yellowAccent,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 2,
                                    fontFamily: 'Acme'
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 500,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GridView.count(
                        mainAxisSpacing: 48,
                        crossAxisSpacing: 48,
                        crossAxisCount: 2,
                        children: List.generate(6, (index) {
                          return InkWell(
                            onTap: () {
                              print('>>>>>>>>>Index : ' + index.toString());
                              // if(index.isEqual(1)) {
                              //
                              //   Navigator.push(context, MaterialPageRoute(builder: (context) => Transfert(currentPhoneNumber: currentPhone,)));
                              // }
                              Navigator.push(context, MaterialPageRoute(builder: (context) => pages[index]));
                            },
                            child: Card(
                              elevation: 20,
                              shadowColor: Colors.purpleAccent.shade200,
                              color: Colors.blueGrey.withOpacity(0.7),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(
                                    icons[index],
                                    size: 50,
                                    color: Colors.yellowAccent,
                                  ),
                                  Text(
                                    label[index].toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.yellowAccent,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 2,
                                        fontFamily: 'Acme'
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        ),
      ),
      floatingActionButton: SpeedDial(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueAccent,
        icon: Icons.add,
        activeIcon: Icons.close,
        children: [
          SpeedDialChild(
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReadQrCodeScreen())
                );
              },
              child: const Icon(Icons.qr_code_scanner)
          ),
          SpeedDialChild(
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Parametre())
                );
              },
              child: const Icon(Icons.settings)
          ),
          SpeedDialChild(
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DemandeAchatCarburantScreen(phone: currentPhone))
                );
              },
              child: const Icon(Icons.archive)
          ),
        ],
      )
    );
  }
}

Widget defaultDashboard(BuildContext context, String solde, String phone){
  return SingleChildScrollView(
    child: Column(
      children: [
        SizedBox(
          child: Container(
            // padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Card(
              margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
              elevation: 20,
              shadowColor: Colors.purpleAccent.shade200,
              color: Colors.blueGrey.withOpacity(0.7),
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      Icons.monetization_on,
                      size: 50,
                      color: Colors.yellowAccent,
                    ),
                    Text(
                      solde.isNotEmpty ? solde : '0.00',
                      style: TextStyle(
                          fontSize: 40,
                          color: Colors.yellowAccent,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                          fontFamily: 'Acme'
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          height: 500,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.count(
              mainAxisSpacing: 48,
              crossAxisSpacing: 48,
              crossAxisCount: 2,
              children: List.generate(4, (index) {
                return InkWell(
                  onTap: () {
                    print('>>>>>>>>>Index default : ' + index.toString());
                    if(index.isEqual(0)) {

                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(currentPhoneNumber: phone,)));
                    }
                    if(index.isEqual(1)) {

                      Navigator.push(context, MaterialPageRoute(builder: (context) => Transfert(currentPhoneNumber: phone,)));
                    }
                    Navigator.push(context, MaterialPageRoute(builder: (context) => pages[index]));
                  },
                  child: Card(
                    elevation: 20,
                    shadowColor: Colors.purpleAccent.shade200,
                    color: Colors.blueGrey.withOpacity(0.7),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          icons[index],
                          size: 50,
                          color: Colors.yellowAccent,
                        ),
                        Text(
                          label[index].toUpperCase(),
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.yellowAccent,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2,
                              fontFamily: 'Acme'
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    ),
  );
}

class RepeatedListTile extends StatelessWidget {

  final String title;
  final String subTitle;
  final IconData icon;
  final Function()? onPressed;

  const RepeatedListTile({
    super.key, required this.title, this.subTitle = '', required this.icon, this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: ListTile(
        title:  Text(
          title,
        ),
        subtitle: Text(subTitle),
        leading: Icon(icon),
      ),
    );
  }
}

class ProfileHeaderLabel extends StatelessWidget {

  final String headerLabel;

  const ProfileHeaderLabel({
    super.key, required this.headerLabel
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
          Text(
            headerLabel,
            style: TextStyle(
                color: Colors.grey,
                fontSize: 24,
                fontWeight: FontWeight.w600
            ),
          ),
          SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}