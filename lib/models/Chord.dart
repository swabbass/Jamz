import 'package:progressions/models/Interval.dart';
import 'package:progressions/models/Notes.dart';
import 'package:progressions/models/TonicTriad.dart';

class Chord {
  String? _name;
  final TonicTriad tonicTriad;

  Chord(this.tonicTriad, Note root) {
    this._name =
        "${NOTES_NAMES[root.index]}${tonicTriad.mode == IntervalMode.M ? "" : IntervalNames[tonicTriad.mode!.index]}";
  }

  String? get name => _name;

  @override
  String toString() {
    return 'Chord{_name: $_name, tonicTriad: ${tonicTriad}';
  }
}
