import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import 'package:prozone/screens/intro/splash_screen.dart';
import 'package:prozone/screens/providers/provider-listings.dart';
import 'package:prozone/services/main-service.dart';
import 'package:prozone/utils/class_builder.dart';

void main() {
  registerClasses();
  runApp(ChangeNotifierProvider(
      create: (context) => MainAppProvider(), child: MyApp()));
}

void registerClasses() {
  register<ProviderListings>(() => ProviderListings());
  // register<TransactionLogs>(() => TransactionLogs());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
        child: MaterialApp(
      title: 'ProZone',
      theme: ThemeData(
        fontFamily: 'Charlie',
        primaryColor: Color(0xff0047ff),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
    ));
  }
}
