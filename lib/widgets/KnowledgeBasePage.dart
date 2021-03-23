import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progressions/widgets/GuitarScaleWidget.dart';
import 'package:progressions/widgets/ScaleChordsListView.dart';
import 'package:progressions/widgets/ScaleNotesListView.dart';
import 'package:progressions/widgets/StyledTitleText.dart';
import 'package:progressions/widgets/TriadWidget.dart';
import 'package:progressions/models/Chord.dart';
import 'package:progressions/models/Modes.dart';
import 'package:progressions/models/Notes.dart';
import 'package:progressions/models/ScaleSelection.dart';
import 'package:provider/provider.dart';

import 'KnowledgeBaseTitle.dart';
import 'KeySelectorWidget.dart';
import 'ModeSelectorWidget.dart';

class KnowledgeBasePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: ChangeNotifierProvider(
            create: (context) => SelectedScaleNotifier(Note.C,ScaleMode.by
              (ModeType.Ionian),true),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KnowledgeBaseTitle(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [KeySelectorWidget(), ModeSelectorWidget()],
                ),
                Divider(
                  indent: 32,
                  endIndent: 32,
                  thickness: 0.5,
                ),
                Container(
                  height: 48,
                  child: ScaleNotesListView(),
                ),
                Divider(
                  indent: 32,
                  endIndent: 32,
                  thickness: 0.5,
                ),
                Container(
                  height: 100,
                  child: ScaleChordsListView()
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      StyledText("Tonic triad:",TextStyle()),
                      TriadWidget()
                    ],
                  ),
                ),
                GuitarScaleWidget()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
