import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progressions/models/Notes.dart';
import 'package:progressions/models/ScaleSelection.dart';
import 'package:provider/provider.dart';

import 'ScaleNoteWidget.dart';
import '../models/Chord.dart';

class TriadWidget extends StatelessWidget {
  final Chord? chord;
  final Note? keyRoot;

  const TriadWidget({Key? key, this.chord, this.keyRoot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SelectedScaleNotifier>(context);
    var tonicTriad = chord != null
        ? chord!.tonicTriad
        : provider.selectedScale.chords[0].tonicTriad;
    final root = keyRoot==null? tonicTriad.root:keyRoot;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ScaleNoteWidget(
          note: tonicTriad.root,
          positionName: "",
          color: root == tonicTriad.root ? Theme.of(context).accentColor : null,
        ),
        ScaleNoteWidget(
          note: tonicTriad.third,
          positionName: "",
          color: root == tonicTriad.third ? Theme.of(context).accentColor : null,

        ),
        ScaleNoteWidget(
          note: tonicTriad.fifth,
          positionName: "",
          color: root == tonicTriad.fifth ? Theme.of(context).accentColor : null,

        )
      ],
    );
  }
}
