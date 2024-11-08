import 'package:flutter/material.dart';
import 'package:fuelcard/Data/Netword/api/services.dart';
import 'package:fuelcard/main_screens/home.dart';
import 'package:fuelcard/widgets/dialogs.dart';
import 'package:fuelcard/widgets/snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TraiterDemandeAchatCarburant extends StatefulWidget {

  final String? achat_id;
  final String? id_sousreseau;
  final String? chauffeur_id;
  final String? chauffeur_nom;
  final String? chauffeur_tel;
  final String? immatriculation;
  final String? date_demande;
  final String? fuel_nom;
  final String? prix_litre;
  final String? montant;
  final String? currentPhone;

  const TraiterDemandeAchatCarburant({
    super.key,
    this.achat_id,
    this.id_sousreseau,
    this.chauffeur_id,
    this.chauffeur_nom,
    this.chauffeur_tel,
    this.immatriculation,
    this.date_demande,
    this.fuel_nom,
    this.prix_litre,
    this.montant,
    this.currentPhone
  });

  @override
  State<TraiterDemandeAchatCarburant> createState() => _TraiterDemandeAchatCarburantState();
}

class _TraiterDemandeAchatCarburantState extends State<TraiterDemandeAchatCarburant> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  bool processing = false;
  String immatriculation = '';
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void validerOperation(
    String immatriculationSaisi,
    String achat_id,
    String sousreseau_id,
    String chauffeur_id,
    String chauffeur_nom,
    String chauffeur_tel,
    String immatriculationChauffeur,
    String date_demande,
    String fuel_nom,
    String prix_litre,
    String montant,
    String gerantSousReseauPhone
  ) {

    if(immatriculationSaisi == immatriculationChauffeur) {

      //enregistrer la demande/transaction
      sendToSubPoint(
        achat_id,
        sousreseau_id,
        chauffeur_id,
        chauffeur_tel,
        montant,
        gerantSousReseauPhone
      ).then((value) {
        if(value.response == 'success'){

          MyMessageHandler.showSnackBar(
              _scaffoldKey, 'Operation effectuée avec succès !'
          );

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
              (route) => false
          );

        }
        else {
          setState(() {
            processing = false;
          });
          showDialog(
              context: context,
              builder: (context) {
                return ConfirmationDialog(
                  backgroundColor: Colors.white,
                  actionButtonTextColor: Colors.black,
                  actionCallbacks: {
                    'Cancel': () {
                      setState(() {
                        processing = false;
                        Navigator.of(context).pop();
                      });
                    },
                    'Retour': () async {
                      processing = false;
                      Navigator.of(context).pop();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                              (route) => false
                      );
                    },
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        value.message ?? 'Veuillez reessayer, erreur serveur !',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        'Connecion internet lente',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              }
          );
        }
      });

    }
    else {

      setState(() {
        processing = false;
      });

      MyMessageHandler.showSnackBar(
          _scaffoldKey, 'Operation impossible !'
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
              child: Column(
                children: [
                  Text(
                    'Date : ' + widget.date_demande.toString(),
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    'Conducteur : ' + widget.chauffeur_nom.toString(),
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    'Tel conducteur : ' + widget.chauffeur_tel.toString(),
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    'Carburant : ' + widget.fuel_nom.toString(),
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    'Prix du litre : ' + widget.prix_litre.toString(),
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    'Montant : ' + widget.montant.toString(),
                    style: TextStyle(fontSize: 20),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: TextFormField(
                            // controller: _passwordController,
                              validator: (value){
                                if(value!.isEmpty) {
                                  return 'please enter id';
                                }
                                return null;
                              },
                              onChanged: (value){
                                // amount = value != '' ? int.parse(value!) : 0;
                                immatriculation = value;
                              },
                              // keyboardType: const TextInputType.,
                              decoration: textFormDecoration.copyWith(
                                  suffixIcon: IconButton(
                                      onPressed: (){
                                        setState(() {

                                        });
                                      },
                                      icon: Icon(
                                        Icons.car_crash,
                                        color: Colors.purple,
                                      )
                                  ),
                                  labelText: 'Immatriculation',
                                  hintText: 'Enter your ID'
                              )
                          ),
                        ),
                        processing == true
                            ? const Center(child: CircularProgressIndicator(color: Colors.purple))
                            : Material(
                          color: Colors.purple,
                          borderRadius: BorderRadius.circular(25),
                          child: MaterialButton(
                            minWidth: double.infinity,
                            onPressed: (){
                              validerOperation(
                                  immatriculation,
                                  widget.achat_id!,
                                  widget.id_sousreseau!,
                                  widget.chauffeur_id!,
                                  widget.chauffeur_nom!,
                                  widget.chauffeur_tel!,
                                  widget.immatriculation!,
                                  widget.date_demande!,
                                  widget.fuel_nom!,
                                  widget.prix_litre!,
                                  widget.montant!,
                                  widget.currentPhone!
                              );
                            },
                            child: Text(
                              'Valider',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

var textFormDecoration = InputDecoration(
    labelText: 'Full Name',
    hintText: 'Enter your full name',
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25)
    ),
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: Colors.purple,
            width: 1
        ),
        borderRadius: BorderRadius.circular(25)
    ),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: Colors.deepPurpleAccent,
            width: 2
        ),
        borderRadius: BorderRadius.circular(25)
    )
);
