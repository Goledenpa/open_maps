import 'package:flutter/material.dart';
import 'package:open_maps/Provider/providers.dart';
import 'package:open_maps/Screen/screens.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MarkerProvider()),
        ChangeNotifierProvider(create: (_) => FormProvider()),
        ChangeNotifierProvider(create: (_) => GeolocationProvider())
      ],
      child: MaterialApp(
        theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(
                primarySwatch: Colors.indigo
            )
        ),
        routes: {
          HomeScreen.route : (_) => const HomeScreen(),
          DetailsScreen.route: (_) => const DetailsScreen()
        },
        initialRoute: HomeScreen.route,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
