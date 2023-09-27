import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter/material.dart';

import 'package:pdf/widgets.dart' as pw;

void _incrementCounter(BuildContext context) async {
  final imagesPath = await CunningDocumentScanner.getPictures();
  // if (imagesPath!.length > 0) {
  //  File file = File(imagesPath![0]);
  final pdf = pw.Document();
  // final image = pw.MemoryImage(
  //   file.readAsBytesSync(),
  // );
  // pdf.addPage(pw.Page(build: (BuildContext context) {
  //   return pw.Center(
  //     child: pw.Image(image),
  //   ); // Center
  // }));
  // final pdfFile = File(
  //     "/storage/emulated/0/Download/${DateTime.now().microsecondsSinceEpoch}");
  // await pdfFile.writeAsBytes(await pdf.save());
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("hello")));
}
