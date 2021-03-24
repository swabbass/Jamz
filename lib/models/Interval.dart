import 'package:progressions/models/Modes.dart';

final _intervalModesNames = ["P", "M", "m"];
enum IntervalMode{P,M,m,A,d}
const  IntervalNames = ["","","m","aug","dim"];
//
// final MODE_INTERVALS = Map.fromIterable([
//  ModeType.Ionian
// ]);
class NoteInterval {
 final IntervalMode intervalMode;
  final int number;

   const NoteInterval(this.intervalMode, this.number);

  @override
  String toString() {
    return "${_intervalModesNames[intervalMode.index]}$number";
  }
}

