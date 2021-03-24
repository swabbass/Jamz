import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:progressions/models/Chord.dart';
import 'package:progressions/models/Modes.dart';
import 'package:progressions/models/Notes.dart';
import 'package:progressions/models/Scale.dart';
import 'package:progressions/models/ScaleSelection.dart';
import 'package:progressions/providers/BarsCountSelection.dart';
import 'package:progressions/widgets/KeySelectorWidget.dart';
import 'package:progressions/widgets/ModeSelectorWidget.dart';
import 'package:progressions/widgets/StyledTitleText.dart';
import 'package:progressions/widgets/common/AppTitle.dart';
import 'package:progressions/widgets/common/PopupMenuWidget.dart';
import 'package:progressions/widgets/jam/BeatWidget.dart';
import 'package:provider/provider.dart';

const int _MAX_BARS = 12;
final tmpScale = Scale(ScaleMode.by(ModeType.Ionian), Note.C);

class CreateJamScreen extends StatelessWidget {
  final barsSelectionOptions = [for (int i = 2; i <= _MAX_BARS; i += 2) i];

  final chordsSelection = <int, int>{0: 0, 4: 2, 8: 4, 12: 0};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => SelectedScaleNotifier(
                Note.C, ScaleMode.by(ModeType.Ionian), true),
          ),
          ChangeNotifierProvider(
            create: (context) => BarsCountSelection(2),
          )
        ],
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTitle(
                title: "Create a Jam",
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 32,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BarsSelection(barsSelectionOptions: barsSelectionOptions),
                    KeySelectorWidget(),
                    ModeSelectorWidget()
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 32,
                ),
                child: ChordsGrid(chordsSelection: chordsSelection),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 32,
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  color: Colors.red.shade300,
                  child: Center(
                    child: StyledText(
                        "Recording goes "
                        "here!",
                        TextStyle()),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  FloatingActionButton.extended(
                      backgroundColor: Colors.blueAccent.shade400,
                      onPressed: () => null,
                      label: StyledText("Sharing is caring!", TextStyle())),
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ChordsGrid extends StatelessWidget {
  const ChordsGrid({
    Key? key,
    required this.chordsSelection,
  }) : super(key: key);

  final Map<int, int> chordsSelection;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<BarsCountSelection>(context);
    var selectedScaleProvider = Provider.of<SelectedScaleNotifier>(context);
    final barsCount = provider.barsCount;
    return Container(
      height: (barsCount / BARS_PER_SCREEN) * BEAT_SIZE,
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2 * BEATS_PER_BAR,
          ),
          itemCount: barsCount * BEATS_PER_BAR,
          itemBuilder: (BuildContext context, int index) {
            final chordIndexInScale = chordsSelection[index];
            final selectedScale = selectedScaleProvider.selectedScale;
            final label = chordIndexInScale == null
                ? ""
                : selectedScale!.chords[chordIndexInScale].name!;
            return BeatWidget(
              chord: label,
              index: index,
            );
          }),
    );
  }
}

class BarsSelection extends StatelessWidget {
  const BarsSelection({
    Key? key,
    required this.barsSelectionOptions,
  }) : super(key: key);

  final List<int> barsSelectionOptions;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<BarsCountSelection>(context);
    return PopupMenu<int>(
        label: "Bars: ${provider.barsCount}",
        data: barsSelectionOptions,
        builder: (BuildContext context) {
          return barsSelectionOptions
              .map((e) => PopupMenuItem<int>(
                    value: e,
                    child: StyledText(
                        "$e",
                        TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        )),
                  ))
              .toList();
        },
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        onSelected: (int barCount, int index) {
          provider.barsCount = barCount;
        });
  }
}
