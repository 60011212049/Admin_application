import 'dart:convert';
import 'dart:io';

import 'package:adminapp/custom_icons.dart';
import 'package:adminapp/model/admin_model.dart';
import 'package:adminapp/service/service.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class AddAdmin extends StatefulWidget {
  @override
  _AddAdminState createState() => _AddAdminState();
}

class _AddAdminState extends State<AddAdmin> {
  var status = {};
  var _usernamecontroller = TextEditingController();
  var _passwordcontroller = TextEditingController();
  var _emailcontroller = TextEditingController();
  var _tellcontroller = TextEditingController();
  List<AdminModel> admin = List<AdminModel>();
  bool userB = false, passB = false, emailB = false, tellB = false;

  Future<Null> addTransciption() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    status['status'] = 'add';
    status['aid'] = pref.getInt('tokenId');
    status['type'] = 'เพิ่มข้อมูลผู้ดูแล ' + _usernamecontroller.text;
    status['time'] = DateTime.now().toString();
    String jsonSt = json.encode(status);
    var response = await http.post(
        'http://' + Service.ip + '/controlModel/transcription_model.php',
        body: jsonSt,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
  }

  Future<Null> sentDataAdmin() async {
    var status = {};
    status['status'] = 'add';
    status['username'] = _usernamecontroller.text;
    status['password'] = _passwordcontroller.text;
    status['tell'] = _tellcontroller.text;
    status['email'] = _emailcontroller.text;
    String jsonSt = json.encode(status);
    var response = await http.post(
        'http://' + Service.ip + '/controlModel/admin_model.php',
        body: jsonSt,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    if (response.statusCode == 200) {
      if (response.body.toString() == 'Bad') {
        setState(() {
          Toast.show("ชื่อผู้ใช้ไม่สามารถใช้งานได้", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        });
      } else {
        Toast.show("เพิ่มข้อมูลสำเร็จ", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        addTransciption();
        Navigator.pop(context);
      }
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'เพิ่มข้อมูลผู้ดูแล',
        textScaleFactor: 1.2,
        style: TextStyle(
          color: Color(0xFF3a3a3a),
        ),
      )),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: ListView.builder(
            itemCount: 1,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.all(5),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Container(
                        height: 230,
                        width: 320,
                        child: Wrap(
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Center(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 10, 5, 10),
                                    child: CircleAvatar(
                                      backgroundImage: ExactAssetImage(
                                          'asset/icons/admin.png'),
                                      radius: 110,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    //******************       username         ************** */
                    Column(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                            child: Container(
                              child: TextField(
                                style: TextStyle(fontSize: 22.0, height: 1.0),
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    userB = false;
                                  }
                                  setState(() {});
                                },
                                decoration: InputDecoration(
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 2,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                  ),
                                  errorStyle: TextStyle(fontSize: 16),
                                  errorText: userB == true
                                      ? 'กรุณากรอกชื่อผู้ใช้งาน'
                                      : null,
                                  labelText: 'ชื่อผู้ใช้งาน',
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: 'ชื่อผู้ใช้งาน',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 22.0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                  ),
                                  prefixIcon: Icon(Icons1.user_5),
                                ),
                                controller: _usernamecontroller,
                              ),
                            )),
                        Padding(
                          padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                          child: Container(
                            child: TextField(
                              style: TextStyle(fontSize: 22.0, height: 1.0),
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  passB = false;
                                  setState(() {});
                                }
                              },
                              decoration: InputDecoration(
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                    width: 2,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                errorStyle: TextStyle(fontSize: 16),
                                errorText:
                                    passB == true ? 'กรุณากรอกรหัสผ่าน' : null,
                                labelText: 'รหัสผ่าน',
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'รหัสผ่าน',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 22.0,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0))),
                                prefixIcon: Icon(Icons1.key_2),
                              ),
                              controller: _passwordcontroller,
                            ),
                          ),
                        ),
                        //******************       email         ************** */
                        Padding(
                          padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                          child: Container(
                            child: TextField(
                              style: TextStyle(fontSize: 22.0, height: 1.0),
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  emailB = false;
                                  setState(() {});
                                }
                              },
                              decoration: InputDecoration(
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                    width: 2,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                errorStyle: TextStyle(fontSize: 16),
                                errorText: emailB == true
                                    ? 'กรุณากรอกอีเมลล์ให้ถูกต้อง'
                                    : null,
                                labelText: 'อีเมล์',
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'อีเมล์',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 22.0,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0))),
                                prefixIcon: Icon(Icons1.email),
                              ),
                              controller: _emailcontroller,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                          child: Container(
                            child: TextField(
                              style: TextStyle(fontSize: 22.0, height: 1.0),
                              maxLength: 10,
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  tellB = false;
                                  setState(() {});
                                }
                              },
                              decoration: InputDecoration(
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                    width: 2,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                errorStyle: TextStyle(fontSize: 16),
                                errorText: tellB == true
                                    ? 'กรุณากรอกเบอร์โทรศัพท์ให้ถูกต้อง'
                                    : null,
                                labelText: 'เบอร์โทร',
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'เบอร์โทร',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 22.0,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0))),
                                prefixIcon: Icon(Icons1.phone_1),
                              ),
                              keyboardType: TextInputType.phone,
                              controller: _tellcontroller,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        ButtonTheme(
                          minWidth: 250.0,
                          height: 60.0,
                          child: RaisedButton(
                            shape: new RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(23.0),
                            ),
                            color: Colors.blue[700],
                            child: Text(
                              "ยืนยันการเพิ่มข้อมูล",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 27.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Quark',
                              ),
                            ),
                            onPressed: () async {
                              if (_usernamecontroller.text.isEmpty) {
                                userB = true;
                              }
                              if (_passwordcontroller.text.isEmpty) {
                                passB = true;
                              }
                              if (_emailcontroller.text.isEmpty ||
                                  EmailValidator.validate(
                                          _emailcontroller.text) !=
                                      true) {
                                emailB = true;
                              }
                              if (_tellcontroller.text.isEmpty ||
                                  _tellcontroller.text.length != 10) {
                                tellB = true;
                              }
                              if (userB == false &&
                                  passB == false &&
                                  (emailB == false) &&
                                  tellB == false) {
                                sentDataAdmin();
                              } else
                                Toast.show("กรุณากรอกข้อมูลให้ครบ", context,
                                    duration: Toast.LENGTH_LONG,
                                    gravity: Toast.BOTTOM);
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                    //******************       password         ************** */
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
