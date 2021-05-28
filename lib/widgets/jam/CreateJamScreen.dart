import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:progressions/models/Modes.dart';
import 'package:progressions/models/Notes.dart';
import 'package:progressions/models/ScaleSelection.dart';
import 'package:progressions/models/ShareState.dart';
import 'package:progressions/providers/BarsCountSelection.dart';
import 'package:progressions/providers/ChordProgressionSelection.dart';
import 'package:progressions/providers/JamShareStateNotifier.dart';

import 'package:progressions/widgets/StyledTitleText.dart';
import 'package:progressions/widgets/common/AppTitle.dart';
import 'package:progressions/widgets/jam/JamOptionsWidget.dart';
import 'package:progressions/widgets/jam/ShareJamButton.dart';
import 'package:provider/provider.dart';

import 'ChordsGrid.dart';

class CreateJamScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => SelectedScaleNotifier(
                Note.C, ScaleMode.by(ModeType.Ionian), true),
          ),
          ChangeNotifierProvider(
            create: (context) => BarsCountSelection(2),
          ),
          ChangeNotifierProvider(
              create: (context) => ChordProgressionSelection({})),
          ChangeNotifierProvider(
              create: (context) => JamShareStateNotifier(ShareState.INITAL)),
        ],
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTitle(
                title: "Create a Jam",
              ),
              JamOptionsWidget(),
              buildChordsGrid(),
              ShareJamButton()
            ],
          ),
        ),
      ),
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
}
