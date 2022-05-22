import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:open_maps/Provider/providers.dart';
import 'package:provider/provider.dart';

class GeolocationProvider with ChangeNotifier {
  LocationData? currentLocation;
  bool _liveUpdate = false;
  bool _perms = false;
  final Location _locationService = Location();
  final interactiveFlags = InteractiveFlag.all;
  bool isActive = false;

  get liveUpdate => _liveUpdate;

  void stopLocationService() {
    debugPrint('Servicio de geolocalización "parado"');
  }

  void startLocationService(MapController controller) async {
    await _locationService.changeSettings(
      accuracy: LocationAccuracy.high,
      interval: 1000,
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
          location = await _locationService.getLocation();
          currentLocation = location;
          recargar();
          _locationService.onLocationChanged
              .listen((LocationData result) async {
                currentLocation =
            if (_liveUpdate) {
              controller.move(
                  LatLng(result.latitude!,
                      result.longitude!),
                  controller.zoom);
            }
            recargar();
          });
        }
      } else {
        serviceRequestResult = await _locationService.requestService();
        if (serviceRequestResult) {
          startLocationService(controller);
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
