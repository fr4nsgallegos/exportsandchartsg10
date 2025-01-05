// import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class Home2Page extends StatelessWidget {
  //TRABAJANDO CON LA LIBRERIA syncfusion_flutter_xlsio
  CollectionReference userReference =
      FirebaseFirestore.instance.collection("users");
  void exporteExcelSyncFusion() async {
    final workbook = Workbook();
    final Worksheet worksheet = workbook.worksheets[0];

    worksheet.getRangeByName("A1").setText("Id");
    worksheet.getRangeByIndex(1, 2).setText("Nombre");

    int row = 2;
    QuerySnapshot userCollection = await userReference.get();
    List<QueryDocumentSnapshot> docs = userCollection.docs;

    List.generate(docs.length, (index) {
      worksheet.getRangeByIndex(row, 1).setText(docs[index].id);
      worksheet.getRangeByIndex(row, 2).setText(docs[index]["name"]);
      row++;
    });

    //almacenando dentro del celular
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    final String path = (await getApplicationSupportDirectory()).path;
    final String fileName = "$path/excelSync.xlsx";

    // final File file = File(fileName);
    // await file.writeAsBytes(bytes, flush: true);
    // OpenFilex.open(fileName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
