import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:progressions/widgets/pages/user_profile.dart';
import 'package:progressions/widgets/pages/search.dart';
import 'package:progressions/widgets/pages/timeline.dart';

import '../StyledTitleText.dart';

BottomAppBar bottomBar(context, {bool isHome = false, required User user}) {
  return BottomAppBar(
    child: Row(
      children: [
        SizedBox(
          width: 15.0,
        ),
        IconButton(
            icon: Icon(Icons.home),
            iconSize: 30.0,
            onPressed: () {
              if (isHome) {
                print("Home pressed");
              } else {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => Timeline(user: user)),
                );
              }
            }),
        SizedBox(
          width: 15.0,
        ),
        IconButton(
            icon: Icon(Icons.search),
            iconSize: 30.0,
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) => Search(
                          userOwner: user,
                        )),
              );
            }),
        Spacer(),
        SizedBox(
          width: 15.0,
        ),
        IconButton(
          icon: Icon(Icons.notifications_active),
          iconSize: 30.0,
          onPressed: () => print("notifications pressed"),
        ),
        SizedBox(
          width: 15.0,
        ),
        IconButton(
          icon: Image.asset('assets/user_64.png'),
          iconSize: 30.0,
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => UserProfile(
                  profileId: user.uid,
                  user: user,
                ),
              ),
            );
          },
        ),
        SizedBox(
          width: 15.0,
        ),
      ],
    ),
  );
}
