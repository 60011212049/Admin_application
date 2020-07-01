import 'package:adminapp/custom_icons.dart';
import 'package:adminapp/model/admin_model.dart';
import 'package:adminapp/page/loginPage.dart';
import 'package:adminapp/page_admin/manage_bus_schedule.dart';
import 'package:adminapp/page_admin/manage_busstop.dart';
import 'package:adminapp/page_admin/manage_comment.dart';
import 'package:adminapp/page_admin/manage_driver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';

class AdminHome extends StatefulWidget {
  static List<AdminModel> adminModel = List<AdminModel>();

  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  List listSvg = [
    "avatar",
    "bus-stop",
    "calendar",
    "star",
    "bus1",
  ];

  List listText = [
    "ข้อมูลคนขับรถ",
    "จุดรับส่งผู้โดยสาร",
    "ตารางการเดินรถ",
    "ความคิดเห็น",
    "ตำแหน่งปัจจุบันของรถ",
  ];

  Size size;
  var _selection;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[dashBg, content],
      ),
    );
  }

  get dashBg => Container(
        child: CustomPaint(
          painter: ShapesPainter(),
          child: Container(
            height: 350,
          ),
        ),
      );

  get content => Container(
        child: Column(
          children: <Widget>[
            header,
            grid,
          ],
        ),
      );

  get header => ListTile(
        contentPadding: EdgeInsets.only(left: 20, right: 20, top: 30),
        title: Text(
          'ผู้ดูแลระบบ',
          style: TextStyle(color: Color(0xFF3a3a3a), fontSize: 37),
        ),
        subtitle: Container(
          child: Row(
            children: <Widget>[
              InkWell(
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons1.directions_bus,
                      size: 18,
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    Text(
                      'MSU BusTracking Project',
                      style: TextStyle(color: Color(0xFF3a3a3a), fontSize: 15),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        trailing: InkWell(
          child: PopupMenuButton<String>(
            onSelected: (String value) {
              setState(() {
                _selection = value;
                if (value == 'Value1') {
                } else if (value == 'Value2') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LogingPage(),
                    ),
                  );
                }
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Value1',
                child: ListTile(
                  title: Text('แก้ไขข้อมูลโปรไฟล์'),
                  trailing: Icon(Icons.edit),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'Value2',
                child: ListTile(
                  title: Text('ออกจากระบบ'),
                  trailing: Icon(Icons1.logout_2),
                ),
              ),
            ],
            child: CircleAvatar(
              child: Icon(
                Icons1.person,
                color: Color(0xFF3a3a3a),
              ),
              backgroundColor: Colors.white,
            ),
          ),
          onTap: () {
            print('sdsd');
          },
        ),
      );

  get grid {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 0),
        child: GridView.count(
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          crossAxisCount: 2,
          children: List.generate(listText.length, (int x) {
            return Card(
              elevation: 10,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                side: BorderSide(color: Colors.white),
              ),
              child: InkWell(
                onTap: () {
                  print('object ');
                  if (x == 0) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ManageDriver(),
                        ));
                  }
                  if (x == 1) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ManageBusstop(),
                        ));
                  }
                  if (x == 2) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ManageBusSchedule(),
                        ));
                  }
                  if (x == 3) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CommentPageAdmin(),
                        ));
                  }
                  if (x == 4) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ManageDriver(),
                        ));
                  }
                },
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image(
                        image:
                            Svg('asset/svg/' + listSvg[x] + '.svg', height: 60),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(bottom: 5, top: 10),
                          child: (x == listText.length - 1)
                              ? Container()
                              : Text(
                                  'จัดการ',
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 22,
                                  ),
                                )),
                      Text(
                        listText[x],
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class ShapesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    // set the paint color to be white
    paint.color = Colors.white;
    // Create a rectangle with size and width same as the canvas
    var rect = Rect.fromLTWH(0, 0, size.width, size.height);
    // draw the rectangle using the paint
    canvas.drawRect(rect, paint);
    paint.color = Colors.yellow[700];
    // create a path
    var path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height / 4);
    path.lineTo(size.width, 0);
    // close the path to form a bounded shape
    path.close();
    canvas.drawPath(path, paint);
    /* // set the color property of the paint
    paint.color = Colors.deepOrange;
    // center of the canvas is (x,y) => (width/2, height/2)
    var center = Offset(size.width / 2, size.height / 2);
    // draw the circle with center having radius 75.0
    canvas.drawCircle(center, 75.0, paint);*/
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
