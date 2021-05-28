import 'package:flutter/material.dart';
import 'package:progressions/models/ScaleSelection.dart';
import 'package:progressions/models/ShareState.dart';
import 'package:progressions/models/jam/Jam.dart';
import 'package:progressions/providers/BarsCountSelection.dart';
import 'package:progressions/providers/ChordProgressionSelection.dart';
import 'package:progressions/providers/JamShareStateNotifier.dart';
import 'package:provider/provider.dart';

import '../StyledTitleText.dart';

class ShareJamButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final shareStateProvider = Provider.of<JamShareStateNotifier>(context);
    final barCountProvider = Provider.of<BarsCountSelection>(context);
    final selectedScaleProvider = Provider.of<SelectedScaleNotifier>(context);
    final chordProgProvider = Provider.of<ChordProgressionSelection>(context);
    Widget button = selectShareByState(context, shareStateProvider,
        barCountProvider, selectedScaleProvider, chordProgProvider);
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child:
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [button]),
    );
  }

  Widget selectShareByState(
      BuildContext context,
      JamShareStateNotifier shareStateProvider,
      BarsCountSelection barCountProvider,
      SelectedScaleNotifier selectedScaleProvider,
      ChordProgressionSelection chordProgProvider) {
    switch (shareStateProvider.shareState) {
      case ShareState.ERROR:
        return FloatingActionButton.extended(
            backgroundColor: Colors.redAccent.shade400,
            onPressed: () {
              Future.delayed(Duration(seconds: 5),
                  () => {shareStateProvider.shareState = ShareState.DONE});
              shareStateProvider.shareState = ShareState.UPLOADING;
            },
            label: Icon(
              Icons.refresh,
              color: Colors.white,
              size: 24,
            ));
      case ShareState.UPLOADING:
        return FloatingActionButton.extended(
            backgroundColor: Colors.deepPurple.shade400,
            onPressed: () => null,
            label: SizedBox(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.yellow.shade700),
                strokeWidth: 3,
              ),
              width: 24,
              height: 24,
            ));
      case ShareState.DONE:
        return FloatingActionButton.extended(
            backgroundColor: Colors.greenAccent.shade400,
            onPressed: () => null,
            label: StyledText("Done!", TextStyle()));
      case ShareState.INITAL:
      default:
        return FloatingActionButton.extended(
            backgroundColor: Colors.blueAccent.shade400,
            onPressed: () {
              //ready to be json
              Jam jam = buildData(
                  barCountProvider, selectedScaleProvider, chordProgProvider);
              Future.delayed(Duration(seconds: 5),
                  () => {shareStateProvider.shareState = ShareState.ERROR});
              shareStateProvider.shareState = ShareState.UPLOADING;
              //sync share with backend/firebase..call application state to update its sections
              //see https://firebase.google.com/codelabs/firebase-get-to-know-flutter#5
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Sending Message $jam"),
              ));
              print(jam);
            },
            label: StyledText("Sharing is caring!", TextStyle()));
    }
  }

  Jam buildData(
      BarsCountSelection barCountProvider,
      SelectedScaleNotifier selectedScaleProvider,
      ChordProgressionSelection chordProgProvider) {
    return Jam(
        barCountProvider.barsCount,
        selectedScaleProvider.selectedKey.index,
        selectedScaleProvider.selectedMode!.type.index,
        chordProgProvider.chordsSelection);
  }
}
