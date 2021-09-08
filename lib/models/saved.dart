import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progressions/widgets/common/custom_image.dart';
import 'package:http/http.dart' as http;
import 'package:progressions/widgets/jam/CreateJamScreen.dart';
import 'package:progressions/widgets/login/google_sign_in_button.dart';

class Saved extends StatelessWidget {
  final String savedId;
  final String postId;
  final String ownerId;
  final String? photoUrl;
  final String? fileUrl;
  final String? timestamp;
  static User? user;

  Saved(
      {required this.savedId,
      required this.postId,
      required this.ownerId,
      this.photoUrl,
      this.fileUrl,
      this.timestamp});

  factory Saved.fromDocument(DocumentSnapshot doc) {
    return Saved(
        savedId: doc['sevedId'],
        postId: doc['postId'],
        ownerId: doc['ownerId'],
        photoUrl: doc['mediaUrl'],
        fileUrl: doc['fileUrl'],
        // DateTime.parse(timestamp.toDate().toString())
        timestamp:
            DateTime.parse(doc['timestamp'].toDate().toString()).toString());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Dismissible(
          child: ListTile(
            // focusColor: Color(0xFFb71c1c),
            minVerticalPadding: 30,
            subtitle: Text(' '),
            title: Text(' ' + timestamp!),
            // trailing: Icon(Icons.delete_forever),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10.0), //or 15.0

              child: Container(
                height: 90.0,
                width: 120.0,
                child: cachedNetworkImage(this.photoUrl!),
              ),
            ),
            onTap: () async {
              // print(ownerId);
              var jsonData = await downloadFile(savedId);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) =>
                        CreateJamScreen(user: user!, data: jsonData)),
              );
            },
          ),
          key: UniqueKey(),
          background: Container(
            color: Colors.red,
            margin: EdgeInsets.symmetric(horizontal: 15),
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.delete,
              size: 40,
              color: Colors.white,
            ),
          ),
          onDismissed: (_) {
            handleDeleteSaved(context);
          },
        ),
        decoration:
            new BoxDecoration(border: new Border(bottom: new BorderSide())));
  }

  handleDeleteSaved(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Remove this Saved?"),
            children: <Widget>[
              SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context);
                    deleteSaved();
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

  deleteSaved() async {
    // delete saved itself
    savedRef
        .doc(ownerId)
        .collection('userSaved')
        .doc(savedId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    storageRef.child("saved_$savedId.json").delete();
  }

//     Future<void> downloadFile(String url) async {
//     final http.Response downloadData = await http.get(url);
//     final Directory systemTempDir = Directory.systemTemp;
//     final File tempFile = File('${systemTempDir.path}/tmp.jpg');
//     if (tempFile.existsSync()) {
//       await tempFile.delete();
//     }
//     await tempFile.create();
//     final StorageFileDownloadTask task = ref.writeToFile(tempFile);
//     final int byteCount = (await task.future).totalByteCount;
//     var bodyBytes = downloadData.bodyBytes;
//     final String name = await ref.getName();
//     final String path = await ref.getPath();
//     print(url);
//     _scaffoldKey.currentState.showSnackBar(
//       SnackBar(
//         backgroundColor: Colors.white,
//         content: Image.memory(
//           bodyBytes,
//           fit: BoxFit.fill,
//         ),
//       ),
//     );
//   }
// }
  Future<Map<String, dynamic>> downloadFile(String savedId) async {
    Reference ref = storageRef.child("saved_$savedId.json");
    final String url = await ref.getDownloadURL();
    var uri = Uri.parse(url);
    final http.Response downloadData = await http.get(uri);
    // final Directory systemTempDir = Directory.systemTemp;
    final tempDir = await getTemporaryDirectory();

    final File tempFile =
        await new File('${tempDir.path}/saved$savedId.json').create();

    if (tempFile.existsSync()) {
      await tempFile.delete();
    }
    await tempFile.create();
    final DownloadTask task = ref.writeToFile(tempFile);
    final int byteCount = (await task).bytesTransferred;
    var bodyBytes = downloadData.bodyBytes;

    final contents = await tempFile.readAsString();
    Map<String, dynamic> jsonData = json.decode(contents);
    // jsonData.
    // print(
    //   'Success!\nDownloaded json:{ $jsonData \n }Url: $url'
    //   ' \nBytes Count :: $byteCount',
    // );
    return jsonData;
  }
}
