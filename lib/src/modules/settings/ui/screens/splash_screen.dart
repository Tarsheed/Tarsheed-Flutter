import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:tarsheed/home_page.dart';
import 'package:tarsheed/src/core/apis/api.dart';
import 'package:tarsheed/src/core/services/app_initializer.dart';
import 'package:tarsheed/src/modules/auth/ui/screens/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Widget nextScreen;
  @override
  void initState() {
    _initializeApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSplashScreen(
        duration: 3000,
        splash: Image.asset("assets/images/E-logo 1.png"),
        nextScreen: HomePage(),
        splashTransition: SplashTransition.fadeTransition,
        backgroundColor: Colors.white,
      ),
    );
  }

  Future<void> _initializeApp() async {
    await AppInitializer.init();
    nextScreen = _getNextScreen();
  }

  Widget _getNextScreen() {
    return ApiManager.userId != null ? HomePage() : LoginPage();
  }
}
