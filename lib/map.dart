import 'package:alpha/parkingtabscreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Maps extends StatefulWidget {
  final LocationData userlocation;
  Maps({this.userlocation});
  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {

  Stream<QuerySnapshot> _parkingStream;
  double _latitude;
  double _longitude;
  List<Marker> markers;
  LocationData userLocation;
  var location = Location();
  @override
  void initState() {
    super.initState();
    _parkingStream = Firestore.instance
      .collection('parking_lot')
      .snapshots();
    _latitude = widget.userlocation.latitude;
    _longitude = widget.userlocation.longitude;
    }




  List<Marker> _getMarkers(List<DocumentSnapshot> documents){
    markers = List<Marker>();
    for(int i=0; i< documents.length; i++){
      markers.add(Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(documents[i]['latitude'], documents[i]['longitude']),
         builder: (context) => Container(
          child: IconButton(
            icon: Icon(FontAwesomeIcons.mapMarkerAlt),
            color: Colors.purpleAccent,
            onPressed: (){
              showModalBottomSheet(
                context: context,
                builder: (builder){
                  return Container(
                    height: 190.0,
                    //margin: EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[/*
                        Flexible(
                          flex: 2,
                          child: Container(
                            color: Colors.amberAccent,
                            padding: EdgeInsets.all(10.0),
                            child: Center(
                              child: Column(
                                children: <Widget>[
                                  Text(documents[i]['address'], style: TextStyle(color: Colors.black,),),
                                  Text('LatLng : ' + documents[i]['latitude'].toString() + ', ' + documents[i]['longitude'].toString(), style: TextStyle(color: Colors.black,),),
                                ],
                              ),
                            )
                           ),
                          ),
                        Flexible(
                          flex: 6,
                          child: Container(
                            color: Colors.white,
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Icon(
                                      FontAwesomeIcons.phone,
                                    ),
                                    Icon(
                                      FontAwesomeIcons.internetExplorer,
                                    ),
                                    Icon(
                                      FontAwesomeIcons.share,
                                    )
                                  ],
                                ),
                                RaisedButton(
                                  child: Text('show parking'),
                                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ParkingTabs(parkDocRef: Firestore.instance.collection('parking_lot').document(documents[i].documentID), parkDocSnapshot: documents[i]))),
                                )
                              ],
                            ),
                          ),
                        )*/
                        ListTile(
                          leading: Icon(Icons.location_searching),
                          title: Text(documents[i]['address'] + ', ' +documents[i]['zip'].toString(),),
                          onTap: (){},
                        ),
                        ListTile(
                          leading: Icon(Icons.location_on),
                          title: Text('LatLng : ' + documents[i]['latitude'].toString() 
                            + ', ' 
                            + documents[i]['longitude'].toString(),
                            style: TextStyle(color: Colors.black,),),
                          onTap: (){},
                        ),
                        Container(
                          color: Colors.green,
                          child: ListTile(
                            
                            leading: Icon(Icons.local_parking),
                            title: Text('Book a slot'),
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ParkingTabs(parkDocRef: Firestore.instance.collection('parking_lot').document(documents[i].documentID), parkDocSnapshot: documents[i]))),
                          ),
                        )
                      ],
                    ),
                  );
                }
              );
              },
            )
          )
      ));
    }
    return markers;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parking lots'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
              stream: _parkingStream,
              builder: (context, snapshot){
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
                    Flexible(
                      flex: 3,
                      child: /*Text(widget.userlocation.latitude.toString()),*/FlutterMap(
                        options: MapOptions(
                          center: LatLng(_latitude, _longitude),
                          zoom: 13.0
                        ),
                        
                        layers: [
                          TileLayerOptions(
                            urlTemplate: "https://api.tiles.mapbox.com/v4/"
                              "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
                            additionalOptions: {
                              'accessToken':'pk.eyJ1IjoidmlzaG51NzciLCJhIjoiY2p2ZDM5cTg5MWNidDRkbm04YTM5Nnh5ZyJ9.GKi_hyXOQ2PIPR-lh3ZOog',
                              'id':'mapbox.streets',
                            }
                          ),
                          MarkerLayerOptions(
                            markers: _getMarkers(snapshot.data.documents),
                            )
                          ]
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: ParkingList(documents: snapshot.data.documents),
                    ),
                  ],
                );
                },
              ),
        );
  }
}

class ParkingList extends StatelessWidget {
  const ParkingList({
    Key key,
    @required this.documents,
  }) : super(key: key);

  final List<DocumentSnapshot> documents;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: documents.length,
      itemBuilder: (builder, index){
        final document = documents[index];
        return ListTile(
          title: Text(document['address']),
          subtitle: Text(document['id']),
          leading: Text(document['latitude'].toString() + ' ' + document['longitude'].toString()),
        );
      },
    );
  }
}
          
/*class ParkingMap extends StatelessWidget {
  //LatLngBounds latlng = 
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(51.5, -0.09),
        zoom: 13.0,
      ),
    );
  }
}*/