import 'package:flutter/material.dart';

class FormProvider with ChangeNotifier {
  GlobalKey<FormState> key = GlobalKey<FormState>();

  Property title = Property();
  Property description = Property();
  Property latitude = Property();
  Property longitude = Property();

  clear() {
    title = Property();
    description = Property();
    latitude = Property();
    longitude = Property();
  }
}

class Property {
  String? value;
}
