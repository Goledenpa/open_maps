import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../Model/models.dart';
import '../Provider/providers.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({Key? key}) : super(key: key);
  static const route = 'details';

  @override
  Widget build(BuildContext context) {
    FormProvider fProvider = Provider.of<FormProvider>(context, listen: true);
    MarkerProvider mProvider = Provider.of<MarkerProvider>(context, listen: false);


    LatLng latlng = ModalRoute.of(context)?.settings.arguments as LatLng;

    fProvider.latitude.value = latlng.latitude.toStringAsFixed(4);
    fProvider.longitude.value = latlng.longitude.toStringAsFixed(4);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Añadir marcador"),
      ),
      body: SingleChildScrollView(
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: fProvider.key,
          child: Column(
            children: [
              getTextFormField(fProvider.title, 'Título', 'Es necesario dar un título', true),
              getTextFormField(fProvider.description, 'Descripción','Es necesario dar una descripción', true),
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: getTextFormField(fProvider.latitude, 'Latitud', null, false)),
                  Expanded(
                    flex: 1,
                    child: getTextFormField(fProvider.longitude, 'Longitud', null, false),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.indigo,
                          ),
                          child: const Text("Añadir",
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            if (fProvider.key.currentState!.validate()) {
                              mProvider.addMarker(
                                MarkerMap(
                                  title: fProvider.title.value!,
                                  description: fProvider.description.value!,
                                  latitude: double.tryParse(fProvider.latitude.value!)!,
                                  longitude: double.tryParse(fProvider.longitude.value!)!
                                )
                              );
                              fProvider.clear();
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                      )),
                  Expanded(
                    flex: 1,
                    child: Container(
                        margin: const EdgeInsets.all(10),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.grey,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text(
                            "Cancelar",
                            style: TextStyle(color: Colors.white),
                          ),
                        )),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getTextFormField(Property value, String labelText, String? errorText, bool enabled) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: TextFormField(
        enabled: enabled,
        initialValue: value.value,
        onChanged: (v) => value.value = v,
        validator: (v) => enabled ? v!.trim().isEmpty ? errorText : null : null,
        decoration: getDecoration(labelText),
        style: TextStyle(color: enabled ? Colors.black : Colors.grey[700]),
      ),
    );
  }

  InputDecoration getDecoration(String text) {
    return InputDecoration(
      border: const UnderlineInputBorder(),
      labelText: text,
      labelStyle: const TextStyle(fontSize: 16),
    );
  }
}
