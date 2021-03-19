import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progressions/widgets/StyledTitleText.dart';
import 'package:provider/provider.dart';

import '../models/Modes.dart';
import '../models/ScaleSelection.dart';

class ModeSelectorWidget extends StatelessWidget {
  final supportedModes = ScaleMode.all();

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<SelectedScaleNotifier>(context);
    ScaleMode _selectedMode = provider.selectedMode!;
    return PopupMenuButton<ScaleMode>(
      child: Card(
        color: _selectedMode.color,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StyledText(
                    "Mode: ${_selectedMode.name}",
                    TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.white
                    )),
                Icon(Icons.arrow_drop_down,color: Colors.white,)
              ],
            ),
          ),
      ),
        onSelected: (ScaleMode result) {
         provider.selectedMode = result;
        },
        itemBuilder: (BuildContext context) => supportedModes
            .map((e) => PopupMenuItem<ScaleMode>(
                  value: e,
                  child: Container(
                    child: Center(
                      child: StyledText(
                          e.name,
                          TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color:Colors.white)),
                    ),
                  ),
                ))
            .toList());
  }
}
