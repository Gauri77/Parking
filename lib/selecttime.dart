/*import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SelectTime extends StatefulWidget {
  //SelectTime({this.singleSlotDocSnapshot, this.singleSlotDocRef});
  //final DocumentSnapshot singleSlotDocSnapshot;
  //final DocumentReference singleSlotDocRef;
  SelectTime({this.parkDocRef});
  final DocumentReference parkDocRef;
  @override
  _SelectTimeState createState() => _SelectTimeState();
}

class _SelectTimeState extends State<SelectTime> {
  DateTime selectedStartDate = DateTime.now();
  TimeOfDay selectedStartTime = TimeOfDay.now();
  TimeOfDay selectedEndTime = TimeOfDay.now();
  DateTime selectedEndDate = DateTime.now();
  
  List<DocumentSnapshot> floorsDocRef;
  @override
  initState(){
    super.initState();
    widget.parkDocRef.collection('floors').getDocuments().then((onValue){
      setState(() {
        floorsDocRef = onValue.documents;
      });
      
      //print('floorsDocRef is : ' + floorsDocRef.toString());
    });
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedStartDate,
      firstDate: DateTime.now().subtract(Duration(days: 1)),
      lastDate: DateTime.now().add(Duration(days: 60)),
    );
    if (picked != null) {
      setState(() {
        selectedStartDate = picked;
        if(selectedStartDate.isAfter(selectedEndDate)){
          selectedEndDate = selectedStartDate;
        }
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedEndDate,
      firstDate: DateTime.now().subtract(Duration(days: 1)),
      lastDate: DateTime.now().add(Duration(days: 60)),
    );
    if (picked != null) {
      setState(() {
        selectedEndDate = picked;
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
        if(selectedStartTime.hour > selectedEndTime.hour || (selectedStartTime.hour == selectedEndTime.hour && selectedStartTime.minute > selectedEndTime.minute)) {
          selectedEndDate = selectedEndDate.add(Duration(days: 1));
        }
      });
    }
  }

  int _getDayFromTimeStamp(Timestamp timestamp) {
    return timestamp.toDate().day;
  }
  _getHourFromTimeStamp(Timestamp timestamp) {
    return timestamp.toDate().hour.toString();
  }
  _getMinuteFromTimeStamp(Timestamp timestamp) {
    return timestamp.toDate().minute.toString();
  }
  Timestamp _getTimestamp(DateTime dateTime) {
    return Timestamp.fromDate(dateTime);
  }
  DateTime _getDateTime(Timestamp timeStamp) {
    return timeStamp.toDate();
  }
  @override
  Widget build(BuildContext context) {
    if(floorsDocRef == null ){
      return Center(child: CircularProgressIndicator());
    }
    final TextStyle valueStyle = Theme.of(context).textTheme.body1;
    return Scaffold(
      appBar: AppBar(
        title: Text('Book a slot'),
      ),
      body: Column(children: <Widget>[
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
        
        SizedBox(height: 20.0,),

        FutureBuilder<Widget> (
          future: _fetchAvailableSlots(floorsDocRef),
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              return snapshot.data;
            }
            return Center(child: CircularProgressIndicator(),);
          },
        )
        
        
        //_showCurrentBookings(
            //widget.singleSlotDocRef.collection('booked').snapshots())
      ]),
    );
  }

  Future<Widget> _fetchAvailableSlots(List<DocumentSnapshot> floorsDoumentRef) async{
    //print('calling ' + floorsDoumentRef.toString());

    for(int i=0; i<floorsDoumentRef.length; i++) {
      DocumentReference myFloorRef = floorsDoumentRef[i].reference;
      QuerySnapshot onValue = await myFloorRef.collection('slots').getDocuments();
      //.then((onValue){

        List<DocumentSnapshot> slotsDocRef =  onValue.documents;
        for(int j=0; j<slotsDocRef.length; j++) {
          //print('slotDocRef is : ' + slotsDocRef.toString());
          if(slotsDocRef[j]['booked'] == true) {
            DocumentReference thisSlotRef = slotsDocRef[j].reference;
            //print(slotsDocRef[j]['booked']);
            try {
              Stream<QuerySnapshot> _bookedSlotQuerySnapshot = thisSlotRef.collection('booked').snapshots();
              //print(_bookedSlotQuerySnapshot);
              return _fetchFromStream(_bookedSlotQuerySnapshot, slotsDocRef[j]);
            } catch(e) {
              print(e);
            }
          }
          else {
            print('returning listtile');
            return ListTile(
                    title: Text('Slot no. ' + slotsDocRef[j]['slot_no'].toString() + ' of ' + slotsDocRef[j]['floor_id']),
                  ); 
          }
        }
      //}
      //);
    }
  }

  _fetchFromStream(Stream<QuerySnapshot> _bookedSlotQuerySnapshot, DocumentSnapshot slotsDocRef) {
    List<DocumentSnapshot> _bookedSlotDocSnapshot;
    //print(_bookedSlotQuerySnapshot);
    return StreamBuilder<QuerySnapshot>(
      stream: _bookedSlotQuerySnapshot,
      builder: (context, snapshot) {
        
        if(!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        _bookedSlotDocSnapshot = snapshot.data.documents;
        //print(_bookedSlotDocSnapshot);
        if(_bookedSlotDocSnapshot!=null) {
          //print(_bookedSlotDocSnapshot.length);
          return Flexible(
            child: ListView.builder(
              itemCount: _bookedSlotDocSnapshot.length,
              itemBuilder: (context, index) {
                final document = _bookedSlotDocSnapshot[index];
                Timestamp start_time =  document['start_date'];
                Timestamp end_time = document['end_date'];

                if(_checkSlotAvailability(start_time, end_time)) {
                  return ListTile(
                    title: Text('Slot no. ' + slotsDocRef['slot_no'].toString() + ' of ' + slotsDocRef['floor_id']),
                    onTap: () {},
                  ); 
                }
                //print(start_time);
                //print(end_time);
                
              },
            ),
          );}
        
      },
    );
  }

  _checkSlotAvailability(Timestamp startTime, Timestamp endTime) {
    DateTime startDateWithTime = selectedStartDate.add(Duration(hours: selectedStartTime.hour, minutes: selectedStartTime.minute));
    DateTime endDateWithTime = selectedEndDate.add(Duration(hours: selectedEndTime.hour, minutes: selectedEndTime.minute));
    if(startDateWithTime.isBefore(_getDateTime(startTime)) && endDateWithTime.isBefore(_getDateTime(startTime))) {
      return true;
    }
    else if(startDateWithTime.isAfter(_getDateTime(endTime)) && endDateWithTime.isAfter(_getDateTime(endTime))) {
      return true;
    }
    return false;
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
*/