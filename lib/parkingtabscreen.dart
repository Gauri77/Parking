import 'package:alpha/selecttime2.dart';
import 'package:alpha/showparking.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ParkingTabs extends StatelessWidget {
  ParkingTabs({this.parkDocRef, this.parkDocSnapshot});
  final DocumentReference parkDocRef;
  final DocumentSnapshot parkDocSnapshot;

  initState() {
    print('parkDocSnapshot inside tabscreen ' + parkDocSnapshot.toString());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(color: Colors.amber),
        primarySwatch: Colors.amber
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.directions_car)),
                Tab(icon: Icon(Icons.zoom_in),)
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              
              SelectTime(parkDocRef: parkDocRef, parkDocSnapshot: parkDocSnapshot,),
              ShowParking(parkDocRef: parkDocRef),
            ],
          ),
        ),
        ),
    );
  }
}