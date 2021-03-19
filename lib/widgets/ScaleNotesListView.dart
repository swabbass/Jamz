import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progressions/widgets/ScaleNoteWidget.dart';
import 'package:progressions/models/ScaleSelection.dart';
import 'package:provider/provider.dart';


class ScaleNotesListView extends StatelessWidget {
  const ScaleNotesListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectedScaleNotifier>(
      builder: (context, scaleSelection, child) {
        var selectedScale = scaleSelection.selectedScale!;
        print("cveveveveveevevevevev");
        print(selectedScale.notes);
        return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: selectedScale.notes!.map((note) {
              var index = selectedScale.notes!.indexOf(note);
              return ScaleNoteWidget(
                  note: note,
                  positionName: index == 0 ? "root" : "${index + 1}",
                  color: index == 0 ? Theme.of(context).accentColor : null);
            }).toList(growable: false));
      },
    );
  }
  
}
