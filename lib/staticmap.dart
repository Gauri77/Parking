/*import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';

class StaticMap extends StatefulWidget {
  @override
  _StaticMapState createState() => _StaticMapState();
}

class _StaticMapState extends State<StaticMap> {
  StaticMapProvider staticMapProvider;
  String apiKey = 'AIzaSyBNfTAcLOBbXN2M-JNqXdfkeiMdjTEACBc';
  Uri imageUri;
  @override
  void initState(){
    super.initState();
    staticMapProvider = StaticMapProvider(apiKey);
    imageUri = staticMapProvider.getStaticUri(Locations.centerOfUSA, 14);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parking Lots'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Center(
                child: ClipRect(
                  child: Image.network(imageUri.toString()),
                ),
              ),
              ),

          ],
        ),
      ),
    );
  }
}*/