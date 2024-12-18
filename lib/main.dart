import 'package:animator/Provider/space_provider.dart';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:provider/provider.dart';

import 'View/splash_screen.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PlanetProvider(),),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen()
      ),
    );
  }
}
