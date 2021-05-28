import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progressions/widgets/StyledTitleText.dart';

class AppTitle extends StatelessWidget {
  final String? title;

  const AppTitle({
    Key? key,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: this.title == null
            ? []
            : [
                StyledText(this.title!,
                    TextStyle(fontWeight: FontWeight.w900, fontSize: 24))
              ],
      ),
    );
  }
}
