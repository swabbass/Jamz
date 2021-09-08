import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:progressions/models/user.dart';
import 'package:progressions/widgets/common/header.dart';
import 'package:progressions/widgets/common/bottom_navBar.dart';
import 'package:progressions/widgets/common/post.dart';

import 'package:progressions/widgets/common/progress.dart';
import 'package:progressions/widgets/jam/CreateJamScreen.dart';
import 'package:progressions/widgets/login/google_sign_in_button.dart';
import 'package:progressions/widgets/pages/test_for_screenshot.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// final usersRef = FirebaseFirestore.instance.collection('users');
AppUser? currentUser;

class Timeline extends StatefulWidget {
  const Timeline({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  late User _user;
  List<Post>? posts;
  // AppUser? currentUser;

  @override
  void initState() {
    _user = widget._user;
    setCurrUser();
    getTimeline();
    super.initState();
  }

  getTimeline() async {
    QuerySnapshot snapshot = await timelineRef
        .doc(widget._user.uid)
        .collection('timelinePosts')
        .orderBy('timestamp', descending: true)
        .get();
    List<Post> posts =
        snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
    setState(() {
      this.posts = posts;
    });
  }

  setCurrUser() async {
    DocumentSnapshot doc = await usersRef.doc(_user.uid).get();
    currentUser = AppUser.fromDocument(doc);
  }

  buildTimeline() {
    if (posts == null) {
      return circularProgress();
    } else if (posts!.isEmpty) {
      return Text(
          "No posts"); //TODO implement suggest users to follow , (latest users signed up to app)
    } else {
      return ListView(children: posts!);
    }
  }

  @override
  Widget build(BuildContext context) {
    // setCurrUser();
    return Scaffold(
      backgroundColor: Color(0xFF414141),
      appBar: header(context, isAppTitle: true),
      body: RefreshIndicator(
          onRefresh: () => getTimeline(), child: buildTimeline()),
      bottomNavigationBar: bottomBar(context, isHome: true, user: _user),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) => CreateJamScreen(
                        user: _user,
                      )),
            );
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
