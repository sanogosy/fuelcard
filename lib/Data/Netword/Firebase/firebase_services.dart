import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypt/crypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fuelcard/Data/Local/SharedPreference/shared_preference.dart';
import 'package:fuelcard/Data/entity/account_login.dart';
import 'package:fuelcard/auth/otp.dart';
import 'package:fuelcard/constants/allconstant.dart';
import 'package:fuelcard/main_screens/customer_home.dart';
import 'package:fuelcard/main_screens/home.dart';
import 'package:fuelcard/utilities/snackbar.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseService {

  static String phoneNumber_ = "";
  static String countryCode_ = "";
  static String name_ = "";
  static String password_ = "";
  static File? file_;
  static CollectionReference customers = FirebaseFirestore.instance.collection('customers');
  static String _uid = "";


  static Future<bool> checkAccount(String phoneNumber, String password, String dbRef) async {

    DatabaseReference ref =  FirebaseDatabase.instance.ref(dbRef).child(phoneNumber);
    // var snapshot = await ref.child("phoneNumber").onValue;
    DatabaseEvent event = await ref.once();

    return event.snapshot.value != null;
  }

  static Future<AccountLogin> getEnterpriseUserAccount(String phoneNumber) async {

    AccountLogin accountLogin = AccountLogin();

    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child(firebaseEnterpriseUsersDB+'/$phoneNumber').get();
    if (snapshot.exists) {
      print(">>>>>>>>>>>>SNAPSHOT<<<<<<<<<<<<<<");
      print(snapshot.value);
      print(">>>>>>>>>>>>END-SNAPSHOT<<<<<<<<<<<<<<");
      accountLogin.setResponse = 'exists';
      accountLogin.setId = (snapshot.value as Map)['id'];
      accountLogin.setName = (snapshot.value as Map)['name'];
      accountLogin.setAvataUrl = (snapshot.value as Map)['avatarUrl'];
      accountLogin.setTel = (snapshot.value as Map)['phoneNumber'];
    }
    else {
      accountLogin.setResponse = 'notexists';
    }
    print(accountLogin.getResponse);
    return accountLogin;
  }

  Future<bool> rootFirebaseIsExists(DatabaseReference databasereference) async{
    DatabaseEvent snapshot = await databasereference.once();

    return snapshot != null;
  }

  static Future<void> requestOtp(String phoneNumber, String name, String password, File file) async {
    phoneNumber_ = phoneNumber;
    name_ = name;
    password_ = password;
    file_ = file;

    checkAccount(phoneNumber_, password_, firebaseAccountDB).then((value) async {

      if(value){
        //account already exists
        ShowSnackBar("Error", errorRead(accountAlreadyExists));
      }
      else {
        //account not exists
        FirebaseAuth auth = FirebaseAuth.instance;
        await auth.verifyPhoneNumber(

          // phoneNumber: '+92$phoneNumber',
          phoneNumber: '+$phoneNumber',
          codeSent: (String verificationId, int? resendToken) async {

            Get.to(Otp(
              phoneNumber: phoneNumber,
              verificationId: verificationId,
            ));
          },

          verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {
          },
          verificationFailed: (FirebaseAuthException error) {
            ShowSnackBar("Error", errorRead(error.toString()));

          },
          codeAutoRetrievalTimeout: (String verificationId) {

          },
        ).onError((error, stackTrace) {

          ShowSnackBar("Error", errorRead(error.toString()));
        },);
      }

    });

  }

  static Future<void> requestLoginOtp(String phoneNumber, String countryCode, String password, BuildContext context) async {
    phoneNumber_ = phoneNumber;
    password_ = password;
    // file_ = file;

    FirebaseAuth auth = FirebaseAuth.instance;
        //account exists
        await auth.verifyPhoneNumber(
          // phoneNumber: '+92$phoneNumber',
          phoneNumber: '$phoneNumber_',
          codeSent: (String verificationId, int? resendToken) async {

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Otp(
                  countryCode: countryCode,
                  phoneNumber: phoneNumber_,
                  verificationId: verificationId,
                  type: "login",
                )
              )
            );
          },

          verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {
          },
          verificationFailed: (FirebaseAuthException error) {
            ShowSnackBar("Error", errorRead(error.toString()));

          },
          codeAutoRetrievalTimeout: (String verificationId) {

          },
        ).onError((error, stackTrace) {

          ShowSnackBar("Error", errorRead(error.toString()));
        },);
  }

  static Future<String> register(String phoneNumber, String countryCode, String name, String password, File file) async {

    // phoneNumber_ = phoneNumber;  //without country code
    phoneNumber_ = '$countryCode$phoneNumber';  //with country code
    file_ = file;
    name_ = name;
    String result = "error";
    // // FirebaseAuth auth = FirebaseAuth.instance;
    //
    // try {
    //   final userCredential =
    //   await FirebaseAuth.instance.signInAnonymously();
    //   print("Signed in with temporary account.");
    //
    //
    // // if(auth != null) {
      try {

        // FirebaseStorage storage = FirebaseStorage.instance;
        // var sref = storage.ref('$phoneNumber_.jpeg');
        // var uploadtask = sref.putFile(file_!);
        _uid = phoneNumber_;
        // await Future.value(uploadtask).then((v) async {
        //   sref.getDownloadURL().then((url) {
        await FirebaseDatabase.instance.ref('Accounts').child(phoneNumber_).set({
              'uid': phoneNumber_,
              'name': name_,
              'email': phoneNumber_ + '@mail.com',
              'phoneNumber': phoneNumber_,
              'countryCode': countryCode,
              'url': '',
              'type': 'customer',
              'password': password,
              'deleted': false,
            }).then((value) async {
              await customers.doc(phoneNumber_).set({
                'name': name_,
                'email': phoneNumber_ + '@mail.com',
                'profileimage': '',
                'phoneNumber': phoneNumber_,
                'countryCode': countryCode,
                'address': '',
                'cid': phoneNumber_,
                'password': password,
                'deleted': false,
              });

              // await SharedPref.saveData(
              //     _uid, name_, phoneNumber_, countryCode, phoneNumber_ + '@mail.com', '');


              result = "success";
            },);
      //     }).onError((error, stackTrace) {
      //       FirebaseAuth.instance.signOut();
      //
      //       result = error.toString();
      //       print(">>>>>>>>>>>>>>>>>>>>>>>>>>>Error SIGN_UP : " +
      //           result.toString());
      //     },);
      //   },
      //   )
      //       .onError((error, stackTrace) {
      //     FirebaseAuth.instance.signOut();
      //
      //     result = error.toString();
      //     print(">>>>>>>>>>>>>>>>>>>>>>>>>>>Error SIGN_UP-1 : " +
      //         result.toString());
      //   },
      //   );
        return "success";
      } catch (e) {

        result = e.toString();
        print(">>>>>>>>>>>>>>>>>>>>>>>>>>>Error SIGN_UP Exceptin : " + result.toString());
        return "error";
      }
    // } on FirebaseAuthException catch (e) {
    //   switch (e.code) {
    //     case "operation-not-allowed":
    //       print("Anonymous auth hasn't been enabled for this project.");
    //       break;
    //     default:
    //       print("Unknown error.");
    //   }
    // }
    // return result;
  }

  static Future<String> registerInEnterprise(
      String phoneNumber,
      String countryCode,
      String name,
      String typeCompte,
      String password
  ) async {

    phoneNumber_ = phoneNumber;  //with country code
    name_ = name;
    String result = "error";
    try {
      _uid = phoneNumber_;
      await FirebaseDatabase.instance.ref(firebaseEnterpriseUsersDB).child(phoneNumber_).set({
        'id': phoneNumber_,
        'name': name_,
        'tel': phoneNumber_,
        'email': phoneNumber_ + '@mail.com',
        'login': '',
        'password': '',
        'uid': '',
        'image': '',
        'thumb_image': '',
        'qrcodesource': '',
        'type_compte': typeCompte,
        'qrcodeimage': '',
        'country_code': countryCode,
        'user_id': '',
        'online': '',
        'status': 'Hello, rejoignez moi sur Weli Enterprise !',
        'reseau_id': '',
        'deleted': 'false',
      }).then((value) async {
        result = "success";
      },);
      return "success";
    } catch (e) {
      result = e.toString();
      print(">>>>>>>>>>>>>>>>>>>>>>>>>>>Error SIGN_UP Exception : " + result.toString());
      return "error";
    }

  }

  static Future<AccountLogin> login(String countryCode, String phoneNumber, String password) async {
    var accountLogin = AccountLogin();
    await getEnterpriseUserAccount(phoneNumber)
    .then((value) async {
      if(value.getResponse == 'exists'){
        accountLogin.setResponse = 'exists';
        accountLogin.setName = value.getName;
        accountLogin.setId = value.getId;
        accountLogin.setTel = value.getTel;
      }
      else {
        await registerInEnterprise(phoneNumber, countryCode, '', '', password)
        .then((value) async {
          if(value == 'success'){
            accountLogin.setResponse = 'exists';
            accountLogin.setName = '';
            accountLogin.setId = phoneNumber;
            accountLogin.setTel = phoneNumber;
          }
          else {
            accountLogin.setResponse = 'notexists';
          }
        });
      }
    });

    return accountLogin;
  }

  static Future<void> verifyOtp(String countryCode, String otp, String verificationId) async {
    try{

      countryCode_ = countryCode;

      FirebaseAuth auth = FirebaseAuth.instance;
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: otp
      );

      await auth.signInWithCredential(credential).then((value) async {
          FirebaseStorage storage = FirebaseStorage.instance;
          var sref = storage.ref('$phoneNumber_.jpeg');
          var uploadtask = sref.putFile(file_!);
          // _uid = AuthRepo.uid;

          print(">>>>>>>>>>>>SNAPSHOT<<<<<<<<<<<<<<");
          print(value);
          print(">>>>>>>>>>>>END-SNAPSHOT<<<<<<<<<<<<<<");

          await Future.value(uploadtask).then((v) async {
              sref.getDownloadURL().then((url) {
                FirebaseDatabase.instance.ref('Accounts').child(phoneNumber_).set({
                  'uid' : phoneNumber_,
                  'name' : name_,
                  'email' : phoneNumber_+'@mail.com',
                  'phoneNumber' : phoneNumber_,
                  'url' : url,
                  'type': 'customer',
                  'password': '',
                  'deleted': false,
                }).then((value) async {

                  await customers.doc(_uid).set({
                    'name': name_,
                    'email': phoneNumber_+'@mail.com',
                    'profileimage': url,
                    'phoneNumber': phoneNumber_,
                    'address': '',
                    'cid': _uid,
                    'password': '',
                    'deleted': false,
                  });

                  // Account account = new Account(_uid, name_, phoneNumber_+'@mail.com', url);
                  await SharedPref.saveData(_uid, name_, phoneNumber_, countryCode_, phoneNumber_+'@mail.com', url);

                  ShowSnackBar("Successful", "Verified");
                  // Get.to( CustomerHomeScreen());
                },);
              }).onError((error, stackTrace) {
                FirebaseAuth.instance.signOut();

                ShowSnackBar("Error", errorRead(error.toString()));
                return;
              },);
            },
          ).onError(
                (error, stackTrace) {
              FirebaseAuth.instance.signOut();
              ShowSnackBar("Error", errorRead(error.toString()));
              return;
            },
          );
        },
      ).onError(
            (error, stackTrace) {

          ShowSnackBar("Error", errorRead(error.toString()));
        },
      );

    }catch (e){
      FirebaseAuth.instance.signOut();
    }
  }

  static Future<void> verifyLoginOtp(String countryCode, String phoneNumber, String otp, String verificationId, BuildContext? context) async {
    phoneNumber_ = phoneNumber;
    try{

      FirebaseAuth auth = FirebaseAuth.instance;
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: otp,
      );

      await auth.signInWithCredential(credential).then((value) async {
        // _uid = value.user!.uid;
        final ref = FirebaseDatabase.instance.ref();
        final snapshot = await ref.child(firebaseEnterpriseUsersDB+'/$phoneNumber_').get();
        if (snapshot.exists) {
          print(">>>>>>>>>>>>SNAPSHOT verifyLoginOtp<<<<<<<<<<<<<<");
          print(snapshot.value);
          print(">>>>>>>>>>>>END-SNAPSHOT<<<<<<<<<<<<<<");
          String id = (snapshot.value as Map)['id'];
          String name = (snapshot.value as Map)['name'];
          String email = (snapshot.value as Map)['email'];
          String phone = (snapshot.value as Map)['tel'];
          String photourl = (snapshot.value as Map)['image'];
          // await SharedPref.saveData(_uid, name_, phoneNumber_, phoneNumber_+'@mail.com', photoUrl);
          await SharedPref.saveData(id, name, phone, countryCode, email, photourl);
          // final SharedPreferences pref = await _prefs;

          SharedPref.getId().then((value) async {
            if(value.isNotEmpty){
              ShowSnackBar("Successful", "Login successfully !");
              Navigator.pushAndRemoveUntil(
                context!,
                MaterialPageRoute(builder: (context) => HomeScreen()),
                (route) => false
              );
            }
            else {
              ShowSnackBar("Error", "Please try again !");
            }
          });

        } else {
          print('OTP check No data available.');
          ShowSnackBar("Error", "Please register and try again !");
        }
      },
      )
     .onError((error, stackTrace) {
          ShowSnackBar("Error", errorRead(error.toString()));
     },);

    }
    catch (e){

      FirebaseAuth.instance.signOut();
      ShowSnackBar("Error", "Please try again !");
    }
  }

  static Future<bool> createContributionTeam(
      String adminName,
      String adminPhone,
      String adminCountryCode,
      String teamName,
      String status,
      String messageToTeamsMember,
      File teamFile
      ) async {

    String time = DateFormat('h:mm:a').format(DateTime.now());
    String created_at = DateFormat('dd/MM/yyyy h:mm:a').format(DateTime.now());
    String key = DateTime.now().microsecondsSinceEpoch.toString();
    bool result = false;

    DatabaseReference dbDatabaseRef = FirebaseDatabase.instance.ref();

    // String pushKey = FirebaseDatabase.instance.ref(contributionTeamAuthorizationRef).push().key.toString();

    await storeTeamFileInStorage(teamFile, "teams", adminPhone, dbDatabaseRef)
    .then((url) async {
      await FirebaseDatabase.instance.ref(contributionTeamRef)
          .child(key)
          .set({
        'teamId' : key,
        'admin' : adminPhone,
        'adminProfileUrl' : '',
        'countryCode' : adminCountryCode,
        'teamName' : teamName,
        'teamProfileUrl' : url,
        'messageToTeamsMember': messageToTeamsMember,
        'status' : status,
        'budget' : 0,
        'time' : time,
        'created_by': adminName,
        'created_at' : created_at,
        'updated_at' : created_at,
        'deleted_at' : '',
        'deleted': false
      }).then((value) async {
        await FirebaseDatabase.instance.ref(contributionTeamAuthorizationRef)
            .push()
            .set({
          'teamId' : key,
          'teamName' : teamName,
          'teamProfileUrl' : url,
          'status' : status,
          'adminPhone' : adminPhone,
          'memberName' : adminName,
          'memberPhone' : adminPhone,
          'memberCountryCode' : adminCountryCode,
          'memberProfileUrl' : '',
          'messageToTeamsMember': messageToTeamsMember,
          'added_by_name' : adminName,
          'authorized': true,
          'deleted_from_team': false,
          'created_by': adminName,
          'created_at': created_at,
          'updated_at': created_at,
          'deleted_at' : '',
          'deleted': false
        })
        .whenComplete(() => result = true);
      });
    });

    return result;
  }

  static Future<String> storeTeamFileInStorage(
      File file,
      String storageName,
      String ownerPhone,
      DatabaseReference dbDatabaseRef
      ) async {
    // DatabaseReference dbDatabaseRef = FirebaseDatabase.instance.ref(databaseRef);
    String? pushId = dbDatabaseRef.push().key;
    // String docId = context.read<IdProvider>().getData;
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage
        .instance
        .ref('$storageName/$ownerPhone/$pushId.jpg');

    await ref.putFile(File(file!.path));

    return await ref.getDownloadURL();
  }

  static Future<void> sendMessage(String sender, String receiver, String name, String message, String url) async {

    String time = DateFormat('h:mm:a').format(DateTime.now());
    String key = DateTime.now().microsecondsSinceEpoch.toString();

    FirebaseDatabase.instance.ref(firebaseChatsDB)
      .child(sender)
      .child(receiver)
      .child(key)
      .set({
      'messageId' : key,
      'sender' : sender,
      'receiver' : receiver,
      'response_to' : '',
      'message' : message,
      'time' : time,
      'deleted': false
    });

    FirebaseDatabase.instance.ref(firebaseChatsDB)
      .child(receiver)
      .child(sender)
      .child(key)
      .set({
        'messageId' : key,
        'sender' : sender,
        'receiver' : receiver,
        'response_to' : '',
        'message' : message,
        'time' : time,
        'deleted': false
    });

    FirebaseDatabase.instance.ref(firebaseAccountDB)
      .child(sender)
      .child(firebaseChatDB)
      .child(receiver)
      .set({
      'messageId' : key,
      'name' : name,
      'phoneNumber' : receiver,
      'response_to' : '',
      'url' : url,
      'latestMessage' : message,
      'deleted': false
    });

    FirebaseDatabase.instance.ref(firebaseAccountDB)
      .child(receiver)
      .child(firebaseChatDB)
      .child(sender)
      .set({
      'messageId' : key,
      'name' : await SharedPref.getName(),
      'phoneNumber' : await SharedPref.getNumber(),
      'response_to' : '',
      'url' : await SharedPref.getUrl(),
      'latestMessage' : message,
      'deleted': false
    });

  }

  static Future<void> sendChannelMessage(String sender,String receiver,String name,String message,String url)async{

    // FirebaseDatabase.instance.ref('Accounts').child(receiver).child(firebaseChannelMessageDB).child(sender).set({
    //   'name' : await SharedPref.getName(),
    //   'phoneNumber' : await SharedPref.getNumber(),
    //   'url' : await SharedPref.getUrl(),
    //   'latestMessage' : message
    // });
    String time = DateFormat('h:mm:a').format(DateTime.now());
    String key = DateTime.now().microsecondsSinceEpoch.toString();

    FirebaseDatabase.instance.ref(firebaseChannelMessageDB).child(receiver).child(firebaseChannelLastMessageDB).set({
      'messageId' : key,
      'name' : name,
      'sender' : sender,
      'url' : url,
      'latestMessage' : message,
      'response_to' : '',
      'deleted': false,
      'updated_at': '',
      'created_at': ''
    });

    // FirebaseDatabase.instance.ref(firebaseChannelMessageDB).child(sender).child(receiver)
    FirebaseDatabase.instance.ref(firebaseChannelMessageDB).child(receiver).child(key)
      .set({
      'messageId' : key,
      'sender' : sender,
      'receiver' : receiver,
      'message' : message,
      'time' : time,
      'response_to' : '',
      'deleted': false,
      'updated_at': '',
      'created_at': ''
    });

    // FirebaseDatabase.instance.ref(firebaseChannelMessageDB).child(receiver)
    // .child(DateTime.now().microsecondsSinceEpoch.toString())
    // .set({
    //   'sender' : sender,
    //   'receiver' : receiver,
    //   'message' : message,
    //   'time' : time,
    //   'response_to' : '',
    //   'deleted': false,
    //   'updated_at': '',
    //   'created_at': ''
    // });

  }

  static Future<bool> removeChannelMessage(String messageKey, String channelKey) async {
    bool result = false;
    String time = DateFormat('h:mm:a').format(DateTime.now());

    await FirebaseDatabase.instance.ref(firebaseChannelMessageDB).child(channelKey).child(messageKey).update({
      'deleted': true,
      'updated_at': time,
      'created_at': ''
    }).whenComplete(() {
      result = true;
    });

    return result;
  }

  static Future<void> setStatusOnline()async{
    FirebaseDatabase.instance.ref('Accounts').child(number).update({
      'status' : 'Online'
    });
  }

  static Future<void> setStatusOffline()async{
    String time = DateFormat('h:mm:a').format(DateTime.now());
    FirebaseDatabase.instance.ref('Accounts').child(number).update({
      'status' : time
    });
  }

  static Future<void> sendImage(String sender,String receiver)async {
    String key=DateTime.now().microsecondsSinceEpoch.toString();

    FirebaseDatabase.instance.ref('Chats').child(sender).child(receiver).child(key).set({
      'messageId' : key,
      'sender' : sender,
      'receiver' : receiver,
      'response_to' : '',
      'message' : 'image__',
      'deleted' : false
    });

    FirebaseDatabase.instance.ref('Chats').child(receiver).child(sender).child(key).set({
      'messageId' : key,
      'sender' : sender,
      'receiver' : receiver,
      'response_to' : '',
      'message' : 'image__',
      'deleted' : false
    });


    var picker=await ImagePicker().pickImage(source: ImageSource.gallery);
    if(picker!=null){
      FirebaseStorage storage = FirebaseStorage.instance;
      var sref = storage.ref('${DateTime.now().microsecondsSinceEpoch}.jpeg');
      var uploadtask = sref.putFile(File(picker.path));
      await Future.value(uploadtask).then((v) async {
            sref.getDownloadURL().then((url) {
              String time = DateFormat('h:mm:a').format(DateTime.now());
              FirebaseDatabase.instance.ref('Chats').child(sender).child(receiver).child(key).set({
                'messageId' : key,
                'sender' : sender,
                'receiver' : receiver,
                'response_to' : '',
                'message' : 'image__',
                'time' : time,
                'url' : url,
                'deleted' : false
              });

              FirebaseDatabase.instance.ref('Chats').child(receiver).child(sender).child(key).set({
                'messageId' : key,
                'sender' : sender,
                'receiver' : receiver,
                'response_to' : '',
                'message' : 'image__',
                'time' : time,
                'url' : url,
                'deleted' : false
              });
            });
      });
    }

  }

  static Future<void> sendChannelImage(String sender,String receiver)async {
    String key=DateTime.now().microsecondsSinceEpoch.toString();

    FirebaseDatabase.instance.ref(firebaseChannelMessageDB).child(receiver).child(key).set({
      'messageId' : key,
      'sender' : sender,
      'receiver' : receiver,
      'message' : 'image__',
      'deleted' : false
    });

    // FirebaseDatabase.instance.ref(firebaseChannelMessageDB).child(receiver).child(sender).child(key).set({
    //   'sender' : sender,
    //   'receiver' : receiver,
    //   'message' : 'image__',
    //
    // });


    var picker=await ImagePicker().pickImage(source: ImageSource.gallery);
    if(picker!=null){
      FirebaseStorage storage = FirebaseStorage.instance;
      var sref = storage.ref('${DateTime.now().microsecondsSinceEpoch}.jpeg');
      var uploadtask = sref.putFile(File(picker.path));
      await Future.value(uploadtask).then((v) async {
        sref.getDownloadURL().then((url) {
          String time = DateFormat('h:mm:a').format(DateTime.now());
          FirebaseDatabase.instance.ref(firebaseChannelMessageDB).child(receiver).child(key).set({
            'messageId' : key,
            'sender' : sender,
            'receiver' : receiver,
            'message' : 'image__',
            'time' : time,
            'url' : url,
            'deleted' : false
          });

          // FirebaseDatabase.instance.ref(firebaseChannelMessageDB).child(receiver).child(sender).child(key).set({
          //   'sender' : sender,
          //   'receiver' : receiver,
          //   'message' : 'image__',
          //   'time' : time,
          //   'url' : url
          // });

        });
      });
    }

  }

  static String errorRead(String error) {
    return error.substring(error.indexOf(']') + 1, error.length);
  }
}
