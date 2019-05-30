import 'package:alpha/bookaslot.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'onbooked.dart';

class SelectTime extends StatefulWidget {
  //SelectTime({this.singleSlotDocSnapshot, this.singleSlotDocRef});
  //final DocumentSnapshot singleSlotDocSnapshot;
  //final DocumentReference singleSlotDocRef;
  SelectTime({Key key, this.parkDocRef, this.parkDocSnapshot});
  final DocumentReference parkDocRef;
  final DocumentSnapshot parkDocSnapshot;
  @override
  _SelectTimeState createState() => _SelectTimeState();
}

class _SelectTimeState extends State<SelectTime> {
  Stream<QuerySnapshot> _floorStream;
  DateTime selectedStartDate = DateTime.now();

  //DateTime selectedStartDate = DateTime.now().subtract(Duration(hours: selectedStartTime.hour, minutes: selectedStartTime.minute, microseconds: 0));
  TimeOfDay selectedStartTime = TimeOfDay.now();
  TimeOfDay selectedEndTime = TimeOfDay.now();
  DateTime selectedEndDate = DateTime.now();
  DateTime startDateWithTime;
  DateTime endDateWithTime;
  bool isLoading = false;
  List<DocumentSnapshot> floorsDocRef;
  @override
  initState() {
    super.initState();
    print('parkDocSnapshot inside selectTime ' + widget.parkDocSnapshot.toString());
    _floorStream = widget.parkDocRef.collection('floors').snapshots();
    //print('floorsDocRef is : ' + floorsDocRef.toString());
  }

