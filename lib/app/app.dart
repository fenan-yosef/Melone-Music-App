import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      home: LoginPage(), // Set LoginPage as the home page
      // initialRoute: Routes.initial,
      // routes: Routes.routes,
    );
    
  }
}
