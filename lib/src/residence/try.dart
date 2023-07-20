import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

class ScreenshotSharePage extends StatefulWidget {
  @override
  _ScreenshotSharePageState createState() => _ScreenshotSharePageState();
}

class _ScreenshotSharePageState extends State<ScreenshotSharePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey _repaintWidgetKey = GlobalKey();

  Future<void> _shareScreenshot() async {
    try {
      RenderRepaintBoundary boundary = _repaintWidgetKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 2.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        Uint8List pngBytes = byteData.buffer.asUint8List();

        // Save Uint8List as a temporary file
        final tempDir = await getTemporaryDirectory();
        final file = await File('${tempDir.path}/share.png').writeAsBytes(pngBytes);

        // Share the temporary file using the share package
        await Share.shareFiles([file.path], text: 'Sharing screenshot');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Screenshot Share'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RepaintBoundary(
              key: _repaintWidgetKey,
              child: Container(
                width: 200,
                height: 200,
                color: Colors.blue,
                child: Center(
                  child: Text(
                    'Widget to Capture',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _shareScreenshot,
              child: Text('Share Screenshot'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ScreenshotSharePage(),
  ));
}
