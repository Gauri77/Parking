import 'dart:io';

import 'package:alpha/auth.dart';
import 'package:alpha/mybookings.dart';
import 'package:alpha/showimage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:location/location.dart';
import 'map.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:flutter/services.dart';
//import 'staticmap.dart';

class HomePage extends StatefulWidget {
  num passedIndex;
  HomePage({this.passedIndex});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username;
  var location = Location();
  LocationData userLocation;
  FirebaseUser currentuser;
  String profilepicURL;
  
  @override
  void initState() {
    //this.username = '';
    super.initState();
    _checkForProfile();
      
    }

int _selectedIndex = 0;
final _widgetOptions = [
  'Dashboard', 'Profile'
];

  @override
  Widget build(BuildContext context) {
    
    //HomePage args = ModalRoute.of(context).settings.arguments;
    //print('args index : ${widget.passedIndex}');
    if(widget.passedIndex != null) {
      //print('args index : ${widget.passedIndex}');
      _selectedIndex = widget.passedIndex;
      widget.passedIndex = null;
    }
    
    if(username == null) {
      return Material(child: Container(child: Center(child: CircularProgressIndicator(),)));
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(_widgetOptions[_selectedIndex]),
        centerTitle: true,
        /*actions: <Widget>[
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
        ],*/
      ),
      body: _buildWidget(),
        /*Container(
           padding: EdgeInsets.all(15.0),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('You are now logged in $username'),
              SizedBox(height: 20.0,),
              Center(
                child: Card(
                  elevation: 4.0,
                  child: InkWell(
                    splashColor: Colors.amberAccent,
                    onTap: () {
                      _getLocation().then((value){
                        userLocation = value;
                        print('latitude : ${userLocation.latitude}');
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Maps(userlocation: this.userLocation)));
                      });
                      CircularProgressIndicator();
                      //Navigator.push(context, MaterialPageRoute(builder: (context) => StaticMap()));
                    },
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: const ListTile(
                        subtitle: Text('Get a slot', style: TextStyle(
                          fontSize: 30.0
                          ),
                        ),
                        trailing: Text('Open Map'),
                      ),
                      )
                    ],
                  ),
                  )
                ),
                
              ),
              SizedBox(height: 15.0,),
              Center(
                child: Card(
                  elevation: 4.0,
                  child: InkWell(
                    splashColor: Colors.amberAccent,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MyBooking(user: currentuser)));
                    },
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: const ListTile(
                        subtitle: Text('My Bookings', style: TextStyle(
                          fontSize: 30.0
                          ),
                        ),
                      ),
                      )
                    ],
                  ),
                  )
                ),
                
              ),
            ],
          ),
        ),*/


      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), title: Text('Dashboard'), ),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), title: Text('Profile'), ),
        ],
        currentIndex: _selectedIndex,
        fixedColor: Colors.deepPurple,
        onTap: _onItemTapped,
        ),

    );
  }
  void _onItemTapped(int index){
    setState((){
      print('index set to : $index');
      _selectedIndex = index;
    });
  }

  _buildWidget() {
    var screensize = MediaQuery.of(context).size;
    double fontsize = screensize.width / 12;
    double numfontsize = fontsize + 20.0;
    print(screensize.width);
    if(_widgetOptions[_selectedIndex] == 'Dashboard'){
      return Container(
        
           padding: EdgeInsets.all(15.0),
            child: GridView.count(
                //childAspectRatio: screensize.width/screensize.height,
                crossAxisCount: 2,
                mainAxisSpacing: 10.0,
                //crossAxisSpacing: 10.0,
                
                //shrinkWrap: true,
                children: <Widget>[
                  //Text('You are now logged in $username'),
                  Card(
                    elevation: 4.0,
                    child: InkWell(
                      splashColor: Colors.amberAccent,
                      onTap: () {},
                      child: ListTile(title: Text('0', style: TextStyle(fontSize: numfontsize),),subtitle: Text('Current bookings', style: TextStyle(fontSize: screensize.width / 12),),),
                    ),
                  ),
                  Card(
                    elevation: 4.0,
                    child: InkWell(
                      splashColor: Colors.amberAccent,
                      onTap: () {},
                      child: ListTile(
                        title: Text('0', style: TextStyle(fontSize: numfontsize),),
                        subtitle: Text('Pending bookings', style: TextStyle(fontSize: fontsize),),
                      )
                    ),
                  ),
                  //SizedBox(height: 20.0,),
                  Card(
                    elevation: 4.0,
                    child: InkWell(
                      splashColor: Colors.amberAccent,
                      onTap: () {
                        _getLocation().then((value){
            userLocation = value;
            print('latitude : ${userLocation.latitude}');
            Navigator.push(context, MaterialPageRoute(builder: (context) => Maps(userlocation: this.userLocation)));
                        });
                        CircularProgressIndicator();
                        //Navigator.push(context, MaterialPageRoute(builder: (context) => StaticMap()));
                      },
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(
            child: ListTile(
              title: Icon(Icons.add, size: numfontsize,),
            subtitle: Text('Get a new slot', style: TextStyle(
              fontSize: fontsize
              ),
            ),
            //trailing: Text('Open Map'),
                        ),
                        )
                      ],
                    ),
                    )
                  ),
                  //SizedBox(height: 15.0,),
                  Card(
                    elevation: 4.0,
                    child: InkWell(
                      splashColor: Colors.amberAccent,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MyBooking(user: currentuser)));
                      },
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(
            child: ListTile(
              title: Icon(Icons.remove_red_eye, size: numfontsize),
            subtitle: Text('All Bookings', style: TextStyle(
              fontSize: fontsize
              ),
            ),
                        ),
                        )
                      ],
                    ),
                    )
                  ),
                ],
              ),
          
        );
    }
    if(_widgetOptions[_selectedIndex] == 'Profile') {
      return Stack(
        children: <Widget>[
          ClipPath(
            child: Container(child: Image.asset('assets/parking.jpg', fit: BoxFit.cover, width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height),),
            clipper: GetClipper(),
          ),
          Positioned(
            width: 350.0,
            top: MediaQuery.of(context).size.height / 5,
            child: Column(
              children: <Widget>[
                Container(
                  width: 150.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    image: DecorationImage(
                      image: profilepicURL == null ? AssetImage('assets/defaultuser.jpg') : NetworkImage(profilepicURL),
                      fit: BoxFit.cover
                    ),
                  ),
                ),
                SizedBox(height: 20.0,),
                Container(
                  child: Center(
                    child: Text('Signed in as:', style: TextStyle(fontSize: 16.0)),
                  ),
                ),
                SizedBox(height: 5.0,),
                Container(
                  child: Center(
                    child: Text(username, style: TextStyle(fontSize: 20.0,)),
                  ),
                ),
                SizedBox(height: 20.0,),
                
              ],
            ),
          ),
          Positioned(
            width: 435,
            top: MediaQuery.of(context).size.height / 5 + 107,
            child: Column(
              children: <Widget>[
                Container(
                  width: 50,
                  height: 50,
                  child: RawMaterialButton(
                    fillColor: Colors.amber[200],
                    //color: Colors.amber,
                    shape: CircleBorder(),
                    child: Icon(Icons.add_a_photo, color: Colors.black, size: 30.0,),
                    onPressed: () {
                      _getImage();
                    },
                  ),
                )
              ],
            ),
          ),
          Positioned(
            width: MediaQuery.of(context).size.width,
            top: MediaQuery.of(context).size.height / 1.9,
            child: Column(
              children: <Widget>[
                InkWell(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(),
                          padding: EdgeInsets.all(30.0),
                          //color: Colors.yellow,
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                Text('Phone Number : ', style: TextStyle(fontSize: 16.0,)),
                Text(currentuser.phoneNumber, style: TextStyle(fontSize: 20.0),),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0,),
                    Container(
                      width: 50,
                      height: 50,
                      child: RawMaterialButton(
                        fillColor: Colors.amber[200],
                        //color: Colors.amber,
                        shape: CircleBorder(),
                        child: Icon(Icons.power_settings_new, color: Colors.black, size: 40.0,),
                        onPressed: () {
                          FirebaseAuth.instance.signOut().then((value){
                            Navigator.pushReplacementNamed(context, '/');
                          });
                        }
                      ),
                    ),
              ],
              
            ),
                
          )

        ],
      );
    }
  }

  Future _getImage() async{
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(tempImage != null) {
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>  ShowImage(pickedImage: tempImage, currentuser: currentuser)));
    }
  }



  Future<LocationData> _getLocation() async{
    //var currentLocation = <String, double>{};
    LocationData currentLocation;
    try{
      currentLocation = await location.getLocation();// as Map<String,double>;
     // print('latitude :' + currentLocation['latitude'].toString());
      //print('longitude :' + currentLocation['longitude'].toString());
     /* currentLocation.then((onValue){
        print(onValue.latitude.toString() + ' ' + onValue.longitude.toString());
      });*/
    } catch(e){
      print(e);
      currentLocation = null;
    }
    if(currentLocation != null){
      return currentLocation;
      }
    
  }

   _checkForProfile() async{
    String userName;
    String url;
    //DocumentSnapshot value;
    

    currentuser = await Auth().currentUser();

    try{
      print('inside checking profile');
      DocumentReference userDocRef = Firestore.instance.collection('/users').document(currentuser.uid);
      userDocRef.get().then((value) {
        if(value.exists){
          userName = value.data['username'];
          url = value['photoURL'];
          print(userName);
          setState(() {
            this.username = userName;
            this.profilepicURL = url;
          });
        }
        else {
          print('user is not registered');
          userName = null;
          Navigator.of(context).pushReplacementNamed('/createprofile');
        }
      });
      
      
    } catch(e){
      print(e);
    }
  }
}

class GetClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height / 1.8);
    path.lineTo(size.width + 300, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    
    return true;
  }

}