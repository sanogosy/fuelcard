import 'package:flutter/material.dart';
import 'package:fuelcard/Data/Local/SharedPreference/shared_preference.dart';
import 'package:fuelcard/Data/Netword/api/services.dart';
import 'package:fuelcard/main_screens/home.dart';
import 'package:fuelcard/widgets/snackbar.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:radio_group_v2/radio_group_v2.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FoundQrCodeScreen extends StatefulWidget {
  final List<Barcode>? barcodes;
  final String? value;
  final Function() screenClosed;

  const FoundQrCodeScreen({
    Key? key,
    this.barcodes,
    this.value,
    required this.screenClosed,
  }) : super(key: key);

  @override
  State<FoundQrCodeScreen> createState() => _FoundQrCodeScreenState();
}

class _FoundQrCodeScreenState extends State<FoundQrCodeScreen> {

  /// The currently selected value of the vertical radio group.
  ///
  /// This one is obtained automatically, thanks to the onChange() method.
  String verticalValAutomatic = "";

  /// The currently selected value of the vertical radio group.
  ///
  /// This one is obtained by clicking the "Fetch Selected" button under the
  /// vertical radio group.
  String verticalValRequested = "";

  /// The currently selected value of the horizontal radio group.
  ///
  /// This one is obtained automatically, thanks to the onChange() method.
  String horizontalValAutomatic = "";

  /// The currently selected value of the horizontal radio group.
  ///
  /// This one is obtained by clicking the "Fetch Selected" button under the
  /// horizontal radio group.
  String horizontalValRequested = "";

  /// The controller for the vertical radio group.
  final RadioGroupController verticalGroupController = RadioGroupController();

  /// The controller for the horizontal radio group.
  final RadioGroupController horizontalGroupController = RadioGroupController();

  /// The values for the vertical radio group.
  final List<String> verticalValues = [
    "Super 91 (S91)",
    "Essence (ES)",
    "Gazoil (GA)"
  ];

  /// The values for the horizontal radio group.
  final List<Text> horizontalValues = [
    const Text("Widget 1"),
    const Text("Widget 2"),
    const Text("Widget 3"),
    const Text("Widget 4"),
    const Text("Widget 5"),
  ];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  bool processing = false;
  int amount = 0;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  late String currentPhone;
  String beneficiairePhone = '';

  @override
  void initState() {
    // TODO: implement initState
    init();
    beneficiairePhone = widget.value ?? '';
    super.initState();
  }

  Future<void> init() async {
    await SharedPref.getId().then((value) async {
      print('>>>>>>>>>>>>Phone : ' + value);
      currentPhone = value;
    });
    setState(() {

    });
  }

