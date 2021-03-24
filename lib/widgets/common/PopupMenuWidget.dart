import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../StyledTitleText.dart';

class PopupMenu<T> extends StatelessWidget {
  final List<T> _data = [];
  late final PopupMenuItemBuilder<T> _builder;
  late final String _label;
  late final TextStyle? _style;
  late final Function(T t, int index)? _onSelected;

  PopupMenu(
      {String label = "",
      required List<T> data,
      required PopupMenuItemBuilder<T> builder,
      TextStyle? style,
      Function(T t, int index)? onSelected}) {
    this._onSelected = onSelected;
    this._style = style;
    this._label = label;
    this._data.addAll(data);
    this._builder = builder;
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
        onSelected: (T t) {
          print("ffff $t");
          this._onSelected?.call(t, this._data.indexOf(t));
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                StyledText(
                    _label,
                    this._style != null
                        ? this._style!
                        : TextStyle(fontWeight: FontWeight.w400, fontSize: 18)),
                Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white,
                )
              ],
            ),
          ),
        ),
        itemBuilder: this._builder);
  }
}
