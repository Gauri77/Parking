import 'dart:io';
import 'package:alpha/auth.dart';
import 'package:alpha/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ShowImage extends StatefulWidget {
  final File pickedImage;
  final FirebaseUser currentuser;
  ShowImage({this.pickedImage, this.currentuser});

  @override
  _ShowImageState createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {
  @override
  Widget build(BuildContext context) {
    return Material(
          child: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.file(widget.pickedImage, fit: BoxFit.cover,)
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 11 / 12,
            child: Column(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    _saveImageToStorage();

                  },
                  splashColor: Colors.white,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.transparent.withOpacity(0.7),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.done, size: 35.0, color: Colors.white,),
                        SizedBox(width: 20.0,),
                        Text('Done', style: TextStyle(color: Colors.white, fontSize: 20.0),),
                      ],
                    ),
                  )
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
  _saveImageToStorage() {
    final StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child('${widget.currentuser.uid}.jpg');
    final StorageUploadTask task = firebaseStorageRef.putFile(widget.pickedImage);
    task.onComplete.then((value) {
      print('task completed');
      value.ref.getDownloadURL().then((url) {
        print('got download url');
        Auth().updateProfilePic(url);
          print('navigating to homepage');
          Navigator.of(context).pop();
          print('passing arg');
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomePage(passedIndex: 1,)));
      });
      
    }).catchError((e){
      print(e);
    });
  }
}