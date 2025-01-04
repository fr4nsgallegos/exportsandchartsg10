import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class HomePage extends StatelessWidget {
  Future<File> generatePdf() async {
    //Crear dicumento PDF
    final pdf = pw.Document();

    //Añadiendo contenido al documento
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text("Hola, este en un PDF creado desde FLUTTER!!!!"),
          );
        },
      ),
    );

    //Obtener la ruta de almacenamiento local
    final output = await getApplicationDocumentsDirectory();
    final file = File("${output.path}/example.pdf");

    //guardar el archivvo
    await file.writeAsBytes(await pdf.save());
    print("pdf guardado en ${file.path}");
    return file;
  }

  Future<File> generateTablePdf() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Table.fromTextArray(
            headers: ["Id", "Nombre", "Puntuación"],
            data: [
              [1, "Juan", 95],
              [2, "Pedro", 80],
              [3, "Elias", 54],
              [4, "María", 70],
              [5, "Olenka", 100],
            ],
          );
        },
      ),
    );

    //Obtener la ruta de almacenamiento local
    final output = await getApplicationDocumentsDirectory();
    final file = File("${output.path}/example.pdf");

    //guardar el archivvo
    await file.writeAsBytes(await pdf.save());
    print("pdf guardado en ${file.path}");
    return file;
  }

  void openPdfFile(File pdfFile) async {
    try {
      print("Intentando abrir el pdf");
      final result = await OpenFilex.open(pdfFile.path);
      print("resultado al abrir: $result");
    } catch (e) {
      print("error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final pdfFile = await generatePdf();
                openPdfFile(pdfFile);
              },
              child: Text("Esportar a PDF"),
            ),
            ElevatedButton(
              onPressed: () async {
                final pdfFile = await generateTablePdf();
                openPdfFile(pdfFile);
              },
              child: Text("Esportar a PDF con tabla"),
            ),
          ],
        ),
      ),
    );
  }
}
