import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fuelcard/Data/Netword/Firebase/firebase_services.dart';
import 'package:fuelcard/constants/allconstant.dart';
import 'package:fuelcard/main_screens/customer_home.dart';
import 'package:fuelcard/res/Assets/image_assets.dart';
import 'package:fuelcard/utilities/snackbar.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Otp extends StatefulWidget {
  final String? phoneNumber;
  final String? countryCode;
  final String? verificationId;
  final String? type;

  Otp({super.key, this.phoneNumber, this.countryCode, this.verificationId, this.type});

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  final pin1 = TextEditingController();

  final pin2 = TextEditingController();

  final pin3 = TextEditingController();

  final pin4 = TextEditingController();

  final pin5 = TextEditingController();

  final pin6 = TextEditingController();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Image.asset(
                  ImageAssets.otp,
                  height: MediaQuery.sizeOf(context).height / 2.8,
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  widget.type != null && widget.type!.isNotEmpty ? "Enter OTP to login" : "Enter OTP",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 35),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text("A six (06) digit otp number has been sent to",
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold)),
                Text(
                    '${widget.phoneNumber}',
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 54,
                      width: MediaQuery.of(context).size.width * 0.14,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(.1),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: TextFormField(
                          controller: pin1,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          keyboardType: TextInputType.number,
                          autofocus: true,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                              counterText: "",
                              border: InputBorder.none,
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                  const BorderSide(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(10))),
                          onSaved: (newValue) {},
                          onChanged: (value) {
                            if (value.length == 1) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                        ),
                      ),
                    ),
                    Container(
                      height: 54,
                      width: MediaQuery.of(context).size.width * 0.14,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(.1),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: TextFormField(
                          controller: pin2,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          keyboardType: TextInputType.number,
                          autofocus: true,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                              counterText: "",
                              border: InputBorder.none,
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                  const BorderSide(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(10))),
                          onSaved: (newValue) {},
                          onChanged: (value) {
                            if (value.length == 1) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                        ),
                      ),
                    ),
                    Container(
                      height: 54,
                      width: MediaQuery.of(context).size.width * 0.14,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(.1),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: TextFormField(
                          controller: pin3,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          keyboardType: TextInputType.number,
                          autofocus: true,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                              counterText: "",
                              border: InputBorder.none,
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                  const BorderSide(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(10))),
                          onSaved: (newValue) {},
                          onChanged: (value) {
                            if (value.length == 1) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                        ),
                      ),
                    ),
                    Container(
                      height: 54,
                      width: MediaQuery.of(context).size.width * 0.14,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(.1),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: TextFormField(
                          controller: pin4,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          keyboardType: TextInputType.number,
                          autofocus: true,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                              counterText: "",
                              border: InputBorder.none,
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                  const BorderSide(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(10))),
                          onSaved: (newValue) {},
                          onChanged: (value) {
                            if (value.length == 1) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                        ),
                      ),
                    ),
                    Container(
                      height: 54,
                      width: MediaQuery.of(context).size.width * 0.14,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(.1),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: TextFormField(
                          controller: pin5,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          keyboardType: TextInputType.number,
                          autofocus: true,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                              counterText: "",
                              border: InputBorder.none,
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                  const BorderSide(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(10))),
                          onSaved: (newValue) {},
                          onChanged: (value) {
                            if (value.length == 1) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                        ),
                      ),
                    ),
                    Container(
                      height: 54,
                      width: MediaQuery.of(context).size.width * 0.14,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(.1),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: TextFormField(
                          controller: pin6,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          keyboardType: TextInputType.number,
                          autofocus: true,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                              counterText: "",
                              border: InputBorder.none,
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                  const BorderSide(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(10))),
                          onSaved: (newValue) {},
                          onChanged: (value) {
                            if (value.length == 1) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    "00:59",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 60,
                      width: 150,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(10)),
                      child: const Center(
                        child: Text(
                          "Resend",
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        print(">>>>>>>>>>>>SNAPSHOT<<<<<<<<<<<<<<");
                        // print("code : " + widget.phone!.code!.toString());
                        print("type : " + widget.type.toString());
                        print("countryCode : " + widget.countryCode!);
                        print(">>>>>>>>>>>>END-SNAPSHOT<<<<<<<<<<<<<<");
                        widget.type != null && widget.type!.isNotEmpty
                        ? await FirebaseService.verifyLoginOtp(
                            widget.countryCode!,
                            widget.phoneNumber!,
                            pin1.text.toString() +
                                pin2.text.toString() +
                                pin3.text.toString() +
                                pin4.text.toString() +
                                pin5.text.toString() +
                                pin6.text.toString(),
                            widget.verificationId!,
                          context
                        )
                        : await FirebaseService.verifyOtp(
                          widget.countryCode!,
                            pin1.text.toString() +
                                pin2.text.toString() +
                                pin3.text.toString() +
                                pin4.text.toString() +
                                pin5.text.toString() +
                                pin6.text.toString(),
                            widget.verificationId!,
                        );
                        // final SharedPreferences pref = await _prefs;
                        //
                        // String uid = pref.getString(customerId).toString();
                        // String name = pref.getString(currentUserName).toString();
                        // String phoneNumber = pref.getString(currentUserPhone).toString();
                        // String email = pref.getString(currentUserEmail).toString();
                        // String photoUrl = pref.getString(currentUserPhotoUrl).toString();
                        //
                        // print(">>>>>>>>>>>>>>>> UID : " + uid);

                        // setCurrentCustomer(uid, name, phoneNumber, email, photoUrl);
                        // uid.isNotEmpty
                        // ? Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerHomeScreen()))
                        // : ShowSnackBar("Error", "Please try again !");
                      },
                      child: Container(
                          height: 60,
                          width: 150,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: isProcessing
                          ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 15,width: 15,child: CircularProgressIndicator(color: Colors.white,),),
                              SizedBox(width: 10,),
                              Center(
                                child: Text(
                                  "Verifying",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                            ],
                          )
                          : const Center(
                            child: Text(
                              "Verify",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),)
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
