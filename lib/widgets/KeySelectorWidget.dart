import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progressions/models/ScaleSelection.dart';
import 'package:provider/provider.dart';

import 'StyledTitleText.dart';
import '../models/Notes.dart';

class KeySelectorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<SelectedScaleNotifier>(context);
    Note _selectedNote = provider.selectedKey;

    return PopupMenuButton<Note>(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              StyledText(
                  "Key: ${NOTES_NAMES[_selectedNote.index]}",
                  TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  )),
              Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
              )
            ]),
          ),
        ),
        onSelected: (Note result) {
          provider.selectedKey = result;
        },
        itemBuilder: (BuildContext context) => Note.values
            .map((e) => PopupMenuItem<Note>(
                  value: e,
                  child: StyledText(NOTES_NAMES[e.index],
                      TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                ))
            .toList());
  }
}
