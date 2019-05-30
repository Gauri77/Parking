import 'package:cloud_firestore/cloud_firestore.dart';

class EditBooking {
  final DocumentSnapshot bookingSnapshot;

  EditBooking({this.bookingSnapshot});
  
  deleteBooking() {
    bookingSnapshot['booked_doc_ref'].delete();
    bookingSnapshot.reference.delete();
  }
}