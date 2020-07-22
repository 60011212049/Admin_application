import 'dart:convert';
import 'dart:io';

import 'package:adminapp/custom_icons.dart';
import 'package:adminapp/service/service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:toast/toast.dart';

class AddUser extends StatefulWidget {
  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  var status = {};
  bool _isLoading = true;
  var _usernamecontroller = TextEditingController();
  var _passwordcontroller = TextEditingController();
  var _emailcontroller = TextEditingController();
  var _namecontroller = TextEditingController();
  var _imagecontroller = TextEditingController();
  File image;
  var bit;
  bool show = true;

  @override
  void initState() {
    super.initState();
  }

  Future<Map<String, dynamic>> _uploadImage(File image) async {
    setState(() {
      _isLoading = true;
    });
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
        return null;
      } else {
        var res = await _sentDataMember();
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      setState(() {
        _isLoading = false;
      });
      return responseData;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Null> _sentDataMember() async {
    status['status'] = 'add';
    status['name'] = _namecontroller.text;
    status['username'] = _usernamecontroller.text;
    status['password'] = _passwordcontroller.text;
    status['email'] = _emailcontroller.text;
    if (bit == null) {
      status['image'] = _imagecontroller.text;
    } else {
      status['image'] = bit;
    }
    String jsonSt = json.encode(status);
    print(jsonSt);
    var response = await http.post(
        'http://' + Service.ip + '/controlModel/member_model.php',
        body: jsonSt,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    print(response.statusCode.toString() + ' ' + response.body.toString());
    if (response.statusCode == 200) {
      if (response.body.toString() == 'Bad') {
        setState(() {
          Toast.show("ชื่อผู้ใช้ไม่สามารถใช้งานได้", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        });
      } else if (response.body.toString() == 'Good') {
        Toast.show("เพิ่มข้อมูลสำเร็จ", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.pop(context);
        bit = '';
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
        'เพิ่มข้อมูลผู้ใช้',
        textScaleFactor: 1.2,
        style: TextStyle(color: Color(0xFF3a3a3a)),
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
                                          maxWidth: 300,
                                          maxHeight: 200,
                                        ),
                                        child: Image.file(
                                          image,
                                          fit: BoxFit.fitWidth,
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
                                  hintText: 'ชื่อ นามสุล',
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
                            )),
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
                            )),
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
                            )),
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
                                  _sentDataMember();
                                } else {
                                  final Map<String, dynamic> response =
                                      await _uploadImage(image);
                                  print(response);
                                }
                              } catch (e) {}
                            },
                          ),
                        ),
                      ],
                    ),
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
