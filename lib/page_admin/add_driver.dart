import 'dart:convert';
import 'dart:io';

import 'package:adminapp/custom_icons.dart';
import 'package:adminapp/model/busdriver_model.dart';
import 'package:adminapp/service/service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:http_parser/http_parser.dart';

class AddBusDriver extends StatefulWidget {
  @override
  _AddBusDriverState createState() => _AddBusDriverState();
}

class _AddBusDriverState extends State<AddBusDriver> {
  var status = {};
  var _usernamecontroller = TextEditingController();
  var _passwordcontroller = TextEditingController();
  var _emailcontroller = TextEditingController();
  var _namecontroller = TextEditingController();
  var _imagecontroller = TextEditingController();
  var _datecontroller = TextEditingController();
  var _gendercontroller = TextEditingController();
  var _tellcontroller = TextEditingController();
  File image;
  var bit;
  bool show = true;
  int id;
  String radioButtonItem;
  DateTime _dataTime = DateTime.now();

  Future<Map<String, dynamic>> _uploadImage() async {
    final mimeTypeData =
        lookupMimeType(image.path, headerBytes: [0xFF, 0xD8]).split('/');
    final imageUploadRequest = http.MultipartRequest(
        'POST', Uri.parse('http://' + Service.ip + '/controlModel/upload.php'));
    final file = await http.MultipartFile.fromPath('image', image.path,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
    imageUploadRequest.fields['ext'] = mimeTypeData[1];
    imageUploadRequest.files.add(file);
    print(mimeTypeData[0]);
    print(mimeTypeData[1]);
    print(image.path);
    print(file.filename);
    bit = file.filename;
    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode != 200) {
        Toast.show("ชื่อผู้ใช้ไม่สามารถใช้งานได้", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        return null;
      } else {
        var res = await _sentDataBusDriver();
        Toast.show("เพิ่มข้อมูลสำเร็จ", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      return responseData;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Null> _sentDataBusDriver() async {
    status['status'] = 'add';
    status['username'] = _usernamecontroller.text;
    status['password'] = _passwordcontroller.text;
    status['name'] = _namecontroller.text;
    if (id == 1) {
      _gendercontroller.text = 'male';
    } else {
      _gendercontroller.text = 'female';
    }
    status['sex'] = _gendercontroller.text;
    status['tell'] = _tellcontroller.text;
    status['email'] = _emailcontroller.text;
    status['date'] = _dataTime.toString();
    if (bit == null) {
      status['image'] = _imagecontroller.text;
    } else {
      status['image'] = bit;
    }
    String jsonSt = json.encode(status);
    var response = await http.post(
        'http://' + Service.ip + '/controlModel/busdriver_model.php',
        body: jsonSt,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    print(response.statusCode.toString() + ' ' + response.body.toString());
    if (response.statusCode == 200) {
      if (response.body.toString() == 'Bad') {
        setState(() {
          Toast.show("ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        });
      } else {
        Toast.show("แก้ไขข้อมูลสำเร็จ", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        bit = '';
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
        'เพิ่มข้อมูลคนขับรถ',
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
                    Container(
                      height: 230,
                      width: 320,
                      child: Wrap(
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              (image != null)
                                  ? Center(
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxHeight: 230,
                                        ),
                                        child: Image.file(
                                          image,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    )
                                  : Center(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            5, 10, 5, 10),
                                        child: CircleAvatar(
                                          backgroundImage: ExactAssetImage(
                                              'asset/icons/student.png'),
                                          radius: 110,
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(
                            onPressed: () async {
                              var img;
                              try {
                                img = await ImagePicker.pickImage(
                                    source: ImageSource.camera);
                                image = img;
                              } catch (e) {}

                              setState(() {});
                            },
                            colorBrightness: Brightness.light,
                            padding: EdgeInsets.all(10.0),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.camera_alt,
                                  color: Colors.grey[700],
                                ),
                                Divider(),
                                Container(
                                  width: 10,
                                ),
                                Text(
                                  'ถ่ายรูป',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 22.0,
                                  ),
                                ),
                              ],
                            )),
                        VerticalDivider(),
                        Container(
                          width: 2,
                          height: 40,
                          color: Colors.grey,
                        ),
                        VerticalDivider(),
                        FlatButton(
                          onPressed: () async {
                            var img;
                            try {
                              img = await ImagePicker.pickImage(
                                  source: ImageSource.gallery);
                              image = img;
                            } catch (e) {}

                            setState(() {});
                          },
                          colorBrightness: Brightness.light,
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            // Replace with a Row for horizontal icon + text
                            children: <Widget>[
                              Icon(
                                Icons1.picture_3,
                                color: Colors.grey[700],
                              ),
                              Divider(),
                              Container(
                                width: 10,
                              ),
                              Text(
                                'แกลลอรี่',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 22.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    //******************       username         ************** */
                    Column(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                            child: Container(
                              child: TextField(
                                style: TextStyle(fontSize: 22.0, height: 1.0),
                                decoration: InputDecoration(
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
                              decoration: InputDecoration(
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
                        Padding(
                          padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                          child: Container(
                            child: TextField(
                              style: TextStyle(fontSize: 22.0, height: 1.0),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'ชื่อ นามสกุล',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 22.0,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0))),
                                prefixIcon: Icon(Icons.verified_user),
                              ),
                              controller: _namecontroller,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey[600],
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20.0),
                                ),
                                color: Colors.white),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Icon(
                                    Icons1.user_male,
                                    color: Colors.grey[500],
                                  ),
                                  Container(
                                    width: 12,
                                  ),
                                  Text(
                                    'เพศ',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Quark',
                                    ),
                                  ),
                                  Radio(
                                    value: 1,
                                    groupValue: id,
                                    onChanged: (val) {
                                      setState(() {
                                        radioButtonItem = 'คนขับรถ';
                                        id = 1;
                                      });
                                    },
                                  ),
                                  Text(
                                    'ชาย',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Quark',
                                    ),
                                  ),
                                  Radio(
                                    value: 2,
                                    groupValue: id,
                                    onChanged: (val) {
                                      setState(() {
                                        radioButtonItem = 'ผู้ดูแลระบบ';
                                        id = 2;
                                      });
                                    },
                                  ),
                                  Text(
                                    'หญิง',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Quark',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        //******************       email         ************** */
                        Padding(
                          padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                          child: Container(
                            child: TextField(
                              style: TextStyle(fontSize: 22.0, height: 1.0),
                              decoration: InputDecoration(
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
                            height: 60,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey[600],
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20.0),
                                ),
                                color: Colors.white),
                            child: InkWell(
                              onTap: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: _dataTime,
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime(2030),
                                ).then((value) {
                                  setState(() {
                                    _dataTime = value;
                                  });
                                });
                              },
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 11),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons1.calendar_3,
                                        color: Colors.grey[500],
                                      ),
                                      Container(
                                        width: 12,
                                      ),
                                      (_dataTime == null)
                                          ? Text('วันเดือนปี',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 22,
                                              ))
                                          : Text(
                                              _dataTime.day.toString() +
                                                  '/' +
                                                  _dataTime.month.toString() +
                                                  '/' +
                                                  _dataTime.year.toString(),
                                              style: TextStyle(
                                                color: Colors.grey[800],
                                                fontSize: 22,
                                              )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                          child: Container(
                            child: TextField(
                              style: TextStyle(fontSize: 22.0, height: 1.0),
                              maxLength: 10,
                              decoration: InputDecoration(
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
                              try {
                                if (image == null) {
                                  _sentDataBusDriver();
                                } else {
                                  final Map<String, dynamic> response =
                                      await _uploadImage();
                                }
                              } catch (e) {}
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
