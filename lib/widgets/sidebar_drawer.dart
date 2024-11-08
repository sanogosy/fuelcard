import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fuelcard/main_screens/customer_home.dart';
import 'package:fuelcard/main_screens/home.dart';
import 'package:fuelcard/main_screens/profile.dart';
import 'package:fuelcard/widgets/alert_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideBarDrawer extends StatefulWidget {
  const SideBarDrawer({super.key});

  @override
  State<SideBarDrawer> createState() => _SideBarDrawerState();
}

class _SideBarDrawerState extends State<SideBarDrawer> {

  late Future<String> documentId;
  late String docId;
  CollectionReference customers = FirebaseFirestore.instance.collection('customers');
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    // TODO: implement initState
    _prefs = SharedPreferences.getInstance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<String>(
          future: documentId,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const Material(child: Center(child: CircularProgressIndicator()));
            // case ConnectionState.active:
              case ConnectionState.done:
                return docId != '' ? userScaffold() : noUserScaffold();
              default:
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
            }
            return const Material(child: Center(child: CircularProgressIndicator()));
          }
      )
    );
  }

  Widget userScaffold() {
    return FutureBuilder<DocumentSnapshot>(
      // future: FirebaseAuth.instance.currentUser!.isAnonymous
      //     ? anonymous.doc(docId).get()
      //     : customers.doc(docId).get(),
        future: customers.doc(docId).get(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if(snapshot.hasError) {
            //
          }

          if(snapshot.hasData && !snapshot.data!.exists) {
            //
          }

          if(snapshot.connectionState == ConnectionState.done && snapshot.data!.data() != null) {
            // if(snapshot.data!.data() != null) {
              Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

              return Scaffold(
                backgroundColor: Colors.grey.shade300,
                body: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    UserAccountsDrawerHeader(
                      accountName: Text(
                          data['name'].toString()
                      ),
                      accountEmail: Text(
                          data['email'].toString()
                      ),
                      currentAccountPicture: data['profileimage'] == ''
                          ? const CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('images/inapp/guest.jpg'),
                      )
                          : CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(data['profileimage']),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.pinkAccent,
                          image: DecorationImage(
                              image: AssetImage('images/inapp/coverimage.jpg'),
                              fit: BoxFit.cover)
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.home),
                      title: Text('Home'),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const CustomerHomeScreen(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text('Account'),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('Paramètres'),
                      onTap: () {
                        //
                      },
                    ),
                    RepeatedListTile(
                      title: 'Log Out',
                      icon: Icons.logout,
                      onPressed: () {
                        MyAlertDialog.showMyDialog(
                          context: context,
                          title: 'Log Out',
                          content: 'Are you sure to log out ?',
                          tabNo: () {
                            Navigator.pop(context);
                          },
                          tabYes: () async {

                          },
                        );
                      },
                    ),
                  ],
                ),
              );
            // }
          }

          if(snapshot.connectionState == ConnectionState.done && snapshot.data!.data() == null) {
            // if(snapshot.data!.data() != null) {
            // Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

            return Scaffold(
              backgroundColor: Colors.grey.shade300,
              body: ListView(
                padding: EdgeInsets.zero,
                children: [
                  RepeatedListTile(
                    title: 'Log Out',
                    icon: Icons.logout,
                    onPressed: () {
                      MyAlertDialog.showMyDialog(
                        context: context,
                        title: 'Log Out',
                        content: 'Are you sure to log out ?',
                        tabNo: () {
                          Navigator.pop(context);
                        },
                        tabYes: () async {

                        },
                      );
                    },
                  ),
                ],
              ),
            );
            // }
          }

          return const Center(
            child: CircularProgressIndicator(
              color: Colors.purple,
            ),
          );

        }
    );
  }

  Widget noUserScaffold() {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              'Guest'
            ),
            accountEmail: Text(
                'guest@mail.com'
            ),
            currentAccountPicture: const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('images/inapp/guest.jpg'),
            ),
            decoration: BoxDecoration(
                color: Colors.pinkAccent,
                image: DecorationImage(image: AssetImage('images/inapp/coverimage.jpg'), fit: BoxFit.cover)
            ),
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text(''),
            onTap: () {
              //
            },
          )
        ],
      ),
    );
  }
}
