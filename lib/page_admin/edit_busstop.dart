import 'dart:convert';
import 'dart:io';

import 'package:adminapp/custom_icons.dart';
import 'package:adminapp/model/busstop_model.dart';
import 'package:adminapp/service/service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
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
  BusstopModel busstop;

  _EditBusstopState(BusstopModel x) {
    this.busstop = x;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      setText();
    });
  }

  void setText() {
    _namecontroller.text = busstop.sName;
    _latitudecontroller.text = busstop.sLatitude;
    _longitudecontroller.text = busstop.sLongitude;
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
    var response = await http.post(
        'http://' + Service.ip + '/controlModel/busstop_model.php',
        body: jsonSt,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    if (response.statusCode == 200) {
      if (response.body.toString() == 'Bad') {
        setState(() {
          Toast.show("ไม่แก้ไขข้อมูลได้", context,
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
        'แก้ไขข้อมูลจุดรับส่ง',
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
                                                  '/controlModel/images/member/' +
                                                  busstop.sImage,
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
                                hintText: 'ชื่อจุดรับส่ง',
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
                              "ยืนยันการแก้ไขข้อมูล",
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
