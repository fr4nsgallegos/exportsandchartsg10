import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  Future<File> generatePdfWithImage() async {
    final pdf = pw.Document();
    final image = pw.MemoryImage(
      (await rootBundle.load("assets/images/imagen1.jpg")).buffer.asUint8List(),
    );

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              children: [
                pw.Text(
                  "PDF CON IMAGEN",
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 16),
                pw.Text(
                  "Este es un ejemplo de parrafo apra el pdf creado con imagenes",
                  style: pw.TextStyle(fontSize: 18, color: PdfColors.blue),
                ),
                pw.SizedBox(height: 32),
                pw.Image(image, height: 200, width: 200),
              ],
            ),
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

  Future<File> generateDynamicPdf(String title, String sutbtitle) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              children: [
                pw.Text(
                  title,
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 16),
                pw.Text(
                  sutbtitle,
                  style: pw.TextStyle(fontSize: 18, color: PdfColors.blue),
                ),
                pw.SizedBox(height: 32),
              ],
            ),
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

  Future<File> generatePdfMuliPage() async {
    final pdf = pw.Document();

    for (int i = 0; i < 5; i++) {
      pdf.addPage(pw.MultiPage(
        header: (pw.Context context) {
          return pw.Text("Encbezado del PDF");
        },
        footer: (context) =>
            pw.Text("Página ${context.pageNumber} de ${context.pagesCount}"),
        build: (pw.Context context) {
          return [
            pw.Center(
              child: pw.Text("Esta es la página $i"),
            )
          ];
        },
      ));
    }

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

  dynamic getCellValue(dynamic value) {
    if (value is String) {
      return TextCellValue(value);
    } else if (value is int) {
      return IntCellValue(value);
    } else if (value is double) {
      return DoubleCellValue(value);
    } else if (value is double) {
      return DoubleCellValue(value);
    } else {
      return TextCellValue(value.toString());
    }
  }

  void exporToExcel() async {
    //Crear libro de excel
    var excel = Excel.createExcel(); //esto crea un archivo excel vacio

    //Obtenuiendo una hoja activa o crear una nueva hoja
    Sheet sheetObject = excel['MySheet'];

    //agregar datos a las celdas
    sheetObject.cell(CellIndex.indexByString("A1")).value =
        TextCellValue("Nombre");
    sheetObject.cell(CellIndex.indexByString("B1")).value =
        TextCellValue("Edad");
    sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 0))
        .value = TextCellValue("País");

    //Agregar filas dinámicamente
    List<List<dynamic>> data = [
      ["Carlos", 25, "Perú"],
      ["Aana", 36, "México"],
      ["Isaias", 63, "España"],
    ];

    for (int i = 0; i < data.length; i++) {
      for (int j = 0; j < data[i].length; j++) {
        sheetObject
            .cell(CellIndex.indexByColumnRow(columnIndex: j, rowIndex: i + 1))
            .value = getCellValue(data[i][j]);
      }
    }

    //Guardar el archivo excel
    var bytes = excel.encode(); //convertimos el arhivo a bytes

    //Obteniendo directorio de almacenamiento
    Directory? directory = await getExternalStorageDirectory();
    String filePath = "${directory!.path}/Reporte.xlsx";

    //Guardar el archivo
    File(filePath)
      ..createSync(recursive: true)
      ..writeAsBytes(bytes!);

    print("archivo guardado en: ${filePath}");
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
              child: Text("Exportar a PDF"),
            ),
            ElevatedButton(
              onPressed: () async {
                final pdfFile = await generateTablePdf();
                openPdfFile(pdfFile);
              },
              child: Text("Exportar a PDF con tabla"),
            ),
            ElevatedButton(
              onPressed: () async {
                final pdfFile = await generatePdfWithImage();
                openPdfFile(pdfFile);
              },
              child: Text("Exportar a PDF con texto personalizado e imagen"),
            ),
            ElevatedButton(
              onPressed: () async {
                final pdfFile = await generateDynamicPdf("Titulo", "Subtitulo");
                openPdfFile(pdfFile);
              },
              child: Text("Exportar a PDF dinámico"),
            ),
            ElevatedButton(
              onPressed: () async {
                final pdfFile = await generatePdfMuliPage();
                openPdfFile(pdfFile);
              },
              child: Text("Exportar a PDF con varias páginas"),
            ),
            ElevatedButton(
              onPressed: () async {
                exporToExcel();
              },
              child: Text("Exportar a excel"),
            ),
          ],
        ),
      ),
    );
  }
}
