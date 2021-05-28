import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:progressions/models/user.dart';
import 'package:progressions/widgets/common/header.dart';
import 'package:progressions/widgets/common/progress.dart';
import 'package:progressions/widgets/common/tile.dart';
import 'package:progressions/widgets/jam/CreateJamScreen.dart';
import 'package:progressions/widgets/login/google_sign_in_button.dart';
import 'package:progressions/widgets/pages/edit_profile.dart';
import 'package:progressions/widgets/common/bottom_navBar.dart';
import 'package:progressions/widgets/common/post.dart';
import 'package:progressions/widgets/pages/search.dart';
import 'package:progressions/widgets/pages/timeline.dart';

class UserProfile extends StatefulWidget {
  // bool isFollowing = false;
  final String? profileId;
  // final String userId;
  User? _user;

  UserProfile({Key? key, this.profileId, User? user})
      : _user = user,
        super(key: key);
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool isFollowing = false;

  final String currentUserId = currentUser!.id;
  late User _user;
  bool isLoading = false;
  int postCount = 0;
  int savedCount = 0;
  List<Post> posts = [];
  String postToggle = "posts";
  int followerCount = 0;
  int followingCount = 0;

  @override
  void initState() {
    _user = widget._user!;
    // currentUserId = currentUser!.id;
    getProfilePosts();
    getFollowers();
    getFollowing();
    checkIfFollowing();
    super.initState();
  }

  checkIfFollowing() async {
    DocumentSnapshot doc = await followersRef
        .doc(widget.profileId)
        .collection('userFollowers')
        .doc(currentUserId)
        .get();
    setState(() {
      isFollowing = doc.exists;
    });
  }

  getFollowers() async {
    QuerySnapshot snapshot = await followersRef
        .doc(widget.profileId)
        .collection('userFollowers')
        .get();
    setState(() {
      followerCount = snapshot.docs.length;
    });
  }

  getFollowing() async {
    QuerySnapshot snapshot = await followingRef
        .doc(widget.profileId)
        .collection('userFollowing')
        .get();
    setState(() {
      followingCount = snapshot.docs.length;
    });
  }

  getProfilePosts() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snapshot = await postsRef
        .doc(widget.profileId)
        .collection('userPosts')
        .orderBy('timestamp', descending: true)
        .get();
    setState(() {
      isLoading = false;
      postCount = snapshot.docs.length;
      posts = snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
    });
  }

  // final String currentUserId = widget.userId;
  Column buildCountColumn(String label, int count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          count.toString(),
          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: EdgeInsets.only(top: 4.0),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  editProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditProfile(currentUserId: currentUserId)),
    ).then((value) => setState(() {}));

    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => EditProfile(currentUserId: currentUserId)));
  }

  Container buildButton({String? text, VoidCallback? function}) {
    return Container(
      padding: EdgeInsets.only(top: 2.0),
      child: TextButton(
        onPressed: function,
        child: Container(
          width: 250.0,
          height: 27.0,
          child: Text(
            text!,
            style: TextStyle(
              color: isFollowing ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isFollowing ? Colors.white : Color(0xFFb71c1c),
            border: Border.all(
              color: isFollowing ? Colors.grey : Color(0xFFb71c1c),
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
    );
  }

  buildProfileButton() {
    bool isProfileOwner = widget.profileId == currentUserId;

    if (isProfileOwner) {
      return buildButton(text: "Edit Profile", function: editProfile);
    } else if (isFollowing) {
      return buildButton(text: "Unfollow", function: handleUnfollowUser);
    } else if (!isFollowing) {
      return buildButton(text: "Follow", function: handleFollowUser);
    }
  }

  handleUnfollowUser() {
    setState(() {
      isFollowing = false;
    });
    // Remove the follower
    followersRef
        .doc(widget.profileId)
        .collection('userFollowers')
        .doc(currentUserId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    // Remove the following
    followingRef
        .doc(currentUserId)
        .collection('userFollowing')
        .doc(widget.profileId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    // delete activity feed to send notification about new follower
  }

  handleFollowUser() {
    setState(() {
      isFollowing = true;
    });
    // Make the sigend user to follow the visited user --> update follower collection
    followersRef
        .doc(widget.profileId)
        .collection('userFollowers')
        .doc(currentUserId)
        .set({});
    // Put visited user on sigend user following collection
    followingRef
        .doc(currentUserId)
        .collection('userFollowing')
        .doc(widget.profileId)
        .set({});
    // add activity feed to send notification about new follower
  }

  buildProfileHeader() {
    return FutureBuilder<DocumentSnapshot>(
      future: usersRef.doc(widget.profileId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        AppUser user = AppUser.fromDocument(snapshot.data!);
        return Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 40.0,
                    backgroundColor: Colors.grey,
                    backgroundImage: CachedNetworkImageProvider(user.photoUrl!),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            // buildCountColumn("posts", postCount),

                            buildCountColumn("followers", followerCount),

                            buildCountColumn("following", followingCount),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            buildProfileButton(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 12.0),
                child: Text(
                  user.username!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 2.0),
                child: Text(
                  user.bio!,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  buildProflePosts() {
    if (isLoading) {
      return circularProgress();
    } else if (postToggle == "posts") {
      return Column(
        children: posts,
      );
    } else if (postToggle == "saved") {
      //TODO: Show List of saved work from jam screen (file + image + timestamp + Title)
      return Column(
          // children: posts,
          );
    }
  }

  setToggle(String toggle) {
    setState(() {
      this.postToggle = toggle;
    });
  }

  buildToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.post_add),
                  onPressed: () => setToggle("posts"),
                  color:
                      postToggle == "posts" ? Color(0xFFb71c1c) : Colors.grey,
                ),
                Text(
                  "Posts " + postCount.toString(),
                  style: TextStyle(
                    color:
                        postToggle == "posts" ? Color(0xFFb71c1c) : Colors.grey,
                  ),
                ),
              ],
            )
          ],
        ),
        Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.archive_outlined),
                  color:
                      postToggle == "saved" ? Color(0xFFb71c1c) : Colors.grey,
                  onPressed: () => setToggle("saved"),
                ),
                Text(
                  "Saved " + savedCount.toString(),
                  style: TextStyle(
                    color:
                        postToggle == "saved" ? Color(0xFFb71c1c) : Colors.grey,
                  ),
                ),
              ],
            )
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titleText: "Profile"),
      body: ListView(
        children: <Widget>[
          buildProfileHeader(),
          Divider(),
          buildToggle(),
          Divider(
            height: 0.0,
          ),
          buildProflePosts(),
        ],
      ),
      bottomNavigationBar: bottomBar(context, isHome: false, user: _user),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => CreateJamScreen()),
            );
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
