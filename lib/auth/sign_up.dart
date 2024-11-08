import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fuelcard/Data/Netword/Firebase/firebase_services.dart';
import 'package:fuelcard/auth/login.dart';
import 'package:fuelcard/res/Assets/image_assets.dart';
import 'package:fuelcard/utilities/snackbar.dart';
import 'package:fuelcard/utilities/text_file_border.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class SignUp extends StatefulWidget {
  SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final TextEditingController nameController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  // final TextEditingController countryCodeController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final _key=GlobalKey<FormState>();

  late String countryCode;

  XFile? _imageFile;

  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Form(
              key: _key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20,),
                  Image.asset(ImageAssets.image1,height: MediaQuery.sizeOf(context).height/2.8,),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Sign Up",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 35),),
                      const Spacer(),
                      const Spacer(),
                      const Spacer(),
                      Obx(
                        () => GestureDetector(
                              onTap: () => null,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Container(
                                  height: 70,
                                  width: 70,
                                  color: Colors.white,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      _imageFile!.path.isNotEmpty
                                          ? const Padding(
                                        padding: EdgeInsets.all(20.0),
                                        child: FlutterLogo(
                                          size: 50,
                                        ),
                                      )
                                          : Image.file(
                                        File(_imageFile!.path),
                                        height: 70,
                                        width: 70,
                                        fit: BoxFit.cover,
                                      ),
                                      Positioned(
                                          bottom: 1,
                                          child: Container(
                                            height: 30,
                                            width: 100,
                                            color: Colors.black12,
                                            child: const Center(
                                              child: Icon(
                                                Icons.camera_alt,
                                                color: Colors.black38,
                                              ),
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  CustomFieldWithBorder(controller: nameController, hint: "Full Name", iconData: Icons.person_outline_rounded),
                  const SizedBox(height: 24,),
                  Row(
                    children: [
                      Expanded(
                        child: IntlPhoneField(
                          controller: phoneController,
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(),
                            ),
                          ),
                          initialCountryCode: 'US',
                          onChanged: (phone) {
                            countryCode = phone.countryCode;
                          },
                        ),
                      ),
                    ],
                  ),

                  // Row(
                  //   children: [

                      // CustomField(
                      //   controller: phoneController,
                      //   hint: "Mobile Number",
                      //   iconData: Icons.phone_iphone,
                      //   type: TextInputType.phone,
                      // ),
                  //   ],
                  // ),

                  const SizedBox(height: 16,),
                  CustomFieldWithBorder(controller: passwordController, hint: "Password", iconData: Icons.lock_outlined),
                  const SizedBox(height: 20,),
                  RichText(text: const TextSpan(
                    children:[
                      TextSpan(
                        text: "By signing up, you're agree to our ",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: " Terms & Conditions",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold)
                      ),
                      TextSpan(
                        text: "  and ",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                          text: "  Privacy Policy",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold)
                      ),
                    ]
                  )),
                  const SizedBox(height: 30,),
                  GestureDetector(
                    onTap: () async {
                      if(nameController.text.toString().isNotEmpty && phoneController.text.toString().isNotEmpty
                       && passwordController.text.toString().isNotEmpty
                      ){

                        // print(">>>>>>>>>>>>>>>>>>Phone : " + phoneController.text.toString());
                        // print(">>>>>>>>>>>>>>>>>>Phone code : " + countryCode);
                        await FirebaseService.register(
                            phoneController.text.toString(),
                            countryCode,
                            nameController.text.toString(),
                            passwordController.text.toString(),
                            File(_imageFile!.path)
                        )
                        .then((value) async {
                          print(">>>>>>>>>>>>>Result : " + value);
                          if(value == "success"){
                            print(">>>>>>>>>>>>>Success");
                            ShowSnackBar("Success", "Registered successfully.");
                            // Navigator.of(context).pushAndRemoveUntil(
                            //   MaterialPageRoute(
                            //     builder: (context) => Login(),
                            //   ),
                            //   (route) => false,
                            // );
                          }else {
                            print(">>>>>>>>>>>>>Warning");
                            ShowSnackBar("Warning", value);
                          }
                        });

                      }else{
                        ShowSnackBar("Warning", "Fill data correctly");
                      }
                    },
                    child: Container(
                      height: 60,width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: isProcessing
                      ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 15,width: 15,child: CircularProgressIndicator(color: Colors.white,),),
                          SizedBox(
                            width: 20,
                          ),
                          Text("Requesting",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
                        ],
                      )

                          :const Center(
                        child: Text("Register",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
                      ),

                        )
                    ),
                  const SizedBox(height: 30,),
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 50),
                        child: RichText(
                            text: const TextSpan(
                            children:[
                              TextSpan(
                                text: "Join us before? ",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                  text: " Login",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold)
                              ),

                            ]
                        )),
                      ),
                    ),
                  ),
                  // const SizedBox(height: 30,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
