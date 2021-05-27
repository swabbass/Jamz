import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progressions/models/ScaleSelection.dart';
import 'package:provider/provider.dart';

import 'ScaleChordWidget.dart';

class ScaleChordsListView extends StatelessWidget {
  const ScaleChordsListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectedScaleNotifier>(
      builder: (context, scaleSelection, child) {
        return ListView(
          scrollDirection: Axis.horizontal,
          children: scaleSelection.selectedScale.chords
              .map((e) => ScaleChordWidget(
                    chord: e,
            keyRoot: scaleSelection.selectedKey,
                  ))
              .toList(),
        );
      },
    );
  }
}
