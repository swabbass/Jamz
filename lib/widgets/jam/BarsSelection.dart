import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:progressions/providers/BarsCountSelection.dart';
import 'package:progressions/widgets/common/PopupMenuWidget.dart';
import 'package:provider/provider.dart';

import '../StyledTitleText.dart';

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