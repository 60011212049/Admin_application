import 'package:adminapp/page_admin/page_assesment.dart';
import 'package:adminapp/page_admin/page_evaluation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ManageAssesment extends StatefulWidget {
  @override
  _ManageAssesmentState createState() => _ManageAssesmentState();
}

class _ManageAssesmentState extends State<ManageAssesment> {
  List listSvg = [
    "taxi-driver",
    "admin",
  ];

  List listText = [
    "ผลการประเมิน",
    "แบบประเมิน",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ผลการประเมิน',
          style: TextStyle(
            color: Color(0xFF3a3a3a),
            fontSize: ScreenUtil().setSp(60),
          ),
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: ScreenUtil().setWidth(500),
                  height: ScreenUtil().setHeight(500),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: Card(
                      elevation: 10,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        side: BorderSide(color: Colors.white),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PageEvaluation(),
                              )).then((value) {});
                        },
                        child: Center(
                          child: Wrap(
                            children: <Widget>[
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    height: ScreenUtil().setHeight(160),
                                    child: Image(
                                      image: AssetImage(
                                          'asset/icons/feedback.png'),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 5, top: 10),
                                  ),
                                  Text(
                                    'ผลประเมิน',
                                    style: TextStyle(
                                      color: Colors.grey[800],
                                      fontSize: ScreenUtil().setSp(57,
                                          allowFontScalingSelf: true),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: ScreenUtil().setWidth(500),
                  height: ScreenUtil().setHeight(500),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: Card(
                      elevation: 10,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        side: BorderSide(color: Colors.white),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PageAssesment(),
                              )).then((value) {});
                        },
                        child: Center(
                          child: Wrap(
                            children: <Widget>[
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    height: ScreenUtil().setHeight(160),
                                    child: Image(
                                      image: AssetImage(
                                          'asset/icons/register.png'),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 5, top: 10),
                                  ),
                                  Text(
                                    'แบบประเมิน',
                                    style: TextStyle(
                                      color: Colors.grey[800],
                                      fontSize: ScreenUtil().setSp(57,
                                          allowFontScalingSelf: true),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
