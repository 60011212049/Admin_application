import 'dart:convert';
import 'dart:io';

import 'package:adminapp/custom_icons.dart';
import 'package:adminapp/model/busstop_model.dart';
import 'package:adminapp/service/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;

import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class AddBusstop extends StatefulWidget {
  @override
  _AddBusstopState createState() => _AddBusstopState();
}

class _AddBusstopState extends State<AddBusstop> {
  var status = {};
  var _namecontroller = TextEditingController();
  var _imagecontroller = TextEditingController();
  var _latitudecontroller = TextEditingController();
  var _longitudecontroller = TextEditingController();

  List<BusstopModel> busstop = List<BusstopModel>();
  Location location = Location();
  LocationData locatNow;
  File image;
  var bit;
  bool nameB = false, latB = false, lngB = false;
  String _selectedTpye;
  String idbus;
  List<String> listName = ['ก่อนจุดแรก'];

  @override
  void initState() {
    super.initState();
    getBusstop();
  }

  Future<Null> getBusstop() async {
    status['status'] = 'show';
    status['id'] = '';
    String jsonSt = json.encode(status);
    var response = await http.post(
        'http://' + Service.ip + '/controlModel/busstop_model.php',
        body: jsonSt,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    List jsonData = json.decode(response.body);
    busstop = jsonData.map((i) => BusstopModel.fromJson(i)).toList();
    busstop.forEach((element) {
      listName.add(element.sName);
    });
    print(listName.length);
    setState(() {});
    return null;
  }

  Future<Null> addTransciption() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    status['status'] = 'add';
    status['aid'] = pref.getInt('tokenId');
    status['type'] = 'เพิ่มข้อมูลจุดรับส่ง ' + _namecontroller.text;
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
        Toast.show("ไม่สามารถเพิ่มรูปภาพได้", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        return null;
      } else {
        var res = await _sentDataBusstop();
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      return responseData;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> editIdDataBusstop(String str, String id) async {
    status.clear();
    status['status'] = 'editId';
    status['id_ch'] = str;
    status['id'] = id;
    String jsonSt = json.encode(status);
    print(jsonSt);
    var response = await http.post(
        'http://' + Service.ip + '/controlModel/busstop_model.php',
        body: jsonSt,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
  }

  Future<void> _sentDataBusstop() async {
    status['status'] = 'add';
    status['id_ch'] = (int.parse(this.idbus) + 1).toString();
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
        Toast.show("ไม่สามารถเพิ่มข้อมูลได้", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else {
        Toast.show("เพิ่มข้อมูลสำเร็จ", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        addTransciption();
        bit = '';
        //Navigator.pop(context);
      }
    } else {
      setState(() {
        Toast.show("ไม่สามารถเพิ่มข้อมูลได้", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      });
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Container(
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(35, 0, 30, 0),
                    child: Text(
                      'จากจุด',
                      style: TextStyle(fontSize: ScreenUtil().setSp(60)),
                    ),
                  ),
                  drowdownStart(),

                  //******************       username         ************** */
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                    child: Column(
                      children: <Widget>[
                        nameBusstop(),
                        SizedBox(
                          height: ScreenUtil().setSp(30),
                        ),
                        latField(),
                        SizedBox(
                          height: ScreenUtil().setSp(30),
                        ),
                        longField(),
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
                                latB = false;
                                lngB = false;
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
                              if (_namecontroller.text.isEmpty) {
                                nameB = true;
                              }
                              if (_latitudecontroller.text.isEmpty) {
                                latB = true;
                              }
                              if (_longitudecontroller.text.isEmpty) {
                                lngB = true;
                              }
                              if (nameB == false &&
                                  latB == false &&
                                  lngB == false) {
                                try {
                                  if (image == null) {
                                    await _sentDataBusstop();
                                    if (idbus == '0') {
                                      print('bus after one');
                                      for (var i = 0; i < busstop.length; i++) {
                                        await editIdDataBusstop(
                                            (int.parse(busstop[i].idCheck) + 1)
                                                .toString(),
                                            busstop[i].sid);
                                        print(busstop[i].sid +
                                            ' : ' +
                                            (int.parse(busstop[i].idCheck) + 1)
                                                .toString());
                                      }
                                      Navigator.pop(context);
                                    } else {
                                      print('bus before one');
                                      for (var i = 0; i < busstop.length; i++) {
                                        if (i + 1 > int.parse(this.idbus)) {
                                          await editIdDataBusstop(
                                              (int.parse(busstop[i].idCheck) +
                                                      1)
                                                  .toString(),
                                              busstop[i].sid);
                                          print(busstop[i].sid +
                                              ' : ' +
                                              (int.parse(busstop[i].idCheck) +
                                                      1)
                                                  .toString());
                                        }
                                      }
                                      Navigator.pop(context);
                                    }
                                  } else {
                                    final Map<String, dynamic> response =
                                        await _uploadImage();
                                  }
                                } catch (e) {}
                              } else {
                                Toast.show("กรุณากรอกข้อมูลให้ครบ", context,
                                    duration: Toast.LENGTH_LONG,
                                    gravity: Toast.BOTTOM);
                                setState(() {});
                              }
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

  Padding drowdownStart() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
      child: Container(
        height: 60,
        width: ScreenUtil().setWidth(900),
        child: Padding(
          padding: const EdgeInsets.only(left: 0, right: 0, bottom: 4, top: 5),
          child: Container(
            height: 55,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                color: Color(0xFFF2F2F2)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                iconEnabledColor: Color(0xFF595959),
                items: listName.map((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    onTap: () {
                      print(value);
                      setState(() {});
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: Wrap(
                        children: [
                          value == 'ก่อนจุดแรก'
                              ? Text(
                                  value,
                                  style: TextStyle(fontSize: 17),
                                )
                              : Text(
                                  'หลัง' + value,
                                  style: TextStyle(fontSize: 17),
                                ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
                hint: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Text(
                    'กรุณาเลือกตำแหน่งที่ต้องการเพิ่ม',
                    style: TextStyle(color: Color(0xFF8B8B8B), fontSize: 17),
                  ),
                ), // setting hint
                onChanged: (String value) {
                  setState(() {
                    if (value != 'ก่อนจุดแรก') {
                      this.idbus = busstop
                          .firstWhere((element) => element.sName == value)
                          .idCheck;
                      print(this.idbus);
                    } else {
                      this.idbus = '0';
                    }
                    _selectedTpye = value; // saving the selected value
                  });
                },
                value: _selectedTpye, // displaying the selected value
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextField longField() {
    return TextField(
      style: TextStyle(
        fontSize: 22.0,
        height: 1.0,
      ),
      onChanged: (value) {
        if (value.isNotEmpty) {
          lngB = false;
        }
        setState(() {});
      },
      decoration: InputDecoration(
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 2,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        errorStyle: TextStyle(fontSize: 16),
        errorText: lngB == true ? 'กรุณากรอกลองจิจูด' : null,
        labelText: 'ลองจิจูด',
        filled: true,
        fillColor: Colors.white,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: ScreenUtil().setSp(50),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        prefixIcon: Icon(Icons.pin_drop),
      ),
      controller: _longitudecontroller,
    );
  }

  TextField latField() {
    return TextField(
      style: TextStyle(
        fontSize: 22.0,
        height: 1.0,
      ),
      onChanged: (value) {
        if (value.isNotEmpty) {
          latB = false;
        }
        setState(() {});
      },
      decoration: InputDecoration(
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 2,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        errorStyle: TextStyle(fontSize: 16),
        errorText: latB == true ? 'กรุณากรอกละติจูด' : null,
        labelText: 'ละติจูด',
        filled: true,
        fillColor: Colors.white,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: ScreenUtil().setSp(50),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        prefixIcon: Icon(Icons.pin_drop),
      ),
      controller: _latitudecontroller,
    );
  }

  TextField nameBusstop() {
    return TextField(
      style: TextStyle(fontSize: 22.0, height: 1.0),
      onChanged: (value) {
        if (value.isNotEmpty) {
          nameB = false;
        }
        setState(() {});
      },
      decoration: InputDecoration(
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 2,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        errorStyle: TextStyle(fontSize: 16),
        errorText: nameB == true ? 'กรุณากรอกชื่อจุดรับส่ง' : null,
        labelText: 'ชื่อจุดรับส่ง',
        filled: true,
        fillColor: Colors.white,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 22.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        prefixIcon: Icon(Icons1.pin_1),
      ),
      controller: _namecontroller,
    );
  }
}