  Future<void> _selectStartDate(BuildContext context) async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedStartDate,
      firstDate: DateTime.now().subtract(Duration(days: 1)),
      lastDate: DateTime.now().add(Duration(days: 60)),
    );
    if (picked != null) {
      setState(() {
        if(picked.day == DateTime.now().day) {
          selectedStartDate = picked.subtract(
            Duration(
              hours: selectedStartDate.hour,
              minutes: selectedStartDate.minute,
              seconds: selectedStartDate.second,
              microseconds: selectedStartDate.microsecond,
              milliseconds: selectedStartDate.millisecond,
            )
          );
        }
        else {
          selectedStartDate = picked;
        }
        //picked = picked.subtract(Duration(hours: TimeOfDay.now().hour, minutes: TimeOfDay.now().minute -5, microseconds: 0));
        print('selected start date before time' + selectedStartDate.toString());
        if (selectedStartDate.isAfter(selectedEndDate)) {
          selectedEndDate = selectedStartDate;
        }
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedEndDate,
      firstDate: DateTime.now().subtract(Duration(days: 1)),
      lastDate: DateTime.now().add(Duration(days: 60)),
    );
    if (picked != null) {
      setState(() {
        if(picked.day == DateTime.now().day) {
          selectedEndDate = picked.subtract(
            Duration(
              hours: selectedEndDate.hour,
              minutes: selectedEndDate.minute,
              seconds: selectedEndDate.second,
              milliseconds: selectedEndDate.millisecond,
              microseconds: selectedEndDate.microsecond
            )
          );
        }
        else {
          selectedEndDate = picked;
        }
        //picked = picked.subtract(Duration(hours: TimeOfDay.now().hour, minutes: TimeOfDay.now().minute -5, microseconds: 0));
        print('selected end date before time : ' + selectedEndDate.toString());
      });
    }

    
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedStartTime,
    );
    if (picked != null) {
      setState(() {
        selectedStartTime = picked;
        //print(selectedStartTime.hour);
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedEndTime,
    );
    if (picked != null) {
      setState(() {
        selectedEndTime = picked;
        //print(selectedStartTime.hour);
        //print(selectedEndTime.hour);
        if ((selectedStartTime.hour > selectedEndTime.hour ||
            (selectedStartTime.hour == selectedEndTime.hour &&
                selectedStartTime.minute > selectedEndTime.minute)) && selectedStartDate.day >= selectedEndDate.day) {
          selectedEndDate = selectedEndDate.add(Duration(days: 1));
        }
      });
    }
  }
/*
  int _getDayFromTimeStamp(Timestamp timestamp) {
    return timestamp.toDate().day;
  }
*/
/*
  _getHourFromTimeStamp(Timestamp timestamp) {
    return timestamp.toDate().hour.toString();
  }
*/
/*
  _getMinuteFromTimeStamp(Timestamp timestamp) {
    return timestamp.toDate().minute.toString();
  }
*/
/*  Timestamp _getTimestamp(DateTime dateTime) {
    return Timestamp.fromDate(dateTime);
  }
*/
  DateTime _getDateTime(Timestamp timeStamp) {
    //print('timestamp :::::: ' + timeStamp.toString());
    return timeStamp.toDate();
  }

  @override
  Widget build(BuildContext context) {
    selectedStartDate =  selectedStartDate.subtract(
      Duration(
        hours: selectedStartDate.hour,
        minutes: selectedStartDate.minute,
        seconds: selectedStartDate.second,
        microseconds: selectedStartDate.microsecond,
        milliseconds: selectedStartDate.millisecond,
      )
    );
    selectedEndDate = selectedEndDate.subtract(
      Duration(
        hours: selectedEndDate.hour,
        minutes: selectedEndDate.minute,
        seconds: selectedEndDate.second,
        milliseconds: selectedEndDate.millisecond,
        microseconds: selectedEndDate.microsecond
      )
    );

    final TextStyle valueStyle = Theme.of(context).textTheme.body1;
    return Scaffold(
      appBar: AppBar(
        title: Text('Book a slot'),
      ),
      body: isLoading 
        ? Container(child: Center(child: CircularProgressIndicator(),),)
      : Column(children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: _InputDropDown(
                  labeltext: 'Start date',
                  valuetext: DateFormat.yMMMd().format(selectedStartDate),
                  valuestyle: valueStyle,
                  onPressed: () {
                    _selectStartDate(context);
                  }),
            ),
            SizedBox(
              width: 12.0,
            ),
            Expanded(
              flex: 3,
              child: _InputDropDown(
                labeltext: 'Start time',
                valuetext: selectedStartTime.format(context),
                valuestyle: valueStyle,
                onPressed: () {
                  _selectStartTime(context);
                },
              ),
            ),
          ],
        ),
        Row(children: <Widget>[
          Expanded(
            flex: 4,
            child: _InputDropDown(
                labeltext: 'End date',
                valuetext: DateFormat.yMMMd().format(selectedEndDate),
                valuestyle: valueStyle,
                onPressed: () {
                  _selectEndDate(context);
                }),
          ),
          SizedBox(
            width: 12.0,
          ),
          Expanded(
            flex: 3,
            child: _InputDropDown(
              labeltext: 'End time',
              valuetext: selectedEndTime.format(context),
              valuestyle: valueStyle,
              onPressed: () {
                _selectEndTime(context);
              },
            ),
          )
        ]),
        SizedBox(
          height: 20.0,
        ),

        /*  FutureBuilder<Widget> (
          future: _fetchAvailableSlots(floorsDocRef),
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              return snapshot.data;
            }
            return Center(child: CircularProgressIndicator(),);
          },
        )*/
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _floorStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              if (!snapshot.hasData) {
                return Center(
                    //child: CircularProgressIndicator()
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
        ),
      ]),
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
          children: <Widget>[
            Column(
              children: <Widget>[
                showParkingWithSlots(widget.parkDocRef
                    .collection('floors')
                    .document(document.documentID)),
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
        if (!snapshot.hasData) {
          return Center(
              //child: CircularProgressIndicator()
              );
        }
        slotDocuments = snapshot.data.documents;

        return Column(
          children: <Widget>[
            GridView.builder(
              shrinkWrap: true,
              itemCount: slotDocuments.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: MediaQuery.of(context).size.width /
                      (MediaQuery.of(context).size.height / 4)),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                final document = slotDocuments[index];
                if(document['booked'] == false){
                  //return _showEachSlot(false, );
                  if(_checkSlotAvailability(null, null)) {
                  return Container(
                    child: Center(
                      child: RaisedButton(
                        child: Text('Slot ' + document['slot_no'].toString()),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        elevation: 2.0,
                        color: Colors.white,
                        splashColor: Colors.amber,
                        onPressed: () {
                          _isTimeValid() == false ? _showSnackBar() : _loadBooking1(document);
                          //Navigator.push(context, MaterialPageRoute(builder: (context) => ShowBookings(singleSlotDocSnapshot: document, singleSlotDocRef: slotDocRef.collection('slots').document(document.documentID))));
                        },
                        //title: Text(doc['id'])
                      ),
                    ),
                  );}
                }
                else {
                  Stream<QuerySnapshot> _bookedSlotQuerySnapshot =
                document.reference.collection('booked').snapshots();
                return _fetchFromStream(_bookedSlotQuerySnapshot, document);
                }
              },
            ),
          ],
        );
      },
    );
  }

  _fetchFromStream(Stream<QuerySnapshot> _bookedSlotQuerySnapshot,
      DocumentSnapshot slotsDocRef) {
    List<DocumentSnapshot> _bookedSlotDocSnapshot;
    //print(_bookedSlotQuerySnapshot);
    return StreamBuilder<QuerySnapshot>(
      stream: _bookedSlotQuerySnapshot,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        _bookedSlotDocSnapshot = snapshot.data.documents;
        //print(_bookedSlotDocSnapshot);
        if (_bookedSlotDocSnapshot != null) {
          //print(_bookedSlotDocSnapshot.length);
          return Container(
            //child: ListView.builder(
              child : returningToContainer(_bookedSlotDocSnapshot, slotsDocRef), 
              //},
            //),
          );
        }
      },
    );
  }

  returningToContainer(List<DocumentSnapshot> _bookedSlotDocSnapshot, DocumentSnapshot slotsDocRef){
    //List<DocumentSnapshot> _bookedSlotDocSnapshot;
    //DocumentSnapshot slotsDocRef;
    for(int index = 0; index < _bookedSlotDocSnapshot.length; index++){
              //itemCount: _bookedSlotDocSnapshot.length,
              //itemBuilder: (context, index) {
                final document = _bookedSlotDocSnapshot[index];
                print('slot document : ' + document.toString());
                if(document.documentID != 'lock') {
                  print('inside document : ${document.documentID}');
                Timestamp start_time = document['start_date'];
                  Timestamp end_time = document['end_date'];
                  //print('db start time ' + start_time.toDate().toString());
                  //print('db end time ' + end_time.toDate().toString());
                  
                  if (_checkSlotAvailability(start_time, end_time) && index == (_bookedSlotDocSnapshot.length-2)) {
                    print('slot is available, showing the slot');
                    index = _bookedSlotDocSnapshot.length;
                    return Container(
                    child: Center(
                      child: RaisedButton(
                        child: Text('Slot ' + slotsDocRef['slot_no'].toString()),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        elevation: 2.0,
                        color: Colors.white,
                        splashColor: Colors.amber,
                        onPressed: () {
                          _isTimeValid() == false ? _showSnackBar() : _loadBooking2(slotsDocRef);
                        },
                        
                      ),
                    ),
                    );
                  } else if(!_checkSlotAvailability(start_time, end_time)){
                    index = _bookedSlotDocSnapshot.length;
                  }
                  else {
                    //index = index + 1;
                    print('inside else !');
                  }
                }
      }
  }

  _isTimeValid() {
    var diff = endDateWithTime.difference(startDateWithTime);
    print(diff.inMinutes);
    if(diff.inMinutes >= 15) {
      print('returning true');
      return true;
    }
    return false;
  }

  _showSnackBar() {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text('Duration should be at least 15 minutes'), duration: Duration(seconds: 3),));
  }

  _checkSlotAvailability(Timestamp startTime, Timestamp endTime) {
    DateTime tempstart = selectedStartDate;
    DateTime tempend = selectedEndDate;
    startDateWithTime = tempstart.add(Duration(
        hours: selectedStartTime.hour, minutes: selectedStartTime.minute));
        print('selected start time : ' + startDateWithTime.toString());
        //print(startDateWithTime);
    endDateWithTime = tempend.add(
        Duration(hours: selectedEndTime.hour, minutes: selectedEndTime.minute));
        print('selected end time : ' + endDateWithTime.toString());
        //print(endDateWithTime);
        if(startTime == null && endTime == null) return true;
    if (startDateWithTime.isBefore(_getDateTime(startTime)) &&
        endDateWithTime.isBefore(_getDateTime(startTime))) {
          print('Available : returning true condition');
      return true;
    } else if (startDateWithTime.isAfter(_getDateTime(endTime)) &&
        endDateWithTime.isAfter(_getDateTime(endTime))) {
          print('Available : returning true condition');
      return true;
    }
    return false;
  }

  _loadBooking1(DocumentSnapshot document) async{
    setState(() {
      isLoading = true;
    });
    await document.reference.updateData({'booked' : true});
    CollectionReference bookedCollectionReference = document.reference.collection('booked');
    bookedCollectionReference.document('lock').setData({'value' : false});
    DocumentReference userBookedDocRef = await BookSlot(parkingDocSnapshot: widget.parkDocSnapshot, parkingDocRef: widget.parkDocRef, slotsDocRef: document, startDateWithTime: startDateWithTime, endDateWithTime: endDateWithTime).bookthisSlot();
    Navigator.push(context, MaterialPageRoute(builder: (context) => OnSuccessBooking(
      thisUserBooking: userBookedDocRef
    )));
    print('bookedDoc :' + userBookedDocRef.toString());
  }



