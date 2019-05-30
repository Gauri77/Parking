import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'showbookings.dart';

class ShowParking extends StatefulWidget {
  ShowParking({this.parkDocRef});
  final DocumentReference parkDocRef;
  @override
  _ShowParkingState createState() => _ShowParkingState();
}

class _ShowParkingState extends State<ShowParking> {
  Stream<QuerySnapshot> _floorStream;
  @override
  void initState() {
    super.initState();
    _floorStream = widget.parkDocRef.collection('floors').snapshots();
    //print(_floorStream);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(),
      body: StreamBuilder<QuerySnapshot>(
        stream: _floorStream,
        builder: (context, snapshot) {
          if(snapshot.hasError){
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                      );
                  }
                if(!snapshot.hasData){
                  return Center(
                    child: CircularProgressIndicator()
                    );
                  }
                  return Column(
                    children: <Widget>[
                      Expanded(
                        //flex:0,
                        child: floorList(snapshot.data.documents),
                      )
                      
                    ],
                  );
        },
      ),
    );
  }

  floorList(List<DocumentSnapshot> documents) {
    //print(documents.length.toString());
    return ListView.builder(
      itemCount: documents.length,
      itemBuilder: (context, index) {
        final document = documents[index];
        return ExpansionTile(
          title: Text('Floor ' + document['floor_no'].toString()),
          //onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ShowParkingWithSlots( slotDocRef: widget.parkDocRef.collection('floors').document(document.documentID))))
          children: <Widget>[
            
            //Padding(
              //padding: const EdgeInsets.symmetric(horizontal: 16.0),
              //child: 
              Column(
                //mainAxisAlignment: MainAxisAlignment.end,
                //mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  showParkingWithSlots(widget.parkDocRef.collection('floors').document(document.documentID)),
                ],
              ),
            //)
          ],
        );
      },
    );
  }

  showParkingWithSlots(DocumentReference slotDocRef) {
    Stream<QuerySnapshot> _slotStream;
    List<DocumentSnapshot> slotDocuments;
    _slotStream = slotDocRef.collection('slots').snapshots();
    return StreamBuilder<QuerySnapshot>(
        stream: _slotStream,
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator()
            );
          }
          slotDocuments = snapshot.data.documents;
          //print(slotDocuments.length);
          return Column(
            children: <Widget>[
              GridView.builder(
                shrinkWrap: true,
                itemCount: slotDocuments.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 4)),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  final document = slotDocuments[index];
                  return Container(
                    //padding: EdgeInsets.all(10.0),
                    child: Center(
                      //child: GridTile(
                    //title: Text(document['id']),
                    //onTap: (){},
                    //child: Text(document['id']),

                  //),
                  child: RaisedButton(
            child: Text('Slot ' + document['slot_no'].toString()),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0), side: BorderSide(color: Colors.black,),),
            elevation: 2.0,
            color: document['booked'] == true ? Colors.blueGrey[200] : Colors.white,
            splashColor: Colors.amber,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ShowBookings(singleSlotDocSnapshot: document, singleSlotDocRef: slotDocRef.collection('slots').document(document.documentID))));
            },
            //title: Text(doc['id'])
          ),
                    ),
                  );
                },
              ),
            ],
    );/*
          List<Widget> _slotList = [];
          slotDocuments.forEach((doc) => _slotList.add(RaisedButton(
            child: Text('Slot ' + doc['slot_no'].toString()),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0), side: BorderSide(color: Colors.black,),),
            elevation: 2.0,
            color: Colors.white,
            onPressed: () {},
            //title: Text(doc['id'])
          )));
          return GridView.builder(crossAxisCount: 2, children: _slotList,);*/
        },
      );
  }
}
/*
class ShowParkingWithSlots extends StatefulWidget {
  ShowParkingWithSlots({this.slotDocRef});
  final DocumentReference slotDocRef;
  @override
  _ShowParkingWithSlotsState createState() => _ShowParkingWithSlotsState();
}

class _ShowParkingWithSlotsState extends State<ShowParkingWithSlots> {
  Stream<QuerySnapshot> _slotStream;
  List<DocumentSnapshot> slotDocuments;
  @override
  void initState() {
    super.initState();
    _slotStream = widget.slotDocRef.collection('slots').snapshots();
    print(_slotStream);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _slotStream,
        builder: (context, snapshot) {
          slotDocuments = snapshot.data.documents;
          print(slotDocuments.length);
          return ListView.builder(
            itemCount: slotDocuments.length,
            itemBuilder: (context, index) {
              final document = slotDocuments[index];
              return ListTile(
                title: Text(document['id']),
                onTap: (){},
              );
            },
          );
        },
      )
    );
  }
}*/