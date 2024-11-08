import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fuelcard/Data/Local/SharedPreference/shared_preference.dart';
import 'package:fuelcard/Data/Netword/api/services.dart';
import 'package:fuelcard/Data/entity/operation.dart';
import 'package:fuelcard/constants/allconstant.dart';
import 'package:fuelcard/main_screens/home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Historique extends StatefulWidget {
  Historique({super.key});
  @override
  HistoriqueState createState() => HistoriqueState();
}

class HistoriqueState extends State<Historique> {

  late String currentPhone;
  // late final Future<List<Operation>> _operations ;
  final studentListKey = GlobalKey<HistoriqueState>();
  bool processing = false;

  @override
  void initState() {
    init();
    // _operations = getOperationsList();
    // print('>>>>>>>>>>>>_operations : ' + _operations.toString());
    super.initState();
  }

  Future<void> init() async {
    await SharedPref.getId().then((value) async {
      print('>>>>>>>>>>>>Phone : ' + value);
      currentPhone = value;
      // await getOperationsList(currentPhone).then((value) async => _operations = value as Future<List<Operation>>);
    })
    .whenComplete(() async {
      await getOperationsList();
      // final url = Uri.parse('$apiUrl$apiHistoriqueOperationNonTransferesSousReseauFile');
      // // List<Operation> operations = [];
      // List<Operation> operationList = [];
      // var data = {
      //   'currentPhone': currentPhone,
      // };
      //
      // var response = await http.post(url, body: data);
      // print('>>>>>>>>>>>>Response : ' + response.body);

      // final items = await json.decode(response.body).cast<Map<String, dynamic>>();
      // final items = await json.decode(response.body);
      // List<Operation> operations = await items.map<Operation>((json) async {
      //   return Operation.fromJson(json);
      // }).toList();
      // _operations = operations as Future<List<Operation>>;
      //
      // var list = json.decode(utf8.decode(response.bodyBytes)) as List;
      // Map obj;
      // list.forEach((element) {
      //   obj = element;
      //   Operation data = new Operation();
      //   data.id = obj['id'];
      //   data.operateur_id = obj['operateur_id'];
      //   data.montant = obj['montant'];
      //   data.transfered = obj['transfered'];
      //   data.date = obj['date'];
      //   data.type_compte_initiateur = obj['type_compte_initiateur'];
      //   operationList.add(data);
      // });
      // _operations = operationList as List<Operation>;

    });
  }

