import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:progressions/models/Interval.dart';
import 'package:progressions/models/Step.dart';

import 'ModeContsatns.dart';


enum ModeType { Ionian, Dorian, Phrygian, Lydian, Mixolydian, Aeolian, Locrian }

const SCALE_MODE_INTERVAL_MODES = [
  IntervalMode.M,
  IntervalMode.m,
  IntervalMode.m,
  IntervalMode.M,
  IntervalMode.M,
  IntervalMode.m,
  IntervalMode.d];


var _modeColors = [
  Colors.yellow.shade600,
  Colors.lightBlue,
  Colors.brown.shade400,
  Colors.blueAccent.shade400,
  Colors.deepOrange,
  Colors.blueGrey.shade800,
  Colors.deepPurple
];

class ScaleMode {
  final ModeType type;
  final List<MusicalStep> steps;
  final Color color;
  late String name;
  IntervalMode? _tonicMode;

  ScaleMode(this.type, this.steps, this.color) {
    this.name = MODE_NAMES[type.index];
    this._tonicMode = SCALE_MODE_INTERVAL_MODES[type.index];
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ScaleMode && runtimeType == other.runtimeType &&
              type == other.type;

  @override
  int get hashCode => type.hashCode;

  IntervalMode? get tonicMode => _tonicMode;

  ScaleMode.by(ModeType type)
      : this(type, _calculateMusicalSteps(type), _modeColors[type.index]);

  static List<MusicalStep> _calculateMusicalSteps(ModeType type) {
    var start = IONIAN_NOTE_STEPS.sublist(type.index);
    var end = IONIAN_NOTE_STEPS.sublist(0, type.index);
    var res = List.of(start);
    res.addAll(end);
    return res;
  }

  static UnmodifiableListView<ScaleMode> all() {
    return UnmodifiableListView(ModeType.values.map((e) => ScaleMode.by(e)));
  }
}
