import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:progressions/widgets/login/google_sign_in_button.dart';
import 'package:progressions/widgets/pages/timeline.dart';
import 'package:progressions/widgets/pages/user_profile.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as Im;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progressions/models/ScaleSelection.dart';
import 'package:progressions/models/jam/Jam.dart';
import 'package:progressions/providers/BarsCountSelection.dart';
import 'package:progressions/providers/ChordProgressionSelection.dart';
import 'package:progressions/providers/JamShareStateNotifier.dart';
import 'package:progressions/widgets/pages/upload.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../StyledTitleText.dart';

class SaveJamButton extends StatefulWidget {
  SaveJamButton(
      {Key? key,
      required User user,
      required ScreenshotController screenshotController})
      : _user = user,
        _screenshotController = screenshotController,
        super(key: key);
  final User _user;
  final _screenshotController;
  @override
  _SaveJamButtonState createState() => _SaveJamButtonState();
}

class _SaveJamButtonState extends State<SaveJamButton> {
  bool isSaving = false;
  String sevedId = Uuid().v4();
  late String postId;
  late ScreenshotController screenshotController;
  late User _user;

  @override
  void initState() {
    _user = widget._user;
    screenshotController = widget._screenshotController;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final shareStateProvider = Provider.of<JamShareStateNotifier>(context);
    final barCountProvider = Provider.of<BarsCountSelection>(context);
    final selectedScaleProvider = Provider.of<SelectedScaleNotifier>(context);
    final chordProgProvider = Provider.of<ChordProgressionSelection>(context);

    postId = shareStateProvider.share ? Uuid().v4() : "";

    Widget button = selectShareByState(context, shareStateProvider,
        barCountProvider, selectedScaleProvider, chordProgProvider);
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child:
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [button]),
    );
  }

  Widget selectShareByState(
      BuildContext context,
      JamShareStateNotifier shareStateProvider,
      BarsCountSelection barCountProvider,
      SelectedScaleNotifier selectedScaleProvider,
      ChordProgressionSelection chordProgProvider) {
    return FloatingActionButton.extended(
        backgroundColor: Colors.blueAccent.shade400,
        onPressed: () async {
          //ready to be json
          Jam jam = buildData(
              barCountProvider, selectedScaleProvider, chordProgProvider);

          if (shareStateProvider.share) {
            // save & share a post
            // File? fileImg = await _takeScreenshot();
            // _uploadPost(fileImg);
            handleSave_Share(jam);
          } else {
            handleSubmit(jam);
          }
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Saving.."),
          ));
          // print(jam);
        },
        label: isSaving
            ? SizedBox(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.yellow.shade700),
                  strokeWidth: 3,
                ),
                width: 24,
                height: 24,
              )
            : shareStateProvider.share
                ? StyledText("Share & Save", TextStyle())
                : StyledText("Save!", TextStyle()));
  }

  Jam buildData(
      BarsCountSelection barCountProvider,
      SelectedScaleNotifier selectedScaleProvider,
      ChordProgressionSelection chordProgProvider) {
    return Jam(
        barCountProvider.barsCount,
        selectedScaleProvider.selectedKey.index,
        selectedScaleProvider.selectedMode!.type.index,
        chordProgProvider.chordsSelection);
  }

  _takeScreenshot() async {
    Uint8List? imageFile = await screenshotController.capture();

    final tempDir = await getTemporaryDirectory();

    File? fileImg =
        await new File('${tempDir.path}/image${imageFile!.hashCode}.jpg')
            .create();

    fileImg.writeAsBytesSync(imageFile);
    return fileImg;
  }

  _uploadPost(File? fileImg, String? mediaUrl) async {
    // Upload
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
          builder: (context) => Upload(
                file: fileImg,
                user: _user,
                postId: postId,
                mediaUrl: mediaUrl,
              )),
    );
    setState(() {
      // file = null;
      isSaving = false;

      // postId = " ";
      sevedId = Uuid().v4();
    });
  }
  // compressImage(imgFile) async {
  //   final tempDir = await getTemporaryDirectory();
  //   final path = tempDir.path;
  //   Im.Image imageFile = Im.decodeImage(imgFile!.readAsBytesSync())!;
  //   final compressedImageFile = File('$path/img_$postId.jpg')
  //     ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));

  // }

  //save iamge in firestorage in frebase
  Future<String> uploadImageScreenShot(File? fileImg) async {
    final tempDir1 = await getTemporaryDirectory();
    final path = tempDir1.path;
    Im.Image imageFile1 = Im.decodeImage(fileImg!.readAsBytesSync())!;
    final compressedImageFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile1, quality: 85));

    UploadTask uploadTask =
        storageRef.child("post_$postId.jpg").putFile(compressedImageFile);

    String downloadUrl = await (await uploadTask).ref.getDownloadURL();
    return downloadUrl;
  }

  //save file in firestorage in frebase
  Future<String> uploadFile(jsonFile) async {
    UploadTask uploadTask =
        storageRef.child("saved_$sevedId.json").putFile(jsonFile);

    String downloadUrl = await (await uploadTask).ref.getDownloadURL();
    return downloadUrl;
  }

  createSavedInFirestore(
      {String? mediaUrl, String? fileUrl, String? description}) {
    savedRef.doc(_user.uid).collection("userSaved").doc(sevedId).set({
      "sevedId": sevedId,
      "ownerId": _user.uid,
      "username": _user.displayName,
      "postId": postId,
      "fileUrl": fileUrl,
      "mediaUrl": mediaUrl,
      "description": description,
      "timestamp": timestamp,
    });
  }

  handleSubmit(Jam jam) async {
    setState(() {
      isSaving = true;
    });
    final tempDir = await getTemporaryDirectory();

    File? file =
        await new File('${tempDir.path}/jam${jam.hashCode}.json').create();

    file.writeAsString(jam.toString());
    String fileUrl = await uploadFile(file);

    File? fileImg = await _takeScreenshot();

    String mediaUrl = await uploadImageScreenShot(fileImg);
    createSavedInFirestore(
        mediaUrl: mediaUrl, fileUrl: fileUrl, description: '');
    // captionController.clear();
    setState(() {
      file = null;
      isSaving = false;
      postId = " ";
      sevedId = Uuid().v4();
    });
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => Timeline(
              user: _user,
            )));
  }

  handleSave_Share(Jam jam) async {
    setState(() {
      isSaving = true;
    });
    final tempDir = await getTemporaryDirectory();

    File? file =
        await new File('${tempDir.path}/jam${jam.hashCode}.json').create();

    file.writeAsString(jam.toString());
    String fileUrl = await uploadFile(file);
    File? fileImg = await _takeScreenshot();

    String mediaUrl = await uploadImageScreenShot(fileImg);

    createSavedInFirestore(
        mediaUrl: mediaUrl, fileUrl: fileUrl, description: '');
    // captionController.clear();

    setState(() {
      file = null;
      isSaving = false;
      // postId = " ";
      sevedId = Uuid().v4();
    });

    await _uploadPost(fileImg, mediaUrl);
    // Navigator.of(context).pushReplacement(MaterialPageRoute(
    //     builder: (context) => Timeline(
    //           user: _user,
    //         )));
  }
}
