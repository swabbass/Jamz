// import 'dart:io';
// import 'dart:typed_data';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:progressions/widgets/login/google_sign_in_button.dart';
// import 'package:progressions/widgets/pages/user_profile.dart';
// import 'package:uuid/uuid.dart';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:progressions/models/ScaleSelection.dart';
// import 'package:progressions/models/ShareState.dart';
// import 'package:progressions/models/jam/Jam.dart';
// import 'package:progressions/providers/BarsCountSelection.dart';
// import 'package:progressions/providers/ChordProgressionSelection.dart';
// import 'package:progressions/providers/JamShareStateNotifier.dart';
// import 'package:progressions/widgets/pages/upload.dart';
// import 'package:provider/provider.dart';
// import 'package:screenshot/screenshot.dart';

// import '../StyledTitleText.dart';

// class ShareJamButton extends StatelessWidget {
//   ShareJamButton(
//       {Key? key,
//       required User user,
//       required ScreenshotController screenshotController})
//       : _user = user,
//         _screenshotController = screenshotController,
//         super(key: key);
//   final User _user;
//   final _screenshotController;

//   bool isSaving = false;
//   String sevedId = Uuid().v4();
//   String postId = Uuid().v4();

//   // TextEditingController captionController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final shareStateProvider = Provider.of<JamShareStateNotifier>(context);
//     final barCountProvider = Provider.of<BarsCountSelection>(context);
//     final selectedScaleProvider = Provider.of<SelectedScaleNotifier>(context);
//     final chordProgProvider = Provider.of<ChordProgressionSelection>(context);
//     postId = shareStateProvider.share ? Uuid().v4() : "";
//     Widget button = selectShareByState(context, shareStateProvider,
//         barCountProvider, selectedScaleProvider, chordProgProvider);
//     return Padding(
//       padding: const EdgeInsets.only(top: 32),
//       child:
//           Row(mainAxisAlignment: MainAxisAlignment.center, children: [button]),
//     );
//   }

//   Widget selectShareByState(
//       BuildContext context,
//       JamShareStateNotifier shareStateProvider,
//       BarsCountSelection barCountProvider,
//       SelectedScaleNotifier selectedScaleProvider,
//       ChordProgressionSelection chordProgProvider) {
//     switch (shareStateProvider.shareState) {
//       case ShareState.ERROR:
//         return FloatingActionButton.extended(
//             backgroundColor: Colors.redAccent.shade400,
//             onPressed: () {
//               // Future.delayed(Duration(seconds: 5),
//               //     () => {shareStateProvider.shareState = ShareState.DONE});
//               shareStateProvider.shareState = ShareState.UPLOADING;
//             },
//             label: Icon(
//               Icons.refresh,
//               color: Colors.white,
//               size: 24,
//             ));
//       case ShareState.UPLOADING:
//         isSaving
//             ? shareStateProvider.shareState = ShareState.UPLOADING
//             // :  handleSubmit(jam, context);
//             : shareStateProvider.shareState = ShareState.DONE;
//         return FloatingActionButton.extended(
//             backgroundColor: Colors.deepPurple.shade400,
//             onPressed: () => null,
//             label: SizedBox(
//               child: CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation(Colors.yellow.shade700),
//                 strokeWidth: 3,
//               ),
//               width: 24,
//               height: 24,
//             )
//             );
//       case ShareState.DONE:
//         return FloatingActionButton.extended(
//             backgroundColor: Colors.greenAccent.shade400,
//             onPressed: () => null,
//             label: StyledText("Done!", TextStyle()));
//       case ShareState.INITAL:
//       default:
//         return FloatingActionButton.extended(
//             backgroundColor: Colors.blueAccent.shade400,
//             onPressed: () {
//               // if (shareStateProvider.share) {
//               //   // save & share a post
//               //   _takeScreenshot(context);
//               // } else {
//               //   isSaving ? shareStateProvider.shareState = ShareState.UPLOADING : () => handleSubmit()
//               // }

