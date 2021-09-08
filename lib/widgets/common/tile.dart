import 'package:flutter/material.dart';
import 'package:progressions/widgets/common/custom_image.dart';
import 'package:progressions/widgets/common/post.dart';

class Tile extends StatelessWidget {
  final Post post;

  Tile(this.post);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {},
      // print('showing post'),
      child: cachedNetworkImage(post.mediaUrl),
    );
  }
}
