import 'package:alpha/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookSlot{
  
  final DocumentSnapshot slotsDocRef;
  final DateTime startDateWithTime;
  final DateTime endDateWithTime;
  final DocumentReference parkingDocRef;
  final DocumentSnapshot parkingDocSnapshot;
  BookSlot({this.parkingDocSnapshot, this.parkingDocRef, this.slotsDocRef, this.startDateWithTime, this.endDateWithTime});
  DocumentReference myBookedDoc;
  Future<DocumentReference> userBooking;

  Future<DocumentReference> bookthisSlot() async{
    print('parkDocSnapshot inside bookSlot ' + parkingDocSnapshot.toString());
    CollectionReference bookedCollectionReference = slotsDocRef.reference.collection('booked');
    DocumentSnapshot lockDocSnap = await bookedCollectionReference.document('lock').get();
    if(lockDocSnap['value'] == false) {
      bookedCollectionReference.document('lock').updateData({'value' : true});
      FirebaseUser user = await Auth().currentUser();
      print('got current user ${user.uid}');
      DocumentReference newBookedDoc = await bookedCollectionReference.add({
          'user_id' : user.uid,
          'floor_id' : slotsDocRef['floor_id'],
          'lot_id' : slotsDocRef['lot_id'],
          'slot_id' : slotsDocRef['id'],
          'start_date' : Timestamp.fromDate(startDateWithTime),
          'end_date' : Timestamp.fromDate(endDateWithTime),
        });
        String docId = newBookedDoc.documentID;
        await newBookedDoc.updateData({
            'id' : docId,
          });
        myBookedDoc = newBookedDoc;
        print('Booking done ! Heading to update user data ----');
        userBooking = Firestore.instance.collection('users').document(user.uid).collection('bookings').add({
              'user_id' : user.uid,
              'floor_id' : slotsDocRef['floor_id'],
              'lot_id' : slotsDocRef['lot_id'],
              'slot_id' : slotsDocRef['id'],
              'start_date' : Timestamp.fromDate(startDateWithTime),
              'end_date' : Timestamp.fromDate(endDateWithTime),
              'lot_doc_id' : parkingDocSnapshot.documentID,
              'booked_doc_ref': myBookedDoc,
              'checked_in': false,
              'checked_out': false,
            });
            bookedCollectionReference.document('lock').updateData({'value' : false});
            print('return after booking');
            print(userBooking);
            return userBooking;

    }
    
  }
  
}