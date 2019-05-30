import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String username = '';

  Future<FirebaseUser> currentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  userId(FirebaseUser currentuser) async{
    DocumentSnapshot value = await Firestore.instance.collection('users').document(currentuser.uid).get();
    username = value['username'];
    print('username is : ' + username);
    return username;
  }

  Future<void> signOut() async{
    _firebaseAuth.signOut();
  }

  updateProfilePic(picUrl) {
    var userInfo = UserUpdateInfo();
    userInfo.photoUrl = picUrl;
    Auth().currentUser().then((user) {
      user.updateProfile(userInfo);
      Firestore.instance.collection('users').document(user.uid).updateData({'photoURL' : picUrl }).then((value) {
        print('Updated');
      });
    });
    return picUrl;
  }
}