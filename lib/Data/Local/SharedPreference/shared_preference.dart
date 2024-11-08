import 'package:flutter/material.dart';
import 'package:fuelcard/constants/allconstant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref{
  static Future<void> saveData(uid, name, phoneNumber, countryCode, email, url)async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    pref.setString(customerId, uid);
    pref.setString(currentUserName, name);
    pref.setString(currentUserPhone, phoneNumber);
    pref.setString(currentUserCountryCode, countryCode);
    pref.setString(currentUserEmail, email);
    pref.setString(currentUserPhotoUrl, url);
  }

  // setCurrentCustomer(String uid, String name, String email, String photoUrl) async {
  //   // User user = FirebaseAuth.instance.currentUser!;
  //
  //   final SharedPreferences pref = await _prefs;
  //   pref.setString(customerId, uid).whenComplete(() => _customerId = uid);
  //   pref.setString(currentUserName, name);
  //   pref.setString(currentUserEmail, email);
  //   pref.setString(currentUserPhotoUrl, photoUrl);
  //   notifyListeners();
  // }

  static Future<String> getId() async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    return pref.getString(customerId) ?? '';
  }

  static Future<String> getName()async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    return pref.getString("NAME") ?? '';
  }
  static Future<String> getNumber()async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    return pref.getString("EMAIL") ?? '';
  }
  static Future<String> getUrl()async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    return pref.getString("URL") ?? '';
  }

  // static Future<String> getCurrentBalance()async{
  //   SharedPreferences pref=await SharedPreferences.getInstance();
  //   return pref.getString("currentBalance")!;
  // }
}