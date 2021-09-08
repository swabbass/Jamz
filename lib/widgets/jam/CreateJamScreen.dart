import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progressions/models/Modes.dart';
import 'package:progressions/models/Notes.dart';
import 'package:progressions/models/ScaleSelection.dart';
import 'package:progressions/models/ShareState.dart';
import 'package:progressions/models/jam/Jam.dart';
import 'package:progressions/providers/BarsCountSelection.dart';
import 'package:progressions/providers/ChordProgressionSelection.dart';
import 'package:progressions/providers/JamShareStateNotifier.dart';

import 'package:progressions/widgets/StyledTitleText.dart';
import 'package:progressions/widgets/common/AppTitle.dart';
import 'package:progressions/widgets/common/bottom_navBar.dart';
import 'package:progressions/widgets/common/header.dart';
import 'package:progressions/widgets/jam/JamOptionsWidget.dart';
import 'package:progressions/widgets/jam/SaveJamButton.dart';
import 'package:progressions/widgets/pages/timeline.dart';
import 'package:progressions/widgets/pages/upload.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'ChordsGrid.dart';
import 'package:uuid/uuid.dart';

class CreateJamScreen extends StatelessWidget {
  // String postId = Uuid().v4();

  CreateJamScreen({
    Key? key,
    Map<String, dynamic>? data,
    required User user,
  })   : _user = user,
        _data = data,
        super(key: key);

  final User _user;
  Map<String, dynamic>? _data;
  late Jam jam;
  final _screenshotController = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    // print('Success!\nSecond 222 Downloaded json:{ $_data \n }');
    // Jam jam = Jam.fromJson(_data!);

    // print('111 ' + jam.barCount.toString());
    // print('222 ' + jam.keyIndex.toString());
    // print('333 ' + jam.modeIndex.toString());
    if (_data != null) {
      jam = Jam.fromJson(_data!);

      // print('111 ' + jam.barCount.toString());
      // print('222 ' + jam.keyIndex.toString());
      // print('333 ' + jam.modeIndex.toString());
      // Jam jam = Jam(barCount, keyIndex, modeIndex, chordProg)

    }
    // Jam jam = Jam(barCount, keyIndex, modeIndex, chordProg)
    return Scaffold(
      // appBar: header(context, titleText: "Create a Jam"),
      appBar: AppBar(
        title: Text(
          "Create a Jam",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          onPressed: () => {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => Timeline(user: _user)),
            ),
          },
          icon: Icon(
            Icons.arrow_back,
          ),
        ),
      ),

      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: _data != null
                ? (context) => SelectedScaleNotifier(
                    Note.values.elementAt(jam.keyIndex),
                    ScaleMode.by(ModeType.values.elementAt(jam.modeIndex)),
                    true)
                : (context) => SelectedScaleNotifier(
                    Note.C, ScaleMode.by(ModeType.Ionian), true),
          ),
          ChangeNotifierProvider(
            create: (context) => _data != null
                ? BarsCountSelection(jam.barCount)
                : BarsCountSelection(2),
          ),
          ChangeNotifierProvider(
              create: (context) => _data != null
                  ? ChordProgressionSelection(jam.chordProg)
                  : ChordProgressionSelection({})),
          ChangeNotifierProvider(
              create: (context) => JamShareStateNotifier(ShareState.INITAL)),
        ],
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AppTitle(
              //   title: "Create a Jam",
              // ),
              JamOptionsWidget(),
              Divider(),

              Screenshot(
                controller: _screenshotController,
                child: Card(
                    color: Colors.white54,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          buildChordsGrid(),
                        ],
                      ),
                    )),
              ),
              // buildChordsGrid(),
              SizedBox(
                height: 50,
              ),
              Divider(),
              Consumer<JamShareStateNotifier>(
                  builder: (context, shareState, child) {
                return buildCheckboxListTile(shareState);
              }),

              SaveJamButton(
                screenshotController: _screenshotController,
                user: _user,
              ),

              // TextButton(
              //   child: Text('Take Screenshot and Share'),
              //   onPressed: () => _takeScreenshot(
              //     context,
              //   ),
              // )
            ],
          ),
        ),
      ),
      // bottomNavigationBar: bottomBar(context, isHome: false, user: _user),
    );
  }

  CheckboxListTile buildCheckboxListTile(
      JamShareStateNotifier jamShareStateNotifier) {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      title: Text('Share post'),
      checkColor: Colors.redAccent, // color of tick Mark
      activeColor: Colors.black38,
      value: jamShareStateNotifier.share,
      onChanged: (value) {
        // print("XXXXXXX changed $value");
        jamShareStateNotifier.share = value ?? false;
      },
    );
  }

  Padding buildChordsGrid() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 32,
      ),
      child: ChordsGrid(),
    );
  }

  Padding buildRecordingWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 32,
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 100,
        color: Colors.red.shade300,
        child: Center(
          child: StyledText(
              "Recording goes "
              "here!",
              TextStyle()),
        ),
      ),
    );
  }

  // _takeScreenshot(context) async {
  //   Uint8List? imageFile = await _screenshotController.capture();
  //   final tempDir = await getTemporaryDirectory();
  //   File? file = await new File('${tempDir.path}/image.jpg').create();
  //   file.writeAsBytesSync(imageFile!);
  //   print(file);

  //   // Upload
  //   Navigator.of(context).pushReplacement(
  //     MaterialPageRoute(
  //         builder: (context) => Upload(
  //               file: file,
  //               user: _user,
  //             )),
  //   );
  // }
}
