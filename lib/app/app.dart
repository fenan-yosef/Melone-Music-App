import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../features/music_feed/music_feed_page.dart';
import './routes.dart';
import '../features/authentication/login/login_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Melone Music',
      theme: ThemeData(
        // Define your app's theme here
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeFeed(), //LoginPage(),
      // initialRoute: Routes.initial,
      // routes: Routes.routes,
    );
    
  }
}
