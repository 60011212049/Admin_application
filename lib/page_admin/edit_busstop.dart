import 'dart:convert';
import 'dart:io';

import 'package:adminapp/custom_icons.dart';
import 'package:adminapp/model/busstop_model.dart';
import 'package:adminapp/service/service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

import 'package:http_parser/http_parser.dart';

// ignore: must_be_immutable
class EditBusstop extends StatefulWidget {
  BusstopModel x;
  EditBusstop(BusstopModel did) {
    this.x = did;
  }

  @override
  _EditBusstopState createState() => _EditBusstopState(x);
}

class _EditBusstopState extends State<EditBusstop> {
  var status = {};
  var _namecontroller = TextEditingController();
  var _imagecontroller = TextEditingController();
  var _latitudecontroller = TextEditingController();
  var _longitudecontroller = TextEditingController();
  File image;
  var bit;
  Location location = Location();
  LocationData locatNow;
  BusstopModel busstop;
  bool loadImage = false;

  _EditBusstopState(BusstopModel x) {
    this.busstop = x;
  }
  @override
  void initState() {
    super.initState();
    setState(() {
      setText();
    });
  }

  void setText() {
    _namecontroller.text = busstop.sName;
    _latitudecontroller.text = busstop.sLongitude;
    _longitudecontroller.text = busstop.sLatitude;
    _imagecontroller.text = busstop.sImage;
  }

  Future<Null> addTransciption() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    status['status'] = 'add';
    status['aid'] = pref.getInt('tokenId');
    status['type'] = 'แก้ไขข้อมูลจุดรับส่ง ' + _namecontroller.text;
    status['time'] = DateTime.now().toString();
    String jsonSt = json.encode(status);
    var response = await http.post(
        'http://' + Service.ip + '/controlModel/transcription_model.php',
        body: jsonSt,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
  }

  Future<Map<String, dynamic>> _uploadImage() async {
    final mimeTypeData =
        lookupMimeType(image.path, headerBytes: [0xFF, 0xD8]).split('/');
    final imageUploadRequest = http.MultipartRequest(
        'POST', Uri.parse('http://' + Service.ip + '/controlModel/upload.php'));
    final file = await http.MultipartFile.fromPath('image', image.path,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
    imageUploadRequest.fields['ext'] = mimeTypeData[1];
    imageUploadRequest.files.add(file);
    bit = file.filename;
    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode != 200) {
        Toast.show("ไม่สามารถแก้ไขข้อมูลได้", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        return null;
      } else {
        var res = await _sentDataBusstop();
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

  Future<void> _sentDataBusstop() async {
    status['status'] = 'edit';
    status['id'] = busstop.sid;
    status['name'] = _namecontroller.text;
    status['latitude'] = _latitudecontroller.text;
    status['longitude'] = _longitudecontroller.text;
    if (bit == null) {
      status['image'] = _imagecontroller.text;
    } else {
      status['image'] = bit;
    }
    String jsonSt = json.encode(status);
    print(jsonSt);
    var response = await http.post(
        'http://' + Service.ip + '/controlModel/busstop_model.php',
        body: jsonSt,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    if (response.statusCode == 200) {
      if (response.body.toString() == 'Bad') {
        setState(() {
          Toast.show("ไม่สามารถแก้ไขข้อมูลได้", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        });
      } else {
        Toast.show("แก้ไขข้อมูลสำเร็จ", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        bit = '';
        addTransciption();
        Navigator.pop(context);
      }
    } else {
      Toast.show("ไม่สามารถแก้ไขข้อมูลได้", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'เพิ่มข้อมูลจุดรับส่ง',
          style: TextStyle(
            color: Color(0xFF3a3a3a),
            fontSize: ScreenUtil().setSp(60),
          ),
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
          child: ListView(
            children: <Widget>[
              Column(
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
                                : (_imagecontroller.text != '')
                                    ? Center(
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxWidth: 300,
                                            maxHeight: 200,
                                          ),
                                          child: Image.network(
                                            'http://' +
                                                Service.ip +
                                                '/controlModel/showImage.php?name=' +
                                                _imagecontroller.text,
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                      )
                                    : Center(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              5, 10, 5, 10),
                                          child: Container(
                                            child: Image.asset(
                                                'asset/icons/bus-stop1.png'),
                                            height: ScreenUtil().setHeight(530),
                                          ),
                                        ),
                                      )
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: TextField(
                            style: TextStyle(fontSize: 22.0, height: 1.0),
                            decoration: InputDecoration(
                              labelText: 'ชื่อจุดรับส่ง',
                              filled: true,
                              fillColor: Colors.white,
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 22.0,
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                              ),
                              prefixIcon: Icon(Icons1.pin_1),
                            ),
                            controller: _namecontroller,
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setSp(30),
                        ),
                        Container(
                          child: TextField(
                            style: TextStyle(
                              fontSize: 22.0,
                              height: 1.0,
                            ),
                            decoration: InputDecoration(
                              labelText: 'ละติจูด',
                              filled: true,
                              fillColor: Colors.white,
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: ScreenUtil().setSp(50),
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                              ),
                              prefixIcon: Icon(Icons.pin_drop),
                            ),
                            controller: _latitudecontroller,
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setSp(30),
                        ),
                        Container(
                          child: TextField(
                            style: TextStyle(
                              fontSize: 22.0,
                              height: 1.0,
                            ),
                            decoration: InputDecoration(
                              labelText: 'ลองจิจูด',
                              filled: true,
                              fillColor: Colors.white,
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: ScreenUtil().setSp(50),
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                              ),
                              prefixIcon: Icon(Icons.pin_drop),
                            ),
                            controller: _longitudecontroller,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'เลือกใส่ตำแหน่งปัจจุบัน กดปุ่มนี้',
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(45),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.add_location,
                                color: Colors.red,
                              ),
                              onPressed: () async {
                                locatNow = await location.getLocation();
                                _latitudecontroller.text =
                                    locatNow.latitude.toString();
                                _longitudecontroller.text =
                                    locatNow.longitude.toString();
                                setState(() {});
                              },
                            )
                          ],
                        ),
                        SizedBox(
                          height: ScreenUtil().setSp(30),
                        ),
                        ButtonTheme(
                          minWidth: ScreenUtil().setWidth(650),
                          height: ScreenUtil().setHeight(170),
                          child: RaisedButton(
                            shape: new RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(23.0),
                            ),
                            color: Colors.blue[700],
                            child: Text(
                              "ยืนยันการเพิ่มข้อมูล",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: ScreenUtil().setSp(70),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Quark',
                              ),
                            ),
                            onPressed: () async {
                              try {
                                if (image == null) {
                                  _sentDataBusstop();
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
                  ),
                  //******************       password         ************** */
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
