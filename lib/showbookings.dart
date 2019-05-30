import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShowBookings extends StatefulWidget {
  ShowBookings({this.singleSlotDocSnapshot, this.singleSlotDocRef});
  final DocumentSnapshot singleSlotDocSnapshot;
  final DocumentReference singleSlotDocRef;
  @override
  _ShowBookingsState createState() => _ShowBookingsState();
}

class _ShowBookingsState extends State<ShowBookings> {
  DateTime selectedStartDate = DateTime.now();
  TimeOfDay selectedStartTime = TimeOfDay.now();
  TimeOfDay selectedEndTime = TimeOfDay.now();
  DateTime selectedEndDate = DateTime.now();
  

  @override
  void initState() {
    super.initState();
    Timestamp myTimeStamp = Timestamp.fromDate(selectedStartDate);
    print(selectedStartDate);
    print(myTimeStamp);
    
    if (widget.singleSlotDocSnapshot['booked'] == true) {
      //_singleSlotBookedStream = widget.singleSlotDocRef.collection('booked').snapshots();
    }
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
        print(selectedStartTime.hour);
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
        print(selectedStartTime.hour);
        print(selectedEndTime.hour);
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
  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.body1;
    return Scaffold(
      appBar: AppBar(
        title: Text('Book a slot'),
        actions: <Widget>[
          FlatButton(
            child: Text('Done'),
            onPressed: () {},
          )
        ],
      ),
      body: Column(children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: _InputDropDown(
                  labeltext: 'Choose date',
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
                labeltext: 'Choose start time',
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
                labeltext: 'Choose end date',
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
              labeltext: 'Choose end time',
              valuetext: selectedEndTime.format(context),
              valuestyle: valueStyle,
              onPressed: () {
                _selectEndTime(context);
              },
            ),
          )
        ]),
        _showCurrentBookings(
            widget.singleSlotDocRef.collection('booked').snapshots())
      ]),
    );
  }

  _showCurrentBookings(Stream<QuerySnapshot> _singleSlotBookedStream) {
    List<DocumentSnapshot> _bookedSlotDocuments;
    return StreamBuilder<QuerySnapshot>(
      stream: _singleSlotBookedStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        _bookedSlotDocuments = snapshot.data.documents;
        return Flexible(
                  child: ListView.builder(
            itemCount: _bookedSlotDocuments.length,
            itemBuilder: (context, index) {
              final document = _bookedSlotDocuments[index];
              int start_day = _getDayFromTimeStamp(document['start_date']);
              int end_day = _getDayFromTimeStamp(document['end_date']);
              
              if(end_day < selectedStartDate.day && end_day < selectedEndDate.day) {

              }
              else if(start_day > selectedStartDate.day && start_day > selectedEndDate.day) {

              }
              else {
                String start_hour = _getHourFromTimeStamp(document['start_date']);
                String end_hour = _getHourFromTimeStamp(document['end_date']);
                String start_minute = _getMinuteFromTimeStamp(document['start_date']);
                String end_minute = _getMinuteFromTimeStamp(document['end_date']);
                return ListTile(
                  title: Text(
                    start_day.toString() + ' to ' + end_day.toString()
                  ),
                  subtitle: Text(
                    'From ' + start_hour + ':' + start_minute + ' to ' + end_hour + ':' + end_minute
                  ),
                );
              }
              //return ListTile(
              //  title: Text(document['start_date'].toDate().day.toString() + ' to ' + document['end_date'].toDate().day.toString()),
              //);
            },
          ),
        );
      },
    );
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
