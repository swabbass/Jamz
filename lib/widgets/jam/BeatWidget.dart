import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progressions/widgets/StyledTitleText.dart';

class BeatWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery
        .of(context)
        .size
        .width;

    return SizedBox(width: width / 8, height: width / 8,
      child: Card(
        child: Center(child: StyledText("Am",TextStyle())),
      ),);
  }

}