import 'dart:convert';

import 'package:progressions/models/Modes.dart';
import 'package:progressions/models/Notes.dart';

class Jam {
  final int barCount;
  final int keyIndex;
  final int modeIndex;
  final Map<int, int> chordProg;

  Jam(this.barCount, this.keyIndex, this.modeIndex, this.chordProg);
  Map<String, dynamic> toJson() => {
        'barCount': barCount,
        'keyIndex': keyIndex,
        'modeIndex': modeIndex,
        'chordProg': chordProg.map((key, value) => MapEntry("$key", value))
      };

  Jam.fromJson(Map<String, dynamic> json)
      : barCount = json['barCount'],
        keyIndex = json['keyIndex'],
        modeIndex = json['modeIndex'],
        chordProg = (json['chordProg'] as Map<String, int>)
            .map((key, value) => MapEntry(int.parse(key), value));

  Note get key => Note.values[keyIndex];

  ScaleMode get mode => ScaleMode.by(ModeType.values[modeIndex]);

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}
