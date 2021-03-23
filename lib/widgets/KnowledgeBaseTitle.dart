import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progressions/models/ScaleSelection.dart';
import 'package:progressions/widgets/StyledTitleText.dart';
import 'package:provider/provider.dart';

class KnowledgeBaseTitle extends StatelessWidget {
  const KnowledgeBaseTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StyledText("Knowledge Base",
              TextStyle(fontWeight: FontWeight.w900, fontSize: 24)),
          Consumer<SelectedScaleNotifier>(
            builder: (context, scaleSelection, child) {
              return Switch(
                value: scaleSelection.sharps,
                onChanged: (bool state) {
                  //Use it to manage the different states
                  if (scaleSelection.sharps != state)
                    scaleSelection.sharps = state;
                },
              );
            },
          )
        ],
      ),
    );
  }
}
