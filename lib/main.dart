import 'dart:io';

import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:flutter/material.dart';
import 'package:flutter_document_scanner/flutter_document_scanner.dart';
import 'package:flutter_document_scanner/src/utils/image_utils.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path/path.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter(BuildContext context) async {
    var listImages = await CunningDocumentScanner.getPictures() ?? [];
    final pdf = pw.Document();
    if (listImages.length > 0) {
      for (var img in listImages) {
        File file = File(img);

        Uint8List uint8list = file.readAsBytesSync();

        final ImageUtils imageUtils = ImageUtils();
        Uint8List image =
            await imageUtils.applyFilter(uint8list, FilterType.eco);
        var mImage = pw.MemoryImage(
          image,
        );
        // file.writeAsBytes(data, mode: FileMode.append);
        pdf.addPage(pw.Page(
          build: (context) => pw.Center(
            child: pw.Image(mImage),
          ),
        ));
      }

      final pdfFile = File(
          "/storage/emulated/0/Download/${DateTime.now().microsecondsSinceEpoch}.pdf");
      await pdfFile.writeAsBytes(await pdf.save());
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("file saved")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _incrementCounter(context);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