//               //ready to be json
//               Jam jam = buildData(
//                   barCountProvider, selectedScaleProvider, chordProgProvider);
//               // Future.delayed(Duration(seconds: 5),
//               //     () => {shareStateProvider.shareState = ShareState.ERROR});
//               // shareStateProvider.shareState = ShareState.UPLOADING;
//               //sync share with backend/firebase..call application state to update its sections
//               //see https://firebase.google.com/codelabs/firebase-get-to-know-flutter#5
//               if (shareStateProvider.share) {
//                 // save & share a post
//                 uploadPost(context, _takeScreenshot());
//                 // _takeScreenshot();
//               } else {
//                 handleSubmit(jam, context);
//                 isSaving
//                     ? shareStateProvider.shareState = ShareState.UPLOADING
//                     // :  handleSubmit(jam, context);
//                     : shareStateProvider.shareState = ShareState.DONE;
//               }
//               ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                 content: Text("Sending Message $jam"),
//               ));
//               print(jam);
//             },
//             label: StyledText("Save", TextStyle()));
//     }
//   }

//   Jam buildData(
//       BarsCountSelection barCountProvider,
//       SelectedScaleNotifier selectedScaleProvider,
//       ChordProgressionSelection chordProgProvider) {
//     return Jam(
//         barCountProvider.barsCount,
//         selectedScaleProvider.selectedKey.index,
//         selectedScaleProvider.selectedMode!.type.index,
//         chordProgProvider.chordsSelection);
//   }

//   _takeScreenshot() async {
//     Uint8List? imageFile = await _screenshotController.capture();

//     final tempDir = await getTemporaryDirectory();

//     File? fileImg =
//         await new File('${tempDir.path}/image${imageFile!.hashCode}.jpg')
//             .create();

//     fileImg.writeAsBytesSync(imageFile);
//     return fileImg;
//     // print(file);

//     // Upload
//     // Navigator.of(context).pushReplacement(
//     //   MaterialPageRoute(
//     //       builder: (context) => Upload(
//     //             file: file,
//     //             user: _user,
//     //             postId: postId,
//     //           )),
//     // );
//   }

//   uploadPost(context, file) {
//     Navigator.of(context).pushReplacement(
//       MaterialPageRoute(
//           builder: (context) => Upload(
//                 file: file,
//                 user: _user,
//                 postId: postId,
//               )),
//     );
//   }

//   //save file in firestorage in frebase
//   Future<String> uploadFile(jsonFile) async {
//     UploadTask uploadTask =
//         storageRef.child("saved_$sevedId.json").putFile(jsonFile);

//     String downloadUrl = await (await uploadTask).ref.getDownloadURL();
//     return downloadUrl;
//   }

//   createSavedInFirestore({String? fileUrl, String? description}) {
//     savedRef.doc(_user.uid).collection("userSaved").doc(sevedId).set({
//       "sevedId": sevedId,
//       "ownerId": _user.uid,
//       "username": _user.displayName,
//       "postId": postId,
//       "fileUrl": fileUrl,
//       "description": description,
//       "timestamp": timestamp,
//     });
//   }

//   handleSubmit(Jam jam, context) async {
//     isSaving = true;
//     final tempDir = await getTemporaryDirectory();

//     File? file =
//         await new File('${tempDir.path}/jam${jam.hashCode}.json').create();

//     file.writeAsString(jam.toString());
//     String fileUrl = await uploadFile(file);
//     createSavedInFirestore(fileUrl: fileUrl, description: '');
//     // captionController.clear();
//     // setState(() {
//     file = null;
//     isSaving = false;
//     postId = Uuid().v4();
//     sevedId = Uuid().v4();
//     // Navigator.of(context).pushReplacement(MaterialPageRoute(
//     //     builder: (context) => UserProfile(
//     //           user: _user,
//     //         )));
//     // });
//   }
// }
