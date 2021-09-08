import 'package:flutter/widgets.dart';
import 'package:progressions/providers/JamShareStateNotifier.dart';
import 'package:provider/provider.dart';

import '../KeySelectorWidget.dart';
import '../ModeSelectorWidget.dart';
import 'BarsSelection.dart';

const int _MAX_BARS = 12;

class JamOptionsWidget extends StatelessWidget {
  final barsSelectionOptions = [for (int i = 2; i <= _MAX_BARS; i += 2) i];

  @override
  Widget build(BuildContext context) {
    final shareStateProvider = Provider.of<JamShareStateNotifier>(context);

    return IgnorePointer(
      ignoring: !shareStateProvider.enableUI,
      child: Padding(
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
    );
  }
}
