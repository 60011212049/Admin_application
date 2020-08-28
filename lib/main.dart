import 'package:adminapp/page/loginPage.dart';
import 'package:adminapp/page/splash_screen.dart';
import 'package:adminapp/page_admin/admin_home.dart';
import 'package:adminapp/page_busdriver/busdriver_home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Quark',
        primaryColor: Colors.yellow[700],
      ),
      home: SplashPage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 5,
      title: new Text(
        'Welcome In SplashScreen',
        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
      navigateAfterSeconds: LogingPage(),
      image: new Image.network(
          'https://flutter.io/images/catalog-widget-placeholder.png'),
      backgroundColor: Colors.white,
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 100.0,
      onClick: () => print("Flutter Egypt"),
      loaderColor: Colors.red,
    );
  }
}
