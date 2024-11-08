// import 'dart:io';
//
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_database/ui/firebase_animated_list.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import 'package:r_shop_customer/Data/Netword/Firebase/firebase_services.dart';
// import 'package:r_shop_customer/constants/allconstant.dart';
// import 'package:r_shop_customer/providers/id_provider.dart';
// import 'package:r_shop_customer/utilities/categ_list.dart';
// import 'package:r_shop_customer/widgets/yellow_button.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class ChatChannelScreen extends StatefulWidget {
//   const ChatChannelScreen({super.key});
//
//   @override
//   State<ChatChannelScreen> createState() => _ChatChannelScreenState();
// }
//
// class _ChatChannelScreenState extends State<ChatChannelScreen> {
//
//   late Future<String> documentId;
//   late String docId;
//   String? currentPhone;
//   late String comment;
//   String mainCategValue = 'select category';
//   bool processing = false;
//   XFile? _imageFile;
//   dynamic _pickedImageError;
//   final ImagePicker _picker = ImagePicker();
//   // CollectionReference anonymous = FirebaseFirestore.instance.collection('anonymous');
//   final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
//   var message = TextEditingController();
//   // final ChatState controller = Get.put(ChatState());
//   // final String senderNumber = '0${FirebaseAuth.instance.currentUser!.phoneNumber!.substring(3, 13)}';
//   final String senderNumber = '${FirebaseAuth.instance.currentUser!.phoneNumber!.substring(1, 12)}';
//   final scrollController=ScrollController();
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     documentId = context.read<IdProvider>().getDocumentId();
//     docId = context.read<IdProvider>().getData;
//     // currentPhone = getUserCurrentPhone() as String?;
//     // getUserCurrentPhone().then((value) {
//     //   currentPhone = value;
//     //   // print(">>>>>>>>>>>>>>>> Phone : " + currentPhone.toString());
//     // });
//
//     super.initState();
//   }
//
//   void selectedMainCateg(String ? value) {
//     // if(value == 'select category'){
//     //   subCategList = [];
//     // }
//     // else if(value == 'men'){
//     //   // setState(() {
//     //   //   subCategValue = 'shirt';
//     //   // });
//     //   subCategList = men;
//     // }
//     // else if(value == 'women'){
//     //   // setState(() {
//     //   //   subCategValue = 'w shirt';
//     //   // });
//     //   subCategList = women;
//     // }
//     // else if(value == 'electronics'){
//     //   // setState(() {
//     //   //   subCategValue = 'w shirt';
//     //   // });
//     //   subCategList = electronics;
//     // }
//     // else if(value == 'accessories'){
//     //   // setState(() {
//     //   //   subCategValue = 'w shirt';
//     //   // });
//     //   subCategList = accessories;
//     // }
//     // else if(value == 'shoes'){
//     //   // setState(() {
//     //   //   subCategValue = 'w shirt';
//     //   // });
//     //   subCategList = shoes;
//     // }
//     // else if(value == 'home & garden'){
//     //   // setState(() {
//     //   //   subCategValue = 'w shirt';
//     //   // });
//     //   subCategList = homeandgarden;
//     // }
//     // else if(value == 'beauty'){
//     //   // setState(() {
//     //   //   subCategValue = 'w shirt';
//     //   // });
//     //   subCategList = beauty;
//     // }
//     // else if(value == 'kids'){
//     //   // setState(() {
//     //   //   subCategValue = 'w shirt';
//     //   // });
//     //   subCategList = kids;
//     // }
//     // else if(value == 'bags'){
//     //   // setState(() {
//     //   //   subCategValue = 'w shirt';
//     //   // });
//     //   subCategList = bags;
//     // }
//     setState(() {
//       mainCategValue = value!;
//     });
//   }
//
//   Future<String> getUserCurrentPhone() async {
//     final SharedPreferences pref = await _prefs;
//     return await pref.getString(currentUserPhone)!;
//     // print(">>>>>>>>>>>>>>Current phone : " + currentPhone.toString());
//   }
//
//   void _pickImageFromCamera() async {
//     try{
//       final pickedImage = await _picker.pickImage(
//           source: ImageSource.camera,
//           maxHeight: 300,
//           maxWidth: 300,
//           imageQuality: 95
//       );
//
//       setState(() {
//         _imageFile = pickedImage;
//       });
//     }
//     catch(e) {
//       setState(() {
//         _pickedImageError = e;
//       });
//
//       print('>>>>>>>>>>>>>>>>>>>>>>>>>LOGGER>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
//       print(_pickedImageError);
//     }
//   }
//
//   void _pickImageFromGallery() async {
//     try{
//       final pickedImage = await _picker.pickImage(
//           source: ImageSource.gallery,
//           maxHeight: 300,
//           maxWidth: 300,
//           imageQuality: 95
//       );
//
//       setState(() {
//         _imageFile = pickedImage;
//       });
//     }
//     catch(e) {
//       setState(() {
//         _pickedImageError = e;
//       });
//
//       print('>>>>>>>>>>>>>>>>>>>>>>>>>LOGGER>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
//       print(_pickedImageError);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             const SizedBox(
//               height: 20,
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 30),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "Search",
//                     style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       showDialog(
//                         context: context,
//                         builder: (context) => Material(
//                           color: Colors.white,
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.spaceAround,
//                               children: [
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Row(
//                                       mainAxisAlignment: MainAxisAlignment.end,
//                                       children: [
//                                         Container(
//                                           decoration: BoxDecoration(
//                                               color: Colors.purple,
//                                               borderRadius: BorderRadius.circular(15)
//                                           ),
//                                           child: IconButton(
//                                               onPressed: (){
//                                                 _pickImageFromCamera();
//                                               },
//                                               icon: Icon(
//                                                 Icons.camera_alt,
//                                                 color: Colors.white,
//                                               )
//                                           ),
//                                         ),
//                                         SizedBox(width: MediaQuery.of(context).size.width * 0.08,),
//                                         Container(
//                                           decoration: BoxDecoration(
//                                               color: Colors.purple,
//                                               borderRadius: BorderRadius.circular(15)
//                                           ),
//                                           child: IconButton(
//                                               onPressed: (){
//                                                 _pickImageFromGallery();
//                                               },
//                                               icon: Icon(
//                                                 Icons.photo,
//                                                 color: Colors.white,
//                                               )
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                     Column(
//                                       children: [
//                                         const Text(
//                                           '* select category',
//                                           style: TextStyle(
//                                               color: Colors.red
//                                           ),
//                                         ),
//                                         DropdownButton(
//                                             iconSize: 40,
//                                             iconEnabledColor: Colors.red,
//                                             dropdownColor: Colors.yellow.shade400,
//                                             value: mainCategValue,
//                                             items: maincateg.map<DropdownMenuItem<String>>((value) {
//                                               return DropdownMenuItem(
//                                                 child: Text(value),
//                                                 value: value,
//                                               );
//                                             }).toList(),
//                                             onChanged: (String? value){
//                                               selectedMainCateg(value);
//                                             }
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                                 Container(
//                                     height: MediaQuery.of(context).size.height * 0.40,
//                                     width: MediaQuery.of(context).size.width * 1,
//                                     decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(15),
//                                         color: Colors.grey.shade300
//                                     ),
//                                     child: _imageFile == null
//                                         ? Center(
//                                       child: Text(
//                                         'Picture Here',
//                                       ),
//                                     )
//                                         : ClipRRect(
//                                       borderRadius: BorderRadius.circular(15),
//                                       child: Image(
//                                         image: FileImage(File(_imageFile!.path)),
//                                         fit: BoxFit.fill,
//                                       ),
//                                     )
//                                 ),
//                                 // : Padding(
//                                 //   padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
//                                 //   child: (
//                                 //     radius: 1,
//                                 //     backgroundColor: Colors.purpleAccent,
//                                 //     backgroundImage: ,
//                                 //   ),
//                                 // ),
//                                 Column(
//                                   children: [
//                                     const SizedBox(height: 10,),
//                                     TextField(
//                                       decoration: InputDecoration(
//                                           hintText: 'Enter your message ...',
//                                           border: OutlineInputBorder(
//                                               borderRadius: BorderRadius.circular(15)
//                                           ),
//                                           enabledBorder: OutlineInputBorder(
//                                               borderSide: const BorderSide(
//                                                   color: Colors.grey,
//                                                   width: 1
//                                               ),
//                                               borderRadius: BorderRadius.circular(15)
//                                           ),
//                                           focusedBorder: OutlineInputBorder(
//                                               borderSide: const BorderSide(
//                                                   color: Colors.amber,
//                                                   width: 2
//                                               ),
//                                               borderRadius: BorderRadius.circular(15)
//                                           )
//                                       ),
//                                       onChanged: (value) {
//                                         comment = value;
//                                       },
//                                     ),
//                                   ],
//                                 ),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.end,
//                                   children: [
//                                     YellowButton(
//                                       label: 'cancel',
//                                       onPressed: (){
//                                         _imageFile = null;
//                                         Navigator.pop(context);
//                                       },
//                                       width: 0.3,
//                                     ),
//                                     const SizedBox(width: 20,),
//                                     YellowButton(
//                                       label: 'ok',
//                                       onPressed: () async {
//                                         // CollectionReference collRef = FirebaseFirestore.instance.collection('products')
//                                         //     .doc(widget.order['proid'])
//                                         //     .collection('reviews');
//                                         //
//                                         // String docId = context.read<IdProvider>().getData;
//                                         // // await collRef.doc(FirebaseAuth.instance.currentUser!.uid)
//                                         // await collRef.doc(docId).set({
//                                         //   'cid': docId,
//                                         //   'orderid': widget.order['orderid'],
//                                         //   'name': widget.order['custname'],
//                                         //   'email': widget.order['email'],
//                                         //   'rate': rate,
//                                         //   'comment': comment,
//                                         //   'profileimage': widget.order['profileimage']
//                                         // }).whenComplete(() async {
//                                         //   await FirebaseFirestore.instance.runTransaction((transaction) async {
//                                         //     DocumentReference documentRef = FirebaseFirestore.instance.collection('orders')
//                                         //         .doc(widget.order['orderid']);
//                                         //
//                                         //     await transaction.update(
//                                         //         documentRef,
//                                         //         {
//                                         //           'orderreview': true
//                                         //         });
//                                         //   });
//                                         //   await Future.delayed(const Duration(microseconds: 100))
//                                         //       .whenComplete(() => Navigator.pop(context));
//                                         // });
//                                       },
//                                       width: 0.3,
//                                     )
//                                   ],
//                                 )
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                     child: Icon(
//                       Icons.edit,
//                       color: Colors.blueAccent,
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             Container(
//               height: 40,
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               margin: const EdgeInsets.symmetric(horizontal: 30,vertical: 20),
//               decoration: BoxDecoration(
//                 color: Colors.grey.withOpacity(.1),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Center(
//                 child: Stack(
//                   children: [
//                     TextFormField(
//                       enabled: true,
//                       decoration: const InputDecoration(
//                         contentPadding: EdgeInsets.only(bottom: 10),
//                         hintText: "Search",
//                         border: InputBorder.none,
//                         // icon: Icon(
//                         //   CupertinoIcons.search,color: Colors.grey,
//                         // )
//                       ),
//                     ),
//                     Positioned(
//                       top: MediaQuery.of(context).size.height * 0.01,
//                       right: 0,
//                       child: Icon(
//                         Icons.search,
//                         color: Colors.grey,
//                         size: 33,
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20,),
//             Expanded(
//                 child: FirebaseAnimatedList(
//                   query: FirebaseDatabase.instance.ref(firebaseChannelDB).child(currentUserPhone!),
//                   itemBuilder: (context, snapshot, animation, index) {
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 10),
//                       child: InkWell(
//                         onTap: snapshot.child('phoneNumber').value.toString() != currentPhone
//                             ? () {
//                           // Get.to(
//                           // ChatScreen(
//                           //     receiverNumber: snapshot.child('phoneNumber').value.toString(),
//                           //     url:
//                           //     snapshot.child('url').value.toString(),
//                           //     receiverName: snapshot.child('name').value.toString()
//                           // )
//                           // );
//                         }
//                             : () {
//                           //view current user profile
//                         },
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Row(
//                               children: [
//                                 CachedNetworkImage(imageUrl: snapshot.child('url').value.toString(),
//                                   placeholder: (context, url) {
//                                     return const Center(
//                                       child: SizedBox(
//                                         height: 15,
//                                         width: 15,
//                                         child: CircularProgressIndicator(color: Colors.deepOrangeAccent,),
//                                       ),
//                                     );
//                                   },
//                                   imageBuilder: (context, imageProvider) {
//                                     return Card(
//                                       margin: EdgeInsets.zero,
//                                       elevation: 5,
//                                       color: Colors.deepOrangeAccent,
//                                       shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(70)
//                                       ),
//                                       child: CircleAvatar(
//                                         radius: 30,
//                                         backgroundImage: imageProvider,
//                                       ),
//                                     );
//                                   },
//                                 ),
//                                 const SizedBox(width: 20,),
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   children: [
//                                     Text(snapshot.child('name').value.toString(),style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
//                                     Text(snapshot.child('phoneNumber').value.toString(),style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: Colors.grey),),
//                                   ],
//                                 )
//                               ],
//                             ),
//                             PopupMenuButton(
//                                 position: PopupMenuPosition.under,
//                                 onSelected: (value) {
//                                   // your logic
//                                   // setState(() {
//                                   // selectedItem = value.toString();
//                                   // });
//                                   // print(value);
//                                   if(value == 'more'){
//                                     //
//                                   }
//                                   if(value == 'write' && snapshot.child('phoneNumber').value.toString() != currentPhone){
//                                     // Get.to(
//                                     //     ChatScreen(
//                                     //         receiverNumber: snapshot.child('phoneNumber').value.toString(),
//                                     //         url:
//                                     //         snapshot.child('url').value.toString(),
//                                     //         receiverName: snapshot.child('name').value.toString()
//                                     //     )
//                                     // );
//                                   }
//                                   if(value == 'edit'){
//                                     //
//                                   }
//                                 },
//                                 itemBuilder: (BuildContext bc) {
//                                   return [
//                                     PopupMenuItem(
//                                       child: TextButton.icon(
//                                         style: TextButton.styleFrom(
//                                             foregroundColor: Colors.blueAccent,
//                                             textStyle: const TextStyle(fontSize: 17)),
//                                         icon: const Icon(Icons.remove_red_eye_outlined),
//                                         onPressed: () {},
//                                         label: const Text('More'),
//                                       ),
//                                       value: 'more',
//                                     ),
//                                     snapshot.child('phoneNumber').value.toString() != currentPhone
//                                         ? PopupMenuItem(
//                                       child: TextButton.icon(
//                                         style: TextButton.styleFrom(
//                                             foregroundColor: Colors.blueAccent,
//                                             textStyle: const TextStyle(fontSize: 17)),
//                                         icon: const Icon(Icons.message),
//                                         onPressed: () {},
//                                         label: const Text('Message'),
//                                       ),
//                                       value: 'message',
//                                     )
//                                         : PopupMenuItem(
//                                       child: TextButton.icon(
//                                         style: TextButton.styleFrom(
//                                             foregroundColor: Colors.blueAccent,
//                                             textStyle: const TextStyle(fontSize: 17)),
//                                         icon: const Icon(Icons.edit),
//                                         onPressed: () {},
//                                         label: const Text('Edit'),
//                                       ),
//                                       value: 'edit',
//                                     ),
//                                     // PopupMenuItem(
//                                     //   child: Text("Delete"),
//                                     //   value: '/delete',
//                                     // )
//                                   ];
//                                 }
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 )
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
