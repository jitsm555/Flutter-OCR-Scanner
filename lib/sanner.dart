import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobile_vision/flutter_mobile_vision.dart';
import './ocr_text_detail.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _cameraBarcode = FlutterMobileVision.CAMERA_BACK;
  int _onlyFormatBarcode = Barcode.ALL_FORMATS;
  bool _autoFocusBarcode = true;
  bool _torchBarcode = false;
  bool _multipleBarcode = false;
  bool _waitTapBarcode = false;
  bool _showTextBarcode = false;
  Size _previewBarcode;
  List<Barcode> _barcodes = [];

  int _cameraOcr = FlutterMobileVision.CAMERA_BACK;
  bool _autoFocusOcr = true;
  bool _torchOcr = false;
  bool _multipleOcr = false;
  bool _waitTapOcr = false;
  bool _showTextOcr = true;
  Size _previewOcr;
  List<OcrText> _textsOcr = [];

  int _cameraFace = FlutterMobileVision.CAMERA_FRONT;
  bool _autoFocusFace = true;
  bool _torchFace = false;
  bool _multipleFace = true;
  bool _showTextFace = true;
  Size _previewFace;
  List<Face> _faces = [];

  @override
  void initState() {
    super.initState();
    FlutterMobileVision.start().then((previewSizes) => setState(() {
          _previewBarcode = previewSizes[_cameraBarcode].first;
          _previewOcr = previewSizes[_cameraOcr].first;
          _previewFace = previewSizes[_cameraFace].first;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        primarySwatch: Colors.lime,
        buttonColor: Colors.lime,
      ),
      home: new DefaultTabController(
        length: 3,
        child: new Scaffold(
          appBar: new AppBar(
            title: new Text('Flutter Mobile Vision'),
          ),
          body: new RaisedButton(
            onPressed: _read,
            child: new Text('READ!'),
          ),
        ),
      ),
    );
  }

  ///
  /// Camera list
  ///
  List<DropdownMenuItem<int>> _getCameras() {
    List<DropdownMenuItem<int>> cameraItems = [];

    cameraItems.add(new DropdownMenuItem(
      child: new Text('BACK'),
      value: FlutterMobileVision.CAMERA_BACK,
    ));

    cameraItems.add(new DropdownMenuItem(
      child: new Text('FRONT'),
      value: FlutterMobileVision.CAMERA_FRONT,
    ));

    return cameraItems;
  }

  ///
  /// Preview sizes list
  ///
  List<DropdownMenuItem<Size>> _getPreviewSizes(int facing) {
    List<DropdownMenuItem<Size>> previewItems = [];

    List<Size> sizes = FlutterMobileVision.getPreviewSizes(facing);

    if (sizes != null) {
      sizes.forEach((size) {
        previewItems.add(
          new DropdownMenuItem(
            child: new Text(size.toString()),
            value: size,
          ),
        );
      });
    } else {
      previewItems.add(
        new DropdownMenuItem(
          child: new Text('Empty'),
          value: null,
        ),
      );
    }

    return previewItems;
  }

  ///
  /// Barcode Method
  ///
  Future<Null> _scan() async {
    List<Barcode> barcodes = [];
    try {
      barcodes = await FlutterMobileVision.scan(
        flash: _torchBarcode,
        autoFocus: _autoFocusBarcode,
        formats: _onlyFormatBarcode,
        multiple: _multipleBarcode,
        waitTap: _waitTapBarcode,
        showText: _showTextBarcode,
        preview: _previewBarcode,
        camera: _cameraBarcode,
        fps: 15.0,
      );
    } on Exception {
      barcodes.add(new Barcode('Failed to get barcode.'));
    }

    if (!mounted) return;

    setState(() => _barcodes = barcodes);
  }

  ///
  /// OCR Screen
  ///
  Widget _getOcrScreen(BuildContext context) {
    List<Widget> items = [];

    items.add(new Padding(
      padding: const EdgeInsets.only(
        top: 8.0,
        left: 18.0,
        right: 18.0,
      ),
      child: const Text('Camera:'),
    ));

    items.add(new Padding(
      padding: const EdgeInsets.only(
        left: 18.0,
        right: 18.0,
      ),
      child: new DropdownButton(
        items: _getCameras(),
        onChanged: (value) {
          _previewOcr = null;
          setState(() => _cameraOcr = value);
        },
        value: _cameraOcr,
      ),
    ));

    items.add(new Padding(
      padding: const EdgeInsets.only(
        top: 8.0,
        left: 18.0,
        right: 18.0,
      ),
      child: const Text('Preview size:'),
    ));

    items.add(new Padding(
      padding: const EdgeInsets.only(
        left: 18.0,
        right: 18.0,
      ),
      child: new DropdownButton(
        items: _getPreviewSizes(_cameraOcr),
        onChanged: (value) {
          setState(() => _previewOcr = value);
        },
        value: _previewOcr,
      ),
    ));

    items.add(new SwitchListTile(
      title: const Text('Auto focus:'),
      value: _autoFocusOcr,
      onChanged: (value) => setState(() => _autoFocusOcr = value),
    ));

    items.add(new SwitchListTile(
      title: const Text('Torch:'),
      value: _torchOcr,
      onChanged: (value) => setState(() => _torchOcr = value),
    ));

    items.add(new SwitchListTile(
      title: const Text('Return all texts:'),
      value: _multipleOcr,
      onChanged: (value) => setState(() => _multipleOcr = value),
    ));

    items.add(new SwitchListTile(
      title: const Text('Capture when tap screen:'),
      value: _waitTapOcr,
      onChanged: (value) => setState(() => _waitTapOcr = value),
    ));

    items.add(new SwitchListTile(
      title: const Text('Show text:'),
      value: _showTextOcr,
      onChanged: (value) => setState(() => _showTextOcr = value),
    ));

    items.add(
      new Padding(
        padding: const EdgeInsets.only(
          left: 18.0,
          right: 18.0,
          bottom: 12.0,
        ),
        child: new RaisedButton(
          onPressed: _read,
          child: new Text('READ!'),
        ),
      ),
    );

    items.addAll(
      ListTile.divideTiles(
        context: context,
        tiles: _textsOcr
            .map(
              (ocrText) => new OcrTextWidget(ocrText),
            )
            .toList(),
      ),
    );

    return new ListView(
      padding: const EdgeInsets.only(
        top: 12.0,
      ),
      children: items,
    );
  }

  ///
  /// OCR Method
  ///
  Future<Null> _read() async {
    List<OcrText> texts = [];
    try {
      texts = await FlutterMobileVision.read(
        flash: _torchOcr,
        autoFocus: _autoFocusOcr,
        multiple: _multipleOcr,
        waitTap: _waitTapOcr,
        showText: _showTextOcr,
        preview: _previewOcr,
        camera: _cameraOcr,
        fps: 2.0,
      );
    } on Exception {
      texts.add(new OcrText('Failed to recognize text.'));
    }

    if (!mounted) return;

    setState(() => _textsOcr = texts);
  }
}

///
/// OcrTextWidget
///
class OcrTextWidget extends StatelessWidget {
  final OcrText ocrText;

  OcrTextWidget(this.ocrText);

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      leading: const Icon(Icons.title),
      title: new Text(ocrText.value),
      subtitle: new Text(ocrText.language),
      trailing: const Icon(Icons.arrow_forward),
      onTap: () => Navigator.of(context).push(
        new MaterialPageRoute(
          builder: (context) => new OcrTextDetail(ocrText),
        ),
      ),
    );
  }
}
