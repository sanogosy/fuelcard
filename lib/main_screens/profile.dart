import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fuelcard/Data/Local/SharedPreference/shared_preference.dart';
import 'package:fuelcard/Data/Netword/api/services.dart';
import 'package:fuelcard/Data/entity/profile.dart';
import 'package:fuelcard/Data/entity/user_account.dart';
import 'package:fuelcard/auth/login.dart';
import 'package:fuelcard/constants/allconstant.dart';
import 'package:fuelcard/main_screens/home.dart';
import 'package:fuelcard/utilities/snackbar.dart';
import 'package:fuelcard/widgets/alert_dialog.dart';
import 'package:fuelcard/widgets/appbar_widgets.dart';
import 'package:fuelcard/widgets/auth_widgets.dart';
import 'package:fuelcard/widgets/dialogs.dart';
import 'package:fuelcard/widgets/send_button.dart';
import 'package:fuelcard/widgets/snackbar.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  String? currentPhoneNumber;
  ProfileScreen({super.key, this.currentPhoneNumber});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _uid;
  bool docExists = false;
  late String countryCode;

  // late String name;
  late String phoneNumber;
  // late String numberPhone;
  late String montant;
  late String profileImage;

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  bool passwordVisible = false;
  bool processing = false;
  String name = '';
  String email = '';
  String tel = '';
  String type_compte = '';
  String balance = '';
  TextEditingController countryCodeController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    // init();
    // isLogin();
    // numberPhone = widget.currentPhoneNumber!;
    // setState(() {
    //
    // });
    super.initState();
  }

  // Future<void> isLogin() async {
  //   await SharedPref.getId().then((value) async {
  //     if(value.isNotEmpty) {
  //       currentPhoneNumber = value;
  //       // await SharedPref.getNumber().then((value) async => currentPhoneNumber = value);
  //       print(">>>>>>>>>>>>>>>>>>>Phone : " + currentPhoneNumber);
  //       getBalance(currentPhoneNumber);
  //     }
  //     else {
  //       print(">>>>>>>>>>>>>>>>>>>Not-Login");
  //       _navigateToLogin(context);
  //     }
  //   });
  // }

  Future<Profile> init() async {
    await SharedPref.getId().then((value) async {
      // print('Phone : ' + value);
      widget.currentPhoneNumber = value;
    })
    .whenComplete(() async {
      await getProfile(widget.currentPhoneNumber!, '').then((value) async {
        print('Name : ' + value.name.toString());
        // print('Balance : ' + value.balance.toString());
        if(value.response == 'success') {
          name = value.name.toString();
          email = value.email.toString();
          tel = value.tel.toString();
          type_compte = value.type_compte.toString();
          balance = value.balance.toString();

          return new Profile(
            name: name,
            tel: tel,
            email: email,
            type_compte: type_compte,
            authorized: value.authorized,
            deleted: value.deleted
          );
        }
        else{
          //log out
          return new Profile(
              name: name,
              tel: tel,
              email: email,
              type_compte: type_compte,
              authorized: '',
              deleted: ''
          );
        }

      });
    });

    return new Profile(
        name: name,
        tel: tel,
        email: email,
        type_compte: type_compte,
        authorized: '',
        deleted: ''
    );
  }

  // Future<void> getBalance(String phoneNumber) async {
  //   await getCurrentBalance(phoneNumber).then((value) async {
  //     print('Balance ProfileScreen : ' + value.currentBalance.toString());
  //     balance = value.currentBalance.toString();
  //   });
  // }

  void _navigateToLogin(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (builder) => Login()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: AppBarTitle(
            title: 'Profile',
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                child: FutureBuilder<Profile>(
                    future: init(),
                    builder: (BuildContext context, AsyncSnapshot<Profile> snapshot){

                      if(snapshot.hasError) {
                        print(">>>>>>>>>>>>>>>>>>>>Error : " + snapshot.error.toString());
                      }

                      if(snapshot.hasData && snapshot.data!.type_compte != '') {
                        print(">>>>>>>>>>>>>>>>>>>>Error data not exists, log out !<<<<<<<<<<<<<<<<<<");
                        // logOut();
                      }

                      if(snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
                        // Map<String, dynamic> data = snapshot.data! as Map<String, dynamic>;

                        return Column(
                          children: [
                            Card(
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
                            RepeatedListTile(
                              title: 'Type Compte.',
                              subTitle: snapshot.data!.type_compte != ''
                              ? snapshot.data!.type_compte == 'sousreseau' ? 'Station'
                                  : snapshot.data!.type_compte == 'partenaireuser' ? 'Transporteur' : ''
                              : 'exemple: Non definie',
                              icon: Icons.person,
                            ),
                            const YellowDivider(),
                            RepeatedListTile(
                              title: 'Nom.',
                              subTitle: snapshot.data!.name != '' ? snapshot.data!.name : 'exemple: +16505550000',
                              icon: Icons.person,
                            ),
                            const YellowDivider(),
                            RepeatedListTile(
                              title: 'Email Addresse',
                              subTitle: snapshot.data!.email != '' ? snapshot.data!.email! : 'exemple@mail.com',
                              icon: Icons.email,
                            ),
                            const YellowDivider(),
                            RepeatedListTile(
                              title: 'Phone No.',
                              subTitle: snapshot.data!.tel != '' ? snapshot.data!.tel! : 'exemple: +16505550000',
                              icon: Icons.phone,
                            ),
                            const YellowDivider(),
                            RepeatedListTile(title: 'Changer le Profile',
                                subTitle: '',
                                icon: Icons.edit,
                                onPressed: () {}),
                            YellowDivider(),
                            RepeatedListTile(
                              title: 'Change password',
                              icon: Icons.lock,
                              onPressed: () {
                                // Navigator.push(context, MaterialPageRoute(builder: (context) => const UpdatePassword()));
                              },
                            ),
                          ],
                        );
                      }

                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.purple,
                        ),
                      );

                    }
                ),
              )
            ],
          ),
        )
    );
  }
}

class YellowDivider extends StatelessWidget {
  const YellowDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Divider(
        color: Colors.yellow,
        thickness: 1,
      ),
    );
  }
}
