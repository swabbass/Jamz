import 'package:progressions/models/Interval.dart';
import 'package:progressions/models/Notes.dart';

const MAJOR_THIRD_DISTANCE = 4; // 4 semi-tones distance from root
const MINOR_THIRD_DISTANCE = 3; // r semi-tones distance from root
const PERFECT_FIFTH_DISTANCE = 7; // 4 semi-tones distance from minor 3rd
const DIM_FIFTH_DISTANCE = 6; // 4 semi-tones distance from minor 3rd

class TonicTriad {
  final Note? root;
  final Note? third;
  final Note? fifth;
  int? _thirdDistance;
  int? _fifthDistance;
  IntervalMode? _mode;

  TonicTriad(this.root, this.third, this.fifth) {
    deductChordMode();
  }

  void deductChordMode() {
    final notesSize = Note.values.length;
    int thirdIndex = third!.index;
    int fifthIndex = fifth!.index;
    if (root!.index > third!.index) {
      thirdIndex += notesSize;
    }

    if (root!.index > fifth!.index) {
      fifthIndex += notesSize;
    }

    _thirdDistance = (root!.index - thirdIndex).abs();
    _fifthDistance = (root!.index - fifthIndex).abs();

    if (isMajor()) {
      _mode = IntervalMode.M;
    } else if (isMinor()) {
      _mode = IntervalMode.m;
    } else if (isDiminished()) {
      _mode = IntervalMode.d;
    } else
      _mode = IntervalMode.A;
  }

  IntervalMode? get mode => _mode;

  bool isMajor() {
    return _thirdDistance == MAJOR_THIRD_DISTANCE &&
        _fifthDistance == PERFECT_FIFTH_DISTANCE;
  }

  bool isMinor() {
    return _thirdDistance == MINOR_THIRD_DISTANCE &&
        _fifthDistance == PERFECT_FIFTH_DISTANCE;
  }

  bool isDiminished() {
    return _thirdDistance == MINOR_THIRD_DISTANCE &&
        _fifthDistance == DIM_FIFTH_DISTANCE;
  }

  @override
  String toString() {
    return 'TonicTriad{root: $root, ${root!.index}, third: $third, ${third!.index}, fifth:$fifth, ${fifth!.index}, mode :$mode';
  }
}
