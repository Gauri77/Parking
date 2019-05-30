import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'auth.dart';

class CreateUserProfile extends StatefulWidget {
  CreateUserProfile({Key key}) : super(key: key);
  @override
  _CreateUserProfileState createState() => _CreateUserProfileState();
}

class _CreateUserProfileState extends State<CreateUserProfile> {
  final GlobalKey<FormState>  _formKey = GlobalKey<FormState>();
  bool _autoValidate = true;
  String _userId;
  Stream<QuerySnapshot> _userStream;
  List<DocumentSnapshot> _documents;
  int _docLen;
  
  @override
  void initState() {
    super.initState();
    _userStream = Firestore.instance.collection('/users').snapshots();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        actions: <Widget>[
          OutlineButton(
                borderSide: BorderSide(
                  color: Colors.red, style: BorderStyle.solid, width: 3.0
                ),
                child: Text('Logout'),
                onPressed: () {
                  //FirebaseUser user = await FirebaseAuth.instance.currentUser();
                  FirebaseAuth.instance.signOut().then((value){
                  Navigator.pushReplacementNamed(context, '/');
                });},
              ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _userStream,
        builder: (context, snapshot){
          return Container(
          padding: EdgeInsets.all(15.0),
          child: Center(
            child: Form(
              key: _formKey,
              autovalidate: _autoValidate,
              child:  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Please provide a user id first.', style: TextStyle(
                  fontSize: 25.0
                ),),
                SizedBox(height: 25.0),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'User id',
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide()
                      )
                    ),
                    validator: (value){
                      if(value.length < 4) {
                        return 'Username must contain at least 4 characters';
                        } 
                      else {try {
                        _documents = snapshot.data.documents;
                        _docLen = _documents.length;
                        print('checking available snapshot');
                        for(int i=0; i<_docLen; i++){
                          if(value == _documents[i]['username']){
                            print(_documents[i]['username'] + ' is registered');
                            return 'User is already registered, try another one!';
                            }
                        }
                        print('returning null');
                        return null;
                      } catch(e) {
                        print(e);
                      }}
                      
                    },
                    onSaved: (String value) {
                      _userId = value;
                    },
                    style: TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),
                ),
              IconButton(
                icon: Icon(Icons.arrow_forward, color: Colors.amber, size: 40.0,),
                onPressed: (){
                  if(_validateInput()) {
                   _addNewUser();
                  }
                },

              ),
              
            ],
          ),
        ),
      ),
    );
        },
      )
      
      
      
    );
  }

  _validateInput() {
    if(_formKey.currentState.validate()) {
      _formKey.currentState.save();
      return true;
    }
    else {
      setState(() {
        _autoValidate = true;
      });
      //return false;
    }
  }


  FirebaseUser user;
  Auth auth = Auth();
  String _phNo;

  _addNewUser() async{
    user = await auth.currentUser();
    _phNo = user.phoneNumber;
      print('Got phone number');
      try {
        await Firestore.instance.collection('/users').document(user.uid).setData(
          {
            'username': _userId,
            'ph_no' : _phNo,
          }
        );
        Navigator.of(context).pushReplacementNamed('/homepage');
      } catch(e) {
        print(e);
      }
  }
}