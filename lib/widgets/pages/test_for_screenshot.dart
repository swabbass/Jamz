import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:progressions/widgets/common/header.dart';
import 'package:progressions/widgets/common/bottom_navBar.dart';
import 'package:progressions/widgets/pages/upload.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';

class TestForScreenshot extends StatefulWidget {
  const TestForScreenshot({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  _TestForScreenshotState createState() => _TestForScreenshotState();
}

class _TestForScreenshotState extends State<TestForScreenshot> {
  late User _user;
  final _screenshotController = ScreenshotController();

  @override
  void initState() {
    _user = widget._user;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titleText: "Test for screenshot"),
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Screenshot(
          controller: _screenshotController,
          child: Card(
              child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Image.asset('assets/guitar_64.png'),
                Text(
                  'Test for screenshot',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )),
        ),
        TextButton(
          child: Text('Take Screenshot and Share'),
          onPressed: _takeScreenshot,
        )
      ])),
      bottomNavigationBar: bottomBar(context, isHome: true, user: _user),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => print(" test pressed"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void _takeScreenshot() async {
    Uint8List? imageFile = await _screenshotController.capture();

    final tempDir = await getTemporaryDirectory();
    File? file = await new File('${tempDir.path}/image.jpg').create();
    file.writeAsBytesSync(imageFile!);

    // Upload
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
          builder: (context) => Upload(
                file: file,
                user: _user,
              )),
    );
  }
}
