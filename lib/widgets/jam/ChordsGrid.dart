import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:progressions/models/ScaleSelection.dart';
import 'package:progressions/providers/BarsCountSelection.dart';
import 'package:progressions/providers/ChordProgressionSelection.dart';
import 'package:progressions/providers/JamShareStateNotifier.dart';
import 'package:provider/provider.dart';

import '../StyledTitleText.dart';
import 'BeatWidget.dart';

class ChordsGrid extends StatelessWidget {
  const ChordsGrid({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final barCountProvider = Provider.of<BarsCountSelection>(context);
    final shareStateProvider = Provider.of<JamShareStateNotifier>(context);
    final selectedScaleProvider = Provider.of<SelectedScaleNotifier>(context);
    final chordsSelectProvider =
        Provider.of<ChordProgressionSelection>(context);
    final barsCount = barCountProvider.barsCount;
    return IgnorePointer(
      ignoring: !shareStateProvider.enableUI,
      child: Container(
        height: (barsCount / BARS_PER_SCREEN) * BEAT_SIZE,
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2 * BEATS_PER_BAR,
            ),
            itemCount: barsCount * BEATS_PER_BAR,
            itemBuilder: (BuildContext context, int index) {
              return buildBeatWidget(
                  index, selectedScaleProvider, chordsSelectProvider);
            }),
      ),
    );
  }

  Widget buildBeatWidget(
      int beatIndex,
      SelectedScaleNotifier selectedScaleProvider,
      ChordProgressionSelection chordsSelectionProvider) {
    final chordsSelection = chordsSelectionProvider.chordsSelection;
    final chordIndexInScale = chordsSelection[beatIndex];
    final selectedScale = selectedScaleProvider.selectedScale;
    final label = chordIndexInScale == null
        ? ""
        : selectedScale.chords[chordIndexInScale].name;
    final chords = selectedScale.chords
        .asMap()
        .map((index, e) => MapEntry(
            index,
            PopupMenuItem<int>(
                value: index,
                child: Center(child: StyledText(e.name, TextStyle())))))
        .values
        .toList();
    final beatPopUp = PopupMenuButton(
      child: BeatWidget(
        chord: label,
        index: beatIndex,
      ),
      itemBuilder: (context) => chords,
      onSelected: (int value) {
        print("xxxxx $value");
        chordsSelection[beatIndex] = value;
        chordsSelectionProvider.chordsSelection = chordsSelection;
      },
    );
    return beatPopUp;
  }
}
