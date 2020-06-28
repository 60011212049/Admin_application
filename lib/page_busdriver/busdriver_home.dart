import 'package:adminapp/custom_icons.dart';
import 'package:adminapp/model/busdriver_model.dart';
import 'package:adminapp/page/loginPage.dart';
import 'package:adminapp/page_admin/admin_home.dart';
import 'package:adminapp/page_admin/manage_driver.dart';
import 'package:adminapp/page_busdriver/comment_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';

class BusdriverHome extends StatefulWidget {
  static List<BusdriverModel> busdriverModel = List<BusdriverModel>();

  @override
  _BusdriverHomeState createState() => _BusdriverHomeState();
}

class _BusdriverHomeState extends State<BusdriverHome> {
  List listSvg = [
    "star",
    "calendar",
  ];

  List listText = [
    "ความคิดเห็น",
    "ตาราการทำงาน",
  ];
  List<BusdriverModel> busdriverModel = BusdriverHome.busdriverModel;
  Size size;
  var _selection;
  bool checkWork = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[dashBgone, dashBg, content],
      ),
    );
  }

  get dashBgone => Container(
        color: Colors.white,
      );

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
            containerShowProfile(),
            grid,
          ],
        ),
      );

  get header => ListTile(
        contentPadding: EdgeInsets.only(left: 20, right: 20, top: 30),
        title: Text(
          'คนขับรถ',
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
                      'Bus Tracking Project',
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
                Icons1.cog_4,
                color: Color(0xFF3a3a3a),
                size: 30,
              ),
              backgroundColor: Colors.yellow[700],
            ),
          ),
          onTap: () {
            print('sdsd');
          },
        ),
      );

  Container containerShowProfile() {
    return Container(
      width: 300,
      child: Column(
        children: <Widget>[
          Container(
            height: 180,
            child: ClipOval(
              child: Image.asset(
                'asset/icons/userIcon.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(Icons1.user_4),
                Text('  :  '),
                Text(
                  busdriverModel[0].dName,
                  style: TextStyle(fontSize: 17),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(Icons1.directions_bus),
                Text('  :  '),
                Text(
                  'bus',
                  style: TextStyle(fontSize: 17),
                ),
              ],
            ),
          ),
          (checkWork == false)
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: RaisedButton(
                    padding: EdgeInsets.fromLTRB(75, 10, 0, 10),
                    child: Row(
                      children: <Widget>[
                        Text(
                          'เริ่มออกรถ',
                          style: TextStyle(
                            fontSize: 35,
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Icon(
                          Icons1.power_1,
                          size: 50,
                        )
                      ],
                    ),
                    color: Colors.red,
                    onPressed: () {
                      checkWork = true;
                      setState(() {});
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: RaisedButton(
                    padding: EdgeInsets.fromLTRB(90, 10, 0, 10),
                    child: Row(
                      children: <Widget>[
                        Text(
                          'หยุดรถ',
                          style: TextStyle(
                            fontSize: 35,
                          ),
                        ),
                        SizedBox(
                          width: 42,
                        ),
                        Icon(
                          Icons1.power_1,
                          size: 50,
                        )
                      ],
                    ),
                    color: Colors.green,
                    onPressed: () {
                      checkWork = false;
                      setState(() {});
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                  ),
                )
        ],
      ),
    );
  }

  get grid {
    return Expanded(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 0),
        child: GridView.count(
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          crossAxisCount: 2,
          children: List.generate(listText.length, (int x) {
            return Card(
              elevation: 6,
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
                          builder: (context) => CommentPage(),
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
                        child: Text(
                          listText[x],
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 22,
                          ),
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
