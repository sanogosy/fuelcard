import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fuelcard/Data/Netword/Firebase/firebase_services.dart';
import 'package:fuelcard/Data/Netword/api/services.dart';
import 'package:fuelcard/main_screens/customer_home.dart';
import 'package:fuelcard/utilities/snackbar.dart';
import 'package:fuelcard/widgets/auth_widgets.dart';
import 'package:fuelcard/widgets/snackbar.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:shared_preferences/shared_preferences.dart';

// final TextEditingController _nameController = TextEditingController();
// final TextEditingController _emailController = TextEditingController();
// final TextEditingController _passwordController = TextEditingController();

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  late String _uid;
  bool docExists = false;
  CollectionReference customers = FirebaseFirestore.instance.collection('customers');
  late String countryCode;

  late String name;
  late String phoneNumber;
  late String password;
  late String profileImage;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  bool passwordVisible = false;
  bool processing = false;
  XFile? _imageFile;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  // dynamic _pickedImageError;
  // final ImagePicker _picker = ImagePicker();
  // CollectionReference customers = FirebaseFirestore.instance.collection('customers');

  @override
  void initState() {
    // setState(() {
    //   processing = false;
    // });
    super.initState();
  }

  Future<bool> checkIfDocExists(String docId) async {
    try{
      var doc = await customers.doc(docId).get();
      return doc.exists;
    }
    catch(e) {
      return false;
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    //Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    //Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    //Create a new credential
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken
    );

    //Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential).whenComplete(() async {
      User user = FirebaseAuth.instance.currentUser!;
      // _uid = FirebaseAuth.instance.currentUser!.uid;
      setUserId(user);

      docExists = await checkIfDocExists(user.uid);
      docExists == false
          ? await customers.doc(user.uid).set({
        'name': user.displayName,
        'email': user.email,
        'profileimage': user.photoURL,
        'phone': '',
        'address': '',
        'cid': user.uid,
      }).then((value) => navigate())
          : navigate();
    });
  }

  void navigate() {
    // Navigator.pushReplacementNamed(context, '/customer_home');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => CustomerHomeScreen()),
          (Route<dynamic> route) => false,
    );
  }

  void setUserId(User user) {
    // context.read<IdProvider>().setCustomerId(user);
  }

  void logIn() async {

    setState(() {
      processing = true;
    });
    phoneNumber = '$countryCode$phoneNumber';

    if(_formKey.currentState!.validate()){

      try{
        fetchOne(phoneNumber, countryCode).then((value) async {
          print(">>>>>>>>>>>>>>>>>>>>>>FETCH-ONE");
          print(value);

          if(value.tel!.isNotEmpty){
            //login
            await FirebaseService.login(countryCode, phoneNumber, password)
            .then((value) async {
              if(value.getResponse == 'exists') {
                //go to OTP screen
                print(phoneNumber);
                // setState(() {
                //   processing = false;
                // });
                // ShowSnackBar('Account', 'Success !');
                Fluttertoast.showToast(
                    msg: "Authentifié avec succès, patientez svp...",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
                await FirebaseService.requestLoginOtp(phoneNumber, countryCode, password, context);
              }
              else {
                setState(() {
                  processing = false;
                });
                ShowSnackBar('Account', 'Veuillez vous inscrire !');
                print('>>>>>>>>>>>>>>>>>>>');
                print('Veuillez vous inscrire');
              }
            });
          }
          else {
            setState(() {
              processing = false;
            });
            ShowSnackBar('Account', 'Veuillez vous inscrire !');
          }
        });
      }
      on FirebaseAuthException catch(e){
        if(e.code == 'user-not-found') {
          setState(() {
            processing = false;
          });
          MyMessageHandler.showSnackBar(
              _scaffoldKey, 'No user found for that email !'
          );
        }
        else if(e.code == 'wrong-password') {
          setState(() {
            processing = false;
          });

          MyMessageHandler.showSnackBar(
              _scaffoldKey, 'Wrong password provided !'
          );
        }
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
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              reverse: true,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AuthHeaderLabel(headerLabel: 'Login'),
                      SizedBox(
                        height: 50,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: IntlPhoneField(
                              // controller: phoneController,
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
                            validator: (value){
                              if(value!.isEmpty) {
                                return 'please enter your password';
                              }
                              return null;
                            },
                            onChanged: (value){
                              password = value;
                            },
                            obscureText: passwordVisible,
                            decoration: textFormDecoration.copyWith(
                                suffixIcon: IconButton(
                                    onPressed: (){
                                      setState(() {
                                        passwordVisible = !passwordVisible;
                                      });
                                    },
                                    icon: Icon(
                                      passwordVisible ? Icons.visibility : Icons.visibility_off,
                                      color: Colors.purple,
                                    )
                                ),
                                labelText: 'Password',
                                hintText: 'Enter your password'
                            )
                        ),
                      ),
                      TextButton(
                          onPressed: (){
                            Navigator.pushReplacementNamed(context, '/');
                          },
                          child: const Text(
                            'Forget Password ?',
                            style: TextStyle(
                                fontSize: 18,
                                fontStyle: FontStyle.italic
                            ),
                          )
                      ),
                      HaveAccount(
                        haveAccount: 'Pas encore inscrit ? ',
                        actionLabel: 'Contactez',
                        onPressed: (){
                          // Navigator.pushReplacementNamed(context, '/customer_signup');
                        },
                      ),
                      processing == true
                          ? const Center(child: CircularProgressIndicator(color: Colors.purple))
                          : AuthMainButton(
                        mainButtonLabel: 'Log In',
                        onPressed: (){
                          logIn();
                        },
                      ),
                      // divider(),
                      // googleLogInButton()
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 80,
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
          Text(
            ' Or ',
            style: TextStyle(
                color: Colors.grey
            ),
          ),
          SizedBox(
            width: 80,
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          )
        ],
      ),
    );
  }

  Widget googleLogInButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(50, 50, 50, 20),
      child: Material(
        elevation: 3,
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
        child: MaterialButton(
          onPressed: (){
            signInWithGoogle();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(
                  FontAwesomeIcons.google,
                  color: Colors.red
              ),
              Text(
                'Sign In with Google',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 16
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}