  Future<List> getOperationsList() async {
    final url = Uri.parse('$apiUrl$apiHistoriqueOperationNonTransferesSousReseauFile');
    // List<Operation> operations = [];
    var data = {
      'currentPhone': currentPhone,
    };

    var response = await http.post(url, body: data);
    print('>>>>>>>>>>>>Response : ' + response.body);
    // final response = await http.get(url);
    // var list = json.decode(response.body);
    // List<Operation> _operations =
    // await list.map<Operation>((json) => Operation.fromJson(json)).toList();

    // final response = await http.get('$apiUrl$apiHistoriqueOperationNonTransferesSousReseauFile');
    // setState(() async {
    //   final items = await json.decode(response.body).cast<Map<String, dynamic>>();
    final items = await json.decode(response.body);
      // operations = await items.map<Operation>((json) async {
      //   return Operation.fromJson(json);
      // }).toList();
    // });
    // _operations = items;
    // return operations;
    setState(() {

    });
    return items;
  }
  late Future<List> _operations;
  // late Future<List<Operation>> _operations;
  // Future<List<Operation>> _operations = [];
  Future<void> sendOperations(String phoneNumber) async {

    setState(() {
      processing = true;
    });
    SharedPref.getId().then((value) async {
      print('>>>>>>>>>>>>getOperationsList() ' + value);
      await sendOperationsToCentral(value).then((value) async {
        if(value.response == 'success'){
          print('>>>>>>>>>>>>getOperationsList() success');
          setState(() {
            processing = false;
          });
          Fluttertoast.showToast(
              msg: "Operation effectuée avec succès.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0
          );

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
                  (route) => false
          );
        }
        else {
          print('>>>>>>>>>>>>getOperationsList() failed');
          setState(() {
            processing = false;
          });
          Fluttertoast.showToast(
              msg: value.message.toString() != '' ? value.message.toString() : "Erreur serveur, veuillez réessayer plus tard.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
          );
        }
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: studentListKey,
      appBar: AppBar(
        title: Text('Operation List'),
      ),
      body: Center(
        child: FutureBuilder<List>(
          future: getOperationsList(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            // By default, show a loading spinner.
            if (!snapshot.hasData) return CircularProgressIndicator();
            // Render student lists
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                var data = snapshot.data[index];
                return Card(
                  child: ListTile(
                    // leading: Icon(Icons.person),
                    trailing: Icon(Icons.view_list),
                    title: Column(
                      children: [
                        Text(
                          'Date : ' + data['date'].toString(),
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          'Montant : ' + data['montant'].toString(),
                          style: TextStyle(fontSize: 20),
                        ),
                        data['transfered'].toString() == '1'
                        ? Text(
                          'Status : Transféré',
                          style: TextStyle(fontSize: 20, color: Colors.green),
                        )
                        : Text(
                          'Status : Non Transféré',
                          style: TextStyle(fontSize: 20, color: Colors.red),
                        ),
                      ],
                    ),
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => Details(student: data)),
                      // );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: processing == false ?
        () {
          sendOperations(currentPhone);
        }
        : (){},
        child: processing == false
        ? const Icon(Icons.send_and_archive_sharp)
        : const Center(child: CircularProgressIndicator(color: Colors.purple)),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:fuelcard/Data/entity/operation.dart';
// import 'package:fuelcard/constants/allconstant.dart';
// import 'package:fuelcard/utilities/operation_data_source.dart';
// import 'package:syncfusion_flutter_datagrid/datagrid.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// class Historique extends StatefulWidget {
//
//   Historique({super.key});
//
//   @override
//   _HistoriqueState createState() => _HistoriqueState();
// }
//
// class _HistoriqueState extends State<Historique> {
//
//   late OperationDataSource _operationDataSource;
//   late List<GridColumn> _columns;
//
//   Future<Object> generateOperationList() async {
//     // Give your PHP URL. It may be online URL o local host URL.
//     // Follow the steps provided in the below KB to configure the mysql using
//     // XAMPP and get the local host php link,
//     ///
//     final url = Uri.parse('$apiUrl$apiHistoriqueOperationNonTransferesSousReseauFile');
//
//     final response = await http.get(url);
//     var list = json.decode(response.body);
//     List<Operation> _operations =
//     await list.map<Operation>((json) => Operation.fromJson(json)).toList();
//     _operationDataSource = OperationDataSource(_operations);
//     return _operations;
//   }
//
//   List<GridColumn> getColumns() {
//     return <GridColumn>[
//       GridColumn(
//           columnName: 'id',
//           width: 70,
//           label: Container(
//               padding: EdgeInsets.all(16.0),
//               alignment: Alignment.center,
//               child: Text(
//                 'ID',
//               ))),
//       GridColumn(
//           columnName: 'name',
//           width: 80,
//           label: Container(
//               padding: EdgeInsets.all(8.0),
//               alignment: Alignment.center,
//               child: Text('Name'))),
//       GridColumn(
//           columnName: 'designation',
//           width: 120,
//           label: Container(
//               padding: EdgeInsets.all(8.0),
//               alignment: Alignment.center,
//               child: Text(
//                 'Designation',
//                 overflow: TextOverflow.ellipsis,
//               ))),
//       GridColumn(
//           columnName: 'salary',
//           label: Container(
//               padding: EdgeInsets.all(8.0),
//               alignment: Alignment.center,
//               child: Text('Salary'))),
//     ];
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _columns = getColumns();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('Operations Non Transférées'),
//         ),
//         body: FutureBuilder<Object>(
//             future: generateOperationList(),
//             builder: (context, data) {
//               return data.hasData
//                   ? SfDataGrid(
//                   source: _operationDataSource,
//                   columns: _columns,
//                   columnWidthMode: ColumnWidthMode.fill)
//                   : Center(
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                     value: 0.8,
//                   ));
//             }));
//   }
// }
//
// /// An object to set the employee collection data source to the datagrid. This
// /// is used to map the employee data to the datagrid widget.
// class OperationDateDataSource extends DataGridSource {
//   /// Creates the employee data source class with required details.
//   OperationDateDataSource(this.operations) {
//     buildDataGridRow();
//   }
//
//   void buildDataGridRow() {
//     _operationDataGridRows = operations
//         .map<DataGridRow>((e) => DataGridRow(cells: [
//       DataGridCell<int>(columnName: 'id', value: e.id),
//       DataGridCell<int>(columnName: 'name', value: e.montant),
//       DataGridCell<String>(
//           columnName: 'designation', value: e.date),
//       DataGridCell<String>(columnName: 'Transfered', value: e.transfered),
//     ]))
//         .toList();
//   }
//
//   List<Operation> operations = [];
//
//   List<DataGridRow> _operationDataGridRows = [];
//
//   @override
//   List<DataGridRow> get rows => _operationDataGridRows;
//
//   @override
//   DataGridRowAdapter buildRow(DataGridRow row) {
//     return DataGridRowAdapter(
//         cells: row.getCells().map<Widget>((e) {
//           return Container(
//             alignment: Alignment.center,
//             padding: EdgeInsets.all(8.0),
//             child: Text(e.value.toString()),
//           );
//         }).toList());
//   }
//
//   void updateDataGrid() {
//     notifyListeners();
//   }
// }