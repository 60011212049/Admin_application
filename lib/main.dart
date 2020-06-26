import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Stack(
            children: <Widget>[
              Text(
                'คนขับรถ',
                style: TextStyle(
                  fontSize: 20.0,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 3.5
                    ..color = Colors.black,
                ),
              ),
              Text(
                'คนขับรถ',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.yellow[700],
                ),
              ),
            ],
          ),
        ),
      ),
      /*drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text('Menu',style: TextStyle(fontSize: 30.0,),),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.yellow[700],
                border: Border.all(
                  width: 3,
                ),
              ),
            ),
            ListTile(
              title: Text('คนขับรถ',style: TextStyle(fontSize: 18.0,),),
              onTap: (){
                Navigator.pushNamed(context, '/home-page');
              },
            ),
            ListTile(
              title: Text('ความพึงพอใจต่อการใช้บริการ',style: TextStyle(fontSize: 18.0,),),
              onTap: (){
                Navigator.pushNamed(context, '/satisfaction-page');
              },
            ),
            ListTile(
              title: Text('ตารางการทำงานของคนขับ',style: TextStyle(fontSize: 18.0,),),
              onTap: (){

              },
            )
          ],
        ),
      ),*/
      body: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Image.asset(
                    'img/user.png',
                    width: 175.0,
                    height: 175.0,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FlatButton(
                        child: Text(
                          'แก้ไขข้อมูลส่วนตัว',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 18.0,
                          ),
                        ),
                        onPressed: () {}),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                          child: Stack(
                            children: <Widget>[
                              Text(
                                'ชื่อ : ',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 3
                                    ..color = Colors.black,
                                ),
                              ),
                              Text(
                                'ชื่อ : ',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 10, 0, 0),
                          child: Stack(
                            children: <Widget>[
                              Text(
                                'เบอร์โทร : ',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 3
                                    ..color = Colors.black,
                                ),
                              ),
                              Text(
                                'เบอร์โทร : ',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SizedBox(
                        width: 150.0,
                        height: 150.0,
                        child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              side: BorderSide(color: Colors.yellow[700]),
                            ),
                            color: Colors.yellow[200],
                            textColor: Colors.black,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    'img/star.png',
                                    width: 75.0,
                                    height: 75.0,
                                  ),
                                  Stack(
                                    children: <Widget>[
                                      Text(
                                        'ความพึงพอใจต่อการใช้บริการ',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          foreground: Paint()
                                            ..style = PaintingStyle.stroke
                                            ..strokeWidth = 0.75
                                            ..color = Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        'ความพึงพอใจต่อการใช้บริการ',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, '/satisfaction-page');
                            }),
                      ),
                      SizedBox(
                        width: 150.0,
                        height: 150.0,
                        child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              side: BorderSide(color: Colors.yellow[700]),
                            ),
                            color: Colors.yellow[200],
                            textColor: Colors.black,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    'img/calendar.png',
                                    width: 75.0,
                                    height: 75.0,
                                  ),
                                  Stack(
                                    children: <Widget>[
                                      Text(
                                        'ตารางการทำงานของคนขับ',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          foreground: Paint()
                                            ..style = PaintingStyle.stroke
                                            ..strokeWidth = 0.75
                                            ..color = Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        'ตารางการทำงานของคนขับ',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/worktable-page');
                            }),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    SizedBox(
                      width: 150.0,
                      height: 120.0,
                      child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            side: BorderSide(color: Colors.yellow[700]),
                          ),
                          color: Colors.yellow[200],
                          textColor: Colors.black,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                            child: Column(
                              children: <Widget>[
                                Image.asset(
                                  'img/logout.png',
                                  width: 75.0,
                                  height: 75.0,
                                ),
                                Stack(
                                  children: <Widget>[
                                    Text(
                                      'ออกจากระบบ',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        foreground: Paint()
                                          ..style = PaintingStyle.stroke
                                          ..strokeWidth = 0.75
                                          ..color = Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      'ออกจากระบบ',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          onPressed: () {
                            //Navigator.pushNamed(context, '/');
                          }),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
