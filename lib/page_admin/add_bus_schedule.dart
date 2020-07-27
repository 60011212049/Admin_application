import 'dart:convert';
import 'dart:io';

import 'package:adminapp/custom_icons.dart';
import 'package:adminapp/model/bus_model.dart';
import 'package:adminapp/service/service.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class AddBusSchedule extends StatefulWidget {
  @override
  _AddBusScheduleState createState() => _AddBusScheduleState();
}

class _AddBusScheduleState extends State<AddBusSchedule> {
  var status = {};
  TimeOfDay _time = TimeOfDay.now();
  TextEditingController timecontroller = TextEditingController();
  TextEditingController buscontroller = TextEditingController();
  List<BusModel> listBus = List<BusModel>();

  @override
  void initState() {
    super.initState();
    getDataBus();
  }

  void onTimeChanged(TimeOfDay newTime) {
    setState(() {
      _time = newTime;
    });
  }

  Future sentDataBusSchedule() async {
    status['status'] = 'add';
    status['time'] =
        _time.hour.toString() + ':' + _time.minute.toString() + ':00';
    status['bus'] = buscontroller.text;
    status['date'] = DateTime.now().toString();
    String jsonSt = json.encode(status);
    print(jsonSt);
    var response = await http.post(
        'http://' + Service.ip + '/controlModel/busschedule_model.php',
        body: jsonSt,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    if (response.statusCode == 200) {
      if (response.body.toString() == 'Bad') {
        setState(() {
          Toast.show("ไม่สามารถเพิ่มข้อมูลได้", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        });
      } else {
        Toast.show("เพิ่มข้อมูลสำเร็จ", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.pop(context);
      }
    } else {
      setState(() {
        Toast.show("ไม่สามารถเพิ่มข้อมูลได้", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      });
    }
  }

  Future getDataBus() async {
    status['status'] = 'show';
    String jsonSt = json.encode(status);
    print(jsonSt);
    var response = await http.post(
        'http://' + Service.ip + '/controlModel/bus_model.php',
        body: jsonSt,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    List jsonData = json.decode(response.body);
    listBus = jsonData.map((i) => BusModel.fromJson(i)).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'เพิ่มตารางการเดินรถ',
          style: TextStyle(
            color: Color(0xFF3a3a3a),
            fontSize: ScreenUtil().setSp(60),
          ),
        ),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'เวลา',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(80),
                        ),
                      ),
                    ],
                  ),
                ),
                Wrap(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                      child: Container(
                        width: ScreenUtil().setWidth(500),
                        height: ScreenUtil().setHeight(170),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey[600],
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.0),
                          ),
                          color: Colors.white,
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              showPicker(
                                context: context,
                                value: _time,
                                onChange: onTimeChanged,
                                is24HrFormat: true,
                              ),
                            );
                          },
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _time.format(context),
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(80),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'รหัสรถราง',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(80),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                  child: Wrap(
                    children: <Widget>[
                      Container(
                        height: ScreenUtil().setHeight(180),
                        width: ScreenUtil().setWidth(600),
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
                            showBus();
                          },
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 11),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons1.directions_bus,
                                    color: Colors.grey[500],
                                  ),
                                  Container(
                                    width: 12,
                                  ),
                                  Text(
                                    'รถราง ' + buscontroller.text,
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 22.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setSp(30),
                ),
                ButtonTheme(
                  minWidth: ScreenUtil().setWidth(660),
                  height: ScreenUtil().setHeight(155),
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
                      sentDataBusSchedule();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _setValue(String value) {
    setState(() {
      buscontroller.text = value;
    });
  }

  Future showBus() async {
    switch (await showDialog(
      context: context,
      child: new SimpleDialog(
        title: new Text(
          'กรุณาเลือกรถราง',
          style: TextStyle(
            fontSize: ScreenUtil().setSp(70),
          ),
        ),
        children: listBus.map((value) {
          return SimpleDialogOption(
            child: Text(
              'รถราง ' + value.cid,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(50),
              ),
            ),
            onPressed: () {
              print('press');
              _setValue(value.cid);
              Navigator.pop(context);
            },
          );
        }).toList(),
        elevation: 5,
      ),
    )) {
    }
  }

  Text textSize(String tex) => new Text(
        tex,
        style: TextStyle(fontSize: 16),
      );
}
