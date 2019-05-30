import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';

class OnSuccessBooking extends StatefulWidget {
  final DocumentReference thisUserBooking;
  OnSuccessBooking({Key key, this.thisUserBooking});
  @override
  _OnSuccessBookingState createState() => _OnSuccessBookingState();
}

class _OnSuccessBookingState extends State<OnSuccessBooking> {
  DocumentSnapshot userBookingDocSnapshot;
  String jsonString = '';
  
  @override
  Widget build(BuildContext context) {
    
    //_getDetailedString();
    
    return Material(
      child: widget.thisUserBooking == null ? Container(child: Center(child: CircularProgressIndicator(),),) 
      : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        
        children: <Widget>[
          Center(child: Container(child: Text('Scan this qr code while checking in', style: TextStyle(fontSize: 16.0),),)),
          SizedBox(height: 20.0,),
          _qrFromString(),
        ],
      ),
    );
  }
//  _getDetailedString() async {
//    userBookingDocSnapshot = await widget.thisUserBooking.get();
//    jsonString = '{${userBookingDocSnapshot['user_id']}: ${widget.thisUserBooking.documentID}}';
//    //return jsonString;
//  }

  _qrFromString() {
    final bodyHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom;
    widget.thisUserBooking.get().then((userBookingDocSnapshot){
      jsonString = '{${userBookingDocSnapshot['user_id']}: ${widget.thisUserBooking.documentID}}';
    });
    return jsonString == null ? CircularProgressIndicator() :
    Container(
      child: Center(
              child: RepaintBoundary(
                key: widget.key,
                child: QrImage(
                  data: jsonString,
                  size: 0.4 * bodyHeight,
                  onError: (ex) {
                    print("[QR] ERROR - $ex");
                  }
                ),
              ),
            ),
          );
  }
}