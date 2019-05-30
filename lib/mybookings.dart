import 'package:alpha/editbookings.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyBooking extends StatefulWidget {
  final FirebaseUser user;

  const MyBooking({this.user});
  @override
  _MyBookingState createState() => _MyBookingState();
}

class _MyBookingState extends State<MyBooking> {
  Stream<QuerySnapshot> _myBookingSnapshot;
  CollectionReference _parkingCollectionRef;
  String address;
  @override
  void initState() {
    super.initState();
    _myBookingSnapshot = Firestore.instance.collection('users').document(widget.user.uid).collection('bookings').snapshots();
    _parkingCollectionRef = Firestore.instance.collection('parking_lot');
  }

  getFromParking(String id) async{
    //await Future.delayed(Duration(milliseconds: 500));
    DocumentSnapshot docsnap = await Firestore.instance.collection('parking_lot').document(id).get();
      address = docsnap['address'];
      print(docsnap['address']);
   //print(value['address']);
    return address;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookings'),
        centerTitle: true,
      ),
      body: //Container(
        //padding: EdgeInsets.all(15.0),
        //child: Column(
          //children: <Widget>[
            //Expanded(
              //child: 
              StreamBuilder(
                stream: _myBookingSnapshot,
                builder: (context, snapshot) {
                  print(' snapshot data : ' + snapshot.data.toString());
                  if(snapshot.hasError) {
                    print(snapshot.error);
                  }
                  if(!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator(),);
                  }
                  List<DocumentSnapshot> documents = snapshot.data.documents;
                  return ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      final document = documents[index];

                      return FutureBuilder(
                        future: getFromParking(document['lot_doc_id']),
                        builder: (context, snapshot) {
                        //  if(address != null) {
                          if(address == null) {
                            return Container(child: Center(child: CircularProgressIndicator(),));
                          }
                          if(!document['end_date'].toDate().isBefore(DateTime.now())) {
                            return Card(
                            elevation: 4.0,
                            child: Container(
                              padding: EdgeInsets.all(15.0),
                              
                              child: Column(
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Text('Start time : ' + document['start_date'].toDate().toString(), style: TextStyle(
                                        fontSize: 20.0
                                      ),),
                                      Text('End time : ' + document['end_date'].toDate().toString(), style: TextStyle(
                                        fontSize: 20.0
                                      ),),
                                      
                                      Text('Location : ' + address.toString(), style: TextStyle(
                                        fontSize: 15.0
                                      ),),
                                    ],
                                  ),
                                  SizedBox(height: 15.0,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      FlatButton(
                                        onPressed: () {
                                          EditBooking(bookingSnapshot: document).deleteBooking();
                                        setState(() {
                                          
                                        });
                                        },
                                        child: Icon(
                                          Icons.cancel
                                        ),
                                      ),
                                      
                                      FlatButton(
                                        onPressed: () {},
                                        child: Icon(
                                          FontAwesomeIcons.qrcode
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );} else return Container();
                        //  }
                        },
                      );
                      //final document = documents[index];
                      //address = getFromParking(document['lot_doc_id']);
                      //print('returning cards');
                      
                      //if(address !=null) {
                        
                      //}
                    
                    },
                  );
                },
              )
            //)
          //],
        //),
      //),
    );
  }
}