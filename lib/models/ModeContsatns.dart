import 'dart:collection';

import 'package:progressions/models/Modes.dart';

import 'Interval.dart';
import 'Step.dart';

final UnmodifiableListView<MusicalStep> IONIAN_NOTE_STEPS =
    UnmodifiableListView([
  MusicalStep.W,
  MusicalStep.W,
  MusicalStep.H,
  MusicalStep.W,
  MusicalStep.W,
  MusicalStep.W,
  MusicalStep.H
]);
final UnmodifiableListView<String> MODE_NAMES = UnmodifiableListView([
  "Ionian",
  "Dorian",
  "Phrygian",
  "Lydian",
  "Mixolydian",
  "Aeolian",
  "Locrian"
]);

final IONIAN_INTERVALS = UnmodifiableListView<NoteInterval>([
  NoteInterval(IntervalMode.P, 1),
  NoteInterval(IntervalMode.M, 2),
  NoteInterval(IntervalMode.M, 3),
  NoteInterval(IntervalMode.P, 4),
  NoteInterval(IntervalMode.P, 5),
  NoteInterval(IntervalMode.M, 6),
  NoteInterval(IntervalMode.M, 7),
  NoteInterval(IntervalMode.P, 8),
]);

final DORIAN_INTERVALS = UnmodifiableListView<NoteInterval>([
  NoteInterval(IntervalMode.P, 1),
  NoteInterval(IntervalMode.M, 2),
  NoteInterval(IntervalMode.m, 3),
  NoteInterval(IntervalMode.P, 4),
  NoteInterval(IntervalMode.P, 5),
  NoteInterval(IntervalMode.M, 6),
  NoteInterval(IntervalMode.m, 7),
  NoteInterval(IntervalMode.P, 8),
]);

final PHRYGIAN_INTERVALS = UnmodifiableListView<NoteInterval>([
  NoteInterval(IntervalMode.P, 1),
  NoteInterval(IntervalMode.m, 2),
  NoteInterval(IntervalMode.m, 3),
  NoteInterval(IntervalMode.P, 4),
  NoteInterval(IntervalMode.P, 5),
  NoteInterval(IntervalMode.m, 6),
  NoteInterval(IntervalMode.m, 7),
  NoteInterval(IntervalMode.P, 8),
]);

final LYDIAN_INTERVALS = UnmodifiableListView<NoteInterval>([
  NoteInterval(IntervalMode.P, 1),
  NoteInterval(IntervalMode.M, 2),
  NoteInterval(IntervalMode.M, 3),
  NoteInterval(IntervalMode.A, 4),
  NoteInterval(IntervalMode.P, 5),
  NoteInterval(IntervalMode.M, 6),
  NoteInterval(IntervalMode.M, 7),
  NoteInterval(IntervalMode.P, 8),
]);

final MIXOLYDIAN_INTERVALS = UnmodifiableListView<NoteInterval>([
  NoteInterval(IntervalMode.P, 1),
  NoteInterval(IntervalMode.M, 2),
  NoteInterval(IntervalMode.M, 3),
  NoteInterval(IntervalMode.A, 4),
  NoteInterval(IntervalMode.P, 5),
  NoteInterval(IntervalMode.M, 6),
  NoteInterval(IntervalMode.m, 7),
  NoteInterval(IntervalMode.P, 8),
]);

final AEOLIAN_INTERVALS = UnmodifiableListView<NoteInterval>([
  NoteInterval(IntervalMode.P, 1),
  NoteInterval(IntervalMode.M, 2),
  NoteInterval(IntervalMode.m, 3),
  NoteInterval(IntervalMode.P, 4),
  NoteInterval(IntervalMode.P, 5),
  NoteInterval(IntervalMode.m, 6),
  NoteInterval(IntervalMode.m, 7),
  NoteInterval(IntervalMode.P, 8),
]);

final LOCRIAN_INTERVALS = UnmodifiableListView<NoteInterval>([
  NoteInterval(IntervalMode.P, 1),
  NoteInterval(IntervalMode.m, 2),
  NoteInterval(IntervalMode.m, 3),
  NoteInterval(IntervalMode.A, 4),
  NoteInterval(IntervalMode.d, 5),
  NoteInterval(IntervalMode.m, 6),
  NoteInterval(IntervalMode.m, 7),
  NoteInterval(IntervalMode.P, 8),
]);

UnmodifiableListView<NoteInterval> getIntervalsByMode(ModeType type) {
  switch (type) {
    case ModeType.Aeolian:
      return AEOLIAN_INTERVALS;
    case ModeType.Dorian:
      return DORIAN_INTERVALS;
    case ModeType.Ionian:
      return IONIAN_INTERVALS;
    case ModeType.Phrygian:
      return PHRYGIAN_INTERVALS;
    case ModeType.Lydian:
      return LYDIAN_INTERVALS;
    case ModeType.Mixolydian:
      return MIXOLYDIAN_INTERVALS;
    case ModeType.Locrian:
      return LOCRIAN_INTERVALS;
  }
}
