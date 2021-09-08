import 'dart:collection';

import 'package:progressions/models/Interval.dart';
import 'package:progressions/models/ModeContsatns.dart';
import 'package:progressions/models/Modes.dart';
import 'package:progressions/models/Notes.dart';
import 'package:progressions/models/Step.dart';
import 'package:progressions/models/TonicTriad.dart';

import 'Chord.dart';

class Scale {
  final ScaleMode? mode;
  final Note? key;
  UnmodifiableListView<Note?>? notes;
  UnmodifiableListView<NoteInterval>? intervals;
  late UnmodifiableListView<Chord> chords;

  Scale(this.mode, this.key) {
    this.intervals = getIntervalsByMode(mode!.type);
    this.notes = _generateNotesForScale();
    final notesWithoutOctave = this.notes!.sublist(0, this.notes!.length - 1);
    // print(notesWithoutOctave);
    this.chords = UnmodifiableListView<Chord>(notesWithoutOctave.map((e) {
      final index = notesWithoutOctave.indexOf(e);
      return Chord(
          TonicTriad(
              notesWithoutOctave[index],
              notesWithoutOctave[(index + 2) % notesWithoutOctave.length],
              notesWithoutOctave[(index + 4) % notesWithoutOctave.length]),
          e!);
    }));
  }

  UnmodifiableListView<Note?> _generateNotesForScale() {
    List<Note?> res = [];
    res.add(this.key);
    int i = this.key!.index;
    for (MusicalStep step in this.mode!.steps) {
      i += step == MusicalStep.H ? HALF_STEP_VAL : WHOLE_STEP_VAL;
      i %= Note.values.length;
      res.add(Note.values[i]);
    }
    return UnmodifiableListView(res);
  }
}
