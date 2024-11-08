import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:fuelcard/Data/Netword/Firebase/firebase_services.dart';
import 'package:fuelcard/Data/entity/abonnement_routier.dart';
import 'package:fuelcard/Data/entity/account_login.dart';
import 'package:fuelcard/Data/entity/generic_response.dart';
import 'package:fuelcard/Data/entity/operation.dart';
import 'package:fuelcard/Data/entity/profile.dart';
import 'package:fuelcard/Data/entity/profile.dart';
import 'package:fuelcard/Data/entity/transfert_response.dart';
import 'package:fuelcard/Data/entity/user_account.dart';
import 'package:fuelcard/constants/allconstant.dart';
import 'package:fuelcard/utilities/operation_data_source.dart';
import 'package:http/http.dart' as http;

//Create
Future<UserAccount> create(String name, String tel, String avatarUrl) async {
  Map<String, dynamic> request = {
    'name': name,
    'tel': tel,
    'avatarUrl': avatarUrl
  };

  final uri = Uri.parse("http://");
  final response = await http.post(uri, body: request);

  if(response.statusCode == 201) {
    return UserAccount.fromJson(json.decode(response.body));
  }
  else {
    throw Exception('Failed to create account');
  }

}

//Fetch one
Future<GeneralResponse> getCurrentBalance(String phoneNumber) async {
  // final queryParameters = {
  //   'phoneNumber': phoneNumber,
  // };
  // final uri = Uri.https('localhost:8000', '/api/weli_enterprise/getuser.php', queryParameters);
  // final response = await http.get(uri, headers: {
  //   HttpHeaders.authorizationHeader: 'Token $token',
  //   HttpHeaders.contentTypeHeader: 'application/json',
  // });
  // final response = await http.get(uri);
  final url = Uri.parse('$apiUrl$apiAccountBalanceFile');
  var data = {
    'phoneNumber': phoneNumber
  };

  var response = await http.post(url, body: data);
  try {
    print('<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>> : ' + response.body);
    if (response.statusCode == 200) {
      return GeneralResponse.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }
    else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }
  on SocketException {
    print('No Internet connection 😑');
    throw Exception('Failed to create album.');
  } on HttpException {
    print("Couldn't find the post 😱");
    throw Exception('Failed to create album.');
  } on FormatException {
    print("Bad response format 👎");
    throw Exception('Bad response format.');
  }
}

Future<UserAccount> fetchOne(String phoneNumber, String countryCode) async {

  final url = Uri.parse('$apiUrl$apiGetUserFile');
  // String url = "http://192.168.43.215/login_api/get_user.php";
  var data = {
    'phoneNumber': phoneNumber,
    'password': '',
  };

  var response = await http.post(url, body: data);
  // var response = await http.post(url, body: json.encode(data));
  if (response.statusCode == 200) {
    //Server response into variable
    print('>>>>>>>>>>> ' + response.body);
    // var msg = jsonDecode(response.body);
    //Check Login Status
    return UserAccount.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    // }
  }
  else {
    throw Exception('Please try again !');
  }
}

Future<GeneralResponse> initierAchat(
    String montant,
    String acheteurPhone,
    String boutiquePhone,
    String typeCarburant
) async {

  final url = Uri.parse('$apiUrl$apiDemandeAchatFile');
  // String url = "http://192.168.43.215/login_api/get_user.php";
  var data = {
    'montant': montant,
    'expediteur': acheteurPhone,
    'beneficiaire': boutiquePhone,
    'typeCarburant': typeCarburant
  };

  var response = await http.post(url, body: data);
  try {
    print('<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>> : ' + response.body);
    if (response.statusCode == 200) {
      return GeneralResponse.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }
    else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }
  on SocketException {
    print('No Internet connection 😑');
    throw Exception('Failed to create album.');
  } on HttpException {
    print("Couldn't find the post 😱");
    throw Exception('Failed to create album.');
  } on FormatException {
    print("Bad response format 👎");
    throw Exception('Bad response format.');
  }
}

