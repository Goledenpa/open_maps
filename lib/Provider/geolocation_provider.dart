import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class GeolocationProvider with ChangeNotifier {
  LocationData? _currentLocation;
  bool _perms = false;
  final Location _locationService = Location();
  var interactiveFlags = InteractiveFlag.all;
  bool isActive = true;
  bool liveUpdate = false;

  LocationData? get currentLocation => _currentLocation;

  void stopLocationService() {
    debugPrint('Servicio de geolocalización "parado"');
  }

  void startLocationService(MapController controller) async {
    await _locationService.changeSettings(
      accuracy: LocationAccuracy.high,
      interval: 100,
    );

    LocationData? location;
    bool serviceEnabled;
    bool serviceRequestResult;

    try {
      serviceEnabled = await _locationService.serviceEnabled();

      if (serviceEnabled) {
        var permission = await _locationService.requestPermission();
        _perms = permission == PermissionStatus.granted;

        if (_perms) {
          isActive = true;
          location = await _locationService.getLocation();
          _currentLocation = location;
          recargar();
          _locationService.onLocationChanged
              .listen((LocationData result) async {
            _currentLocation = result;
            if (liveUpdate) {
              controller.move(
                  LatLng(result.latitude!, result.longitude!), controller.zoom);
            }
            recargar();
          });
        }
      } else {
        serviceRequestResult = await _locationService.requestService();
        if (serviceRequestResult) {
          startLocationService(controller);
          isActive = false;
          return;
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void recargar() {
    notifyListeners();
  }
}
