import 'package:flutter/material.dart';

import '../StyledTitleText.dart';

AppBar header(context, {bool isAppTitle = false, String? titleText}) {
  return AppBar(
    title: StyledText((isAppTitle ? "Jamz" : titleText)!,
        TextStyle(fontWeight: FontWeight.w900, fontSize: isAppTitle ? 32 : 22)),
    centerTitle: true,
  );
}
