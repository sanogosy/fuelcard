import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fuelcard/Data/Local/SharedPreference/shared_preference.dart';
import 'package:fuelcard/Data/Netword/api/services.dart';
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

class Transfert extends StatefulWidget {
  String? currentPhoneNumber;
  Transfert({super.key, this.currentPhoneNumber});

  @override
  State<Transfert> createState() => _TransfertState();
}

class _TransfertState extends State<Transfert> {

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _uid;
  bool docExists = false;
  late String countryCode;

  late String name;
  late String phoneNumber;
  // late String numberPhone;
  late String montant;
  late String profileImage;

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  bool passwordVisible = false;
  bool processing = false;
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

  Future<void> init() async {
    await SharedPref.getId().then((value) async {
      print('Phone : ' + value);
      widget.currentPhoneNumber = value;
    })
    .whenComplete(() async {
      await getCurrentBalance(widget.currentPhoneNumber!).then((value) async {
        print('Balance : ' + value.currentBalance.toString());
        if(value.response == 'success') {
          balance = value.currentBalance.toString();
        }
        else{
          //log out
        }
        setState(() {

        });
      });
    });
  }

  // Future<void> getBalance(String phoneNumber) async {
  //   await getCurrentBalance(phoneNumber).then((value) async {
  //     print('Balance Transfert : ' + value.currentBalance.toString());
  //     balance = value.currentBalance.toString();
  //   });
  // }

  void _navigateToLogin(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (builder) => Login()),
          (route) => false,
    );
  }

  void checkReceiver() async {
    phoneNumber = '$countryCode$phoneNumber';
    // phoneNumber = countryCodeController.text;
    setState(() {
      processing = true;
    });
    // widget.phoneNumber = '$countryCode$phoneNumber';
    print('CurrentPhoneNumber : ' + widget.currentPhoneNumber.toString());
    print('phoneNumber : ' + phoneNumber.toString());
    print('montant : ' + montant);
    if(_formKey.currentState!.validate()){

      try{

        // sendToSubPoint(widget.currentPhoneNumber!, phoneNumber, montant).then((value) {
        //   if(value.response == 'success'){
        //
        //     Fluttertoast.showToast(
        //         msg: "Operation effectuee avec succes : " + value.currentBalance.toString(),
        //         toastLength: Toast.LENGTH_SHORT,
        //         gravity: ToastGravity.CENTER,
        //         timeInSecForIosWeb: 1,
        //         backgroundColor: Colors.red,
        //         textColor: Colors.white,
        //         fontSize: 16.0
        //     );
        //
        //     Navigator.pushAndRemoveUntil(
        //         context,
        //         MaterialPageRoute(builder: (context) => HomeScreen()),
        //         (route) => false
        //     );
        //
        //     // ShowSnackBar('success', value.message ?? 'Operation effectuée avec succès !');
        //
        //
        //   }
        //   else {
        //     setState(() {
        //       processing = false;
        //     });
        //     showDialog(
        //         context: context,
        //         builder: (context) {
        //           return ConfirmationDialog(
        //             backgroundColor: Colors.white,
        //             actionButtonTextColor: Colors.black,
        //             actionCallbacks: {
        //               'Cancel': () {
        //                 setState(() {
        //                   processing = false;
        //                   Navigator.of(context).pop();
        //                 });
        //               },
        //               'Retour': () async {
        //                 processing = false;
        //                 Navigator.of(context).pop();
        //                 Navigator.pushAndRemoveUntil(
        //                     context,
        //                     MaterialPageRoute(builder: (context) => HomeScreen()),
        //                         (route) => false
        //                 );
        //               },
        //             },
        //             child: Column(
        //               mainAxisSize: MainAxisSize.min,
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: [
        //                 Text(
        //                   value.message ?? 'Veuillez reessayer, erreur serveur !',
        //                   style: TextStyle(color: Colors.black, fontSize: 16),
        //                 ),
        //                 const SizedBox(height: 16.0),
        //                 Text(
        //                   'Connecion internet lente',
        //                   style: TextStyle(
        //                     color: Colors.grey,
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           );
        //         }
        //     );
        //   }
        // });

      }
      catch(e){
        print('>>>>>>>>>>>>>>>data required');
      }

    }
    else {
      setState(() {
        processing = false;
      });

      MyMessageHandler.showSnackBar(
          _scaffoldKey, 'Please fill all fields'
      );

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: AppBarTitle(
            title: 'Transfert',
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
                child: Container(
                  // padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: FutureBuilder(
                    future: init(),
                    builder: (BuildContext context, AsyncSnapshot snapshot){
                      return Card(
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
                    );
                    }
                  ),
                ),
              ),
              Container(
                height: 500,
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: IntlPhoneField(
                              controller: countryCodeController,
                              decoration: InputDecoration(
                                labelText: 'Phone Number',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(),
                                    borderRadius: BorderRadius.circular(25)
                                ),
                              ),
                              initialCountryCode: 'US',
                              onChanged: (phone) {
                                phoneNumber = phone.number;
                                countryCode = phone.countryCode;
                              },
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          // controller: _passwordController,
                          keyboardType: TextInputType.number,
                          validator: (value){
                            if(value!.isEmpty) {
                              return 'please enter amount';
                            }
                            return null;
                          },
                          onChanged: (value){
                            montant = value;
                          },
                          obscureText: passwordVisible,
                          decoration: textFormDecoration.copyWith(
                              suffixIcon: Icon(
                                Icons.money,
                                color: Colors.purple,
                              ),
                              labelText: '0000',
                              hintText: 'Enter amount to send'
                          )
                        ),
                      ),
                      processing == true
                          ? const Center(child: CircularProgressIndicator(color: Colors.purple))
                          : SendButton(
                        mainButtonLabel: 'Continue',
                        onPressed: (){
                          checkReceiver();
                        },
                      ),
                      // divider(),
                      // googleLogInButton()
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}
