import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progressions/widgets/StyledTitleText.dart';

const BEATS_PER_SCREEN = 8;
const BEATS_PER_BAR = 4;
const BARS_PER_SCREEN = BEATS_PER_SCREEN / BEATS_PER_BAR;
const BEAT_SIZE = 48.0;

class BeatWidget extends StatelessWidget {
  final String chord;
  final int index;

  BeatWidget({required this.chord, required this.index});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final size = BEAT_SIZE * BEATS_PER_SCREEN > width
        ? width / BEATS_PER_SCREEN
        : BEAT_SIZE;
    final fontSize = size / 4;
    return SizedBox(
      width: size,
      height: size,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Center(child: StyledText(chord, TextStyle(fontSize: fontSize))),
            if (index % BEATS_PER_BAR == 0)
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: StyledText("${index + 1}", TextStyle(fontSize: 10)),
              ),
          ],
        ),
      ),
    );
  }
}
