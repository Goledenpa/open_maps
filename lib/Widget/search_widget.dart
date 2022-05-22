import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../Model/models.dart';
import '../Provider/providers.dart';
import 'package:provider/provider.dart';

class MapSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back_ios));
  }

  @override
  Widget buildResults(BuildContext context) {
    MarkerProvider mProvider =
        Provider.of<MarkerProvider>(context, listen: true);
    return FutureBuilder(
      future: mProvider.getMarkerSearch(query),
      builder: (context, AsyncSnapshot<List<MarkerMap>> snapshot) {
        if (!snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Center(
                child: CircularProgressIndicator(),
              )
            ],
          );
        } else if (snapshot.data!.isEmpty) {
          return const Center(
              child: Text("No se han encontrado resultados",
                        style: TextStyle(fontSize: 18),
          ));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  mProvider.moveMap(LatLng(snapshot.data![index].latitude,
                      snapshot.data![index].longitude));
                  close(context, null);
                },
                title: Text(snapshot.data![index].title),
                subtitle: Text(snapshot.data![index].description),
                trailing: IconButton(
                    onPressed: () {
                      mProvider.removeMarker(snapshot.data![index]);
                    },
                    icon: const Icon(Icons.clear)),
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    MarkerProvider provider =
        Provider.of<MarkerProvider>(context, listen: true);
    return FutureBuilder(
      future: provider.getMarkerSearch(query),
      builder: (context, AsyncSnapshot<List<MarkerMap>> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else {
          return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    provider.moveMap(LatLng(snapshot.data![index].latitude,
                        snapshot.data![index].longitude));
                    close(context, null);
                  },
                  title: Text(snapshot.data![index].title),
                  subtitle: Text(snapshot.data![index].description),
                  trailing: IconButton(
                      onPressed: () {
                        provider.removeMarker(snapshot.data![index]);
                      },
                      icon: const Icon(Icons.clear)),
                );
              });
        }
      },
    );
  }
}
