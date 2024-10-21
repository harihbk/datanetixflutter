import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pos/app/app.dialogs.dart';
import 'package:pos/app/app.locator.dart';
import 'package:pos/app/app.router.dart';
import 'package:pos/statemanagement/globalstore.dart';
import 'package:pos/themes/main_theme.dart';
import 'package:pos/ui/views/auth/auth_view.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  setupDialogUi();
  Get.put(GlobalStoreController());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSplashVisible = true;

  @override
  void initState() {
    super.initState();

    // Simulate a delay for the splash screen (optional)
    Timer(const Duration(seconds: 3), () {
      setState(() {
        _isSplashVisible = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sapphire POS',
      theme: MainTheme.lightTheme,
      home: _isSplashVisible ? _buildSplashScreen() : const AuthView(),
      onGenerateRoute: StackedRouter().onGenerateRoute,
      navigatorKey: StackedService.navigatorKey,
      navigatorObservers: [
        StackedService.routeObserver,
      ],
    );
  }

  Widget _buildSplashScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('assets/images/icon.png'),
      ),
    );
  }
}
