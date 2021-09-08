import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:progressions/models/user.dart';
import 'package:progressions/widgets/common/progress.dart';
import 'package:progressions/widgets/login/google_sign_in_button.dart';
import 'package:progressions/widgets/common/custom_image.dart';
import 'package:progressions/widgets/pages/timeline.dart';

class Post extends StatefulWidget {
  final String postId;
  final String ownerId;
  final String username;
  final String description;
  final String mediaUrl;
  final dynamic? likes;

  Post({
    required this.postId,
    required this.ownerId,
    required this.username,
    required this.description,
    required this.mediaUrl,
    this.likes,
  });

  factory Post.fromDocument(DocumentSnapshot doc) {
    return Post(
      postId: doc['postId'],
      ownerId: doc['ownerId'],
      username: doc['username'],
      description: doc['description'],
      mediaUrl: doc['mediaUrl'],
      likes: doc['likes'],
    );
  }

  int getLikeCount(likes) {
    // if no likes, return 0
    if (likes == null) {
      return 0;
    }
    int count = 0;
    // if the key is explicitly set to true, add a like
    likes.values.forEach((val) {
      if (val == true) {
        count += 1;
      }
    });
    return count;
  }

  @override
  _PostState createState() => _PostState(
        postId: this.postId,
        ownerId: this.ownerId,
        username: this.username,
        description: this.description,
        mediaUrl: this.mediaUrl,
        likes: this.likes,
        likeCount: getLikeCount(this.likes),
      );
}

class _PostState extends State<Post> {
  final String currentUserId = currentUser!.id;
  final String postId;
  final String ownerId;
  final String username;
  final String description;
  final String mediaUrl;
  int likeCount;
  Map? likes;
  bool? isLiked;

  _PostState({
    required this.postId,
    required this.ownerId,
    required this.username,
    required this.description,
    required this.mediaUrl,
    this.likes,
    required this.likeCount,
  });

  buildPostHeader() {
    return FutureBuilder<DocumentSnapshot>(
        future: usersRef.doc(ownerId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          AppUser user = AppUser.fromDocument(snapshot.data!);
          bool isPostOwner = currentUserId == ownerId;
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(user.photoUrl!),
              backgroundColor: Colors.grey,
            ),
            title: GestureDetector(
              onTap: () => print('showing profile'),
              child: Text(
                user.username!,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            trailing: isPostOwner
                ? IconButton(
                    onPressed: () => handleDeletePost(context),
                    icon: Icon(Icons.more_vert),
                  )
                : Text(''),
          );
        });
  }

