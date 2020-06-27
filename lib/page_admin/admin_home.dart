import 'package:adminapp/custom_icons.dart';
import 'package:adminapp/model/admin_model.dart';
import 'package:flutter/material.dart';

class AdminHome extends StatefulWidget {
  static List<AdminModel> adminModel = List<AdminModel>();

  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  Size size;
  List listText = [
    "ข้อมูลคนขับรถ",
    "จุดรับส่งผู้โดยสาร",
    "ตารางการเดินรถ",
    "ความคิดเห็น",
    "ตำแหน่งปัจจุบันของรถ",
  ];
  List<Icon> listIcon = [
    Icon(Icons.person),
  ];
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
          'Dashboard',
          style: TextStyle(color: Color(0xFF3a3a3a), fontSize: 30),
        ),
        subtitle: Container(
          child: Row(
            children: <Widget>[
              InkWell(
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.edit,
                      size: 18,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'แก้ไขข้อมูลโปรไฟล์',
                      style: TextStyle(color: Color(0xFF3a3a3a), fontSize: 15),
                    ),
                  ],
                ),
                onTap: () {
                  print('object');
                },
              ),
            ],
          ),
        ),
        trailing: CircleAvatar(
          child: Icon(
            Icons1.person,
            color: Color(0xFF3a3a3a),
          ),
          backgroundColor: Colors.white,
        ),
      );

  get grid {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
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
                  print('object');
                },
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons1.access_alarms,
                        size: 40,
                        color: Colors.grey[800],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5, top: 10),
                        child: (x == listText.length-1) ? Container() : Text(
                          'จัดการ',
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 22,
                          ),
                        ) 
                      ),
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
