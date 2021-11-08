/*
This is splash screen page
Don't forget to add all images and sound used in this pages at the pubspec.yaml
 */

import 'dart:async';

import 'package:logitracking/ui/login/signin.dart';
import 'package:universal_io/io.dart';

import 'package:logitracking/config/constant.dart';
import 'package:logitracking/ui/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logitracking/aws/aws-cognito/my_cognito_user_pool.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  Timer? _timer;
  int _second = 3; // set timer for 3 second and then direct to next page

  void _startTimer() {
    const period = Duration(seconds: 1);
    _timer = Timer.periodic(period, (timer) async {
      setState(() {
        _second--;
      });

      final prefs = await SharedPreferences.getInstance();
      final pool = MyCognitoUserPool(prefs);
      final user = await pool.getUser();
      if (_second == 0) {
        _cancelFlashsaleTimer();

        final credentials = await pool.getCredentials('userPool');


        final page = user == null ? const LoginPage() : const Home();
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => page), (Route<dynamic> route) => false);
      }
    });
  }

  void _cancelFlashsaleTimer() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }

  @override
  void initState() {
    // set status bar color to transparent and navigation bottom color to black21
    SystemChrome.setSystemUIOverlayStyle(
      Platform.isIOS?SystemUiOverlayStyle.light:const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.light
      ),
    );

    if(_second != 0){
      _startTimer();
    }
    super.initState();
  }

  @override
  void dispose() {
    _cancelFlashsaleTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WillPopScope(
          onWillPop: () {
            return Future.value(false);
          },
          child: Center(
            child: Image.asset('assets/images/splash_log1.png', height: 200),
          ),
        )
    );
  }
}
