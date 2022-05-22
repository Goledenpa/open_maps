import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:open_maps/Model/models.dart';
import 'package:open_maps/Provider/db_provider.dart';

class MarkerProvider with ChangeNotifier {
  List<MarkerMap> markerList = [];
  final MapController controller = MapController();

  void getAllMarkers() async {
    markerList = await DBProvider.db.getMarkers();
    debugPrint('GOT MARKERS FROM DB ${markerList.length}');
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

  void addMarker(MarkerMap marker) async {
    int markerId = await DBProvider.db.addMarker(marker);
    marker.id = markerId;
    markerList.add(marker);
    notifyListeners();
  }

  Future<List<MarkerMap>> getMarkerList() async {
    return markerList;
  }

  MarkerMap getMarker(LatLng point) {
    return markerList.firstWhere(
        (e) => e.latitude == point.latitude && e.longitude == point.longitude);
  }

  void moveMap(LatLng value){
    controller.move(value, 12);
  }

  void removeMarker(MarkerMap value){
    markerList.remove(value);
    DBProvider.db.removeMarker(value.id!);
    notifyListeners();
  }

  Future<List<MarkerMap>> getMarkerSearch(String query) async{
    return markerList.where((m) => m.title.contains(query)).toList();
  }
}