_loadBooking2(DocumentSnapshot slotsDocRef){
  print('executing after true');
  setState(() {
    isLoading = true;
  });
  Future<DocumentReference> docRef = BookSlot(parkingDocSnapshot: widget.parkDocSnapshot, parkingDocRef: widget.parkDocRef, slotsDocRef: slotsDocRef, startDateWithTime: startDateWithTime, endDateWithTime: endDateWithTime)
    .bookthisSlot();
    docRef.then((userBookedDocRef) {
      print('userBookedDocRef : ' + userBookedDocRef.toString());
      Navigator.push(context, MaterialPageRoute(builder: (context) => OnSuccessBooking(
        thisUserBooking: userBookedDocRef
      )));
    });
  
  }

}


class _InputDropDown extends StatelessWidget {
  _InputDropDown(
      {this.labeltext, this.onPressed, this.valuetext, this.valuestyle});
  final String labeltext;
  final String valuetext;
  final VoidCallback onPressed;
  final TextStyle valuestyle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: InputDecorator(
        decoration: InputDecoration(labelText: labeltext),
        baseStyle: valuestyle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(valuetext),
            Icon(
              Icons.arrow_drop_down,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey.shade700
                  : Colors.white70,
            )
          ],
        ),
      ),
    );
  }
}
