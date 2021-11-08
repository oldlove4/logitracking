import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _HomeState();
}
class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  String _version = '1.0.0';
  late TabBar _tabBar;
  int _tabIndex = 0;
  late TabController _tabController;

  Future<void> _getSystemDevice() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = packageInfo.version;
    });
  }
  // this function is used for exit the application, user must click back button two times
  DateTime? _currentBackPressTime;
  Future<bool> _onWillPop() {
    DateTime now = DateTime.now();
    if (_currentBackPressTime == null || now.difference(_currentBackPressTime!) > const Duration(seconds: 2)) {
      _currentBackPressTime = now;
      Fluttertoast.showToast(msg: '뒤로가기 버튼을 한번 더 누르시면 앱을 종료합니다.', toastLength: Toast.LENGTH_SHORT);
      return Future.value(false);
    }
    return Future.value(true);
  }
  @override
  void initState() {
    // set navigation bar color to default color
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          systemNavigationBarColor: Color(0xFFF2F2F2),
          systemNavigationBarIconBrightness: Brightness.light
      ),
    );

    if(!kIsWeb){
      // StaticVarMethod.flutterLocalNotificationsPlugin.cancelAll();
      // // used for local notification on integration
      // if(!StaticVarMethod.isInitLocalNotif){
      //   StaticVarMethod.isInitLocalNotif = true;
      //   _initLocalNotification();
      // }
    }
    _getSystemDevice();
    // _tabController = TabController(vsync: this, length: _tabBarList.length, initialIndex: _tabIndex);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: const Text('hello word'),
      ),
    );
  }
}