  void demandeAchat(
      int montant,
      String expediteurPhone,
      String beneficiairePhone,
      String typeCarburant
  ) async {

    setState(() {
      processing = true;
    });

    if(_formKey.currentState!.validate()){

      if(montant > 0) {
        try{
          initierAchat(
              montant.toString(),
              expediteurPhone,
              beneficiairePhone,
              typeCarburant
          ).then((value) async {
            print(">>>>>>>>>>>>>>>>>>>>>>FETCH-ONE");
            print(value);

            if(value.response!.isNotEmpty){
              //successful
              setState(() {
                processing = false;
              });

              MyMessageHandler.showSnackBar(
                  _scaffoldKey, 'Demande effectuée avec succès !'
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
              MyMessageHandler.showSnackBar(
                  _scaffoldKey, 'Veuillez saisir un montant valide'
              );
            }
          });
        }
        catch(e){
          print('>>>>>>>>>>>>>>>>>Error : ' + e.toString());
          setState(() {
            processing = false;
          });
          MyMessageHandler.showSnackBar(
              _scaffoldKey, 'Erreur interne, veuillez réessayer plus tard ...'
          );
        }
      }
      else {
        setState(() {
          processing = false;
        });

        MyMessageHandler.showSnackBar(
            _scaffoldKey, 'Veuillez saisir un montant valide'
        );

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
        appBar: AppBar(
          title: Text("Found Code"),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              widget.screenClosed();
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_outlined,),
          ),
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              reverse: true,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // selectedValBoard(verticalValAutomatic, verticalValRequested),
                    IntrinsicWidth(
                      child: RadioGroup(
                        controller: verticalGroupController,
                        values: verticalValues,
                        onChanged: (newValue) => setState(() {
                          verticalValAutomatic = newValue.toString();
                        }),
                        decoration: const RadioGroupDecoration(
                          labelStyle: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    // actionButtons(RadioGroupId.vertical),
                    const Divider(
                      height: 50.0,
                    ),
                    Text("Scanned Code:", style: TextStyle(fontSize: 20,),),
                    SizedBox(height: 20,),
                    Text(widget.value ?? 'No data found', style: TextStyle(fontSize: 16,),),
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
                                    return 'please enter amount';
                                  }
                                  return null;
                                },
                                onChanged: (value){
                                  amount = value != '' ? int.parse(value!) : 0;
                                },
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                decoration: textFormDecoration.copyWith(
                                    suffixIcon: IconButton(
                                        onPressed: (){
                                          setState(() {

                                          });
                                        },
                                        icon: Icon(
                                          Icons.attach_money,
                                          color: Colors.purple,
                                        )
                                    ),
                                    labelText: 'Montant',
                                    hintText: 'Enter your amount'
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
                                print(">>>>>>>>>>>>> Demande Achat <<<<<<<<<<<<<<<");
                                print(verticalGroupController.value);
                                print(verticalValAutomatic.toString());
                                String sigle = "";
                                if(verticalValAutomatic.toString() == "Super 91 (S91)") sigle = "S91";
                                if(verticalValAutomatic.toString() == "Essence (ES)") sigle = "ES";
                                if(verticalValAutomatic.toString() == "Gazoil (GA)") sigle = "GA";
                                print('Sigle ' + sigle);
                                print('Montant ' + amount.toString());
                                print('Expediteur ' + currentPhone);
                                print('Beneficiare ' + beneficiairePhone);
                                demandeAchat(amount, currentPhone, beneficiairePhone, sigle);
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
      ),
    );
  }

  Padding selectedValBoard(String automatic, String requested) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.5),
      child: Column(
        children: [
          const Text("Selected Value"),
          IntrinsicHeight(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        const Text("onChange():"),
                        Text(automatic),
                      ],
                    ),
                  ],
                ),
              ),
              const VerticalDivider(
                color: Colors.black,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        const Text("\"Fetch Selected\" btn:"),
                        Text(requested),
                      ],
                    ),
                  ],
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }

  /// The buttons used to demo the radio groups.
  Padding actionButtons(RadioGroupId radioGroupId) {
    /// Make the buttons blue.
    ButtonStyle buttonStyle = ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith(
            (states) => states.contains(MaterialState.pressed)
            ? Colors.blueAccent
            : Colors.blue,
      ),
      padding: MaterialStateProperty.all(
        const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
      ),
    );

    /// Make the button text white.
    TextStyle textStyle = const TextStyle(
      color: Colors.white,
    );

    /// Either the [verticalGroupController] or the [horizontalGroupController]
    /// depending on which radio group we are working with at the moment.
    RadioGroupController radioGroupController;
    if (radioGroupId == RadioGroupId.vertical) {
      radioGroupController = verticalGroupController;
    } else {
      radioGroupController = horizontalGroupController;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 12.5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  radioGroupController.value = null;
                },
                style: buttonStyle,
                child: Text(
                  "Select None",
                  style: textStyle,
                ),
              ),
              const SizedBox(
                width: 12.5,
              ),
              TextButton(
                onPressed: () {
                  if (radioGroupId == RadioGroupId.vertical) {
                    radioGroupController.value = verticalValues.last;
                  } else {
                    radioGroupController.value = horizontalValues.last;
                  }
                },
                style: buttonStyle,
                child: Text(
                  "Select Last",
                  style: textStyle,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 12.5,
          ),
          TextButton(
            onPressed: () {
              setState(() {
                if (radioGroupId == RadioGroupId.vertical) {
                  verticalValRequested = radioGroupController.value.toString();
                } else {
                  horizontalValRequested =
                      radioGroupController.value.toString();
                }
              });
            },
            style: buttonStyle,
            child: Text(
              "Fetch Selected",
              style: textStyle,
            ),
          ),
        ],
      ),
    );
  }

}


/// This is how this example code will know if we are talking about the vertical
/// radio group example or the horizontal radio group example.
enum RadioGroupId {
  /// The vertical radio group example.
  vertical,

  /// The horizontal radio group example.
  horizontal,
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