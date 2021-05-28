import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progressions/widgets/common/progress.dart';
import 'package:progressions/widgets/login/google_sign_in_button.dart';
import 'package:progressions/widgets/pages/test_for_screenshot.dart';
import 'package:image/image.dart' as Im;
import 'package:uuid/uuid.dart';

class Upload extends StatefulWidget {
  Upload({Key? key, required User user, File? file})
      : _user = user,
        _file = file,
        super(key: key);

  final User _user;
  File? _file;

  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  TextEditingController captionController = TextEditingController();

  late User _user;
  File? _file;
  bool isUploading = false;
  String postId = Uuid().v4();

  @override
  void initState() {
    _user = widget._user;
    _file = widget._file;
    super.initState();
  }

  clearImage() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => TestForScreenshot(
              user: _user,
            )));
  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(_file!.readAsBytesSync())!;
    final compressedImageFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
    setState(() {
      _file = compressedImageFile;
    });
  }

  Future<String> uploadImage(imageFile) async {
    UploadTask uploadTask =
        storageRef.child("post_$postId.jpg").putFile(imageFile);

    String downloadUrl = await (await uploadTask).ref.getDownloadURL();
    return downloadUrl;
  }

  createPostInFirestore({String? mediaUrl, String? description}) {
    postsRef.doc(widget._user.uid).collection("userPosts").doc(postId).set({
      "postId": postId,
      "ownerId": widget._user.uid,
      "username": widget._user.displayName,
      "mediaUrl": mediaUrl,
      "description": description,
      "timestamp": timestamp,
      "likes": {},
    });
  }

  handleSubmit() async {
    setState(() {
      isUploading = true;
    });
    await compressImage();
    String mediaUrl = await uploadImage(_file);
    createPostInFirestore(
      mediaUrl: mediaUrl,
      description: captionController.text,
    );
    captionController.clear();
    setState(() {
      //   file = null;
      isUploading = false;
      postId = Uuid().v4();
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => TestForScreenshot(
                user: _user,
              )));
    });
  }

  Scaffold buildUploadForm() {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: clearImage),
        title: Text(
          "Caption Post",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: isUploading ? null : () => handleSubmit(),
            child: Text(
              "Post",
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          isUploading ? linearProgress() : Text(""),
          Padding(
            padding: EdgeInsets.only(top: 30.0),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(_user.photoURL!),
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                controller: captionController,
                decoration: InputDecoration(
                  hintText: "Write a caption...",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.only(top: 10.0),
          // ),
          Container(
            height: 220.0,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 8,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(_file!),
                    ),
                  ),
                ),
              ),
            ),
          ),

          Divider(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildUploadForm();
  }
}
