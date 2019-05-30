import 'package:flutter/material.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  String _phoneNo;
  String _smsCode;
  String _verificationId;
  FirebaseUser _firebaseUser;
  @override
  void initState(){
    super.initState();
    FirebaseAuth.instance.currentUser().then((user){
      if(user!=null){
        Navigator.of(context).pushReplacementNamed('/homepage');
      }
    });
  }

  Future<void> verifyPhone() async{
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId){
      this._verificationId = verId;
      print('auto retireval called');
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]){
      this._verificationId = verId;
      print('code sent');
      smsCodeDialog(context).then((value){
        print('Signed In');
      });

    };
    final  PhoneVerificationCompleted verified = (AuthCredential credential) async{
      _firebaseUser =  await FirebaseAuth.instance.signInWithCredential(credential);
      print('verified user : ${_firebaseUser.phoneNumber}');
      Navigator.of(context).pushReplacementNamed('/homepage');
    };

  

    final PhoneVerificationFailed failed = (AuthException exception){
      print('${exception.message}');
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: this._phoneNo,
      codeAutoRetrievalTimeout: autoRetrieve,
      codeSent: smsCodeSent,
      timeout: const Duration(seconds: 30),
      verificationCompleted: verified,
      verificationFailed: failed,

    );
  }

  Future<bool> smsCodeDialog(BuildContext context){
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Enter sms code'),
          content: TextField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(3.0)
            ),
            onChanged: (value){
              this._smsCode = value;
            },
          ),
          contentPadding: EdgeInsets.all(10.0),
          actions: <Widget>[
            FlatButton(
              child: Text('Next'),
              onPressed: (){
                FirebaseAuth.instance.currentUser().then((user){
                  Navigator.of(context).pop();
                  if(user != null){
                    Navigator.of(context).pushReplacementNamed('/homepage');
                  }
                  else{
                    signInManually();
                  }
                });
              },
            )
          ],
        );
      }
    );
  }

  signInManually(){
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: _verificationId,
      smsCode: _smsCode,
    );
    FirebaseAuth.instance.signInWithCredential(credential)
    .then((user){
      this._verificationId = null;
      this._smsCode = null;
      Navigator.of(context).pushReplacementNamed('/homepage');
    }).catchError((e){
      print('e');
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alpha'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(hintText: 'Enter phone number'),
                onChanged: (value){
                  this._phoneNo = value;
                },
              ),
              SizedBox(height: 10.0,),
              RaisedButton(
                onPressed: verifyPhone,
                child: Text('Sign In'),
                textColor: Colors.white,
                elevation: 7.0,
                color: Colors.amber,
              )
            ],
          ),
        ),
      ),
    );
  }
}