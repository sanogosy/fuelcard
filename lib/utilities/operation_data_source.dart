// import 'package:flutter/material.dart';
// import 'package:fuelcard/Data/entity/operation.dart';
// // import 'dart:io';
// // import 'dart:convert';
// // import 'package:http/http.dart' as http;
// import 'package:syncfusion_flutter_datagrid/datagrid.dart';
//
// class OperationDataSource extends DataGridSource {
//
//   OperationDataSource(this.employees) {
//     buildDataGridRow();
//   }
//
//   void buildDataGridRow() {
//     _employeeDataGridRows = employees
//         .map<DataGridRow>((e) => DataGridRow(cells: [
//       DataGridCell<int>(columnName: 'id', value: e.id),
//       DataGridCell<int>(columnName: 'name', value: e.montant),
//       DataGridCell<String>(
//           columnName: 'designation', value: e.date),
//       DataGridCell<String>(columnName: 'salary', value: e.transfered),
//     ]))
//     .toList();
//   }
//
//   List<Operation> employees = [];
//
//   List<DataGridRow> _employeeDataGridRows = [];
//
//   @override
//   List<DataGridRow> get rows => _employeeDataGridRows;
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