import 'dart:convert';
import 'dart:io';

import 'package:adminapp/service/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

class AddComment extends StatefulWidget {
  @override
  _AddCommentState createState() => _AddCommentState();
}

class _AddCommentState extends State<AddComment> {
  double ratingTrue;
  var _namecontroller = TextEditingController();
  var _detailcontroller = TextEditingController();

  Future addTransciption(String id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var status = {};
    status['status'] = 'add';
    status['aid'] = pref.getInt('tokenId');
    status['type'] = 'เพิ่มข้อมูลรีวิว ' + id;
    status['time'] = DateTime.now().toString();
    String jsonSt = json.encode(status);
    var response = await http.post(
        'http://' + Service.ip + '/controlModel/transcription_model.php',
        body: jsonSt,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
  }

  Future sentDataComment() async {
    var status = {};
    status['status'] = 'add';
    if (_namecontroller.text == '') {
      status['name'] = 'No name';
    } else {
      status['name'] = _namecontroller.text;
    }
    status['detail'] = _detailcontroller.text;
    status['point'] = ratingTrue.toString();
    String jsonSt = json.encode(status);
    var response = await http.post(
        'http://' + Service.ip + '/controlModel/comment_model.php',
        body: jsonSt,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    print(response.statusCode.toString() + ' ' + response.body.toString());
    if (response.statusCode == 200) {
      if (response.body.toString() == 'Bad') {
        setState(() {
          Toast.show("เพิ่มข้อมูลไม่สำเร็จ", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        });
      } else {
        Toast.show("เพิ่มข้อมูลสำเร็จ", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        addTransciption(_detailcontroller.text);
        Navigator.pop(context);
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'เพิ่มความคิดเห็น',
          style: TextStyle(
            color: Color(0xFF3a3a3a),
            fontSize: ScreenUtil().setSp(60),
          ),
        ),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 10, 0, 0),
                      child: Text(
                        'คะแนนการรีวิวการใช้งาน',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(65),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: RatingBar(
                            initialRating: 0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            unratedColor: Colors.grey[300],
                            onRatingUpdate: (rating) {
                              print(rating);
                              ratingTrue = rating;
                            },
                          ),
                        )
                      ],
                    ),
                    Divider(
                      height: 5,
                      color: Colors.black,
                    ),
                    Container(
                      height: 20,
                    ),
                    Container(
                      height: ScreenUtil().setHeight(250),
                      child: TextField(
                        maxLength: 20,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(50),
                        ),
                        decoration: InputDecoration(
                          labelText: 'ชื่อเล่น',
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'ชื่อเล่น',
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                          ),
                        ),
                        controller: _namecontroller,
                      ),
                    ),
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: TextField(
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(50),
                          ),
                          decoration: InputDecoration(
                            labelText: 'ข้อความ',
                            labelStyle: TextStyle(
                              fontSize: ScreenUtil().setSp(50),
                            ),
                            hintText: 'ข้อความ',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                            ),
                          ),
                          keyboardType: TextInputType.multiline,
                          maxLines: 8,
                          maxLength: 500,
                          controller: _detailcontroller,
                        ),
                      ),
                    ),
                    Container(
                      height: ScreenUtil().setHeight(50),
                    ),
                    Center(
                      child: ButtonTheme(
                        minWidth: 250.0,
                        height: 60.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            shape: new RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(23.0),
                            ),
                            color: Colors.blue[700],
                            child: Text(
                              "เพิ่มความคิดเห็น",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 27.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Quark',
                              ),
                            ),
                            onPressed: () {
                              print(_namecontroller.text);
                              print(_detailcontroller.text);

                              setState(() {
                                sentDataComment();
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
