import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:bitmap/bitmap.dart' as ui;
import 'package:flutter/material.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:image/image.dart' as img;

import 'package:pdf/widgets.dart' as pw;

void main() {
  runApp(const MyApp());
}

void _incrementCounter(BuildContext context) async {
  final imagesPath = await CunningDocumentScanner.getPictures();
  if (imagesPath!.length > 0) {
    File file = File(imagesPath[0]);
    final pdf = pw.Document();

    //editing
    // final texture = await TextureSource.fromFile(file);

    // final configuration = GroupShaderConfiguration();
    // configuration.add(BrightnessShaderConfiguration()..brightness = 1);
    // configuration.add(WhiteBalanceShaderConfiguration()..temperature = 0.8);
    // configuration.add(GammaShaderConfiguration()..gamma = 0.8);
    // configuration.add(HALDLookupTableShaderConfiguration());

    // /////////////
    // final editedImage = await configuration.export(texture, texture.size);

    // //converting to bytes
    // ByteData? byteData = await editedImage.toByteData();
    // final persistedImage = img.Image.fromBytes(
    //   width: editedImage.width,
    //   height: editedImage.height,
    //   bytes: byteData!.buffer,
    // );
    // img.JpegEncoder encoder = img.JpegEncoder();
    // final data = encoder.encode(persistedImage);

    // file.writeAsBytes(data, mode: FileMode.append);

    //////////
    ///
    ///
    final image = pw.MemoryImage(
      file.readAsBytesSync(),
    );

    ui.Bitmap bitmap = ui.Bitmap.fromHeadful(
        image.width!, image.height!, file.readAsBytesSync()); //
    bitmap.apply(ui.BitmapContrast(0.2));
    var outputImage = await bitmap.buildImage();
    ByteData? byteData = await outputImage.toByteData();
    final persistedImage = img.Image.fromBytes(
      width: outputImage.width,
      height: outputImage.height,
      bytes: byteData!.buffer,
    );
    img.JpegEncoder encoder = img.JpegEncoder();
    final data = encoder.encode(persistedImage);

    file.writeAsBytes(data, mode: FileMode.append);
    pdf.addPage(pw.Page(build: (pw.Context context) {
      return pw.Center(
        child: pw.Image(image),
      ); // Center
    }));

    final pdfFile = File(
        "/storage/emulated/0/Download/${DateTime.now().microsecondsSinceEpoch}.pdf");
    await pdfFile.writeAsBytes(await pdf.save());
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("file saved")));
  }
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

  get pw => null;

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
        onPressed: () {
          _incrementCounter(context);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
