import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:open_maps/Screen/screens.dart';
import 'package:open_maps/Widget/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';

import '../Provider/providers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const String route = "home";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      MarkerProvider mProvider =
          Provider.of<MarkerProvider>(context, listen: false);
      mProvider.getAllMarkers();
    });
  }

  @override
  Widget build(BuildContext context) {
    MarkerProvider mProvider = Provider.of<MarkerProvider>(context);

    final PopupController popupController = PopupController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('OpenStreetMap'),
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
              onPressed: () => showSearch(context: context, delegate: MapSearchDelegate()),
              icon: const Icon(Icons.search)
          )
        ],
      ),
      body: FutureBuilder(
        future: mProvider.getMarkers(),
        builder: (context, AsyncSnapshot markerList) {
          return Stack(
            children: [
              FlutterMap(
                mapController: mProvider.controller,
                options: MapOptions(
                    plugins: [MarkerClusterPlugin()],
                    center: LatLng(40.463667, -3.74922),
                    maxZoom: 18,
                    zoom: 4,
                    onLongPress: (_, LatLng latlng) {
                      Navigator.of(context)
                          .pushNamed(DetailsScreen.route, arguments: latlng);
                    },
                    onTap: (_, __)  => popupController.hideAllPopups()
                ),
                layers: [
                  TileLayerOptions(
                      urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c']),
                  MarkerClusterLayerOptions(
                      spiderfyCircleRadius: 80,
                      spiderfySpiralDistanceMultiplier: 2,
                      circleSpiralSwitchover: 12,
                      maxClusterRadius: 120,
                      rotate: true,
                      size: const Size(40, 40),
                      anchor: AnchorPos.align(AnchorAlign.center),
                      markers: markerList.data ?? [],
                      fitBoundsOptions: const FitBoundsOptions(
                          padding: EdgeInsets.all(50), maxZoom: 15),
                      polygonOptions: const PolygonOptions(
                          borderColor: Colors.indigo,
                          color: Colors.black12,
                          borderStrokeWidth: 3),
                      popupOptions: PopupOptions(
                          popupSnap: PopupSnap.markerTop,
                          popupController: popupController,
                          popupBuilder: (_, marker) => Container(
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(20))
                                ),
                                width: 200,
                                height: 100,
                                child: GestureDetector(
                                  onTap: () => debugPrint('Popup tap!'),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(mProvider
                                        .getMarker(marker.point)
                                        .description),
                                  ),
                                ),
                              )),
                      builder: (context, markers) => Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.indigo
                            ),
                            child: Center(
                              child: Text(
                                markers.length.toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ))
                ],
              ),
              FloatingActionButton(
                onPressed: () {},
                child: const Icon(Icons.location_off),
              )
            ],
          );
        },
      ),
    );
  }
}
