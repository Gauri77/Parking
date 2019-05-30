/*import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
class SelectProfilePic extends StatefulWidget {
  @override
  _SelectProfilePicState createState() => _SelectProfilePicState();
}

class _SelectProfilePicState extends State<SelectProfilePic> {
  FileImage newProfilePic;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          ClipPath(
            clipper: getClipper(),
            child: Container(color: Colors.amber.withOpacity(0.8)),
          ),
          Positioned(
            width: 350.0,
            top: MediaQuery.of(context).size.height/5,
            child: Column(
              children: <Widget>[
                Container(
                  width: 150.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    image: DecorationImage(
                      image: NetworkImage(
                        ''
                      ),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(75.0)),
                    boxShadow: [
                      BoxShadow(blurRadius: 7.0, color: Colors.black)
                    ]
                  ),
                ),
                SizedBox(height: 90.0,),
                Text(
                  'Choose a profile pic',
                  style: TextStyle(
                    fontSize: 17.0,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'Montserrat',
                  ),
                ),
                SizedBox(height: 75.0),
                IconButton(
                  icon: Icon(Icons.arrow_forward, color: Colors.amber, size: 40.0,),
                onPressed: (){
                   _addUserProf();
                }
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}*/