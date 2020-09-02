import 'dart:async';

import 'package:adminapp/page/loginPage.dart';
import 'package:adminapp/page_admin/admin_home.dart';
import 'package:adminapp/page_busdriver/busdriver_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  SharedPreferences logindata;
  void checkLogin() async {
    logindata = await SharedPreferences.getInstance();
    var idToken = logindata.getInt('tokenId');
    var typeToken = logindata.getString('tokenType');
    print(idToken.toString() + ' ' + typeToken.toString());
    if (idToken != null && typeToken.toString() == 'admin') {
      Navigator.pushReplacement(
        context,
        new MaterialPageRoute(
          builder: (context) => AdminHome(),
        ),
      );
    } else if (idToken != null && typeToken.toString() == 'driver') {
      Navigator.pushReplacement(
        context,
        new MaterialPageRoute(
          builder: (context) => BusdriverHome(),
        ),
      );
    } else {
      // login = true;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        width: 1080, height: 1920, allowFontScaling: false);
    return Scaffold(
      body: initScreen(context),
    );
  }

  startTime() async {
    var duration = new Duration(seconds: 5);
    logindata = await SharedPreferences.getInstance();
    var idToken = logindata.getInt('tokenId');
    var typeToken = logindata.getString('tokenType');
    print(idToken.toString() + ' ' + typeToken.toString());
    if (idToken != null && typeToken.toString() == 'admin') {
      return Timer(duration, routeAdmin);
    } else if (idToken != null && typeToken.toString() == 'driver') {
      return Timer(duration, routeDriver);
    } else {
      return Timer(duration, routeLogin);
    }
  }

  routeLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LogingPage(),
      ),
    );
  }

  routeAdmin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AdminHome(),
      ),
    );
  }

  routeDriver() {
    Navigator.pushReplacement(
      context,
      new MaterialPageRoute(
        builder: (context) => BusdriverHome(),
      ),
    );
  }

  initScreen(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("asset/icons/2.png"),
            fit: BoxFit.fill,
            alignment: Alignment.bottomCenter,
          ),
          color: Colors.grey[700],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 200, 0, 0),
                child: Container(
                  height: 200,
                  width: 200,
                  child: Image.asset(
                    "asset/icons/msubusnew.png",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              // Text(
              //   "Splash Screen",
              //   style: TextStyle(fontSize: 20.0, color: Colors.white),
              // ),
              // CircularProgressIndicator(
              //   backgroundColor: Colors.white,
              //   strokeWidth: 1.5,
              // )
            ],
          ),
        ),
      ),
    );
  }
}
