import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:progressions/widgets/StyledTitleText.dart';

import '../models/Notes.dart';

class ScaleNoteWidget extends StatelessWidget {
  final Note? note;
  final String? positionName;
  final Color? color;

  const ScaleNoteWidget({Key? key, this.note, this.positionName, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: CircleBorder(),
      shadowColor: Colors.white,
      elevation: 1,
      color: color,
      child: Container(
        width: 32,
        height: 48,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              StyledText(
                  NOTES_NAMES[note!.index],
                  TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 12)),
              positionName!.isEmpty
                  ? SizedBox.shrink()
                  : StyledText(
                      positionName!,
                      TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          fontSize: 8)),
            ]),
      ),
    );
  }
}
