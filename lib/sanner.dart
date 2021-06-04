import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_vision/flutter_mobile_vision.dart';

class MyAppOCR extends StatefulWidget {
  @override
  _MyAppOCRState createState() => _MyAppOCRState();
}

class _MyAppOCRState extends State<MyAppOCR> {
  int _cameraOcr = FlutterMobileVision.CAMERA_BACK;
  String _textValue = "KLIK UNTUK MEMINDAI";
  final FlutterTts flutterTts = FlutterTts();

  @override
  Widget build(BuildContext context) {
    Future _speak() async {
      await flutterTts.setLanguage("id-ID");
      await flutterTts.speak(_textValue);
    }

    return new MaterialApp(
      theme: new ThemeData(
        backgroundColor: Color(0xff002e8d),
        buttonColor: Color(0xFFFEC800),
      ),
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Text To Speech'),
        ),
        body: Center(
            child: new ListView(
          children: <Widget>[
            new Text(_textValue),
            new RaisedButton(
              onPressed: _read,
              child: new Text('Mulai Kamera'),
            ),
          ],
        )),
      ),
    );
  }

  Future<Null> _read() async {
    List<OcrText> texts = [];
    try {
      texts = await FlutterMobileVision.read(
        camera: _cameraOcr,
        waitTap: true,
      );

      setState(() {
        _textValue = texts[0].value;
      });
    } on Exception {
      texts.add(new OcrText('Gagal memindai teks.'));
    }
  }
}