Future<Profile> getProfile(String phoneNumber, String password) async {

  final url = Uri.parse('$apiUrl$apiGetProfileFile');
  // String url = "http://192.168.43.215/login_api/get_user.php";
  var data = {
    'phoneNumber': phoneNumber,
    'password': '',
  };

  var response = await http.post(url, body: data);
  // var response = await http.post(url, body: json.encode(data));
  if (response.statusCode == 200) {
    //Server response into variable
    print('>>>>>>>>>>> Response : ' + response.body);
    // var msg = jsonDecode(response.body);
    //Check Login Status
    return Profile.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    // }
  }
  else {
    throw Exception('Please try again !');
  }
}

Future<GeneralResponse> sendOperationsToCentral(String phoneNumber) async {

  final url = Uri.parse('$apiUrl$apiTransfertOperationFile');
  // String url = "http://192.168.43.215/login_api/get_user.php";
  var data = {
    'phoneNumber': phoneNumber,
  };

  var response = await http.post(url, body: data);
  // var response = await http.post(url, body: json.encode(data));
  if (response.statusCode == 200) {
    //Server response into variable
    print('>>>>>>>>>>> ' + response.body);
    // var msg = jsonDecode(response.body);
    //Check Login Status
    return GeneralResponse.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    // }
  }
  else {
    throw Exception('Please try again !');
  }
}

//Fetch
Future<UserAccount> fetchPost() async {
  final uri = Uri.parse("https://");
  final response = await http.get(uri);

  if(response.statusCode == 200) {
    return UserAccount.fromJson(json.decode(response.body));
  }
  else {
    throw Exception('Failed to load data');
  }
}

//Update
Future<UserAccount> update(String name, String tel, String avatarUrl) async {
  Map<String, dynamic> request = {
    'id': tel,
    'name': name,
    'avatarUrl': avatarUrl
  };

  final uri = Uri.parse("https://");
  final response = await http.put(uri, body: request);

  if(response.statusCode == 200) {
    return UserAccount.fromJson(json.decode(response.body));
  }
  else {
    throw Exception('Failed to updated');
  }

}

Future<UserAccount?>? deleteAccount() async {
  final uri = Uri.parse("https://");
  final response = await http.delete(uri);

  if(response.statusCode == 200) {
    return null;
  }
  else {
    throw Exception('Failed to updated');
  }
}

Future<TransfertResponse> sendToSubPoint(
    String achat_id,
    String sousreseau_id,
    String chauffeur_id,
    String chauffeur_tel,
    String montant,
    String gerantSousReseauPhone
) async {

  final url = Uri.parse('$apiUrl$apiTransfertFile');
  // String url = "http://192.168.43.215/login_api/get_user.php";
  var data = {
    'achat_id': achat_id,
    'sousreseau_id': sousreseau_id,
    'chauffeur_id': chauffeur_id,
    'chauffeur_tel': chauffeur_tel,
    'montant': montant,
    'gerantSousReseauPhone': gerantSousReseauPhone,
  };

  // var response = await http.post(url, body: json.encode(data));
  var response = await http.post(url, body: data);
  if (response.statusCode == 200) {
    //Server response into variable
    print(response.body);
    var msg = jsonDecode(response.body);
    //Check Login Status
    return TransfertResponse.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    // }
  }
  else {
    throw Exception('Please try again !');
  }
}

// Future<dynamic> generateEmployeeList(OperationDataSource operationDataSource) async {
//
//   // Give your sever URL of get_employees_details.php file
//   final url = Uri.parse('$apiUrl$apiHistoriqueOperationNonTransferesSousReseauFile');
//
//   final response = await http.get(url);
//   var list = json.decode(response.body);
//   List<Operation> _operations =
//   await list.map<Operation>((json) => Operation.fromJson(json)).toList();
//   operationDataSource = OperationDataSource(_operations);
//   return _operations;
// }

Future<AbonnementRoutier> getAbonnementRoutier(String phoneNumber) async {

  final url = Uri.parse('$apiUrl$apiAbonnementRoutierFile');
  var data = {
    'phoneNumber': phoneNumber
  };

  var response = await http.post(url, body: data);
  try {
    print('<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>> : ' + response.body);
    if (response.statusCode == 200) {
      return AbonnementRoutier.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }
    else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to get response.');
    }
  }
  on SocketException {
    print('No Internet connection 😑');
    throw Exception('Failed to create album.');
  } on HttpException {
    print("Couldn't find the post 😱");
    throw Exception('Failed to create album.');
  } on FormatException {
    print("Bad response format 👎");
    throw Exception('Bad response format.');
  }
}