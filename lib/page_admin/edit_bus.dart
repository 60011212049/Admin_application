import 'dart:convert';
import 'dart:io';

import 'package:adminapp/model/bus_model.dart';
import 'package:flutter/material.dart';
import 'package:adminapp/service/service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class EditBus extends StatefulWidget {
  String idbus;
  EditBus(String cid) {
    this.idbus = cid;
  }

  @override
  _EditBusState createState() => _EditBusState(idbus);
}

class _EditBusState extends State<EditBus> {
  List<BusModel> listBus = List<BusModel>();
  var status = {};
  TextEditingController namecontroller = TextEditingController();
  TextEditingController statuscontroller = TextEditingController();
  bool loadData = false;

  _EditBusState(String idbus) {
    getDataBus(idbus);
  }

  @override
  void initState() {
    super.initState();
  }

  Future<Null> getDataBus(String idbus) async {
    status['status'] = 'showId';
    status['id'] = idbus;
    String jsonSt = json.encode(status);
    print(jsonSt);
    var response = await http.post(
        'http://' + Service.ip + '/controlModel/bus_model.php',
        body: jsonSt,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    List jsonData = json.decode(response.body);
    print(response.body);
    listBus = jsonData.map((i) => BusModel.fromJson(i)).toList();
    namecontroller.text = listBus[0].cid;
    if (listBus[0].cStatus == '1') {
      statuscontroller.text = 'พร้อมใช้งาน';
    } else if (listBus[0].cStatus == '0') {
      statuscontroller.text = 'ไม่พร้อมใช้งาน';
    }

    setState(() {
      loadData = true;
    });
    return null;
  }

  Future<Null> updateDataBus() async {
    status['status'] = 'edit';
    status['cid'] = namecontroller.text;
    if (statuscontroller.text == 'พร้อมใช้งาน') {
      status['statusbus'] = '1';
    } else if (statuscontroller.text == 'ไม่พร้อมใช้งาน') {
      status['statusbus'] = '0';
    }
    String jsonSt = json.encode(status);
    var response = await http.post(
        'http://' + Service.ip + '/controlModel/bus_model.php',
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
          'แก้ไขข้อมูลรถ',
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
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'ข้อมูลรถ',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: ScreenUtil().setSp(80),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                  child: Container(
                    child: TextField(
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(55),
                      ),
                      decoration: InputDecoration(
                        labelText: 'ชื่่อรหัสรถราง',
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'ชื่อรถ',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: ScreenUtil().setSp(55),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        prefixIcon: Icon(Icons.assignment_turned_in),
                      ),
                      controller: namecontroller,
                      readOnly: true,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                  child: Container(
                    child: TextField(
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(55),
                      ),
                      decoration: InputDecoration(
                        labelText: 'สถานะรถราง',
                        filled: true,
                        fillColor: Colors.white,
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: ScreenUtil().setSp(55),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        prefixIcon: Icon(Icons.assignment_turned_in),
                      ),
                      controller: statuscontroller,
                      readOnly: true,
                      onTap: _askUser,
                    ),
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(12),
                ),
                ButtonTheme(
                  minWidth: 250.0,
                  height: ScreenUtil().setHeight(160),
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
                    onPressed: () {
                      updateDataBus();
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

  String value = '';

  void _setValue(String value) {
    setState(() {
      if (value == 'on') {
        statuscontroller.text = 'พร้อมใช้งาน';
      } else if (value == 'off') {
        statuscontroller.text = 'ไม่พร้อมใช้งาน';
      }
    });
  }

  Future _askUser() async {
    switch (await showDialog(
        context: context,
        child: new SimpleDialog(
          title: new Text(
            'เลือกสถานะรถราง',
            style: TextStyle(fontSize: ScreenUtil().setSp(70)),
          ),
          children: <Widget>[
            SimpleDialogOption(
              child: textSize('พร้อมใช้งาน'),
              onPressed: () {
                Navigator.pop(context, '1');
              },
            ),
            SimpleDialogOption(
              child: textSize('ไม่พร้อมใช้งาน'),
              onPressed: () {
                Navigator.pop(context, '2');
              },
            ),
          ],
        ))) {
      case '1':
        _setValue('on');
        break;
      case '2':
        _setValue('off');
        break;
    }
  }

  Text textSize(String tex) {
    return Text(
      tex,
      style: TextStyle(fontSize: ScreenUtil().setSp(50)),
    );
  }
}
