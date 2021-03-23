import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:progressions/widgets/StyledTitleText.dart';
import 'package:progressions/widgets/common/AppTitle.dart';
import 'package:progressions/widgets/common/PopupMenuWidget.dart';
import 'package:progressions/widgets/jam/BeatWidget.dart';

class CreateJamScreen extends StatelessWidget {
  static const int _MAX_BARS = 4;
  static final barsSelectionOptions = [
    for (int i = 1; i <= _MAX_BARS; i += 1) i
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTitle(
              title: "Create a Jam",
            ),
            BarsSelection(barsSelectionOptions: barsSelectionOptions),
            Row(
              children: [
                BeatWidget(),
                BeatWidget(),
                BeatWidget(),
                BeatWidget(),
                BeatWidget(),
                BeatWidget(),
                BeatWidget(),
                BeatWidget(),
              ],
            )
          ],
        ),
      ),
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          PopupMenu<int>(
              label: "Bars",
              data: barsSelectionOptions,
              builder: (BuildContext context) {
                return barsSelectionOptions
                    .map((e) => PopupMenuItem<int>(
                          value: e,
                          child: StyledText(
                              "$e", TextStyle(fontWeight: FontWeight.w300)),
                        ))
                    .toList(growable: false);
              },
              style: TextStyle(fontWeight: FontWeight.w300),
              onSelected: (int barCount, int index) =>
                  print("Bars selected $barCount, at $index")),
        ],
      ),
    );
  }
}
