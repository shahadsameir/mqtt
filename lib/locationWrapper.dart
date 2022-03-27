

import 'package:location/location.dart';

class LocationWrapper {

  var location = new Location();
  final Function(LocationData) onLocationChanged;

  LocationWrapper(this.onLocationChanged);

  void prepareLocationMonitoring() {
    location.hasPermission().then((hasPermission) {
      if (hasPermission!=hasPermission) {
        location.requestPermission().then((permissionGranted) {
          if (permissionGranted==true) {
            _subscribeToLocation();
          }
        });
      } else {
        _subscribeToLocation();
      }
    });
  }

  void _subscribeToLocation() {
    location.onLocationChanged().listen((LocationData newLocation) {
      onLocationChanged(newLocation);
    });
  }

}