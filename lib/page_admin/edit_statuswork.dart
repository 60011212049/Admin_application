import 'dart:convert';
import 'dart:io';

import 'package:adminapp/custom_icons.dart';
import 'package:adminapp/model/busdriver_model.dart';
import 'package:adminapp/model/busstop_model.dart';
import 'package:adminapp/model/statuswork_model.dart';
import 'package:adminapp/service/service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class EditStatusWork extends StatefulWidget {
  StatusWorkModel dat = StatusWorkModel();
  EditStatusWork(StatusWorkModel data) {
    this.dat = data;
  }

  @override
  _EditStatusWorkState createState() => _EditStatusWorkState(this.dat);
}

class _EditStatusWorkState extends State<EditStatusWork> {
  var status = {};
  String id;
  List<BusdriverModel> busdriverList = List<BusdriverModel>();
  List<BusstopModel> busstop = List<BusstopModel>();
  var _nameIdcontroller = TextEditingController();
  var _dateIncontroller = TextEditingController();
  var _dateOutcontroller = TextEditingController();
  var _incontroller = TextEditingController();
  var _outcontroller = TextEditingController();
  TimeOfDay _time = TimeOfDay.now();
  String _selectedTpye, selectIn, selectOut;
  bool show = true;
  bool userB = false, passB = false, nameB = false;
  DateTime _dataTime = DateTime.now();
  TimeOfDay _timeNow = TimeOfDay.now();
  DateTime _dataTime2 = DateTime.now();
  TimeOfDay _timeNow2 = TimeOfDay.now();

  _EditStatusWorkState(StatusWorkModel dat) {
    this.id = dat.idStwork;
    _nameIdcontroller.text = dat.did;
    _dataTime = dat.inDate;
    _dataTime2 = dat.outDate;
    _timeNow = TimeOfDay.fromDateTime(dat.inDate);
    _timeNow2 = TimeOfDay.fromDateTime(dat.outDate);
    _selectedTpye = dat.did;
    selectIn = dat.inSid;
    selectOut = dat.outSid;
    _incontroller.text = dat.inSid;
    _outcontroller.text = dat.outSid;
    _dateIncontroller.text = _dataTime.year.toString() +
        '-' +
        _dataTime.month.toString() +
        '-' +
        _dataTime.day.toString() +
        ' ' +
        _timeNow.hour.toString() +
        ':' +
        _timeNow.minute.toString();
    _dateOutcontroller.text = _dataTime2.year.toString() +
        '-' +
        _dataTime2.month.toString() +
        '-' +
        _dataTime2.day.toString() +
        ' ' +
        _timeNow2.hour.toString() +
        ':' +
        _timeNow2.minute.toString() +
        ':00';
  }

  @override
  void initState() {
    super.initState();
    getDataDriver();
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
    setState(() {});
    return null;
  }

