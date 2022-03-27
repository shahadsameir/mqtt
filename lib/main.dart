import 'package:flutter/material.dart';

import 'package:location/location.dart';
import 'locationWrapper.dart';
import 'models.dart';
import 'mqttClientWrapper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter MQTT Location Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter MQTT Location'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  MQTTClientWrapper mqttClientWrapper;
  LocationWrapper locationWrapper;

  LocationData currentLocation;

  void setup() {
    locationWrapper = LocationWrapper(
        (newLocation) => mqttClientWrapper.publishLocation(newLocation));
    mqttClientWrapper = MQTTClientWrapper(
        () => locationWrapper.prepareLocationMonitoring(),
        (newLocationJson) => gotNewLocation(newLocationJson));
    mqttClientWrapper.prepareMqttClient();
  }

  void gotNewLocation(LocationData newLocationData) {
    setState(() {
      this.currentLocation = newLocationData;
    });
    animateCameraToNewLocation(newLocationData);
  }

  void animateCameraToNewLocation(LocationData newLocation) {
    print(newLocation.latitude);
    print(newLocation.longitude);
  }

  @override
  void initState() {
    super.initState();

    setup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: mqttClientWrapper.connectionState !=
                MqttCurrentConnectionState.CONNECTED
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text("CONNECTING TO MQTT..."),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: CircularProgressIndicator(),
                    ),
                  ],
                ),
              )
            : Text(currentLocation.toString()));
  }
}
