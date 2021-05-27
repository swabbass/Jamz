import 'dart:collection';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:progressions/models/Notes.dart';
import 'package:progressions/models/Scale.dart';
import 'package:progressions/models/ScaleSelection.dart';
import 'package:provider/provider.dart';

const MAX_FRETS_COUNT = 17;
class GuitarScaleWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => GuitarScaleWidgetState();

}
class GuitarScaleWidgetState extends State<GuitarScaleWidget> with SingleTickerProviderStateMixin{


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
      child: Consumer<SelectedScaleNotifier>(
        builder: (context,selectedScaleNotifier,child) {
          return CustomPaint(painter: GuitarScalePainter(48.0,
              selectedScaleNotifier.selectedScale, Theme
                  .of(context)
                  .accentColor),
            size: new Size(48.0 * MAX_FRETS_COUNT, 200),
          );
        }
      )
    );
  }

}
class GuitarScalePainter extends CustomPainter {
  final UnmodifiableListView<Note> stringTuning =
      UnmodifiableListView([Note.E, Note.A, Note.D, Note.G, Note.B, Note.E]);
  final double _fretSize;
  final Scale? scale;
  final Color rootColor;

  final _fretPaint = Paint()
    ..color = Colors.grey
    ..strokeWidth = 1.5
    ..isAntiAlias = true;
  final _stringsPaint = Paint()..color = Colors.white;
  late var _rootCirclesPaint;
  late var _stringCount;

  GuitarScalePainter(this._fretSize, this.scale, this.rootColor) {
    this._stringCount = stringTuning.length;
    this._rootCirclesPaint=Paint()..color = rootColor;
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (int fretPos = 0; fretPos < MAX_FRETS_COUNT; ++fretPos) {
      _drawFrets(canvas, fretPos, size);
      _drawFretCircles(fretPos, size, canvas);
    }

    _drawStrings(size, canvas);
    _drawNotes(size, canvas);
  }

  void _drawStrings(Size size, Canvas canvas) {
    for (int i = 1; i <= this._stringCount; ++i) {
      double dy = (i - 0.5) * size.height / this._stringCount;
      canvas.drawLine(Offset(0, dy),
          Offset(_fretSize * (MAX_FRETS_COUNT + 1), dy), _stringsPaint);
    }
  }

  void _drawNotes(Size size, Canvas canvas) {
    for (int fretPos = 0; fretPos < MAX_FRETS_COUNT; ++fretPos) {
      for (int stringPos = 1; stringPos <= this._stringCount; ++stringPos) {
        _drawNote(fretPos, stringPos, size, canvas);
      }
    }
  }

  void _drawNote(int fretPos, int stringPos, Size size, Canvas canvas) {
    final guitarNote =
        getGuitarNote(fretPos: fretPos, tuning: stringTuning[stringPos - 1]);
    final stringCount = stringTuning.length;

    var fretYStart = ((stringCount - stringPos) / stringCount) * size.height;
    double dy = fretYStart + (size.height / (4 * stringCount));
    var offset2 = Offset(fretPos * _fretSize, dy);
    var isRoot = scale!.key == guitarNote;
    if (isRoot) {
      _drawRootNoteCircle(fretPos, fretYStart, size, stringCount, canvas);
    }
    final textStyle = TextStyle(
      color: scale!.notes!.contains(guitarNote)
          ? Colors.white
          : Colors.white.withOpacity(0.2),
      fontSize: 14,
    );
    final textSpan = TextSpan(
      text: NOTES_NAMES[guitarNote.index],
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: _fretSize,
      maxWidth: _fretSize,
    );
    textPainter.paint(canvas, offset2);
  }

  void _drawRootNoteCircle(int fretPos, double fretYStart, Size size, int stringCount, Canvas canvas) {
       var offsetCircles = Offset(fretPos * _fretSize + (_fretSize / 2),
        fretYStart+(size.height / (2 * stringCount)));
    canvas.drawCircle(offsetCircles, _fretSize / 4, _rootCirclesPaint);
  }

  void _drawFretCircles(int i, Size size, Canvas canvas) {
    if (i == 0) return;
    if (i % 13 == 0) {
      var offsetDot1 = Offset(i * _fretSize - (_fretSize / 2), size.height / 4);
      var offsetDot2 =
          Offset(i * _fretSize - (_fretSize / 2), 3 * size.height / 4);
      canvas.drawCircle(offsetDot1, _fretSize / 4, _fretPaint);
      canvas.drawCircle(offsetDot2, _fretSize / 4, _fretPaint);
    }
    if (i == 3 || i == 9) {
      var offsetDots = Offset(i * _fretSize - (_fretSize / 2), size.height / 2);
      canvas.drawCircle(offsetDots, _fretSize / 4, _fretPaint);
    }
  }

  Note getGuitarNote({required int fretPos, Note tuning = Note.E}) {
    return Note.values[(tuning.index + fretPos) % Note.values.length];
  }

  void _drawFrets(Canvas canvas, int i, Size size) {
    canvas.drawLine(Offset(i * _fretSize, 0),
        Offset(i * _fretSize, size.height), _fretPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) =>
      (oldDelegate as GuitarScalePainter).scale != scale;
}
