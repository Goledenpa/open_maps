import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:open_maps/Model/models.dart';
import 'package:open_maps/Provider/db_provider.dart';

class MarkerProvider with ChangeNotifier {
  List<MarkerMap> markerList = [];

  void getAllMarkers() async {
    debugPrint('GOT MARKERS FROM DB');
    markerList = await DBProvider.db.getMarkers();
    notifyListeners();
  }

  Future<List<Marker>> getMarkers() async {
    return markerList
        .map((marker) => Marker(
              point: LatLng(marker.latitude, marker.longitude),
              width: 60,
              height: 60,
              anchorPos: AnchorPos.align(AnchorAlign.center),
              rotate: false,
              builder: (context) => const Icon(
                Icons.location_pin,
                color: Colors.black,
                size: 60,
              ),
            ))
        .toList();
  }

  void addMarker(MarkerMap marker){
    markerList.add(marker);
    DBProvider.db.addMarker(marker);
    notifyListeners();
  }

  MarkerMap getMarker(LatLng point){
    return markerList.firstWhere((e) => e.latitude == point.latitude && e.longitude == point.longitude);
  }
}
