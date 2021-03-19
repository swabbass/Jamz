import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:progressions/widgets/StyledTitleText.dart';
import 'package:progressions/models/Chord.dart';

import 'ScaleNoteWidget.dart';
import 'TriadWidget.dart';
import '../models/Notes.dart';

class ScaleChordWidget extends StatelessWidget {
 final Chord? chord;
final Color? color;
final Note? keyRoot;
  const ScaleChordWidget({Key? key, this.chord, this.color,this.keyRoot}) : super
      (key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.white,
      color: color,
      child: Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            StyledText(
           chord!.name!, TextStyle(color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 18)),
              TriadWidget(chord:chord,keyRoot: keyRoot,)
              ,
        ]),
      ),
    );
  }
}