  Future<Null> getDataDriver() async {
    status['status'] = 'show';
    status['id'] = '';
    String jsonSt = json.encode(status);
    var response = await http.post(
        'http://' + Service.ip + '/controlModel/busdriver_model.php',
        body: jsonSt,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    List jsonData = json.decode(response.body);
    busdriverList = jsonData.map((i) => BusdriverModel.fromJson(i)).toList();
    setState(() {});
  }

  Future<Null> addTransciption() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    status['status'] = 'add';
    status['aid'] = pref.getInt('tokenId');
    status['type'] = 'แก้ไขสถานะเข้าออกงานคนขับ ' + _nameIdcontroller.text;
    status['time'] = DateTime.now().toString();
    String jsonSt = json.encode(status);
    var response = await http.post(
        'http://' + Service.ip + '/controlModel/transcription_model.php',
        body: jsonSt,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
  }

  Future<Null> _sentDataStatusWork() async {
    var status = {};
    status['status'] = 'update';
    status['timeIn'] = _dateIncontroller.text;
    status['timeOut'] = _dateOutcontroller.text;
    status['sidIn'] = _incontroller.text;
    status['sidOut'] = _outcontroller.text;
    status['did'] = _nameIdcontroller.text;
    status['id'] = this.id;
    String jsonSt = json.encode(status);
    print(jsonSt);
    var response = await http.post(
        'http://' + Service.ip + '/controlModel/statuswork_model.php',
        body: jsonSt,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    print(response.statusCode.toString() + ' ' + response.body.toString());
    if (response.statusCode == 200) {
      if (response.body.toString() == 'Bad') {
        setState(() {
          Toast.show("ไม่สามารถแก้ไขข้อมูลได้", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        });
      } else {
        Toast.show("แก้ไขข้อมูลสำเร็จ", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
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
        'เพิ่มสถานะเข้าออกงาน',
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
                    rowText('เลือกคนขับรถ'),
                    dropdownDriver(),
                    rowText('เลือกเวลาเข้างาน'),
                    dateTimePicker(context),
                    rowText('เลือกเวลาออกงาน'),
                    dateTimePicker2(context),
                    rowText('เลือกจุดรับส่งที่เริ่มรถ'),
                    dropdownBusstop(),
                    rowText('เลือกจุดรับส่งที่หยุดรถ'),
                    dropdownBusstop2(),
                    SizedBox(
                      height: 10.0,
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
                            fontSize: 27.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Quark',
                          ),
                        ),
                        onPressed: () async {
                          // print(id);
                          if (_incontroller.text.isEmpty) {
                            userB = true;
                          }
                          if (_outcontroller.text.isEmpty) {
                            passB = true;
                          }
                          if (_nameIdcontroller.text.isEmpty) {
                            nameB = true;
                          }
                          if (userB == false &&
                              passB == false &&
                              nameB == false) {
                            _sentDataStatusWork();
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
              );
            },
          ),
        ),
      ),
    );
  }

  Padding dateTimePicker(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
      child: Container(
        width: ScreenUtil().setWidth(700),
        height: ScreenUtil().setHeight(170),
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
              if (value != null) {
                if (value != null) {
                  _dataTime = value;
                }
                showTimePicker(
                  context: context,
                  initialTime: _timeNow,
                ).then((value) {
                  if (value != null) {
                    _timeNow = value;
                  }
                  setState(() {});
                });
                _dateIncontroller.text = _dataTime.year.toString() +
                    '-' +
                    _dataTime.month.toString() +
                    '-' +
                    _dataTime.day.toString() +
                    ' ' +
                    _timeNow.hour.toString() +
                    ':' +
                    _timeNow.minute.toString() +
                    ':00';
              } else {}
              _dateIncontroller.text = _dataTime.year.toString() +
                  '-' +
                  _dataTime.month.toString() +
                  '-' +
                  _dataTime.day.toString() +
                  ' ' +
                  _timeNow.hour.toString() +
                  ':' +
                  _timeNow.minute.toString() +
                  ':00';
            });

            print(_dateIncontroller.text);
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
                              _dataTime.year.toString() +
                              '    ' +
                              _timeNow.hour.toString() +
                              ':' +
                              _timeNow.minute.toString(),
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
    );
  }

  Padding dateTimePicker2(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
      child: Container(
        width: ScreenUtil().setWidth(700),
        height: ScreenUtil().setHeight(170),
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
              initialDate: _dataTime2,
              firstDate: DateTime(1950),
              lastDate: DateTime(2030),
            ).then((value) {
              if (value != null) {
                if (value != null) {
                  _dataTime2 = value;
                }
                showTimePicker(
                  context: context,
                  initialTime: _timeNow2,
                ).then((value) {
                  if (value != null) {
                    _timeNow2 = value;
                  }
                  _dateOutcontroller.text = _dataTime2.year.toString() +
                      '-' +
                      _dataTime2.month.toString() +
                      '-' +
                      _dataTime2.day.toString() +
                      ' ' +
                      _timeNow2.hour.toString() +
                      ':' +
                      _timeNow2.minute.toString() +
                      ':00';
                  print(_dateOutcontroller.text);
                  setState(() {});
                });
              } else {}
              _dateOutcontroller.text = _dataTime2.year.toString() +
                  '-' +
                  _dataTime2.month.toString() +
                  '-' +
                  _dataTime2.day.toString() +
                  ' ' +
                  _timeNow2.hour.toString() +
                  ':' +
                  _timeNow2.minute.toString() +
                  ':00';
            });

            print(_dateOutcontroller.text);
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
                          _dataTime2.day.toString() +
                              '/' +
                              _dataTime2.month.toString() +
                              '/' +
                              _dataTime2.year.toString() +
                              '    ' +
                              _timeNow2.hour.toString() +
                              ':' +
                              _timeNow2.minute.toString(),
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
    );
  }

  Container dropdownDriver() {
    return Container(
      height: 50,
      width: 250,
      child: DropdownButton(
        isExpanded: true,
        hint: Text(
          'กรุณาเลือกผู้ใช้งาน',
          style: TextStyle(fontSize: 20),
        ), // Not necessary for Option 1
        value: _selectedTpye,
        onChanged: (newValue) {
          setState(() {
            _selectedTpye = newValue;
          });
        },
        items: busdriverList.map((item) {
          return DropdownMenuItem(
            child: new Text(
              item.dName,
              style: TextStyle(fontSize: 20),
            ),
            value: item.did,
            onTap: () {
              _nameIdcontroller.text = item.did;
              print(_nameIdcontroller.text);
            },
          );
        }).toList(),
      ),
    );
  }

  Container dropdownBusstop() {
    return Container(
      height: 50,
      width: 330,
      child: DropdownButton(
        isExpanded: true,
        hint: Text(
          'กรุณาเลือกจุดเริ่มรถ',
          style: TextStyle(fontSize: 20),
        ), // Not necessary for Option 1
        value: selectIn,
        onChanged: (newValue) {
          setState(() {
            selectIn = newValue;
          });
        },
        items: busstop.map((item) {
          return DropdownMenuItem(
            child: new Text(
              item.sName,
              style: TextStyle(fontSize: 20),
            ),
            value: item.sid,
            onTap: () {
              _incontroller.text = item.sid;
              print(_incontroller.text);
            },
          );
        }).toList(),
      ),
    );
  }

  Container dropdownBusstop2() {
    return Container(
      height: 50,
      width: 330,
      child: DropdownButton(
        isExpanded: true,
        hint: Text(
          'กรุณาเลือกจุดหยุดรถ',
          style: TextStyle(fontSize: 20),
        ), // Not necessary for Option 1
        value: selectOut,
        onChanged: (newValue) {
          setState(() {
            selectOut = newValue;
          });
        },
        items: busstop.map((item) {
          return DropdownMenuItem(
            child: new Text(
              item.sName,
              style: TextStyle(fontSize: 20),
            ),
            value: item.sid,
            onTap: () {
              _incontroller.text = item.sid;
              print(_incontroller.text);
            },
          );
        }).toList(),
      ),
    );
  }

  Padding rowText(String s) {
    return Padding(
      padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            s,
            style: TextStyle(fontSize: 24),
          ),
        ],
      ),
    );
  }
}