  handleDeletePost(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Remove this post?"),
            children: <Widget>[
              SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context);
                    deletePost();
                  },
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  )),
              SimpleDialogOption(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel')),
            ],
          );
        });
  }

  deletePost() async {
    // delete post itself
    postsRef.doc(ownerId).collection('userPosts').doc(postId).get().then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    storageRef.child("post_$postId.jpg").delete();
  }

  //TODO Complete method to send to owner notifaction and wait for respond
  // handleRequestPost(BuildContext parentContext) {
  //   return ScaffoldMessenger.of(parentContext).showSnackBar(SnackBar(
  //     content: Text("request to save sent !"),
  //   ));
  // }
  addLikeToActivityFeed() {
    // add a notification to the postOwner's activity feed only if comment made by OTHER user (to avoid getting notification for our own like)
    bool isNotPostOwner = currentUserId != ownerId;

    if (isNotPostOwner) {
      activityFeedRef.doc(ownerId).collection("feedItems").doc(postId).set({
        "type": "like",
        "username": currentUser!.username,
        "userId": currentUserId,
        "userProfileImg": currentUser!.photoUrl,
        "postId": postId,
        "mediaUrl": mediaUrl,
        "timestamp": timestamp,
      });
    }
  }

  removeLikeFromActivityFeed() {
    bool isNotPostOwner = currentUserId != ownerId;
    if (isNotPostOwner) {
      activityFeedRef
          .doc(ownerId)
          .collection("feedItems")
          .doc(postId)
          .get()
          .then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });
    }
  }

  buildPostImage() {
    return GestureDetector(
      onDoubleTap: () => {
        if (likes!.containsKey(currentUserId))
          {
            if (likes![currentUserId] == true)
              {
                // print("DISLiked"),
                postsRef
                    .doc(ownerId)
                    .collection('userPosts')
                    .doc(postId)
                    .update({'likes.$currentUserId': false}),
                removeLikeFromActivityFeed(),
                setState(() {
                  likeCount -= 1;
                  isLiked = false;
                  likes![currentUserId] = false;
                }),
              }
            else if (likes![currentUserId] == false)
              {
                // print("Liked"),
                postsRef
                    .doc(ownerId)
                    .collection('userPosts')
                    .doc(postId)
                    .update({'likes.$currentUserId': true}),
                addLikeToActivityFeed(),
                setState(() {
                  likeCount += 1;
                  isLiked = true;
                  likes![currentUserId] = true;
                }),
              }
          }
        else
          {
            // postsRef.doc(ownerId).collection('userPosts').doc(postId).update({
            //   "likes": likes
            // }),
            setState(() {
              likeCount += 1;
              isLiked = true;
              likes![currentUserId] = true;
              postsRef
                  .doc(ownerId)
                  .collection('userPosts')
                  .doc(postId)
                  .update({"likes": likes});
            }),
          }
      },
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // Image.network(mediaUrl),
          cachedNetworkImage(mediaUrl),
        ],
      ),
    );
  }

  buildPostFooter() {
    bool isPostOwner = currentUserId == ownerId;

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 40.0, left: 20.0)),
            GestureDetector(
              onTap: () => {
                if (likes!.containsKey(currentUserId))
                  {
                    if (likes![currentUserId] == true)
                      {
                        // print("DISLiked"),
                        postsRef
                            .doc(ownerId)
                            .collection('userPosts')
                            .doc(postId)
                            .update({'likes.$currentUserId': false}),
                        removeLikeFromActivityFeed(),

                        setState(() {
                          likeCount -= 1;
                          isLiked = false;
                          likes![currentUserId] = false;
                        }),
                      }
                    else if (likes![currentUserId] == false)
                      {
                        // print("Liked"),
                        postsRef
                            .doc(ownerId)
                            .collection('userPosts')
                            .doc(postId)
                            .update({'likes.$currentUserId': true}),
                        addLikeToActivityFeed(),

                        setState(() {
                          likeCount += 1;
                          isLiked = true;
                          likes![currentUserId] = true;
                        }),
                      }
                  }
                else
                  {
                    // postsRef.doc(ownerId).collection('userPosts').doc(postId).update({
                    //   "likes": likes
                    // }),
                    setState(() {
                      likeCount += 1;
                      isLiked = true;
                      likes![currentUserId] = true;
                      postsRef
                          .doc(ownerId)
                          .collection('userPosts')
                          .doc(postId)
                          .update({"likes": likes});
                    }),
                  }
              },
              child: Icon(
                isLiked! ? Icons.thumb_up : Icons.thumb_up_outlined,
                size: 28.0,
                color: Colors.blue,
              ),
            ),
            Padding(padding: EdgeInsets.only(right: 20.0)),
            GestureDetector(
              onTap: () => {
                //TODO : to complete the func of request to save post
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text("request to save sent !"),
                ))
              },
              child: isPostOwner
                  ? Text("")
                  : Icon(
                      Icons.save_alt,
                      size: 28.0,
                      color: Colors.blue,
                    ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text(
                "$likeCount likes",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text(
                "$username ",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(child: Text(description))
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    isLiked = (likes![currentUserId] == true);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Divider(),
        buildPostHeader(),
        buildPostImage(),
        buildPostFooter(),
        Divider()
      ],
    );
  }
}
